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
	ce_const INACCESSIBLE_OAM
	ce_const TWOBPP_IS_1BPP
	ce_const ONEBPP_IS_2BPP
	
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
	ce_const ENEMY_MON_SPECIES_2
	ce_const BATTLE_MON_SPECIES_2
	ce_const EBS_SPECIES
	ce_const PBS_SPECIES
	ce_const EBS_HP
	ce_const EBS_PARTYPOS
	ce_const EBS_STATUS
	ce_const EBS_TYPE1
	ce_const EBS_TYPE2
	ce_const EBS_MOVE1
	ce_const EBS_MOVE2
	ce_const EBS_MOVE3
	ce_const EBS_MOVE4	
	ce_const EBS_DVS
	ce_const EBS_LEVEL
	ce_const EBS_MAXHP
	ce_const EBS_ATTACK
	ce_const EBS_DEFENSE
	ce_const EBS_SPEED
	ce_const EBS_SPECIAL
	ce_const EBS_BASESTATS
	;ce_const EBS_CATCHRATE
	ce_const EBS_BASEEXP
	ce_const PBS_HP
	ce_const PBS_PARTYPOS
	ce_const PBS_STATUS
	ce_const PBS_TYPE1
	ce_const PBS_TYPE2
	ce_const PBS_MOVE1
	ce_const PBS_MOVE2
	ce_const PBS_MOVE3
	ce_const PBS_MOVE4
	ce_const PBS_LEVEL
	ce_const PBS_MAXHP
	ce_const PBS_ATTACK
	ce_const PBS_DEFENSE
	ce_const PBS_SPEED
	ce_const PBS_SPECIAL
	ce_const PBS_PP
	ce_const INACCESSIBLE_OAM
	ce_const FORCE_ANIMS
	ce_const EVS_STORING_ENERGY
	ce_const EVS_THRASING_ABOUT
	ce_const EVS_ATTACKING_MULTIPLE_TIMES
	ce_const EVS_FLINCHED
	ce_const EVS_CHARGING_UP
	ce_const EVS_USING_TRAPPING_MOVE
	ce_const EVS_CONFUSED
	ce_const EVS_USING_X_ACCURACY
	ce_const EVS_PROTECTED_BY_MIST
	ce_const EVS_GETTING_PUMPED
	ce_const EVS_HAS_SUBSTITUTE_UP
	ce_const EVS_NEEDS_TO_RECHARGE
	ce_const EVS_USING_RAGE
	ce_const EVS_SEEDED
	ce_const EVS_BADLY_POISONED
	ce_const EVS_HAS_LIGHT_SCREEN_UP
	ce_const EVS_HAS_REFLECT_UP
	ce_const EVS_TRANSFORMED
	ce_const PVS_STORING_ENERGY
	ce_const PVS_THRASING_ABOUT
	ce_const PVS_ATTACKING_MULTIPLE_TIMES
	ce_const PVS_FLINCHED
	ce_const PVS_CHARGING_UP
	ce_const PVS_USING_TRAPPING_MOVE
	ce_const PVS_CONFUSED
	ce_const PVS_USING_X_ACCURACY
	ce_const PVS_PROTECTED_BY_MIST
	ce_const PVS_GETTING_PUMPED
	ce_const PVS_HAS_SUBSTITUTE_UP
	ce_const PVS_NEEDS_TO_RECHARGE
	ce_const PVS_USING_RAGE
	ce_const PVS_SEEDED
	ce_const PVS_BADLY_POISONED
	ce_const PVS_HAS_LIGHT_SCREEN_UP
	ce_const PVS_HAS_REFLECT_UP
	ce_const PVS_TRANSFORMED
	ce_const TWOBPP_IS_1BPP
	ce_const ONEBPP_IS_2BPP
	ce_const RANDOM_TRAINERCLASS
	
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
	ce_const TWOBPP_IS_1BPP
	ce_const ONEBPP_IS_2BPP