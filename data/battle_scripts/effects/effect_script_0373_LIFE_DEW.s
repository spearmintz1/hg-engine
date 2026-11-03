.include "asm/include/battle_commands.inc"

.data

_000:
    PrintAttackMessage 
    Wait 
    // fails only when the user and its ally (if any) are all at full HP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MAXHP, BSCRIPT_VAR_CALC_TEMP
    CompareMonDataToVar OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, BSCRIPT_VAR_CALC_TEMP, _heal
    GetAllyAsMsgBattler _failed
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_MAXHP, BSCRIPT_VAR_CALC_TEMP
    CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_HP, BSCRIPT_VAR_CALC_TEMP, _failed

_heal:
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait 
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    Call BATTLE_SUBSCRIPT_LIFE_DEW_HEAL
    GetAllyAsMsgBattler _end
    Call BATTLE_SUBSCRIPT_LIFE_DEW_HEAL

_end:
    End 

_failed:
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End 
