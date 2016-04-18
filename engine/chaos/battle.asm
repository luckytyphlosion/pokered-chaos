ChaosEffectBattleJumptable::
	dw CE_InstantText
	dw CE_InvisibleText
	dw CE_Redbar
	dw CE_wcf4b
	dw CE_NoFrameEffect
	dw CE_JoypadChaos
	dw CE_RandomPalettes
	dw CE_InaccessibleVRAM
	dw CE_RandomCurMoveNumberEnemy
	dw CE_RandomCurMoveEffectEnemy
	dw CE_RandomCurMovePowerEnemy
	dw CE_RandomCurMoveTypeEnemy
	dw CE_RandomCurMoveAccEnemy
	dw CE_RandomCurMoveNumberPlayer
	dw CE_RandomCurMoveEffectPlayer
	dw CE_RandomCurMovePowerPlayer
	dw CE_RandomCurMoveTypePlayer
	dw CE_RandomCurMoveAccPlayer
	dw CE_RandomCurMoveMaxPPPlayer
	dw CE_Superfast
	dw CE_InaccessibleTilemap
	dw CE_EnemyMonSpecies2 ; used in:
	                       ; - give pokemon code
						   ; - common text code (for playing mon's cry and checking for marowak ghost)
						   ; - send out code
						   ; - LoadEnemyMonData input
						   ; - mon to catch
	dw CE_BattleMonSpecies2 ; used in:
	                        ; - change mon pic input
							; - LoadMonBackPic input
							; - LoadBattleMonFromParty for GetMonHeader
							
	dw CE_EnemyBattleStruct_Species ; used in:
	                                ; - safari zone code to determine catch rate
									; - transform code
									; - AnimationFlashMonPic code
									; - GetMoveSound code to get the mon's cry
									; - Transform anim code
									; - reloading the mon's front sprite if looked at status screen
									; - GetEnemyMonStat to get base stats
									; - critical hit test
	dw CE_EnemyBattleStruct_HP      ; used to store current HP
	                                ; don't let this go over 999
	dw CE_EnemyBattleStruct_PartyPos ; used in:
	                                 ; - enemy mon fainting code (to prevent sending out that mon)
									 ; - switch out code
	dw CE_EnemyBattleStruct_Status ; used to store the mon's status
	dw CE_EnemyBattleStruct_Type1  ; types
	dw CE_EnemyBattleStruct_Type2  ; make sure that it is a valid type
	dw CE_EnemyBattleStruct_Moves  ; moves (make sure it is valid)
	dw CE_EnemyBattleStruct_DVs    ; only relevant for wild pokemon
	dw CE_EnemyBattleStruct_Level  ; current mon level
	                               ; don't overbuff
	dw CE_EnemyBattleStruct_MaxHP  ; don't make this = 0 or > 999
	dw CE_EnemyBattleStruct_Attack ; stats
	dw CE_EnemyBattleStruct_Defense
	dw CE_EnemyBattleStruct_Speed
	dw CE_EnemyBattleStruct_Special
	dw CE_EnemyBattleStruct_BaseStats ; used in stat exp calculation
	dw CE_EnemyBattleStruct_CatchRate ; catch rate stuff
	dw CE_EnemyBattleStruct_BaseExp ; exp calc
	dw CE_PlayerBattleStruct_Species ; used in:
	                                 ; - transform code
									 ; - more change mon pic
									 ; - critical hit test
	dw CE_PlayerBattleStruct_HP
	dw CE_PlayerBattleStruct_PartyPos
	dw CE_PlayerBattleStruct_Status
	dw CE_PlayerBattleStruct_Type1
	dw CE_PlayerBattleStruct_Type2
	dw CE_PlayerBattleStruct_Moves
	dw CE_PlayerBattleStruct_DVs
	dw CE_PlayerBattleStruct_Level
	dw CE_PlayerBattleStruct_MaxHP
	dw CE_PlayerBattleStruct_Attack
	dw CE_PlayerBattleStruct_Defense
	dw CE_PlayerBattleStruct_Speed
	dw CE_PlayerBattleStruct_Special
	dw CE_PlayerBattleStruct_PP
ChaosEffectBattleJumptableEnd::

CE_RandomCurMoveNumberEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy
	jr CE_RandomCurMoveNumber
	
CE_RandomCurMoveNumberPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer

CE_RandomCurMoveNumber:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
.randomLoop
	call Random
	cp NUM_ATTACKS + 1
	jr nc, .randomLoop
	inc a
	ld [de], a
	set 0, [hl]
	ret
.reset
	res 0, [hl]
	ret
	
CE_RandomCurMoveEffectEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 1
	jr CE_RandomCurMoveEffect
	
CE_RandomCurMoveEffectPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 1
	
CE_RandomCurMoveEffect:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 1, [hl]
	ret
.reset
	res 1, [hl]
	ret

CE_RandomCurMovePowerEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 2
	jr CE_RandomCurMovePower
	
CE_RandomCurMovePowerPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 2

CE_RandomCurMovePower:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 2, [hl]
	ret
.reset
	res 2, [hl]
	ret
	
CE_GetRandomPokemonType:
	call Random
	and $f
	cp $9
	ret c
	add $b
	ret
	
CE_RandomCurMoveTypeEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 3
	jr CE_RandomCurMoveType
	
CE_RandomCurMoveTypePlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 3

CE_RandomCurMoveType:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call CE_GetRandomPokemonType
	ld [de], a
	set 3, [hl]
	ret
.reset
	res 3, [hl]
	ret
	
CE_RandomCurMoveAccEnemy:
	ld hl, wGetCurrentMoveCorruptionFlagsEnemy
	ld de, wCurMoveCorruptionValuesEnemy + 4
	jr CE_RandomCurMoveAcc
	
CE_RandomCurMoveAccPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	ld de, wCurMoveCorruptionValuesPlayer + 4
	
CE_RandomCurMoveAcc:
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [de], a
	set 4, [hl]
	ret
.reset
	res 4, [hl]
	ret
	
CE_RandomCurMoveMaxPPPlayer:
	ld hl, wGetCurrentMoveCorruptionFlagsPlayer
	call CheckIfNextFrameWillReplaceChaosEffect
	jr z, .reset
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [wCurMoveCorruptionValuesPlayer+5], a
	set 5, [hl]
	ret
.reset
	res 5, [hl]
	ret

CE_GetRandomPokemon:
	push hl
	push de
	call Random
	cp NUM_POKEMON
	jr nc, CE_GetRandomPokemon
	inc a
	ld b, a
	ld a, [wd11e]
	push af
	ld a, b
	ld [wd11e], a
	callab IndexToPokedex
	ld a, [wd11e]
	ld b, a
	pop af
	ld [wd11e], a
	ld a, b
	pop de
	pop hl
	ret
	
CE_EnemyMonSpecies2:
	ld hl, wEnemyMonSpecies2
	ld de, wEnemyMonSpecies2Chaos
	jr CE_MonSpecies2
	
CE_BattleMonSpecies2:
	ld hl, wBattleMonSpecies2
	ld de, wBattleMonSpecies2Chaos

CE_MonSpecies2:
	call CheckIfFirstRunthrough
	jr nz, .applyEffects
	call CE_GetRandomPokemon
	ld [de], a
.applyEffects
	ld a, [de]
	ld [hl], a
	ret

CE_EnemyBattleStruct_Species:
	ld hl, wEnemyMonSpecies
	ld de, wEBSChaosSpecies
	jr CE_BattleStruct_Species
	
CE_PlayerBattleStruct_Species:
	ld hl, wBattleMonSpecies
	ld de, wPBSChaosSpecies
	
CE_BattleStruct_Species:
	call CheckIfFirstRunthrough
	jr nz, .applyEffects
	call CE_GetRandomPokemon
	ld [de], a
.randomLoop
	ld a, [de]
	ld [hl], a
	ret
	
CE_EnemyBattleStruct_HP:
	ld hl, wEnemyMonHP
	jr CE_BattleStruct_HP
	
CE_PlayerBattleStruct_HP:
	ld hl, wBattleMonHP
	
CE_BattleStruct_HP:
	call CheckIfFirstRunthrough
	ret nz
; 3/4 chance of calculating rand[-curHP, curHP]
; 1/4 chance of calculating rand[-curHP, min(3*curHP,999)]
	call Random
	and %11
	push hl
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld b, h
	ld c, l
	jr nz, .normalEffect
	add hl, hl
.normalEffect
; hl = cur hp
	add hl, hl
; hl = 2*curHP
; bc = curHP
	ld a, h
	cp 999 / $100
	jr c, .doNotCap
	ld a, l
	cp 999 & $ff
	jr c, .doNotCap
; cap HP
	ld hl, 999
.doNotCap
	push bc
	ld d, h
	ld e, l
	call GetRandomRangeFor16BitValue
; de = rand[0, curHP*2]
	pop bc
	ld a, e
	sub c
	ld c, a
	ld a, d
	sbc b
; bc = rand[-curHP, curHP]
	pop hl
	ld [hli], a
	ld [hl], c
	ret

CE_EnemyBattleStruct_PartyPos:
	ld hl, wEnemyMonPartyPos
	ld de, wEnemyPartyCount
	jr CE_BattleStruct_PartyPos
	
CE_PlayerBattleStruct_PartyPos:
	ld hl, wPlayerMonNumber
	ld de, wPartyCount
	
BattleStruct_PartyPos:
	call CheckIfFirstRunthrough
	ret nz
	ld a, [de]
	ld c, a
	inc c
.randomLoop
	call Random
	and $7
	cp c
	jr nc, .randomLoop
	ld [hl], a
	ret

CE_GetRandomStatus:
	call Random
	and $7
	cp 5 ; five statuses
	jr nc, CE_GetRandomStatus
	and a ; sleep
	jr z, .handleSleep
	ld b, %1000
	jr .handleLoop
.loop
	sla b
.handleLoop
	dec a
	jr nz, .loop
	ld a, b
	ret
.handleSleep
	ld a, [hRandomSub]
	and SLP
	ret

CE_EnemyBattleStruct_Status:
	ld hl, wEnemyMonStatus
	jr CE_BattleStruct_Status
	
CE_PlayerBattleStruct_Status:
	ld hl, wBattleMonStatus
	
CE_BattleStruct_Status:
	call CheckIfFirstRunthrough
	ret z
.loop
	call CE_GetRandomStatus
	or [hl]
.randomLoop
	call Random
	and $1
	jr nz, .loop
	ret
	
CE_EnemyBattleStruct_Type1:
	ld hl, wEnemyMonType1
	jr CE_BattleStruct_Types
	
CE_EnemyBattleStruct_Type2:
	ld hl, wEnemyMonType2
	jr CE_BattleStruct_Types
	
CE_PlayerBattleStruct_Type1:
	ld hl, wBattleMonType1	
	jr CE_BattleStruct_Types

CE_PlayerBattleStruct_Type2:
	ld hl, wBattleMonType2
	
CE_BattleStruct_Types:
	call CheckIfFirstRunthrough
	ret nz
	
	call CE_GetRandomPokemonType
	ld [hl], a
	ret
	
CE_EnemyBattleStruct_Moves:
	ld hl, wEnemyMonMoves
	jr CE_BattleStruct_Moves
	
CE_PlayerBattleStruct_Moves:
	ld hl, wBattleMonMoves
	
CE_BattleStruct_Moves:
	call CheckIfFirstRunthrough
	ret nz
.randomLoop
	call Random
	cp NUM_ATTACKS + 1
	jr nc, .randomLoop
	inc a
	ld b, a
	ld a, [hRandomSub]
	and $3
	ld e, a
	ld d, $0
	add hl, de
	ld [hl], b
	ret
	
CE_EnemyBattleStruct_Level:
	ld hl, wEnemyMonLevel
	jr CE_BattleStruct_Level
	
CE_PlayerBattleStruct_Level
	ld hl, wBattleMonLevel
	
CE_BattleStruct_Level:
	call CheckIfFirstRunthrough
	ret nz
	ld a, [hl]
	ld b, a
	inc b
	call DetermineBitmaskForRandomRange
	ld c, a
.randomLoop
	call Random
	and c
	cp b
	jr nc, .randomLoop
	ld b, a
	ld d, $0
.modifyLevelLoop
; b = count
; c = temp for random value
; d = sum of bits
; e = temp for loop count
	ld a, b
	cp $9 ; number of bitshifts left
	jr c, .lastRun
	call Random
	ld c, a
	ld e, $8
	ld a, d
.addBitsLoop
	srl c
	adc $0
	dec e
	jr nz, .addBitsLoop
	ld d, a
	ld a, b
	sub $8
	jr .modifyLevelLoop
.lastRun
	call Random
	ld c, a
	ld a, d
.addBitsLoop2
	srl c
	adc $0
	dec b
	jr nz, .addBitsLoop2
	ld d, [hl] ; get level
	sub d ; subtract sumOfBits - level
	ld [hl], a
	ret

;	dw CE_EnemyBattleStruct_Level  ; current mon level
;	                               ; don't overbuff
;	dw CE_EnemyBattleStruct_MaxHP  ; don't make this = 0 or > 999
;	dw CE_EnemyBattleStruct_Attack ; stats
;	dw CE_EnemyBattleStruct_Defense
;	dw CE_EnemyBattleStruct_Speed
;	dw CE_EnemyBattleStruct_Special
;	dw CE_EnemyBattleStruct_BaseStats ; used in stat exp calculation
;	dw CE_EnemyBattleStruct_CatchRate ; catch rate stuff
;	dw CE_EnemyBattleStruct_BaseExp ; exp calc
;	dw CE_PlayerBattleStruct_Species ; used in:
;	                                 ; - transform code
;									 ; - more change mon pic
;									 ; - critical hit test
;	dw CE_PlayerBattleStruct_HP
;	dw CE_PlayerBattleStruct_PartyPos
;	dw CE_PlayerBattleStruct_Status
;	dw CE_PlayerBattleStruct_Type1
;	dw CE_PlayerBattleStruct_Type2
;	dw CE_PlayerBattleStruct_Moves
;	dw CE_PlayerBattleStruct_Level
;	dw CE_PlayerBattleStruct_MaxHP
;	dw CE_PlayerBattleStruct_Attack
;	dw CE_PlayerBattleStruct_Defense
;	dw CE_PlayerBattleStruct_Speed
;	dw CE_PlayerBattleStruct_Special
;	dw CE_PlayerBattleStruct_PP