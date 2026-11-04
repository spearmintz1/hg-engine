.nds
.thumb

.include "armips/include/scriptmacros.s"
.include "armips/include/flags.s"
.include "armips/include/soundeffects.s"
.include "armips/include/vars.s"

.include "asm/include/items.inc"


// Pokemon League, Hall of Fame room (header 280)

.create "build/a012/2_825", 0


scrdef scr_seq_0825_000
scrdef scr_seq_0825_001
scrdef_end

scr_seq_0825_000:
    scrcmd_609
    lockall
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0825_031E
    apply_movement 0, scr_seq_0825_032A
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    buffer_players_name 0
    gender_msgbox 0, 1
    closemsg
    scrcmd_602 0
    scrcmd_603
    scrcmd_604 55
    apply_movement obj_player, scr_seq_0825_033E
    wait_movement
    scrcmd_603
    scrcmd_602 1
    scrcmd_604 48
    party_count_not_egg VAR_SPECIAL_RESULT
    hall_of_fame_anim VAR_SPECIAL_RESULT
    add_special_game_stat 23
    fade_screen 6, 1, 0, 0
    wait_fade
    call scr_seq_0825_0127
    hasitem ITEM_SS_TICKET, 1, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_eq scr_seq_0825_013C
    setvar VAR_SCENE_PLAYERS_HOUSE_1F, 3
    setflag FLAG_UNK_97E
    clearflag FLAG_HIDE_LAKE_OF_RAGE_PRYCE
    call_if_unset FLAG_CAUGHT_HO_OH, scr_seq_0825_01C9
    call_if_unset FLAG_CAUGHT_LUGIA, scr_seq_0825_01CF
    call_if_unset FLAG_CAUGHT_SUDOWOODO, scr_seq_0825_01D5
    call_if_unset FLAG_CAUGHT_RED_GYARADOS, scr_seq_0825_01DB
    call_if_unset FLAG_CAUGHT_MEWTWO, scr_seq_0825_01E1
    call_if_unset FLAG_CAUGHT_ARTICUNO, scr_seq_0825_01E7
    call_if_unset FLAG_CAUGHT_ZAPDOS, scr_seq_0825_01ED
    call_if_unset FLAG_CAUGHT_MOLTRES, scr_seq_0825_0206
    goto_if_unset FLAG_CAUGHT_SNORLAX, scr_seq_0825_020C
    call_if_unset FLAG_CAUGHT_SUICUNE, scr_seq_0825_021D
    get_game_version VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 7
    goto_if_ne scr_seq_0825_0230
    goto scr_seq_0825_0236

scr_seq_0825_001:
    stop_bgm 0
    end

scr_seq_0825_0127:
    goto_if_set FLAG_GAME_CLEAR, scr_seq_0825_024B
    setflag FLAG_UNK_998
    clearflag FLAG_UNK_25F
    return

scr_seq_0825_013C:
    setflag FLAG_UNK_97E
    clearflag FLAG_HIDE_LAKE_OF_RAGE_PRYCE
    call_if_unset FLAG_CAUGHT_HO_OH, scr_seq_0825_01C9
    call_if_unset FLAG_CAUGHT_LUGIA, scr_seq_0825_01CF
    call_if_unset FLAG_CAUGHT_SUDOWOODO, scr_seq_0825_01D5
    call_if_unset FLAG_CAUGHT_RED_GYARADOS, scr_seq_0825_01DB
    call_if_unset FLAG_CAUGHT_MEWTWO, scr_seq_0825_01E1
    call_if_unset FLAG_CAUGHT_ARTICUNO, scr_seq_0825_01E7
    call_if_unset FLAG_CAUGHT_ZAPDOS, scr_seq_0825_01ED
    call_if_unset FLAG_CAUGHT_MOLTRES, scr_seq_0825_0206
    goto_if_unset FLAG_CAUGHT_SNORLAX, scr_seq_0825_020C
    call_if_unset FLAG_CAUGHT_SUICUNE, scr_seq_0825_021D
    get_game_version VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 7
    goto_if_ne scr_seq_0825_0230
    goto scr_seq_0825_0236

scr_seq_0825_01C9:
    clearflag FLAG_HIDE_BELL_TOWER_HO_OH
    return

scr_seq_0825_01CF:
    clearflag FLAG_HIDE_WHIRL_ISLAND_LUGIA
    return

scr_seq_0825_01D5:
    clearflag FLAG_HIDE_ROUTE_36_SUDOWOODO
    return

scr_seq_0825_01DB:
    clearflag FLAG_HIDE_LAKE_OF_RAGE_RED_GYARADOS
    return

scr_seq_0825_01E1:
    clearflag FLAG_HIDE_CERULEAN_CAVE_MEWTWO
    return

scr_seq_0825_01E7:
    clearflag FLAG_HIDE_SEAFOAM_ISLAND_ARTICUNO
    return

scr_seq_0825_01ED:
    check_badge 15, VAR_SPECIAL_RESULT
    compare VAR_SPECIAL_RESULT, 1
    goto_if_ne scr_seq_0825_0251
    clearflag FLAG_HIDE_ROUTE_10_ZAPDOS
    return

scr_seq_0825_0206:
    clearflag FLAG_HIDE_MT_SILVER_CAVE_MOLTRES
    return

scr_seq_0825_020C:
    goto_if_set FLAG_SNORLAX_MEET, scr_seq_0825_0253
    goto scr_seq_0825_025D

scr_seq_0825_021D:
    compare VAR_SCENE_ROUTE_25, 3
    goto_if_ne scr_seq_0825_027F
    clearflag FLAG_HIDE_BURNED_TOWER_STATIC_SUICUNE
    return

scr_seq_0825_0230:
    goto scr_seq_0825_0281

scr_seq_0825_0236:
    goto_if_set FLAG_CAUGHT_KYOGRE, scr_seq_0825_0296
    clearflag FLAG_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    goto scr_seq_0825_0296

scr_seq_0825_024B:
    clearflag FLAG_UNK_25F
    return

scr_seq_0825_0251:
    return

scr_seq_0825_0253:
    clearflag FLAG_HIDE_ROUTE_12_SNORLAX
    goto scr_seq_0825_025D

scr_seq_0825_025D:
    call_if_unset FLAG_CAUGHT_SUICUNE, scr_seq_0825_021D
    get_game_version VAR_TEMP_x4000
    compare VAR_TEMP_x4000, 7
    goto_if_ne scr_seq_0825_0230
    goto scr_seq_0825_0236

scr_seq_0825_027F:
    return

scr_seq_0825_0281:
    goto_if_set FLAG_CAUGHT_KYOGRE, scr_seq_0825_0296
    clearflag FLAG_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    goto scr_seq_0825_0296

scr_seq_0825_0296:
    call_if_unset FLAG_CAUGHT_RAYQUAZA, _02EB
    compare VAR_UNK_4046, 2
    call_if_eq _02F1
    compare VAR_UNK_4045, 2
    call_if_eq _02FC
    compare VAR_UNK_4047, 2
    call_if_eq _0307
    compare VAR_UNK_4048, 2
    call_if_eq _0312
    hof_credits 0
    scrcmd_150
    fade_screen 6, 1, 1, 0
    wait_fade
    releaseall
    end

_02EB:
    clearflag FLAG_HIDE_EMBEDDED_TOWER_RAYQUAZA
    return

_02F1:
    setvar VAR_UNK_4046, 0
    create_roamer 1
    return

_02FC:
    setvar VAR_UNK_4045, 0
    create_roamer 0
    return

_0307:
    setvar VAR_UNK_4047, 0
    create_roamer 2
    return

_0312:
    setvar VAR_UNK_4048, 0
    create_roamer 3
    return

    .align 2
scr_seq_0825_031E:
    step 12, 14
    step 3, 2
    step_end
scr_seq_0825_032A:
    step 12, 12
    step 3, 2
    step 15, 1
    step 2, 2
    step_end
scr_seq_0825_033E:
    step 0, 2
    step 12, 4
    step_end

.close
