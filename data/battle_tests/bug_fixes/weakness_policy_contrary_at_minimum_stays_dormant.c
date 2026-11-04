// Test: Weakness Policy on a Contrary holder already at -6 Attack and -6 Sp. Atk (so it cannot lower either) must not activate or be consumed
#include "../battle_tests.h"
BEGIN_TEST
{
    .battleType = BATTLE_TYPE_TRAINER,
    .weather = FIELD_CONDITION_NONE,
    .fieldCondition = 0,
    .terrain = TERRAIN_NONE,
    .playerParty = {
        {
            .species = SPECIES_SNORLAX,
            .level = 100,
            .form = 0,
            .ability = ABILITY_CONTRARY,
            .item = ITEM_WEAKNESS_POLICY,
            .moves = { MOVE_SWORDS_DANCE, MOVE_NASTY_PLOT, MOVE_SPLASH, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
    },
    .enemyParty = {
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
    .playerScript = {
    {
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_2, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_3, BATTLER_ENEMY_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .enemyScript = {
    {
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_MOVE_SLOT_2, BATTLER_PLAYER_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .expectations = {
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "It's super effective!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE_DOES_NOT_CONTAIN, .expectationValue.message = "Attack" },
    },
}
END_TEST
