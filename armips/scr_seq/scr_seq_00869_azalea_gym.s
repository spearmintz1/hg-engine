.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Azalea Town Gym (Bugsy, header 154)

.create "build/a012/2_869", 0


scrdef scr_seq_0869_000
scrdef scr_seq_0869_001
scrdef scr_seq_0869_002
scrdef scr_seq_0869_003
scrdef scr_seq_0869_004
scrdef scr_seq_0869_005
scrdef scr_seq_0869_006
scrdef scr_seq_0869_007
scrdef scr_seq_0869_008
scrdef scr_seq_0869_009
scrdef scr_seq_0869_010
scrdef scr_seq_0869_011
scrdef scr_seq_0869_012
scrdef scr_seq_0869_013
scrdef scr_seq_0869_014
scrdef scr_seq_0869_015
scrdef scr_seq_0869_016
scrdef_end

scr_seq_0869_000:
    end

scr_seq_0869_001:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 1, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0869_0151
    npc_msg 0
    closemsg
    trainer_battle 21, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0869_0167
    npc_msg 1
    buffer_players_name 0
    npc_msg 2
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    give_badge 1
    settrainerflag 68
    settrainerflag 67
    settrainerflag 69
    settrainerflag 10
    add_special_game_stat 22
    npc_msg 3
    goto_if_no_item_space ITEM_TM89, 1, scr_seq_0869_016D
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM89_FROM_BUGSY
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    setvar VAR_UNK_416F, 21
    releaseall
    end

scr_seq_0869_002:
    azalea_gym_spinarak 0
    end

scr_seq_0869_003:
    azalea_gym_spinarak 1
    end

scr_seq_0869_004:
    azalea_gym_spinarak 2
    end

scr_seq_0869_005:
    azalea_gym_spinarak 3
    end

scr_seq_0869_006:
    azalea_gym_spinarak 4
    end

scr_seq_0869_007:
    azalea_gym_spinarak 5
    end

scr_seq_0869_008:
    azalea_gym_spinarak 6
    end

scr_seq_0869_009:
    azalea_gym_spinarak 7
    end

scr_seq_0869_010:
    azalea_gym_spinarak 8
    end

scr_seq_0869_011:
    azalea_gym_spinarak 9
    end

scr_seq_0869_012:
    azalea_gym_spinarak 10
    end

scr_seq_0869_013:
    azalea_gym_spinarak 11
    end

scr_seq_0869_014:
    azalea_gym_switch 0
    end

scr_seq_0869_015:
    azalea_gym_switch 1
    end

scr_seq_0869_016:
    azalea_gym_init
    get_phone_book_rematch 34, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 0
    goto_if_ne scr_seq_0869_0177
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0869_017D
    clearflag FLAG_UNK_2EA
    end

scr_seq_0869_0151:
    goto_if_unset FLAG_GOT_TM89_FROM_BUGSY, scr_seq_0869_01A7
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0869_0167:
    white_out
    releaseall
    end

scr_seq_0869_016D:
    callstd std_bag_is_full
    closemsg
    releaseall
    end

scr_seq_0869_0177:
    setflag FLAG_UNK_2EA
    end

scr_seq_0869_017D:
    check_registered_phone_number 34, VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq scr_seq_0869_01DB
    get_weekday VAR_TEMP_x4002
    compare VAR_TEMP_x4002, 4
    goto_if_ne scr_seq_0869_01DB
    setflag FLAG_UNK_2EA
    end

scr_seq_0869_01A7:
    goto_if_no_item_space ITEM_TM89, 1, scr_seq_0869_016D
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM89_FROM_BUGSY
    npc_msg 5
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0869_01DB:
    get_weekday VAR_TEMP_x4001
    compare VAR_TEMP_x4001, 1
    goto_if_eq _020C
    compare VAR_TEMP_x4001, 3
    goto_if_eq _020C
    compare VAR_TEMP_x4001, 5
    goto_if_eq _020C
    clearflag FLAG_UNK_2EA
    end

_020C:
    setflag FLAG_UNK_2EA
    end

.close
