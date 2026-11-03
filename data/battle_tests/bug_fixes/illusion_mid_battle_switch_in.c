// Test: A Zoroark switched in mid-battle must disguise as the last non-fainted party mon in the switch-in and move messages
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
            .level = 50,
            .form = 0,
            .ability = ABILITY_GUTS,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
    },
    .enemyParty = {
        {
            .species = SPECIES_RATTATA,
            .level = 50,
            .form = 0,
            .ability = ABILITY_GUTS,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {
            .species = SPECIES_ZOROARK,
            .level = 50,
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
            .level = 50,
            .form = 0,
            .ability = ABILITY_STATIC,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = FULL_HP,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
        {
            .species = SPECIES_EEVEE,
            .level = 50,
            .form = 0,
            .ability = ABILITY_RUN_AWAY,
            .item = ITEM_NONE,
            .moves = { MOVE_SPLASH, MOVE_NONE, MOVE_NONE, MOVE_NONE },
            .hp = 0,
            .status = 0,
            .condition2 = 0,
            .moveEffectFlags = 0,
        },
    },
    .playerScript = {
    {
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_MOVE_SLOT_1, BATTLER_ENEMY_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .enemyScript = {
    {
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_SWITCH_SLOT_1, 0 },
        { ACTION_MOVE_SLOT_1, BATTLER_PLAYER_FIRST },
        { ACTION_NONE, 0 },
    },
    {
        { ACTION_NONE, 0 },
    },
    },
    .expectations = {
        { .expectationType = EXPECTATION_TYPE_MESSAGE_CONTAINS, .expectationValue.message = "sent out Pikachu!" },
        { .expectationType = EXPECTATION_TYPE_MESSAGE, .expectationValue.message = "The opposing Pikachu used Splash!" },
    },
}
END_TEST
