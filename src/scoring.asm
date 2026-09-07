; ---------------------------------------------------------
; computeScore
; Implements the scoring rule for objects 7..17:
; - if carried: add (idx-6)
; - if in room 1: add (idx-6)*2
; Stores result in (score).
; ---------------------------------------------------------
COMSCO:
        XOR     A
        LD      (SCORE),A
        LD      B,FIRSCOOB        ; 7
CS_LOOP:
        LD A,B
        CP OBJBOMB
        JR Z,CS_NEXT
        ; Load object location for index B
        LD      A,B
        DEC     A
        LD      L,A
        LD      H,0
        LD      DE,OBJLOC
        ADD     HL,DE
        LD      A,(HL)
        CP      ROOCAR
        JR      Z,CSADDONC
        CP      ROODARRO
        JR      Z,CSADDTWI
        JR      CS_NEXT

CSADDONC:
        LD      A,B
        SUB     SCOINDBA              ; (idx-6)
        LD      C,A
        LD      A,(SCORE)
        ADD     A,C
        LD      (SCORE),A
        JR      CS_NEXT

CSADDTWI:
        LD      A,B
        SUB     SCOINDBA
        ADD     A,A
        LD      C,A
        LD      A,(SCORE)
        ADD     A,C
        LD      (SCORE),A

CS_NEXT:
        INC     B
        LD      A,B
        CP      AFTLASSC      ; 18
        JR      NZ,CS_LOOP
        RET

; ---------------------------------------------------------
; printByteDecA
; Prints unsigned A in decimal (0..255) with no leading zeros.
; Clobbers: A, B, C, D, E
; ---------------------------------------------------------
PRIBYTDE:
        LD      B,0                    ; printed-any flag

        LD      D,100
        CALL    PBDDIG
        LD      D,10
        CALL    PBDDIG
        LD      D,1
        CALL    PBDDIGLA
        RET

; D = divisor (100 or 10)
PBDDIG:
        LD E,0
PBDDLO:
        CP D
        JR C,PBDDDO
        SUB D
        INC E
        JR PBDDLO
PBDDDO:
        PUSH AF
        LD A,B
        OR E
        JR Z,PBDEND
PBDPRIDI:
        LD A,E
        ADD A,'0'
        CALL TERPUT
        LD B,1
PBDEND:
        POP AF
        RET

; D = 1
PBDDIGLA:
        LD      C,A                    ; remaining value 0..9
        LD      A,B
        OR      A
        JR      NZ,PBDPRILA
        ; if nothing printed yet, print 0..9 (including 0)
PBDPRILA:
        LD      A,C
        ADD     A,'0'
        CALL TERPUT
        RET

