ChaosEffectBattleJumptable::
	dw CE_InstantText
	dw CE_InvisibleText
	dw CE_Redbar
	dw CE_wcf4b
	dw CE_NoFrameEffect
	dw CE_JoypadChaos
	dw CE_RandomPalettes
	dw CE_InaccessibleVRAM
	dw CE_RandomCurMoveNumberEnemy
	dw CE_RandomCurMoveEffectEnemy
	dw CE_RandomCurMovePowerEnemy
	dw CE_RandomCurMoveTypeEnemy
	dw CE_RandomCurMoveAccEnemy
	dw CE_RandomCurMoveNumberPlayer
	dw CE_RandomCurMoveEffectPlayer
	dw CE_RandomCurMovePowerPlayer
	dw CE_RandomCurMoveTypePlayer
	dw CE_RandomCurMoveAccPlayer
	dw CE_RandomCurMoveMaxPPPlayer
	dw CE_Superfast
	dw CE_InaccessibleTilemap
ChaosEffectBattleJumptableEnd::

CE_RandomCurMoveNumberEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy
	jr CE_RandomCurMoveNumber
	
CE_RandomCurMoveNumberPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer

CE_RandomCurMoveNumber:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
.randomLoop
	call Random
	cp NUM_ATTACKS + 1
	jr nc, .randomLoop
	inc a
	ld [de], a
	set 0, [hl]
	ret
.reset
	res 0, [hl]
	ret
	
CE_RandomCurMoveEffectEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 1
	jr CE_RandomCurMoveEffect
	
CE_RandomCurMoveEffectPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 1
	
CE_RandomCurMoveEffect:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 1, [hl]
	ret
.reset
	res 1, [hl]
	ret

CE_RandomCurMovePowerEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 2
	jr CE_RandomCurMovePower
	
CE_RandomCurMovePowerPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 2

CE_RandomCurMovePower:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 2, [hl]
	ret
.reset
	res 2, [hl]
	ret
	
CE_RandomCurMoveTypeEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 3
	jr CE_RandomCurMoveType
	
CE_RandomCurMoveTypePlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 3

CE_RandomCurMoveType:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	and $f
	cp $9
	jr c, .doNotAddOffset
	add $b
.doNotAddOffset
	ld [de], a
	set 3, [hl]
	ret
.reset
	res 3, [hl]
	ret
	
CE_RandomCurMoveAccEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 4
	jr CE_RandomCurMoveAcc
	
CE_RandomCurMoveAccPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 4
	
CE_RandomCurMoveAcc:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 4, [hl]
	ret
.reset
	res 4, [hl]
	ret
	
CE_RandomCurMoveMaxPPPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [wCurMoveCorruptionValuesPlayer+5], a
	set 5, [hl]
	ret
.reset
	res 5, [hl]
	ret
