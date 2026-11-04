.nds
.thumb

.open "base/arm9.bin", 0x02000000

.if NO_PARTNER_DOUBLE_BATTLES == 1

// fix for special intros being overwritten with the double battle intro
.org 0x02000000 + 0x51779
.byte 0xE0  // Overwrite with 'B' opcode in THUMB

// modify the double battle flag check to immediately return with the original value instead of forcing 0 or 1
.org 0x02000000 + 0x40508
.hword 0xBD08  // word write: pop {r3, r4, pc}

// trainer sight check: battle types 2 and 3 (any double) take the pair branch, which is the only one that refuses when fewer than 2 healthy Pokemon (r4 == 0)
.org 0x02000000 + 0x640EE
.byte 0x02  // cmp r0, #2
.org 0x02000000 + 0x640EE + 3
.byte 0xD2  // bcs (branch to the pair branch for values >= 2)

// pair branch: refuse with fewer than 2 healthy Pokemon, walk as a pair only for value of 2, send value 3 down the single walk
.org 0x02000000 + 0x64172
.hword 0x2C00  // cmp r4, #0
.hword 0xD035  // beq 0x020641E2 (return 0)
.hword 0x2802  // cmp r0, #2
.hword 0xD1BB  // bne 0x020640F2 (single walk)
.hword 0xE001  // b 0x02064180 (pair walk)

// patch for the double battle text box to only appear for value of 2
.org 0x02000000 + 0x497A4
.hword 0x46C0  // mov r8 -> r0
.hword 0x2802  // cmp r0, #2
.org 0x02000000 + 0x497A4 + 5
.byte 0xD0  // beq

// single and no-partner trainers share a message branch; give its "only one Pokemon" message the double one-Pokemon text type (6)
.org 0x02000000 + 0x497AE
.hword 0x2206  // movs r2, #6

.else


.org 0x02000000 + 0x51779
.byte 0xD0

.org 0x02000000 + 0x40508
.hword 0x2800

.org 0x02000000 + 0x640EE
.byte 0x00
.org 0x02000000 + 0x640EE + 3
.byte 0xD1

.org 0x02000000 + 0x64172
.hword 0x2801
.hword 0xD133
.hword 0x2C00
.hword 0xD102
.hword 0xB016

.org 0x02000000 + 0x497A4
.hword 0x0400
.hword 0x0C00
.org 0x02000000 + 0x497A4 + 5
.byte 0xD1

.org 0x02000000 + 0x497AE
.hword 0x1C02


.endif

.close
