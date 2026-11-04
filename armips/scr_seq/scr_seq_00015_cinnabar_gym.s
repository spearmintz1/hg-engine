.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Cinnabar Gym (Blaine, Volcano Badge); no map header

.create "build/a012/2_015", 0


scrdef scr_seq_0015_000
scrdef scr_seq_0015_001
scrdef scr_seq_0015_002
scrdef scr_seq_0015_003
scrdef scr_seq_0015_004
scrdef scr_seq_0015_005
scrdef scr_seq_0015_006
scrdef scr_seq_0015_007
scrdef scr_seq_0015_008
scrdef scr_seq_0015_009
scrdef_end

scr_seq_0015_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 14, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0015_0306
    npc_msg 0
    closemsg
    trainer_battle 259, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    give_badge 14
    addvar VAR_UNK_4135, 1
    setflag FLAG_UNK_265
    setflag FLAG_HIDE_ROUTE_19_WORKMEN_CLOSED
    clearflag FLAG_HIDE_ROUTE_19_WORKMEN_OPEN
    add_special_game_stat 22
    setflag FLAG_UNK_13F
    setflag FLAG_UNK_140
    setflag FLAG_UNK_13C
    setvar VAR_UNK_416F, 90
    npc_msg 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    goto scr_seq_0015_0322

scr_seq_0015_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 14, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0015_0359
    npc_msg 24
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_13B, scr_seq_0015_0364
    npc_msg 6
    closemsg
    trainer_battle 689, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 8
    closemsg
    apply_movement 5, scr_seq_0015_047A
    wait_movement
    setflag FLAG_UNK_13B
    releaseall
    end

scr_seq_0015_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_13C, scr_seq_0015_036F
    npc_msg 9
    closemsg
    trainer_battle 690, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 11
    closemsg
    get_player_facing VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0015_037A
    apply_movement 6, scr_seq_0015_0486
    goto scr_seq_0015_038C

scr_seq_0015_004:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_13D, scr_seq_0015_0396
    npc_msg 12
    closemsg
    trainer_battle 691, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 14
    closemsg
    apply_movement 7, scr_seq_0015_0492
    wait_movement
    setflag FLAG_UNK_13D
    releaseall
    end

scr_seq_0015_005:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_13E, scr_seq_0015_03A1
    npc_msg 15
    closemsg
    trainer_battle 692, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 17
    closemsg
    apply_movement 2, scr_seq_0015_049E
    wait_movement
    setflag FLAG_UNK_13E
    releaseall
    end

scr_seq_0015_006:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_13F, scr_seq_0015_03AC
    npc_msg 18
    closemsg
    trainer_battle 693, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 20
    closemsg
    get_player_facing VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 3
    goto_if_ne scr_seq_0015_03B7
    apply_movement 3, scr_seq_0015_04AA
    goto scr_seq_0015_03C9

scr_seq_0015_007:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_140, scr_seq_0015_03D3
    npc_msg 21
    closemsg
    trainer_battle 694, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0015_031C
    npc_msg 23
    closemsg
    get_player_facing VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 2
    goto_if_ne scr_seq_0015_03DE
    apply_movement 4, scr_seq_0015_04B6
    goto scr_seq_0015_03F0

scr_seq_0015_008:
    call_if_set FLAG_UNK_13B, scr_seq_0015_03FA
    call_if_set FLAG_UNK_13D, scr_seq_0015_0408
    call_if_set FLAG_UNK_13E, scr_seq_0015_0416
    end

scr_seq_0015_009:
    get_phone_book_rematch 30, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0015_0424
    check_registered_phone_number 30, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0015_042A
    check_badge 15, VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 1
    goto_if_eq scr_seq_0015_0445
    clearflag FLAG_UNK_2F5
    end

scr_seq_0015_0306:
    goto_if_unset FLAG_GOT_TM50_FROM_BLAINE, scr_seq_0015_0322
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_031C:
    white_out
    releaseall
    end

scr_seq_0015_0322:
    goto_if_no_item_space ITEM_TM50, 1, scr_seq_0015_0460
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM50_FROM_BLAINE
    buffer_players_name 0
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_0359:
    npc_msg 25
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_0364:
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_036F:
    npc_msg 10
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_037A:
    apply_movement 6, scr_seq_0015_04C2
    wait_movement
    setflag FLAG_UNK_13C
    releaseall
    end

scr_seq_0015_038C:
    wait_movement
    setflag FLAG_UNK_13C
    releaseall
    end

scr_seq_0015_0396:
    npc_msg 13
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_03A1:
    npc_msg 16
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_03AC:
    npc_msg 19
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_03B7:
    apply_movement 3, scr_seq_0015_04CE
    wait_movement
    setflag FLAG_UNK_13F
    releaseall
    end

scr_seq_0015_03C9:
    wait_movement
    setflag FLAG_UNK_13F
    releaseall
    end

scr_seq_0015_03D3:
    npc_msg 22
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0015_03DE:
    apply_movement 4, scr_seq_0015_04DA
    wait_movement
    setflag FLAG_UNK_140
    releaseall
    end

scr_seq_0015_03F0:
    wait_movement
    setflag FLAG_UNK_140
    releaseall
    end

scr_seq_0015_03FA:
    move_person_facing 5, 21, 0, 14, 2
    return

scr_seq_0015_0408:
    move_person_facing 7, 9, 0, 13, 0
    return

scr_seq_0015_0416:
    move_person_facing 2, 15, 0, 16, 1
    return

scr_seq_0015_0424:
    setflag FLAG_UNK_2F5
    end

scr_seq_0015_042A:
    get_weekday VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 4
    goto_if_ne scr_seq_0015_046A
    setflag FLAG_UNK_2F5
    goto scr_seq_0015_0470

scr_seq_0015_0445:
    get_weekday VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 2
    goto_if_ne scr_seq_0015_0472
    setflag FLAG_UNK_2F5
    goto scr_seq_0015_0478

scr_seq_0015_0460:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0015_046A:
    clearflag FLAG_UNK_2F5
    end

scr_seq_0015_0470:
    end

scr_seq_0015_0472:
    clearflag FLAG_UNK_2F5
    end

scr_seq_0015_0478:
    end

    .align 2
scr_seq_0015_047A:
    step 15, 1
    step 2, 1
    step_end
scr_seq_0015_0486:
    step 12, 1
    step 1, 1
    step_end
scr_seq_0015_0492:
    step 13, 1
    step 0, 1
    step_end
scr_seq_0015_049E:
    step 12, 1
    step 1, 1
    step_end
scr_seq_0015_04AA:
    step 15, 1
    step 2, 1
    step_end
scr_seq_0015_04B6:
    step 14, 1
    step 3, 1
    step_end
scr_seq_0015_04C2:
    step 13, 1
    step 0, 1
    step_end
scr_seq_0015_04CE:
    step 14, 1
    step 3, 1
    step_end
scr_seq_0015_04DA:
    step 15, 1
    step 2, 1
    step_end

.close
