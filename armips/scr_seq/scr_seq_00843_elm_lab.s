.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// New Bark Town, Elm's lab (header 35)

.create "build/a012/2_843", 0


scrdef scr_seq_0843_000
scrdef scr_seq_0843_001
scrdef scr_seq_0843_002
scrdef scr_seq_0843_003
scrdef scr_seq_0843_004
scrdef scr_seq_0843_005
scrdef scr_seq_0843_006
scrdef scr_seq_0843_007
scrdef scr_seq_0843_008
scrdef scr_seq_0843_009
scrdef scr_seq_0843_010
scrdef scr_seq_0843_011
scrdef scr_seq_0843_012
scrdef scr_seq_0843_013
scrdef scr_seq_0843_014
scrdef scr_seq_0843_015
scrdef_end

scr_seq_0843_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    compare VAR_SCENE_ELMS_LAB, 4
    call_if_ge scr_seq_0843_exp_share_catch_up
    goto_if_set FLAG_UNK_0F2, scr_seq_0843_0584
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0843_0606
    get_party_count VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0843_0630
    get_party_lead_alive VAR_TEMP_x4000
    get_partymon_species VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 172
    goto_if_ne scr_seq_0843_0630
    get_partymon_forme VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0677
    goto_if_set FLAG_UNK_072, scr_seq_0843_071C
    goto_if_set FLAG_UNK_983, scr_seq_0843_077F
    compare VAR_SCENE_ELMS_LAB, 9
    goto_if_ge scr_seq_0843_071C
    compare VAR_SCENE_ELMS_LAB, 0
    goto_if_ne scr_seq_0843_07B9
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    goto scr_seq_0843_07D7

scr_seq_0843_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    compare VAR_UNK_40FC, 3
    goto_if_eq scr_seq_0843_07DB
    compare VAR_SCENE_ELMS_LAB, 0
    goto_if_ne scr_seq_0843_07E6
    npc_msg 18
    goto scr_seq_0843_07FC

scr_seq_0843_002:
    scrcmd_609
    lockall
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0843_11CA
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    apply_movement 1, scr_seq_0843_11D6
    wait_movement
    npc_msg 23
    closemsg
    clearflag FLAG_HIDE_ELMS_LAB_FRIEND
    play_se SEQ_SE_DP_KAIDAN2
    show_person 3
    wait_se SEQ_SE_DP_KAIDAN2
    callstd std_play_friend_music
    apply_movement 3, scr_seq_0843_11DE
    apply_movement 1, scr_seq_0843_11EE
    wait_movement
    gender_msgbox 24, 25
    closemsg
    apply_movement 1, scr_seq_0843_11FA
    wait_movement
    npc_msg 26
    closemsg
    callstd std_fade_end_friend_music
    fade_screen 6, 1, 0, 0
    wait_fade
    name_rival VAR_SPECIAL_RESULT
    fade_screen 6, 1, 1, 0
    wait_fade
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0804
    apply_movement 1, scr_seq_0843_11D6
    wait_movement
    buffer_rivals_name 1
    npc_msg 27
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0959
    closemsg
    npc_msg 28
    closemsg
    apply_movement 3, scr_seq_0843_1226
    apply_movement 1, scr_seq_0843_1242
    wait_movement
    play_se SEQ_SE_DP_KAIDAN2
    hide_person 1
    wait_se SEQ_SE_DP_KAIDAN2
    apply_movement 3, scr_seq_0843_1262
    wait_movement
    buffer_players_name 0
    gender_msgbox 30, 31
    closemsg
    apply_movement 3, scr_seq_0843_1272
    wait_movement
    setflag FLAG_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    play_se SEQ_SE_DP_KAIDAN2
    hide_person 3
    wait_se SEQ_SE_DP_KAIDAN2
    setflag FLAG_HIDE_ELMS_LAB_OFFICER
    setflag FLAG_HIDE_ELMS_LAB_FRIEND
    setflag FLAG_UNK_079
    apply_movement obj_player, scr_seq_0843_1286
    wait_movement
    apply_movement 0, scr_seq_0843_128E
    wait_movement
    buffer_players_name 0
    gender_msgbox 32, 33
    closemsg
    npc_msg 34
    play_fanfare SEQ_ME_ITEM
    wait_fanfare
    setvar VAR_SPECIAL_x8004, 484
    setvar VAR_SPECIAL_x8005, 1
    takeitem VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    apply_movement 0, scr_seq_0843_1296
    wait_movement
    npc_msg 35
    closemsg
    apply_movement 0, scr_seq_0843_12AA
    wait_movement
    gender_msgbox 36, 37
    closemsg
    call scr_seq_0843_give_exp_share
    apply_movement 0, scr_seq_0843_12B2
    wait_movement
    gender_msgbox 38, 39
    closemsg
    apply_movement 0, scr_seq_0843_12C6
    wait_movement
    setflag FLAG_HIDE_ROUTE_30_BATTLERS
    clearflag FLAG_HIDE_ROUTE_30_YOUNGSTER_JOEY
    setvar VAR_SCENE_ELMS_LAB, 4
    setvar VAR_UNK_408B, 1
    clearflag FLAG_HIDE_ROUTE_29_FRIEND
    clearflag FLAG_HIDE_ROUTE_29_MARILL
    setvar VAR_SCENE_MR_POKEMONS_HOUSE, 2
    setvar VAR_SCENE_NEW_BARK_TOWN_OW, 3
    clearflag FLAG_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK
    setvar VAR_SCENE_ROUTE_30_PHONE_CALL, 1
    releaseall
    end

scr_seq_0843_003:
    scrcmd_609
    lockall
    get_player_coords VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0843_0964
    apply_movement 2, scr_seq_0843_12CE
    goto scr_seq_0843_097F

scr_seq_0843_004:
    end

scr_seq_0843_005:
    buffer_players_name 0
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 93
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_006:
    buffer_players_name 0
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 94
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_007:
    buffer_players_name 0
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 95
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_008:
    buffer_players_name 0
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 96
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_009:
    play_se SEQ_SE_DP_SELECT
    lockall
    npc_msg 97
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_010:
    get_friend_sprite VAR_OBJ_0
    goto_if_set FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE, scr_seq_0843_09F3
    compare VAR_SCENE_ELMS_LAB, 0
    goto_if_ne scr_seq_0843_0A05
    move_person_facing 0, 4, 0, 5, 1
    goto scr_seq_0843_0A24

scr_seq_0843_011:
    scrcmd_609
    lockall
    goto_if_set FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE, scr_seq_0843_0A3A
    get_player_coords VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0843_0A5F
    apply_movement obj_player, scr_seq_0843_12DE
    goto scr_seq_0843_0A7A

scr_seq_0843_012:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_set FLAG_GOT_STARTER, scr_seq_0843_0ACC
    choose_starter
    setflag FLAG_GOT_STARTER
    scrcmd_605 3, 2
    scrcmd_602 0
    scrcmd_608
    wait 10, VAR_SPECIAL_RESULT
    scrcmd_602 1
    get_partymon_species 0, VAR_TEMP_x4001
    set_starter_choice VAR_TEMP_x4001
    buffer_players_name 0
    buffer_mon_species_name 1, 0
    npc_msg 7
    play_fanfare SEQ_ME_POKEGET
    wait_fanfare
    touchscreen_menu_hide
    buffer_mon_species_name 1, 0
    npc_msg 8
    getmenuchoice VAR_SPECIAL_RESULT
    closemsg
    compare VAR_SPECIAL_RESULT, 0
    call_if_eq scr_seq_0843_0AED
    touchscreen_menu_show
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0843_12EE
    apply_movement 0, scr_seq_0843_12FE
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    npc_msg 10
    closemsg
    apply_movement 0, scr_seq_0843_1306
    wait_movement
    npc_msg 11
    closemsg
    apply_movement 0, scr_seq_0843_130E
    wait_movement
    buffer_players_name 0
    gender_msgbox 12, 13
    wait_button_or_walk_away
    closemsg
    setvar VAR_SCENE_ELMS_LAB, 1
    setvar VAR_SCENE_NEW_BARK_TOWN_OW, 1
    clearflag FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    releaseall
    end

scr_seq_0843_013:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    goto_if_unset FLAG_GOT_STARTER, scr_seq_0843_0B30
    npc_msg 92
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    closemsg
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0B3B
    fade_screen 6, 1, 0, 0
    wait_fade
    play_fanfare SEQ_ME_ASA
    heal_party
    scrcmd_436
    scrcmd_150
    wait_fanfare
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

scr_seq_0843_014:
    scrcmd_609
    lockall
    apply_movement 3, scr_seq_0843_131A
    wait_movement
    apply_movement 3, scr_seq_0843_1326
    wait_movement
    buffer_players_name 0
    gender_msgbox 58, 59
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0843_1332
    apply_movement 3, scr_seq_0843_133A
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    apply_movement 0, scr_seq_0843_128E
    wait_movement
    buffer_players_name 0
    gender_msgbox 60, 61
    setvar VAR_SPECIAL_x8004, 1
    setvar VAR_SPECIAL_x8005, 1
    hasspaceforitem VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0843_0B3F
    callstd std_bag_is_full
    goto scr_seq_0843_0BC5

scr_seq_0843_015:
    scrcmd_609
    lockall
    apply_movement 2, scr_seq_0843_134E
    wait_movement
    buffer_players_name 0
    npc_msg 56
    closemsg
    apply_movement 2, scr_seq_0843_135A
    wait_movement
    setvar VAR_UNK_40FC, 3
    releaseall
    end

scr_seq_0843_0584:
    get_party_count VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0843_0630
    get_party_lead_alive VAR_TEMP_x4000
    get_partymon_species VAR_TEMP_x4000, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 172
    goto_if_ne scr_seq_0843_0630
    get_partymon_forme VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0677
    goto_if_set FLAG_UNK_072, scr_seq_0843_071C
    goto_if_set FLAG_UNK_983, scr_seq_0843_077F
    compare VAR_SCENE_ELMS_LAB, 9
    goto_if_ge scr_seq_0843_071C
    compare VAR_SCENE_ELMS_LAB, 0
    goto_if_ne scr_seq_0843_07B9
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    goto scr_seq_0843_07D7

scr_seq_0843_0606:
    buffer_players_name 0
    gender_msgbox 71, 72
    goto_if_no_item_space ITEM_SS_TICKET, 1, scr_seq_0843_1198
    setflag FLAG_UNK_0F2
    callstd std_give_item_verbose
    buffer_players_name 0
    gender_msgbox 73, 74
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0630:
    goto_if_set FLAG_UNK_072, scr_seq_0843_071C
    goto_if_set FLAG_UNK_983, scr_seq_0843_077F
    compare VAR_SCENE_ELMS_LAB, 9
    goto_if_ge scr_seq_0843_071C
    compare VAR_SCENE_ELMS_LAB, 0
    goto_if_ne scr_seq_0843_07B9
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    goto scr_seq_0843_07D7

scr_seq_0843_0677:
    compare VAR_TEMP_x4006, 1
    goto_if_eq scr_seq_0843_0C47
    compare VAR_UNK_412F, 2
    goto_if_ge scr_seq_0843_0C58
    compare VAR_UNK_412F, 1
    goto_if_eq scr_seq_0843_0C63
    call scr_seq_0843_0C7C
    apply_movement 0, scr_seq_0843_136A
    wait_movement
    npc_msg 75
    closemsg
    apply_movement 0, scr_seq_0843_1372
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_1382
    wait_movement
    npc_msg 76
    closemsg
    apply_movement 0, scr_seq_0843_136A
    wait_movement
    npc_msg 77
    closemsg
    apply_movement 0, scr_seq_0843_1392
    wait_movement
    npc_msg 78
    closemsg
    apply_movement 0, scr_seq_0843_139E
    wait_movement
    npc_msg 79
    closemsg
    get_person_coords 0, VAR_SPECIAL_x8006, VAR_SPECIAL_x8007
    compare VAR_SPECIAL_x8006, 4
    goto_if_ne scr_seq_0843_0CC0
    apply_movement 0, scr_seq_0843_13AE
    goto scr_seq_0843_0CEC

scr_seq_0843_071C:
    check_badge 15, VAR_TEMP_x4003
    compare VAR_TEMP_x4003, 1
    goto_if_eq scr_seq_0843_0D10
    goto_if_set FLAG_UNK_0F2, scr_seq_0843_0D1F
    goto_if_set FLAG_UNK_108, scr_seq_0843_0D2E
    goto_if_set FLAG_UNK_109, scr_seq_0843_0D2E
    check_badge 7, VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 1
    goto_if_eq scr_seq_0843_0D39
    compare VAR_TEMP_x400F, 1
    goto_if_eq scr_seq_0843_0D44
    buffer_players_name 0
    gender_msgbox 98, 99
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_077F:
    get_party_lead_alive VAR_TEMP_x4000
    get_partymon_species VAR_TEMP_x4000, VAR_TEMP_x4001
    scrcmd_149 0
    compare VAR_TEMP_x4001, 175
    goto_if_eq scr_seq_0843_0D50
    compare VAR_TEMP_x4001, 176
    goto_if_eq scr_seq_0843_0D50
    compare VAR_TEMP_x4001, 468
    goto_if_eq scr_seq_0843_0D50
    goto scr_seq_0843_0D86

scr_seq_0843_07B9:
    compare VAR_SCENE_ELMS_LAB, 2
    goto_if_gt scr_seq_0843_0D99
    buffer_players_name 0
    gender_msgbox 12, 13
    wait_button_or_walk_away
    closemsg
    goto scr_seq_0843_07D7

scr_seq_0843_07D7:
    releaseall
    end

scr_seq_0843_07DB:
    npc_msg 57
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_07E6:
    compare VAR_SCENE_ELMS_LAB, 2
    goto_if_ne scr_seq_0843_0DB3
    npc_msg 22
    goto scr_seq_0843_07FC

scr_seq_0843_07FC:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0804:
    fade_screen 6, 1, 0, 0
    wait_fade
    name_rival VAR_SPECIAL_RESULT
    fade_screen 6, 1, 1, 0
    wait_fade
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0804
    apply_movement 1, scr_seq_0843_11D6
    wait_movement
    buffer_rivals_name 1
    npc_msg 27
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0959
    closemsg
    npc_msg 28
    closemsg
    apply_movement 3, scr_seq_0843_1226
    apply_movement 1, scr_seq_0843_1242
    wait_movement
    play_se SEQ_SE_DP_KAIDAN2
    hide_person 1
    wait_se SEQ_SE_DP_KAIDAN2
    apply_movement 3, scr_seq_0843_1262
    wait_movement
    buffer_players_name 0
    gender_msgbox 30, 31
    closemsg
    apply_movement 3, scr_seq_0843_1272
    wait_movement
    setflag FLAG_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    play_se SEQ_SE_DP_KAIDAN2
    hide_person 3
    wait_se SEQ_SE_DP_KAIDAN2
    setflag FLAG_HIDE_ELMS_LAB_OFFICER
    setflag FLAG_HIDE_ELMS_LAB_FRIEND
    setflag FLAG_UNK_079
    apply_movement obj_player, scr_seq_0843_1286
    wait_movement
    apply_movement 0, scr_seq_0843_128E
    wait_movement
    buffer_players_name 0
    gender_msgbox 32, 33
    closemsg
    npc_msg 34
    play_fanfare SEQ_ME_ITEM
    wait_fanfare
    setvar VAR_SPECIAL_x8004, 484
    setvar VAR_SPECIAL_x8005, 1
    takeitem VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    apply_movement 0, scr_seq_0843_1296
    wait_movement
    npc_msg 35
    closemsg
    apply_movement 0, scr_seq_0843_12AA
    wait_movement
    gender_msgbox 36, 37
    closemsg
    call scr_seq_0843_give_exp_share
    apply_movement 0, scr_seq_0843_12B2
    wait_movement
    gender_msgbox 38, 39
    closemsg
    apply_movement 0, scr_seq_0843_12C6
    wait_movement
    setflag FLAG_HIDE_ROUTE_30_BATTLERS
    clearflag FLAG_HIDE_ROUTE_30_YOUNGSTER_JOEY
    setvar VAR_SCENE_ELMS_LAB, 4
    setvar VAR_UNK_408B, 1
    clearflag FLAG_HIDE_ROUTE_29_FRIEND
    clearflag FLAG_HIDE_ROUTE_29_MARILL
    setvar VAR_SCENE_MR_POKEMONS_HOUSE, 2
    setvar VAR_SCENE_NEW_BARK_TOWN_OW, 3
    clearflag FLAG_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK
    setvar VAR_SCENE_ROUTE_30_PHONE_CALL, 1
    releaseall
    end

// saves that got past the starter scene before the Exp. Share existed, or whose bag was full then, get it when they next talk to Elm
scr_seq_0843_exp_share_catch_up:
    hasitem ITEM_EXP_SHARE, 1, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    call_if_eq scr_seq_0843_give_exp_share
    return

scr_seq_0843_give_exp_share:
    npc_msg 107
    closemsg
    goto_if_no_item_space ITEM_EXP_SHARE, 1, scr_seq_0843_exp_share_bag_full
    callstd std_give_item_verbose
    return

scr_seq_0843_exp_share_bag_full:
    callstd std_bag_is_full
    return

scr_seq_0843_0959:
    npc_msg 29
    closemsg
    goto scr_seq_0843_0804

scr_seq_0843_0964:
    compare VAR_TEMP_x4000, 4
    goto_if_ne scr_seq_0843_0DCF
    apply_movement 2, scr_seq_0843_13D2
    goto scr_seq_0843_097F

scr_seq_0843_097F:
    wait_movement
    buffer_players_name 0
    gender_msgbox 19, 20
    giveitem_no_check ITEM_MAX_REPEL, 999
    giveitem_no_check 801, 1
    giveitem_no_check 802, 1
    npc_msg 106
    giveitem_no_check 800, 1
    closemsg
    setvar VAR_SCENE_ELMS_LAB, 2
    npc_msg 21
    closemsg
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0843_0DEA
    apply_movement 2, scr_seq_0843_13E2
    goto scr_seq_0843_0E05

scr_seq_0843_09F3:
    move_person_facing 0, 4, 0, 5, 3
    goto scr_seq_0843_0A24

scr_seq_0843_0A05:
    compare VAR_SCENE_ELMS_LAB, 3
    goto_if_ne scr_seq_0843_0E0B
    move_person_facing 0, 4, 0, 5, 1
    goto scr_seq_0843_0A24

scr_seq_0843_0A24:
    scrcmd_621
    end

    move_person_facing 0, 4, 0, 5, 3
    goto scr_seq_0843_0A24

scr_seq_0843_0A3A:
    apply_movement 0, scr_seq_0843_13EE
    wait_movement
    npc_msg 6
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    apply_movement obj_player, scr_seq_0843_13FE
    wait_movement
    releaseall
    end

scr_seq_0843_0A5F:
    compare VAR_TEMP_x4000, 4
    goto_if_ne scr_seq_0843_0E46
    apply_movement obj_player, scr_seq_0843_1406
    goto scr_seq_0843_0A7A

scr_seq_0843_0A7A:
    wait_movement
    buffer_players_name 0
    gender_msgbox 0, 1
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    wait 15, VAR_SPECIAL_x8004
    play_se SEQ_SE_GS_PHONE0
    apply_movement 0, scr_seq_0843_140E
    wait_movement
    npc_msg 2
    npc_msg 3
    closemsg
    apply_movement 0, scr_seq_0843_141E
    wait_movement
    npc_msg 4
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    setflag FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    releaseall
    end

scr_seq_0843_0ACC:
    goto_if_set FLAG_GOT_TM51_FROM_FALKNER, scr_seq_0843_0E61
    goto_if_set FLAG_MET_PASSERBY_BOY, scr_seq_0843_0E6C
    npc_msg 15
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0AED:
    setvar VAR_TEMP_x4000, 0
    fade_screen 6, 1, 0, 0
    wait_fade
    nickname_input 0, VAR_TEMP_x4000
    fade_screen 6, 1, 1, 0
    wait_fade
    touchscreen_menu_hide
    bufferpartymonnick 1, 0
    npc_msg 9
    getmenuchoice VAR_SPECIAL_RESULT
    closemsg
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0843_0AED
    return

scr_seq_0843_0B30:
    npc_msg 14
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0B3B:
    releaseall
    end

scr_seq_0843_0B3F:
    callstd std_give_item_verbose
    buffer_players_name 0
    gender_msgbox 62, 63
    buffer_players_name 0
    gender_msgbox 64, 65
    closemsg
    apply_movement 3, scr_seq_0843_1426
    apply_movement obj_player, scr_seq_0843_1432
    wait_movement
    buffer_players_name 0
    gender_msgbox 67, 68
    closemsg
    apply_movement 3, scr_seq_0843_143E
    wait_movement
    hide_person 3
    setflag FLAG_HIDE_ELMS_LAB_FRIEND
    play_se SEQ_SE_DP_KAIDAN2
    wait_se SEQ_SE_DP_KAIDAN2
    apply_movement 0, scr_seq_0843_128E
    apply_movement obj_player, scr_seq_0843_144E
    wait_movement
    npc_msg 69
    wait_button_or_walk_away
    closemsg
    releaseall
    setvar VAR_SCENE_ELMS_LAB, 9
    setvar VAR_UNK_4079, 3
    setflag FLAG_UNK_23B
    clearflag FLAG_HIDE_NEW_BARK_FRIEND_2
    setvar VAR_SCENE_NEW_BARK_EAST_EXIT, 2
    setvar VAR_UNK_407B, 2
    end

scr_seq_0843_0BC5:
    buffer_players_name 0
    gender_msgbox 62, 63
    buffer_players_name 0
    gender_msgbox 64, 65
    closemsg
    apply_movement 3, scr_seq_0843_1426
    apply_movement obj_player, scr_seq_0843_1432
    wait_movement
    buffer_players_name 0
    gender_msgbox 67, 68
    closemsg
    apply_movement 3, scr_seq_0843_143E
    wait_movement
    hide_person 3
    setflag FLAG_HIDE_ELMS_LAB_FRIEND
    play_se SEQ_SE_DP_KAIDAN2
    wait_se SEQ_SE_DP_KAIDAN2
    apply_movement 0, scr_seq_0843_128E
    apply_movement obj_player, scr_seq_0843_144E
    wait_movement
    npc_msg 69
    wait_button_or_walk_away
    closemsg
    releaseall
    setvar VAR_SCENE_ELMS_LAB, 9
    setvar VAR_UNK_4079, 3
    setflag FLAG_UNK_23B
    clearflag FLAG_HIDE_NEW_BARK_FRIEND_2
    setvar VAR_SCENE_NEW_BARK_EAST_EXIT, 2
    setvar VAR_UNK_407B, 2
    end

scr_seq_0843_0C47:
    npc_msg 83
    wait_button_or_walk_away
    closemsg
    addvar VAR_TEMP_x4006, 1
    releaseall
    end

scr_seq_0843_0C58:
    npc_msg 91
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0C63:
    mon_get_friendship VAR_SPECIAL_RESULT, VAR_TEMP_x4000
    compare VAR_SPECIAL_RESULT, 220
    goto_if_ge scr_seq_0843_0E77
    goto scr_seq_0843_0630

scr_seq_0843_0C7C:
    buffer_players_name 0
    gender_msgbox 84, 85
    closemsg
    get_player_facing VAR_TEMP_x4005
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    get_person_coords 0, VAR_SPECIAL_x8006, VAR_SPECIAL_x8007
    compare VAR_TEMP_x4005, 0
    goto_if_ne scr_seq_0843_0EBC
    apply_movement obj_player, scr_seq_0843_1456
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_1462
    goto scr_seq_0843_0EE1

scr_seq_0843_0CC0:
    apply_movement 0, scr_seq_0843_1472
    wait_movement
    npc_msg 80
    closemsg
    compare VAR_SPECIAL_x8006, 4
    goto_if_ne scr_seq_0843_0EEF
    apply_movement 0, scr_seq_0843_149E
    wait_movement
    goto scr_seq_0843_0F14

scr_seq_0843_0CEC:
    wait_movement
    npc_msg 80
    closemsg
    compare VAR_SPECIAL_x8006, 4
    goto_if_ne scr_seq_0843_0EEF
    apply_movement 0, scr_seq_0843_149E
    wait_movement
    goto scr_seq_0843_0F14

scr_seq_0843_0D10:
    buffer_players_name 0
    gender_msgbox 102, 103
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0D1F:
    buffer_players_name 0
    gender_msgbox 73, 74
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0D2E:
    npc_msg 70
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0D39:
    npc_msg 69
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0D44:
    gender_msgbox 100, 101
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0D50:
    apply_movement 0, scr_seq_0843_14A6
    wait_movement
    npc_msg 46
    buffer_players_name 0
    get_game_version VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 7
    goto_if_ne scr_seq_0843_0F2F
    goto_if_unset FLAG_UNK_108, scr_seq_0843_0F44
    gender_msgbox 104, 105
    goto scr_seq_0843_0F4E

scr_seq_0843_0D86:
    buffer_players_name 0
    gender_msgbox 53, 54
    setvar VAR_TEMP_x400F, 1
    goto scr_seq_0843_071C

scr_seq_0843_0D99:
    compare VAR_SCENE_ELMS_LAB, 5
    goto_if_gt scr_seq_0843_0F54
    npc_msg 40
    wait_button_or_walk_away
    closemsg
    goto scr_seq_0843_07D7

scr_seq_0843_0DB3:
    compare VAR_SCENE_ELMS_LAB, 4
    goto_if_ne scr_seq_0843_0F72
    npc_msg 41
    setvar VAR_SCENE_ELMS_LAB, 5
    goto scr_seq_0843_07FC

scr_seq_0843_0DCF:
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0843_0F88
    apply_movement 2, scr_seq_0843_14B2
    goto scr_seq_0843_097F

scr_seq_0843_0DEA:
    compare VAR_TEMP_x4000, 4
    goto_if_ne scr_seq_0843_0FFF
    apply_movement 2, scr_seq_0843_14C2
    goto scr_seq_0843_0E05

scr_seq_0843_0E05:
    wait_movement
    releaseall
    end

scr_seq_0843_0E0B:
    compare VAR_SCENE_ELMS_LAB, 8
    goto_if_ne scr_seq_0843_0A24
    move_person_facing 0, 4, 0, 5, 1
    move_person_facing 3, 7, 0, 12, 3
    scrcmd_621
    end

    move_person_facing 0, 4, 0, 5, 3
    goto scr_seq_0843_0A24

scr_seq_0843_0E46:
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0843_101A
    apply_movement obj_player, scr_seq_0843_14CE
    goto scr_seq_0843_0A7A

scr_seq_0843_0E61:
    npc_msg 17
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0E6C:
    npc_msg 16
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_0E77:
    call scr_seq_0843_0C7C
    gender_msgbox 86, 87
    closemsg
    apply_movement 0, scr_seq_0843_1392
    wait_movement
    npc_msg 88
    closemsg
    apply_movement 0, scr_seq_0843_1372
    wait_movement
    npc_msg 89
    closemsg
    apply_movement 0, scr_seq_0843_139E
    wait_movement
    npc_msg 90
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_412F, 2
    releaseall
    end

scr_seq_0843_0EBC:
    compare VAR_TEMP_x4005, 3
    goto_if_ne scr_seq_0843_1081
    apply_movement obj_player, scr_seq_0843_14DE
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_14EE
    goto scr_seq_0843_0EE1

scr_seq_0843_0EE1:
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    return

scr_seq_0843_0EEF:
    apply_movement 0, scr_seq_0843_1502
    wait_movement
    buffer_players_name 0
    gender_msgbox 81, 82
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_412F, 1
    addvar VAR_TEMP_x4006, 1
    releaseall
    end

scr_seq_0843_0F14:
    buffer_players_name 0
    gender_msgbox 81, 82
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_412F, 1
    addvar VAR_TEMP_x4006, 1
    releaseall
    end

scr_seq_0843_0F2F:
    goto_if_unset FLAG_UNK_109, scr_seq_0843_10A6
    gender_msgbox 104, 105
    goto scr_seq_0843_10EF

scr_seq_0843_0F44:
    gender_msgbox 47, 48
    goto scr_seq_0843_10EF

scr_seq_0843_0F4E:
    goto scr_seq_0843_10EF

scr_seq_0843_0F54:
    compare VAR_SCENE_ELMS_LAB, 6
    goto_if_ne scr_seq_0843_1134
    buffer_players_name 0
    gender_msgbox 42, 43
    wait_button_or_walk_away
    closemsg
    goto scr_seq_0843_07D7

scr_seq_0843_0F72:
    compare VAR_SCENE_ELMS_LAB, 6
    goto_if_ne scr_seq_0843_1143
    npc_msg 55
    goto scr_seq_0843_07FC

scr_seq_0843_0F88:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0843_097F
    apply_movement 2, scr_seq_0843_1512
    wait_movement
    buffer_players_name 0
    gender_msgbox 19, 20
    goto_if_no_item_space ITEM_POTION, 5, scr_seq_0843_114E
    callstd std_obtain_item_verbose
    closemsg
    setvar VAR_SCENE_ELMS_LAB, 2
    npc_msg 21
    closemsg
    compare VAR_TEMP_x4000, 3
    goto_if_ne scr_seq_0843_0DEA
    apply_movement 2, scr_seq_0843_13E2
    goto scr_seq_0843_0E05

scr_seq_0843_0FFF:
    compare VAR_TEMP_x4000, 5
    goto_if_ne scr_seq_0843_1158
    apply_movement 2, scr_seq_0843_1522
    goto scr_seq_0843_0E05

scr_seq_0843_101A:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0843_0A7A
    apply_movement obj_player, scr_seq_0843_152E
    wait_movement
    buffer_players_name 0
    gender_msgbox 0, 1
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    wait 15, VAR_SPECIAL_x8004
    play_se SEQ_SE_GS_PHONE0
    apply_movement 0, scr_seq_0843_140E
    wait_movement
    npc_msg 2
    npc_msg 3
    closemsg
    apply_movement 0, scr_seq_0843_141E
    wait_movement
    npc_msg 4
    closemsg
    apply_movement 0, scr_seq_0843_11C2
    wait_movement
    setflag FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    releaseall
    end

scr_seq_0843_1081:
    compare VAR_TEMP_x4005, 2
    goto_if_ne scr_seq_0843_1173
    apply_movement obj_player, scr_seq_0843_153E
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_154E
    goto scr_seq_0843_0EE1

scr_seq_0843_10A6:
    gender_msgbox 47, 48
    goto_if_no_item_space ITEM_EVERSTONE, 1, scr_seq_0843_1198
    callstd std_give_item_verbose
    setflag FLAG_UNK_072
    setflag FLAG_GOT_EVERSTONE_FROM_ELM
    setvar VAR_TEMP_x400F, 0
    npc_msg 49
    buffer_players_name 0
    gender_msgbox 50, 51
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_10EF:
    goto_if_no_item_space ITEM_EVERSTONE, 1, scr_seq_0843_1198
    callstd std_give_item_verbose
    setflag FLAG_UNK_072
    setflag FLAG_GOT_EVERSTONE_FROM_ELM
    setvar VAR_TEMP_x400F, 0
    npc_msg 49
    buffer_players_name 0
    gender_msgbox 50, 51
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_1134:
    buffer_players_name 0
    gender_msgbox 44, 45
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_1143:
    npc_msg 55
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0843_114E:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0843_1158:
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0843_0E05
    apply_movement 2, scr_seq_0843_1556
    wait_movement
    releaseall
    end

scr_seq_0843_1173:
    compare VAR_SPECIAL_x8006, 4
    goto_if_ne scr_seq_0843_11A2
    apply_movement obj_player, scr_seq_0843_1562
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_154E
    goto scr_seq_0843_0EE1

scr_seq_0843_1198:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0843_11A2:
    apply_movement obj_player, scr_seq_0843_1576
    wait_movement
    apply_movement obj_partner_poke, scr_seq_0843_14EE
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    return

scr_seq_0843_11C2:
    step 3, 1
    step_end
scr_seq_0843_11CA:
    step 76, 8
    step 2, 1
    step_end
scr_seq_0843_11D6:
    step 35, 1
    step_end
scr_seq_0843_11DE:
    step 16, 6
    step 18, 1
    step 48, 2
    step_end
scr_seq_0843_11EE:
    step 63, 4
    step 33, 1
    step_end
scr_seq_0843_11FA:
    step 75, 1
    step 60, 1
    step 1, 1
    step 63, 2
    step 3, 1
    step 63, 2
    step 1, 1
    step 63, 2
    step 3, 1
    step 63, 2
    step_end
scr_seq_0843_1226:
    step 2, 1
    step 71, 1
    step 15, 1
    step 72, 1
    step 66, 1
    step 1, 1
    step_end
scr_seq_0843_1242:
    step 1, 1
    step 62, 1
    step 13, 6
    step 3, 1
    step 15, 1
    step 1, 1
    step 13, 2
    step_end
scr_seq_0843_1262:
    step 14, 1
    step 12, 2
    step 35, 1
    step_end
scr_seq_0843_1272:
    step 1, 1
    step 13, 6
    step 15, 1
    step 13, 2
    step_end
scr_seq_0843_1286:
    step 0, 1
    step_end
scr_seq_0843_128E:
    step 33, 1
    step_end
scr_seq_0843_1296:
    step 49, 1
    step 71, 1
    step 80, 1
    step 72, 1
    step_end
scr_seq_0843_12AA:
    step 77, 1
    step_end
scr_seq_0843_12B2:
    step 0, 1
    step 8, 1
    step 64, 1
    step 1, 1
    step_end
scr_seq_0843_12C6:
    step 77, 1
    step_end
scr_seq_0843_12CE:
    step 75, 1
    step 78, 6
    step 32, 1
    step_end
scr_seq_0843_12DE:
    step 12, 2
    step 15, 1
    step 12, 1
    step_end
scr_seq_0843_12EE:
    step 13, 2
    step 14, 4
    step 32, 1
    step_end
scr_seq_0843_12FE:
    step 33, 1
    step_end
scr_seq_0843_1306:
    step 32, 1
    step_end
scr_seq_0843_130E:
    step 65, 1
    step 33, 1
    step_end
scr_seq_0843_131A:
    step 2, 1
    step 75, 1
    step_end
scr_seq_0843_1326:
    step 78, 3
    step 33, 1
    step_end
scr_seq_0843_1332:
    step 12, 7
    step_end
scr_seq_0843_133A:
    step 12, 5
    step 15, 1
    step 12, 1
    step 34, 1
    step_end
scr_seq_0843_134E:
    step 14, 5
    step 13, 1
    step_end
scr_seq_0843_135A:
    step 12, 1
    step 15, 5
    step 33, 1
    step_end
scr_seq_0843_136A:
    step 33, 1
    step_end
scr_seq_0843_1372:
    step 13, 1
    step 15, 1
    step 33, 1
    step_end
scr_seq_0843_1382:
    step 49, 1
    step 65, 1
    step 48, 1
    step_end
scr_seq_0843_1392:
    step 75, 1
    step 63, 1
    step_end
scr_seq_0843_139E:
    step 12, 1
    step 14, 1
    step 33, 1
    step_end
scr_seq_0843_13AE:
    step 12, 1
    step 63, 2
    step 71, 1
    step 11, 1
    step 32, 1
    step 10, 1
    step 72, 1
    step 63, 2
    step_end
scr_seq_0843_13D2:
    step 75, 1
    step 78, 5
    step 32, 1
    step_end
scr_seq_0843_13E2:
    step 79, 6
    step 34, 1
    step_end
scr_seq_0843_13EE:
    step 1, 1
    step 75, 1
    step 33, 2
    step_end
scr_seq_0843_13FE:
    step 12, 1
    step_end
scr_seq_0843_1406:
    step 12, 3
    step_end
scr_seq_0843_140E:
    step 75, 1
    step 12, 1
    step 65, 1
    step_end
scr_seq_0843_141E:
    step 13, 1
    step_end
scr_seq_0843_1426:
    step 13, 1
    step 34, 1
    step_end
scr_seq_0843_1432:
    step 63, 1
    step 35, 1
    step_end
scr_seq_0843_143E:
    step 77, 3
    step 78, 1
    step 77, 4
    step_end
scr_seq_0843_144E:
    step 32, 1
    step_end
scr_seq_0843_1456:
    step 13, 1
    step 32, 1
    step_end
scr_seq_0843_1462:
    step 15, 1
    step 13, 1
    step 32, 1
    step_end
scr_seq_0843_1472:
    step 12, 1
    step 14, 2
    step 32, 1
    step 63, 2
    step 71, 1
    step 11, 1
    step 32, 1
    step 10, 1
    step 72, 1
    step 63, 2
    step_end
scr_seq_0843_149E:
    step 13, 1
    step_end
scr_seq_0843_14A6:
    step 75, 1
    step 62, 1
    step_end
scr_seq_0843_14B2:
    step 75, 1
    step 78, 4
    step 32, 1
    step_end
scr_seq_0843_14C2:
    step 79, 5
    step 34, 1
    step_end
scr_seq_0843_14CE:
    step 12, 2
    step 14, 1
    step 12, 1
    step_end
scr_seq_0843_14DE:
    step 13, 2
    step 15, 1
    step 32, 1
    step_end
scr_seq_0843_14EE:
    step 13, 1
    step 15, 2
    step 12, 1
    step 32, 1
    step_end
scr_seq_0843_1502:
    step 13, 1
    step 15, 2
    step 33, 1
    step_end
scr_seq_0843_1512:
    step 75, 1
    step 78, 3
    step 32, 1
    step_end
scr_seq_0843_1522:
    step 79, 4
    step 34, 1
    step_end
scr_seq_0843_152E:
    step 12, 2
    step 14, 2
    step 12, 1
    step_end
scr_seq_0843_153E:
    step 13, 2
    step 14, 1
    step 32, 1
    step_end
scr_seq_0843_154E:
    step 32, 1
    step_end
scr_seq_0843_1556:
    step 79, 3
    step 34, 1
    step_end
scr_seq_0843_1562:
    step 15, 1
    step 13, 3
    step 14, 1
    step 32, 1
    step_end
scr_seq_0843_1576:
    step 14, 1
    step 13, 3
    step 15, 1
    step 32, 1
    step_end

.close
