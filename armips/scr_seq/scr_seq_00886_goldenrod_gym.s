.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Goldenrod City Gym (Whitney, header 111)

.create "build/a012/2_886", 0


scrdef scr_seq_0886_000
scrdef scr_seq_0886_001
scrdef scr_seq_0886_002
scrdef scr_seq_0886_003
scrdef scr_seq_0886_004
scrdef_end

scr_seq_0886_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 2, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0886_018A
    goto_if_set FLAG_UNK_0B7, scr_seq_0886_01A0
    compare VAR_UNK_410A, 1
    goto_if_eq scr_seq_0886_01F8
    npc_msg 0
    closemsg
    trainer_battle 30, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0886_021B
    settrainerflag 22
    settrainerflag 71
    settrainerflag 5
    settrainerflag 70
    add_special_game_stat 22
    move_person_facing 1, 13, 0, 15, 0
    npc_msg 2
    wait_button_or_walk_away
    closemsg
    releaseall
    setvar VAR_UNK_410A, 1
    setflag FLAG_UNK_084
    setvar VAR_UNK_40DA, 1
    clearflag FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_UNLOCKED
    setflag FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_LOCKED
    setvar VAR_UNK_416F, 27
    end

scr_seq_0886_001:
    scrcmd_609
    lockall
    apply_movement 1, scr_seq_0886_0328
    wait_movement
    npc_msg 9
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement 1, scr_seq_0886_0334
    apply_movement obj_player, scr_seq_0886_0340
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    setflag FLAG_UNK_0B7
    releaseall
    end

scr_seq_0886_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 2, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0886_0221
    npc_msg 10
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0886_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 2, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0886_022C
    npc_msg 12
    goto scr_seq_0886_0237

scr_seq_0886_004:
    get_phone_book_rematch 17, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0886_023F
    goto_if_unset FLAG_GAME_CLEAR, scr_seq_0886_0245
    check_registered_phone_number 17, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0886_024B
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 12
    goto_if_ne scr_seq_0886_0266
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_027D

scr_seq_0886_018A:
    goto_if_unset FLAG_GOT_TM45_FROM_WHITNEY, scr_seq_0886_027F
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0886_01A0:
    npc_msg 3
    buffer_players_name 0
    npc_msg 4
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    give_badge 2
    setvar VAR_UNK_410A, 2
    clearflag FLAG_UNK_084
    setflag FLAG_UNK_998
    npc_msg 5
    goto_if_no_item_space ITEM_TM45, 1, scr_seq_0886_02B3
    callstd std_give_item_verbose
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    setflag FLAG_GOT_TM45_FROM_WHITNEY
    releaseall
    end

scr_seq_0886_01F8:
    npc_msg 2
    wait_button_or_walk_away
    closemsg
    releaseall
    setvar VAR_UNK_410A, 1
    setflag FLAG_UNK_084
    setvar VAR_UNK_40DA, 1
    clearflag FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_UNLOCKED
    setflag FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_LOCKED
    end

scr_seq_0886_021B:
    white_out
    releaseall
    end

scr_seq_0886_0221:
    npc_msg 11
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0886_022C:
    npc_msg 13
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0886_0237:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0886_023F:
    setflag FLAG_UNK_2EC
    end

scr_seq_0886_0245:
    clearflag FLAG_UNK_2EC
    end

scr_seq_0886_024B:
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 18
    goto_if_ne scr_seq_0886_02BD
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_02D4

scr_seq_0886_0266:
    compare VAR_TEMP_x4000, 13
    goto_if_ne scr_seq_0886_02D6
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_027D

scr_seq_0886_027D:
    end

scr_seq_0886_027F:
    goto_if_no_item_space ITEM_TM45, 1, scr_seq_0886_02B3
    callstd std_give_item_verbose
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    setflag FLAG_GOT_TM45_FROM_WHITNEY
    releaseall
    end

scr_seq_0886_02B3:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0886_02BD:
    compare VAR_TEMP_x4000, 19
    goto_if_ne scr_seq_0886_02ED
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_02D4

scr_seq_0886_02D4:
    end

scr_seq_0886_02D6:
    compare VAR_TEMP_x4000, 14
    goto_if_ne scr_seq_0886_0304
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_027D

scr_seq_0886_02ED:
    compare VAR_TEMP_x4000, 20
    goto_if_ne scr_seq_0886_031B
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_02D4

scr_seq_0886_0304:
    compare VAR_TEMP_x4000, 15
    goto_if_ne scr_seq_0886_0321
    setflag FLAG_UNK_2EC
    goto scr_seq_0886_027D

scr_seq_0886_031B:
    goto scr_seq_0886_0245

scr_seq_0886_0321:
    goto scr_seq_0886_0245

    .align 2
scr_seq_0886_0328:
    step 75, 1
    step 12, 3
    step_end
scr_seq_0886_0334:
    step 13, 3
    step 32, 1
    step_end
scr_seq_0886_0340:
    step 63, 1
    step 12, 1
    step_end

.close
