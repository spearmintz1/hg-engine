.include "asm/include/battle_commands.inc"

.data

_000:
    // the terrain is already set (UpdateTerrainOverlay in MoveHitDefenderAbilityCheck), so the move in flight is left alone
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_GRASSY_TERRAIN
    Wait
    // Grass grew to cover the battlefield!
    PrintMessage 1388, TAG_NONE
    Wait
    WaitButtonABTime 30
    ResetParadoxAbility ABILITY_QUARK_DRIVE
    // Booster Energy
    ActivateParadoxAbility ABILITY_QUARK_DRIVE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    End
