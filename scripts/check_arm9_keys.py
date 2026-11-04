#!/usr/bin/env python3
"""Fail the build if a return-address key in src/ no longer matches the built arm9.

MonTryLearnMoveOnLevelUp tells its callers apart by its own return address (`register u32 retAddr asm("lr")`).  Each
key is only meaningful while the call site it names is the vanilla `bl MonTryLearnMoveOnLevelUp`; a hook that moves or
rewrites those bytes silently turns the caller's filter into a no-op.

usage: check_arm9_keys.py [arm9.bin]    (default: base/arm9.bin, the image armips patched)
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ARM9_BASE = 0x02000000

# (call site, the vanilla thumb `bl 0x02071534` as stored in the image, the function that makes the call)
CALL_SITES = [
    (0x020764E6, bytes.fromhex("fbf725f8"), "the evolution callback"),
    (0x02081CFE, bytes.fromhex("eff719fc"), "PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop"),
]


def main() -> int:
    arm9 = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "base/arm9.bin"
    image = arm9.read_bytes()
    source = (ROOT / "src/pokemon.c").read_text()
    failed = False
    for site, expected, caller in CALL_SITES:
        offset = site - ARM9_BASE
        found = image[offset:offset + 4]
        if found != expected:
            print(f"FAIL: {caller} no longer calls MonTryLearnMoveOnLevelUp at {site:#010x} "
                  f"(expected {expected.hex()}, found {found.hex()}); its retAddr key is dead", file=sys.stderr)
            failed = True
        key = f"{site + 4 + 1:#010x}"  # the return address of a 4-byte Thumb bl, with the Thumb bit
        if not re.search(rf"retAddr == {key}\b", source, re.IGNORECASE):
            print(f"FAIL: src/pokemon.c has no `retAddr == {key}` for {caller}", file=sys.stderr)
            failed = True
    if not failed:
        print(f"check_arm9_keys: {len(CALL_SITES)} return-address key(s) match {arm9}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
