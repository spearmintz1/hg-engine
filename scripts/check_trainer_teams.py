"""Check the boss teams, level changes and doubles of a built ROM against a base build.

Decodes the trainer data (a/0/5/5) and trainer party (a/0/5/6) NARCs of both ROMs and
fails unless, for every trainer whose bytes differ from the base build:
  * the party/header layout is self-consistent (flags match the fields present, no
    leftover bytes, nummons matches the party)
  * species and party size are unchanged, levels change only by the allowed deltas
  * a boss carries item + 4 moves + nature on every mon; every move is legal for that
    species at that level (level-up of the mon or a pre-evolution, TM/HM, tutor, egg
    move, per the repo learnset data); every item is a known id on the supported list
  * a non-boss differs from base only by its battle type
Every boss must be edited, and every boss must stay a single battle.

usage: python3 scripts/check_trainer_teams.py [--rom test.nds] [--base ../integration/test.nds]
"""
import argparse
import re
import struct
import sys
from pathlib import Path

import ndspy.narc
import ndspy.rom

ROOT = Path(__file__).resolve().parent.parent

TYPE_MOVES, TYPE_ITEMS, TYPE_ABILITY, TYPE_BALL = 0x01, 0x02, 0x04, 0x08
TYPE_IV_EV, TYPE_NATURE, TYPE_SHINY, TYPE_EXTRA = 0x10, 0x20, 0x40, 0x80
BOSS_FLAGS = TYPE_MOVES | TYPE_ITEMS | TYPE_NATURE
SINGLE, DOUBLE = 0, 2
HEADER_SIZE = 20

# first-run Elite Four: every mon is raised by this much
E4_LEVEL_DELTA = {245: 4, 246: 5, 247: 4, 418: 5}
E4_LEVEL_CAP = 54
# gym leader rematches: ace (last mon of the top level) at 75-80, the rest 2-5 below it
REMATCH_IDS = set(range(712, 728))
REMATCH_ACE = (75, 80)

SILVER = [1, 2, 3, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 285, 286, 287, 288, 289,
          489, 490, 491, 735, 736, 737]
BOSS_IDS = set(SILVER) | {
    20, 21, 30, 31, 32, 33, 34, 35,                  # Johto gyms
    253, 254, 255, 256, 257, 258, 259, 261,          # Kanto gyms (Blue included)
    260,                                             # Red
    244, 245, 246, 247, 418,                         # Lance + Elite Four
    675, 701, 702, 703, 704, 705, 733,               # Lance partner/rematch, E4 rematch
    478, 479, 485, 486, 487, 488, 706, 700,          # Rocket executives + Giovanni
    734,                                             # Clair (Dragon's Den)
} | REMATCH_IDS

SUPPORTED_ITEMS = """
ITEM_NONE ITEM_LEFTOVERS ITEM_FOCUS_SASH ITEM_LIFE_ORB ITEM_CHOICE_BAND ITEM_CHOICE_SPECS
ITEM_CHOICE_SCARF ITEM_EXPERT_BELT ITEM_MUSCLE_BAND ITEM_WISE_GLASSES ITEM_SHELL_BELL
ITEM_SCOPE_LENS ITEM_BLACK_SLUDGE ITEM_QUICK_CLAW ITEM_KINGS_ROCK ITEM_RAZOR_CLAW ITEM_LIGHT_BALL
ITEM_FLAME_ORB ITEM_TOXIC_ORB ITEM_WIDE_LENS ITEM_ZOOM_LENS ITEM_METRONOME ITEM_LAGGING_TAIL
ITEM_ORAN_BERRY ITEM_SITRUS_BERRY ITEM_LUM_BERRY ITEM_PERSIM_BERRY ITEM_CHESTO_BERRY ITEM_LEPPA_BERRY
ITEM_SALAC_BERRY ITEM_LIECHI_BERRY ITEM_PETAYA_BERRY ITEM_GANLON_BERRY ITEM_APICOT_BERRY
ITEM_STARF_BERRY ITEM_CUSTAP_BERRY ITEM_LANSAT_BERRY ITEM_MICLE_BERRY
ITEM_OCCA_BERRY ITEM_PASSHO_BERRY ITEM_WACAN_BERRY ITEM_RINDO_BERRY ITEM_YACHE_BERRY ITEM_CHOPLE_BERRY
ITEM_KEBIA_BERRY ITEM_SHUCA_BERRY ITEM_COBA_BERRY ITEM_PAYAPA_BERRY ITEM_TANGA_BERRY ITEM_CHARTI_BERRY
ITEM_KASIB_BERRY ITEM_HABAN_BERRY ITEM_COLBUR_BERRY ITEM_BABIRI_BERRY ITEM_CHILAN_BERRY
ITEM_SILK_SCARF ITEM_BLACK_BELT ITEM_SHARP_BEAK ITEM_POISON_BARB ITEM_SOFT_SAND ITEM_HARD_STONE
ITEM_SILVER_POWDER ITEM_SPELL_TAG ITEM_METAL_COAT ITEM_CHARCOAL ITEM_MYSTIC_WATER ITEM_MIRACLE_SEED
ITEM_MAGNET ITEM_TWISTED_SPOON ITEM_NEVER_MELT_ICE ITEM_DRAGON_FANG ITEM_BLACK_GLASSES
ITEM_THICK_CLUB ITEM_LUCKY_PUNCH ITEM_LEEK ITEM_METAL_POWDER ITEM_QUICK_POWDER
ITEM_DEEP_SEA_TOOTH ITEM_DEEP_SEA_SCALE ITEM_SOUL_DEW ITEM_ADAMANT_ORB ITEM_LUSTROUS_ORB
ITEM_ASSAULT_VEST ITEM_ROCKY_HELMET ITEM_GRISEOUS_ORB ITEM_MENTAL_HERB ITEM_WHITE_HERB ITEM_POWER_HERB ITEM_FOCUS_BAND
""".split()


# ---------------------------------------------------------------- constants and learnsets

def read_defines(inc, prefix):
    """Reads `.equ NAME, expr` lines of asm/include/<inc>.inc, the ids armips builds with.

    Expressions are arithmetic over other names (form ranges); they are resolved to a fixpoint.
    """
    pending = {}
    for line in (ROOT / "asm/include" / (inc + ".inc")).read_text().splitlines():
        m = re.match(r"\.equ\s+(\w+),\s*([^/]+?)\s*(?://.*)?$", line)
        if m:
            pending[m.group(1)] = m.group(2)
    values = {}
    while pending:
        progressed = False
        for name, expr in list(pending.items()):
            if re.fullmatch(r"[\w\s()+\-*]+", expr):
                try:
                    values[name] = int(eval(expr, {"__builtins__": {}}, values))
                except NameError:
                    continue
                del pending[name]
                progressed = True
        if not progressed:
            break
    return {k: v for k, v in values.items() if k.startswith(prefix)}


class Learnsets:
    """Union of every legal source of moves per species id."""

    def __init__(self):
        self.species = read_defines("species", "SPECIES_")
        self.moves = read_defines("moves", "MOVE_")
        self.items = read_defines("items", "ITEM_")
        self.levelup = {}   # species -> [(move, level)]
        self.other = {}     # species -> {move} from TM/HM, tutor, egg
        self.preevo = {}    # species -> {pre-evolution species}
        self._load_levelup()
        self._load_evolutions()
        self._load_tm_tutor()
        self._load_egg()

    def _sid(self, name):
        return self.species[name]

    def _load_levelup(self):
        cur = None
        for line in (ROOT / "armips/data/levelupdata.s").read_text().splitlines():
            m = re.match(r"levelup (SPECIES_\w+)", line)
            if m:
                cur = self.levelup.setdefault(self._sid(m.group(1)), [])
                continue
            m = re.match(r"\s*learnset (MOVE_\w+),\s*(\d+)", line)
            if m and cur is not None:
                cur.append((self.moves[m.group(1)], int(m.group(2))))

    def _load_evolutions(self):
        cur = None
        for line in (ROOT / "armips/data/evodata.s").read_text().splitlines():
            m = re.match(r"evodata (SPECIES_\w+)", line)
            if m:
                cur = self._sid(m.group(1))
                continue
            m = re.match(r"\s*evolution \w+,\s*[^,]+,\s*(SPECIES_\w+)", line)
            if m and cur is not None and m.group(1) != "SPECIES_NONE":
                self.preevo.setdefault(self._sid(m.group(1)), set()).add(cur)

    def _load_tm_tutor(self):
        for fname, head in (("tmlearnset.txt", r"(?:TM|HM)\d+:\s*(MOVE_\w+)"),
                            ("tutordata.txt", r"TUTOR\w*:\s*(MOVE_\w+)")):
            move = None
            for line in (ROOT / "armips/data" / fname).read_text().splitlines():
                m = re.match(head, line)
                if m:
                    move = self.moves[m.group(1)]
                    continue
                m = re.match(r"\s*(SPECIES_\w+)\s*$", line)
                if m and move is not None and m.group(1) in self.species:
                    self.other.setdefault(self._sid(m.group(1)), set()).add(move)

    def _load_egg(self):
        cur = None
        for line in (ROOT / "armips/data/eggmoves.s").read_text().splitlines():
            m = re.match(r"eggmoveentry (SPECIES_\w+)", line)
            if m:
                cur = self.other.setdefault(self._sid(m.group(1)), set())
                continue
            m = re.match(r"\s*eggmove (MOVE_\w+)", line)
            if m and cur is not None:
                cur.add(self.moves[m.group(1)])

    def chain(self, species):
        seen, todo = set(), [species]
        while todo:
            s = todo.pop()
            if s not in seen:
                seen.add(s)
                todo.extend(self.preevo.get(s, ()))
        return seen

    def legal_moves(self, species, level):
        legal = set()
        for s in self.chain(species):
            legal |= {mv for mv, lv in self.levelup.get(s, ()) if lv <= level}
            legal |= self.other.get(s, set())
        return legal


# ---------------------------------------------------------------- trainer decoding

def decode_header(raw):
    if len(raw) != HEADER_SIZE:
        raise ValueError("trainer data is %d bytes, expected %d" % (len(raw), HEADER_SIZE))
    return {"flags": raw[0], "class": raw[1], "nummons": raw[3],
            "items": struct.unpack_from("<4H", raw, 4),
            "ai": struct.unpack_from("<I", raw, 12)[0], "battle": raw[16]}


def decode_party(raw, flags, nummons):
    """Returns the list of mons; raises ValueError if the bytes do not fit the flags."""
    if flags & TYPE_EXTRA:
        raise ValueError("additional-flags mons are not decoded by this checker")
    mons, off = [], 0

    def take(fmt):
        nonlocal off
        size = struct.calcsize(fmt)
        if off + size > len(raw):
            raise ValueError("party data ends inside mon %d" % len(mons))
        val = struct.unpack_from(fmt, raw, off)
        off += size
        return val

    for _ in range(nummons):
        mon = {}
        mon["ivs"], mon["abilityslot"], mon["level"], word = take("<BBHH")
        mon["species"], mon["form"] = word & 0x7FF, word >> 11
        mon["item"] = take("<H")[0] if flags & TYPE_ITEMS else None
        mon["moves"] = list(take("<4H")) if flags & TYPE_MOVES else None
        mon["ability"] = take("<H")[0] if flags & TYPE_ABILITY else None
        mon["ball"] = take("<H")[0] if flags & TYPE_BALL else None
        if flags & TYPE_IV_EV:
            take("<12B")
        mon["nature"] = take("<B")[0] if flags & TYPE_NATURE else None
        mon["shiny"] = take("<B")[0] if flags & TYPE_SHINY else None
        mon["ballseal"] = take("<H")[0]
        mons.append(mon)
    if off != len(raw):
        raise ValueError("%d leftover bytes after %d mons" % (len(raw) - off, nummons))
    return mons


def load_rom(path):
    rom = ndspy.rom.NintendoDSRom.fromFile(str(path))
    data = ndspy.narc.NARC(rom.getFileByName("a/0/5/5")).files
    party = ndspy.narc.NARC(rom.getFileByName("a/0/5/6")).files
    return data, party


# ---------------------------------------------------------------- allowed level changes

def expected_levels(tid, base_levels):
    """Returns a predicate-friendly description: list of allowed (lo, hi) per mon."""
    if tid in E4_LEVEL_DELTA:
        return [(min(lv + E4_LEVEL_DELTA[tid], E4_LEVEL_CAP),) * 2 for lv in base_levels]
    if tid in REMATCH_IDS:
        top = max(base_levels)
        ace = max(i for i, lv in enumerate(base_levels) if lv == top)
        out = []
        for i, lv in enumerate(base_levels):
            out.append(REMATCH_ACE if i == ace else (REMATCH_ACE[0] - 5, REMATCH_ACE[1] - 2))
        return out
    return [(lv, lv) for lv in base_levels]


# ---------------------------------------------------------------- main check

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", default=str(ROOT / "test.nds"))
    ap.add_argument("--base", default=str(ROOT.parent / "integration/test.nds"))
    args = ap.parse_args()

    ls = Learnsets()
    names = {v: k for k, v in ls.moves.items()}
    unknown = [n for n in SUPPORTED_ITEMS if n not in ls.items]
    if unknown:
        sys.exit("SUPPORTED_ITEMS has names missing from items.inc: %s" % unknown)
    allowed_items = {ls.items[n] for n in SUPPORTED_ITEMS}
    max_item = max(ls.items.values())
    max_species = max(ls.species.values())

    new_data, new_party = load_rom(args.rom)
    old_data, old_party = load_rom(args.base)
    errors = []

    def err(tid, msg):
        errors.append("trainer %d: %s" % (tid, msg))

    if len(new_data) != len(old_data) or len(new_party) != len(old_party):
        sys.exit("trainer NARC sizes differ: %d/%d vs %d/%d" %
                 (len(new_data), len(new_party), len(old_data), len(old_party)))

    edited, doubles, level_changes = [], [], []
    for tid in range(len(new_data)):
        if new_data[tid] == old_data[tid] and new_party[tid] == old_party[tid]:
            if tid in BOSS_IDS:
                err(tid, "boss is unedited")
            continue
        edited.append(tid)
        try:
            nh, oh = decode_header(new_data[tid]), decode_header(old_data[tid])
            old_mons = decode_party(old_party[tid], oh["flags"], oh["nummons"])
            new_mons = decode_party(new_party[tid], nh["flags"], nh["nummons"])
        except ValueError as e:
            err(tid, "undecodable: %s" % e)
            continue

        for key in ("class", "nummons", "items", "ai"):
            if nh[key] != oh[key]:
                err(tid, "header field %s changed %r -> %r" % (key, oh[key], nh[key]))
        for mon in new_mons:
            if mon["species"] == 0 or mon["species"] > max_species:
                err(tid, "bad species %d" % mon["species"])

        allowed = expected_levels(tid, [m["level"] for m in old_mons])
        for i, (o, n) in enumerate(zip(old_mons, new_mons)):
            if (o["species"], o["form"]) != (n["species"], n["form"]):
                err(tid, "mon %d species changed" % i)
            lo, hi = allowed[i]
            if not lo <= n["level"] <= hi:
                err(tid, "mon %d level %d -> %d, allowed %d-%d" % (i, o["level"], n["level"], lo, hi))
        if tid in REMATCH_IDS or tid in E4_LEVEL_DELTA:
            new_levels = [m["level"] for m in new_mons]
            if tid in REMATCH_IDS:
                top = max(new_levels)
                if new_levels.count(top) != 1 or new_levels.index(top) != allowed.index(REMATCH_ACE):
                    err(tid, "rematch ace is not the single top-level mon: %s" % new_levels)
            level_changes.append((tid, [m["level"] for m in old_mons], new_levels))

        if tid in BOSS_IDS:
            if nh["flags"] != BOSS_FLAGS:
                err(tid, "boss flags 0x%02X, expected 0x%02X" % (nh["flags"], BOSS_FLAGS))
            if nh["battle"] != SINGLE:
                err(tid, "boss battle type %d, expected single" % nh["battle"])
            for i, (o, n) in enumerate(zip(old_mons, new_mons)):
                where = "mon %d (species %d L%d)" % (i, n["species"], n["level"])
                if n["item"] is not None and n["item"] != o["item"] and n["item"] not in allowed_items:
                    err(tid, "%s item %s not on the supported list" % (where, n["item"]))
                if n["item"] is not None and not 0 <= n["item"] <= max_item:
                    err(tid, "%s item id %d invalid" % (where, n["item"]))
                if n["nature"] is None or n["nature"] > 24:
                    err(tid, "%s nature %r invalid" % (where, n["nature"]))
                mv = n["moves"] or []
                if len(mv) != 4 or 0 in mv or len(set(mv)) != 4:
                    err(tid, "%s moves not four distinct real moves: %s" % (where, mv))
                legal = ls.legal_moves(n["species"], n["level"])
                for m in mv:
                    if m not in legal:
                        err(tid, "%s cannot legally learn %s" % (where, names.get(m, m)))
        else:
            if nh["flags"] != oh["flags"] or new_party[tid] != old_party[tid]:
                err(tid, "non-boss party changed")
            if nh["battle"] == oh["battle"]:
                err(tid, "non-boss differs from base without a battle type change")
            elif nh["battle"] == DOUBLE and oh["battle"] == SINGLE:
                if nh["nummons"] < 2:
                    err(tid, "double battle with %d mon" % nh["nummons"])
                doubles.append(tid)
            else:
                err(tid, "battle type %d -> %d is not single -> double" % (oh["battle"], nh["battle"]))

    for tid in sorted(BOSS_IDS):
        if tid >= len(new_data):
            err(tid, "boss id out of range")

    print("edited trainers: %d (bosses %d, doubles %d)" % (
        len(edited), sum(t in BOSS_IDS for t in edited), len(doubles)))
    print("converted doubles:", doubles)
    if not 10 <= len(doubles) <= 15:
        errors.append("expected 10-15 converted doubles, found %d" % len(doubles))
    for tid, before, after in level_changes:
        print("levels %d: %s -> %s" % (tid, before, after))
    if errors:
        print("\n%d FAILURES" % len(errors))
        print("\n".join(errors))
        sys.exit(1)
    print("OK")


if __name__ == "__main__":
    main()
