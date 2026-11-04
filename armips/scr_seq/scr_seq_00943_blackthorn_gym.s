.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Blackthorn City Gym (Clair, header 115)

.create "build/a012/2_943", 0


scrdef scr_seq_0943_000
scrdef scr_seq_0943_001
scrdef scr_seq_0943_002
scrdef scr_seq_0943_003
scrdef scr_seq_0943_004
scrdef scr_seq_0943_005
scrdef_end

scr_seq_0943_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_0EA, scr_seq_0943_017F
    goto_if_set FLAG_UNK_0D1, scr_seq_0943_01C4
    npc_msg 3
    closemsg
    trainer_battle 35, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0943_01CF
    settrainerflag 110
    settrainerflag 112
    settrainerflag 111
    settrainerflag 119
    settrainerflag 117
    add_special_game_stat 22
    setflag FLAG_UNK_0D1
    setflag FLAG_HIDE_BLACKTHORN_DEN_GUARD_INFRONT
    clearflag FLAG_HIDE_BLACKTHRON_DEN_GUARD_ASIDE
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_416F, 55
    releaseall
    end

scr_seq_0943_001:
    blackthorn_gym_init
    setvar VAR_UNK_4120, 0
    get_phone_book_rematch 27, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0943_01D5
    compare VAR_UNK_40FC, 2
    goto_if_ge scr_seq_0943_01DB
    end

scr_seq_0943_002:
    scrcmd_609
    lockall
    play_se SEQ_SE_DP_GYURU
    apply_movement obj_player, scr_seq_0943_03D8
    wait_movement
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 141, 0, 8, 83, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0943_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_UNK_0D1, scr_seq_0943_0209
    npc_msg 0
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4120, 1
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_004:
    scrcmd_609
    lockall
    goto_if_set FLAG_UNK_138, scr_seq_0943_0214
    get_player_coords VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4000, 12
    goto_if_ne scr_seq_0943_0231
    apply_movement 6, scr_seq_0943_0420
    apply_movement obj_player, scr_seq_0943_0430
    goto scr_seq_0943_0254

scr_seq_0943_005:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 7, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0943_027A
    npc_msg 10
    goto scr_seq_0943_0285

scr_seq_0943_017F:
    goto_if_set FLAG_GOT_TM59_FROM_CLAIR, scr_seq_0943_028D
    npc_msg 6
    goto_if_no_item_space ITEM_TM59, 1, scr_seq_0943_0298
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM59_FROM_CLAIR
    npc_msg 7
    npc_msg 9
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_01C4:
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_01CF:
    white_out
    releaseall
    end

scr_seq_0943_01D5:
    setflag FLAG_UNK_2EF
    end

scr_seq_0943_01DB:
    check_registered_phone_number 27, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0943_02A3
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0943_02BE
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_02D5

scr_seq_0943_0209:
    npc_msg 1
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_0214:
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4120, 1
    setvar VAR_UNK_4120, 1
    releaseall
    end

scr_seq_0943_0231:
    compare VAR_TEMP_x4000, 13
    goto_if_ne scr_seq_0943_02D7
    apply_movement 6, scr_seq_0943_043C
    apply_movement obj_player, scr_seq_0943_044C
    goto scr_seq_0943_0254

scr_seq_0943_0254:
    wait_movement
    npc_msg 2
    closemsg
    setflag FLAG_UNK_138
    compare VAR_TEMP_x4000, 12
    goto_if_ne scr_seq_0943_030D
    apply_movement 6, scr_seq_0943_0458
    goto scr_seq_0943_0328

scr_seq_0943_027A:
    npc_msg 11
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_0285:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_028D:
    npc_msg 9
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_0298:
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0943_02A3:
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 16
    goto_if_ne scr_seq_0943_0347
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_035E

scr_seq_0943_02BE:
    compare VAR_TEMP_x4000, 7
    goto_if_ne scr_seq_0943_0360
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_02D5

scr_seq_0943_02D5:
    end

scr_seq_0943_02D7:
    apply_movement 6, scr_seq_0943_0464
    apply_movement obj_player, scr_seq_0943_0470
    wait_movement
    npc_msg 2
    closemsg
    setflag FLAG_UNK_138
    compare VAR_TEMP_x4000, 12
    goto_if_ne scr_seq_0943_030D
    apply_movement 6, scr_seq_0943_0458
    goto scr_seq_0943_0328

scr_seq_0943_030D:
    compare VAR_TEMP_x4000, 13
    goto_if_ne scr_seq_0943_0377
    apply_movement 6, scr_seq_0943_047C
    goto scr_seq_0943_0328

scr_seq_0943_0328:
    wait_movement
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4120, 1
    setvar VAR_UNK_4120, 1
    releaseall
    end

scr_seq_0943_0347:
    compare VAR_TEMP_x4000, 17
    goto_if_ne scr_seq_0943_039E
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_035E

scr_seq_0943_035E:
    end

scr_seq_0943_0360:
    compare VAR_TEMP_x4000, 8
    goto_if_ne scr_seq_0943_03B5
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_02D5

scr_seq_0943_0377:
    apply_movement 6, scr_seq_0943_0488
    wait_movement
    scrcmd_600
    set_follow_poke_inhibit_state 1
    scrcmd_607
    scrcmd_109 253, 56
    setvar VAR_UNK_4120, 1
    setvar VAR_UNK_4120, 1
    releaseall
    end

scr_seq_0943_039E:
    compare VAR_TEMP_x4000, 18
    goto_if_ne scr_seq_0943_03CC
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_035E

scr_seq_0943_03B5:
    compare VAR_TEMP_x4000, 9
    goto_if_ne scr_seq_0943_03D2
    setflag FLAG_UNK_2EF
    goto scr_seq_0943_02D5

scr_seq_0943_03CC:
    clearflag FLAG_UNK_2EF
    end

scr_seq_0943_03D2:
    clearflag FLAG_UNK_2EF
    end

scr_seq_0943_03D8:
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
scr_seq_0943_0420:
    step 2, 1
    step 75, 1
    step 14, 2
    step_end
scr_seq_0943_0430:
    step 63, 5
    step 3, 1
    step_end
scr_seq_0943_043C:
    step 2, 1
    step 75, 1
    step 14, 1
    step_end
scr_seq_0943_044C:
    step 63, 4
    step 3, 1
    step_end
scr_seq_0943_0458:
    step 15, 2
    step 1, 1
    step_end
scr_seq_0943_0464:
    step 2, 1
    step 75, 1
    step_end
scr_seq_0943_0470:
    step 63, 2
    step 3, 1
    step_end
scr_seq_0943_047C:
    step 15, 1
    step 1, 1
    step_end
scr_seq_0943_0488:
    step 1, 1
    step_end

.close
