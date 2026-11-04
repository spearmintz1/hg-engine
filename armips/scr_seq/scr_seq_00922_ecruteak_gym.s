.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Ecruteak City Gym (Morty, header 54)

.create "build/a012/2_922", 0


scrdef scr_seq_0922_000
scrdef scr_seq_0922_001
scrdef scr_seq_0922_002
scrdef scr_seq_0922_003
scrdef scr_seq_0922_004
scrdef scr_seq_0922_005
scrdef_end

scr_seq_0922_000:
    ecruteak_gym_init
    get_phone_book_rematch 37, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0922_01AB
    goto_if_unset FLAG_GAME_CLEAR, scr_seq_0922_01B1
    check_registered_phone_number 37, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0922_01B7
    get_weekday VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 1
    goto_if_ne scr_seq_0922_01D2
    setflag FLAG_UNK_2ED
    goto scr_seq_0922_01E9

scr_seq_0922_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 3, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0922_01EB
    npc_msg 0
    closemsg
    trainer_battle 31, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0922_0201
    npc_msg 1
    give_badge 3
    addvar VAR_UNK_4134, 1
    add_special_game_stat 22
    setflag FLAG_UNK_998
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    setvar VAR_UNK_416F, 35
    goto scr_seq_0922_0207

scr_seq_0922_002:
    scrcmd_609
    lockall
    play_se SEQ_SE_DP_GYURU
    apply_movement obj_player, scr_seq_0922_0274
    wait_movement
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 80, 0, 16, 49, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0922_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 3, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0922_023B
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_004:
    scrcmd_609
    lockall
    apply_movement 6, scr_seq_0922_02BC
    wait_movement
    npc_msg 9
    closemsg
    apply_movement 6, scr_seq_0922_02CC
    apply_movement obj_player, scr_seq_0922_02DC
    wait_movement
    setvar VAR_UNK_4079, 1
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 78, 7, 376, 182, 1
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0922_005:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 3, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0922_0249
    npc_msg 10
    goto scr_seq_0922_0254

scr_seq_0922_01AB:
    setflag FLAG_UNK_2ED
    end

scr_seq_0922_01B1:
    clearflag FLAG_UNK_2ED
    end

scr_seq_0922_01B7:
    get_weekday VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0922_025C
    setflag FLAG_UNK_2ED
    goto scr_seq_0922_0262

scr_seq_0922_01D2:
    compare VAR_TEMP_x4000, 2
    goto_if_ne scr_seq_0922_0264
    setflag FLAG_UNK_2ED
    goto scr_seq_0922_01E9

scr_seq_0922_01E9:
    end

scr_seq_0922_01EB:
    goto_if_unset FLAG_GOT_TM30_FROM_MORTY, scr_seq_0922_0207
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_0201:
    white_out
    releaseall
    end

scr_seq_0922_0207:
    goto_if_no_item_space ITEM_TM30, 1, scr_seq_0922_026A
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM30_FROM_MORTY
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_023B:
    buffer_players_name 0
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_0249:
    npc_msg 11
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_0254:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0922_025C:
    clearflag FLAG_UNK_2ED
    end

scr_seq_0922_0262:
    end

scr_seq_0922_0264:
    clearflag FLAG_UNK_2ED
    end

scr_seq_0922_026A:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

    .align 2
scr_seq_0922_0274:
    step 1, 2
    step 2, 2
    step 0, 2
    step 3, 2
    step 1, 2
    step 2, 2
    step 0, 2
    step 3, 2
    step 1, 2
    step 2, 2
    step 0, 2
    step 3, 2
    step 1, 2
    step 2, 2
    step 0, 2
    step 3, 1
    step 69, 0
    step_end
scr_seq_0922_02BC:
    step 75, 1
    step 13, 3
    step 63, 1
    step_end
scr_seq_0922_02CC:
    step 9, 1
    step 71, 1
    step 12, 1
    step_end
scr_seq_0922_02DC:
    step 63, 1
    step 13, 1
    step 63, 1
    step_end

.close
