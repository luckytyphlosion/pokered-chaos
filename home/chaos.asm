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
	
AreChaosEffectsBetweenBCAndDEActive::
; input:
; bc: start index
; de: end index
; a: type
; return result in the flagarray wChaosEffectRangeFlagArray (40 flags)
	push hl
	call GetChaosEffectListPointer
.loop
; check for terminator
	ld a, [hli]
	or [hl]
	jr z, .done
; compare bc and [hl]
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
; if bc > [hl], try again
	jr c, .notInRange
; compare de and [hl]
	inc hl
	ld a, e
	sub [hl]
	dec hl
	ld a, d
	sbc [hl]
; if equal, we're in the range
	jr z, .inRange
; else, if we're greater, we're not in the range
	jr nc, .notInRange
.inRange
	push hl
	push bc
	inc hl
; read the lower byte of the chaos effect
	ld a, [hl]
; a - c to get difference
; since the maximum difference is only 40 bytes anyway an 8-bit comparison shouldn't affect anything
	sub c
	ld c, a
; flag action predef
	ld hl, wChaosEffectRangeFlagArray
	ld b, FLAG_SET
	predef FlagActionPredef
	pop bc
	pop hl
.notInRange
	inc hl
	inc hl
	jr .loop
.done
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
