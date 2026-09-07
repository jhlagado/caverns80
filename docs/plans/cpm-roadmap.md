# Caverns80 roadmap to playable browser CP/M

> **Spoilers:** This development document discusses the map, puzzles, game rules, or solutions. Read it after playing if you want to discover the adventure yourself.

8 September 2026. This roadmap retains the delivery acceptance criteria.
Implementation and local qualification have progressed through M1 and M2;
M3 remains open until the published browser passes the hosted acceptance run.
The [baseline](../reports/cpm-baseline.md) records source evidence and
the author's confirmed progress. The [architecture](../design/cpm-game.md) defines
the proposed CP/M and save boundaries.

## Outcome and scope

Deliver a complete Caverns80 adventure that John can play in Triptych's published
WebAssembly CP/M system, with the revised gameplay, working puzzles, recoverable
disk saves and a safe return to CP/M. Preserve the original setting and the
author's improvements. The retained 54-room world is the content baseline;
intentional changes to rooms, scoring or puzzle dependencies require a recorded
design reason, not accidental omission.

The documentation milestone is M0. Implementation follows M1 → M2 → M3.
Each milestone leaves a playable build and evidence for the next stage. Scheduling
should be estimated after the first ATOM build and opening-route tests; current
source volume does not establish remaining effort.

## Current delivery status

The upstream [v0.1.1 release](https://github.com/jhlagado/caverns80/releases/tag/v0.1.1)
is published from `0a0a67fda6163fdad982be7d5d20031d2b151c4d`. Its
22,896-byte COM has SHA-256
`6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.
All 57 owner tests and Linux CI pass. The [implementation report](../reports/implementation-status.md)
links complete adventure, saves, memory and performance evidence. The
[room tour](../reports/room-matrix.md) establishes visits to all 54 rooms.

The earlier v0.1.0 consumer integration passed checks and merged in PR 5;
its deployment run is in browser verification at this snapshot. The v0.1.1
update at `26ad80f` is under checks in
[consumer PR 6](https://github.com/jhlagado/triptych/pull/6). Hosted full progression,
persistence, media preservation and downloaded-asset identity checks remain
M3 acceptance work for the qualified final version.

## M0 — Establish the baseline

Deliver the three linked documents, distinguish source-present routines from
proven play, record canonical authority and identify concrete technical risks.
Check source references and document links. This gate establishes a development
plan; execution coverage remains an explicit M1 task.

Status: baseline documentation was prepared on 8 September 2026 before the
implementation. Its source observations remain a dated historical record.

## M1 — Play the opening in CP/M

**Result:** launch `CAVERNS.COM` in native and local browser CP/M and play from
the hut through the bridge to just beyond the cave entrance using ordinary
commands. This is the first implementation goal.

1. Inventory all handlers and map the opening route, prerequisites and revised
   interactions into executable scenarios. Preserve evidence of defects before
   repairing them. Record intended command/turn semantics separately from bugs.
2. Convert to native ATOM; implement the CP/M console/entry/exit layer and measured
   memory layout. Replace HALT termination and the custom port/vector runtime.
3. Make command outcomes explicit so death, restart and quit cannot resume stale
   commands. Correct proven register/state defects in opening-route handlers.
4. Establish reproducible RNG, long-game counter behaviour and bounded input.
   Test ordinary commands, aliases, missing tools, unknown input and item limits.
5. Load a development artifact into private fresh Triptych images. Keep this
   identified as development integration, separate from a pinned release.
6. Establish the [automated verification harness](../design/cpm-game.md#automated-game-verification),
   CI entry points, deterministic replay format and per-command cycle/latency
   baseline. Tests must execute the assembled game and retain reproducible failures.

**Exit evidence:** reproducible ATOM COM and memory report; scripted opening-route
transcript and state assertions; no stage commands; repeated restart/quit without
stack drift; CR/backspace/empty/overlength cases; native and browser launch/play/
return; no resident-memory corruption. A failing intended route blocks the gate.

## M2 — Complete and qualify the adventure

**Result:** every intended region and puzzle works in a full game, with disk saves.

Develop in connected slices: cave/treasure access, temple/crypt and rope route,
drainage/river network, castle/bomb/escape route, then return and final scoring.
For each slice, inventory room exits, prerequisites, consumed items, permanent
changes, clues, deaths and recovery routes. The geography is present in the
sources; its dependencies and solvability must be demonstrated.

Retain revised tool/target interactions. Complete or deliberately classify generic
stub responses. Review combat and candle pacing against ordinary exploration;
apply the [playability improvements](../design/cpm-game.md#playability-improvements),
including free informational commands, parser feedback and named disk saves.
Failed physical actions need a consistent turn-cost rule. Produce
player help without spoilers and a separate maintainer walkthrough with spoilers.
The COM includes the original introductory story and current rules at startup,
with HELP available to read them again. Credit Copyright 1982–83 John Hardy:
development began for the ZX81 in 1982 and the Microbee release followed in 1983.
Keep INVENT, INVENTORY, I and LIST as equivalent inventory commands. Label
solution-bearing development documents and links clearly as spoilers.

Revise the [magic-word clue chains](../design/cpm-game.md#magic-words-and-inscription-puzzles)
as part of the crypt/castle slices. Select final names and inscriptions, preserve
discovery through readable clues, and test both puzzle effects and replay use.

Maintain a playtest checklist alongside the room/puzzle matrix: every mandatory
puzzle is clued, descriptions refer to examinable objects or explained scenery,
irreversible losses have deliberate consequences, and required fights are
practical without repeated blind reloads. Complete one run with exploration
detours as well as the shortest known solution. Record which optional proposals
were retained, revised or deferred and why. John's playthrough supplies design
feedback; automated completion alone cannot establish that the game is enjoyable.

Implement versioned disk saves with complete state and controlled RNG replay.
Test failed replacement and corrupt-load recovery. Keep test-stage access out of
the player release and exercise all progression through real commands.

**Exit evidence:** room/puzzle coverage matrix; reachable intended regions;
full winning or maximum-score route from fresh state without cheats; alternate
puzzle order and replay tests; all death/restart outcomes; runs beyond 255 turns;
save/load before and after each irreversible puzzle; disk-full/read-only/corrupt/
missing-save tests; zero live-state mutation on rejected loads or failed saves.
If the retained score target is 126, demonstrate it rather than assuming the
BASIC's target remains achievable under new rules.

The complete route, alternate-order routes, save-failure tests and bounded seeded
stress runs are automated release gates. Compare command costs with M1, publish
regressions as well as improvements, and test the proposed browser response target
on the declared reference host. A quick boot or a single manual win is insufficient.

## M3 — Publish and play in Triptych

**Result:** John can open the published Triptych site and play the complete game.

The upstream owner is Caverns80; the consumer is Triptych. First qualify and
publish an identified Caverns80 release. Then update Triptych's component lock,
verified assets and provenance through its existing release-input mechanism.
Use the current component contract at implementation time; the Edit integration
is an example, not a dependency on an arbitrary sibling build.

Install the game in fresh supported images and provide a clear launch instruction.
Verify the entire application allocation against each supported resident layout.
Run full owner checks, Triptych checks and Linux CI. Build and publish the exact
qualified browser distribution through Triptych's existing release process.

**Exit evidence:**

- Immutable upstream and consumer revisions, artifact hashes, licences, passing
  checks and release manifests.
- Extracted game bytes in each fresh image match the qualified COM; unrelated
  files and system regions retain their required identities.
- Real browser run from boot to opening play, late-game play and completion;
  maintainer full-route replay proves that stage shortcuts are unnecessary.
- Save, quit, relaunch, load, reload the page, then continue with the same state;
  download and reimport the disk into a fresh browser session and continue again.
- Reopening existing saved media preserves its bytes. A game update uses the
  established explicit backup/update flow and retains compatible saves or gives
  a clear compatibility result before any replacement.
- Fetch the published release and verify asset identities. Repeat launch/save/
  reload on the actual hosted site. Supply its playable URL and a short player
  guide. A passing local browser run alone does not close M3.

## Decision and risk register

| Issue | Default direction | Resolution gate |
| --- | --- | --- |
| Original versus revised behaviour | Author's intentional Caverns80 changes take precedence | M1 scenario inventory; never use BASIC parity to erase improvements |
| Unfinished areas | Reuse historical content and complete coherent routes | M2 coverage and full-route proof |
| Parser ambiguity | Preserve useful two-noun commands; specify deterministic responses | M1 command contract; broader polish M2 |
| Combat/candle fairness | Preserve intent, measure outcomes, document balancing changes | M2 ordinary-play and seeded tests |
| Save replacement failure | Versioned state plus tested temporary/backup recovery | M2 fault-injection evidence |
| Release timing | Upstream qualification precedes consumer pinning and deployment | M3 exact-artifact provenance |
| Existing browser disks | Preservation on reopen; explicit installation/update path | M3 fresh-versus-saved tests |

Next task: finish consumer CI and deployment, then run the M3 acceptance
sequence against the actual published website. Reconcile each remaining
requirement in the implementation report before closing delivery.
