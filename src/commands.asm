; Add short forms only when the normal verb scan found no verb.
SHORTCMD:
        LD DE,SAVWORD
        CALL FILEVERB
        JR NZ,TRYLOAD
        LD A,12
        JP SHORTSET
TRYLOAD:
        LD DE,LOADWORD
        CALL FILEVERB
        JR NZ,TRYSHORT
        LD A,13
        JP SHORTSET
TRYSHORT:
        LD A,(VERPATIN)
        OR A
        RET NZ
        LD A,(BUF)
        CALL TOUPPERA
        LD B,A
        LD A,(BUF+1)
        OR A
        JR Z,SHORTONE
        CP 32
        RET NZ
        LD A,B
        CP 'X'
        RET NZ
        LD A,8
        JR SHORTSET
SHORTONE:
        LD A,B
        CP 'N'
        LD A,32
        JR Z,SHORTSET
        LD A,B
        CP 'S'
        LD A,33
        JR Z,SHORTSET
        LD A,B
        CP 'W'
        LD A,34
        JR Z,SHORTSET
        LD A,B
        CP 'E'
        LD A,35
        JR Z,SHORTSET
        LD A,B
        CP 'I'
        RET NZ
        LD A,3
SHORTSET:
        LD (VERPATIN),A
        RET

; Describe present objects. Unrecognized scenery uses the contextual inscription.
EXAMCMD:
        LD A,(CUROBJIN)
        OR A
        JP Z,CMDREAD
        CP 25
        JP NC,CMDREAD
        LD B,A
        DEC A
        LD E,A
        LD D,0
        LD HL,OBJLOC
        ADD HL,DE
        LD A,(HL)
        CP 255
        JR Z,EXAMPRES
        LD C,A
        LD A,(PLALOC)
        CP C
        JP NZ,CMDGETCA
EXAMPRES:
        LD A,B
        LD HL,EXAMTAB
        JP PRIDES

; Leading file command has priority over words inside the slot name.
FILEVERB:
        LD HL,BUF
FILESKIP:
        LD A,(HL)
        CP 32
        JR NZ,FILECOMP
        INC HL
        JR FILESKIP
FILECOMP:
        LD B,4
FILELOOP:
        LD A,(DE)
        LD C,A
        LD A,(HL)
        CALL TOUPPERA
        CP C
        RET NZ
        INC DE
        INC HL
        DJNZ FILELOOP
        LD A,(HL)
        OR A
        RET Z
        CP 32
        RET
SAVWORD: DB "SAVE"
LOADWORD: DB "LOAD"

; An actor leaving the represented world is removed, never an invalid index.
CLAMPLOC:
        CP 55
        RET C
        XOR A
        RET
