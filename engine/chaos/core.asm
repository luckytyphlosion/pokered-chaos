dbl: MACRO
	db \1 << 8, \1 & $ff
ENDM

DoChaosEffects:
	ld a, [wd732]
	bit 0, a
	ret z
	call CheckChaosEffectType
	call GetChaosEffectListPointer
	ld d, h
	ld e, l
	ld a, [wPlayTimeFrames]
	and a
	jr nz, .runEffects
	ld a, [wPlayTimeSeconds]
	and a ; 0 seconds
	jr z, .replaceChaosEffect
	cp 30
	jr nz, .runEffects
.replaceChaosEffect
	call ReplaceChaosEffect
	ld a, [hRandomAdd]
	and a
	jr nz, .runEffects
	push hl
	push de
	call CE_AddNewChaosEffect
	pop de
	pop hl
.runEffects
	call GetChaosJumptable
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
	ld a, [hChaosEffectType]
	push af
	push de
	push hl
	xor a
.loop
	ld [hChaosEffectType], a
	call GetChaosEffectListPointer
	ld d, h
	ld e, l
	call _ReplaceChaosEffect
	ld a, [hChaosEffectType]
	inc a
	cp 3
	jr nz, .loop
	pop hl
	pop de
	pop af
	ld [hChaosEffectType], a
	ret

_ReplaceChaosEffect:	
	push hl
	push de
	call GetChaosEffectTypeAndNumberOfChaosEffects
	dec c
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
	ld a, $1
	jr nz, .gotEffect
	
	ld a, [hWY]
	and a
	ld a, $2
	jr z, .gotEffect
	
	xor a
.gotEffect
	ld [hChaosEffectType], a
	ret
	
GetChaosJumptable:
	ld a, [hChaosEffectType]
	ld hl, ChaosJumptables
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
	
ChaosJumptables:
	dw ChaosEffectOverworldJumptable
	dw ChaosEffectBattleJumptable
	dw ChaosEffectMenuJumptable

; trolls code
INCLUDE "engine/chaos/battle.asm"
INCLUDE "engine/chaos/menu.asm"
INCLUDE "engine/chaos/overworld.asm"
INCLUDE "engine/chaos/universal.asm"

NUM_OVERWORLD_CHAOS_EFFECTS EQU (ChaosEffectOverworldJumptableEnd - ChaosEffectOverworldJumptable) / 2 - 1
NUM_BATTLE_CHAOS_EFFECTS EQU (ChaosEffectBattleJumptableEnd - ChaosEffectBattleJumptable) / 2 - 1
NUM_MENU_CHAOS_EFFECTS EQU (ChaosEffectMenuJumptableEnd - ChaosEffectMenuJumptable) / 2 - 1

GetChaosEffectTypeAndNumberOfChaosEffects:
	ld a, [hChaosEffectType]
	ld b, a
	ld c, hNumOverworldChaosEffects & $ff
	add c
	ld c, a
	ld a, [$ff00+c]
	ld c, a
	ret

CE_AddNewChaosEffect:
; get effect type, check that there aren't already 31 effects.
; if 31, don't add any more. else increment
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
; setup c = (numEffects-1)*2 for getting the slot location later
	dec a
	add a
	ld c, a
; get a pointer to the START of this chaos effect list in WRAM
	ld a, b
	call GetChaosEffectListPointer
; get the location of the slot we're inserting into
	ld b, $0
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
	jr .handleLoop
.loop
	srl a
.handleLoop
	sla c
	jr nc, .loop
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
	ld a, c
	and a
	ret nz
	ld a, b
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
