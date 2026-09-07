; ---------------------------------------------------------
; printCurrentRoomDescription
; Prints the primary description for playerLocation via roomDesc1Table.
; ---------------------------------------------------------
PRICURRO:
        ; Discover the drainage return at the waterfall. Once found, it stays open.
        LD      A,(PLALOC)
        CP      ROOWATBA
        JR      NZ,WATSEEN
        LD      A,ROODRAC
        LD      (WATEXILO),A
WATSEEN:
        LD      A,(PLALOC)     ; 1-based room id
        LD      D,A                    ; D = current room (preserve across calls)
        CALL    ISROOTOO          ; Z=1 if too dark to see
        JR      Z,PCTOODAR

        LD      A,D
        LD      HL,ROODES1T
        CALL    PRIDES

        LD      A,(PLALOC)
        LD      D,A                    ; restore room after printDescription

        LD      A,D
        LD      HL,ROODES2T
        CALL    PRIDES

        ; Dragon corpse only when dragon is dead in cave entrance clearing.
        LD      A,D
        CP      ROOCAVEN
        JR      NZ,PCAFTDRA
        LD      A,(OBJLOC+OBJDRA-1)
        OR      A
        JR      NZ,PCAFTDRA
        LD      HL,STRDRACO
        CALL    PRILIN
PCAFTDRA:

        ; Drawbridge message when activated.
        LD      A,D
        CP      ROOCASLE
        JR      NZ,PCAFTDR1
        LD      A,(DRASTA)
        CP      ROODRA
        JR      NZ,PCAFTDR1
        LD      HL,STRGOLBR
        CALL    PRILIN
PCAFTDR1:

        ; Extra flavor line in select rooms.
        LD      A,D
        LD      HL,DARCAVRO
        CALL    CONBYTLI
        JR      NZ,PC_LISTS
        LD      HL,STRDARCA
        CALL    PRILIN

PC_LISTS:
        LD      A,D
        CALL    UPDDRAST
        ; Candle is advanced by the action loop, never rendering.
        CALL    LISROOOB
        CALL    LISROOCR
        CALL    PRINEWLI           ; blank line after the whole response
        RET

PCTOODAR:
        LD      HL,STRTOOD1
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; ---------------------------------------------------------
; updateCandleByTurns
; candle timing using turnCounter.
;
; Behavior:
; - At turn 201 (U > 200): prints "Your candle is growing dim."
; - At turn 230 (U >= 230): sets candleIsLitFlag = 0 and prints "In fact...it went out!"
;
; Notes:
; - Only runs when the room is visible (not "too dark").
; - Prints messages only on the threshold turns (avoids repeated spam).
;
; Clobbers:
;   AF
; ---------------------------------------------------------
UPDCANBY:
        LD      A,(CANISLIT)
        OR      A
        RET     Z

        LD      A,(TURCOU+1)
        OR      A
        RET     NZ
        LD      A,(TURCOU)
        CP      CANDIMTU+1
        JR      Z,UC_DIM
        CP      CANOUTTU
        RET     NZ

        XOR     A
        LD      (CANISLIT),A
        LD      HL,STRCANOU
        CALL    PRILIN
        RET

UC_DIM:
        LD      HL,STRCANDI
        CALL    PRILIN
        RET

; ---------------------------------------------------------
; updateDrawbridgeState
; A = room id
; Sets drawbridgeState once the player reaches roomDrawbridge.
;
; Clobbers:
;   AF
; ---------------------------------------------------------
UPDDRAST:
        CP      ROODRA
        RET     NZ
        LD      A,ROODRA
        LD      (DRASTA),A
        RET

; ---------------------------------------------------------
; isRoomTooDark
; A = room id (1..roomMax)
;
; Returns:
;   Z set if room is too dark to see anything.
;   Z clear otherwise.
;
; Rules:
;   Rooms < roomDarkCavernA are always visible.
;   Rooms >= roomDarkCavernA require a lit candle that is carried or present.
;
; Clobbers:
;   AF, BC, HL
; ---------------------------------------------------------
ISROOTOO:
        LD      B,A                    ; B = room
        CP      ROODARCA
        JR      NC,IRDCHECA
        OR      1                      ; visible => Z=0
        RET

IRDCHECA:
        LD      A,(CANISLIT)
        OR      A
        RET     Z                      ; unlit => too dark (Z=1)

        ; Candle must be carried or in this room.
        LD      HL,OBJLOC+OBJCAN-1
        LD      A,(HL)
        CP      ROOCAR
        JR      Z,IRDVIS
        CP      B
        JR      Z,IRDVIS
        XOR     A                      ; too dark => Z=1
        RET

IRDVIS:
        OR      1                      ; visible => Z=0
        RET

; ---------------------------------------------------------
; containsByteListZeroTerm
; HL = byte list terminated by 0
; A  = value to search for (0 is not a valid search value)
;
; Returns:
;   Z set if found, Z clear if not found.
;
; Clobbers:
;   AF, HL
; ---------------------------------------------------------
CONBYTLI:
        LD      B,A                    ; B = search value
CB_LOOP:
        LD      A,(HL)
        OR      A
        JR      Z,CBNOT
        CP      B
        RET     Z
        INC     HL
        JR      CB_LOOP

CBNOT:
        OR      1                      ; ensure Z=0
        RET

; ---------------------------------------------------------
; listRoomCreatures
; Prints a list of visible creatures in the current room.
; Creatures are indices 1..6 in objectLocation[].
; ---------------------------------------------------------
LISROOCR:
        LD      A,(PLALOC)
        LD      C,A                    ; C = current room
        LD      HL,OBJLOC
        LD      B,OBJCRECO     ; creatures 1..6
        LD      D,0                    ; printed-any flag
        LD      E,1                    ; creature index (1..6)
LC_LOOP:
        LD      A,(HL)
        CP      C
        JR      NZ,LC_NEXT

        LD      A,D
        OR      A
        JR      NZ,LC_PRINT
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRINEWLI
        POP     HL
        POP     DE
        POP     BC
        PUSH    HL
        LD      HL,STRSEECR
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRILIN
        POP     HL
        POP     DE
        POP     BC
        POP     HL
        LD      D,1
LC_PRINT:
        PUSH    DE
        PUSH    HL
        LD      A,E
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRICREAD
        POP     HL
        POP     DE
        POP     BC
        POP     HL
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRINEWLI
        POP     HL
        POP     DE
        POP     BC
        POP     DE
        LD      A,E
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    MAYPRIEN
        POP     HL
        POP     DE
        POP     BC
LC_NEXT:
        INC     HL
        INC     E
        DJNZ    LC_LOOP
        RET

; ---------------------------------------------------------
; printCreatureAdjNoun
; A = creature index (1..6)
; Prints adjective+article then noun via monster tables.
; ---------------------------------------------------------
PRICREAD:
        DEC     A
        LD      B,A
        LD      HL,MONNAMTA
        LD      A,B
        CALL    PRIWORTA
        RET

; ---------------------------------------------------------
; maybePrintEncounter
; A = creature index (1..6)
; Prints special encounter text for wizard/dragon/goblin.
; ---------------------------------------------------------
MAYPRIEN:
        CP      OBJWIZ
        JR      Z,MPEWIZ
        CP      OBJDRA
        JR      Z,MPEDRA
        CP      OBJGOB
        JR      Z,MPEGOB
        RET

MPEWIZ:
        CALL    PRINEWLI
        LD      HL,STRENCWI
        CALL    PRILIN
        RET

MPEDRA:
        CALL    PRINEWLI
        LD      HL,STRENCDR
        CALL    PRILIN
        RET

MPEGOB:
        CALL    PRINEWLI
        LD      HL,STRENCGO
        CALL    PRILIN
        RET

; ---------------------------------------------------------
; printDescription
; HL = base of DW table, A = 1-based index
; Loads word pointer and prints if non-zero.
; ---------------------------------------------------------
PRIDES:
        OR      A
        RET     Z
        PUSH    DE
        DEC     A
        ADD     A,A                    ; (index-1) * 2
        LD      E,A
        LD      D,0
        ADD     HL,DE
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      A,D
        OR      E
        JR      Z,PDRES
        EX      DE,HL
        CALL    PRILIN
PDRES:
        POP     DE
        RET

; ---------------------------------------------------------
; printLine
; HL = 0-terminated string pointer
; Prints the string then CRLF.
; ---------------------------------------------------------
PRILIN:
        CALL TERPUT1
        CALL    PRINEWLI
        RET

; ---------------------------------------------------------
; printNewLine
; Prints a blank line (CRLF).
; ---------------------------------------------------------
PRINEWLI:
        LD      HL,STRCRLF
        CALL TERPUT1
        RET

; ---------------------------------------------------------
; listRoomObjects
; Prints a list of visible objects in the current room.
; Current scope: only objects 7..24 (as per original index map).
; ---------------------------------------------------------
LISROOOB:
        LD      A,(PLALOC)
        LD      C,A                    ; C = current room
        LD      HL,OBJLOC
        LD      B,OBJCRECO     ; skip creatures 1..6
LOSKICRE:
        INC     HL
        DJNZ    LOSKICRE

        LD      B,OBJITECO      ; objects 7..24 count
        LD      D,0                    ; printed-any flag
        LD      E,FIROBJIN     ; current object id (7..24)
LO_LOOP:
        LD      A,(HL)                 ; A = location
        CP      C
        JR      NZ,LO_NEXT
        LD      A,D
        OR      A
        JR      NZ,LOPRIOBJ
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRINEWLI           ; blank line between room desc and header
        POP     HL
        POP     DE
        POP     BC
        PUSH    DE                     ; preserve current object id (E)
        PUSH    HL
        LD      HL,STRSEEOB
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRILIN
        POP     HL
        POP     DE
        POP     BC
        POP     HL
        POP     DE
        LD      D,1
LOPRIOBJ:
        ; print: adjective includes article ("a"/"an") + noun
        PUSH    DE                     ; preserve current object id (E)
        PUSH    HL
        LD      A,E
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRIOBJAD
        POP     HL
        POP     DE
        POP     BC
        POP     HL
        PUSH    BC
        PUSH    DE
        PUSH    HL
        CALL    PRINEWLI
        POP     HL
        POP     DE
        POP     BC
        POP     DE
LO_NEXT:
        INC     HL
        INC     E
        DJNZ    LO_LOOP
        RET

; ---------------------------------------------------------
; printObjectAdjNoun
; A = object id (7..24)
; Prints adjective then noun via tables.
;
; Clobbers:
;   AF, BC, DE, HL
; ---------------------------------------------------------
PRIOBJAD:
        SUB     FIROBJIN
        LD      B,A                    ; save 0-based index (SYS_PUTS clobbers C)
        LD      C,A                    ; 0-based index into object tables
        LD      HL,OBJNAMNA
        LD      A,B
        CALL    PRIWORTA
        RET

; A = object index (7..24)
PRIOBJA1:
        SUB     FIROBJIN
        LD      B,A
        LD      HL,OBJNAMNA
        LD      A,B
        CALL    PRIWORTA
        RET

; ---------------------------------------------------------
; printWordTableEntry0Based
; HL = base of DW table, A = 0-based index
; Loads word pointer and prints if non-zero.
;
; Clobbers:
;   AF, BC, DE, HL
; ---------------------------------------------------------
PRIWORTA:
        ADD     A,A                    ; index * 2
        LD      E,A
        LD      D,0
        ADD     HL,DE
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      A,D
        OR      E
        RET     Z
        EX      DE,HL
        CALL TERPUT1
        RET

