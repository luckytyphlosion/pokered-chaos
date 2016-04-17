ChaosEffectOverworldJumptable::
	dw CE_Redbar
	dw CE_RandomMonPoison
	dw CE_NoFrameEffect
	dw CE_JoypadChaos
	dw CE_RandomPalettes
	dw CE_InaccessibleVRAM
	dw CE_CyclingRoad
	dw CE_RandomJackMode
	dw CE_RandomEncounterRate
	dw CE_SSD_MovementStatus ; set to 3, instant
	dw CE_SSD_YDelta ; "any" value (larger = more chaos), continuous
	dw CE_SSD_XDelta ; "any" value (larger = more chaos), continuous
	dw CE_SSD_PixelYPos ; "any" value (don't go out of range obvs), continuous because ledges
	dw CE_SSD_PixelXPos ; "any" value (don't go out of range obvs), continuous because ledges
	dw CE_SSD_IntraAnimFrameCounter ; any value, only thing it does it freeze the player animation, continuous
	dw CE_SSD_AnimFrameCounter ; any value, codemod (force base value) + continuous []
	dw CE_SSD_Visibility ; any non-ff value, continuous
	dw CE_SSD_FacingDirection ; any value, codemod (force base value) + continuous
	dw CE_SSD_NPCWalkCounter ; any value, codemod (force start value)
	dw CE_SSD_GridYPos ; "any" value, instant
	dw CE_SSD_GridXPos ; "any" value, instant
	dw CE_SSD_MovementByte ; set to fe for randumb movement, instant
	dw CE_SSD_GrassMask ; set to 80 for grassmask, continuous
	dw CE_SSD_MovementDelay ; "any" value (lower = more chaos), continuous
	dw CE_SSD_SpriteImageBaseOffset ; "any" value, continuous
ChaosEffectOverworldJumptableEnd::

CE_RandomMonPoison:
	ret
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

CE_CyclingRoad:
	call CheckIfNextFrameWillReplaceChaosEffect
	ld hl, wFlags_D733
	jr z, .reset
	set 6, [hl]
	ret
.reset
	res 6, [hl]
	ret
	
CE_RandomJackMode:
	call CheckIfFirstRunthrough
	ret nz
	xor a
	ld [wUpdateSpritesEnabled], a
	ret
	
CE_RandomEncounterRate:
	call CheckIfFirstRunthrough
	jr nz, .applySubmod
	call Random
	ld [wNewEncounterRateFlags], a
.applySubmod
	ld a, [wNewEncounterRateFlags]
	and $3
	add a
	ld e, a
	ld d, $0
	ld hl, RandomEncounterRateSubmods
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
	
RandomEncounterRateSubmods:
	dw RandomEncRate_AddRange0to31
	dw RandomEncRate_AddRangeNEG31to31
	dw RandomEncRate_Write0
	dw RandomEncRate_Write255
	
RandomEncRate_AddRange0to31:
	ld a, [wNewEncounterRateFlags]
	srl a
	srl a
	and $1f
AddRandomEncRateDeltas:
	ld b, a
	ld a, [wGrassRate]
	add b
	ld [wGrassRate], a
	ld a, [wWaterRate]
	add b
	ld [wWaterRate], a
	ret
	
RandomEncRate_AddRangeNEG31to31:
	ld a, [wNewEncounterRateFlags]
	srl a
	srl a
	sub 31
	jr AddRandomEncRateDeltas
	
RandomEncRate_Write0:
	xor a
	jr WriteNewEncounterRates
	
RandomEncRate_Write255:
	ld a, 255
WriteNewEncounterRates:
	ld [wGrassRate], a
	ld [wWaterRate], a
	ret	

CE_SSD_GetRandomSpriteIndex_IgnorePlayer:
	ld b, $1
	jr CE_SSD_GetRandomSpriteIndexCommon
	
; fallthrough
CE_SSD_GetRandomSpriteIndex:
; get a random sprite between 0 and wNumSprites
; and return in a
	ld b, $0
CE_SSD_GetRandomSpriteIndexCommon:
	ld a, [wNumSprites]
	inc a
	ld c, a
.randomLoop
	call Random
	and $f
	cp b
	jr c, .randomLoop
	cp c
	jr nc, .randomLoop
	ret
	
CE_SSD_CanSpriteMove:
; check if the sprite in a can move
; return carry if yes, else return no carry
	push hl
	push af
	ld hl, wSpriteStateData2 + $6
	swap a
	add l
	ld l, a
	ld a, [hl]
	and a
	jr z, .canMove
	inc a
	jr z, .cannotMove
	inc a
	jr z, .canMove
.cannotMove
	pop af
	pop hl
	and a
	ret
.canMove
	pop af
	pop hl
	scf
	ret
	
CE_SSD_DoesNonMovingSpriteExist:
	ld d, $ff
	jr CE_SSD_CanSpritesMoveCommon
	
CE_SSD_CanAnySpriteMove:
; check if any sprite on the map can move
; return carry if yes, else return no carry
	ld d, $fe

CE_SSD_CanSpritesMoveCommon:
	push hl
	push bc
	ld hl, wSpriteStateData2 + $16
	ld bc, $10
	ld e, 15
	jr .handleLoop
.loop
	add hl, bc
.handleLoop
	ld a, [hl]
	cp d
	jr z, .canMove
	and a
	jr z, .noSpritesCanMove
	dec e
	jr nz, .loop
; no sprites can move
	jr .noSpritesCanMove
.canMove
	scf
.noSpritesCanMove
	pop bc
	pop hl
	ret

CE_SSD_IsSpriteInMotion:
; check if the sprite in a is in motion (even if moonwalking)
	and a
	jr z, .inMotion
	push hl
	push bc
	push af
	swap a
	ld l, a
	ld h, $0
	ld bc, wSpriteStateData1 + $11
	add hl, bc
	ld a, [hl]
	cp $3
	jr z, .inMotion
	ld bc, wSpriteStateData2 + $16
	add hl, bc
	ld a, [hl]
	inc a
	jr z, .notInMotion
	inc a
	jr z, .inMotion
.notInMotion
	pop af
	pop bc
	pop hl
	and a
	ret
.inMotion
	pop af
	pop bc
	pop hl
	scf
	ret
	
CE_SSD_CanAnySpriteBeInMotion:
; check if any sprite is in motion (even if moonwalking)
; return c if yes, else return nc
	push hl
	push bc
	push de
	ld bc, $10
	ld hl, wSpriteStateData1 + $11
	ld de, wSpriteStateData2 + $16
	ld a, 15
	ld [hChaosEffectTemp], a
	jr .handleLoop
.loop
	add hl, bc
	ld a, $10
	add e
	ld e, a
.handleLoop
	ld a, [hl]
	and a
	jr z, .noneInMotion
	cp $3
	jr z, .isInMotion
	ld a, [de]
	cp $fe
	jr z, .isInMotion
	ld a, [hChaosEffectTemp]
	dec a
	ld [hChaosEffectTemp], a
	jr nz, .loop
; none in motion
.noneInMotion
	pop de
	pop bc
	pop hl
	and a
	ret
.isInMotion
	pop de
	pop bc
	pop hl
	scf
	ret

CE_SSD_MovementStatus:
	call CheckIfFirstRunthrough
	ret nz
	ld a, [wNumSprites]
	and a
	ret z
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData1 + $1
	add hl, bc
	ld [hl], $3
	ret

CE_SSD_YDelta:
	xor a
	ld hl, wSSDCorruptionFlags
	set 0, [hl]
	jr CE_SSD_DeltaCommon
	
CE_SSD_XDelta:
	ld a, $1
	ld hl, wSSDCorruptionFlags
	set 1, [hl]
	
CE_SSD_DeltaCommon:
	ld [wSSDWhichCoord], a
	call CheckIfFirstRunthrough
	jr z, .firstRunthrough
	call CheckIfNextFrameWillReplaceChaosEffect
	ret nz
	res 0, [hl]
	res 1, [hl]
	ret
.firstRunthrough
	ld a, [wSSDWhichCoord]
	ld c, a
	ld b, $0
	ld hl, wSSDWhichSprite
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wSSDCorruptionValues
	add hl, bc
	call CE_SSD_CanAnySpriteBeInMotion
	jr c, .checkIfOnlyPlayerOnMap
; if no sprites can be in motion, pick an unbiased value
; in case the sprite could move in the future
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	jr .writeValue
.checkIfOnlyPlayerOnMap
	ld a, [wNumSprites]
	and a
	ret z
.randomLoop
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	call CE_SSD_CanSpriteMove
	
	jr nc, .randomLoop
.writeValue
	ld [de], a
	;jr z, .handlePlayer
; set ydelta for npc
	call Random
	and $7
	sub $3
	jr z, .decrementOnce
	jr nc, .doNotDecrementOnce
.decrementOnce
	dec a
.doNotDecrementOnce
	ld [hl], a
	ret
;.handlePlayer
; player simply has value doubled, tripled or quadrupled
;	call Random
;	and $3
;	jr z, .handlePlayer
;	inc a
;	ld [hl], a
;	ret
	
CE_SSD_PixelYPos:
	ld hl, wSSDCorruptionFlags
	set 2, [hl]
	
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 2, [hl]
.doNotResetFlag
	call CheckIfFirstRunthrough
	jr nz, .applyEffects
	call CE_SSD_GetRandomSpriteIndex
	ld [wSSDWhichSprite + 2], a
.randomLoop
	call Random
	cp $90
	jr nc, .randomLoop
	ld c, a
	ld a, [hRandomSub]
	and $f
	jr nz, .doNotAddOffset
	call Random
	and $f
	add c
	ld c, a
.doNotAddOffset
	ld a, c
	ld [wSSDCorruptionValues + 2], a
.applyEffects
	ld a, [wSSDWhichSprite + 2]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData1 + 4
	add hl, bc
	ld a, [wSSDCorruptionValues + 2]
	ld [hl], a
	ret
	
CE_SSD_PixelXPos:
	ld hl, wSSDCorruptionFlags
	set 3, [hl]
	
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 3, [hl]
.doNotResetFlag
	call CheckIfFirstRunthrough
	jr nz, .applyEffects
	call CE_SSD_GetRandomSpriteIndex
	ld [wSSDWhichSprite + 3], a
.randomLoop
	call Random
	cp $a0
	jr nc, .randomLoop
	ld c, a
	ld a, [hRandomSub]
	and $f
	jr nz, .doNotAddOffset
	call Random
	and $f
	add c
	ld c, a
.doNotAddOffset
	ld a, c
	ld [wSSDCorruptionValues + 3], a
.applyEffects
	ld a, [wSSDWhichSprite + 3]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData1 + 6
	add hl, bc
	ld a, [wSSDCorruptionValues + 3]
	ld [hl], a
	ret
	
CE_SSD_IntraAnimFrameCounter:
	call CheckIfFirstRunthrough
	jr nz, .applyEffects
.randomLoop
	call CE_SSD_GetRandomSpriteIndex
	call CE_SSD_CanSpriteMove
	jr nc, .randomLoop
.writeValue
	ld [wSSDWhichSprite + 4], a
.applyEffects
	ld a, [wSSDWhichSprite + 4]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData1 + $7
	add hl, bc
	ld [hl], $1
	ret
	
CE_SSD_AnimFrameCounter:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetValue
	xor a
	ld [wSSDCorruptionValues + 4], a
	ret
.doNotResetValue
	call CheckIfFirstRunthrough
	ret nz
	call CE_SSD_GetRandomSpriteIndex
	ld [wSSDWhichSprite + 5], a
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData1 + $8
	add hl, bc
	call Random
	ld [wSSDCorruptionValues + 4], a
	ld [hl], a
	ret

CE_SSD_Visibility:
	ld hl, wSSDCorruptionFlags
	set 4, [hl]
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 4, [hl]
	ret
.doNotResetFlag
	call CheckIfFirstRunthrough
	ret nz
; get sprite slot
	ld a, [wNumSprites]
	and a
	ret z
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	ld [wSSDWhichSprite + 6], a
	ret

CE_SSD_FacingDirection:
	ld hl, wSSDCorruptionFlags
	set 5, [hl]
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 5, [hl]
	ret
.doNotResetFlag
	call CheckIfFirstRunthrough
	ret nz
; get sprite slot
	call CE_SSD_GetRandomSpriteIndex
	ld [wSSDWhichSprite + 7], a
; get random facing direction
	call Random
	and $3
	ld c, a
	inc c
	xor a
	jr .handleLoop
.loop
	add $4
.handleLoop
	dec c
	jr nz, .loop
	ld [wSSDCorruptionValues + 5], a
	ret

CE_SSD_NPCWalkCounter:
	ld hl, wSSDCorruptionFlags
	set 6, [hl]
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 6, [hl]
	ret
.doNotResetFlag
	call CheckIfFirstRunthrough
	ret nz
	call CE_SSD_CanAnySpriteMove
	jr c, .spritesCanMove
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	jr .writeSpriteIndex
.spritesCanMove
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	call CE_SSD_CanSpriteMove
	jr nc, .spritesCanMove
.writeSpriteIndex
	ld [wSSDWhichSprite + 8], a
	call Random
	ld [wSSDCorruptionValues + 6], a
	ret
	
CE_SSD_GridYPos:
	call CheckIfFirstRunthrough
	jr nz, .writeValue
; calc new value
	ld a, [wNumSprites]
	and a
	ret z
	
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	ld [wSSDWhichSprite + 9], a
	
	ld a, [wCurMapHeight]
	add a
	add $8
	ld b, a
	inc b
	call DetermineBitmaskForRandomRange
	ld c, a
.randomHeightLoop
	call Random
	and c
	cp b
	jr nc, .randomHeightLoop
	sub $4
	ld [wSSDCorruptionValues + 7], a
.writeValue
	ld a, [wSSDWhichSprite + 9]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData2 + 4
	add hl, bc
	ld a, [wSSDCorruptionValues + 7]
	ld [hl], a
	ret
	
CE_SSD_GridXPos:
	call CheckIfFirstRunthrough
	jr nz, .writeValue
; calc new value
	ld a, [wNumSprites]
	and a
	ret z
	
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	ld [wSSDWhichSprite + 10], a
	
	ld a, [wCurMapWidth]
	add a
	add $8
	ld b, a
	inc b
	call DetermineBitmaskForRandomRange
	ld c, a
.randomHeightLoop
	call Random
	and c
	cp b
	jr nc, .randomHeightLoop
	sub $4
	ld [wSSDCorruptionValues + 8], a
.writeValue
	ld a, [wSSDWhichSprite + 10]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData2 + 4
	add hl, bc
	ld a, [wSSDCorruptionValues + 8]
	ld [hl], a
	ret

CE_SSD_MovementByte:
	call CheckIfFirstRunthrough
	jr nz, .writeValue
	
	ld a, [wNumSprites]
	and a
	ret z
	
	call CE_SSD_DoesNonMovingSpriteExist
	ret nc
	
.randomLoop
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	call CE_SSD_CanSpriteMove
	jr c, .randomLoop
	ld [wSSDWhichSprite + 11], a
.writeValue
	ld a, [wSSDWhichSprite + 11]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData2 + 6
	add hl, bc
	ld [hl], $fe
	ret

CE_SSD_GrassMask:
	ld hl, wSSDCorruptionFlags
	set 7, [hl]
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 7, [hl]
	ret
.doNotResetFlag
	call CheckIfFirstRunthrough
	ret nz
	call CE_SSD_GetRandomSpriteIndex
	ld [wSSDWhichSprite + 12], a
	ret
	
CE_SSD_MovementDelay:
	ld hl, wSSDCorruptionFlags + 1
	set 0, [hl]
	call CheckIfNextFrameWillReplaceChaosEffect
	jr nz, .doNotResetFlag
	res 0, [hl]
	ret
.doNotResetFlag
	call CheckIfFirstRunthrough
	ret nz
	ld a, [wNumSprites]
	and a
	ret z
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	ld [wSSDWhichSprite + 13], a
	ret
	
	
CE_SSD_SpriteImageBaseOffset:
	call CheckIfFirstRunthrough
	jr nz, .writeOffset
	call CE_SSD_GetRandomSpriteIndex_IgnorePlayer
	ld [wSSDWhichSprite + 14], a
	call Random
	and $f
	jr z, .completelyRandomBaseOffset
.randomLoop
	call Random
	and $f
	cp $d
	jr nc, .randomLoop
	ld [wSSDCorruptionValues + 9], a
	jr .writeOffset
.completelyRandomBaseOffset
	ld a, [hRandomSub]
	ld [wSSDCorruptionValues + 9], a
.writeOffset
	ld a, [wSSDWhichSprite + 14]
	swap a
	ld c, a
	ld b, $0
	ld hl, wSpriteStateData2 + $1e
	add hl, bc
	ld a, [wSSDCorruptionValues + 9]
	ld [hl], a
	ret