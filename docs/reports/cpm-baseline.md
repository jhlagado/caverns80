# Caverns80 baseline for CP/M

> **Spoilers:** This development document discusses the map, puzzles, game rules, or solutions. Read it after playing if you want to discover the adventure yourself.

8 September 2026. Source inspected at `43f06d609562c958573fd71d36f9f962b78ed1ff`.
This is a source assessment, not an execution or completion certificate.

## Canonical direction

John Hardy confirmed that his intentional Caverns80 gameplay changes are
canonical. His aim is to improve the game, not reproduce every behaviour of the
1983 version. He reports playable progress through the bridge and just beyond
the cave entrance, with no subsequent progress. That is the current confirmed
extent; routines for later areas do not establish a completed adventure.

Use Caverns80 as the development baseline. Use the recovered MicroWorld BASIC
listing in the separate `caverns` repository for unfinished geography, story,
puzzles and historical context. Resolve contradictions in favour of the newer
intentional design. Programming defects, stale comments and test shortcuts do
not become gameplay rules merely because they occur in Caverns80 source.

The source repository remains independent of Triptych. This documentation goal
does not implement or publish the game. See the [architecture](../design/cpm-game.md)
and [delivery roadmap](../plans/cpm-roadmap.md).

## Evidence and implementation inventory

The recovered listing is at `projects/2025/caverns/src/caverns.basic`; the
assembly repository is `projects/2026/caverns80`. The former is MicroWorld BASIC,
with Microbee-specific display/input and control-flow syntax. No Microsoft BASIC
interpreter is required by the proposed port.

| Area | Source evidence | Established status |
| --- | --- | --- |
| World | `src/constants.asm`, `src/tables.asm` | 54 room IDs; four exits per room; 216-byte base movement table; seven dynamic exit records |
| Actors and objects | `objectLocation`, `objectLocationTable` | Six creatures and 18 objects share 24 location bytes; carried objects use the byte representation of -1 |
| Text | `src/strings.asm`, room description pointer tables | Later-game descriptions are present; narrative availability is not puzzle completion |
| Parser | `scanInputTokens`, `dispatchScannedCommand` in `src/game.asm` | 36 verb table entries; first matching verb in table order; up to two distinct noun matches in table order |
| Revised interactions | `cmdOpenCommon`, `cmdKillAttack`, `cmdLightBurnBombCommon`, `cmdDown` | Explicit tool/target handling, door/gate nouns, sword requirements, bomb/candle combination and rope descent are present |
| Convenience | `cmdHelp`, `cmdScore`, `cmdRead`, `cmdPray` | Help, score and contextual clue routines exist; retain the revised direction and test their actual outputs |
| Inventory | `doGetObjectIndex` | Ten-item limit is explicit; do not restore the BASIC off-by-one allowance |
| Encounters | `maybeBatCarry`, `maybeMonsterAttackOnMove`, `maybeMonsterAttack` | Revised attack ordering and exemptions exist; balance and terminal outcomes need execution proof |
| Later puzzles | `cmdApe`, `cmdGalar`, bomb and rope routines, dynamic exits | Source-present and unqualified beyond the author's reported extent |
| Saves | `cmdSave`, `cmdLoad` | RAM-only snapshot, with a concrete copy-direction defect; unsuitable for browser persistence |
| Test access | `cmdStage2` through `cmdStage5` | State-reset shortcuts to bridge, cave and castle areas; not ordinary progression evidence |
| Machine adapter | `src/system.asm`, `src/main.asm` | Custom reset vectors, terminal ports, entry at 0900h and stack at FF00h; not a CP/M COM application |
| Toolchain | README and source directives/macros | Historical asm80 build; native ATOM migration remains work |

No fresh assembly, gameplay run or complete-path test was performed for this
assessment. Existing ignored HEX/listing files are historical artifacts, not
release evidence. The working tree was clean before these documents were added.

## Concrete defects and qualification risks

These findings come from static source inspection. Reproduce them through the
new harness before applying fixes; preserve tests for the failure mechanism.

1. **Save copies in the wrong direction.** In `cmdSave`, HL advances through
   the snapshot header, DE is then set to `objectLocation`, and LDIR copies
   snapshot bytes into live object locations. `cmdLoad` uses that direction
   appropriately, but saving requires the reverse. A save must not mutate play.
2. **Turn count wraps.** `turnCounter` is a byte and `handleInputLine` increments
   it for every accepted nonempty input line. The candle thresholds are 200 and
   230. Long games need a wider counter and tests across 255; free informational
   commands are a design proposal, not an existing rule.
3. **Input is tied to the old host.** `readLn` ignores CR and terminates on LF.
   The main buffer is 32 bytes, permitting 31 characters, despite a separate
   80-byte padded parser buffer. Empty input exits through HALT. CP/M line entry,
   editing, overflow and clean quit need explicit contracts.
4. **Zero has two dynamic-exit meanings.** `resolveDynamicExit` returns zero for
   both no record and a zero-valued matching record; `doMove` falls back to the
   static table in either case. A blocked override cannot be expressed reliably
   wherever the static exit is open. Test match-present separately from destination.
5. **Initial bridge state alone is not a defect.** Although it starts at zero,
   static movement supplies the initial bridge destination. The earlier comparison
   with BASIC's initial value of 11 was insufficient to establish broken movement.
6. **Combat needs register and control-flow proofs.** In `cka_kill`, D initially
   holds the creature index but is overwritten by `LD DE,objectLocation` before
   another creature comparison. Also trace death/restart through callers so that
   no old command continues in a newly initialized game.
7. **Randomness and saves are incomplete contracts.** Refresh-register sampling
   is used in `RAND` and combat. Stated probabilities are not measurements. The
   snapshot omits combat counters and has no format, validity or checksum checks.

## Product decisions for implementation

Preserve the improved two-noun interactions, aliases, contextual clues and
ten-item inventory baseline. Record each further change with its player-visible
reason and a scenario. The precise combat balance, candle pacing, treatment of
failed commands, ambiguity handling and winning presentation remain proposed
design work. A full-score route must remain achievable under the final rules.

The first implementation milestone should demonstrate the author's existing
opening route on CP/M. Further rooms should be completed in connected regions,
with ordinary commands and prerequisite items, rather than certified through
stage shortcuts. Keep the original Viking setting and descriptive voice while
making instructions and failure messages consistent.
