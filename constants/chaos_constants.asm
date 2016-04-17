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
; Sprite State Data
	ce_const SSD_MOVEMENT_STATUS
	ce_const SSD_Y_DELTA
	ce_const SSD_X_DELTA
	ce_const SSD_PIXEL_YPOS
	ce_const SSD_PIXEL_XPOS
	ce_const SSD_INTRA_ANIM_FRAMECOUNTER
	ce_const SSD_ANIM_FRAMECOUNTER
	ce_const SSD_VISIBILITY
	ce_const SSD_FACING_DIR
	ce_const SSD_NPC_WALKCOUNTER
	ce_const SSD_GRID_YPOS
	ce_const SSD_GRID_XPOS
	ce_const SSD_MOVEMENT_BYTE
	ce_const SSD_GRASS_MASK
	ce_const SSD_MOVEMENT_DELAY
	ce_const SSD_SPRITE_IMAGE_BASE_OFFSET
; end of SSD constants
	ce_const SUPERFAST
	ce_const INACCESSIBLE_ROW_COLUMN
	
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
	ce_const SUPERFAST
	ce_const INACCESSIBLE_TILEMAP
	
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
	ce_const SUPERFAST
	ce_const INACCESSIBLE_TILEMAP