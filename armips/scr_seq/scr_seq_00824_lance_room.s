.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Pokemon League, Lance (Champion) room (header 279)

.create "build/a012/2_824", 0


scrdef scr_seq_0824_000
scrdef scr_seq_0824_001
scrdef scr_seq_0824_002
scrdef_end

scr_seq_0824_000:
    scrcmd_609
    lockall
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    get_player_coords VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0824_0087
    apply_movement obj_player, scr_seq_0824_05BC
    goto scr_seq_0824_00A2

scr_seq_0824_001:
    scrcmd_609
    lockall
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0824_05CC
    wait_movement
    setvar VAR_UNK_416F, 65
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    play_se SEQ_SE_DP_KI_GASYAN
    clearflag FLAG_UNK_210
    show_person 3
    setvar VAR_UNK_40C8, 1
    releaseall
    end

scr_seq_0824_002:
    setflag FLAG_UNK_210
    setvar VAR_UNK_40C8, 0
    end

scr_seq_0824_0087:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0824_00DC
    apply_movement obj_player, scr_seq_0824_05D4
    goto scr_seq_0824_00A2

scr_seq_0824_00A2:
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    apply_movement 0, scr_seq_0824_05DC
    wait_movement
    buffer_players_name 0
    gender_msgbox 0, 1
    closemsg
    compare VAR_UNK_4135, 8
    goto_if_lt scr_seq_0824_011E
    trainer_battle 701, 0, 0, 0
    goto scr_seq_0824_01B2

scr_seq_0824_00DC:
    apply_movement obj_player, scr_seq_0824_05E4
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    apply_movement 0, scr_seq_0824_05DC
    wait_movement
    buffer_players_name 0
    gender_msgbox 0, 1
    closemsg
    compare VAR_UNK_4135, 8
    goto_if_lt scr_seq_0824_011E
    trainer_battle 701, 0, 0, 0
    goto scr_seq_0824_01B2

scr_seq_0824_011E:
    trainer_battle 244, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_023E
    buffer_players_name 0
    gender_msgbox 2, 3
    closemsg
    wait 10, VAR_SPECIAL_x8004
    play_se SEQ_SE_DP_KI_GASYAN
    hide_person 4
    move_person_facing 2, 6, 0, 20, 0
    move_person_facing 1, 6, 0, 17, 0
    wait 30, VAR_SPECIAL_x8004
    stop_bgm 0
    play_bgm 1107
    apply_movement 0, scr_seq_0824_05F4
    apply_movement obj_player, scr_seq_0824_060C
    wait_movement
    scrcmd_729 VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_0244
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0824_0333
    apply_movement obj_partner_poke, scr_seq_0824_0624
    goto scr_seq_0824_034E

scr_seq_0824_01B2:
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_023E
    buffer_players_name 0
    gender_msgbox 2, 3
    closemsg
    wait 10, VAR_SPECIAL_x8004
    play_se SEQ_SE_DP_KI_GASYAN
    hide_person 4
    move_person_facing 2, 6, 0, 20, 0
    move_person_facing 1, 6, 0, 17, 0
    wait 30, VAR_SPECIAL_x8004
    stop_bgm 0
    play_bgm 1107
    apply_movement 0, scr_seq_0824_05F4
    apply_movement obj_player, scr_seq_0824_060C
    wait_movement
    scrcmd_729 VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_0244
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0824_0333
    apply_movement obj_partner_poke, scr_seq_0824_0624
    goto scr_seq_0824_034E

scr_seq_0824_023E:
    white_out
    releaseall
    end

scr_seq_0824_0244:
    apply_movement 2, scr_seq_0824_0634
    wait_movement
    npc_msg 5
    closemsg
    apply_movement 1, scr_seq_0824_0644
    apply_movement 2, scr_seq_0824_064C
    wait_movement
    buffer_players_name 0
    gender_msgbox 6, 7
    closemsg
    apply_movement 2, scr_seq_0824_065C
    wait_movement
    npc_msg 8
    apply_movement 0, scr_seq_0824_0664
    apply_movement obj_player, scr_seq_0824_0674
    wait_movement
    buffer_players_name 0
    gender_msgbox 9, 10
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement 0, scr_seq_0824_0680
    apply_movement obj_player, scr_seq_0824_0690
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    scrcmd_729 VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_043F
    apply_movement obj_partner_poke, scr_seq_0824_06A0
    wait_movement
    play_se SEQ_SE_DP_KAIDAN2
    apply_movement 2, scr_seq_0824_06A8
    wait_movement
    npc_msg 11
    apply_movement 2, scr_seq_0824_06B8
    wait_movement
    wait_button
    closemsg
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0824_049B
    clearflag FLAG_HIDE_OLIVINE_PORT_OAK
    setvar VAR_UNK_411A, 1
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 306, 0, 6, 22, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0824_0333:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0824_04C3
    apply_movement obj_partner_poke, scr_seq_0824_06D0
    goto scr_seq_0824_034E

scr_seq_0824_034E:
    wait_movement
    apply_movement 2, scr_seq_0824_0634
    wait_movement
    npc_msg 5
    closemsg
    apply_movement 1, scr_seq_0824_0644
    apply_movement 2, scr_seq_0824_064C
    wait_movement
    buffer_players_name 0
    gender_msgbox 6, 7
    closemsg
    apply_movement 2, scr_seq_0824_065C
    wait_movement
    npc_msg 8
    apply_movement 0, scr_seq_0824_0664
    apply_movement obj_player, scr_seq_0824_0674
    wait_movement
    buffer_players_name 0
    gender_msgbox 9, 10
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement 0, scr_seq_0824_0680
    apply_movement obj_player, scr_seq_0824_0690
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    scrcmd_729 VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_043F
    apply_movement obj_partner_poke, scr_seq_0824_06A0
    wait_movement
    play_se SEQ_SE_DP_KAIDAN2
    apply_movement 2, scr_seq_0824_06A8
    wait_movement
    npc_msg 11
    apply_movement 2, scr_seq_0824_06B8
    wait_movement
    wait_button
    closemsg
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0824_049B
    clearflag FLAG_HIDE_OLIVINE_PORT_OAK
    setvar VAR_UNK_411A, 1
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 306, 0, 6, 22, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0824_043F:
    play_se SEQ_SE_DP_KAIDAN2
    apply_movement 2, scr_seq_0824_06A8
    wait_movement
    npc_msg 11
    apply_movement 2, scr_seq_0824_06B8
    wait_movement
    wait_button
    closemsg
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0824_049B
    clearflag FLAG_HIDE_OLIVINE_PORT_OAK
    setvar VAR_UNK_411A, 1
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 306, 0, 6, 22, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0824_049B:
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 306, 0, 6, 22, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0824_04C3:
    apply_movement obj_partner_poke, scr_seq_0824_06E8
    wait_movement
    apply_movement 2, scr_seq_0824_0634
    wait_movement
    npc_msg 5
    closemsg
    apply_movement 1, scr_seq_0824_0644
    apply_movement 2, scr_seq_0824_064C
    wait_movement
    buffer_players_name 0
    gender_msgbox 6, 7
    closemsg
    apply_movement 2, scr_seq_0824_065C
    wait_movement
    npc_msg 8
    apply_movement 0, scr_seq_0824_0664
    apply_movement obj_player, scr_seq_0824_0674
    wait_movement
    buffer_players_name 0
    gender_msgbox 9, 10
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement 0, scr_seq_0824_0680
    apply_movement obj_player, scr_seq_0824_0690
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    scrcmd_729 VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0824_043F
    apply_movement obj_partner_poke, scr_seq_0824_06A0
    wait_movement
    play_se SEQ_SE_DP_KAIDAN2
    apply_movement 2, scr_seq_0824_06A8
    wait_movement
    npc_msg 11
    apply_movement 2, scr_seq_0824_06B8
    wait_movement
    wait_button
    closemsg
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0824_049B
    clearflag FLAG_HIDE_OLIVINE_PORT_OAK
    setvar VAR_UNK_411A, 1
    fade_screen 6, 1, 0, 0
    wait_fade
    warp 306, 0, 6, 22, 0
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0824_05BC:
    step 12, 2
    step 15, 1
    step 32, 1
    step_end
scr_seq_0824_05CC:
    step 12, 6
    step_end
scr_seq_0824_05D4:
    step 12, 2
    step_end
scr_seq_0824_05DC:
    step 33, 1
    step_end
scr_seq_0824_05E4:
    step 12, 2
    step 14, 1
    step 32, 1
    step_end
scr_seq_0824_05F4:
    step 1, 1
    step 75, 0
    step 71, 1
    step 15, 1
    step 72, 1
    step_end
scr_seq_0824_060C:
    step 1, 1
    step 63, 4
    step 71, 1
    step 12, 2
    step 72, 1
    step_end
scr_seq_0824_0624:
    step 16, 3
    step 19, 1
    step 33, 1
    step_end
scr_seq_0824_0634:
    step 16, 12
    step 1, 1
    step 37, 3
    step_end
scr_seq_0824_0644:
    step 12, 8
    step_end
scr_seq_0824_064C:
    step 63, 6
    step 14, 1
    step 0, 1
    step_end
scr_seq_0824_065C:
    step 36, 4
    step_end
scr_seq_0824_0664:
    step 12, 2
    step 14, 1
    step 1, 1
    step_end
scr_seq_0824_0674:
    step 63, 3
    step 0, 1
    step_end
scr_seq_0824_0680:
    step 62, 1
    step 12, 2
    step 69, 1
    step_end
scr_seq_0824_0690:
    step 12, 2
    step 12, 2
    step 69, 1
    step_end
scr_seq_0824_06A0:
    step 69, 1
    step_end
scr_seq_0824_06A8:
    step 16, 4
    step 75, 0
    step 63, 2
    step_end
scr_seq_0824_06B8:
    step 19, 1
    step 18, 2
    step 19, 2
    step 18, 1
    step 0, 1
    step_end
scr_seq_0824_06D0:
    step 16, 2
    step 18, 1
    step 16, 2
    step 19, 1
    step 33, 1
    step_end
scr_seq_0824_06E8:
    step 16, 1
    step 19, 1
    step 16, 2
    step 18, 2
    step 33, 1
    step_end

.close
