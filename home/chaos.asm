IsChaosEffectActive::
; input:
; c: type
; de: effect index
; output:
; set carry if yes, else reset carry
	push hl
	push bc
	ld a, c
	call GetChaosEffectListPointer
.loop
	ld a, [hli]
	ld b, a
	cp d
	jr nz, .firstByteNotEqual
	ld a, [hli]
	cp e
	jr nz, .testEOL
	scf
	jr .done
.firstByteNotEqual
	ld a, [hli]
.testEOL
	or b
	jr z, .notActive
	jr .loop
.notActive
	and a
.done
	pop bc
	pop hl
	ret
	
; given a = type of list, return hl = pointer to start of list
GetChaosEffectListPointer::
	push bc
	ld c, a
	ld b, 0
	ld hl, .ChaosEffectPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret
	
.ChaosEffectPointers:
	dw wOverworldChaosEffects
	dw wBattleChaosEffects
	dw wMenuChaosEffects
