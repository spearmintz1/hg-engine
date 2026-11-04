.include "asm/include/battle_commands.inc"

.data

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT, _preventWeatherChange
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HEAVY_RAIN, _preventWeatherChange
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_STRONG_WINDS, _preventWeatherChange
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_ALL, _alreadySunny
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SUN
    Wait
    // Orichalcum Pulse will still show the "The sunlight turned harsh!" message before showing the unique message
    Call BATTLE_SUBSCRIPT_HANDLE_SUN_TEMPORARY
    // {0} turned the sunlight harsh, sending its ancient pulse into a frenzy!
    PrintMessage 1616, TAG_NICKNAME, BATTLER_CATEGORY_ABILITY_MON
    Wait
    WaitButtonABTime 30
    End

_alreadySunny:
    // {0} basked in the sunlight, sending its ancient pulse into a frenzy!
    PrintMessage 1619, TAG_NICKNAME, BATTLER_CATEGORY_ABILITY_MON
    Wait
    WaitButtonABTime 30
    End

_preventWeatherChange:
    Call BATTLE_SUBSCRIPT_PREVENT_CHANGING_WEATHER
    End
