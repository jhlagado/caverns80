# Caverns80 implementation and delivery status

> **Spoilers:** This development report names puzzle areas and completion criteria. The [player guide](../player-guide.md) contains the opening story and general rules without solutions.

8 September 2026. Copyright 1982–83 John Hardy. Development began on the ZX81
in 1982; the Microbee release followed in 1983.

The current game has passed a complete 126-point adventure in the development
harness and through actual native and WebAssembly CP/M hosts. These results
establish a playable route, not completion of every release requirement in the
[roadmap](../plans/cpm-roadmap.md). The upstream release is published; consumer
deployment and hosted-browser acceptance remain open.

## Evidence snapshot

The inspected final module check ran `npm run check`: native ATOM assembly and
50 tests passed, with no failures or skipped tests. The resulting COM is 22,726
bytes, loads at 0100h, and has SHA-256
`662445028d6c55d58f5497032853803d181e128082ed1f1264db1e010cd162e3`.
The ATOM revision is recorded by the [build tool](../../tools/build.mjs) in the
generated manifest, along with every source-file hash. These identities describe
this check; source changes require a new build and qualification.

The native-host result reports the full 126-point route, a disk save and a
subsequent CCP command. The WASM-host result reports 147 commands, 126 points,
state checks after each command, a completed-game save and return to CCP.
The paginated source revision is `c2926e2be370e574b80666ecbe6db5c459674fa5`.
A subsequent local Chromium run completed the same 147-command route for
126 points, traversed eight introduction pages, and verified reload/load.
Its command-to-prompt p95 was 18.74 ms. The hosted site still requires its own
full progression and persistence evidence, including export/import. See the [performance report](performance.md).

The [archived CPU samples](evidence/command-costs.json),
[WASM full-route proof](evidence/cpm-proof.json),
[full-media proof](evidence/save-failure-proof.json) and
[local browser record](evidence/browser-local.json) retain current qualification
results. The repeatable owners are [the CP/M proof](../../tools/prove-cpm.mjs)
and [the full-media proof](../../tools/prove-save-failures.mjs).

The complete allocation is 0100h–59C6h exclusive, including the reserved
512-byte stack at 57C6h–59C6h. There is no dynamic allocation. The
[stack audit](cpm-stack.md) records entry, stack ownership and CP/M termination.

The upstream [v0.1.0 release](https://github.com/jhlagado/caverns80/releases/tag/v0.1.0)
is published from the paginated source revision above. Triptych integration at
`a6a63d7` has passed the full local `npm run check`; its
[Linux run](https://github.com/jhlagado/triptych/actions/runs/34142439421)
passed. [Consumer PR 5](https://github.com/jhlagado/triptych/pull/5)
was merged at `1bce80ad60eaeb27ae019787ba659ab42282a84c`. The
[deployment run](https://github.com/jhlagado/triptych/actions/runs/34144053990)
is running. A merged pull request does not establish hosted delivery.

The later ordinary-command [54-room tour](room-matrix.md), in `058faa6`,
adds coverage without changing the released COM. Its branch
[Linux check](https://github.com/jhlagado/caverns80/actions/runs/34143150353)
passed; [upstream PR 4](https://github.com/jhlagado/caverns80/pull/4) has merged.
The 50-test count above identifies release qualification before that added test.

## Milestone matrix

| Requirement | Current evidence | Remaining acceptance work |
| --- | --- | --- |
| M1: native ATOM and CP/M entry/exit | [Build](../../tools/build.mjs), [runtime](../../src/system.asm), [startup](../../src/startup.asm), and passing host runs | The release revision is fixed; consumer checks validate the complete allocation against supported resident layouts. Hosted acceptance remains M3. |
| M1: ordinary opening route | [Opening tests](../../test/opening.test.mjs) cross the bridge and reach the cave candle without stage commands | Local browser full-route evidence exists; retain it with the qualified artifact. |
| M1: input and aliases | [Regression tests](../../test/regressions.test.mjs) cover overflow draining/rejection, backspace, empty input, pseudo-nouns, inventory aliases and save-slot command collisions | Review the complete command inventory against the player help; expand missing-tool and ambiguity cases where coverage is absent. |
| M1: state and stack safety | [Stress tests](../../test/stress.test.mjs) check room/object bounds, stack bounds and a canary beyond program storage; codec tests check balanced returns | [Terminal tests](../../test/terminal-paths.test.mjs) exercise every current ending dispatch repeatedly; preserve the separate resident-layout qualification. |
| M1: repeatable measurement | Earlier per-command CPU baseline and current local browser p95 18.74 ms | Current CPU samples are archived in the performance report; qualify the hosted browser separately. |
| M2: complete adventure | [Full-route test](../../test/full-route.test.mjs) banks every treasure for 126 points; native and WASM hosts also complete | [Coverage report](coverage.md) records route and ending coverage; the [room matrix](room-matrix.md) adds ordinary-command visits to all 54 rooms. Its test/report PR has merged. |
| M2: alternate order and replay | [Puzzle replay](../../test/puzzle-replay.test.mjs) replays every route action across save/restore and moves oak-door/demon puzzles earlier | Every full-route action is replayed across save/restore, including irreversible transitions. The tested alternate order is documented; other orders remain outside that proof. |
| M2: exploration and balance | Four seeded 180-command stress runs pass; the full route tolerates LOOK/HELP/LIST before every command | A physical out-and-back detour route also passes with its candle lit. Four extra turns establish modest slack; John's playthrough remains design feedback. |
| M2: long games and restart | Counter-crossing and seeded restart assertions pass | [Terminal tests](../../test/terminal-paths.test.mjs) enumerate all current ending dispatches with repeated restart and exit checks; branch fixtures do not prove natural reachability. |
| M2: save integrity | [Codec tests](../../test/save-codec.test.mjs) use an independent CRC oracle, reject every single-bit corruption and reject invalid fields without publication | Review cross-field invariants against reachable gameplay states whenever the rules change. |
| M2: save failure recovery | [Disk tests](../../test/save-disk.test.mjs) cover read-only slots/drives, rejected loads, before-effect faults and after-effect recovery in a fresh game process | Real WASM CP/M data-full and directory-full proofs pass. Power-loss durability and arbitrary interruption timing remain outside these proofs. |
| M2: story and rules | [Story/help tests](../../test/story-help.test.mjs), [text](../../src/strings.asm), and [player guide](../player-guide.md) cover the original narrative, revised commands and heritage | Keep text and command behaviour aligned through subsequent changes. |
| M2: map and clue revisions | [Map tests](../../test/map.test.mjs) check ordinary compass reversibility with documented puzzle exceptions; [map report](map-revisions.md) records changes | Audit every mandatory clue and classify generic scenery/stub responses. Completion alone does not prove that players can discover the solution. |
| M3: release and integration | v0.1.0 published; exact COM pinned in Triptych; owner Linux CI and full local consumer checks pass | Consumer Linux CI passed and the integration merged; deployment is running. |
| M3: browser persistence and publication | Local browser completion and reload/load established | Finish disk export/reimport, existing-media preservation and exact deployed-asset checks on the hosted site. |

[Pager tests](../../test/pager.test.mjs) cover the paginated introduction and
HELP. [pager.asm](../../src/pager.asm) contains the pager; host-only descriptive
symbol metadata lives in [tools/symbol-map.json](../../tools/symbol-map.json).

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

Finish deployment
and reconcile remaining clue/playability checks above. Preserve reproducible
transcripts and exact artifact identities with the final evidence. The [native full-route record](evidence/native-proof.json) identifies the
consumer revision, executable hashes, command route, saved score and subsequent
CCP command.

The final acceptance run must use the published browser site: complete the
adventure, save, return to CP/M, reload and continue, and export/reimport the
saved disk. Verify the downloaded artifact identities and preservation of
existing saved media. Only those results, together with the remaining roadmap
gates, can close the full delivery goal.

## Archived working evidence

The [CP/M full-route record](evidence/cpm-proof.json) identifies the COM and
actual WASM host binaries. The [real full-media proof](evidence/save-failure-proof.json)
records disk-data and directory exhaustion without injected BDOS failures.
The [local browser record](evidence/browser-local.json) records pagination,
147 commands, victory, save, page reload and restoration. These records support
the local qualification; they do not claim that the hosted site is updated.
