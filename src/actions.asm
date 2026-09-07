; Minimal quit/galar/ape placeholders for now.
CMDSCORE:
        CALL    COMSCO
        LD      HL,STRSCOPR
        CALL TERPUT1
        LD      A,(SCORE)
        CALL    PRIBYTDE
        CALL    PRINEWLI
        CALL    PRINEWLI
        RET

CMDHELP:
        CALL PGBEGIN
        LD      HL,STORYTXT
        CALL    TERPUT1
        LD      HL,STRHELTE
        CALL    PRILIN
        CALL    PRINEWLI
        CALL PAGEEND
        RET

CMDQUIT:
        CALL    COMSCO

        LD      HL,STRSCOPR
        CALL TERPUT1
        LD      A,(SCORE)
        CALL    PRIBYTDE

        LD      HL,STRSCOMI
        CALL TERPUT1
        LD      HL,(TURCOU)
        CALL    PRIWOR

        LD      HL,STRSCOSU
        CALL    PRILIN
        CALL    PRINEWLI

        CALL    VOLPROM
        RET

; unreachable (promptPlayAgain handles restart/exit)
CMDGALAR:
        XOR     A
        LD      (SWOSWICO),A
        LD      HL,STRMAGWI
        CALL    PRILIN
        CALL    PRINEWLI
        LD      A,ROOCAVE1
        LD      (PLALOC),A
        CALL    PRICURRO
        RET
CMDAPE:
        ; Only meaningful in the crypt.
        LD      A,(PLALOC)
        CP      ROOCRY
        JR      Z,CA_DO
        LD      HL,STRNOTHA
        CALL    PRILIN
        CALL    PRINEWLI
        RET
CA_DO:
        LD      HL,STRCRYWA
        CALL    PRILIN
        CALL    PRINEWLI
        ; Open the eastern wall exit via dynamic override.
        LD      A,ROOTINCE
        LD      (SECEXILO),A
        CALL    PRICURRO
        RET

; ---------------------------------------------------------
; promptPlayAgain
; Asks "Another adventure?" and restarts on yes/ok.
; ---------------------------------------------------------
; Fatal entry: cancellation disabled. Voluntary entry: RET may resume caller.
; The permission byte lives on this activation's stack, never in game state.
PROPLAAG:
        XOR A
        LD HL,STRANO
        JR PPASHARE
VOLPROM:
        LD A,1
        LD HL,VOLTEXT
PPASHARE:
        PUSH AF
        CALL TERPUT1

PPA_READ:
        LD      HL,BUF
        LD      B,32
        CALL    READLN

        LD      HL,BUF
PPASKISP:
        LD      A,(HL)
        OR      A
        JR      Z,PPA_READ
        CP      ' '
        JR      NZ,PPACHE
        INC     HL
        JR      PPASKISP

PPACHE:
        CP      0
        JR      Z,PPARES
        CP      'y'
        JR      Z,PPARES
        CP      'Y'
        JR      Z,PPARES
        CP      'n'
        JR      Z,PPA_EXIT
        CP      'N'
        JR      Z,PPA_EXIT
        CP 'c'
        JR Z,PPACAN
        CP 'C'
        JR Z,PPACAN
PPA_BAD:
        LD      HL,STREH
        CALL    PRILIN
        JR      PPA_READ

PPACAN:
        INC HL
        LD A,(HL)
        OR A
        JR Z,PPACHECK
        LD DE,CANTAIL
PPACWORD:
        LD A,(HL)
        CALL TOUPPERA
        LD B,A
        LD A,(DE)
        CP B
        JR NZ,PPA_BAD
        OR A
        JR Z,PPACHECK
        INC HL
        INC DE
        JR PPACWORD
PPACHECK:
        POP AF
        PUSH AF
        OR A
        JR Z,PPA_BAD
        POP AF
        RET

PPARES:
        POP AF
        JP START                ; reset SP before reinitializing gameplay

PPA_EXIT:
        POP AF
        JP CPMEXIT

; ---------------------------------------------------------
; cmdOpen / cmdUnlock
; Minimal behavior for the key:
; - Requires key noun (orderless) and key carried
; - Works in:
;     roomForestClearing -> moves to roomDarkRoom (hut door)
;     roomTemple         -> moves to roomCrypt (locked gate)
; - Key must be carried; key is not consumed
; ---------------------------------------------------------
CMDUNL:
        JR      CMDOPECO

CMDOPEN:
        ; fallthrough
CMDOPECO:
        ; Require key to be one noun and door/gate to be the other noun.
        LD      A,(CUROBJIN)
        LD      B,A
        LD      A,(TARLOC)
        LD      C,A
        CALL    GETOPEAC
        OR      A
        JR      NZ,COCHAVAC
        LD      HL,STRPLETE
        CALL    PRILIN
        CALL    PRINEWLI
        RET

COCHAVAC:
        LD      E,A                    ; preserve action kind
        ; Require key carried.
        LD      A,(OBJLOC+OBJKEY-1)
        CP      ROOCAR
        JR      Z,COCKEYCA
        LD      HL,STRNOTCA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

COCKEYCA:
        LD      A,E
        ; A = action type (1=door, 2=gate)
        CP      1
        JR      Z,COCOPEDO
        ; action type 2 = gate
        LD      A,(PLALOC)
        CP      ROOTEM
        JR      Z,COCGATOK
        LD      HL,STRWONOP
        CALL    PRILIN
        CALL    PRINEWLI
        RET

COCOPEDO:
        LD      A,(PLALOC)
        CP      ROOFORCL
        JR      Z,COCDOOOK
        LD      HL,STRWONOP
        CALL    PRILIN
        CALL    PRINEWLI
        RET

COCDOOOK:
        LD      HL,STRDOOOP
        CALL    PRILIN
        LD      A,ROODARRO
        LD      (PLALOC),A
        CALL    PRICURRO
        RET

COCGATOK:
        LD      HL,STRGATOP
        CALL    PRILIN
        LD      A,ROOCRY
        LD      (PLALOC),A
        CALL    PRICURRO
        RET

; Inputs:
;   B = noun1, C = noun2
; Returns:
;   A = 1 for door, 2 for gate, 0 for missing/invalid
GETOPEAC:
        ; key + door
        LD      A,B
        CP      OBJKEY
        JR      NZ,GOACHEDO
        LD      A,C
        CP      NOUNDOOR
        JR      Z,GOADOO
GOACHEDO:
        LD      A,C
        CP      OBJKEY
        JR      NZ,GOACHEGA
        LD      A,B
        CP      NOUNDOOR
        JR      Z,GOADOO

GOACHEGA:
        ; key + gate
        LD      A,B
        CP      OBJKEY
        JR      NZ,GOACHEG1
        LD      A,C
        CP      NOUNGATE
        JR      Z,GOAGAT
GOACHEG1:
        LD      A,C
        CP      OBJKEY
        JR      NZ,GOANON
        LD      A,B
        CP      NOUNGATE
        JR      Z,GOAGAT

GOANON:
        XOR     A
        RET

GOADOO:
        LD      A,1
        RET

GOAGAT:
        LD      A,2
        RET

; ---------------------------------------------------------
; cmdDown
; Clean model: DOWN is a verb. If rope is mentioned and you're in room 28,
; descend to room 35 (temple), leaving the  rope behind.
; ---------------------------------------------------------
CMDDOWN:
        ; Require rope noun (either noun1 or noun2) and rope must be carried.
        LD      A,(CUROBJIN)
        CP      OBJROPE
        JR      Z,CDHAVROP
        LD      A,(TARLOC)
        CP      OBJROPE
        JR      Z,CDHAVROP
        LD      HL,STRICANT
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CDHAVROP:
        LD      A,(OBJLOC+OBJROPE-1)
        CP      ROOCAR
        JR      Z,CDROPCAR
        LD      HL,STRNOTCA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CDROPCAR:
        LD      A,(PLALOC)
        CP      ROOTEMBA
        JR      Z,CDDODES
        LD      HL,STRTOODA
        CALL    PRILIN
        CALL    PRINEWLI
        RET

CDDODES:
        XOR     A
        LD      (SWOSWICO),A
        LD      HL,STRDESRO
        CALL    PRILIN

        ; Leave rope in current room (28) and move player to temple (35).
        LD      A,ROOTEMBA
        LD      (OBJLOC+OBJROPE-1),A
        LD      A,ROOTEM
        LD      (PLALOC),A
        CALL    PRICURRO
        RET

; ---------------------------------------------------------
; cmdStubAction
; Placeholder for not-yet-implemented verbs. Prints the verb token
; and the scanned nouns (noun1/noun2) for debugging.
; ---------------------------------------------------------
CMDSTUAC:
        LD      HL,STRSTUVE
        CALL TERPUT1

        ; Print verb token text (space padded) from verbTokenTable[verbPatternIndex]
        LD      A,(VERPATIN)
        DEC     A
        ADD     A,A
        LD      E,A
        LD      D,0
        LD      HL,VERTOKTA
        ADD     HL,DE
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        EX      DE,HL
        CALL TERPUT1

        LD      HL,STRSTUTA
        CALL TERPUT1
        LD      A,(CUROBJIN)
        CALL    PRINOUBY

        LD      HL,STRSTUTO
        CALL TERPUT1
        LD      A,(TARLOC)
        CALL    PRINOUBY

        CALL    PRINEWLI
        CALL    PRINEWLI
        RET

