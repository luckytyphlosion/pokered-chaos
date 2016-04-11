chaos_effect_overworld: MACRO
ChaosEffectOverworldJumptable\1::
	dw \2
ENDM

ChaosEffectOverworldJumptable::
	chaos_effect_overworld INSTANT_TEXT, CE_InstantText
	chaos_effect_overworld INVISIBLE_TEXT, CE_InvisibleText
	chaos_effect_overworld REDBAR, CE_Redbar
	chaos_effect_overworld RANDOM_MON_POISON, CE_RandomMonPoison
	chaos_effect_overworld ALL_ENCOUNTERS_JYNX, CE_NoFrameEffect
ChaosEffectOverworldJumptableEnd:
