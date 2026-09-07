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

; ---------------------------------------------------------
; cmdLight
; Behavior: "light" is recognized but requires clarification.
; (In the original BASIC this prints "Please tell me how." and does not relight.)
; ---------------------------------------------------------
CMDLIGHT:
        JP      CMDLIGBU

; ---------------------------------------------------------
; cmdBurn
; Special-case: burning the bomb requires candle as the second noun.
; Otherwise behaves like "Please tell me how."
; ---------------------------------------------------------
CMDBURN:
        ; fallthrough

; ---------------------------------------------------------
; cmdLightBurnBombCommon
; Handles "light/burn bomb candle" gating.
;
; Rule (as requested):
; - Require bomb noun + candle noun (orderless).
; - If requirement not met: "Please tell me how."
; - If bomb not mentioned: "Please tell me how."
;
; Note: The actual bomb explosion logic is implemented separately.
; ---------------------------------------------------------
CMDLIGBU:
        ; Require bomb noun to be present.
        LD      A,(CUROBJIN)
        CP      OBJBOMB
        JR      Z,CLBHAVBO
        LD      A,(TARLOC)
        CP      OBJBOMB
        JR      Z,CLBHAVBO
        JP      CMDNEEHO

CLBHAVBO:
        ; Require candle noun (explicit, orderless).
        LD      A,(CUROBJIN)
        CP      OBJCAN
        JR      Z,CLBHAVCA
        LD      A,(TARLOC)
        CP      OBJCAN
        JR      Z,CLBHAVCA
        JP      CMDNEEHO

CLBHAVCA:
        ; Require candle to be carried (tool).
        LD      A,(OBJLOC+OBJCAN-1)
        CP      ROOCAR
        JR      Z,CLBCANOK
        LD      HL,STRNOTCA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CLBCANOK:
        ; Candle must be lit.
        LD      A,(CANISLIT)
        OR      A
        JR      NZ,CLBCANLI
        LD      HL,STRCANO1
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CLBCANLI:
        ; Require bomb to be carried or present.
        LD      A,(PLALOC)
        LD      C,A
        LD      A,(OBJLOC+OBJBOMB-1)
        CP      ROOCAR
        JR      Z,CLBBOMOK
        CP      C
        JR      Z,CLBBOMOK
        LD      HL,STRCANSE
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CLBBOMOK:
        ; The oak door is the only useful and safe place to set this charge.
        ; Validate before consuming the bomb or changing any world state.
        LD      A,(PLALOC)
        CP      ROOOAKDO
        JR      Z,CLBAFTKN
        LD      HL,STRTOODA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

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

