CE_RandomMonPoison:
	call CheckIfFirstRunthrough
	ret nz
	ld a, [wPartyCount]
	and a
	ret z
	ld d, a
	ld e, a
	ld hl, wPartyMon1Status
	ld bc, wPartyMon2 - wPartyMon1
.checkAllPoisonedLoop
	bit PSN, [hl]
	jr z, .setPoisonLoop
	dec e
	jr nz, .checkAllPoisonedLoop
	ret
.setPoisonLoop
	call Random
	and $7
	cp d
	jr nc, .setPoisonLoop
	ld hl, wPartyMon1Status
	call AddNTimes
	bit PSN, [hl]
	jr nz, .setPoisonLoop
	set PSN, [hl]
	ret
