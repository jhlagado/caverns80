; ---------------------------------------------------------
; cmdList
; Prints carried objects (objectLocation == roomCarried).
; Current scope: objects 7..24 only.
;
; Notes:
; - SYS_PUTS clobbers C and advances HL.
; - printObjectAdjNoun clobbers B/C/HL, so B (loop counter) and HL
;   (objectLocation pointer) must be preserved across the call.
; ---------------------------------------------------------
CMDLIST:
        LD      HL,STRCARPR
        CALL TERPUT1

        LD      HL,OBJLOC
        LD      B,OBJCRECO     ; skip creatures 1..6
CLSKICRE:
        INC     HL
        DJNZ    CLSKICRE

        LD      B,OBJITECO      ; objects 7..24 count
        LD      D,0                    ; printed-any flag
        LD      E,FIROBJIN     ; current object id (7..24)
CL_LOOP:
        LD      A,(HL)
        CP      ROOCAR
        JR      NZ,CL_NEXT

        LD      A,D
        OR      A
        JR      Z,CL_FIRST
        PUSH    HL                     ; preserve objectLocation pointer
        LD      HL,STRCOMSP
        CALL TERPUT1
        POP     HL
        JR      CL_PRINT
CL_FIRST:
        LD      D,1
CL_PRINT:
        PUSH    BC                     ; preserve loop counter
        PUSH    DE                     ; preserve object id (E)
        PUSH    HL                     ; preserve objectLocation pointer
        LD      A,E
        CALL    PRIOBJAD
        POP     HL
        POP     DE
        POP     BC

CL_NEXT:
        INC     HL
        INC     E
        DJNZ    CL_LOOP

        LD      A,D
        OR      A
        JR      NZ,CL_DONE
        LD      HL,STRNOT
        CALL TERPUT1
CL_DONE:
        CALL    PRINEWLI
        CALL    PRINEWLI
        RET

; toUpperA
; A = ASCII char; returns uppercase for a-z.
TOUPPERA:
        CP      'a'
        RET     C
        CP      'z'+1
        RET     NC
        AND     $DF
        RET

 ; readLn: HL buffer, B capacity including null. AF BC DE HL clobbered.
; CP/M raw console input with local echo. Full lines drain to CR/LF;
; backspace edits the current buffer and Ctrl-C returns safely to CP/M.
READLN:
        XOR A
        LD (INPOVER),A
        LD A,B
        OR A
        RET Z
        DEC B
        LD C,0
RL_LOOP:
        CALL TERGET
        CP 3
        JP Z,CPMEXIT
        CP 13
        JR Z,RL_DONE
        CP 10
        JR Z,RL_DONE
        CP 8
        JR Z,RL_BACK
        CP 127
        JR Z,RL_BACK
        CP 32
        JR C,RL_LOOP
        LD D,A
        LD A,C
        CP B
        JR C,RLSTORE
        LD A,1
        LD (INPOVER),A
        JR RL_LOOP
RLSTORE:
        LD A,D
        LD (HL),A
        INC HL
        INC C
        CALL TERPUT
        JR RL_LOOP
RL_BACK:
        LD A,C
        OR A
        JR Z,RL_LOOP
        DEC HL
        DEC C
        LD A,8
        CALL TERPUT
        LD A,32
        CALL TERPUT
        LD A,8
        CALL TERPUT
        JR RL_LOOP
RL_DONE:
        LD (HL),0
        LD A,(INPOVER)
        OR A
        JR Z,RLACCEPT
        LD A,C
        LD E,A
        LD D,0
        OR A
        SBC HL,DE
        LD (HL),0
        LD HL,LONGMSG
        CALL TERPUT1
RLACCEPT:
        LD A,13
        CALL TERPUT
        LD A,10
        CALL TERPUT
        RET
