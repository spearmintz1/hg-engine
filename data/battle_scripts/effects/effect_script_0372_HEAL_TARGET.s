.include "asm/include/battle_commands.inc"

.data

_000:
    PrintAttackMessage 
    Wait 
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MAXHP, BSCRIPT_VAR_HP_CALC
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MEGA_LAUNCHER, _heal75Percent
    // round up to half
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_HP_CALC, 1
    UpdateVar OPCODE_DIV, BSCRIPT_VAR_HP_CALC, 2
    GoTo _heal

_heal75Percent:
    // round up to a quarter, then triple it
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_HP_CALC, 3
    UpdateVar OPCODE_DIV, BSCRIPT_VAR_HP_CALC, 4
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, 3

_heal:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_RECOVER_HP
    End 
