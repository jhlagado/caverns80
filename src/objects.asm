; ---------------------------------------------------------
; cmdGet / cmdDrop
; Uses scanned nouns: chooses the first object noun (7..24).
; ---------------------------------------------------------
CMDGET:
        CALL    SELSCAOB
        OR      A
        JP      Z,CMDGETUN
        LD      B,A                    ; object index (7..24)
        CALL    DOGETOBJ
        RET

CMDDROP:
        CALL    SELSCAOB
        OR      A
        JP      Z,CMDDROUN
        LD      B,A
        CALL    DODROOBJ
        RET

SELSCAOB:
        LD A,(CUROBJIN)
        CP 7
        JR C,SELSEC
        CP 25
        RET C
SELSEC:
        LD A,(TARLOC)
        CP 7
        JR C,SELNONE
        CP 25
        RET C
SELNONE:
        XOR A
        RET

; ---------------------------------------------------------
; countCarriedItems
; Returns: A = number of carried objects (7..24).
; ---------------------------------------------------------
COUCARIT:
        LD      HL,OBJLOC+OBJCRECO  ; skip creatures 1..6
        LD      B,OBJITECO                   ; objects 7..24
        LD      C,0                                 ; count
CIC_LOOP:
        LD      A,(HL)
        CP      ROOCAR
        JR      NZ,CIC_NEXT
        INC     C
CIC_NEXT:
        INC     HL
        DJNZ    CIC_LOOP
        LD      A,C
        RET

; B = object index (7..24)
DOGETOBJ:
        ; Enforce a max carry limit (10 objects).
        PUSH    BC
        CALL    COUCARIT
        CP      MAXCARIT
        POP     BC
        JP      NC,CMDGETTO

        LD      A,(PLALOC)
        LD      C,A                    ; room
        LD      A,B
        DEC     A
        LD      L,A
        LD      H,0
        LD      DE,OBJLOC
        ADD     HL,DE
        LD      A,(HL)
        CP      C
        JP      NZ,CMDGETCA
        LD      A,ROOCAR
        LD      (HL),A
        ; Taking the loose grille opens the cell's eastern ventilator permanently.
        LD      A,B
        CP      OBJGRILL
        JR      NZ,GETNOGR
        LD      A,ROODARC9
        LD      (GATDES),A
GETNOGR:
        PUSH    BC
        LD      A,B
        CALL    PRIOBJA1
        LD      HL,STRTAKSU
        CALL TERPUT1
        CALL    PRINEWLI
        POP     BC
        CALL    PRICURRO
        RET

CMDGETTO:
        LD      HL,STRTOOMA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; B = object index (7..24)
DODROOBJ:
        LD      A,B
        DEC     A
        LD      L,A
        LD      H,0
        LD      DE,OBJLOC
        ADD     HL,DE
        LD      A,(HL)
        CP      ROOCAR
        JP      NZ,CMDDROCA
        LD      A,(PLALOC)
        LD      (HL),A
        CALL COMSCO
        LD A,(SCORE)
        CP 126
        JR NZ,DROPEND
        LD HL,WINMSG
        CALL PRILIN
DROPEND:
        CALL    PRICURRO
        RET

