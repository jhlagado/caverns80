CMDNORTH:
        LD      A,DIRNORTH
        JR      DOMOVE
CMDSOUTH:
        LD      A,DIRSOUTH
        JR      DOMOVE
CMDWEST:
        LD      A,DIRWEST
        JR      DOMOVE
CMDEAST:
        LD      A,DIREAST
        ; fallthrough

; doMove
; A = dir index (0..3)
DOMOVE:
        LD      C,A                    ; C = dir index
        LD      A,(PLALOC)     ; 1-based room id
        OR      A
        RET     Z

        ; Dynamic exit override layer:
        ; If a (room,dir) override exists, use it; otherwise fall back to movementTable.
        LD      B,A                    ; save current room id (1-based)
        PUSH    BC                     ; preserve B(room) + C(dir) across resolver
        CALL    RESDYNEX     ; A = override dest or 0
        POP     BC
        OR      A
        JR      NZ,HAVEDEST            ; if override present, skip static lookup

        LD      A,B                    ; restore current room id for static lookup
        DEC     A                      ; 0-based room index
        ADD     A,A                    ; *2
        ADD     A,A                    ; *4
        ADD     A,C                    ; + dir
        LD      E,A
        LD      D,0
        LD      HL,MOVTAB
        ADD     HL,DE
        LD      A,(HL)                 ; A = destination (0/128/some room id)
HAVEDEST:
        OR      A
        JR      Z,CANTMOVE
        CP      EXIFAT
        JR      Z,FATMOV

        LD      (PLALOC),A
        XOR     A
        LD      (SWOSWICO),A
        CALL    PRICURRO
        RET

CANTMOVE:
        LD      HL,STRCANGO
        CALL    PRILIN
        CALL    PRINEWLI
        RET

FATMOV:
        LD      HL,STRFATFA
        CALL    PRILIN
        CALL    PROPLAAG
        RET

; ---------------------------------------------------------
; resolveDynamicExit
; Checks dynamicExitPatchTable for a (room,dir) override.
;
; Inputs:
;   A = current room id (1..roomMax)
;   C = dir index (dirNorth..dirEast)
;
; Returns:
;   A = overridden destination (0 means “no override”)
;
; Clobbers:
;   B, D, E, HL
;   (Preserves C)
; ---------------------------------------------------------
RESDYNEX:
        LD      D,A                    ; D = room
        LD      E,C                    ; E = dir
        LD      HL,DYNEXIP1
        LD      B,DYNEXIPA
RDE_LOOP:
        LD      A,(HL)                 ; room
        INC     HL
        CP      D
        JR      NZ,RDESKIRO

        LD      A,(HL)                 ; dir
        INC     HL
        CP      E
        JR      NZ,RDESKIDI

        ; Match: next word is pointer to a state byte holding destination/flag.
        LD      A,(HL)                 ; ptr lo
        INC     HL
        LD      H,(HL)                 ; ptr hi
        LD      L,A
        LD      A,(HL)                 ; A = destination (0 => no override/blocked)
        RET

RDESKIRO:
        INC     HL                     ; skip dir
RDESKIDI:
        INC     HL                     ; skip ptr lo
        INC     HL                     ; skip ptr hi
        DJNZ    RDE_LOOP

        XOR     A                      ; no override
        RET

CMDLOOK:
        CALL    PRICURRO
        RET

CMDGETCA:
        LD      HL,STRCANSE
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CMDGETUN:
        LD      HL,STREH
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; ---------------------------------------------------------
; cmdNeedHow
; Behavior for verbs that require extra context.
; ---------------------------------------------------------
CMDNEEHO:
        LD      HL,STRPLETE
        CALL    PRILIN
        CALL    PRINEWLI
        XOR     A
        LD      (VERPATIN),A
        RET

 ; The parser returns up to two nouns; flask and crystal may be in either
 ; order. Keep the legacy slot numbers for existing disk records.
CMDLIGHT:
CMDBURN:
CMDUSE:
CMDLIGBU:
        LD      A,(CUROBJIN)
        CP      OBJBOMB
        JR      Z,CLBHAVBO
        LD      A,(TARLOC)
        CP      OBJBOMB
        JP      NZ,CMDNEEHO
CLBHAVBO:
        LD      A,(CUROBJIN)
        CP      OBJCAN
        JR      Z,CLBHAVCA
        LD      A,(TARLOC)
        CP      OBJCAN
        JR      Z,CLBHAVCA
        ; A bare USE FLASK reads the seal if the flask is here.
        CALL    FLASKLOC
        JP      NZ,CMDGETCA
        LD      HL,EXAM09
        JP      PRILIN
CLBHAVCA:
        LD      A,(OBJLOC+OBJCAN-1)
        CP      ROOCAR
        JR      Z,CLBCANOK
        LD      HL,STRNEEDC
        JP      PRILIN
CLBCANOK:
        ; A dark crystal can still wake the enchantment.
        CALL    FLASKLOC
        JP      NZ,CMDGETCA
        JR      CLBBOMOK

FLASKLOC:
        LD      A,(PLALOC)
        LD      C,A
        LD      A,(OBJLOC+OBJBOMB-1)
        CP      ROOCAR
        RET     Z
        CP      C
        RET

CLBBOMOK:
        ; The flask is spent only at the oak door.
        LD      A,(PLALOC)
        CP      ROOOAKDO
        JR      Z,CLBAFTKN
        LD      HL,STRSEALG
        JP      PRILIN

CLBAFTKN:
        LD      HL,STRBOMEX
        CALL    PRILIN
        XOR     A
        LD      (OBJLOC+OBJBOMB-1),A
        LD      A,ROOTRERO
        LD      (TELDES),A

CLB_DONE:
        CALL    PRICURRO
        RET

CMDDROCA:
        LD      HL,STRCANSE
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CMDDROUN:
        LD      HL,STREH
        CALL    PRILIN
        CALL    PRINEWLI
        RET

