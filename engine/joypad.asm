_Joypad::
; hJoyReleased: (hJoyLast ^ hJoyInput) & hJoyLast
; hJoyPressed:  (hJoyLast ^ hJoyInput) & hJoyInput

	ld a, [hTrueJoyInput]
	cp A_BUTTON + B_BUTTON + SELECT + START ; soft reset
	jp z, TrySoftReset
SoftResetDidNotWork:
	ld a, [hJoyInput]
	ld b, a
	ld a, [hJoyLast]
	ld e, a
	xor b
	ld d, a
	and e
	ld [hJoyReleased], a
	ld a, d
	and b
	ld [hJoyPressed], a
	ld a, b
	ld [hJoyLast], a

	ld a, [wd730]
	bit 5, a
	jr nz, DiscardButtonPresses

	ld a, [hJoyLast]
	ld [hJoyHeld], a

	ld a, [wJoyIgnore]
	and a
	ret z

	cpl
	ld b, a
	ld a, [hJoyHeld]
	and b
	ld [hJoyHeld], a
	ld a, [hJoyPressed]
	and b
	ld [hJoyPressed], a
	ret

DiscardButtonPresses:
	xor a
	ld [hJoyHeld], a
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ret

TrySoftReset:
	ld hl, hSoftReset
.loop
	call DelayFrame
	ld a, [hTrueJoyInput]
	and A_BUTTON | B_BUTTON | START | SELECT
	cp A_BUTTON | B_BUTTON | START | SELECT
	jp nz, SoftResetDidNotWork
	dec [hl]
	jr nz, .loop
	jp SoftReset
