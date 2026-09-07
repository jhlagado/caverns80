; ---------------------------------------------------------
; maybeMonsterAttack
; If a hostile creature is present and the player did not issue
; a combat action, the creature can attack.
;
; Exempts non-action verbs (look/list/score/quit/save/load/stage),
; movement, and kill/attack.
; ---------------------------------------------------------
MAYMONAT:
        LD      A,(VERPATIN)
        OR      A
        RET     Z
        CP      32                     ; north
        RET     Z
        CP      33                     ; south
        RET     Z
        CP      34                     ; west
        RET     Z
        CP      35                     ; east
        RET     Z
        ; Skip attack for non-action verbs.
        CALL    ISNONCOM
        RET     Z
        CALL    MONATTCO
        RET

; ---------------------------------------------------------
; maybeMonsterAttackOnMove
; If the verb is a movement command, resolve attack before moving.
; ---------------------------------------------------------
MAYMONA1:
        LD      A,(VERPATIN)
        LD      B,A                    ; save verb id
        CP      32                     ; north
        JR      Z,MMOATT
        CP      33                     ; south
        JR      Z,MMOATT
        CP      34                     ; west
        JR      Z,MMOATT
        CP      35                     ; east
        JR      Z,MMOATT
        RET

MMOATT:
        CALL    MONATTCO
        RET

; ---------------------------------------------------------
; monsterAttackCore
; Runs the hostile creature attack regardless of verb gating.
; ---------------------------------------------------------
MONATTCO:
        CALL    FINCREIN
        OR      A
        RET     Z
        LD      (HOSCREIN),A
        CP      OBJBAT
        RET     Z                      ; bats handled elsewhere; no attack

        ; Mentioned-tool defense requires actual possession of the sword.
        ; Nouns alone must not let an unarmed player bypass an encounter.
        LD      A,(OBJLOC+OBJSWORD-1)
        CP      ROOCAR
        JR      NZ,MONROLL
        LD      A,(CUROBJIN)
        CP      OBJSWORD
        RET     Z
        LD      A,(TARLOC)
        CP      OBJSWORD
        RET     Z

MONROLL:
        ; 10% chance to miss (player survives), otherwise death.
        LD      B,26                   ; 26/256 ~= 10%
        CALL RNG
        SUB B
        JR      C,MONMIS

        ; Death message.
        LD      HL,STRMONKI
        CALL TERPUT1
        LD      A,(HOSCREIN)
        CALL    PRICREAD
        LD      HL,STRMONSU
        CALL    PRILIN
        CALL    PROPLAAG
        RET

MONMIS:
        LD      HL,STRMONMI
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; ---------------------------------------------------------
; maybeBatCarry
; If the bat is present in the current room, it carries the
; player to roomBatCave and relocates itself (MWB behavior).
;
; Returns:
;   Z set if carry occurred, Z clear otherwise.
; ---------------------------------------------------------
MAYBATCA:
        LD      A,(PLALOC)
        LD      C,A
        LD      A,(OBJLOC+OBJBAT-1)
        CP      C
        JR      Z,MBCCAR
        OR      1                      ; Z=0
        RET

MBCCAR:
        XOR     A
        LD      (SWOSWICO),A
        LD      HL,STRGIABA
        CALL    PRILIN
        LD      A,ROOBATCA
        LD      (PLALOC),A
        LD      A,(OBJLOC+OBJBAT-1)
        ADD     A,BATRELOF
        CALL CLAMPLOC
        LD      (OBJLOC+OBJBAT-1),A
        CALL    PRICURRO
        XOR     A                      ; Z=1
        RET

; Returns Z=1 if verb should NOT trigger monster attack.
ISNONCOM:
        LD      A,(VERPATIN)
        CP      1                      ; look
        RET     Z
        CP      2                      ; list
        RET     Z
        CP      3                      ; invent
        RET     Z
        CP      4                      ; score
        RET     Z
        CP      5                      ; quit
        RET     Z
        CP      6                      ; galar
        RET     Z
        CP      7                      ; ape
        RET     Z
        CP      8                      ; stage2
        RET     Z
        CP      9                      ; stage3
        RET     Z
        CP      10                     ; stage4
        RET     Z
        CP      11                     ; stage5
        RET     Z
        CP      12                     ; save
        RET     Z
        CP      13                     ; load
        RET     Z
        CP      14                     ; read
        RET     Z
        CP      15                     ; pray
        RET     Z
        CP      36                     ; help
        RET     Z
        OR      1                      ; Z=0 => combat applies
        RET

; Returns A = creature index (1..6) if present, else 0.
FINCREIN:
        LD      A,(PLALOC)
        LD      C,A
        LD      HL,OBJLOC
        LD      B,OBJCRECO     ; 1..6
        LD      D,1
FCR_LOOP:
        LD      A,(HL)
        CP      C
        JR      Z,FCRFOU
        INC     HL
        INC     D
        DJNZ    FCR_LOOP
        XOR     A
        RET
FCRFOU:
        LD      A,D
        RET

; A = noun index (1..nounTokenCount) or 0
; Prints "none" if 0 else prints the noun string via fallthrough tables.
PRINOUBY:
        OR      A
        JR      NZ,PNIPRI
        LD      HL,STRNOT
        CALL TERPUT1
        RET
PNIPRI:
        CP      NOUNDOOR
        JR      Z,PNI_DOOR
        CP      NOUNGATE
        JR      Z,PNI_GATE
        CP      FIROBJIN
        JR      NC,PNI_OBJ
        CALL    PRICREAD
        RET
PNI_OBJ:
        CALL    PRIOBJA1
        RET

PNI_DOOR:
        LD      HL,STRDOOWO
        CALL TERPUT1
        RET

PNI_GATE:
        LD      HL,STRGATWO
        CALL TERPUT1
        RET

; ---------------------------------------------------------
; printRandomFightMessage
; Prints one of the four fight miss messages at random.
; ---------------------------------------------------------
PRIRANFI:
        CALL RNG
        AND     3                      ; 0..3
        CP      0
        JR      Z,PRFMOV
        CP      1
        JR      Z,PRFDEF
        CP      2
        JR      Z,PRFSTU
        ; 3
        LD      HL,STRATTHE
        CALL    PRILIN
        RET

PRFMOV:
        LD      HL,STRATTMO
        CALL    PRILIN
        RET
PRFDEF:
        LD      HL,STRATTDE
        CALL    PRILIN
        RET
PRFSTU:
        LD      HL,STRATTST
        CALL    PRILIN
        RET


