#!/usr/bin/env python3
"""Resolve and validate every mart in the built ROM (default: test.nds).

Follows the special mart pointer table at 0x0210FA3C in arm9 into the field extension overlay, checks that each list terminates
inside its own symbol (no overrun into a neighbour), has no duplicates and only valid item ids, and that the table matches
the `repoints` file.  The general mart (src/field/mart.c sBadgeMart) is read from the same overlay and resolved for a few
badge/game-clear states.  Exits 1 on any failure.

usage: scripts/check_marts.py [rom.nds]
"""
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

ARM9_BASE = 0x02000000
TABLE_ADDR = 0x0210FA3C
NUM_MARTS = 30
HOOK_ADDR = 0x02048060
MART_UI_MAX_ITEMS = 254  # Mart_Init asserts count < 0xFF
TERMINATOR = 0xFFFF
NM = "arm-none-eabi-nm"

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def load_item_names():
    defs = {}
    for line in (ROOT / "include/constants/item.h").read_text().splitlines():
        m = re.match(r"#define\s+(ITEM_\w+)\s+(.*?)\s*(//.*)?$", line)
        if m:
            defs[m.group(1)] = m.group(2)
    values = {}
    for _ in range(10):
        for name, expr in defs.items():
            if name in values:
                continue
            for ref in re.findall(r"ITEM_\w+", expr):
                if ref in values:
                    expr = expr.replace(ref, str(values[ref]))
            try:
                values[name] = eval(expr, {"__builtins__": {}})
            except Exception:
                pass
    names = {}
    for name, value in values.items():
        if name == "ITEM_NONE" or value in names:
            continue
        names[value] = name[len("ITEM_"):]
    return names


def extract(rom, out):
    """Unpack arm9, the overlay table and the overlay files with the repo's own ndstool."""
    subprocess.run(
        [str(ROOT / "tools/ndstool"), "-x", str(rom), "-9", str(out / "arm9.bin"), "-y9", str(out / "y9.bin"),
         "-y", str(out / "overlay")],
        check=True, stdout=subprocess.DEVNULL)


def load_arm9(out):
    data = (out / "arm9.bin").read_bytes()
    # the table must sit inside the image; a compressed arm9 would make the pointers meaningless
    if len(data) < TABLE_ADDR - ARM9_BASE + 4 * NUM_MARTS:
        fail("arm9.bin is too small to hold the mart pointer table")
    return data


def load_field_extension(out):
    """(ram address, bytes) of the field extension overlay, where src/field/*.c lands.

    Other overlays share its address range (the battle extension overlaps it), so it is looked up by id.
    """
    file_h = (ROOT / "include/constants/file.h").read_text()
    ovl_id = int(re.search(r"#define OVERLAY_FIELD_EXTENSION\s+(\d+)", file_h).group(1))
    y9 = (out / "y9.bin").read_bytes()
    _id, ram, _size, _bss, _s, _e, file_id, comp = struct.unpack_from("<8I", y9, ovl_id * 0x20)
    if comp >> 24:
        sys.exit(f"overlay {ovl_id} is compressed; this checker only reads the uncompressed synthetic overlay")
    return ram, (out / "overlay" / f"overlay_{file_id:04}.bin").read_bytes()


def read_u16s_until_terminator(read, addr):
    items = []
    while len(items) <= MART_UI_MAX_ITEMS + 1:
        value = struct.unpack("<H", read(addr + 2 * len(items), 2))[0]
        if value == TERMINATOR:
            return items, True
        items.append(value)
    return items, False


def nm_symbols():
    """{symbol: (address, size)} for the linked field overlay, all symbol types."""
    path = ROOT / "build/field_linked.o"
    out = subprocess.check_output([NM, "-S", str(path)]).decode()
    symbols = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) == 4:
            symbols[parts[3]] = (int(parts[0], 16), int(parts[1], 16))
    return symbols


def repoint_symbols():
    """{table index: symbol} from the MART_EXPANSION block of repoints."""
    mapping = {}
    for line in (ROOT / "repoints").read_text().splitlines():
        parts = line.split()
        if len(parts) == 3 and parts[0] == "arm9":
            addr = int(parts[2], 16)
            if TABLE_ADDR <= addr < TABLE_ADDR + 4 * NUM_MARTS:
                mapping[(addr - TABLE_ADDR) // 4] = parts[1]
    return mapping


def fmt(ids, names):
    return ", ".join(names.get(i, f"?{i}") for i in ids)


def check_list(label, items, names, size_bytes=None):
    if len(items) == 0:
        fail(f"{label}: empty list")
    if len(items) > MART_UI_MAX_ITEMS:
        fail(f"{label}: {len(items)} items exceeds the mart UI limit of {MART_UI_MAX_ITEMS}")
    dupes = sorted({str(names.get(i, i)) for i in items if items.count(i) > 1})
    if dupes:
        fail(f"{label}: duplicate items {dupes}")
    bad = [i for i in items if i not in names]
    if bad:
        fail(f"{label}: invalid item ids {bad}")
    if size_bytes is not None and size_bytes != 2 * (len(items) + 1):
        fail(f"{label}: terminator ends the list at {2 * (len(items) + 1)} bytes but the symbol is {size_bytes} bytes")


def resolve_general(read, addr, size, names):
    entry = 4
    if size % entry:
        fail(f"sBadgeMart size {size} is not a multiple of {entry}")
    entries = [struct.unpack("<HBB", read(addr + i * entry, entry)) for i in range(size // entry)]
    check_list("general mart (all entries)", [e[0] for e in entries], names)
    for item, badges, clear in entries:
        if badges > 16 or clear > 1:
            fail(f"general mart entry {names.get(item, item)}: badges {badges} / clear {clear} out of range")
    print(f"general mart: {len(entries)} entries at {addr:#010x}  (item: badges needed, [post-game])")
    for item, badges, clear in entries:
        print(f"    {names.get(item, item):22} {badges:2}{'  post-game' if clear else ''}")
    for badges, clear in ((0, False), (3, False), (8, False), (8, True), (16, True)):
        shown = [i for i, b, c in entries if badges >= b and (clear or not c)]
        print(f"  with {badges:2} badges{', game cleared' if clear else '':14}: {len(shown)} items")
    shown_full = [i for i, b, c in entries if 16 >= b]
    print(f"  16 badges, game cleared: {fmt(shown_full, names)}")
    return entries


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "test.nds"
    if not rom.exists():
        sys.exit(f"{rom} not found; run make first")
    names = load_item_names()
    symbols = nm_symbols()
    repoints = repoint_symbols()

    with tempfile.TemporaryDirectory(prefix="check_marts_") as tmp:
        out = Path(tmp)
        extract(rom, out)
        arm9 = load_arm9(out)
        ext_ram, ext = load_field_extension(out)

        def read(addr, n):
            if ARM9_BASE <= addr < ARM9_BASE + len(arm9):
                return arm9[addr - ARM9_BASE:addr - ARM9_BASE + n]
            if ext_ram <= addr and addr + n <= ext_ram + len(ext):
                return ext[addr - ext_ram:addr - ext_ram + n]
            raise KeyError(f"address {addr:#010x} is in neither arm9 nor the field extension overlay")

        # the hook that replaces ScrCmd_MartBuy: ldr r1, [pc, #0]; bx r1; .word <thumb address of ScrCmd_MartBuy>
        hook = read(HOOK_ADDR, 8)
        target = struct.unpack_from("<I", hook, 4)[0]
        if hook[:4] != bytes([0x00, 0x49, 0x08, 0x47]) or "ScrCmd_MartBuy" not in symbols \
                or target != symbols["ScrCmd_MartBuy"][0] | 1:
            fail(f"ScrCmd_MartBuy hook at {HOOK_ADDR:#010x} is not in place ({hook.hex()})")
        else:
            print(f"ScrCmd_MartBuy hook at {HOOK_ADDR:#010x} -> {target:#010x}")

        if "sBadgeMart" not in symbols:
            fail("sBadgeMart not found in build/field_linked.o")
        else:
            addr, size = symbols["sBadgeMart"]
            resolve_general(read, addr, size, names)

        print()
        for mart_id in range(NUM_MARTS):
            ptr = struct.unpack("<I", read(TABLE_ADDR + 4 * mart_id, 4))[0]
            label = f"special mart {mart_id}"
            sym = repoints.get(mart_id)
            if sym is None or sym not in symbols:
                fail(f"{label}: no repoints entry / symbol")
                continue
            sym_addr, sym_size = symbols[sym]
            if ptr != sym_addr:
                fail(f"{label}: table points to {ptr:#010x} but {sym} is at {sym_addr:#010x}")
            if ptr & 1:
                fail(f"{label}: pointer {ptr:#010x} has the thumb bit set")
            items, terminated = read_u16s_until_terminator(read, ptr)
            if not terminated:
                fail(f"{label}: list at {ptr:#010x} does not terminate")
            check_list(label, items, names, sym_size)
            print(f"{mart_id:2} {ptr:#010x} {sym} ({len(items)} items)\n     {fmt(items, names)}")

    print()
    if failures:
        print(f"{len(failures)} check(s) FAILED")
        sys.exit(1)
    print(f"OK: general mart and all {NUM_MARTS} special marts terminate, have no duplicates and only valid item ids")


if __name__ == "__main__":
    main()
