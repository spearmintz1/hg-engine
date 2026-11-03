#!/usr/bin/env python3
"""Host check for MonTryLearnMoveOnLevelUp's learnset scan.

Extracts the real function text from src/pokemon.c (or `git show <ref>:src/pokemon.c` with --ref), compiles it
on the host against stubs, and drives it over every build/a033/learnset_* at every level 1-100, both
levelling up and evolving. After the END marker the learnset buffer is poisoned with entries that match the
level being scanned, so a scan that runs past END returns garbage. A species fails when the scan leaves
last_i past the END index, returns a move the learnset does not hold, or disagrees with an independent oracle.

    scripts/check_learnset_scan.py              # the working tree
    scripts/check_learnset_scan.py --ref HEAD   # an older revision, for A/B
"""
import argparse
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

HARNESS = r"""
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef int s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NULL ((void *)0)
#define HEAPID_DEFAULT 0
#define MON_DATA_SPECIES 0
#define MON_DATA_FORM 1
#define MON_DATA_LEVEL 2
#define LEARNSET_TOTAL_MOVES @TOTAL_MOVES@
@LEARNSET_DEFINES@

#define ARENA_WORDS 4096
struct PartyPokemon { int unused; };

static u32 g_arena[ARENA_WORDS];
static u32 g_file[LEARNSET_TOTAL_MOVES + 8];
static u32 g_fileWords;
static u32 g_level;
static int g_evolving;
static int g_poisonKind;

static u32 GetMonData(struct PartyPokemon *mon, int field, void *unused) {
    (void)mon; (void)unused;
    if (field == MON_DATA_LEVEL) return g_level;
    return 0;
}
static void *sys_AllocMemory(int heap, u32 size) {
    (void)heap; (void)size;
    return g_arena;
}
static void sys_FreeMemoryEz(void *p) { (void)p; }
static void LoadLevelUpLearnset_HandleAlternateForm(u32 species, int form, u32 *out) {
    (void)species; (void)form;
    memcpy(out, g_file, g_fileWords * sizeof(u32));
    for (u32 i = g_fileWords; i < ARENA_WORDS; i++) {
        if (g_poisonKind == 0)
            out[i] = (g_level << 16) | (0x1000 + i); // always matches the level being scanned
        else
            out[i] = ((i % 101) << 16) | (0x1000 + i); // every level appears within 101 words
    }
}
static u32 TryAppendMonMove(struct PartyPokemon *mon, u16 move) { (void)mon; return move; }

@FUNCTION@

static struct PartyPokemon g_mon;

int main(int argc, char **argv) {
    // usage: harness <learnset file> ; prints one line per failing (level, evolving, poison) and a final summary
    FILE *f = fopen(argv[1], "rb");
    if (!f) return 2;
    g_fileWords = fread(g_file, sizeof(u32), LEARNSET_TOTAL_MOVES + 8, f);
    fclose(f);
    int endIdx = -1;
    for (u32 i = 0; i < g_fileWords; i++)
        if (g_file[i] == LEVEL_UP_LEARNSET_END) { endIdx = (int)i; break; }
    if (endIdx < 0) { printf("NOEND\n"); return 2; }

    int failures = 0, pastEnd = 0;
    for (g_poisonKind = 0; g_poisonKind < 2; g_poisonKind++)
    for (g_evolving = 0; g_evolving < 2; g_evolving++)
    for (g_level = 1; g_level <= 100; g_level++) {
        // oracle: the moves the scan must hand out, in order
        u32 want[LEARNSET_TOTAL_MOVES * 2]; int nWant = 0;
        if (g_evolving)
            for (int i = 0; i < endIdx; i++)
                if (LEVEL_UP_LEARNSET_LEVEL(g_file[i]) == 0) want[nWant++] = LEVEL_UP_LEARNSET_MOVE(g_file[i]);
        for (int i = 0; i < endIdx; i++) {
            u32 lv = LEVEL_UP_LEARNSET_LEVEL(g_file[i]);
            if (lv != g_level) continue;
            int dup = 0;
            if (g_evolving)
                for (int j = 0; j < endIdx; j++)
                    if (LEVEL_UP_LEARNSET_LEVEL(g_file[j]) == 0 && LEVEL_UP_LEARNSET_MOVE(g_file[j]) == LEVEL_UP_LEARNSET_MOVE(g_file[i])) dup = 1;
            if (!dup) want[nWant++] = LEVEL_UP_LEARNSET_MOVE(g_file[i]);
        }

        int last_i = 0, got = 0, bad = 0, over = 0;
        u32 gotMoves[LEARNSET_TOTAL_MOVES * 2];
        for (int calls = 0; calls < 200; calls++) {
            u16 sp0 = 0;
            u32 ret = MonTryLearnMoveOnLevelUp(&g_mon, &last_i, &sp0);
            if (last_i > endIdx) bad = over = 1;
            if (ret == 0) break;
            if (got < LEARNSET_TOTAL_MOVES * 2) gotMoves[got] = sp0;
            got++;
            if (bad) break;
        }
        if (!bad && got != nWant) bad = 1;
        for (int k = 0; !bad && k < got; k++)
            if (gotMoves[k] != want[k]) bad = 1;
        if (bad) {
            if (failures < 3)
                printf("  lv%u %s poison%d: last_i=%d END@%d got %d moves, oracle %d\n", g_level,
                       g_evolving ? "evolving" : "levelup", g_poisonKind, last_i, endIdx, got, nWant);
            failures++;
            pastEnd += over;
        }
    }
    printf("FAILURES %d PASTEND %d\n", failures, pastEnd);
    return failures ? 1 : 0;
}
"""


def read_source(ref):
    if ref:
        return subprocess.run(["git", "show", f"{ref}:src/pokemon.c"], cwd=ROOT, check=True,
                              capture_output=True, text=True).stdout
    return (ROOT / "src/pokemon.c").read_text()


def extract_function(src):
    start = src.index("u32 MonTryLearnMoveOnLevelUp(")
    end = src.index("\n}\n", start) + 3
    body = src[start:end]
    body = re.sub(r'register u32 retAddr asm\("lr"\);', "", body)
    body, n = re.subn(r"retAddr == 0x[0-9A-Fa-f]+", "g_evolving", body)
    if n != 1:
        sys.exit("could not find the evolution return-address test in MonTryLearnMoveOnLevelUp")
    return body


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ref", help="git revision to take src/pokemon.c from (default: the working tree)")
    ap.add_argument("--dir", default=str(ROOT / "build/a033"), help="directory holding learnset_* files")
    args = ap.parse_args()

    learnsets = sorted(Path(args.dir).glob("learnset_*"))
    if not learnsets:
        sys.exit(f"no learnset_* files in {args.dir}; build the ROM first")

    header = (ROOT / "include/pokemon.h").read_text()
    defines = "\n".join(re.findall(r"^#define LEVEL_UP_LEARNSET_\w+.*$", header, re.M))
    total = re.search(r"#define LEARNSET_TOTAL_MOVES (\d+)", (ROOT / "include/config.h").read_text()).group(1)
    harness = (HARNESS.replace("@TOTAL_MOVES@", total).replace("@LEARNSET_DEFINES@", defines)
               .replace("@FUNCTION@", extract_function(read_source(args.ref))))

    with tempfile.TemporaryDirectory() as tmp:
        c_file, exe = Path(tmp) / "scan.c", Path(tmp) / "scan"
        c_file.write_text(harness)
        subprocess.run(["gcc", "-O0", "-g", "-w", "-o", str(exe), str(c_file)], check=True)

        failed, past_end = [], []
        for path in learnsets:
            run = subprocess.run([str(exe), str(path)], capture_output=True, text=True)
            if run.returncode != 0:
                failed.append((path.name, run.stdout.strip() or f"exit {run.returncode}"))
                if not re.search(r"PASTEND 0$", run.stdout.strip()):
                    past_end.append(path.name)

    print(f"source: {args.ref or 'working tree'}; {len(learnsets)} learnsets, levels 1-100, levelling up and evolving")
    for name, detail in failed:
        print(f"FAIL {name}\n{detail}")
    print(f"scan passed END (last_i beyond the marker): {len(past_end)} learnsets {[n.removeprefix('learnset_') for n in past_end]}")
    print(f"{'FAIL' if failed else 'PASS'}: {len(failed)} of {len(learnsets)} learnsets failed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
