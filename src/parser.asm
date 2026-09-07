; ---------------------------------------------------------
; handleInputLine
; Interprets a minimal command set:
; - N/S/E/W (single-letter) attempts to move.
; Otherwise handles the line as before.
; ---------------------------------------------------------
HANINPLI:
        CALL    PRINEWLI

        CALL    BUIINPPA
        CALL    SCAINPTO
        CALL SHORTCMD
        LD A,(VERPATIN)
        OR A
        JP Z,ECHOLINE
        CALL ISNONCOM
        JP Z,DISSCACO
        LD HL,(TURCOU)
        LD A,H
        AND L
        CP $FF
        JR Z,TURNFULL
        INC HL
        LD (TURCOU),HL
TURNFULL:
        CALL UPDCANBY
TURNFREE:
        CALL    MAYBATCA
        RET     Z
        CALL    MAYMONA1
        CALL    DISSCACO
        CALL    MAYMONAT
        RET

ECHOLINE:
        LD      HL,STREH
        CALL    PRILIN
        CALL    PRINEWLI
        RET

; ---------------------------------------------------------
; buildInputPadded
; Builds `inputBuffer` as: " " + BUF + " " + 0
; This lets us SEARCH for " word " tokens like the original BASIC.
; ---------------------------------------------------------
BUIINPPA:
        LD      HL,INPBUF
        LD      A,' '
        LD      (HL),A
        INC     HL

        LD      DE,BUF
BIP_COPY:
        LD      A,(DE)
        OR      A
        JR      Z,BIP_DONE
        LD      (HL),A
        INC     HL
        INC     DE
        JR      BIP_COPY

BIP_DONE:
        LD      A,' '
        LD      (HL),A
        INC     HL
        XOR     A
        LD      (HL),A
        RET

; ---------------------------------------------------------
; containsTokenCI
; Case-insensitive substring search.
;
; Inputs:
;   HL = haystack (0-terminated)
;   DE = needle (0-terminated)
;
; Returns:
;   Z set if found, Z clear if not found
;
; Clobbers:
;   AF, BC, DE, HL
; ---------------------------------------------------------
CONTOKCI:
CT_OUTER:
        LD      A,(HL)
        OR      A
        JR      Z,CTNOT

        PUSH    HL
        PUSH    DE
CT_INNER:
        LD      A,(DE)
        OR      A
        JR      Z,CT_FOUND
        LD      B,A

        LD      A,(HL)
        OR      A
        JR      Z,CTMIS
        CALL    TOUPPERA
        LD      C,A
        LD      A,B
        CALL    TOUPPERA
        CP      C
        JR      NZ,CTMIS

        INC     HL
        INC     DE
        JR      CT_INNER

CTMIS:
        POP     DE
        POP     HL
        INC     HL
        JR      CT_OUTER

CT_FOUND:
        POP     DE
        POP     HL
        CP      A              ; Z=1
        RET

CTNOT:
        OR      1              ; Z=0
        RET

; ---------------------------------------------------------
; scanInputTokens
; Populates:
;   verbPatternIndex = verbId (1..verbTokenCount) or 0
;   currentObjectIndex = noun1 (1..24) or 0
;   targetLocation = noun2 (1..24) or 0
; based on the content of inputBuffer.
; ---------------------------------------------------------
SCAINPTO:
        XOR     A
        LD      (VERPATIN),A
        LD      (CUROBJIN),A
        LD      (TARLOC),A

        ; Scan verbs (first match wins).
        LD      IX,VERTOKTA
        LD      B,VERTOKCO
        LD      C,1
SV_LOOP:
        PUSH    BC
        LD      E,(IX+0)
        LD      D,(IX+1)               ; DE = token ptr
        LD      HL,INPBUF         ; HL = input
        CALL    CONTOKCI
        POP     BC
        JR      Z,SV_HIT
        INC     IX
        INC     IX
        INC     C
        DJNZ    SV_LOOP
        JR      SN_START
SV_HIT:
        LD      A,C
        LD      (VERPATIN),A

SN_START:
        ; Scan nouns: capture first two distinct matches.
        LD      IX,NOUTOKTA
        LD      B,NOUTOKCO       ; entries (1..nounTokenCount)
        LD      C,1
SN_LOOP:
        PUSH    BC
        LD      E,(IX+0)
        LD      D,(IX+1)               ; DE = token ptr
        LD      HL,INPBUF         ; HL = input
        CALL    CONTOKCI
        POP     BC
        JR      NZ,SN_NEXT

        LD      A,(CUROBJIN)
        OR      A
        JR      Z,SN_SET1
        CP      C
        JR      Z,SN_NEXT
        LD      A,(TARLOC)
        OR      A
        JR      NZ,SN_NEXT
        LD      A,C
        LD      (TARLOC),A
        JR      SN_NEXT
SN_SET1:
        LD      A,C
        LD      (CUROBJIN),A

SN_NEXT:
        INC     IX
        INC     IX
        INC     C
        DJNZ    SN_LOOP
        RET

; ---------------------------------------------------------
; dispatchScannedCommand
; Executes the command based on scanned verb + nouns.
; ---------------------------------------------------------
DISSCACO:
        LD      A,(VERPATIN)
        OR      A
        JP      Z,ECHOLINE

        ; Verb ids (match tables.asm verbTokenTable order)
        CP      1
        JP      Z,CMDLOOK
        CP      2
        JP      Z,CMDLIST
        CP      3
        JP      Z,CMDLIST              ; invent alias
        CP      4
        JP      Z,CMDSCORE
        CP      5
        JP      Z,CMDQUIT
        CP      6
        JP      Z,CMDGALAR
        CP      7
        JP      Z,CMDAPE
        CP      8
        JP      Z,EXAMCMD
        CP      9
        JP      Z,CMDLIST
        CP      10
        JP      Z,PROPLAAG
        CP      11
        JP      Z,CMDHELP
        CP      12
        JP      Z,SAVECMD
        CP      13
        JP      Z,LOADCMD
        CP      14
        JP      Z,CMDREAD
        CP      15
        JP      Z,CMDPRAY
        CP      16
        JP      Z,CMDGET
        CP      17
        JP      Z,CMDGET               ; take alias
        CP      18
        JP      Z,CMDDROP
        CP      19
        JP      Z,CMDDROP              ; put alias (stubbed same as drop for now)
        CP      20
        JP      Z,CMDSTUAC         ; cut
        CP      21
        JP      Z,CMDSTUAC         ; break
        CP      22
        JP      Z,CMDUNL
        CP      23
        JP      Z,CMDOPEN
        CP      24
        JP      Z,CMDKILAT
        CP      25
        JP      Z,CMDKILAT
        CP      26
        JP      Z,CMDLIGHT
        CP      27
        JP      Z,CMDBURN
        CP      28
        JP      Z,CMDNEEHO            ; up
        CP      29
        JP      Z,CMDDOWN               ; down (rope descent)
        CP      30
        JP      Z,CMDNEEHO            ; jump
        CP      31
        JP      Z,CMDNEEHO            ; swim
        CP      32
        JP      Z,CMDNORTH
        CP      33
        JP      Z,CMDSOUTH
        CP      34
        JP      Z,CMDWEST
        CP      35
        JP      Z,CMDEAST
        CP      36
        JP      Z,CMDHELP
        JP      ECHOLINE

