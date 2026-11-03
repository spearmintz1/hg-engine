#include "../../include/types.h"
#include "../../include/config.h"
#include "../../include/save.h"
#include "../../include/script.h"
#include "../../include/constants/item.h"

#ifdef MART_EXPANSION

// replaces the hand-patched tables the arm9 used to carry: the badge-gated general mart (ScrCmd_MartBuy) and the
// 30 special marts, which the vanilla ScrCmd_SpecialMartBuy reads by id through the pointer table at 0x0210FA3C.
// the arrays are deliberately not const: scripts/make.py only exports the symbols of .text and .data to the repoints file.

#define AFTER_GAME_CLEAR TRUE

struct BadgeMartItem {
    u16 item_id;
    u8 required_badges;     // total Johto + Kanto badges
    u8 requires_game_clear; // also needs FLAG_GAME_CLEAR
};

void LONG_CALL InitMartUI(void *taskManager, FieldSystem *fieldSystem, const u16 *items, int kind, int buySell, int decoWhich, const void *priceOverrides);

// every mart of the general kind sells this; each entry shows up once its badge count and, if set, the game clear are met
// prices come from the item data
static const struct BadgeMartItem sBadgeMart[] = {
    { ITEM_POKE_BALL,      0, FALSE },
    { ITEM_GREAT_BALL,     1, FALSE },
    { ITEM_ULTRA_BALL,     3, FALSE },
    { ITEM_MASTER_BALL,    8, FALSE },
    { ITEM_POTION,         0, FALSE },
    { ITEM_SUPER_POTION,   1, FALSE },
    { ITEM_HYPER_POTION,   3, FALSE },
    { ITEM_MAX_POTION,     7, FALSE },
    { ITEM_FULL_RESTORE,   8, FALSE },
    { ITEM_FULL_HEAL,      0, FALSE },
    { ITEM_MAX_ETHER,      3, FALSE },
    { ITEM_ELIXIR,         5, FALSE },
    { ITEM_MAX_ELIXIR,     7, FALSE },
    { ITEM_MAX_REVIVE,     8, FALSE },
    { ITEM_HEART_SCALE,    7, FALSE },
    { ITEM_REPEL,          0, FALSE },
    { ITEM_SUPER_REPEL,    3, FALSE },
    { ITEM_MAX_REPEL,      5, FALSE },
    { ITEM_MEGA_RING,      5, FALSE },
    { ITEM_SHINY_CHARM,    0, FALSE },
    // sold once the Hall of Fame has been entered
    { ITEM_RARE_CANDY,     0, AFTER_GAME_CLEAR },
    { ITEM_GRISEOUS_ORB,   0, AFTER_GAME_CLEAR },
    { ITEM_GRISEOUS_CORE,  0, AFTER_GAME_CLEAR },
    { ITEM_ADAMANT_ORB,    0, AFTER_GAME_CLEAR },
    { ITEM_ADAMANT_CRYSTAL, 0, AFTER_GAME_CLEAR },
    { ITEM_LUSTROUS_ORB,   0, AFTER_GAME_CLEAR },
    { ITEM_LUSTROUS_GLOBE, 0, AFTER_GAME_CLEAR },
    { ITEM_CORNERSTONE_MASK, 0, AFTER_GAME_CLEAR },
    { ITEM_WELLSPRING_MASK, 0, AFTER_GAME_CLEAR },
    { ITEM_HEARTHFLAME_MASK, 0, AFTER_GAME_CLEAR },
    { ITEM_ENIGMA_STONE,   0, AFTER_GAME_CLEAR },
};

// the special marts: one list per mart id, 0xFFFF terminated, each with its own storage so none can read into a neighbour
// id 0: Cherrygrove City, 2nd clerk
u16 sCherrygroveCityMart[] = {
    ITEM_HEAL_BALL, ITEM_NET_BALL, 0xFFFF
};

// id 1: Goldenrod Flower Shop (the Violet City slot); the nectars are the Oricorio forms
u16 sVioletCityMart[] = {
    ITEM_POWER_HERB, ITEM_MENTAL_HERB, ITEM_WHITE_HERB, ITEM_RED_NECTAR, ITEM_YELLOW_NECTAR,
    ITEM_PINK_NECTAR, ITEM_PURPLE_NECTAR, 0xFFFF
};

// id 2: Azalea Town
u16 sAzaleaCityMart[] = {
    ITEM_BLOOM_MAIL, ITEM_HEAL_BALL, ITEM_NET_BALL, 0xFFFF
};

// id 3: Goldenrod Dept. Store 2F, upper counter (Chansey Supply 2)
u16 sGoldenrodDepartmentUpper2F[] = {
    ITEM_PP_UP, ITEM_ABILITY_CAPSULE, ITEM_ABILITY_PATCH, ITEM_LONELY_MINT, ITEM_ADAMANT_MINT,
    ITEM_NAUGHTY_MINT, ITEM_BRAVE_MINT, ITEM_BOLD_MINT, ITEM_IMPISH_MINT, ITEM_LAX_MINT,
    ITEM_RELAXED_MINT, ITEM_MODEST_MINT, ITEM_MILD_MINT, ITEM_RASH_MINT, ITEM_QUIET_MINT,
    ITEM_CALM_MINT, ITEM_GENTLE_MINT, ITEM_CAREFUL_MINT, ITEM_SASSY_MINT, ITEM_TIMID_MINT,
    ITEM_HASTY_MINT, ITEM_JOLLY_MINT, ITEM_NAIVE_MINT, ITEM_SERIOUS_MINT, 0xFFFF
};

// id 4: Goldenrod Dept. Store 2F, lower counter (Trainer's Market)
u16 sGoldenrodDepartmentLower2F[] = {
    ITEM_POKE_BALL, ITEM_GREAT_BALL, ITEM_ULTRA_BALL, ITEM_ESCAPE_ROPE, ITEM_POKE_DOLL,
    ITEM_FLUFFY_TAIL, ITEM_REPEL, ITEM_SUPER_REPEL, ITEM_MAX_REPEL, ITEM_GRASS_MAIL,
    ITEM_FLAME_MAIL, ITEM_BUBBLE_MAIL, ITEM_SPACE_MAIL, 0xFFFF
};

// id 5: Goldenrod Dept. Store 3F (Battle Collection): evolution items, held items, screens
u16 sGoldenrodDepartment3F[] = {
    ITEM_DRAGON_SCALE, ITEM_UP_GRADE, ITEM_DUBIOUS_DISC, ITEM_PROTECTOR, ITEM_ELECTIRIZER,
    ITEM_MAGMARIZER, ITEM_REAPER_CLOTH, ITEM_METAL_COAT, ITEM_PRISM_SCALE, ITEM_KINGS_ROCK,
    ITEM_RAZOR_CLAW, ITEM_RAZOR_FANG, ITEM_WHIPPED_DREAM, ITEM_SACHET, ITEM_DEEP_SEA_TOOTH,
    ITEM_DEEP_SEA_SCALE, ITEM_EVIOLITE, ITEM_ROCKY_HELMET, ITEM_ASSAULT_VEST, ITEM_LOADED_DICE,
    ITEM_LEFTOVERS, ITEM_BLACK_SLUDGE, ITEM_METRONOME, ITEM_FOCUS_SASH, ITEM_LIFE_ORB, ITEM_TM16,
    ITEM_TM17, ITEM_TM33, 0xFFFF
};

// id 6: Goldenrod Dept. Store 4F (Tranquil Terrace)
u16 sGoldenrodDepartment4F[] = {
    ITEM_PROTEIN, ITEM_IRON, ITEM_CALCIUM, ITEM_ZINC, ITEM_CARBOS, ITEM_HP_UP, 0xFFFF
};

// id 7: Goldenrod Dept. Store 5F: evolution stones and the Hisui/Galar/Paldea evolution items
u16 sGoldenrodDepartment5F[] = {
    ITEM_SUN_STONE, ITEM_MOON_STONE, ITEM_FIRE_STONE, ITEM_THUNDER_STONE, ITEM_WATER_STONE,
    ITEM_LEAF_STONE, ITEM_ICE_STONE, ITEM_SHINY_STONE, ITEM_DUSK_STONE, ITEM_DAWN_STONE,
    ITEM_LINKING_CORD, ITEM_METAL_ALLOY, ITEM_PEAT_BLOCK, ITEM_GALARICA_CUFF, ITEM_GALARICA_WREATH,
    ITEM_BLACK_AUGURITE, ITEM_CRACKED_POT, ITEM_SYRUPY_APPLE, ITEM_SWEET_APPLE, ITEM_TART_APPLE,
    ITEM_MALICIOUS_ARMOR, ITEM_AUSPICIOUS_ARMOR, 0xFFFF
};

// id 8: Goldenrod Underground herbal medicine shop
u16 sGoldenrodHerbs[] = {
    ITEM_HEAL_POWDER, ITEM_ENERGY_POWDER, ITEM_ENERGY_ROOT, ITEM_REVIVAL_HERB, 0xFFFF
};

// id 9: Ecruteak City, 2nd clerk
u16 sEcruteakMart[] = {
    ITEM_BLACK_BELT, ITEM_EXPERT_BELT, ITEM_FOCUS_SASH, 0xFFFF
};

// id 10: Olivine City, 2nd clerk
u16 sOlivineMart[] = {
    ITEM_HEART_MAIL, ITEM_HEAL_BALL, ITEM_NET_BALL, 0xFFFF
};

// id 11: Cianwood City pharmacy
u16 sCianwoodPharmacy[] = {
    ITEM_POTION, ITEM_SUPER_POTION, ITEM_HYPER_POTION, ITEM_FULL_HEAL, ITEM_REVIVE,
    ITEM_LAVA_COOKIE, ITEM_OLD_GATEAU, 0xFFFF
};

// id 12: Blackthorn City and Battle Frontier
u16 sBlackthornAndBattleFrontierMart[] = {
    ITEM_AIR_MAIL, ITEM_NET_BALL, ITEM_DUSK_BALL, 0xFFFF
};

// id 13: Indigo Plateau
u16 sIndigoPlateau[] = {
    ITEM_ULTRA_BALL, ITEM_MAX_REPEL, ITEM_HYPER_POTION, ITEM_MAX_POTION, ITEM_FULL_RESTORE,
    ITEM_REVIVE, ITEM_FULL_HEAL, 0xFFFF
};

// id 14: Vermilion City and Safari Zone Gate
u16 sVermilionAndSafariMart[] = {
    ITEM_AIR_MAIL, ITEM_NEST_BALL, ITEM_DUSK_BALL, ITEM_QUICK_BALL, ITEM_SAFARI_BALL,
    ITEM_DIVE_BALL, 0xFFFF
};

// id 15: Saffron City
u16 sSaffronMart[] = {
    ITEM_AIR_MAIL, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

// id 16: Lavender Town
u16 sLavenderMart[] = {
    ITEM_SNOW_MAIL, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

// id 17: Cerulean City
u16 sCeruleanMart[] = {
    ITEM_AIR_MAIL, ITEM_QUICK_BALL, 0xFFFF
};

// id 18: Celadon Dept. Store 2F, upper counter (tail of the Goldenrod 2F mint list in the release)
u16 sCeladonDepartmentUpper2F[] = {
    ITEM_RASH_MINT, ITEM_QUIET_MINT, ITEM_CALM_MINT, ITEM_GENTLE_MINT, ITEM_CAREFUL_MINT,
    ITEM_SASSY_MINT, ITEM_TIMID_MINT, ITEM_HASTY_MINT, ITEM_JOLLY_MINT, ITEM_NAIVE_MINT,
    ITEM_SERIOUS_MINT, 0xFFFF
};

// id 19: Celadon Dept. Store 2F, lower counter
u16 sCeladonDepartmentLower2F[] = {
    ITEM_GALARICA_CUFF, ITEM_GALARICA_WREATH, ITEM_BLACK_AUGURITE, ITEM_CRACKED_POT,
    ITEM_SYRUPY_APPLE, ITEM_SWEET_APPLE, ITEM_TART_APPLE, ITEM_MALICIOUS_ARMOR,
    ITEM_AUSPICIOUS_ARMOR, ITEM_DREAM_BALL, ITEM_BEAST_BALL, 0xFFFF
};

// id 20: Celadon Dept. Store 3F: form items (release) plus the evolution items (source)
u16 sCeladonDepartment3F[] = {
    ITEM_SCROLL_OF_DARKNESS, ITEM_SCROLL_OF_WATERS, ITEM_DNA_SPLICERS, ITEM_PRISON_BOTTLE,
    ITEM_REVEAL_GLASS, ITEM_RUSTED_SHIELD, ITEM_RUSTED_SWORD, ITEM_GRACIDEA, ITEM_MEWTWONITE_Y,
    ITEM_MEWTWONITE_X, ITEM_SHINY_STONE, ITEM_DUSK_STONE, ITEM_DAWN_STONE, ITEM_PRISM_SCALE,
    ITEM_KINGS_ROCK, ITEM_LINKING_CORD, ITEM_RAZOR_CLAW, ITEM_RAZOR_FANG, ITEM_WHIPPED_DREAM,
    ITEM_SACHET, ITEM_SYRUPY_APPLE, ITEM_SWEET_APPLE, 0xFFFF
};

// id 21: Celadon Dept. Store 4F (mail)
u16 sCeladonDepartment4F[] = {
    ITEM_AIR_MAIL, ITEM_TUNNEL_MAIL, ITEM_BLOOM_MAIL, ITEM_MOSAIC_MAIL, ITEM_BRICK_MAIL, 0xFFFF
};

// id 22: Celadon Dept. Store 5F, left clerk (Battle Collection): held items, old and new generations
u16 sCeladonDepartmentLeft5F[] = {
    ITEM_KINGS_ROCK, ITEM_RAZOR_CLAW, ITEM_RAZOR_FANG, ITEM_WHIPPED_DREAM, ITEM_SACHET,
    ITEM_DEEP_SEA_TOOTH, ITEM_DEEP_SEA_SCALE, ITEM_ROCKY_HELMET, ITEM_ASSAULT_VEST,
    ITEM_LOADED_DICE, ITEM_LEFTOVERS, ITEM_BLACK_SLUDGE, ITEM_METRONOME, ITEM_FOCUS_SASH,
    ITEM_LIFE_ORB, ITEM_EJECT_BUTTON, ITEM_EJECT_PACK, ITEM_RED_CARD, ITEM_WEAKNESS_POLICY,
    ITEM_FLOAT_STONE, ITEM_SAFETY_GOGGLES, ITEM_HEAVY_DUTY_BOOTS, ITEM_BOOSTER_ENERGY,
    ITEM_CLEAR_AMULET, ITEM_MIRROR_HERB, ITEM_PROTECTIVE_PADS, ITEM_TERRAIN_EXTENDER,
    ITEM_UTILITY_UMBRELLA, ITEM_ABILITY_SHIELD, ITEM_PUNCHING_GLOVE, ITEM_LUMINOUS_MOSS,
    ITEM_MACHO_BRACE, ITEM_ICY_ROCK, ITEM_SMOOTH_ROCK, ITEM_HEAT_ROCK, ITEM_DAMP_ROCK, 0xFFFF
};

// id 23: Celadon Dept. Store 5F, right clerk (Battle Collection): recovery and the rooftop drinks, plus type boosters
u16 sCeladonDepartmentRight5F[] = {
    ITEM_POTION, ITEM_SUPER_POTION, ITEM_HYPER_POTION, ITEM_MAX_POTION, ITEM_REVIVE, ITEM_FULL_HEAL,
    ITEM_POKE_DOLL, ITEM_FRESH_WATER, ITEM_SODA_POP, ITEM_LEMONADE, ITEM_REPEL, ITEM_HEART_MAIL,
    ITEM_PIXIE_PLATE, ITEM_BLANK_PLATE, ITEM_BURN_DRIVE, ITEM_CHILL_DRIVE, ITEM_DOUSE_DRIVE,
    ITEM_SHOCK_DRIVE, ITEM_FAIRY_FEATHER, ITEM_NORMAL_GEM, ITEM_FIGHTING_GEM, ITEM_FLYING_GEM,
    ITEM_POISON_GEM, ITEM_GROUND_GEM, ITEM_ROCK_GEM, ITEM_BUG_GEM, ITEM_GHOST_GEM, ITEM_STEEL_GEM,
    ITEM_FIRE_GEM, ITEM_WATER_GEM, ITEM_GRASS_GEM, ITEM_ELECTRIC_GEM, ITEM_PSYCHIC_GEM,
    ITEM_ICE_GEM, ITEM_DRAGON_GEM, ITEM_DARK_GEM, ITEM_FAIRY_GEM, ITEM_FIGHTING_MEMORY,
    ITEM_FLYING_MEMORY, ITEM_POISON_MEMORY, ITEM_GROUND_MEMORY, ITEM_ROCK_MEMORY, ITEM_BUG_MEMORY,
    ITEM_GHOST_MEMORY, ITEM_STEEL_MEMORY, ITEM_FIRE_MEMORY, ITEM_WATER_MEMORY, ITEM_GRASS_MEMORY,
    ITEM_ELECTRIC_MEMORY, ITEM_PSYCHIC_MEMORY, ITEM_ICE_MEMORY, ITEM_DRAGON_MEMORY,
    ITEM_DARK_MEMORY, ITEM_FAIRY_MEMORY, 0xFFFF
};

// id 24: Fuchsia City (Safari Zone berries: the Gen 4 and Gen 6 berries no wild Pokemon holds)
u16 sFuschiaMart[] = {
    ITEM_STEEL_MAIL, ITEM_DUSK_BALL, ITEM_QUICK_BALL, ITEM_MAGOST_BERRY, ITEM_RABUTA_BERRY,
    ITEM_SPELON_BERRY, ITEM_PAMTRE_BERRY, ITEM_WATMEL_BERRY, ITEM_BELUE_BERRY, ITEM_LIECHI_BERRY,
    ITEM_GANLON_BERRY, ITEM_SALAC_BERRY, ITEM_PETAYA_BERRY, ITEM_APICOT_BERRY, ITEM_LANSAT_BERRY,
    ITEM_STARF_BERRY, ITEM_ENIGMA_BERRY, ITEM_MICLE_BERRY, ITEM_CUSTAP_BERRY, ITEM_JABOCA_BERRY,
    ITEM_ROWAP_BERRY, ITEM_ROSELI_BERRY, ITEM_KEE_BERRY, ITEM_MARANGA_BERRY, 0xFFFF
};

// id 25: Pewter City
u16 sPewterMart[] = {
    ITEM_STEEL_MAIL, ITEM_NEST_BALL, ITEM_QUICK_BALL, 0xFFFF
};

// id 26: Viridian City
u16 sViridianMart[] = {
    ITEM_STEEL_MAIL, ITEM_NET_BALL, ITEM_HEAL_BALL, 0xFFFF
};

// id 27: Mt. Moon Square
u16 sMtMoonSquare[] = {
    ITEM_POKE_DOLL, ITEM_FRESH_WATER, ITEM_SODA_POP, ITEM_LEMONADE, ITEM_REPEL, ITEM_HEART_MAIL,
    0xFFFF
};

// id 28: Mahogany Town, before the Rocket Hideout is cleared
u16 sMahoganyPreRocketHideout[] = {
    ITEM_TINY_MUSHROOM, ITEM_POKE_BALL, ITEM_POTION, 0xFFFF
};

// id 29: Mahogany Town, after the Rocket Hideout is cleared
u16 sMahoganyPostRocketHideout[] = {
    ITEM_PRISM_SCALE, ITEM_KINGS_ROCK, ITEM_RAZOR_FANG, ITEM_RAZOR_CLAW, ITEM_WHIPPED_DREAM,
    ITEM_SACHET, ITEM_DEEP_SEA_TOOTH, ITEM_DEEP_SEA_SCALE, 0xFFFF
};

static u32 CountBadges(u8 badgeMask)
{
    u32 count = 0;

    for (; badgeMask != 0; badgeMask &= badgeMask - 1) {
        count++;
    }
    return count;
}

BOOL ScrCmd_MartBuy(SCRIPTCONTEXT *ctx)
{
    u16 unused UNUSED = ScriptGetVar(ctx); // the script still passes the old mart id operand
    u16 items[NELEMS(sBadgeMart) + 1];
    struct PlayerProfile *profile = Sav2_PlayerData_GetProfileAddr(ctx->fsys->savedata);
    u32 badgeCount = CountBadges(profile->johtoBadges) + CountBadges(profile->kantoBadges);
    BOOL gameClear = CheckScriptFlag(FLAG_GAME_CLEAR);
    u32 count = 0;
    u32 i;

    for (i = 0; i < NELEMS(sBadgeMart); i++) {
        if (badgeCount >= sBadgeMart[i].required_badges && (gameClear || !sBadgeMart[i].requires_game_clear)) {
            items[count++] = sBadgeMart[i].item_id;
        }
    }
    items[count] = 0xFFFF;

    InitMartUI(ctx->taskman, ctx->fsys, items, 0, 0, 0, NULL);
    return TRUE;
}

#endif // MART_EXPANSION
