CHAOS_TYPE_OVERWORLD EQU 0
CHAOS_TYPE_BATTLE EQU 1
CHAOS_TYPE_MENU EQU 2

ce_type = CHAOS_TYPE_OVERWORLD

ce_const: MACRO
	; durrr
	IF ce_type == CHAOS_TYPE_OVERWORLD
		const CE_OW_\1
	ELSE
		IF ce_type == CHAOS_TYPE_BATTLE
			const CE_BTL_\1
		ELSE
			const CE_MENU_\1
		ENDC
	ENDC
ENDM

; overworld
const_value = 1
	
	ce_const INSTANT_TEXT
	ce_const INVISIBLE_TEXT
	ce_const REDBAR
	ce_const RANDOM_MON_POISON
	ce_const ALL_ENCOUNTERS_JYNX
	ce_const JOYPAD_CHAOS
	ce_const RANDOM_PALETTES
	ce_const INACCESSIBLE_VRAM
	ce_const JACK_MODE
	ce_const RANDOM_ENCOUNTERS
	
; battle
const_value = 1
ce_type = CHAOS_TYPE_BATTLE

	ce_const INSTANT_TEXT
	ce_const INVISIBLE_TEXT
	ce_const REDBAR
	ce_const CF4B_CORRUPTION
	ce_const ALL_CRIES_JYNX
	ce_const JOYPAD_CHAOS
	ce_const RANDOM_PALETTES
	ce_const INACCESSIBLE_VRAM
	ce_const CURMOVE_NUM_E
	ce_const CURMOVE_EFFECT_E
	ce_const CURMOVE_PWR_E
	ce_const CURMOVE_TYPE_E
	ce_const CURMOVE_ACC_E
	ce_const CURMOVE_NUM_P
	ce_const CURMOVE_EFFECT_P
	ce_const CURMOVE_PWR_P
	ce_const CURMOVE_TYPE_P
	ce_const CURMOVE_ACC_P
	ce_const CURMOVE_MAXPP_P
	
; menu
const_value = 1
ce_type = CHAOS_TYPE_MENU

	ce_const INSTANT_TEXT
	ce_const INVISIBLE_TEXT
	ce_const REDBAR
	ce_const CF4B_CORRUPTION
	ce_const JOYPAD_CHAOS
	ce_const RANDOM_PALETTES
	ce_const INACCESSIBLE_VRAM