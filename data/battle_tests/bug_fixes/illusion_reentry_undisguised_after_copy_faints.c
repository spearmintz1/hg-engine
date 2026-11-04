// Test: A Zoroark that re-enters after the mon it copied fainted has nothing left to copy and must show as itself, not as the fainted mon
#include "../battle_tests.h"
BEGIN_TEST
{
    .battleType = BATTLE_TYPE_TRAINER,
    .weather = FIELD_CONDITION_NONE,
    .fieldCondition = 0,
    .terrain = TERRAIN_NONE,
    .playerParty = {
        {
            .species = SPECIES_MACHAMP,
            .level = 100,
            .form = 0,
            .ability = ABILITY_GUTS,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_AURA_SPHERE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
    },
    .enemyParty = {
        {
            .species = SPECIES_ZOROARK,
            .level = 5,
            .form = 0,
            .ability = ABILITY_ILLUSION,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {
            .species = SPECIES_PIKACHU,
            .level = 5,
            .form = 0,
            .ability = ABILITY_STATIC,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
    },
    .playerScript = {
    {
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .enemyScript = {
    {
        { ACTION_SWITCH_SLOT_1, 0 },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .expectations = {
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Pikachu fainted!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE_CONTAINS, .expectationValue.message = "sent out Zoroark!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Zoroark used Splash!" },
    },
}
END_TEST
