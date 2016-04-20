VBlank::

	push af
	push bc
	push de
	push hl
	ld a, [H_LOADEDROMBANK]
	ld [wVBlankSavedROMBank], a

	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ld a, [hWY]
	ld [rWY], a
.ok
	call AutoBgMapTransfer
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
	call WriteCGBPalettes
	
	ld a, [wChaosFlags1]
	bit 2, a
	call z, $ff80 ; hOAMDMA

	ld a, [wd732]
	bit 7, a
	jr z, .doNotPrepareOAMData
	ld a, BANK(PrepareOAMData)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call PrepareOAMData
.doNotPrepareOAMData
	; VBlank-sensitive operations end.

	call Random

	xor a
	ld [H_VBLANKOCCURRED], a

	ld a, [H_FRAMECOUNTER]
	and a
	jr z, .skipDec
	dec a
	ld [H_FRAMECOUNTER], a

.skipDec
	call FadeOutAudio
	
	callab Music_DoLowHealthAlarm

	ld a, [wAudioROMBank] ; music ROM bank
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	cp BANK(Audio1_UpdateMusic)
	jr nz, .checkForAudio2
.audio1
	call Audio1_UpdateMusic
	jr .afterMusic
.checkForAudio2
	cp BANK(Audio2_UpdateMusic)
	jr nz, .audio3
.audio2
	call Audio2_UpdateMusic
	jr .afterMusic
.audio3
	call Audio3_UpdateMusic
.afterMusic
	call TrackPlayTime ; keep track of time played

	ld a, [hDisableJoypadPolling]
	and a
	call z, ReadJoypad
	
	callab DoChaosEffects
	
	ld a, [wChaosFlags1]
	bit 0, a
	jr z, .doNotCopyTilemap
	ld a, [H_AUTOBGTRANSFERENABLED]
	and a
	jr z, .doNotCopyTilemap
	call WaitForNonVBlankPeriod
	call InaccessibleVRAMTileMapTransfer
.doNotCopyTilemap
	ld a, [wChaosFlags1]
	bit 1, a
	jr z, .doNotCopyScreenEdge
	ld a, [hRedrawRowOrColumnMode]
	and a
	jr z, .doNotCopyScreenEdge
	call WaitForNonVBlankPeriod
	call RedrawRowOrColumnInaccessible
.doNotCopyScreenEdge
	ld a, [wChaosFlags1]
	bit 2, a
	jr z, .afterInaccessibleFunctions
	call WaitForNonVBlankPeriod
	ld hl, wOAMBuffer
	ld de, $fe00
	ld bc, 4 * 40
	call CopyData
.afterInaccessibleFunctions
	ld a, [wVBlankSavedROMBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	pop hl
	pop de
	pop bc
	pop af
	reti

WaitForNonVBlankPeriod:
	ld a, [rLY]
	cp $90
	jr nc, WaitForNonVBlankPeriod
	ret
	
DelayFrame::
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

NOT_VBLANKED EQU 1

	ld a, [wd732]
	bit 7, a
	ret nz
	push hl
	push bc
	push de
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, Bank(PrepareOAMData)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call PrepareOAMData
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	pop de
	pop bc
	pop hl
	ld a, NOT_VBLANKED
	ld [H_VBLANKOCCURRED], a
.halt
	halt
	ld a, [H_VBLANKOCCURRED]
	and a
	jr nz, .halt
	ret
