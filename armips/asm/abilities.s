.nds
.thumb

// included by global

.open "base/arm9.bin", 0x2000000


// personal narc ability expansion here too
.org 0x0206FB80
ldrh r5, [r4, #0x16]

.org 0x0206FB84
ldrh r5, [r4, #0x1A]

/*
summary screen!
ability is originally a u8 at 0x32 of the pokemondata structure (0x262 of overall structure)
we need to move it to the original form field, a u16 at 0x4e (0x27e of overall structure)
*/
// changes to how the ability is stored
.org 0x02089A2A
add r1, #0x4e
strh r0, [r1]

// change how the form is stored
.org 0x02089B30
add r1, #0x32
strb r0, [r1]

// change how the form is used for the summary screen cry
.org 0x02089C9A
add r2, #0x26

// the icon palette and personal data lookups read the form as well: follow it to its new byte
.org 0x0208BE8C
add r1, #0x26
.org 0x0208BE90
ldrb r1, [r4, r1]

.org 0x0208BEAE
add r1, #0x26
.org 0x0208BEB0
ldrb r1, [r4, r1]

// change how ability is used
.org 0x0208D376
ldrh r2, [r4, r2]

.org 0x0208D3C4
ldrh r1, [r4, r1]

.org 0x0208D464
.word 0x27E

/*
script commands!

GiveMon script command uses a u8 variable.  this cast is done by a paired lsl/lsr instruction that we change to make it u16 instead
*/

.org 0x0204D132
lsl r0, #0x10
lsr r0, #0x10

.org 0x02054248
ldrh r0, [r0, #0x14]

// egg hatching compares the ability against Magma Armor/Flame Body after a u8 cast: drop the cast
// (otherwise Armor Tail 296 = 0x128 acts as Magma Armor 40 and Toxic Chain 305 = 0x131 as Flame Body 49)
.org 0x0206CB6A
nop
nop

.close


.open "base/overlay/overlay_0012.bin", 0x022378C0

/*
basically we need to take the ability element in the BattlePokemon structure and move it to somewhere that is previously unused.
the original structure has it at 0x27.  we are moving it to 0x7a.  i think?  that this is still within range of the offset for purposes of ldrh.
2D67 -> 2DBA (offset within total BattleStruct)

we need to change ldrb -> ldrh (and strb -> strh) when applicable as well
*/

.equ BASE_BATTLEMON_OFFSET, 0x2D40
.equ NEW_ABILITY_OFFSET, 0x7a
.equ ABILITY_OFFSET_WITHIN_BATTLESTRUCT, (BASE_BATTLEMON_OFFSET + NEW_ABILITY_OFFSET)


// WS_ABICNT_CALC / statbuffchange
// already handled because of hooked change, but included here to mark it as done
.org 0x0223F0E8
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT

.org 0x0223F374
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// btl_scr_cmd_87_tryknockoff
// already handled because of hooked change
.org 0x02242FC8
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// btl_scr_cmd_d1_trynaturalcure
// already handled because of hooked change
//.org 0x02245148
//.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// MessageParamTokuseiGet
// this features a call to the function at 2248648 (AI_BattlerSetAbility) that reveals to the AI what ability is being displayed
.org 0x022481BC
ldrh r4, [r2, r0]

.org 0x022481CC
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// Arceus multitype typing check (reached from GetBattlerVar)
.org 0x022584EA
add r0, #NEW_ABILITY_OFFSET
ldrh r0, [r1, r0]


// AI_BattlerSetAbility(btx, client, ability)
// not going to be too comprehensive about changes to 0x390 to get it to 0x3E0
// am allowed to use 1 extra instruction per 2248654 giving me space after alignment
.org 0x02248648
add r1, r1 // multiply client by 2
add r1, r0, r1 // add it to btx
mov r0, #0x3e
lsl r0, #4
strh r2, [r1, r0] // strh to 0x3e0[client]
bx lr


// edits to ST_PokemonParamGet/BattleSystem_GetBattleMon
.org 0x0224E780
strh r0, [r3, r2]
sub r2, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2DB8)
sub r1, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2DAC)

.org 0x0224E7A0
strh r0, [r2, r1]

.org 0x0224E914
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// edits to GetBattlerVar - https://github.com/pret/pokeheartgold/blob/77a632e01831822a771760d1afdbfbcd7d3bd96b/asm/overlay_12_0224E4FC.s#L1282-L1284
.org 0x0224EF36
add r4, #NEW_ABILITY_OFFSET
ldrh r0, [r4]

// edits to SetBattlerVar
.org 0x0224F320
ldrh r0, [r3]
add r2, #NEW_ABILITY_OFFSET
strh r0, [r2]


// ST_ServerTokuseiGet / GetBattlerAbility
// already handled
.org 0x02252830
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// BattleFormChangeCheck (already handled)
.org 0x02256F24
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// some function checking forecast/trace/multitype
.org 0x022585CC
ldrh r3, [r6, r2]

.org 0x022585DA
sub r2, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2D8C)

.org 0x022585EA
sub r2, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2D8C)

.org 0x022585F4
ldrh r2, [r6, r2]

.org 0x02258636
ldrh r1, [r2, r0]

.org 0x02258640
sub r0, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2D8C)

.org 0x02258654
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// BattleControl_EmitPartyStatusHeal
.org 0x02263CFC
ldrh r1, [r3, r1]

.org 0x02263D10
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT


// pickup check: the party mon's ability was cut to a u8 before comparing against Pickup (53)
.org 0x022440F2
nop
nop


// SCIO_PSPtoPPCopy: the battle mon's ability is read as the byte after the form (0x2D66+1), i.e. the dead 0x2D67.  the message's +0x24 is a
// whole word (str [sp,#0x34]) so the u16 fits; the receiver at 0x022592A4 passes it to SetMonData(MON_DATA_ABILITY)
.org 0x02263BC6
add r0, #(ABILITY_OFFSET_WITHIN_BATTLESTRUCT-0x2D66)

.org 0x02263BD0
ldrh r0, [r2, r0]


// and that is all instances of 2D67 in overlay 12!  let's see how it goes


.close


.open "base/overlay/overlay_0010.bin", 0x0221BE20

/*
trainer AI.  battle mon abilities are read straight out of the BattleStruct here, so these follow the move 2D67 -> 2DBA
(AI_BattlerSetAbility / the AI's ability memory moved from u8 0x390+client to u16 0x3E0+2*client, see ov12 0x02248648)
*/

// AI ability memory, reader 1: was ldrb [btx+client+0x390], r2 is the pool value 0x3CF
.org 0x0221D0F6
lsl r1, r1, #1
add r2, #0x11 // 0x3CF -> 0x3E0
add r4, r5, r1
ldrh r1, [r4, r2]

.org 0x0221D102
sub r2, #0x84 // 0x3E0 -> 0x35C, was 0x3CF-0x73

// battlemon ability, was ldrb [r0+0x2DC0-0x59]
.org 0x0221D10A
sub r1, #6

.org 0x0221D10C
ldrh r1, [r0, r1]

.org 0x0221D176
ldrh r1, [r1, r0]

.org 0x0221D184
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT

// AI ability memory, reader 2 (0x0221D1D0..D6) is hooked: AI_AbilityMemoryRead_hook in asm/other_hook.s
.org 0x0221D1DC
sub r1, #0x84 // 0x3E0 -> 0x35C, was 0x390-0x34

.org 0x0221D1E8
ldrh r4, [r2, r1]

.org 0x0221D1F6
sub r1, #NEW_ABILITY_OFFSET // back to the BattlePokemon base, was 0x2D67-0x27

.org 0x0221D230
sub r1, #6

.org 0x0221D232
ldrh r4, [r6, r1]

.org 0x0221D25C
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT

// Wonder Guard check
.org 0x0221F658
ldrh r0, [r2, r0]

.org 0x0221F7DC
.word ABILITY_OFFSET_WITHIN_BATTLESTRUCT

// party ability compared against the absorb abilities: drop the u8 cast
.org 0x0221FFC6
mov r1, r0
nop

.close


.open "base/overlay/overlay_0002.bin", 0x02245B80

/*
EncounterInfo.ability is a u16 now (Compound Eyes etc. were compared after a u8 truncation)
the builder at 0x02248618 zeroed +15 after storing +14, so that store goes
*/
.org 0x02248642
strh r0, [r5, #14]

.org 0x0224864C
nop

// readers: ldrb -> ldrh, same registers
.org 0x0224785E
ldrh r0, [r1, #14]

.org 0x022478DA
ldrh r0, [r7, #14]

.org 0x02247932
ldrh r0, [r6, #14]

.org 0x022479A0
ldrh r0, [r6, #14]

.org 0x02247A58
ldrh r0, [r7, #14]

.org 0x0224815E
ldrh r1, [r1, #14]

.org 0x0224819A
ldrh r0, [r2, #14]

.org 0x02248200
ldrh r0, [r0, #14]

.org 0x022485BE
ldrh r0, [r2, #14]

.close
