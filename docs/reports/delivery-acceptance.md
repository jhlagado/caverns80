# Caverns delivery acceptance

> **Spoilers:** This report links winning routes, puzzle tests and development evidence.
> Use the [player guide](../player-guide.md) to play without solutions.

Copyright 1982–83 John Hardy. This report assesses the original
[M1–M3 roadmap](../plans/cpm-roadmap.md), including the public browser delivery.
Version 0.1.1 is the final game artifact under qualification. Its upstream source
is `0a0a67fda6163fdad982be7d5d20031d2b151c4d`; its 22,896-byte `CAVERNS.COM`
has SHA-256 `6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.
Later test and documentation commits do not alter that executable.

## Requirement evidence

| Requirement | Authoritative evidence | Assessment |
| --- | --- | --- |
| M1.1: canonical opening interactions and handler inventory | [Opening tests](../../test/opening.test.mjs), [baseline](cpm-baseline.md), [coverage](coverage.md) | The ordinary route crosses the bridge and enters the cave with required tools. Unsupported historical verbs are explicitly classified. |
| M1.2: native ATOM, CP/M entry/exit and memory | [Build](../../tools/build.mjs), [stack audit](cpm-stack.md), [memory accounts](memory-account.md) | Entry 0100h, private 512-byte stack, BDOS exit, complete allocation below resident ceilings. All ASM filenames are 8.3 and modules at most 500 lines. |
| M1.3: terminal outcomes and stack restoration | [Terminal tests](../../test/terminal-paths.test.mjs), [cancellation tests](../../test/cancel-read.test.mjs) | Repeated death/restart/quit, voluntary cancellation and Ctrl-C preserve their required paths. Death cannot be cancelled. |
| M1.4: deterministic state and bounded input | [Regression tests](../../test/regressions.test.mjs), [stress tests](../../test/stress.test.mjs), [codec tests](../../test/save-codec.test.mjs) | RNG is explicit, turns are 16-bit with defined saturation, overflow is drained/rejected, aliases and item bounds are tested. |
| M1.5: private real-host integration | [Native record](evidence/native-proof-v011.json), [WASM record](evidence/cpm-proof-v011.json) | Both execute the full game, save the winning score and return to CP/M using private images. |
| M1.6: repeatable harness and costs | [Harness](../../test/support/machine.mjs), [CPU samples](evidence/command-costs-v011.json), [performance gate](../../test/performance.test.mjs) | The normal suite executes assembled code. Full-route, HELP, SAVE and LOAD costs have explicit regression ceilings. |
| M2: all regions and complete adventure | [Full route](../../test/support/full-route.mjs), [54-room tour](../../test/world-tour.test.mjs), [room matrix](room-matrix.md) | All 54 rooms are visited through real player commands; all ten scoring treasures yield 126 points. No STAGE shortcut is used. |
| M2: alternate order and irreversible puzzle replay | [Puzzle replay](../../test/puzzle-replay.test.mjs) | Every winning-route action is tested across save/restore; the oak-door/demon order is varied. |
| M2: exploration, danger and long games | [Terminal paths](../../test/terminal-paths.test.mjs), [stress](../../test/stress.test.mjs), [map revisions](map-revisions.md) | Fatal branches, repeated resets, counter boundaries, seeded histories and physical detours are covered. Ordinary compass asymmetries were reduced; deliberate puzzle exceptions are recorded. |
| M2: recoverable versioned saves | [Save codec](../../test/save-codec.test.mjs), [disk tests](../../test/save-disk.test.mjs), [real full-media failures](evidence/save-failure-proof-v011.json) | Invalid loads do not publish state. Named-slot overwrite/recovery, read-only media, disk/directory exhaustion and selected operation failures are tested. RNG and puzzle state survive reload. |
| M2: coherent clues and period presentation | [Magic words](../../test/magic-words.test.mjs), [examination](../../test/examine.test.mjs), [story](../../test/story-help.test.mjs), [pager](../../test/pager.test.mjs) | VARD/GALAR have contextual clues; READ exposes the key inscription. Story/rules and copyright are embedded; long text is paged for a 25-row terminal. |
| M2: proposed playability dispositions | [Design dispositions](../design/cpm-game.md#release-disposition-of-playability-proposals), [coverage](coverage.md) | Required implemented behavior is distinguished from optional hints, broader parser work and first-player balance feedback. No claim of universal enjoyment or every possible puzzle order is made. |
| M3: identified upstream artifact | [Release v0.1.1](https://github.com/jhlagado/caverns80/releases/tag/v0.1.1), [owner CI](https://github.com/jhlagado/caverns80/actions/runs/34144753343) | Downloaded published COM and manifest match the Linux CI artifact exactly. Licence and player guide accompany the release. |
| M3: exact consumer pin and full checks | [Triptych PR 6](https://github.com/jhlagado/triptych/pull/6), [consumer CI](https://github.com/jhlagado/triptych/actions/runs/34145233295) | Full local checks and Linux release/browser tests pass. Merged consumer revision is `54bc6385f846233fc6430d9bd655857dd6ba86fd`. |
| M3: fresh images and existing media | Consumer distribution/profile tests; local upgrade proof | Exact game records are installed in fresh supported images. Local reopening preserved every old disk byte; explicit update preserved system tracks, other files and the old save. Final hosted repetition remains pending below. |
| M3: actual hosted full progression and persistence | [First hosted full route](evidence/hosted-full-v010.json), [first hosted transfer](evidence/hosted-transfer-v010.json), [first hosted assets](evidence/hosted-assets-v010.json) | Version 0.1.0 is publicly verified. Repeat with the final 0.1.1 deployment before closing M3. |
| Future HyperDrive preparation | [Reusable lessons](reusable-lessons.md) | Engineering/gameplay/test lessons retained for Ken Stone's HyperDrive; no HyperDrive implementation included. |

## Remaining release gate

The [0.1.1 deployment](https://github.com/jhlagado/triptych/actions/runs/34146693090)
is running. Completion requires downloading the final hosted assets, repeating
full progression and save/reload/export/reimport, and explicitly upgrading the
older saved disk on that site. The playable URL is
[Triptych](https://jhlagado.github.io/triptych/); type `CAVERNS` at the CP/M prompt.

Power-loss atomicity, physical ESP32 timing and every possible random history
are outside these measured proofs. They are not silently claimed by passing
host tests. John can now supply first-player feedback on the canonical game.
