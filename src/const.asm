; ASCII helpers
CR          EQU $0D
LF          EQU $0A
ESC         EQU $1B
NULL        EQU 0

; ---------------------------------------------------------
;  Constants for Caverns
; ---------------------------------------------------------

; Exit codes
EXITNONE        equ 0
EXIFAT       equ 128

; Common byte values / sentinels
BYTEZERO           equ 0
ROOCAR        equ 255         ; int8 sentinel in objectLocation[] meaning “carried”
BOOLTRUE           equ 1

; Turn thresholds for candle
CANDIMTU  equ 200
CANOUTTU  equ 230

; Direction indices
DIRNORTH        equ 0
DIRSOUTH        equ 1
DIRWEST         equ 2
DIREAST         equ 3

; Direction counts
DIRCOUNT        equ 4

; Dynamic exit patching (updateDynamicExits)
DYNEXIPA equ 7

; Verb indices come from `verbTokenTable` (see `examples/Caverns/src/tables.asm`).
; The parser scans for space-padded tokens like " kill " in a space-padded input buffer.

; Random fight message ids
FIGMSGMO      equ 0
FIGMSGDE   equ 1
FIGMSGST      equ 2
FIGMSGHE  equ 3

; Score thresholds
RANHOP equ 20
RANLOS    equ 50
RANAVE  equ 100
RANPER  equ 126

; Room ID constants (1..54)
ROODARRO             equ 1
ROOFORCL       equ 2
ROODARFO           equ 3
ROOCLOFI          equ 4
ROORIVCL           equ 5
ROORIVBA            equ 6
ROOCRAED           equ 7
ROORIVOU         equ 8
ROOMTYMI         equ 9
ROOBRINO   equ 10
ROOBRIMI            equ 11
ROOBRISO   equ 12
ROOMUSRO         equ 13
ROOCAVEN equ 14
ROOCLIFA            equ 15
ROOCAVE1            equ 16
ROODEAEN  equ 17
ROODARCA         equ 18
ROOTRERO         equ 19
ROOOAKDO              equ 20
ROODARC1         equ 21
ROOWINCO         equ 22
ROOTORCH       equ 23
ROONORSO    equ 24
ROODARC2         equ 25
ROOROURO            equ 26
ROOLEDOV      equ 27
ROOTEMBA        equ 28
ROODARC3         equ 29
ROODARC4         equ 30
ROODARC5         equ 31
ROODARC6         equ 32
ROOBATCA              equ 33
ROODARC7         equ 34
ROOTEM                equ 35
ROODARC8         equ 36
ROOCRY                 equ 37
ROOTINCE             equ 38
ROODARC9         equ 39
ROOLEDWA    equ 40
ROODRAA               equ 41
ROODRAB               equ 42
ROODRAC               equ 43
ROODRAD               equ 44
ROOWATBA        equ 45
ROODAR10         equ 46
ROOSTOST       equ 47
ROOCASLE          equ 48
ROODRA            equ 49
ROOCASCO      equ 50
ROOPOWMA            equ 51
ROOEASRI        equ 52
ROOWOOBR         equ 53
ROORIVCO         equ 54

; Index map (1..24)
; Creatures occupy indices 1..6, objects occupy indices 7..24.
; This matches the original BASIC (single P(1..24) array).

; Creature indices (1..6) (use obj* names because they share index space)
OBJWIZ   equ 1
OBJDEMON    equ 2
OBJTROLL    equ 3
OBJDRA   equ 4
OBJBAT      equ 5
OBJGOB   equ 6
OBJCRECO equ 6

; Object indices (7..24)
OBJCOIN     equ 7
OBJCOM  equ 8
OBJBOMB     equ 9
OBJRUBY     equ 10
OBJDIA  equ 11
OBJPEARL    equ 12
OBJSTONE    equ 13
OBJRING     equ 14
OBJPEN  equ 15
OBJGRAIL    equ 16
OBJSHI   equ 17
OBJBOX      equ 18
OBJKEY      equ 19
OBJSWORD    equ 20
OBJCAN   equ 21
OBJROPE     equ 22
OBJBRICK    equ 23
OBJGRILL    equ 24

MAXCARIT      equ 10


ROOMMAX     equ 54
OBJCOU equ 24
MOVTABBY equ ROOMMAX*4

; Input buffer sizing
INPBUFSI equ 80        ; characters incl. padding/terminator

; Extended noun token indices (not part of objectLocation[])
NOUNDOOR equ 25
NOUNGATE equ 26
NOUTOKCO equ 26          ; nouns scanned from nounTokenTable

; Save/load block size (bytes)
; playerLocation + candleIsLitFlag + turnCounter + 6 state bytes + 24 objectLocation

; Object index ranges
FIROBJIN equ 7
LASOBJIN  equ OBJCOU
OBJITECO  equ OBJCOU-OBJCRECO

; Score calculation range (objects 7..17)
FIRSCOOB equ 7
LASSCOOB  equ 17
AFTLASSC equ 18
SCOINDBA     equ 6

; Creature relocation offsets
BATRELOF     equ 7
CORRELOF  equ 10

; Sword combat tuning (current approximation)
SWOFIGBA equ 15

; Sword kill chance: pseudo2 uses `RND < .38`
; Using an 8-bit threshold: kill if randByte < 97  (~0.379)
SWOKILCH equ 97
