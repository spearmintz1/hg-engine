.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// New Bark Town, player's house 1F (header 37)

.create "build/a012/2_845", 0


scrdef scr_seq_0845_000
scrdef scr_seq_0845_001
scrdef scr_seq_0845_002
scrdef scr_seq_0845_003
scrdef scr_seq_0845_004
scrdef scr_seq_0845_005
scrdef scr_seq_0845_006
scrdef_end

scr_seq_0845_000:
    scrcmd_609
    lockall
    apply_movement obj_player, scr_seq_0845_0490
    apply_movement 0, scr_seq_0845_049C
    wait_movement
    callstd std_play_mom_music
    wait 30, VAR_SPECIAL_RESULT
    apply_movement 0, scr_seq_0845_04A4
    wait_movement
    buffer_players_name 0
    gender_msgbox 0, 1
    setflag FLAG_GOT_BAG
    play_fanfare SEQ_SE_PL_KIRAKIRA
    wait_fanfare
    npc_msg 2
    setflag FLAG_GOT_TRAINER_CARD
    play_fanfare SEQ_SE_PL_KIRAKIRA
    wait_fanfare
    npc_msg 3
    setflag FLAG_GOT_SAVE_BUTTON
    play_fanfare SEQ_SE_PL_KIRAKIRA
    wait_fanfare
    npc_msg 4
    setflag FLAG_GOT_OPTIONS_BUTTON
    play_fanfare SEQ_SE_PL_KIRAKIRA
    wait_fanfare
    npc_msg 5
    closemsg
    wait 15, VAR_SPECIAL_RESULT
    apply_movement 0, scr_seq_0845_04B4
    wait_movement
    callstd std_fade_end_mom_music
    setvar VAR_SCENE_PLAYERS_HOUSE_1F, 1
    setvar VAR_UNK_416F, 13
    releaseall
    end

scr_seq_0845_001:
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0845_0173
    compare VAR_SCENE_ELMS_LAB, 4
    goto_if_ge scr_seq_0845_018E
    goto_if_set FLAG_GOT_STARTER, scr_seq_0845_01BD
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 35
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 36
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_004:
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 37
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_005:
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 38
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_006:
    scrcmd_609
    lockall
    apply_movement obj_player, scr_seq_0845_0490
    apply_movement 0, scr_seq_0845_049C
    wait_movement
    callstd std_play_mom_music
    wait 30, VAR_SPECIAL_RESULT
    apply_movement 0, scr_seq_0845_04A4
    wait_movement
    buffer_players_name 0
    npc_msg 33
    closemsg
    apply_movement 0, scr_seq_0845_04B4
    wait_movement
    callstd std_fade_end_mom_music
    setvar VAR_SCENE_PLAYERS_HOUSE_1F, 4
    setvar VAR_UNK_416F, 100
    releaseall
    end

scr_seq_0845_0173:
    hasitem ITEM_SS_TICKET, 1, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0845_020A
    goto scr_seq_0845_018E

scr_seq_0845_018E:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_TALKED_TO_MOM_AFTER_NAMING_RIVAL, scr_seq_0845_021D
    check_badge 0, VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 0
    goto_if_ne scr_seq_0845_0285
    npc_msg 15
    goto scr_seq_0845_02B7

scr_seq_0845_01BD:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_GOT_POKEGEAR, scr_seq_0845_02E3
    buffer_players_name 0
    npc_msg 7
    buffer_players_name 0
    npc_msg 8
    setflag FLAG_GOT_POKEGEAR
    play_fanfare SEQ_ME_ITEM
    wait_fanfare
    npc_msg 9
    npc_msg 10
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0845_02EE
    npc_msg 11
    goto scr_seq_0845_02FC

scr_seq_0845_020A:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    npc_msg 34
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_021D:
    npc_msg 20
    scrcmd_795 1, 1
    touchscreen_menu_hide
    menu_init 1, 1, 0, 1, VAR_SPECIAL_RESULT
    menu_item_add 29, 255, 0
    menu_item_add 30, 255, 1
    menu_item_add 31, 255, 2
    menu_item_add 32, 255, 3
    menu_exec
    copyvar VAR_SPECIAL_x8008, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_x8008, 0
    goto_if_eq scr_seq_0845_0307
    compare VAR_SPECIAL_x8008, 1
    goto_if_eq scr_seq_0845_035D
    compare VAR_SPECIAL_x8008, 2
    goto_if_eq scr_seq_0845_03B1
    goto scr_seq_0845_03DB

scr_seq_0845_0285:
    buffer_players_name 0
    npc_msg 16
    setflag FLAG_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    setvar VAR_SCENE_ROUTE_30_PHONE_CALL, 0
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0845_03EA
    npc_msg 17
    setflag FLAG_SYS_MOMS_SAVINGS
    goto scr_seq_0845_03F9

scr_seq_0845_02B7:
    setflag FLAG_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    setvar VAR_SCENE_ROUTE_30_PHONE_CALL, 0
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0845_03EA
    npc_msg 17
    setflag FLAG_SYS_MOMS_SAVINGS
    goto scr_seq_0845_03F9

scr_seq_0845_02E3:
    npc_msg 14
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_02EE:
    npc_msg 12
    npc_msg 13
    wait_button_or_dpad
    closemsg
    releaseall
    end

scr_seq_0845_02FC:
    npc_msg 13
    wait_button_or_dpad
    closemsg
    releaseall
    end

scr_seq_0845_0307:
    bank_or_wallet_is_full 1, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0845_0401
    check_bank_balance VAR_SPECIAL_RESULT, 1
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0845_0410
    bank_transaction 1, VAR_SPECIAL_RESULT
    scrcmd_796
    touchscreen_menu_show
    copyvar VAR_SPECIAL_x8008, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_x8008, 0
    goto_if_eq scr_seq_0845_041F
    compare VAR_SPECIAL_x8008, 1
    goto_if_eq scr_seq_0845_0439
    releaseall
    end

scr_seq_0845_035D:
    bank_or_wallet_is_full 0, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0845_0444
    hasenoughmoneyvar VAR_SPECIAL_RESULT, 1
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0845_0453
    bank_transaction 0, VAR_SPECIAL_RESULT
    scrcmd_796
    touchscreen_menu_show
    copyvar VAR_SPECIAL_x8008, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_x8008, 0
    goto_if_eq scr_seq_0845_0462
    compare VAR_SPECIAL_x8008, 1
    goto_if_eq scr_seq_0845_0439
    releaseall
    end

scr_seq_0845_03B1:
    npc_msg 25
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    scrcmd_796
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0845_0479
    buffer_players_name 0
    npc_msg 17
    setflag FLAG_SYS_MOMS_SAVINGS
    goto scr_seq_0845_0488

scr_seq_0845_03DB:
    scrcmd_796
    touchscreen_menu_show
    npc_msg 21
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_03EA:
    npc_msg 18
    clearflag FLAG_SYS_MOMS_SAVINGS
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_03F9:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0401:
    touchscreen_menu_show
    scrcmd_796
    npc_msg 28
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0410:
    touchscreen_menu_show
    scrcmd_796
    npc_msg 22
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_041F:
    closemsg
    wait 8, VAR_SPECIAL_RESULT
    play_se SEQ_SE_GS_OKOZUKAI
    buffer_players_name 0
    npc_msg 24
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0439:
    npc_msg 21
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0444:
    touchscreen_menu_show
    scrcmd_796
    npc_msg 27
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0453:
    touchscreen_menu_show
    scrcmd_796
    npc_msg 26
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0462:
    closemsg
    wait 8, VAR_SPECIAL_RESULT
    play_se SEQ_SE_GS_OKOZUKAI
    npc_msg 23
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0479:
    npc_msg 18
    clearflag FLAG_SYS_MOMS_SAVINGS
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0488:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0845_0490:
    step 62, 1
    step 33, 1
    step_end
scr_seq_0845_049C:
    step 32, 1
    step_end
scr_seq_0845_04A4:
    step 12, 2
    step 14, 3
    step 12, 1
    step_end
scr_seq_0845_04B4:
    step 33, 1
    step 13, 3
    step 15, 3
    step 32, 1
    step_end

.close
