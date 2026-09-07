; ---------------------------------------------------------
;  Data tables (constants)
; ---------------------------------------------------------

MOVTAB:
                        DB ROOFORCL,0,0,0
                        DB 0,0,ROODARFO,ROOCLOFI
                        DB 0,0,ROORIVCL,ROOFORCL
                        DB 0,0,ROOFORCL,ROOMTYMI
                        DB 0,ROORIVBA,0,ROODARFO
                        DB ROORIVCL,0,ROOCRAED,ROORIVOU
                        DB 0,0,128,ROORIVBA
                        DB 0,0,ROORIVBA,0
                        DB 0,ROOBRINO,ROOCLOFI,0
                        DB ROOMTYMI,ROOBRIMI,0,0
                        DB ROOBRINO,ROOBRISO,128,128
                        DB ROOBRIMI,0,ROOMUSRO,ROOCLIFA
                        DB 0,ROOCAVEN,0,ROOBRISO
                        DB ROOMUSRO,ROOCAVE1,0,0
                        DB 0,0,ROOBRISO,0
                        DB ROOCAVEN,ROODARCA,0,ROODEAEN
                        DB 0,0,ROOCAVE1,0
                        DB ROOCAVE1,0,ROOTORCH,0
                        DB 0,0,ROOOAKDO,0
                        DB 0,ROODARC1,0,0
                        DB ROOOAKDO,ROONORSO,0,ROOWINCO
                        DB 0,ROOTORCH,ROODARC1,0
                        DB ROOWINCO,0,0,ROODARCA
                        DB ROODARC1,ROOROURO,0,0
                        DB 0,0,ROOROURO,0
                        DB ROONORSO,ROOLEDOV,ROODARC3,ROODARC2
                        DB ROOROURO,0,0,ROOTEMBA
                        DB 0,0,ROOLEDOV,0
                        DB ROODARC4,ROOBATCA,0,ROOROURO
                        DB 0,ROODARC3,0,ROODARC6
                        DB ROOBATCA,0,ROODARC6,0
                        DB 0,0,ROODARC4,ROODARC5
                        DB ROODARC3,ROODARC5,ROODARC7,0
                        DB 0,0,0,ROOBATCA
                        DB 0,0,0,ROODARC8
                        DB ROODARC9,0,ROOTEM,ROOLEDWA
                        DB 0,ROOTEM,0,0
                        DB 0,0,0,0
                        DB 0,ROODARC8,ROOTINCE,0
                        DB ROOWATBA,ROOCASLE,ROODARC8,128
                        DB 0,0,ROORIVCO,ROODRAB
                        DB 0,0,ROODRAA,ROODRAC
                        DB ROODAR10,ROOTINCE,ROODRAB,ROODRAD
                        DB 0,0,ROODRAC,0
                        DB ROOSTOST,ROOLEDWA,0,128
                        DB 0,ROODRAC,ROOSTOST,0
                        DB 0,ROOWATBA,0,ROODAR10
                        DB ROOLEDWA,128,0,128
                        DB 0,0,ROOCASLE,ROOCASCO
                        DB 0,ROOEASRI,ROODRA,ROOPOWMA
                        DB 0,0,ROOCASCO,0
                        DB ROOCASCO,0,ROOWOOBR,0
                        DB ROORIVCO,0,0,ROOEASRI
                        DB 0,ROOWOOBR,0,ROODRAA

OBJLOCTA:
                        DW ROODARC8, ROOTRERO, ROOBRINO
                        DW ROOCAVEN
                        DW ROODEAEN, ROOSTOST, ROORIVOU
                        DW ROODARRO
                        DW ROOPOWMA, ROOWATBA
                        DW ROOWINCO, ROODAR10
                        DW ROORIVCO, ROOTRERO
                        DW ROOTRERO, ROOTRERO
                        DW ROOTRERO, EXITNONE
                        DW ROODARC7, ROOCRAED
                        DW ROODARCA, ROOCLIFA
                        DW ROONORSO, ROOTINCE

ROODES1T:
                        DW DESDARRO, DESFORCL, DESDARFO
                        DW DESCLOFI, DESRIVCL, DESRIVBA
                        DW DESCRAED, DESRIVOU, DESMTYMI
                        DW DESBRINO, DESBRIMI, DESBRISO
                        DW DESMUSRO, DESCAVCL, DESCLIFA
                        DW DESCAVEN, DESDEAEN, NULL
                        DW DESTRERO, DESOAKDO, NULL, DESWINCO
                        DW DESTORCH, DESNSTUN, NULL, DESROURO
                        DW DESLEDRI, DESTEMBA
                        DW NULL, NULL, NULL, NULL, DESBATCA, NULL, DESTEM
                        DW NULL, DESCRY, DESTINCE, NULL, DESWATLE
                        DW NULL, NULL, NULL, NULL, DESWATBA, NULL, DESSTOST
                        DW DESCASLE, DESDRA, DESCASCO
                        DW DESPOWMA, DESEASBA, DESWOOBR
                        DW DESRIVCO

ROODES2T:
                        DW NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
                        DW NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
                        DW NULL, NULL, NULL, NULL, DESTORC1, NULL, NULL
                        DW DESROUR1, NULL, DESTEMB1
                        DW NULL, NULL, NULL, NULL, DESBATC1, NULL, NULL, NULL, DESCRY2
                        DW NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
                        DW NULL, NULL, NULL, NULL, NULL, NULL, NULL

; Verb tokens for orderless input scanning (first match wins).
; Keep common no-noun verbs first, then get/drop, then movement.
VERTOKTA:
                        DW TOKLOO
                        DW TOKLIS
                        DW TOKINV
                        DW TOKSCO
                        DW TOKQUI
                        DW TOKGAL
                        DW TOKENAPE
                        DW TOKSTA2
                        DW TOKSTA3
                        DW TOKSTA4
                        DW TOKSTA5
                        DW TOKSAV
                        DW TOKLOA
                        DW TOKREA
                        DW TOKPRA
                        DW TOKENGET
                        DW TOKTAK
                        DW TOKDRO
                        DW TOKENPUT
                        DW TOKENCUT
                        DW TOKBRE
                        DW TOKUNL
                        DW TOKOPE
                        DW TOKKIL
                        DW TOKATT
                        DW TOKLIG
                        DW TOKBUR
                        DW TOKENUP
                        DW TOKDOW
                        DW TOKJUM
                        DW TOKSWI
                        DW TOKNOR
                        DW TOKSOU
                        DW TOKWES
                        DW TOKEAS
                        DW TOKHEL
VERTOKCO          EQU 36

; Noun tokens scanned from input (indices 1..nounTokenCount).
; 1..24 align to index space (creatures 1..6, objects 7..24).
; 25.. are pseudo-nouns (not in objectLocation[]), e.g. door/gate.
NOUTOKTA:
                        DW TOKWIZ, TOKDEM, TOKTRO
                        DW TOKDRA, TOKENBAT, TOKGOB
                        DW TOKCOI, TOKCOM, TOKBOM, TOKRUB
                        DW TOKDIA, TOKPEA, TOKSTO, TOKRIN
                        DW TOKPEN, TOKGRA, TOKSHI, TOKENBOX
                        DW TOKENKEY, TOKSWO, TOKCAN, TOKROP
                        DW TOKBRI, TOKGRI
                        DW TOKDOO, TOKGAT

MONNAMTA:
                        DW MONNAMWI, MONNAMDE, MONNAMTR
                        DW MONNAMDR, MONNAMBA, MONNAMGO

MONNOUTA:
                        DW MONNOUWI, MONNOUDE, MONNOUTR
                        DW MONNOUDR, MONNOUBA, MONNOUGO

OBJNAMNA:
                        DW OBJNAMCO, OBJNAMC1, OBJNAMBO, OBJNAMRU
                        DW OBJNAMDI, OBJNAMPE, OBJNAMST, OBJNAMRI
                        DW OBJNAMP1, OBJNAMGR, OBJNAMSH, OBJNAMB1
                        DW OBJNAMKE, OBJNAMSW, OBJNAMCA, OBJNAMRO
                        DW OBJNAMBR, OBJNAMG1

OBJNAMNO:
                        DW OBJNOUCO, OBJNOUC1, OBJNOUBO, OBJNOURU
                        DW OBJNOUDI, OBJNOUPE, OBJNOUST, OBJNOURI
                        DW OBJNOUP1, OBJNOUGR, OBJNOUSH, OBJNOUB1
                        DW OBJNOUKE, OBJNOUSW, OBJNOUCA, OBJNOURO
                        DW OBJNOUBR, OBJNOUG1

OBJ1TAB:
                        DW MONNAMWI, MONNAMDE, MONNAMTR
                        DW MONNAMDR, MONNAMBA, MONNAMGO
                        DW OBJNAMCO, OBJNAMC1, OBJNAMBO, OBJNAMRU
                        DW OBJNAMDI, OBJNAMPE, OBJNAMST, OBJNAMRI
                        DW OBJNAMP1, OBJNAMGR, OBJNAMSH, OBJNAMB1
                        DW OBJNAMKE, OBJNAMSW, OBJNAMCA, OBJNAMRO
                        DW OBJNAMBR, OBJNAMG1

OBJ2TAB:
                        DW MONNOUWI, MONNOUDE, MONNOUTR
                        DW MONNOUDR, MONNOUBA, MONNOUGO
                        DW OBJNOUCO, OBJNOUC1, OBJNOUBO, OBJNOURU
                        DW OBJNOUDI, OBJNOUPE, OBJNOUST, OBJNOURI
                        DW OBJNOUP1, OBJNOUGR, OBJNOUSH, OBJNOUB1
                        DW OBJNOUKE, OBJNOUSW, OBJNOUCA, OBJNOURO
                        DW OBJNOUBR, OBJNOUG1

; ---------------------------------------------------------
;  Dynamic exit patch table for updateDynamicExits
;  Each entry:
;    DB roomId
;    DB dirIndex (dirNorth/dirSouth/dirWest/dirEast)
;    DW &stateByte (variable holding runtime destination/flag)
; ---------------------------------------------------------
DYNEXIP1:
                        DB ROOBRINO, DIRSOUTH
                        DW BRICON
                        DB ROOBRISO, DIRNORTH
                        DW BRICON
                        DB ROOOAKDO, DIREAST
                        DW TELDES
                        DB ROOCRY, DIREAST
                        DW SECEXILO
                        DB ROOTINCE, DIRNORTH
                        DW WATEXILO
                        DB ROOTINCE, DIREAST
                        DW GATDES
                        DB ROOCASLE, DIREAST
                        DW DRASTA

; Rooms that should display the generic "dark cavern" extra line after the
; base description. Zero-terminated list for containsByteListZeroTerm.
DARCAVRO:
                        DB ROODARCA
                        DB ROODARC1
                        DB ROODARC2
                        DB ROODARC3
                        DB ROODARC4
                        DB ROODARC5
                        DB ROODARC6
                        DB ROODARC7
                        DB ROODARC8
                        DB ROODARC9
                        DB ROODAR10
                        DB 0
