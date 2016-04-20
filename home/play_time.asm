TrackPlayTime: ; 18dee (6:4dee)
	call CountDownIgnoreInputBitReset
	ld a, [wd732]
	bit 0, a
	ret z
	ld a, [wPlayTimeMaxed]
	inc a
	ret z
	ld a, 60
	ld b, a
; frames
	ld hl, wPlayTimeFrames
	inc [hl]
	cp [hl]
	ret nz
	xor a
	ld [hld], a
; seconds
	ld a, b
	inc [hl]
	cp [hl]
	ret nz
	xor a
	ld [hld], a
; minutes
	ld a, b
	inc [hl]
	cp [hl]
	ret nz
	xor a
	ld [hld], a
	dec hl ; skip wPlayTimeMaxed
; hours
	inc [hl]
	ret nz
	dec a
	ld [hli], a ; write $ff to wPlayTimeHours
	ld [hli], a ; write $ff to wPlayTimeMaxed
	ld [hl], 59 ; write 59 to wPlayTimeMinutes
	ret

CountDownIgnoreInputBitReset: ; 18e36 (6:4e36)
	ld hl, wIgnoreInputCounter
	dec [hl]
	ret nz
	ld hl, wd730
	res 1, [hl]
	res 2, [hl]
	bit 5, [hl]
	res 5, [hl]
	ret z
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ret
