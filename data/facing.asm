SpriteFacingAndAnimationTable: ; 4000 (1:4000)
    dw SpriteFacingDownAndStanding        ; facing down, walk animation frame 0
    dw SpriteFacingDownAndWalking         ; facing down, walk animation frame 1
    dw SpriteFacingDownAndStanding        ; facing down, walk animation frame 2
    dw SpriteFacingDownAndWalking2        ; facing down, walk animation frame 3
 
    dw SpriteFacingUpAndStanding          ; facing up, walk animation frame 0
    dw SpriteFacingUpAndWalking           ; facing up, walk animation frame 1
    dw SpriteFacingUpAndStanding          ; facing up, walk animation frame 2
    dw SpriteFacingUpAndWalking2          ; facing up, walk animation frame 3
 
    dw SpriteFacingLeftAndStanding        ; facing left, walk animation frame 0
    dw SpriteFacingLeftAndWalking         ; facing left, walk animation frame 1
    dw SpriteFacingLeftAndStanding        ; facing left, walk animation frame 2
    dw SpriteFacingLeftAndWalking         ; facing left, walk animation frame 3
   
    dw SpriteFacingRightAndStanding       ; facing right, walk animation frame 0
    dw SpriteFacingRightAndWalking        ; facing right, walk animation frame 1
    dw SpriteFacingRightAndStanding       ; facing right, walk animation frame 2
    dw SpriteFacingRightAndWalking        ; facing right, walk animation frame 3
   
    dw SpriteFacingDownAndStanding        ; ---
    dw SpriteFacingDownAndStanding        ; This table is used for sprites $a and $b.
    dw SpriteFacingDownAndStanding        ; All orientation and animation parameters
    dw SpriteFacingDownAndStanding        ; lead to the same result. Used for immobile
    dw SpriteFacingDownAndStanding        ; sprites like items on the ground
    dw SpriteFacingDownAndStanding        ; ---
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
    dw SpriteFacingDownAndStanding
 
SpriteFacingDownAndStanding: ; 4042 (1:4042)
; Sprite OAM Parameters
    db $00,$00,$00,$00                                      ; top left
    db $00,$08,$01,$00                                      ; top right
    db $08,$00,$02,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$03,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
 
SpriteFacingDownAndWalking: ; 4053 (1:4053)
; Sprite OAM Parameters
    db $00,$00,$80,$00                                      ; top left
    db $00,$08,$81,$00                                      ; top right
    db $08,$00,$82,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$83,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
 
SpriteFacingDownAndWalking2: ; 4064 (1:4064)
; Sprite OAM Parameters
    db $00,$08,$80,OAMFLAG_VFLIPPED                                           ; top left
    db $00,$00,$81,OAMFLAG_VFLIPPED                                           ; top right
    db $08,$08,$82,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED                     ; bottom left
    db $08,$00,$83,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right
 
SpriteFacingUpAndStanding: ; 4075 (1:4075)
; Sprite OAM Parameters
    db $00,$00,$04,$00                                      ; top left
    db $00,$08,$05,$00                                      ; top right
    db $08,$00,$06,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$07,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
   
SpriteFacingUpAndWalking: ; 4086 (1:4086)
; Sprite OAM Parameters
    db $00,$00,$84,$00                                      ; top left
    db $00,$08,$85,$00                                      ; top right
    db $08,$00,$86,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$87,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
 
SpriteFacingUpAndWalking2: ; 4097 (1:4097)
; Sprite OAM Parameters
    db $00,$08,$84,OAMFLAG_VFLIPPED                                           ; top left
    db $00,$00,$85,OAMFLAG_VFLIPPED                                           ; top right
    db $08,$08,$86,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED                     ; bottom left
    db $08,$00,$87,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right
   
SpriteFacingLeftAndStanding: ; 40a8 (1:40a8)
; Sprite OAM Parameters
    db $00,$00,$08,$00                                      ; top left
    db $00,$08,$09,$00                                      ; top right
    db $08,$00,$0a,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$0b,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
 
SpriteFacingLeftAndWalking: ; 40b9 (1:40b9)
; Sprite OAM Parameters
    db $00,$00,$88,$00                                      ; top left
    db $00,$08,$89,$00                                      ; top right
    db $08,$00,$8a,OAMFLAG_CANBEMASKED                      ; bottom left
    db $08,$08,$8b,OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right
 
SpriteFacingRightAndStanding: ; 40ca (1:40ca)
; Sprite OAM Parameters
    db $00,$08,$08,OAMFLAG_VFLIPPED                                           ; top left
    db $00,$00,$09,OAMFLAG_VFLIPPED                                           ; top right
    db $08,$08,$0a,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED                     ; bottom left
    db $08,$00,$0b,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right
   
SpriteFacingRightAndWalking: ; 40db (1:40db)
; Sprite OAM Parameters
    db $00,$08,$88,OAMFLAG_VFLIPPED                                           ; top left
    db $00,$00,$89,OAMFLAG_VFLIPPED                                           ; top right
    db $08,$08,$8a,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED                     ; bottom left
    db $08,$00,$8b,OAMFLAG_VFLIPPED | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right

