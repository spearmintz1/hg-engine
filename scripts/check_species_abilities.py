"""Fail if the built ROM's species data lacks an ability id the u16 port must carry.

Reads the personal data NARC (a/0/0/2: u16 ability slots at 0x16 and 0x1A) and the hidden ability table (a/0/2/8,
file 7: one u16 per species) out of the built ROM.  Every expected ability is one the old 8-bit mondata macro dropped
(id above 255 became ABILITY_NONE or a stand-in) or one whose species data was rewritten to its intended id.  Ids are
taken from the headers and cross-checked against the number recorded here.

usage: check_species_abilities.py [ROM]   (default: test.nds)
"""
import ndspy.narc
import ndspy.rom
import re
import struct
import sys

PERSONAL_NARC = "a/0/0/2"
HIDDEN_NARC = "a/0/2/8"
HIDDEN_FILE = 7
SLOT_OFFSETS = {1: 0x16, 2: 0x1A}

# (species, slot, ability, id)
EXPECTED = (
    ("APPLETUN", 1, "WELL_BAKED_BODY", 273),
    ("ARBOLIVA", 1, "SEED_SOWER", 269),
    ("ARCTIBAX", 1, "THERMAL_EXCHANGE", 270),
    ("BAXCALIBUR", 1, "THERMAL_EXCHANGE", 270),
    ("BELLIBOLT", 1, "ELECTROMORPHOSIS", 280),
    ("BISHARP", 1, "SHARPNESS", 292),
    ("BRAMBLEGHAST", 1, "WIND_RIDER", 274),
    ("BRAMBLIN", 1, "WIND_RIDER", 274),
    ("CALYREX_ICE_RIDER", 1, "AS_ONE_GLASTRIER", 266),
    ("CALYREX_SHADOW_RIDER", 1, "AS_ONE_SPECTRIER", 267),
    ("CHIEN_PAO", 1, "SWORD_OF_RUIN", 285),
    ("CHI_YU", 1, "BEADS_OF_RUIN", 287),
    ("DACHSBUN", 1, "WELL_BAKED_BODY", 273),
    ("FARIGIRAF", 1, "ARMOR_TAIL", 296),
    ("FRIGIBAX", 1, "THERMAL_EXCHANGE", 270),
    ("GALLADE", 2, "SHARPNESS", 292),
    ("GARGANACL", 1, "PURIFYING_SALT", 272),
    ("GHOLDENGO", 1, "GOOD_AS_GOLD", 283),
    ("GLASTRIER", 1, "CHILLING_NEIGH", 264),
    ("GOUGING_FIRE", 1, "PROTOSYNTHESIS", 281),
    ("KILOWATTREL", 1, "WIND_POWER", 277),
    ("KINGAMBIT", 1, "SHARPNESS", 292),
    ("KLAWF", 1, "ANGER_SHELL", 271),
    ("KORAIDON_GLIDING_BUILD", 1, "ORICHALCUM_PULSE", 288),
    ("KORAIDON_LIMITED_BUILD", 1, "ORICHALCUM_PULSE", 288),
    ("KORAIDON_SPRINTING_BUILD", 1, "ORICHALCUM_PULSE", 288),
    ("KORAIDON_SWIMMING_BUILD", 1, "ORICHALCUM_PULSE", 288),
    ("MABOSSTIFF", 2, "GUARD_DOG", 275),
    ("MIRAIDON_AQUATIC_MODE", 1, "HADRON_ENGINE", 289),
    ("MIRAIDON_DRIVE_MODE", 1, "HADRON_ENGINE", 289),
    ("MIRAIDON_GLIDE_MODE", 1, "HADRON_ENGINE", 289),
    ("MIRAIDON_LOW_POWER_MODE", 1, "HADRON_ENGINE", 289),
    ("MORPEKO", 1, "HUNGER_SWITCH", 258),
    ("MORPEKO_HANGRY", 1, "HUNGER_SWITCH", 258),
    ("NACLI", 1, "PURIFYING_SALT", 272),
    ("NACLSTACK", 1, "PURIFYING_SALT", 272),
    ("OGERPON_CORNERSTONE_MASK_TERASTAL", 1, "EMBODY_ASPECT_4", 304),
    ("OGERPON_HEARTHFLAME_MASK_TERASTAL", 1, "EMBODY_ASPECT_3", 303),
    ("OGERPON_TEAL_MASK_TERASTAL", 1, "EMBODY_ASPECT", 301),
    ("OGERPON_WELLSPRING_MASK_TERASTAL", 1, "EMBODY_ASPECT_2", 302),
    ("OINKOLOGNE", 1, "LINGERING_AROMA", 268),
    ("OINKOLOGNE_FEMALE", 1, "LINGERING_AROMA", 268),
    ("ORTHWORM", 1, "EARTH_EATER", 297),
    ("PALAFIN", 1, "ZERO_TO_HERO", 278),
    ("PALAFIN_HERO", 1, "ZERO_TO_HERO", 278),
    ("PAWNIARD", 1, "SHARPNESS", 292),
    ("POLTCHAGEIST", 1, "HOSPITALITY", 299),
    ("POLTCHAGEIST_MASTERPIECE", 1, "HOSPITALITY", 299),
    ("REGIDRAGO", 1, "DRAGONS_MAW", 263),
    ("REGIELEKI", 1, "TRANSISTOR", 262),
    ("SHIFTRY", 2, "WIND_RIDER", 274),
    ("SINISTCHA", 1, "HOSPITALITY", 299),
    ("SINISTCHA_MASTERPIECE", 1, "HOSPITALITY", 299),
    ("SPECTRIER", 1, "GRIM_NEIGH", 265),
    ("TATSUGIRI", 1, "COMMANDER", 279),
    ("TATSUGIRI_DROOPY", 1, "COMMANDER", 279),
    ("TATSUGIRI_STRETCHY", 1, "COMMANDER", 279),
    ("TERAPAGOS", 1, "TERA_SHIFT", 307),
    ("TERAPAGOS_STELLAR", 1, "TERAFORM_ZERO", 309),
    ("TERAPAGOS_TERASTAL", 1, "TERA_SHELL", 308),
    ("TING_LU", 1, "VESSEL_OF_RUIN", 284),
    ("URSALUNA_BLOODMOON", 1, "MINDS_EYE", 300),
    ("URSHIFU", 1, "UNSEEN_FIST", 260),
    ("URSHIFU_RAPID_STRIKE", 1, "UNSEEN_FIST", 260),
    ("WATTREL", 1, "WIND_POWER", 277),
    ("WO_CHIEN", 1, "TABLETS_OF_RUIN", 286),
    ("SILVALLY", 1, "RKS_SYSTEM", 225),
    ("MAGEARNA", 1, "SOUL_HEART", 220),
    ("ZACIAN", 1, "INTREPID_SWORD", 234),
    ("ZAMAZENTA", 1, "DAUNTLESS_SHIELD", 235),
    ("ZACIAN_CROWNED", 1, "INTREPID_SWORD", 234),
    ("ZAMAZENTA_CROWNED", 1, "DAUNTLESS_SHIELD", 235),
    ("KLEAVOR", "hidden", "SHARPNESS", 292),
    ("BOMBIRDIER", "hidden", "ROCKY_PAYLOAD", 276),
    ("VELUZA", "hidden", "SHARPNESS", 292),
    ("SAMUROTT_HISUIAN", "hidden", "SHARPNESS", 292),
    ("KLEAVOR_LORD", "hidden", "SHARPNESS", 292),
)


def read_defines(path: str) -> dict:
    defines = {}
    for line in open(path):
        m = re.match(r"#define\s+(\w+)\s+(.+?)\s*(//.*)?$", line)
        if m:
            defines[m.group(1)] = m.group(2)
    return defines


def resolve(name: str, defines: dict) -> int:
    expression = re.sub(r"[A-Z_0-9]+", lambda m: str(resolve(m.group(0), defines)) if m.group(0) in defines else m.group(0), defines[name])
    return eval(expression, {"__builtins__": {}})  # nothing but header arithmetic like (SPECIES_MEGA_START + 25)


def main() -> int:
    rom = ndspy.rom.NintendoDSRom.fromFile(sys.argv[1] if len(sys.argv) > 1 else "test.nds")
    personal = ndspy.narc.NARC(rom.getFileByName(PERSONAL_NARC)).files
    hidden = ndspy.narc.NARC(rom.getFileByName(HIDDEN_NARC)).files[HIDDEN_FILE]
    species_defines = read_defines("include/constants/species.h")
    ability_defines = read_defines("include/constants/ability.h")

    failures = []
    for species, slot, ability, expected_id in EXPECTED:
        header_id = resolve("ABILITY_" + ability, ability_defines)
        if header_id != expected_id:
            failures.append(f"{species} {slot}: ABILITY_{ability} is {header_id} in the headers, expected {expected_id}")
            continue
        index = resolve("SPECIES_" + species, species_defines)
        offset = index * 2 if slot == "hidden" else SLOT_OFFSETS[slot]
        actual = struct.unpack_from("<H", hidden if slot == "hidden" else personal[index], offset)[0]
        if actual != expected_id:
            failures.append(f"{species} {slot}: ROM holds ability {actual}, expected ABILITY_{ability} ({expected_id})")

    for failure in failures:
        print(failure, file=sys.stderr)
    if failures:
        print(f"check_species_abilities: {len(failures)} of {len(EXPECTED)} rows wrong", file=sys.stderr)
        return 1
    print(f"check_species_abilities: all {len(EXPECTED)} rows hold their intended ability")
    return 0


if __name__ == "__main__":
    sys.exit(main())
