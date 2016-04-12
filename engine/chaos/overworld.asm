ChaosEffectOverworldJumptable::
	dw CE_Redbar
	dw CE_RandomMonPoison
	dw CE_NoFrameEffect
	dw CE_JoypadChaos
	dw CE_RandomPalettes
	dw CE_InaccessibleVRAM
	dw CE_CyclingRoad
	dw CE_RandomJackMode
	dw CE_RandomEncounterRate
ChaosEffectOverworldJumptableEnd::

CE_RandomMonPoison:
	ret
	call CheckIfFirstRunthrough
	ret nz
	ld a, [wPartyCount]
	and a
	ret z
	ld d, a
	ld e, a
	ld hl, wPartyMon1Status
	ld bc, wPartyMon2 - wPartyMon1
.checkAllPoisonedLoop
	bit PSN, [hl]
	jr z, .setPoisonLoop
	dec e
	jr nz, .checkAllPoisonedLoop
	ret
.setPoisonLoop
	call Random
	and $7
	cp d
	jr nc, .setPoisonLoop
	ld hl, wPartyMon1Status
	call AddNTimes
	bit PSN, [hl]
	jr nz, .setPoisonLoop
	set PSN, [hl]
	ret

CE_CyclingRoad:
	call CheckIfNextFrameWillReplaceChaosEffect
	ld hl, wFlags_D733
	jr z, .reset
	set 6, [hl]
	ret
.reset
	res 6, [hl]
	ret
	
CE_RandomJackMode:
	call CheckIfFirstRunthrough
	ret nz
	xor a
	ld [wUpdateSpritesEnabled], a
	ret
	
CE_RandomEncounterRate:
	call CheckIfFirstRunthrough
	jr nz, .applySubmod
	call Random
	ld [wNewEncounterRateFlags], a
.applySubmod
	ld a, [wNewEncounterRateFlags]
	and $3
	add a
	ld e, a
	ld d, $0
	ld hl, RandomEncounterRateSubmods
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
	
RandomEncounterRateSubmods:
	dw RandomEncRate_AddRange0to31
	dw RandomEncRate_AddRangeNEG31to31
	dw RandomEncRate_Write0
	dw RandomEncRate_Write255
	
RandomEncRate_AddRange0to31:
	ld a, [wNewEncounterRateFlags]
	srl a
	srl a
	and $1f
AddRandomEncRateDeltas:
	ld b, a
	ld a, [wGrassRate]
	add b
	ld [wGrassRate], a
	ld a, [wWaterRate]
	add b
	ld [wWaterRate], a
	ret
	
RandomEncRate_AddRangeNEG31to31:
	ld a, [wNewEncounterRateFlags]
	srl a
	srl a
	sub 31
	jr AddRandomEncRateDeltas
	
RandomEncRate_Write0:
	xor a
	jr WriteNewEncounterRates
	
RandomEncRate_Write255:
	ld a, 255
WriteNewEncounterRates:
	ld [wGrassRate], a
	ld [wWaterRate], a
	ret
	
