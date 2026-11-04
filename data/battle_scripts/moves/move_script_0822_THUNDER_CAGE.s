.include "asm/include/battle_commands.inc"

.data

_000:
    // {0} trapped {1}! (7 side variants from 1579)
    BufferMessage 1579, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER
    GoToEffectScript 
