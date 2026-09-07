IMMEND:
WORSTA:
; ---------------------------------------------------------
;  Variables and arrays (uninitialised, set at gameStart)
; ---------------------------------------------------------

; Single-byte state
BRICON:         DB 0
DRASTA:         DB 0
WATEXILO:       DB 0
GATDES:         DB 0
TELDES:     DB 0
SECEXILO:      DB 0
GENFLAJ:            DB 0
HOSCREIN:    DB 0
RESFLA:              DB 0
PLALOC:          DB 0
CANISLIT:         DB 0
FEACOU:             DB 0
TURCOU:             DW 0
SWOSWICO:         DB 0
SCORE:                   DB 0
CUROBJIN:      DB 0
VISOBJCO:      DB 0
VISCRECO:    DB 0
YESNOKEY:                DB 0
RANDIRIN:    DB 0
RANFIGME:      DB 0
TARLOC:          DB 0
CARCOU:            DB 0
LOOIND:               DB 0
VERPATIN:        DB 0
DIRIND:          DB 0

OBJLOC:          DS 24               ; byte per object/creature

; Input buffer (padded with leading/trailing space)
INPBUF:             DS INPBUFSI
BUF:                     DS 32,0

RNGSTATE: DW $ACE1
; Save candidate record.
SVBUF: DS 128,0
SVBUFEND:
INPOVER: DB 0
WOREND:
STABOT: DS 512,0
STACKTOP:
PROEND:
