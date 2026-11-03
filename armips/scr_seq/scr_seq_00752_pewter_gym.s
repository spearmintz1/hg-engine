.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Pewter Gym (Brock, Boulder Badge); no map header

.create "build/a012/2_752", 0


scrdef scr_seq_0752_000
scrdef scr_seq_0752_001
scrdef scr_seq_0752_002
scrdef scr_seq_0752_003
scrdef_end

scr_seq_0752_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 8, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0752_010F
    npc_msg 0
    closemsg
    trainer_battle 253, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0752_0128
    give_badge 8
    addvar VAR_UNK_4135, 1
    add_special_game_stat 22
    settrainerflag 308
    settrainerflag 685
    setvar VAR_UNK_416F, 75
    npc_msg 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    buffer_players_name 0
    gender_msgbox 3, 4
    goto scr_seq_0752_012E

scr_seq_0752_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 8, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0752_0170
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 8, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0752_017B
    npc_msg 8
    goto scr_seq_0752_0186

scr_seq_0752_003:
    get_phone_book_rematch 33, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0752_018E
    check_registered_phone_number 33, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0752_0194
    check_badge 15, VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 1
    goto_if_eq scr_seq_0752_01AF
    goto scr_seq_0752_01CA

scr_seq_0752_010F:
    goto_if_unset FLAG_GOT_TM80_FROM_BROCK, scr_seq_0752_012E
    buffer_players_name 0
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_0128:
    white_out
    releaseall
    end

scr_seq_0752_012E:
    goto_if_no_item_space ITEM_TM80, 1, scr_seq_0752_01D0
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM80_FROM_BROCK
    goto_if_unset FLAG_GOT_TM80_FROM_BROCK, scr_seq_0752_012E
    buffer_players_name 0
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_0170:
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_017B:
    npc_msg 9
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_0186:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0752_018E:
    setflag FLAG_UNK_2F4
    end

scr_seq_0752_0194:
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 17
    goto_if_ne scr_seq_0752_01DA
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_01F1

scr_seq_0752_01AF:
    scrcmd_522 VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 12
    goto_if_ne scr_seq_0752_01F3
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_020A

scr_seq_0752_01CA:
    clearflag FLAG_UNK_2F4
    end

scr_seq_0752_01D0:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0752_01DA:
    compare VAR_TEMP_x4000, 18
    goto_if_ne scr_seq_0752_020C
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_01F1

scr_seq_0752_01F1:
    end

scr_seq_0752_01F3:
    compare VAR_TEMP_x4000, 13
    goto_if_ne scr_seq_0752_0223
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_020A

scr_seq_0752_020A:
    end

scr_seq_0752_020C:
    compare VAR_TEMP_x4000, 19
    goto_if_ne scr_seq_0752_023A
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_01F1

scr_seq_0752_0223:
    compare VAR_TEMP_x4000, 14
    goto_if_ne scr_seq_0752_0240
    setflag FLAG_UNK_2F4
    goto scr_seq_0752_020A

scr_seq_0752_023A:
    goto scr_seq_0752_01CA

scr_seq_0752_0240:
    goto scr_seq_0752_01CA

.close
