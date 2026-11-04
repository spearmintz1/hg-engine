.text
.align 2
.thumb

.global set_starter_hidden_ability_hook
set_starter_hidden_ability_hook:
mov r5, r2
add r4, #8
mul r5, r1
add r1, r4, r5
push {r0-r7}
bl set_starter_hidden_ability
pop {r0-r7}
ldr r2, =0x02096160 | 1
bx r2

.pool


.global ImplementLevelCap_hook
ImplementLevelCap_hook:
ldr r3, =0x206E540 | 1
bl bx_r3
// r0 is level
bl IsLevelAtLevelCap
cmp r0, #1
beq return_to_2245B3E // above level cap
ldr r3, =0x02245A32 | 1
bx r3

return_to_2245B3E:
ldr r3, =0x2245B3E|1
// fall through

bx_r3:
bx r3

.pool


// r0 is level
.global CapRareCandies
CapRareCandies:
bl IsLevelAtLevelCap
cmp r0, #0
bne return_to_208FEFA
mov r0, r4
ldr r3, =0x0201AB0C | 1 // free memory
bl bx_r3
ldr r3, =0x0208FEF4 | 1
bx r3

return_to_208FEFA:
ldr r3, =0x0208FEFA | 1
bx r3


// replaces "exp = ExpToNextLevel(mon)" in the vanilla item effect (r5 is the mon, [sp, #4] the item) so EXP Candies can add more
.global LevelUpItemExp_hook
LevelUpItemExp_hook:
mov r0, r5
ldr r3, =0x0206FCA8 | 1 // experience missing for the next level
bl bx_r3
mov r2, r0
mov r0, r5
ldr r1, [sp, #4]
bl GetLevelUpItemExp
mov r2, r0
mov r0, r5
mov r1, #8 // MON_DATA_EXPERIENCE
ldr r3, =0x02090448 | 1 // the add-to-mon-data call
bx r3

.pool


// still needed because function itself is not 0x1C bytes long
.global Bag_HasSpaceForItem_hook
Bag_HasSpaceForItem_hook:
ldr r5, =Bag_HasSpaceForItem_return_address
mov r6, lr
str r6, [r5]
pop {r5-r6}
bl Bag_HasSpaceForItem
ldr r1, =Bag_HasSpaceForItem_return_address
ldr r1, [r1]
mov pc, r1

.pool

Bag_HasSpaceForItem_return_address:
.word 0


// still needed because function itself is not 0x1C bytes long
.global Bag_HasItem_hook
Bag_HasItem_hook:
ldr r5, =Bag_HasItem_return_address
mov r6, lr
str r6, [r5]
pop {r5-r6}
bl Bag_HasItem
ldr r1, =Bag_HasItem_return_address
ldr r1, [r1]
mov pc, r1

.pool

Bag_HasItem_return_address:
.word 0


// still needed because function itself is not 0x1C bytes long
.global CanUseItemOnMonInParty_hook
CanUseItemOnMonInParty_hook:
ldr r5, =CanUseItemOnMonInParty_return_address
mov r6, lr
str r6, [r5]
pop {r5-r6}
bl CanUseItemOnMonInParty
ldr r1, =CanUseItemOnMonInParty_return_address
ldr r1, [r1]
mov pc, r1

.pool

CanUseItemOnMonInParty_return_address:
.word 0

.global PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop_Case6_hook
PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop_Case6_hook:
mov r0, r4
bl PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop_Case6
ldr r1, =0x02081ea6 | 1
bx r1

.global PartyMenu_ItemUseFunc_ReuseItem_hook
PartyMenu_ItemUseFunc_ReuseItem_hook:
mov r0, r4
bl PartyMenu_ItemUseFunc_ReuseItem
ldr r3, =0x02081398 | 1
bx r3

// replaces the "was elevated to Lv." message block of the vanilla level-up item function (r5 is the work, r4 the mon)
.global PartyMenu_ItemUseFunc_LevelUp_PrintResult_hook
PartyMenu_ItemUseFunc_LevelUp_PrintResult_hook:
mov r0, r5
mov r1, r4
bl PartyMenu_ItemUseFunc_LevelUp_PrintResult
ldr r0, =0x02081B98 | 1
bx r0

.pool

// replaces "state = 0; return 5" at the end of the vanilla level-up item function (r5 is the work)
.global PartyMenu_ItemUseFunc_LevelUp_SetState_hook
PartyMenu_ItemUseFunc_LevelUp_SetState_hook:
mov r0, r5
bl PartyMenu_ItemUseFunc_LevelUp_SetState
mov r0, #5
ldr r1, =0x02081C10 | 1
bx r1

.pool
