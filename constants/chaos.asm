chaos_overworld_const: MACRO
CHAOS_OVERWORLD_\1 EQUS "((ChaosEffectOverworldJumptable\1 - ChaosEffectOverworldJumptable) / 2 + 1)"
ENDM

chaos_battle_const: MACRO
CHAOS_BATTLE_\1 EQUS "((ChaosEffectBattleJumptable\1 - ChaosEffectBattleJumptable) / 2 + 1)"
ENDM

chaos_menu_const: MACRO
CHAOS_MENU_\1 EQUS "((ChaosEffectMenuJumptable\1 - ChaosEffectMenuJumptable) / 2 + 1)"
ENDM

CHAOS_TYPE_OVERWORLD EQU 0
CHAOS_TYPE_BATTLE EQU 1
CHAOS_TYPE_MENU EQU 2

; overworld
	chaos_overworld_const INSTANT_TEXT
	chaos_overworld_const INVISIBLE_TEXT
	chaos_overworld_const REDBAR
	chaos_overworld_const RANDOM_MON_POISON
	chaos_overworld_const ALL_ENCOUNTERS_JYNX
	
	chaos_battle_const INSTANT_TEXT
	chaos_battle_const INVISIBLE_TEXT
	chaos_battle_const REDBAR
	chaos_battle_const CF4B_CORRUPTION
	
	chaos_menu_const INSTANT_TEXT
	chaos_menu_const INVISIBLE_TEXT
	chaos_menu_const REDBAR
	chaos_menu_const CF4B_CORRUPTION
	