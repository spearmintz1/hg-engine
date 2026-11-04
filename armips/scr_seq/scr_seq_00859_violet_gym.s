.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Violet City Gym (Falkner, header 109)

.create "build/a012/2_859", 0


scrdef scr_seq_0859_000
scrdef scr_seq_0859_001
scrdef scr_seq_0859_002
scrdef scr_seq_0859_003
scrdef scr_seq_0859_004
scrdef scr_seq_0859_005
scrdef_end

scr_seq_0859_000:
    violet_gym_init
    get_phone_book_rematch 18, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0859_0144
    check_registered_phone_number 18, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0859_014A
    check_badge 12, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0859_0165
    goto scr_seq_0859_0180

scr_seq_0859_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 0, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0859_0186
    npc_msg 0
    closemsg
    trainer_battle 20, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0859_019C
    give_badge 0
    add_special_game_stat 22
    settrainerflag 29
    settrainerflag 50
    setvar VAR_SCENE_VIOLET_CITY_OW, 1
    setflag FLAG_UNK_192
    setvar VAR_SCENE_ELMS_LAB, 6
    setflag FLAG_UNK_0F4
    setflag FLAG_HIDE_WIFI_CLUB_CLOSED_LADY
    npc_msg 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    setvar VAR_UNK_416F, 17
    goto scr_seq_0859_01A2

scr_seq_0859_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 0, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0859_01DA
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 0, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0859_01E5
    npc_msg 9
    goto scr_seq_0859_01F0

scr_seq_0859_004:
    setvar VAR_TEMP_x4000, 0
    violet_gym_elevator
    end

scr_seq_0859_005:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_0144:
    setflag FLAG_UNK_2E9
    end

scr_seq_0859_014A:
    get_weekday VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 3
    goto_if_ne scr_seq_0859_01F8
    setflag FLAG_UNK_2E9
    goto scr_seq_0859_01FE

scr_seq_0859_0165:
    get_weekday VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_ne scr_seq_0859_0200
    setflag FLAG_UNK_2E9
    goto scr_seq_0859_0206

scr_seq_0859_0180:
    clearflag FLAG_UNK_2E9
    end

scr_seq_0859_0186:
    goto_if_unset FLAG_GOT_TM51_FROM_FALKNER, scr_seq_0859_01A2
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_019C:
    white_out
    releaseall
    end

scr_seq_0859_01A2:
    goto_if_no_item_space ITEM_TM51, 1, scr_seq_0859_0208
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM51_FROM_FALKNER
    clearflag FLAG_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_01DA:
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_01E5:
    npc_msg 10
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_01F0:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0859_01F8:
    goto scr_seq_0859_0180

scr_seq_0859_01FE:
    end

scr_seq_0859_0200:
    goto scr_seq_0859_0180

scr_seq_0859_0206:
    end

scr_seq_0859_0208:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

.close
