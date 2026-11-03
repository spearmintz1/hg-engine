.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Cianwood City Gym (Chuck, header 113)

.create "build/a012/2_877", 0


scrdef scr_seq_0877_000
scrdef scr_seq_0877_001
scrdef scr_seq_0877_002
scrdef scr_seq_0877_003
scrdef_end

scr_seq_0877_000:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    compare VAR_TEMP_x4000, 0
    goto_if_eq scr_seq_0877_0102
    check_badge 4, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0877_010D
    npc_msg 0
    closemsg
    trainer_battle 34, 0, 0, 0
    check_battle_won VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0877_0123
    npc_msg 3
    settrainerflag 156
    settrainerflag 157
    settrainerflag 251
    settrainerflag 159
    buffer_players_name 0
    npc_msg 4
    give_badge 4
    play_fanfare SEQ_ME_BADGE
    wait_fanfare
    addvar VAR_UNK_4134, 1
    add_special_game_stat 22
    setvar VAR_UNK_4116, 1
    compare VAR_UNK_4134, 3
    setvar VAR_UNK_416F, 40
    goto_if_ne scr_seq_0877_0129
    setvar VAR_SCENE_ROCKET_TAKEOVER, 1
    npc_msg 5
    setvar VAR_UNK_416F, 40
    goto scr_seq_0877_0132

scr_seq_0877_001:
    cianwood_gym_init
    clearflag FLAG_SYS_CIANWOOD_WATERFALL_DISABLE
    end

scr_seq_0877_002:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    compare VAR_TEMP_x4000, 0
    goto_if_eq scr_seq_0877_0166
    npc_msg 12
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_003:
    play_se SEQ_SE_DP_SELECT
    lockall
    faceplayer
    check_badge 4, VAR_SPECIAL_RESULT
    buffer_players_name 0
    compare VAR_SPECIAL_RESULT, 0
    goto_if_ne scr_seq_0877_0184
    npc_msg 13
    goto scr_seq_0877_018F

scr_seq_0877_0102:
    npc_msg 9
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_010D:
    goto_if_unset FLAG_GOT_TM01_FROM_CHUCK, scr_seq_0877_0132
    npc_msg 8
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_0123:
    white_out
    releaseall
    end

scr_seq_0877_0129:
    npc_msg 5
    goto scr_seq_0877_0132

scr_seq_0877_0132:
    goto_if_no_item_space ITEM_TM01, 1, scr_seq_0877_0197
    callstd std_give_item_verbose
    setflag FLAG_GOT_TM01_FROM_CHUCK
    npc_msg 6
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_0166:
    npc_msg 10
    touchscreen_menu_hide
    getmenuchoice VAR_SPECIAL_RESULT
    touchscreen_menu_show
    compare VAR_SPECIAL_RESULT, 0
    goto_if_eq scr_seq_0877_01A2
    closemsg
    releaseall
    end

scr_seq_0877_0184:
    npc_msg 14
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_018F:
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_0197:
    npc_msg 7
    wait_button_or_walk_away
    closemsg
    releaseall
    end

scr_seq_0877_01A2:
    buffer_players_name 0
    npc_msg 11
    closemsg
    setflag FLAG_SYS_CIANWOOD_WATERFALL_DISABLE
    stop_se SEQ_SE_GS_N_TAKI
    play_se SEQ_SE_DP_SHIP03
    play_se SEQ_SE_GS_TAKI2
    cianwood_gym_turn_winch VAR_TEMP_x4000
    releaseall
    end

.close
