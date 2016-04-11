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
CE_NoFrameEffect:
	ret
	
CE_InvisibleText:
	call CheckIfNextFrameWillReplaceChaosEffect
	ld hl, wFlags_D733
	jr z, .resetFlag
	set 5, [hl]
	ret
.resetFlag
	res 5, [hl]
	ret
	
CE_Redbar:
	call CheckIfNextFrameWillReplaceChaosEffect
	ld hl, wLowHealthAlarm
	jr z, .resetFlag
	set 7, [hl]
	ret
.resetFlag
	res 7, [hl]
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
	ret

CE_JoypadChaos:
	call CheckIfFirstRunthrough
	jr nz, .gotIndex
.rejectionSampleLoop
	call Random
	and $7
	cp $7
	jr nc, .rejectionSampleLoop
	ld [wJoypadChaosIndex], a
	cp $3
	ld a, [hRandomSub]
	jr nc, .writeRandomValue
; button identifier
	and $7
	ld hl, ButtonIdentifiers
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
.writeRandomValue
	ld [wJoyInputModifier], a
.gotIndex
	ld a, [wJoypadChaosIndex]
	add a
	ld c, a
	ld b, $0
	ld hl, JoypadChaosSubEffects
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
	
ButtonIdentifiers:
	db A_BUTTON
	db B_BUTTON
	db SELECT
	db START
	db D_RIGHT
	db D_LEFT
	db D_UP
	db D_DOWN
	
JoypadChaosSubEffects:
; single button
	dw CE_ForceButton
	dw CE_ReleaseButton
	dw CE_InvertButton
; random button modifier
	dw CE_RandomButtonOR
	dw CE_RandomButtonXOR
	dw CE_RandomButtonNAND
; odd one out
	dw CE_ComplementJoypad
	
CE_RandomButtonOR:
CE_ForceButton:
	ld a, [wJoyInputModifier]
	ld b, a
	ld a, [hJoyInput]
	or b
	ld [hJoyInput], a
	ret
	
CE_RandomButtonNAND:
CE_ReleaseButton:
	ld a, [wJoyInputModifier]
	cpl
	ld b, a
	ld a, [hJoyInput]
	and b
	ld [hJoyInput], a
	ret

CE_RandomButtonXOR:
CE_InvertButton:
	ld a, [wJoyInputModifier]
	ld b, a
	ld a, [hJoyInput]
	xor b
	ld [hJoyInput], a
	ret
	
CE_ComplementJoypad:
	ld a, [hJoyInput]
	cpl
	ld [hJoyInput], a
	ret
	
CE_RandomPalettes:
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld b, a
	and %11000000
	jr nz, .predefinedPalette
	ld hl, wTempBGP
	ld d, h
	ld e, l
	ld c, $4
.randomLoop
	call Random
	ld [hli], a
	ld a, [hRandomSub]
	ld [hli], a
	dec c
	jr nz, .randomLoop
; copy the random palette to the other palettes
; restore hl back from earlier
	ld h, d
	ld l, e
	ld de, wTempOBP0
	ld bc, $8
	call CopyData
	ld bc, $8
; registers auto incremented
	jp CopyData
.predefinedPalette
	and $f
	ld b, a
	ld a, [wCurPalette]
	cp b
	jr c, .doNotIncrementRandomPalette
	inc b
.doNotIncrementRandomPalette
	ld a, b
	ld [wCurPalette], a
	ret
	
CE_InaccessibleVRAM:
	call CheckIfNextFrameWillReplaceChaosEffect
	ld hl, wd736
	jr z, .reset
	set 3, [hl]
	ret
.reset
	res 3, [hl]
	ret