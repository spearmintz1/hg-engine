"""Fail if a built trainer cell bank in a/0/5/8 has a corrupt VRAM transfer table.

Each trainer owns five consecutive members: 5k+0 NCGR (cell graphics), 5k+1 NCLR,
5k+2 NCER (cell bank), 5k+3 NANR, 5k+4 NCGR (battle pic).  The game copies the
(offset, size) entries of the NCER's VRAM transfer table out of member 5k+0 while
animating, so one entry outside that graphic reads past it and freezes the battle.

usage: python3 scripts/check_trainer_cells.py [path/to/a/0/5/8]
"""
import struct
import sys

import ndspy.narc

MEMBERS_PER_TRAINER = 5
KBEC_BLOCK = 0x10  # the cell bank block follows the 0x10 byte NCER header
RAHC_BLOCK = 0x10  # likewise for the character block of the NCGR


def check_cells(ncgr, ncer):
    if ncer[KBEC_BLOCK:KBEC_BLOCK + 4] != b"KBEC" or ncgr[RAHC_BLOCK:RAHC_BLOCK + 4] != b"RAHC":
        return ["not an NCER/NCGR pair"]

    block_size, cell_count = struct.unpack_from("<IH", ncer, KBEC_BLOCK + 4)
    transfer_offset = struct.unpack_from("<I", ncer, KBEC_BLOCK + 0x14)[0]
    if transfer_offset == 0:
        return []  # the bank has no VRAM transfer table

    graphics_size = struct.unpack_from("<I", ncgr, RAHC_BLOCK + 0x18)[0]
    table = KBEC_BLOCK + 8 + transfer_offset
    block_end = min(KBEC_BLOCK + block_size, len(ncer))
    if table + 8 > block_end:
        return [f"transfer table at {table:#x} lies outside the {block_size:#x} byte cell block"]

    max_size, entries_offset = struct.unpack_from("<II", ncer, table)
    entries = table + entries_offset
    if entries + 8 * cell_count > block_end:
        return [f"transfer entries at {entries:#x} do not fit the {block_size:#x} byte cell block (max size {max_size:#x})"]

    errors = []
    if max_size > graphics_size:
        errors.append(f"max size {max_size:#x} exceeds the {graphics_size:#x} byte graphic")
    for cell in range(cell_count):
        offset, size = struct.unpack_from("<II", ncer, entries + 8 * cell)
        if size > max_size or offset + size > graphics_size:
            errors.append(f"cell {cell}: offset {offset:#x} size {size:#x} outside {graphics_size:#x} byte graphic (max {max_size:#x})")
    return errors


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "base/root/a/0/5/8"
    files = ndspy.narc.NARC.fromFile(path).files
    if len(files) % MEMBERS_PER_TRAINER:
        sys.exit(f"{path}: {len(files)} members is not a multiple of {MEMBERS_PER_TRAINER}")

    failed = 0
    for trainer in range(len(files) // MEMBERS_PER_TRAINER):
        first = trainer * MEMBERS_PER_TRAINER
        for error in check_cells(files[first], files[first + 2]):
            print(f"trainer class {trainer} (member {first + 2}): {error}")
            failed += 1

    if failed:
        sys.exit(f"{path}: {failed} bad VRAM transfer entries")
    print(f"{path}: all {len(files) // MEMBERS_PER_TRAINER} trainer cell banks have in-range VRAM transfers")


if __name__ == "__main__":
    main()
