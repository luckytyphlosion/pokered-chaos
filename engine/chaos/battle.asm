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
	dw CE_BattleMonSpecies2 ; used in:
	dw CE_EnemyBattleStruct_Species ; used in:
	dw CE_EnemyBattleStruct_HP      ; used to store current HP
	dw CE_EnemyBattleStruct_PartyPos ; used in:
	dw CE_EnemyBattleStruct_Status ; used to store the mon's status
	dw CE_EnemyBattleStruct_Type1  ; types
	dw CE_EnemyBattleStruct_Type2  ; make sure that it is a valid type
	dw CE_EnemyBattleStruct_Move1
	dw CE_EnemyBattleStruct_Move2
	dw CE_EnemyBattleStruct_Move3
	dw CE_EnemyBattleStruct_Move4 ; moves (make sure it is valid)
	dw CE_EnemyBattleStruct_Level  ; current mon level
	dw CE_EnemyBattleStruct_MaxHP  ; don't make this = 0 or > 999
	dw CE_EnemyBattleStruct_Attack ; stats
	dw CE_EnemyBattleStruct_Defense
	dw CE_EnemyBattleStruct_Speed
	dw CE_EnemyBattleStruct_Special
	dw CE_EnemyBattleStruct_BaseStats ; used in stat exp calculation
	dw CE_EnemyBattleStruct_BaseExp ; exp calc
	dw CE_PlayerBattleStruct_Species ; used in:
	dw CE_PlayerBattleStruct_HP
	dw CE_PlayerBattleStruct_PartyPos
	dw CE_PlayerBattleStruct_Status
	dw CE_PlayerBattleStruct_Type1
	dw CE_PlayerBattleStruct_Type2
	dw CE_PlayerBattleStruct_Move1
	dw CE_PlayerBattleStruct_Move2
	dw CE_PlayerBattleStruct_Move3
	dw CE_PlayerBattleStruct_Move4
	dw CE_PlayerBattleStruct_Level
	dw CE_PlayerBattleStruct_MaxHP
	dw CE_PlayerBattleStruct_Attack
	dw CE_PlayerBattleStruct_Defense
	dw CE_PlayerBattleStruct_Speed
	dw CE_PlayerBattleStruct_Special
	dw CE_PlayerBattleStruct_PP
	dw CE_InaccessibleOAM
	dw CE_ForceAnimationsOn

;	dw CE_EnemyMonSpecies2 ; used in:
;	                       ; - give pokemon code
;						   ; - common text code (for playing mon's cry and checking for marowak ghost)
;						   ; - send out code
;						   ; - LoadEnemyMonData input
;						   ; - mon to catch
;	dw CE_BattleMonSpecies2 ; used in:
;	                        ; - change mon pic input
;							; - LoadMonBackPic input
;							; - LoadBattleMonFromParty for GetMonHeader
;							
;	dw CE_EnemyBattleStruct_Species ; used in:
;	                                ; - safari zone code to determine catch rate
;									; - transform code
;									; - AnimationFlashMonPic code
;									; - GetMoveSound code to get the mon's cry
;									; - Transform anim code
;									; - reloading the mon's front sprite if looked at status screen
;									; - GetEnemyMonStat to get base stats
;									; - critical hit test
;	dw CE_EnemyBattleStruct_HP      ; used to store current HP
;	                                ; don't let this go over 999
;	dw CE_EnemyBattleStruct_PartyPos ; used in:
;	                                 ; - enemy mon fainting code (to prevent sending out that mon)
;									 ; - switch out code
;	dw CE_EnemyBattleStruct_Status ; used to store the mon's status
;	dw CE_EnemyBattleStruct_Type1  ; types
;	dw CE_EnemyBattleStruct_Type2  ; make sure that it is a valid type
;	dw CE_EnemyBattleStruct_Moves  ; moves (make sure it is valid)
;	dw CE_EnemyBattleStruct_Level  ; current mon level
;	                               ; don't overbuff
;	dw CE_EnemyBattleStruct_MaxHP  ; don't make this = 0 or > 999
;	dw CE_EnemyBattleStruct_Attack ; stats
;	dw CE_EnemyBattleStruct_Defense
;	dw CE_EnemyBattleStruct_Speed
;	dw CE_EnemyBattleStruct_Special
;	dw CE_EnemyBattleStruct_BaseStats ; used in stat exp calculation
;	dw CE_EnemyBattleStruct_BaseExp ; exp calc
;	dw CE_PlayerBattleStruct_Species ; used in:
;	                                 ; - transform code
;									 ; - more change mon pic
;									 ; - critical hit test
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
.randomLoop
	call Random
	cp NUM_POKEMON
	jr nc, .randomLoop
	inc a
	ld b, a
	ld a, [wd11e]
	push af
	ld a, b
	ld [wd11e], a
	callab PokedexToIndex
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
.applyEffects
	ld a, [de]
	ld [hl], a
	ret
	
CheckForStatOverflowOrZero:
; if stat is 0, return 1
; if stat is >999, return 999
; else, return the stat
	ld a, h
	or l
	jr nz, .notZero
	inc l
	ret
.notZero
	ld a, h
	cp 999 / $100
	ret c
	ld a, l
	cp 999 & $ff
	ret c
; cap HP
	ld hl, 999
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
	call CheckForStatOverflowOrZero
	push bc
	ld d, h
	ld e, l
	call GetRandomRangeFor16BitValue
; de = rand[0, curHP*2]
	pop bc
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc b
	ld d, a
	push hl
	ld h, b
	ld l, c
	add hl, de
	ld b, h
	ld c, l
	pop hl
.writeNewHP
; bc = rand[-curHP, curHP]
	pop hl
	ld a, b
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
	
CE_BattleStruct_PartyPos:
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
	ret nz
.loop
	call CE_GetRandomStatus
	or [hl]
	ld [hl], a
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
	
CE_EnemyBattleStruct_Move1:
	ld hl, wEnemyMonMoves
	jr CE_BattleStruct_Moves
	
CE_EnemyBattleStruct_Move2:
	ld hl, wEnemyMonMoves + 1
	jr CE_BattleStruct_Moves
	
CE_EnemyBattleStruct_Move3:
	ld hl, wEnemyMonMoves + 2
	jr CE_BattleStruct_Moves
	
CE_EnemyBattleStruct_Move4:
	ld hl, wEnemyMonMoves + 3
	jr CE_BattleStruct_Moves
	
CE_PlayerBattleStruct_Move1:
	ld hl, wBattleMonMoves
	jr CE_BattleStruct_Moves
	
CE_PlayerBattleStruct_Move2:
	ld hl, wBattleMonMoves + 1
	jr CE_BattleStruct_Moves
	
CE_PlayerBattleStruct_Move3:
	ld hl, wBattleMonMoves + 2
	jr CE_BattleStruct_Moves
	
CE_PlayerBattleStruct_Move4:
	ld hl, wBattleMonMoves + 3
	
CE_BattleStruct_Moves:
	call CheckIfFirstRunthrough
	ret nz
.randomLoop
	call Random
	cp NUM_ATTACKS + 1
	jr nc, .randomLoop
	inc a
	ld [hl], a
	ret
	
GetRandomRangeOfRandomRange_16Bit:
; calculate rand(0,rand(0,de)) + 1
; and return in de
	call GetRandomRangeFor16BitValue
	call GetRandomRangeFor16BitValue
	inc de
	ret

GetRandomRangeOfRandomRange_8Bit:
; calculate rand(0,rand(0,b))
; and return in b
	ld a, b
	call DetermineBitmaskForRandomRange
	ld c, a
	call .randomLoop
	dec b
.randomLoop
	call Random
	and c
	cp b
	jr z, .gotNumber
	jr nc, .randomLoop
.gotNumber
	ld b, a
	inc b
	ret
	
CE_EnemyBattleStruct_Level:
	ld hl, wEnemyMonLevel
	jr CE_BattleStruct_Level
	
CE_PlayerBattleStruct_Level
	ld hl, wBattleMonLevel
	
CE_BattleStruct_Level:
; chance of modifier n = l - n / l
	call CheckIfFirstRunthrough
	ret nz
	ld b, [hl]
	call GetRandomRangeOfRandomRange_8Bit
	ld a, [hRandomSub]
	and $1
	jr z, .addOffset
	ld a, [hl]
	sub b
	ld [hl], a
	ret
.addOffset
	ld a, [hl]
	add b
	ld [hl], a
	ret
	
CE_EnemyBattleStruct_MaxHP:
	ld de, wEnemyMonMaxHP
	ld hl, wEnemyMonUnmodifiedMaxHP
	jr CE_BattleStruct_Stat
	
CE_PlayerBattleStruct_MaxHP:
	ld de, wBattleMonMaxHP
	ld hl, wPlayerMonUnmodifiedMaxHP
	jr CE_BattleStruct_Stat
	
CE_EnemyBattleStruct_Attack:
	ld de, wEnemyMonAttack
	ld hl, wEnemyMonUnmodifiedAttack
	jr CE_BattleStruct_Stat
	
CE_EnemyBattleStruct_Defense:
	ld de, wEnemyMonDefense
	ld hl, wEnemyMonUnmodifiedDefense
	jr CE_BattleStruct_Stat
	
CE_EnemyBattleStruct_Speed:
	ld de, wEnemyMonSpeed
	ld hl, wEnemyMonUnmodifiedSpeed
	jr CE_BattleStruct_Stat
	
CE_EnemyBattleStruct_Special:
	ld de, wEnemyMonSpecial
	ld hl, wEnemyMonUnmodifiedSpecial
	jr CE_BattleStruct_Stat
	
CE_PlayerBattleStruct_Attack:
	ld de, wBattleMonAttack
	ld hl, wPlayerMonUnmodifiedAttack
	jr CE_BattleStruct_Stat
	
CE_PlayerBattleStruct_Defense:
	ld de, wBattleMonDefense
	ld hl, wPlayerMonUnmodifiedDefense
	jr CE_BattleStruct_Stat
	
CE_PlayerBattleStruct_Speed:
	ld de, wBattleMonSpeed
	ld hl, wPlayerMonUnmodifiedSpeed
	jr CE_BattleStruct_Stat
	
CE_PlayerBattleStruct_Special:
	ld de, wBattleMonSpecial
	ld hl, wPlayerMonUnmodifiedSpecial
	jr CE_BattleStruct_Stat

; add more stuff here
CE_BattleStruct_Stat:
	call CheckIfFirstRunthrough
	ret nz
	push de
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call GetRandomRangeOfRandomRange_16Bit
	call Random
	and $1
	push hl
	ld a, [hld]
	ld h, [hl]
	ld l, a
	jr z, .subtractOffset
	add hl, de
	call CheckForStatOverflowOrZero
	jr .copyToUnmodifiedStat
.subtractOffset
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	jr c, .setToOne
	or l
	jr nz, .copyToUnmodifiedStat
.setToOne
	ld hl, $1
.copyToUnmodifiedStat
	pop de
	ld a, l
	ld [de], a
	dec de
	ld a, h
	ld [de], a
	pop de
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	ret
	
CE_EnemyBattleStruct_BaseStats:
	call CheckIfFirstRunthrough
	ret nz
.randomLoop
	call Random
	and $7
	cp 5
	jr nc, .randomLoop
	ld e, a
	ld d, $0
	ld hl, wEnemyMonBaseStats
	add hl, de
	ld a, [hRandomSub]
	ld [hl], a
	ret

CE_EnemyBattleStruct_BaseExp:
	call CheckIfFirstRunthrough
	ret nz
	call Random
	ld [wEnemyMonBaseExp], a
	ret

CE_PlayerBattleStruct_PP:
	call CheckIfFirstRunthrough
	ret nz
	call Random
	and $3
	ld e, a
	ld d, $0
	ld hl, wBattleMonPP
	add hl, de
	ld a, [hRandomSub]
	ld [hl], a
	ret
	
CE_ForceAnimationsOn:
	ld hl, wOptions
	res 7, [hl]
	ret