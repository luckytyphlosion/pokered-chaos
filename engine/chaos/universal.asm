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
	ld hl, wLowHealthAlarm
	set 7, [hl]
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
	ld [hl], "@"
	ret
