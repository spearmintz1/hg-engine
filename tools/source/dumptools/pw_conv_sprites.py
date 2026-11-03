#!/usr/bin/env python3

# Regenerates the Pokewalker sprites and icons from this repository's own battle sprites and party icons.
# Run from the repository root.  Output names follow the narc member order that GrabPokewalkerMonSpriteIndex expects:
#   sprites: 0001-0493 for species 1-493, 7_<species> for species 544 and up (the 6_ gender/form sprites are not touched)
#   icons:   <species> for every species
# By default only species 544 and up are converted (the original Pokewalker art for species 1-493 is kept); pass --all to convert those too.

import argparse
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

FIRST_NEW_SPECIES = 544  # SPECIES_VICTINI
LAST_OLD_SPECIES = 493  # SPECIES_ARCEUS
TOOLS_DIR = "tools/source/dumptools"


def GrabSpeciesDict(speciesDict: dict):
    speciesEntry = 0
    with open("include/constants/species.h") as f:
        for line in f:
            if len(line.split()) > 1:
                test = line.split()[1].strip()
                if 'SPECIES' in test and not '_START' in test and not '_SPECIES_H' in test and not '_NUM (' in line and (not 'MAX_' in test or 'GIGANTAMAX' in test):
                    speciesDict[speciesEntry] = test
                    speciesEntry += 1


def ConvertSpecies(args):
    species, name = args
    base_name = name[len("SPECIES_"):].lower()
    sprite_dir = f"data/graphics/sprites/{base_name}"
    input_name = f"{sprite_dir}/male/front.png"
    if not os.path.isfile(input_name) or os.path.getsize(input_name) == 0:  # female-only species have an empty male placeholder
        input_name = f"{sprite_dir}/female/front.png"
    output_name = f"{'7_' if species > LAST_OLD_SPECIES else ''}{species:04}"
    subprocess.run([f"{TOOLS_DIR}/pw_conv_sprite.sh", input_name, f"data/graphics/pokewalker/sprites/{output_name}.png"], check=True, capture_output=True, text=True)
    subprocess.run([f"{TOOLS_DIR}/pw_conv_icon.sh", f"{sprite_dir}/icon.png", f"data/graphics/pokewalker/icons/{species:04}.png"], check=True, capture_output=True, text=True)
    return species


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--all", action="store_true", help=f"also convert species 1-{LAST_OLD_SPECIES}")
    parser.add_argument("--jobs", type=int, default=3, help="parallel conversions (default 3)")
    args = parser.parse_args()

    SpeciesDict = {}
    GrabSpeciesDict(SpeciesDict)
    # the species list is numbered by counting #defines; make sure that still matches the real numbering
    if SpeciesDict.get(FIRST_NEW_SPECIES) != "SPECIES_VICTINI":
        sys.exit("species.h numbering does not match: SPECIES_VICTINI is not entry 544")

    # nothing to be done for species 0 and the egg/placeholder/form-slot range LAST_OLD_SPECIES+1..FIRST_NEW_SPECIES-1
    todo = [(i, SpeciesDict[i]) for i in sorted(SpeciesDict) if i >= FIRST_NEW_SPECIES or (args.all and 0 < i <= LAST_OLD_SPECIES)]
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        for species in pool.map(ConvertSpecies, todo):
            pass
    print(f"converted {len(todo)} species")
