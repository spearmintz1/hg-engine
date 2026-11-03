.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Mahogany Town Gym (Pryce, header 114)

.create "build/a012/2_932", 0


scrdef scr_seq_0932_000
scrdef scr_seq_0932_001
scrdef_end

scr_seq_0932_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 6, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0932_00DB
    npc_msg 0
    closemsg
    trainer_battle 32, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0932_00F1
    settrainerflag 482
    settrainerflag 484
    settrainerflag 481
    settrainerflag 480
    settrainerflag 483
    npc_msg 1
    give_badge 6
    addvar VAR_UNK_4134, 1
    setvar VAR_UNK_416F, 45
    add_special_game_stat 22
    compare VAR_UNK_4134, 3
    goto_if_ne scr_seq_0932_00F7
    setvar VAR_SCENE_ROCKET_TAKEOVER, 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    goto_if_no_item_space ITEM_TM07, 1, scr_seq_0932_013A
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM07_FROM_PRYCE
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_416F, 45
    releaseall
    end

scr_seq_0932_001:
    goto_if_unset FLAG_UNK_189, scr_seq_0932_0144
    clearflag FLAG_UNK_189
    end

scr_seq_0932_00DB:
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0932_0190
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0932_00F1:
    white_out
    releaseall
    end

scr_seq_0932_00F7:
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    npc_msg 3
    goto_if_no_item_space ITEM_TM07, 1, scr_seq_0932_013A
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM07_FROM_PRYCE
    npc_msg 4
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0932_013A:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0932_0144:
    get_phone_book_rematch 39, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0932_01F1
    goto_if_unset FLAG_GAME_CLEAR, scr_seq_0932_01F7
    check_registered_phone_number 39, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0932_01F7
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 6
    goto_if_ne scr_seq_0932_01FD
    setflag FLAG_UNK_2EE
    goto scr_seq_0932_0214

scr_seq_0932_0190:
    npc_msg 6
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0932_0216
    photo_album_is_full VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0932_0221
    npc_msg 7
    closemsg
    setflag FLAG_UNK_189
    fade_screen 6, 1, 0, 0
    wait_fade
    cameron_photo 40
    faceplayer
    lockall
    fade_screen 6, 1, 1, 0
    wait_fade
    clearflag FLAG_UNK_189
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0932_01F1:
    setflag FLAG_UNK_2EE
    end

scr_seq_0932_01F7:
    clearflag FLAG_UNK_2EE
    end

scr_seq_0932_01FD:
    compare VAR_TEMP_x4000, 7
    goto_if_ne scr_seq_0932_022C
    setflag FLAG_UNK_2EE
    goto scr_seq_0932_0214

scr_seq_0932_0214:
    end

scr_seq_0932_0216:
    npc_msg 9
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0932_0221:
    npc_msg 10
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0932_022C:
    compare VAR_TEMP_x4000, 8
    goto_if_ne _0243
    setflag FLAG_UNK_2EE
    goto scr_seq_0932_0214

_0243:
    compare VAR_TEMP_x4000, 9
    goto_if_ne _025A
    setflag FLAG_UNK_2EE
    goto scr_seq_0932_0214

_025A:
    clearflag FLAG_UNK_2EE
    end

.close
