"""Fail the build if a script's apply_movement points at movement data on an odd address.

The DS ARM9 reads the 16-bit action and count halfwords of a movement script directly from the script file, and a
misaligned halfword read returns rotated garbage: the scripted walk never finishes and `wait_movement` hangs forever.
armips lays a script file out byte for byte, so any odd-sized edit above an unaligned movement block silently moves the
whole block onto an odd address.  The fix is an `.align 4` before the block (see scr_seq_00003_commonscript.s).
Only odd targets are fatal: vanilla scripts keep blocks at 2 mod 4 and run fine, so a 4-alignment check would reject the
release ROM.

Scans every member of the script NARC (a/0/1/2) for `apply_movement` (opcode 0x005E, u16 npc, s32 offset relative to
the end of the command) and checks the target.  Commands are not decoded, so every byte offset is tried; a candidate
counts only if its target walks as movement data (u16 action, u16 count pairs) to the 0x00FE terminator in the file.

usage: check_movement_align.py NARC_OR_ROM...      (a .nds is searched for a/0/1/2)
"""
import struct
import sys

SCRIPT_NARC_PATH = "a/0/1/2"
APPLY_MOVEMENT = 0x005E
MOVEMENT_END = 0x00FE
MAX_MOVEMENT_ACTION = 0x00FF  # every real action id is below the terminator; garbage rarely stays under it


def rom_file(rom: bytes, wanted: str) -> bytes:
    fnt_off, _, fat_off, _ = struct.unpack_from("<IIII", rom, 0x40)

    def walk(dir_id: int, path: str):
        sub, first_id, _ = struct.unpack_from("<IHH", rom, fnt_off + (dir_id & 0xFFF) * 8)
        pos, file_id = fnt_off + sub, first_id
        while rom[pos]:
            length = rom[pos] & 0x7F
            is_dir = rom[pos] & 0x80
            name = rom[pos + 1 : pos + 1 + length].decode()
            pos += 1 + length
            if is_dir:
                yield from walk(struct.unpack_from("<H", rom, pos)[0], path + name + "/")
                pos += 2
            else:
                start, end = struct.unpack_from("<II", rom, fat_off + file_id * 8)
                yield path + name, rom[start:end]
                file_id += 1

    for path, data in walk(0xF000, ""):
        if path == wanted:
            return data
    raise SystemExit(f"check_movement_align: {wanted} not found in ROM")


def narc_members(narc: bytes):
    if narc[:4] != b"NARC":
        raise SystemExit("check_movement_align: not a NARC")
    pos = 0x10
    assert narc[pos : pos + 4] == b"BTAF"
    size, count = struct.unpack_from("<IH", narc, pos + 4)
    entries = [struct.unpack_from("<II", narc, pos + 12 + 8 * i) for i in range(count)]
    pos += size
    pos += struct.unpack_from("<I", narc, pos + 4)[0]  # BTNF
    assert narc[pos : pos + 4] == b"GMIF"
    base = pos + 8
    return [narc[base + start : base + end] for start, end in entries]


def walks_to_terminator(member: bytes, target: int) -> bool:
    while target + 4 <= len(member):
        action, _ = struct.unpack_from("<HH", member, target)
        if action == MOVEMENT_END:
            return True
        if action > MAX_MOVEMENT_ACTION:
            return False
        target += 4
    return False


def misaligned_targets(member: bytes):
    """Yield (command offset, target offset) for every apply_movement whose target is on an odd address."""
    needle = struct.pack("<H", APPLY_MOVEMENT)
    pos = member.find(needle)
    while pos != -1:
        if pos + 8 <= len(member):
            target = pos + 8 + struct.unpack_from("<i", member, pos + 4)[0]
            if 0 <= target < len(member) and target % 2 and walks_to_terminator(member, target):
                yield pos, target
        pos = member.find(needle, pos + 1)


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    failed = False
    for path in sys.argv[1:]:
        data = open(path, "rb").read()
        narc = data if data[:4] == b"NARC" else rom_file(data, SCRIPT_NARC_PATH)
        for index, member in enumerate(narc_members(narc)):
            bad = list(misaligned_targets(member))
            if not bad:
                continue
            failed = True
            targets = sorted({target for _, target in bad})
            print(
                f"{path}: script {index}: {len(bad)} apply_movement command(s) target {len(targets)} movement block(s) "
                f"at an odd offset (first at 0x{targets[0]:X}); add `.align 4` before the movement data",
                file=sys.stderr,
            )
    if failed:
        print("check_movement_align: failed (movement data on an odd address makes the ARM9 hang on wait_movement)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
