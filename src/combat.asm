; ---------------------------------------------------------
; cmdRead / cmdPray
; Contextual inscriptions: crypt, castle and dead-end key clue.
; ---------------------------------------------------------
CMDREAD:
        JR      CMDPRACO

CMDPRAY:
        ; fallthrough
CMDPRACO:
        LD      A,(PLALOC)
        CP      ROOCRY
        JR      Z,CPPINCRY
        CP ROOCASCO
        JR Z,READCAST
        CP ROODEAEN
        JR Z,READDEAD
        LD      HL,STRNOTHA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CPPINCRY:
        LD      HL,VARDCLUE
        CALL    PRILIN
        CALL    PRINEWLI
        RET

READDEAD:
        LD HL,DESDEAEN
        CALL PRILIN
        RET

READCAST:
        LD HL,STRGALCL
        CALL PRILIN
        RET

; ---------------------------------------------------------
; cmdKillAttack
; Sword combat:
; - Requires a target creature in room.
; - Requires a tool noun; only sword works.
; - Uses RNG to decide kill vs. miss.
; ---------------------------------------------------------
CMDKILAT:
        ; Find target creature among noun1/noun2.
        LD      A,(CUROBJIN)
        LD      B,A
        LD      A,(TARLOC)
        LD      C,A
        PUSH    BC                     ; preserve noun1/noun2 across helper
        CALL    SELTARCR
        POP     BC
        OR      A
        JP      Z,CKANOT
        LD      D,A                    ; D = creature index (1..6)
        LD      (HOSCREIN),A

        ; Find tool object among noun1/noun2 (orderless).
        CALL    SELTOOOB
        OR      A
        JP      Z,CKANEEHO
        LD      E,A                    ; E = object index (7..24)

        ; Only sword works for now.
        LD      A,E
        CP      OBJSWORD
        JP      NZ,CKANOTHA

        ; Require sword to be carried.
        LD      A,(OBJLOC+OBJSWORD-1)
        CP      ROOCAR
        JP      NZ,CKANEECA

        ; Count swings; if random threshold <= swing count, the monster kills you.
        LD      A,(SWOSWICO)
        INC     A
        LD      (SWOSWICO),A
        LD      C,A                    ; C = swing count (F)

        CALL RNG
        AND     7                      ; 0..7
        CP      7
        JP      NZ,CKARANOK
        LD      A,6
CKARANOK:
        ADD     A,SWOFIGBA  ; 15..21
        CP      C
        JP      C,CKADEA
        JP      Z,CKADEA
        JP      CKATRYKI

CKADEA:
        LD      HL,STRSWOMI
        CALL    PRILIN
        CALL    PRINEWLI
        CALL    PROPLAAG
        RET

CKATRYKI:
        LD      B,SWOKILCH
        CALL RNG
        SUB B
        JP      C,CKA_KILL

        ; Miss: bat carries you away, otherwise print a random fight message.
        LD      A,D
        CP      OBJBAT
        JP      Z,CKABATCA

        CALL    PRIRANFI
        CALL    PRINEWLI
        RET

CKABATCA:
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
        RET

CKA_KILL:
        LD      HL,STRSWOKI
        CALL    PRILIN
        ; Remove/relocate creature (MWB style).
        LD      A,(HOSCREIN)
        DEC     A
        LD      L,A
        LD      H,0
        LD      DE,OBJLOC
        ADD     HL,DE
        LD      A,(HOSCREIN)
        CP      OBJBAT
        JP      Z,CKAREL
        XOR     A
        LD      (HL),A
        JP      CKAAFTCR

CKAREL:
        LD      A,(HL)
        ADD     A,CORRELOF
        CALL CLAMPLOC
        LD      (HL),A

CKAAFTCR:
        ; Sword crumbles only when killing the wizard (MWB).
        LD      A,(HOSCREIN)
        CP      OBJWIZ
        JP      NZ,CKAAFTSW
        LD      HL,STRSWOCR
        CALL    PRILIN
        LD      A,ROOTEM
        LD      (OBJLOC+OBJSWORD-1),A

CKAAFTSW:
        ; Vapor message for non-dragon.
        LD      A,(HOSCREIN)
        CP      OBJDRA
        JP      Z,CKA_DONE
        LD      HL,STRCORVA
        CALL    PRILIN
CKA_DONE:
        ; A defeated opponent ends this encounter's fatigue budget.
        XOR     A
        LD      (SWOSWICO),A
        CALL    PRINEWLI
        RET

CKANOT:
        LD      HL,STRNOTTO
        CALL    PRILIN
        CALL    PRINEWLI
        RET
CKANEEHO:
        LD      HL,STRPLETE
        CALL    PRILIN
        CALL    PRINEWLI
        XOR     A
        LD      (VERPATIN),A
        RET

CKANEECA:
        LD      HL,STRNOTCA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CKANOTHA:
        LD      HL,STRNOTHA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; Inputs: B=noun1, C=noun2
; Returns: A=creature index 1..6 if present, else 0
SELTARCR:
        LD      A,B
        CP      1
        JR      C,STC_TRY2
        CP      OBJCRECO+1
        JR      NC,STC_TRY2
        ; verify creature is in current room
        PUSH    BC
        LD      B,A
        CALL    CREINROO
        POP     BC
        JR      NZ,STC_TRY2
        LD      A,B
        RET
STC_TRY2:
        LD      A,C
        CP      1
        JR      C,STC_NONE
        CP      OBJCRECO+1
        JR      NC,STC_NONE
        PUSH    BC
        LD      B,A
        CALL    CREINROO
        POP     BC
        JR      NZ,STC_NONE
        LD      A,C
        RET
STC_NONE:
        XOR     A
        RET

; B = creature index (1..6)
; Returns: Z=1 if creature is in playerLocation, NZ otherwise
CREINROO:
        LD      A,(PLALOC)
        LD      C,A
        LD      A,B
        DEC     A
        LD      L,A
        LD      H,0
        LD      DE,OBJLOC
        ADD     HL,DE
        LD      A,(HL)
        CP      C
        RET

; Returns: A = object index 7..24 if present in nouns (and not the target creature), else 0
SELTOOOB:
        ; prefer noun1 then noun2 (object indices are 7..24)
        LD      A,B
        CP      FIROBJIN
        RET     NC
        LD      A,C
        CP      FIROBJIN
        RET     NC
        XOR     A
        RET

