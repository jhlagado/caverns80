; Save record codec v1. No BDOS or terminal calls.
; SVENC encodes live state into SVBUF; does not modify live state.
; SVVALID returns A=0/Z valid, A=1/NZ invalid. Live state untouched.
; SVAPPLY validates before publication; same status, atomic rejection.
; All entries clobber AF BC DE HL; preserve IX IY and balanced stack.
; Record: CV80,format1,rules1,payload48LE,CRC16LE,reserved6;
; payload offsets16..63, padding64..127. Reserved bytes must be zero.
; CRC16/CCITT-FALSE over128bytes, treating offsets8/9 as zero.
SVENC:
        LD HL,SVBUF
        LD DE,SVBUF+1
        LD BC,127
        LD (HL),0
        LDIR
        LD A,67
        LD (SVBUF+0),A
        LD A,86
        LD (SVBUF+1),A
        LD A,56
        LD (SVBUF+2),A
        LD A,48
        LD (SVBUF+3),A
        LD A,1
        LD (SVBUF+4),A
        LD A,1
        LD (SVBUF+5),A
        LD A,48
        LD (SVBUF+6),A
        LD A,(PLALOC)
        LD (SVBUF+16),A
        LD A,(CANISLIT)
        LD (SVBUF+17),A
        LD A,(TURCOU)
        LD (SVBUF+18),A
        LD A,(TURCOU+1)
        LD (SVBUF+19),A
        LD A,(RNGSTATE)
        LD (SVBUF+20),A
        LD A,(RNGSTATE+1)
        LD (SVBUF+21),A
        LD A,(BRICON)
        LD (SVBUF+22),A
        LD A,(DRASTA)
        LD (SVBUF+23),A
        LD A,(WATEXILO)
        LD (SVBUF+24),A
        LD A,(GATDES)
        LD (SVBUF+25),A
        LD A,(TELDES)
        LD (SVBUF+26),A
        LD A,(SECEXILO)
        LD (SVBUF+27),A
        LD A,(GENFLAJ)
        LD (SVBUF+28),A
        LD A,(HOSCREIN)
        LD (SVBUF+29),A
        LD A,(FEACOU)
        LD (SVBUF+30),A
        LD A,(SWOSWICO)
        LD (SVBUF+31),A
        LD A,(RESFLA)
        LD (SVBUF+32),A
        LD A,(SCORE)
        LD (SVBUF+34),A
        LD HL,OBJLOC
        LD DE,SVBUF+36
        LD BC,24
        LDIR
        CALL SVCRC
        LD (SVBUF+8),DE
        XOR A
        RET

SVVALID:
        LD A,(SVBUF+0)
        CP 67
        JP NZ,SVBAD
        LD A,(SVBUF+1)
        CP 86
        JP NZ,SVBAD
        LD A,(SVBUF+2)
        CP 56
        JP NZ,SVBAD
        LD A,(SVBUF+3)
        CP 48
        JP NZ,SVBAD
        LD A,(SVBUF+4)
        CP 1
        JP NZ,SVBAD
        LD A,(SVBUF+5)
        CP 1
        JP NZ,SVBAD
        LD A,(SVBUF+6)
        CP 48
        JP NZ,SVBAD
        LD A,(SVBUF+7)
        CP 0
        JP NZ,SVBAD
        LD A,(SVBUF+33)
        CP 0
        JP NZ,SVBAD
        LD A,(SVBUF+35)
        CP 0
        JP NZ,SVBAD
        LD HL,SVBUF+10
        LD B,6
        CALL SVZEROS
        JP NZ,SVBAD
        LD HL,SVBUF+60
        LD B,68
        CALL SVZEROS
        JP NZ,SVBAD
        CALL SVCRC
        LD HL,(SVBUF+8)
        OR A
        SBC HL,DE
        JP NZ,SVBAD
        LD A,(SVBUF+16)
        DEC A
        CP 54
        JP NC,SVBAD
        LD HL,(SVBUF+20)
        LD A,H
        OR L
        JP Z,SVBAD
        LD A,(SVBUF+17)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+28)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+32)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+29)
        CP 7
        JP NC,SVBAD
        LD A,(SVBUF+34)
        CP 127
        JP NC,SVBAD
        LD A,(SVBUF+22)
        CP 0
        JR Z,SVOK22
        CP 11
        JR Z,SVOK22
        CP 128
        JR Z,SVOK22
        JP SVBAD
SVOK22:
        LD A,(SVBUF+23)
        CP 0
        JR Z,SVOK23
        CP 49
        JR Z,SVOK23
        JP SVBAD
SVOK23:
        LD A,(SVBUF+24)
        CP 0
        JR Z,SVOK24
        CP 43
        JR Z,SVOK24
        JP SVBAD
SVOK24:
        LD A,(SVBUF+25)
        CP 0
        JR Z,SVOK25
        CP 39
        JR Z,SVOK25
        JP SVBAD
SVOK25:
        LD A,(SVBUF+26)
        CP 0
        JR Z,SVOK26
        CP 19
        JR Z,SVOK26
        JP SVBAD
SVOK26:
        LD A,(SVBUF+27)
        CP 0
        JR Z,SVOK27
        CP 38
        JR Z,SVOK27
        JP SVBAD
SVOK27:
        LD HL,SVBUF+36
        LD B,6
SVCRLOOP:
        LD A,(HL)
        CP 55
        JR NC,SVBAD
        INC HL
        DJNZ SVCRLOOP
        LD B,18
SVOBLOOP:
        LD A,(HL)
        CP 255
        JR Z,SVOBNEXT
        CP 55
        JR NC,SVBAD
SVOBNEXT:
        INC HL
        DJNZ SVOBLOOP
        XOR A
        RET
SVBAD:
        LD A,1
        OR A
        RET
SVZEROS:
        LD A,(HL)
        OR A
        RET NZ
        INC HL
        DJNZ SVZEROS
        RET

SVAPPLY:
        CALL SVVALID
        RET NZ
        LD A,(SVBUF+16)
        LD (PLALOC),A
        LD A,(SVBUF+17)
        LD (CANISLIT),A
        LD A,(SVBUF+18)
        LD (TURCOU),A
        LD A,(SVBUF+19)
        LD (TURCOU+1),A
        LD A,(SVBUF+20)
        LD (RNGSTATE),A
        LD A,(SVBUF+21)
        LD (RNGSTATE+1),A
        LD A,(SVBUF+22)
        LD (BRICON),A
        LD A,(SVBUF+23)
        LD (DRASTA),A
        LD A,(SVBUF+24)
        LD (WATEXILO),A
        LD A,(SVBUF+25)
        LD (GATDES),A
        LD A,(SVBUF+26)
        LD (TELDES),A
        LD A,(SVBUF+27)
        LD (SECEXILO),A
        LD A,(SVBUF+28)
        LD (GENFLAJ),A
        LD A,(SVBUF+29)
        LD (HOSCREIN),A
        LD A,(SVBUF+30)
        LD (FEACOU),A
        LD A,(SVBUF+31)
        LD (SWOSWICO),A
        LD A,(SVBUF+32)
        LD (RESFLA),A
        LD A,(SVBUF+34)
        LD (SCORE),A
        LD HL,SVBUF+36
        LD DE,OBJLOC
        LD BC,24
        LDIR
        XOR A
        RET

; SVCRC returns DE checksum; leaves SVBUF unchanged.
SVCRC:
        LD HL,SVBUF
        LD DE,$FFFF
        LD B,128
        LD C,0
SVCRBYTE:
        LD A,C
        CP 8
        JR Z,SVCRZERO
        CP 9
        JR Z,SVCRZERO
        LD A,(HL)
        JR SVCRXOR
SVCRZERO:
        XOR A
SVCRXOR:
        XOR D
        LD D,A
        PUSH BC
        LD B,8
SVCRBIT:
        SLA E
        RL D
        JR NC,SVCRNEXT
        LD A,D
        XOR $10
        LD D,A
        LD A,E
        XOR $21
        LD E,A
SVCRNEXT:
        DJNZ SVCRBIT
        POP BC
        INC HL
        INC C
        DJNZ SVCRBYTE
        RET
SVCODEND:
