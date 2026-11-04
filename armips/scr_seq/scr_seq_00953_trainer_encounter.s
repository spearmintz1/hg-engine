.nds
.thumb

// Overworld trainer encounter script (shared by every trainer NPC).
// NO_PARTNER_DOUBLE_BATTLES makes TrainerIsDouble return the raw battle type (0, 2 or 3) instead of 0/1,
// so the vanilla "if result != 1 skip PartyCheckForDouble" test let every double battle start with one
// healthy Pokemon. Test for "not a single battle" instead, so any double battle gets the party check.
//   trainer_is_double_battle VAR_SPECIAL_RESULT
//   compare_var_to_value VAR_SPECIAL_RESULT, 0       (was 1)
//   goto_if EQUAL, <skip party check>                (was NOT_EQUAL)

.open "build/a012/2_953", 0

// talk-to-trainer path
.org 0xBE9 + 8
.byte 0x00
.org 0xBE9 + 12
.byte 0x01

// trainer-sees-you path
.org 0xD08 + 8
.byte 0x00
.org 0xD08 + 12
.byte 0x01

.close
