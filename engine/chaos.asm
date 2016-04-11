DoChaosEffects:
	ld a, [wd732]
	bit 0, a
	ret z
	call CheckChaosEffectType
	ld a, [wPlayTimeFrames]
	and a
	jr nz, .loop
	ld a, [wPlayTimeSeconds]
	and a ; 0 seconds
	jr z, .replaceChaosEffect
	cp 30
	jr nz, .loop
.replaceChaosEffect
	call ReplaceChaosEffect
	ld a, [hRandomAdd]
	and a
	jr nz, .loop
	push hl
	push de
	call CE_AddNewChaosEffect
	pop de
	pop hl
.loop
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	or b
	ret z
	inc de
	dec bc
	push de
	push hl
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [wPlayTimeSeconds]
	ld b, a
	ld a, [wPlayTimeFrames]
	ld c, a
	
	call JumpToAddress
	pop hl
	pop de
	jr .loop
	
ReplaceChaosEffect:
	push hl
	push de
	call GetChaosEffectTypeAndNumberOfChaosEffects
	ld b, c
	call DetermineBitmaskForRandomRange
	ld c, a
.rejectionSampleLoop
	call Random
	and c
	cp b
	jr z, .gotNumber
	jr nc, .rejectionSampleLoop
.gotNumber
	ld h, d
	ld l, e
	add a
	ld c, a
	ld b, $0
	add hl, bc
	call CE_WriteChaosEffect
	pop de
	pop hl
	ret
	
CheckChaosEffectType:
	ld a, [hTrueIsInBattle]
	and a
	ld hl, ChaosEffectOverworldJumptable
	ld de, wOverworldChaosEffects
	ld a, $0
	jr z, .gotEffect
	
	ld a, [hWY]
	and a
	ld hl, ChaosEffectBattleJumptable
	ld de, wBattleChaosEffects
	ld a, $1
	jr z, .gotEffect
	
	ld hl, ChaosEffectMenuJumptable
	ld de, wMenuChaosEffects
	ld a, $2
.gotEffect
	ld [hChaosEffectType], a
	ret

GetChaosEffectTypeAndNumberOfChaosEffects:
	ld a, [hChaosEffectType]
	ld b, a
	ld c, hNumOverworldChaosEffects & $ff
	add c
	ld c, a
	ld a, [$ff00+c]
	ld c, a
	ret
	
ChaosEffectOverworldJumptable:
	dw CE_InstantText
	dw CE_InvisibleText
	dw CE_Redbar
	dw CE_RandomMonPoison
	
ChaosEffectOverworldJumptableEnd:

ChaosEffectBattleJumptable:
	dw CE_InstantText
	dw CE_InvisibleText
	dw CE_Redbar
	dw CE_wcf4b
	
ChaosEffectBattleJumptableEnd:

ChaosEffectMenuJumptable:
	dw CE_InstantText
	dw CE_InvisibleText
	dw CE_Redbar
	dw CE_wcf4b
	
ChaosEffectMenuJumptableEnd:
	
NUM_OVERWORLD_CHAOS_EFFECTS EQU (ChaosEffectOverworldJumptableEnd - ChaosEffectOverworldJumptable) / 2 - 1
NUM_BATTLE_CHAOS_EFFECTS EQU (ChaosEffectBattleJumptableEnd - ChaosEffectBattleJumptable) / 2 - 1
NUM_MENU_CHAOS_EFFECTS EQU (ChaosEffectMenuJumptableEnd - ChaosEffectMenuJumptable) / 2 - 1

dbl: MACRO
	db \1 << 8, \1 & $ff
ENDM

CE_AddNewChaosEffect:
	ld a, [hChaosEffectType]
	ld b, a
	ld c, hNumOverworldChaosEffects & $ff
	add c
	ld c, a
	ld a, [$ff00+c]
	cp 31
	ret nc
	inc a
	ld [$ff00+c], a
	
	ld c, b
	ld b, $0
	ld hl, ChaosEffectPointers
	add hl, bc
	add hl, bc
	
	dec a
	add a
	ld c, a
	ld b, $0
	
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	add hl, bc
CE_WriteChaosEffect:
	ld a, [hChaosEffectType]
	and a
	ld de, NUM_OVERWORLD_CHAOS_EFFECTS
	jr z, .gotNumEffects
	dec a
	ld de, NUM_BATTLE_CHAOS_EFFECTS
	jr z, .gotNumEffects
	ld de, NUM_MENU_CHAOS_EFFECTS
.gotNumEffects
	call GetRandomRangeFor16BitValue
	inc de
	ld a, d
	ld [hli], a
	ld [hl], e
	ret
	
ChaosEffectPointers:
	dw wOverworldChaosEffects
	dw wBattleChaosEffects
	dw wMenuChaosEffects
	
InitializeChaosEffects:
	ld c, 3
.outerLoop
	ld b, 3
.innerLoop
	push bc
	call CE_AddNewChaosEffect
	pop bc
	dec b
	jr nz, .innerLoop
	ld a, [hChaosEffectType]
	inc a
	ld [hChaosEffectType], a
	dec c
	jr nz, .outerLoop
	ret
	
DetermineBitmaskForRandomRange:
; find a bitmask for the value in a
; and return it in a
	and a
	ret z
	ld c, a
	ld a, $ff
.loop
	sla c
	jr c, .done
	srl a
	jr .loop
.done
	ret

GetRandomRangeFor16BitValue:
	ld a, d
	and a
	jr z, .handleEightBitValue
	call DetermineBitmaskForRandomRange
	ld c, a
.rejectionSampleLoop1
	call Random
	and c
	cp h
	jr z, .doRejectionSampleLoop2
	jr nc, .rejectionSampleLoop1
	ld d, a
	call Random
	ld e, a
	pop de
	ret
.doRejectionSampleLoop2
	ld d, a
	call Random
	cp e
	jr z, .gotLowerByte
	jr nc, .handleEightBitValue
.gotLowerByte
	ld e, a
	ret

.handleEightBitValue
	ld a, e
	call DetermineBitmaskForRandomRange
	ld c, a
.eightBitValueRejectionLoop
	call Random
	and c
	cp e
	jr z, .gotLowerByte2
	jr nc, .eightBitValueRejectionLoop
.gotLowerByte2
	ld e, a
	ret

CheckIfFirstRunthrough:
	ld a, b
	or c
	ret z
	cp 30
	ret
	
CheckIfNextFrameWillReplaceChaosEffect:
	ld a, c
	cp 59
	ret nz
	ld a, b
	cp 29
	ret z
	cp 59
	ret
	
CE_InstantText:
	call CheckIfFirstRunthrough
	jr nz, .notFirstRun
	ld a, [wOptions]
	ld [wSavedOptions], a
	and $f0
	ld [wOptions], a
	ret
.notFirstRun
	call CheckIfNextFrameWillReplaceChaosEffect
	ret nz
	ld a, [wSavedOptions]
	ld [wOptions], a
	ret
	
CE_InvisibleText:
	ld hl, wFlags_D733
	set 5, [hl]
	ret
	
CE_Redbar:
	ld hl, wLowHealthAlarm
	set 7, [hl]
	ret
	
CE_wcf4b::
	call Random
	and $f
	ld c, a
	ld b, $0
	ld hl, wcf4b
	add hl, bc
	ld a, [hl]
	ld a, [hRandomSub]
	ld [hli], a
	ld [hl], "@"
	ret
	
CE_RandomMonPoison:
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
	