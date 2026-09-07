# Caverns80 implementation and delivery status

> **Spoilers:** This development report names puzzle areas and completion criteria. The [player guide](../player-guide.md) contains the opening story and general rules without solutions.

8 September 2026. Copyright 1982–83 John Hardy. Development began on the ZX81
in 1982; the Microbee release followed in 1983.

The current game has passed a complete 126-point adventure in the development
harness and through actual native and WebAssembly CP/M hosts. These results
establish a playable route, not completion of every release requirement in the
[roadmap](../plans/cpm-roadmap.md). Publication and hosted-browser acceptance
remain separate work.

## Evidence snapshot

The inspected final module check ran `npm run check`: native ATOM assembly and
39 tests passed, with no failures or skipped tests. The resulting COM is 21,233
bytes, loads at 0100h, and has SHA-256
`19f47683a6848d8438ae7dea602b2525034f1fee2fcfa3255e3104590244ad68`.
The ATOM revision is recorded by the [build tool](../../tools/build.mjs) in the
generated manifest, along with every source-file hash. These identities describe
this check; source changes require a new build and qualification.

The native-host result reports the full 126-point route, a disk save and a
subsequent CCP command. The WASM-host result reports 147 commands, 126 points,
state checks after each command, a completed-game save and return to CCP.
These are actual CP/M host runs. They do not establish browser page reload,
export/import persistence, or a published site's behaviour.

The coordinator's run logs for this snapshot are
`/tmp/caverns-final-module-check.log`, `/tmp/caverns-native-final.log` and
`/tmp/caverns-wasm-final.log`. They are temporary working evidence. Archive the
logs with the exact source revision, host identity, invocation and generated
artifacts before using them as release evidence.

## Milestone matrix

| Requirement | Current evidence | Remaining acceptance work |
| --- | --- | --- |
| M1: native ATOM and CP/M entry/exit | [Build](../../tools/build.mjs), [runtime](../../src/system.asm), [startup](../../src/startup.asm), and passing host runs | Freeze the release revision and report the complete allocation against every supported resident layout. |
| M1: ordinary opening route | [Opening tests](../../test/opening.test.mjs) cross the bridge and reach the cave candle without stage commands | Retain an actual browser launch/play/return transcript for the qualified build. |
| M1: input and aliases | [Regression tests](../../test/regressions.test.mjs) cover overflow draining/rejection, backspace, empty input, pseudo-nouns, inventory aliases and save-slot command collisions | Review the complete command inventory against the player help; expand missing-tool and ambiguity cases where coverage is absent. |
| M1: state and stack safety | [Stress tests](../../test/stress.test.mjs) check room/object bounds, stack bounds and a canary beyond program storage; codec tests check balanced returns | A bounds check at command completion is not an exhaustive stack-depth or resident-memory proof. Exercise each terminal path explicitly. |
| M1: repeatable measurement | Harness records instruction and cycle totals | Publish per-command CPU costs and a reference-host latency baseline; test the stated browser response target. |
| M2: complete adventure | [Full-route test](../../test/full-route.test.mjs) banks every treasure for 126 points; native and WASM hosts also complete | Produce the room/puzzle/death coverage matrix and account for intended regions outside the winning route. |
| M2: alternate order and replay | [Puzzle replay](../../test/puzzle-replay.test.mjs) replays every route action across save/restore and moves oak-door/demon puzzles earlier | Explicitly cover every irreversible puzzle boundary and additional meaningful alternate orders. |
| M2: exploration and balance | Four seeded 180-command stress runs pass; the full route tolerates LOOK/HELP/LIST before every command | Informational detours cost no turns. Add physical exploration detours and review candle/combat fairness; John's playthrough remains design feedback. |
| M2: long games and restart | Counter-crossing and seeded restart assertions pass | Enumerate and test every death/restart outcome and repeated terminal-path stack restoration. |
| M2: save integrity | [Codec tests](../../test/save-codec.test.mjs) use an independent CRC oracle, reject every single-bit corruption and reject invalid fields without publication | Review cross-field invariants against reachable gameplay states whenever the rules change. |
| M2: save failure recovery | [Disk tests](../../test/save-disk.test.mjs) cover read-only slots/drives, rejected loads, before-effect faults and after-effect recovery in a fresh game process | Confirm real CP/M disk-full/directory-exhaustion and interrupted replacement behaviour; harness faults do not prove durable-media crash atomicity. |
| M2: story and rules | [Story/help tests](../../test/story-help.test.mjs), [text](../../src/strings.asm), and [player guide](../player-guide.md) cover the original narrative, revised commands and heritage | Keep text and command behaviour aligned through subsequent changes. |
| M2: map and clue revisions | [Map tests](../../test/map.test.mjs) check ordinary compass reversibility with documented puzzle exceptions; [map report](map-revisions.md) records changes | Audit every mandatory clue and classify generic scenery/stub responses. Completion alone does not prove that players can discover the solution. |
| M3: release and integration | Local game and real-host development proofs exist | Publish an identified upstream artifact, update Triptych's component lock and provenance, and pass owner/consumer Linux CI and full consumer checks. |
| M3: browser persistence and publication | Not established by these logs | Verify real browser save/quit/relaunch/load, page reload, disk export/reimport, preservation of existing media, and the exact deployed assets on the hosted site. |

## Current source boundaries

The previous monolithic game body has been separated into ordinary assembly
modules. [Startup](../../src/startup.asm) handles the opening and session loop;
[parser](../../src/parser.asm) and [commands](../../src/commands.asm) handle
command recognition. [Actions](../../src/actions.asm),
[movement](../../src/movement.asm), [combat](../../src/combat.asm) and
[encounters](../../src/encountr.asm) contain the corresponding game rules.
[Room display](../../src/roomdisp.asm),
[objects](../../src/objects.asm), [inventory/input](../../src/invinput.asm)
and [scoring](../../src/scoring.asm) contain their named operations.

The [save codec](../../src/savecode.asm) validates records before publishing
state. The [disk layer](../../src/savedisk.asm) manages named primary, temporary
and backup files. Its recovery tests establish the tested file-operation
sequences; CP/M rename and browser persistence remain distinct mechanisms.
A recoverable backup is not a claim of atomic replacement under every possible
host or storage failure.

## Work needed before closing delivery

First finish the coverage, playability and performance evidence above, preserving
a reproducible command transcript for each failing scenario. Archive the exact
successful native and WASM proofs with the build manifest. Then qualify the
upstream release and consume that artifact in Triptych through its normal
release mechanism.

The final acceptance run must use the published browser site: complete the
adventure, save, return to CP/M, reload and continue, and export/reimport the
saved disk. Verify the downloaded artifact identities and preservation of
existing saved media. Only those results, together with the remaining roadmap
gates, can close the full delivery goal.
