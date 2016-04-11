chaos_effect_battle: MACRO
ChaosEffectBattleJumptable\1::
	dw \2
ENDM

ChaosEffectBattleJumptable:
	chaos_effect_battle INSTANT_TEXT, CE_InstantText
	chaos_effect_battle INVISIBLE_TEXT, CE_InvisibleText
	chaos_effect_battle REDBAR, CE_Redbar
	chaos_effect_battle CF4B_CORRUPTION, CE_wcf4b
	chaos_effect_battle ALL_CRIES_JYNX, CE_NoFrameEffect
ChaosEffectBattleJumptableEnd:
