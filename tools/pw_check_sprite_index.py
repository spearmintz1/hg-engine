#!/usr/bin/env python3

# Host-side check that GrabPokewalkerMonSpriteIndex never returns an index past the end of the pokewalker sprite narc (a256).
# Compiles src/field/pokewalker.c for the host against the real form tables, calls it for every species, form (0-31) and gender,
# and compares each result with the narc member count.  Also checks that the icon narc (a248, indexed by species) covers every species.
# Run from the repository root; exits 1 on any out-of-range index.
#
#   tools/pw_check_sprite_index.py                         member counts from build/narc/pw_*.narc if built, else from data/graphics/pokewalker
#   tools/pw_check_sprite_index.py --source FILE --count N [--icon-count N]  check another copy of pokewalker.c against a given member count

import argparse
import glob
import os
import struct
import subprocess
import sys
import tempfile

SPRITE_NARC = "build/narc/pw_pokegra.narc"
ICON_NARC = "build/narc/pw_pokeicon.narc"
SPRITE_DIR = "data/graphics/pokewalker/sprites"
ICON_DIR = "data/graphics/pokewalker/icons"

HARNESS = r'''
#include "%(source)s"
#include "%(root)s/data/PokeFormDataTbl.c"
#include "%(root)s/data/FormToSpeciesMapping.c"
int printf(const char *, ...); // not <stdio.h>: the game headers declare their own sprintf

// same lookups as src/pokemon.c, against the tables that become a028 members 11 and 12
// (the tables end at the last species that has a form, a species past their end has no forms)
u16 GetSpeciesBasedOnForm(int mons_no, int form_no)
{
    if (form_no != 0 && (u32)mons_no < sizeof(PokeFormDataTbl) / sizeof(PokeFormDataTbl[0]))
    {
        u16 newSpecies = PokeFormDataTbl[mons_no][form_no - 1] & ~(NEEDS_REVERSION);
        if (newSpecies != 0)
            mons_no = newSpecies;
    }
    return mons_no;
}

u16 GetBaseSpeciesFromAdjustedForm(u32 mons_no)
{
    if (mons_no > MAX_MON_NUM && mons_no - SPECIES_MEGA_START < sizeof(FormToSpeciesMapping) / sizeof(FormToSpeciesMapping[0]))
        mons_no = FormToSpeciesMapping[mons_no - SPECIES_MEGA_START];
    return mons_no;
}

int main(void)
{
    for (u32 species = 0; species <= MAX_SPECIES_INCLUDING_FORMS; species++)
        for (u32 form = 0; form < 32; form++)
            for (u32 isFemale = 0; isFemale < 2; isFemale++)
                printf("%%u %%u %%u %%u\n", species, form, isFemale, GrabPokewalkerMonSpriteIndex(species, isFemale, form));
    printf("max %%u\n", MAX_SPECIES_INCLUDING_FORMS);
    return 0;
}
'''


def NarcMemberCount(path):
    with open(path, "rb") as f:
        header = f.read(28)
    if header[:4] != b"NARC" or header[16:20] != b"BTAF":
        sys.exit(f"{path} is not a NARC")
    return struct.unpack_from("<H", header, 24)[0]


def MemberCount(narc, source_dir):
    if os.path.isfile(narc):
        return NarcMemberCount(narc), narc
    return len(glob.glob(f"{source_dir}/*.png")), f"{source_dir}/*.png (narc not built)"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", default="src/field/pokewalker.c", help="pokewalker.c to check")
    parser.add_argument("--count", type=int, help="sprite narc member count (default: the built narc, else the sprite directory)")
    parser.add_argument("--icon-count", type=int, help="icon narc member count (default: the built narc, else the icon directory)")
    args = parser.parse_args()
    root = os.getcwd()

    if args.count is not None:
        sprite_count, sprite_from = args.count, "--count"
    else:
        sprite_count, sprite_from = MemberCount(SPRITE_NARC, SPRITE_DIR)
    if args.icon_count is not None:
        icon_count, icon_from = args.icon_count, "--icon-count"
    else:
        icon_count, icon_from = MemberCount(ICON_NARC, ICON_DIR)

    with tempfile.TemporaryDirectory() as tmp:
        harness = os.path.join(tmp, "harness.c")
        with open(harness, "w") as f:
            f.write(HARNESS % {"source": os.path.abspath(args.source), "root": root})
        exe = os.path.join(tmp, "harness")
        subprocess.run(["gcc", "-std=gnu11", "-w", f"-DPOKEWALKER_SPRITE_COUNT={sprite_count}", f"-I{root}", harness, "-o", exe], check=True)
        out = subprocess.run([exe], check=True, capture_output=True, text=True).stdout.split("\n")

    max_species = int(out[-2].split()[1])
    names = {}
    with open("include/constants/species.h") as f:
        for line in f:
            parts = line.split()
            if len(parts) == 3 and parts[0] == "#define" and parts[1].startswith("SPECIES_") and parts[2].isdigit():
                names.setdefault(int(parts[2]), parts[1])

    calls = out[:-2]
    bad = [tuple(map(int, line.split())) for line in calls if int(line.split()[3]) >= sprite_count]
    print(f"sprite narc members: {sprite_count} ({sprite_from})")
    print(f"checked {len(calls)} (species, form, gender) combinations, species 0-{max_species}")
    print(f"out-of-range sprite indices: {len(bad)} across {len({b[0] for b in bad})} species")
    first = {}
    for species, form, female, index in bad:
        first.setdefault(species, (form, female, index))
    for species in sorted(first)[:15]:
        form, female, index = first[species]
        print(f"  {names.get(species, species)} (first bad: form {form} female {female}) -> index {index} >= {sprite_count}")
    if len(first) > 15:
        print(f"  ... and {len(first) - 15} more species")

    missing_icons = max_species + 1 - icon_count
    print(f"icon narc members: {icon_count} ({icon_from}), species 0-{max_species} need {max_species + 1}: " + ("OK" if missing_icons <= 0 else f"{missing_icons} species have no icon"))

    if bad or missing_icons > 0:
        print("FAIL")
        sys.exit(1)
    print("PASS")
