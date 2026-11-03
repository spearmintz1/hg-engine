"""Fail the build if a linked object contains a 32-bit Thumb instruction other than BL/BLX.

The DS ARM9 (ARMv5TE) has no Thumb-2.  Without an -march on the assembler, binutils happily assembles things like
`ldr r1, =0x2D68` into a Thumb-2 `movw`, which the CPU cannot execute.  BL and BLX are the only 32-bit Thumb
encodings ARMv5TE has (a pair of 16-bit halves), so any other 32-bit instruction is a bug.

usage: check_thumb2.py [--objdump PATH] LINKED_OBJECT...
"""
import argparse
import re
import subprocess
import sys

# "  23dd95a:\tf642 5168 \tmovw\tr1, #9576"
INSN = re.compile(r"^\s*([0-9a-f]+):\t((?:[0-9a-f]{4} )+)\t(\S+)")  # data dumps have no tab before their ascii column


def wide_thumb_instructions(objdump: str, path: str):
    out = subprocess.run([objdump, "-d", path], capture_output=True, text=True, check=True).stdout
    for line in out.splitlines():
        m = INSN.match(line)
        if not m:
            continue
        address, encoding, mnemonic = m.groups()
        if len(encoding.split()) != 2:
            continue  # a 16-bit instruction, or ARM-state/data words (their 8-digit hex is one token)
        if mnemonic.split(".")[0] in ("bl", "blx"):
            continue
        yield address, encoding.strip(), line.strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--objdump", default="arm-none-eabi-objdump")
    parser.add_argument("objects", nargs="+")
    args = parser.parse_args()

    failed = False
    for path in args.objects:
        for address, encoding, line in wide_thumb_instructions(args.objdump, path):
            failed = True
            print(f"{path}: 32-bit Thumb instruction at {address} ({encoding}) is not available on the ARM9: {line}", file=sys.stderr)
    if failed:
        print("check_thumb2: failed (is the assembler missing -march=armv5te?)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
