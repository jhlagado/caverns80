# Caverns80: The 1982 Fantasy Adventure (Z80 Port)

Z80 assembly port of the 1983 MicroWorld BASIC program in `docs/basic/caverns.mwb`
and related references.

## A Microbee Classic

Caverns is a fantasy text adventure written by John Hardy in 1982 and released
in 1983, the same year as the TEC-1. It began on the Sinclair ZX81 with a 16K
expansion, was co-ported with Ken Stone to the VIC-20, and then reworked for
the Microbee where it reached its most complete form.

The program is classic 1980s BASIC: sprawling, direct, and ambitious for its
era. It remains one of the most detailed early Australian text adventures for
the Microbee.

## Recovery Note

The source listing was lost for decades and survived only in hobbyist
collections. It was preserved through the Microbee Software Preservation
Project, with Alan Laughton (aka ChickenMan) providing guidance and access to
the original files. The recovered listing is released here under the GNU Public
License, reflecting the 2019 release note embedded in the BASIC program.

## The Premise (From the Intro)

The intro frames Caverns as a Viking quest in the northern wastes of Norway.
Long ago the Great Sons of Svartalfheim built a subterranean empire of mines
and treasure. After the King of the Danes sacked their city, the elves perished
and the location of their hoard faded into myth. Centuries later, rumors of a
hidden cave and a green serpent reignite the legend. You arrive in Iotunheim,
standing in a small hut at the edge of the forest, with a single goal: find the
lost treasure of Svartalfheim.

## What the Game Feels Like

Caverns is a map-heavy adventure of forests, cliffs, rivers, and tunnels that
lead into the underworld. The game trades on hazards and folklore: trolls and
wizards, a fire-breathing dragon, a giant bat colony, and a temple devoted to
Loki. Progress depends on careful exploration, inventory management, and
bringing treasure back to the hut to raise your score.

## What You Will Find Here (Minimal)

- `src/` — the Z80 assembly source, including macros, tables, and game logic.
- `docs/basic/caverns.mwb` — the original MicroWorld BASIC listing used as the
  primary reference.
- `.vscode/` — Debug80 configuration for VS Code (optional; can be regenerated).
- `build/` — build artifacts (ignored by git).

## Build (asm80)

This project assembles with asm80 and does not depend on Debug80 for building.

```bash
npm i -g asm80
mkdir -p build
asm80 -m Z80 -t hex -o build/main src/main.asm
```

That produces `build/main.hex` and `build/main.lst`.

## Goal

Translate the original Caverns BASIC program into structured Z80 assembly while
preserving gameplay behavior and documenting differences or discoveries when
needed.
