.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Viridian Gym (Blue, Earth Badge); no map header

.create "build/a012/2_743", 0


scrdef scr_seq_0743_000
scrdef scr_seq_0743_001
scrdef scr_seq_0743_002
scrdef scr_seq_0743_003
scrdef scr_seq_0743_004
scrdef_end

scr_seq_0743_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 15, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0743_017C
    npc_msg 0
    closemsg
    trainer_battle 261, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0743_0192
    give_badge 15
    addvar VAR_UNK_4135, 1
    setflag FLAG_UNK_998
    add_special_game_stat 22
    settrainerflag 681
    settrainerflag 683
    settrainerflag 682
    settrainerflag 684
    setflag FLAG_UNK_97F
    clearflag FLAG_HIDE_ROUTE_10_ZAPDOS
    setflag FLAG_UNK_30F
    setvar VAR_UNK_4096, 1
    setvar VAR_UNK_416F, 100
    npc_msg 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    goto scr_seq_0743_0198

scr_seq_0743_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 15, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0743_01CF
    npc_msg 6
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4127, 1
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_002:
    viridian_gym_init
    setvar VAR_UNK_4127, 0
    get_phone_book_rematch 31, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0743_01DA
    compare VAR_UNK_40FD, 0
    goto_if_eq scr_seq_0743_01E0
    get_weekday VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 5
    goto_if_ne scr_seq_0743_01E6
    setflag FLAG_UNK_2F6
    goto scr_seq_0743_01EC

scr_seq_0743_003:
    scrcmd_609
    lockall
    goto_if_set FLAG_UNK_13A, scr_seq_0743_01EE
    get_player_coords VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4000, 1
    goto_if_ne scr_seq_0743_0205
    apply_movement 4, scr_seq_0743_042C
    apply_movement obj_player, scr_seq_0743_043C
    goto scr_seq_0743_0228

scr_seq_0743_004:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 15, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0743_024E
    npc_msg 9
    goto scr_seq_0743_0259

scr_seq_0743_017C:
    goto_if_unset FLAG_GOT_TM92_FROM_BLUE, scr_seq_0743_0198
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_0192:
    white_out
    releaseall
    end

scr_seq_0743_0198:
    goto_if_no_item_space ITEM_TM92, 1, scr_seq_0743_0261
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM92_FROM_BLUE
    buffer_players_name 0
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_01CF:
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_01DA:
    setflag FLAG_UNK_2F6
    end

scr_seq_0743_01E0:
    clearflag FLAG_UNK_2F6
    end

scr_seq_0743_01E6:
    clearflag FLAG_UNK_2F6
    end

scr_seq_0743_01EC:
    end

scr_seq_0743_01EE:
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4127, 1
    releaseall
    end

scr_seq_0743_0205:
    compare VAR_TEMP_x4000, 2
    goto_if_ne scr_seq_0743_026B
    apply_movement 4, scr_seq_0743_0448
    apply_movement obj_player, scr_seq_0743_043C
    goto scr_seq_0743_0228

scr_seq_0743_0228:
    wait_movement
    npc_msg 8
    closemsg
    setflag FLAG_UNK_13A
    compare VAR_TEMP_x4000, 1
    goto_if_ne scr_seq_0743_028E
    apply_movement 4, scr_seq_0743_0458
    goto scr_seq_0743_02A9

scr_seq_0743_024E:
    npc_msg 10
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_0259:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0743_0261:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0743_026B:
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0743_02C2
    apply_movement 4, scr_seq_0743_0464
    apply_movement obj_player, scr_seq_0743_043C
    goto scr_seq_0743_0228

scr_seq_0743_028E:
    compare VAR_TEMP_x4000, 2
    goto_if_ne scr_seq_0743_02E5
    apply_movement 4, scr_seq_0743_0474
    goto scr_seq_0743_02A9

scr_seq_0743_02A9:
    wait_movement
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4127, 1
    releaseall
    end

scr_seq_0743_02C2:
    compare VAR_TEMP_x4000, 4
    goto_if_ne scr_seq_0743_0300
    apply_movement 4, scr_seq_0743_0480
    apply_movement obj_player, scr_seq_0743_0490
    goto scr_seq_0743_0228

scr_seq_0743_02E5:
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0743_0323
    apply_movement 4, scr_seq_0743_049C
    goto scr_seq_0743_02A9

scr_seq_0743_0300:
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0743_033E
    apply_movement 4, scr_seq_0743_04A8
    apply_movement obj_player, scr_seq_0743_0490
    goto scr_seq_0743_0228

scr_seq_0743_0323:
    compare VAR_TEMP_x4000, 4
    goto_if_ne scr_seq_0743_0361
    apply_movement 4, scr_seq_0743_04B8
    goto scr_seq_0743_02A9

scr_seq_0743_033E:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0743_037C
    apply_movement 4, scr_seq_0743_04C4
    apply_movement obj_player, scr_seq_0743_0490
    goto scr_seq_0743_0228

scr_seq_0743_0361:
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0743_039F
    apply_movement 4, scr_seq_0743_04D0
    goto scr_seq_0743_02A9

scr_seq_0743_037C:
    compare VAR_TEMP_x4000, 8
    goto_if_ne scr_seq_0743_03BA
    apply_movement 4, scr_seq_0743_04DC
    apply_movement obj_player, scr_seq_0743_04E8
    goto scr_seq_0743_0228

scr_seq_0743_039F:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0743_03F0
    apply_movement 4, scr_seq_0743_04F4
    goto scr_seq_0743_02A9

scr_seq_0743_03BA:
    apply_movement 4, scr_seq_0743_04FC
    apply_movement obj_player, scr_seq_0743_04E8
    wait_movement
    npc_msg 8
    closemsg
    setflag FLAG_UNK_13A
    compare VAR_TEMP_x4000, 1
    goto_if_ne scr_seq_0743_028E
    apply_movement 4, scr_seq_0743_0458
    goto scr_seq_0743_02A9

scr_seq_0743_03F0:
    compare VAR_TEMP_x4000, 8
    goto_if_ne _040B
    apply_movement 4, scr_seq_0743_04F4
    goto scr_seq_0743_02A9

_040B:
    apply_movement 4, scr_seq_0743_050C
    wait_movement
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4127, 1
    releaseall
    end

scr_seq_0743_042C:
    step 2, 1
    step 75, 1
    step 14, 5
    step_end
scr_seq_0743_043C:
    step 65, 2
    step 3, 1
    step_end
scr_seq_0743_0448:
    step 2, 1
    step 75, 1
    step 14, 4
    step_end
scr_seq_0743_0458:
    step 15, 5
    step 1, 1
    step_end
scr_seq_0743_0464:
    step 2, 1
    step 75, 1
    step 14, 3
    step_end
scr_seq_0743_0474:
    step 15, 4
    step 1, 1
    step_end
scr_seq_0743_0480:
    step 2, 1
    step 75, 1
    step 14, 2
    step_end
scr_seq_0743_0490:
    step 63, 2
    step 3, 1
    step_end
scr_seq_0743_049C:
    step 15, 3
    step 1, 1
    step_end
scr_seq_0743_04A8:
    step 2, 1
    step 75, 1
    step 14, 1
    step_end
scr_seq_0743_04B8:
    step 15, 2
    step 1, 1
    step_end
scr_seq_0743_04C4:
    step 2, 1
    step 75, 1
    step_end
scr_seq_0743_04D0:
    step 15, 1
    step 1, 1
    step_end
scr_seq_0743_04DC:
    step 3, 1
    step 75, 1
    step_end
scr_seq_0743_04E8:
    step 63, 2
    step 2, 1
    step_end
scr_seq_0743_04F4:
    step 1, 1
    step_end
scr_seq_0743_04FC:
    step 3, 1
    step 75, 1
    step 15, 1
    step_end
scr_seq_0743_050C:
    step 14, 1
    step 1, 1
    step_end

.close
