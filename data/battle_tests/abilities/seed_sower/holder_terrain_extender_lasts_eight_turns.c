// Test: Seed Sower - the holder's Terrain Extender lengthens the Grassy Terrain to 8 turns
#include "../../battle_tests.h"
BEGIN_TEST
{
    .battleType = BATTLE_TYPE_TRAINER,
    .weather = FIELD_CONDITION_NONE,
    .fieldCondition = 0,
    .terrain = TERRAIN_NONE,

    .playerParty = {
        {
            .species = SPECIES_ARBOLIVA,
            .level = 50,
            .form = 0,
            .ability = ABILITY_SEED_SOWER,
            .item = ITEM_TERRAIN_EXTENDER,
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
        {.species = SPECIES_NONE},
    },

    .enemyParty = {
        {
            .species = SPECIES_SNORLAX,
            .level = 20,
            .form = 0,
            .ability = ABILITY_IMMUNITY,
            .item = ITEM_NONE,
            .moves = {MOVE_TACKLE, MOVE_SPLASH, MOVE_NONE, MOVE_NONE},
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {.species = SPECIES_NONE},
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
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST},
        },
        {
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        }
    },

    .enemyScript = {
        {
            {ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
            {ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST},
        },
        {
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
            {ACTION_NONE, 0},
        }
    },

    .expectations = {
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Grass grew to cover the battlefield!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "Arboliva used Splash!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The grass disappeared from the battlefield." },
    }
}
END_TEST
