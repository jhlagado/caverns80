# Assembly source modules

Copyright 1982–83 John Hardy.

> **Spoilers:** The assembly source and module descriptions discuss game mechanics and puzzle implementation. For instructions without solutions, read the [player guide](../player-guide.md).

All production assembly uses native ATOM syntax. `main.asm` establishes output order;
`game.asm` includes the game modules in order. All ASM filenames use CP/M 8.3 names. Each ASM file is limited to 500 lines
by the build so that individual modules remain convenient to read and edit in Edit.

| Module | Responsibility |
| --- | --- |
| startup.asm | CP/M entry, main command loop and initial state |
| roomdisp.asm | Room descriptions, darkness, candle warnings and visible objects |
| parser.asm | Input token scanning and command dispatch |
| actions.asm | General actions, help, quitting and opening passages |
| encountr.asm | Hostile encounters, bat movement and encounter messages |
| scoring.asm | Treasure scoring and decimal byte output |
| combat.asm | Inscription reading, sword combat and target selection |
| objects.asm | Taking and dropping objects, carrying limits |
| movement.asm | Compass travel, dynamic exits and light/bomb actions |
| invinput.asm | Inventory display and bounded console line input |
| examtext.asm | Object examination descriptions |
| commands.asm | Command aliases, file-command priority and examination |
| savecode.asm | Save format, validation, checksum and state transfer |
| savedisk.asm | CP/M disk replacement and recovery |
| system.asm | Console output, wrapping and random number generator |
| numbers.asm | Decimal word output |
| strings.asm, tables.asm | Text and world data |
| const.asm, vars.asm, prologue.asm | Constants, runtime allocation and COM origin |

The initial split preserves the previous byte order. Cross-module labels use the
same identifiers; it introduces no runtime calls or extra allocation. Build and
run the executable tests with `npm run check`.
