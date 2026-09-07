# Caverns80: The 1982 Fantasy Adventure (Z80 Port)

Copyright 1982–83 John Hardy. Development began in 1982 for the Sinclair ZX81;
the Microbee version was released in 1983.

Z80 assembly port of the 1983 MicroWorld BASIC program in `docs/basic/caverns.mwb`
and related references.

[Read the spoiler-free player guide](docs/player-guide.md) for the story, commands,
and disk-save instructions.

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

## Build and test

Run `npm ci`, then `npm run check`. The build uses pinned native ATOM and creates
`build/CAVERNS.COM`, a manifest and development debug information. No source
translation or legacy assembler is required. All ASM filenames fit CP/M 8.3;
each module has at most 500 lines.

`src/` contains assembly input. `tools/` contains host build and verification
utilities, including the descriptive test-symbol map. `test/` runs the assembled
game. Generated files in `build/` and dependencies in `node_modules/` are ignored.
The recovered BASIC remains in `docs/basic/` as historical reference.

Run `npm run measure` after building for per-command cycle samples. With a built
Triptych checkout, run `TRIPTYCH_ROOT=/path/to/triptych node tools/prove-cpm.mjs`
for the complete CP/M WASM-host route on a private disk.

## Goal

Complete the revised Caverns80 adventure for CP/M and deliver it in Triptych's
WebAssembly browser system. John Hardy's intentional Caverns80 gameplay changes
are canonical; the recovered BASIC is a reference for unfinished content.
The current implementation completes a 126-point adventure in automated native
and WASM CP/M checks. Release integration and published-browser qualification
are tracked separately in the implementation report.

**Spoiler warning:** The source, automated full-game routes, and development
documents below reveal locations, puzzle solutions, and ways to complete the
adventure. They are retained for development and historical reference; players
who want to discover the game should avoid them until after playing.

The September 2026 documentation package contains:

- [Current implementation and gameplay baseline](docs/reports/cpm-baseline.md)
- [Proposed CP/M architecture](docs/design/cpm-game.md)
- [Delivery milestones and browser acceptance](docs/plans/cpm-roadmap.md)

- [Assembly module guide (spoilers)](docs/design/source-modules.md)
