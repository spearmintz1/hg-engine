// Test: Quark Drive - a held Booster Energy takes over as soon as the Electric Terrain ends, before the rest of the end of turn
#include "../../battle_tests.h"
BEGIN_TEST
{
    .battleType = BATTLE_TYPE_DOUBLES,
    .weather = FIELD_CONDITION_NONE,
    .fieldCondition = 0,
    .terrain = TERRAIN_NONE,

    .playerParty = {
        {
            .species = SPECIES_TAPU_KOKO,
            .level = 50,
            .form = 0,
            .ability = ABILITY_ELECTRIC_SURGE,
            .item = ITEM_NONE,
            .moves = {MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE},
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {
            .species = SPECIES_NINJASK,
            .level = 50,
            .form = 0,
            .ability = ABILITY_SPEED_BOOST,
            .item = ITEM_NONE,
            .moves = {MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE},
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
    },

    .enemyParty = {
        {
            .species = SPECIES_IRON_VALIANT,
            .level = 50,
            .form = 0,
            .ability = ABILITY_QUARK_DRIVE,
            .item = ITEM_BOOSTER_ENERGY,
            .moves = {MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE},
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {
            .species = SPECIES_WOBBUFFET,
            .level = 50,
            .form = 0,
            .ability = ABILITY_SHADOW_TAG,
            .item = ITEM_NONE,
            .moves = {MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE},
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
        {.species = SPECIES_NONE},
    },

    .playerScript = {
        {
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        },
        {
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        }
    },

    .enemyScript = {
        {
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        },
        {
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        }
    },

    .expectations = {
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "An electric current ran across the battlefield!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The Electric Terrain activated the opposing Iron Valor's Quark Drive!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Iron Valor's Attack was heightened!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The electricity disappeared from the battlefield." },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The effects of the opposing Iron Valor's Quark Drive wore off!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Iron Valor used the Booster Energy to activate Quark Drive!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Iron Valor's Attack was heightened!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE_CONTAINS, .expectationValue.message = "Ninjask's Speed Boost" },
    }
}
END_TEST
