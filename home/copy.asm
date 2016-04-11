FarCopyData::
FarCopyData2::
; Copy bc bytes from a:hl to de.
	ld [wFarCopyDataSavedROMBank], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wFarCopyDataSavedROMBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call CopyData
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

CopyData::
; Copy bc bytes from hl to de.
	inc b
	inc c
	jr .handleLoop
.loop
	ld a, [hli]
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret
