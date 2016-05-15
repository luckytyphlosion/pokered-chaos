FarCopyDataDouble::
; Expand bc bytes of 1bpp image data
; from a:hl to 2bpp data at de.
	ld [wFarCopyDataSavedROMBank],a
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wFarCopyDataSavedROMBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld a,h ; swap hl and de
	ld h,d
	ld d,a
	ld a,l
	ld l,e
	ld e,a
	
	call CopyDataDouble
	
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

CopyDataDouble:
	inc b
	inc c
	jr .handleLoop
.expandloop
	ld a,[de]
	inc de
	ld [hli],a
	ld [hli],a
.handleLoop
	dec c
	jr nz, .expandloop
	dec b
	jr nz, .expandloop
	ret
	
WaitUntilHBlankStartPeriod:
	ld a, [rLY]
	cp $90
	jr nc, .inVBlank
	cp $7e
	call nc, SafeDelayFrame
.inVBlank
	ld a, [rSTAT]
	and $3
	jr z, WaitUntilHBlankStartPeriod
.waitForHBlankLoop
	ld a, [rSTAT]
	and $3
	jr nz, .waitForHBlankLoop
	ret
	
SetVCopyForcedDelay:
; save number of tiles to copy to simulate the delay in vanilla pokered
; first, divide the number of tiles by 8
	push bc
	ld a, c ; save number of tiles in a
	srl c
	srl c
	srl c ; divide by 8
; check for lower 3 bits of tile count
	and %111 ; if tile count isn't a multiple of 8, increase the frame count
	jr z, .doNotIncreaseFrameCount
	inc c
.doNotIncreaseFrameCount
	ld a, c
	ld [H_VBCOPYFRAMECOUNTER], a
	pop bc
	ret
	
CopyVideoData::
; Wait for the next VBlank, then copy c 2bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.

	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a

	ld a, [H_LOADEDROMBANK]
	push af

	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
; set forced delay
	call SetVCopyForcedDelay
; swap hl and de
	push hl
	ld h, d
	ld l, e
	pop de
; get raw byte count for copy
	swap c
	ld a,$f
	and c
	ld b,a
	ld a,$f0
	and c
	ld c,a
; check for inaccessible vram copies
	ld a, [wd736]
	bit 3, a
	jr z, .regularCopy
	call CopyData
	jr .doneInaccessibleCopy
.regularCopy
; copy 2 bytes every frame, using hblank
; first, divide bc by 2 to account for the double copy
	srl b
	rr c
; now copy every hblank period
.copyLoop
	call WaitUntilHBlankStartPeriod
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .copyLoop
; forced delay to simulate the original vcopy delay
	ld a, [H_VBCOPYFRAMECOUNTER]
	and a
	ld c, a
	call nz, DelayFrames
.doneInaccessibleCopy
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

CopyVideoDataDouble::
; Wait for the next VBlank, then copy c 1bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, [H_LOADEDROMBANK]
	push af

	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	ld a, [wd736]
	bit 3, a
	jr z, .regularCopy
	call CopyDataDouble
	jr .doneInaccesibleCopy
.regularCopy
; get frame count for forced delay
	call SetVCopyForcedDelay
; get raw byte count at the same time
	push hl
; use hl for 16-bit arithmetic to quadruple tile count
	ld h, $0
	ld l, c
	add hl, hl
	add hl, hl
	ld b, h
	ld c, l
; restore hl
	pop hl
.copyLoop
	call WaitUntilHBlankStartPeriod
	ld a, [de]
	ld [hli], a
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .copyLoop
; forced delay to simulate the original vcopy delay
	ld a, [H_VBCOPYFRAMECOUNTER]
	and a
	ld c, a
	call nz, DelayFrames
.doneInaccesibleCopy
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

ClearScreenArea::
; Clear tilemap area cxb at hl.
	ld a, " " ; blank tile
	ld de, 20 ; screen width
.y
	push hl
	push bc
.x
	ld [hli], a
	dec c
	jr nz, .x
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, .y
	ret

CopyScreenTileBufferToVRAM::
; Copy wTileMap to the BG Map starting at b * $100.
; This is done in thirds of 6 rows, so it takes 3 frames.
	ld a, [rLY]
	cp $81
	call nc, DelayFrame ; if ly is past $80, then wait for another vblank for the tilemap to be successfully copied
						; not exactly sure if needed
	ld a, [H_AUTOBGTRANSFERDEST + 1]
	push af
	ld a, [H_AUTOBGTRANSFERDEST]
	push af
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a
	ld [H_AUTOBGTRANSFERDEST], a
	ld a, b
	ld [H_AUTOBGTRANSFERDEST + 1], a
	ld [H_AUTOBGTRANSFERENABLED], a
	call SafeDelayFrame
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	pop af
	ld [H_AUTOBGTRANSFERDEST], a
	pop af
	ld [H_AUTOBGTRANSFERDEST + 1], a
	ret

ClearScreen::
; Clear wTileMap, then wait
; for the bg map to update.
	ld bc, 20 * 18
	inc b
	coord hl, 0, 0
	ld a, " "
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3

SafeDelayFrame:
	ld a, [wChaosFlags1]
	set 3, a
	ld [wChaosFlags1], a
	call DelayFrame
	ld a, [wChaosFlags1]
	res 3, a
	ld [wChaosFlags1], a
	ret