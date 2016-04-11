chaos_effect_menu: MACRO
ChaosEffectMenuJumptable\1::
	dw \2
ENDM

ChaosEffectMenuJumptable:
	chaos_effect_menu INSTANT_TEXT, CE_InstantText
	chaos_effect_menu INVISIBLE_TEXT, CE_InvisibleText
	chaos_effect_menu REDBAR, CE_Redbar
	chaos_effect_menu CF4B_CORRUPTION, CE_wcf4b
ChaosEffectMenuJumptableEnd:
