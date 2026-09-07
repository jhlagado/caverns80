START:
        LD SP,STACKTOP
        LD HL,$ACE1
        LD (RNGSTATE),HL
        CALL    INISTA
        LD      HL,TITLE
        CALL TERPUT1
        CALL    CMDHELP
        CALL    PRICURRO

READLOOP:
        LD      HL,PROSTR
        CALL TERPUT1
        XOR     A
        LD      (BUF),A                ; clear buffer to avoid stale echo
        LD      HL,BUF
        LD      B,32           ; buffer length including terminator
        CALL    READLN
        LD      A,(BUF)        ; treat control/empty as termination
        CP      $20
        JR      C,READLOOP     ; empty input returns to the prompt

        CALL    HANINPLI
        JR      READLOOP

DONE:   LD      HL,DONE_MSG
        CALL TERPUT1
        JP CPMEXIT

; ---------------------------------------------------------
; initState
; Initializes a minimal subset of game state (expand incrementally).
; ---------------------------------------------------------
INISTA:
        ; Clear screen (ANSI ESC[2J ESC[H])
        LD      HL,CLESEQ
        CALL TERPUT1

        LD      A,ROODARRO
        LD      (PLALOC),A

        LD      A,BOOLTRUE
        LD      (CANISLIT),A

        XOR     A
        LD      (BRICON),A
        LD      (DRASTA),A
        LD      (WATEXILO),A
        LD      (GATDES),A
        LD      (TELDES),A
        LD      (SECEXILO),A
        LD      (GENFLAJ),A
        LD      (HOSCREIN),A
        LD      (RESFLA),A
        LD      (FEACOU),A
        LD      (TURCOU),A
        LD      (TURCOU+1),A
        LD      (SWOSWICO),A
        LD      (SCORE),A

        ; Initialize creatures + objects from the original P(1..24) table.
        ; `objectLocationTable` is DW entries; the low byte is the room id.
        LD      HL,OBJLOCTA
        LD      DE,OBJLOC
        LD      B,OBJCOU
ISINIOBJ:
        LD      A,(HL)                 ; low byte = room id (0..255)
        LD      (DE),A
        INC     HL
        INC     HL                     ; skip high byte
        INC     DE
        DJNZ    ISINIOBJ
        RET

