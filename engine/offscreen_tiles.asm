CopyOffscreenTilesToWRAMBuffer::
	di
	ld a, [rSVBK]
	ld [hSavedWRAMBank], a
	ld a, $2
	ld [rSVBK], a
	ld hl, OffscreenTilesFunctions
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
OffscreenTiles_DoneFunction:
	ld a, [hSavedWRAMBank]
	ld [rSVBK], a
	reti
	
OffscreenTilesFunctions:
	dw ClearBackground ; pad with $7f
	dw BlackBars
	
ClearBackground:
	ld a, $7f
	ld b, SCREEN_HEIGHT
	ld de, SCREEN_WIDTH
	ld hl, $d000 + SCREEN_WIDTH
.loop
	ld c, $20 - SCREEN_WIDTH
.innerloop
	ld [hli], a
	dec c
	jr nz, .innerloop
	add hl, de
	dec b
	jr nz, .loop
	jp OffscreenTiles_DoneFunction
	
BlackBars:
	ld a, $1 ; intro black tile
	ld b, $4
	ld de, SCREEN_WIDTH
	ld hl, $d000 + SCREEN_WIDTH
.loop
	ld c, $20 - SCREEN_WIDTH
.innerloop
	ld [hli], a
	dec c
	jr nz, .innerloop
	add hl, de
	dec b
	jr nz, .loop
	
	xor a
	ld b, 10
	ld de, SCREEN_WIDTH
	ld hl, $d000 + 4 * $20 + SCREEN_WIDTH
.loop2
	ld c, $20 - SCREEN_WIDTH
.innerloop2
	ld [hli], a
	dec c
	jr nz, .innerloop2
	add hl, de
	dec b
	jr nz, .loop2
	
	ld a, $1 ; intro black tile
	ld b, $4
	ld de, SCREEN_WIDTH
	ld hl, $d000 + 14 * $20 + SCREEN_WIDTH
.loop3
	ld c, $20 - SCREEN_WIDTH
.innerloop3
	ld [hli], a
	dec c
	jr nz, .innerloop3
	add hl, de
	dec b
	jr nz, .loop3
	jp OffscreenTiles_DoneFunction