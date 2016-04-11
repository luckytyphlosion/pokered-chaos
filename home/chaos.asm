IsChaosEffectActive::
; input:
; c: type
; de: effect index
; output:
; set carry if yes, else reset carry
	push hl
	push bc
	call CheckChaosEffectType
	cp c
	jr nz, .notActive
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
	
CheckChaosEffectType::
	ld a, [hTrueIsInBattle]
	and a
	ld hl, wOverworldChaosEffects
	ld a, $0
	jr z, .gotEffect
	
	ld a, [hWY]
	and a
	ld hl, wBattleChaosEffects
	ld a, $1
	jr z, .gotEffect
	
	ld hl, wMenuChaosEffects
	ld a, $2
.gotEffect
	ld [hChaosEffectType], a
	ret
