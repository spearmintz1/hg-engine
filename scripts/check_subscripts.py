"""Fail the build if the numbered battle scripts and the constants that name them disagree.

The scripts in data/battle_scripts/subscripts and data/battle_scripts/effects are packed into their NARC in sorted
filename order, so the number in a filename has to be the file's position in that order.  The constants that the C code
and the other scripts use (BATTLE_SUBSCRIPT_*, SUB_SEQ_*, MOVE_EFFECT_*) have to carry the same number, and the
MAX_BASE_* constant has to be the number of the last base script.  Branches that each add scripts collide here when
merged, and a collision otherwise only shows up as the wrong script running in battle.

usage: check_subscripts.py [--root DIR]
"""
import argparse
import pathlib
import re
import sys

SCRIPT_NAME = re.compile(r"^(?P<prefix>subscript|effect_script)_(?P<number>\d{4})_(?P<name>\w+)\.s$")
INC_CONSTANT = re.compile(r"^\s*\.equ\s+(\w+)\s*,\s*(0x[0-9a-fA-F]+|\d+)\s*(?://.*)?$")
H_CONSTANT = re.compile(r"^\s*#define\s+(\w+)\s+\(?\s*(0x[0-9a-fA-F]+|\d+)\s*\)?\s*(?://.*)?$")

# constants named after a different script than the one their number selects (names inherited from the decompilation): pinned to their number
RENAMED = {"SUB_SEQ_RECHARGE_TURN": 65}  # script 65 is subscript_0065_RECHARGING, script 64 is subscript_0064_RECHARGE_TURN

# kind: (script folder, constant prefixes in the .inc, constant prefixes in the .h, MAX_BASE_* constant, the files holding the constants)
KINDS = {
    "subscripts": {
        "folder": "data/battle_scripts/subscripts",
        "inc": ("BATTLE_SUBSCRIPT_",),
        "h": ("SUB_SEQ_",),
        "max": "MAX_BASE_SUBSCRIPT_NUM",
        "inc_file": "asm/include/battle_constants.inc",
        "h_file": "include/constants/battle_script_constants.h",
    },
    "effects": {
        "folder": "data/battle_scripts/effects",
        "inc": ("MOVE_EFFECT_",),
        "h": ("MOVE_EFFECT_",),
        "max": "MAX_BASE_MOVE_EFFECT_NUM",
        "inc_file": "asm/include/move_effects.inc",
        "h_file": "include/constants/move_effects.h",
    },
}


def read_constants(path: pathlib.Path, pattern: re.Pattern) -> dict[str, list[int]]:
    """every integer constant in the file; a name defined twice keeps all its values so that a redefinition is visible"""
    constants: dict[str, list[int]] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        m = pattern.match(line)
        if m:
            constants.setdefault(m.group(1), []).append(int(m.group(2), 0))
    return constants


def check_scripts(root: pathlib.Path, kind: str, spec: dict) -> list[str]:
    errors = []
    folder = root / spec["folder"]
    # the NARC packs the base scripts, then the custom/ ones, each in sorted filename order
    files = sorted(folder.glob("*.s"))
    base_count = len(files)
    files += sorted((folder / "custom").glob("*.s"))

    numbered: dict[str, int] = {}  # script name -> number in its filename
    by_number: dict[int, list[str]] = {}
    for position, path in enumerate(files):
        m = SCRIPT_NAME.match(path.name)
        if not m:
            errors.append(f"{path.relative_to(root)}: not named like {SCRIPT_NAME.pattern}")
            continue
        number = int(m.group("number"))
        by_number.setdefault(number, []).append(path.name)
        numbered[m.group("name")] = number
        if number != position:
            errors.append(f"{path.relative_to(root)}: numbered {number} but it is script {position} in sorted order")

    for number, names in sorted(by_number.items()):
        if len(names) > 1:
            errors.append(f"{kind}: number {number} is shared by {', '.join(names)}")

    for file_key, pattern, prefixes in (("inc_file", INC_CONSTANT, spec["inc"]), ("h_file", H_CONSTANT, spec["h"])):
        path = root / spec[file_key]
        constants = read_constants(path, pattern)
        rel = path.relative_to(root)

        for name, values in constants.items():
            if name == spec["max"]:
                if len(values) > 1:
                    errors.append(f"{rel}: {name} is defined {len(values)} times ({', '.join(map(str, values))})")
                if base_count and values[-1] != base_count - 1:
                    errors.append(f"{rel}: {name} is {values[-1]} but the last base script is {base_count - 1}")
                continue
            prefix = next((p for p in prefixes if name.startswith(p)), None)
            if prefix is None:
                continue
            script = name[len(prefix):]
            if name in RENAMED:
                if values != [RENAMED[name]]:
                    errors.append(f"{rel}: {name} is {', '.join(map(str, values))} but is pinned to {RENAMED[name]}")
                continue
            if script not in numbered:
                continue  # an alias or a constant for something that is not a script of this kind
            if len(set(values)) > 1 or values[0] != numbered[script]:
                errors.append(f"{rel}: {name} is {', '.join(map(str, values))} but its script is numbered {numbered[script]}")

        if spec["max"] not in constants:
            errors.append(f"{rel}: {spec['max']} is not defined")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=pathlib.Path, default=pathlib.Path(__file__).resolve().parent.parent)
    args = parser.parse_args()

    errors = []
    for kind, spec in KINDS.items():
        errors += check_scripts(args.root, kind, spec)

    for error in errors:
        print(error, file=sys.stderr)
    if errors:
        print(f"check_subscripts: {len(errors)} problem(s); renumber the scripts and their constants together", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
