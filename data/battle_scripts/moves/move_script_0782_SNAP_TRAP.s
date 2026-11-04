.include "asm/include/battle_commands.inc"

.data

_000:
    // {0} got trapped by a snap trap! (3 side variants from 1576)
    BufferMessage 1576, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    GoToEffectScript 
