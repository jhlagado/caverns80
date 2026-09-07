# Lessons for the later HyperDrive project

> **Spoilers:** This development document discusses the map, puzzles, game rules, or solutions. Read it after playing if you want to discover the adventure yourself.

This record accompanies Caverns development. John requested that useful lessons
be applied to HyperDrive, which he credits to Ken Stone, after Caverns is complete.
No HyperDrive implementation is part of this release.

## Source assessment

An unfinished assembly port can contain late-game descriptions and handlers
without a playable route to those areas. Inventory ordinary-command progression
and state transitions separately from source coverage. Preserve intentional
author revisions instead of treating historical BASIC as an overriding oracle.

## Assembly interfaces

Room-list rendering in the Caverns source exposed shared-register risks: loop
counts, location pointers and creature identities remain live across text calls.
Document preservation contracts and test state as well as printed output.
A save/load pair also needs directional tests: saving must not mutate live state,
and loading must validate temporary state before publication.

## Testing direction

Keep a fresh-start walkthrough that uses the released program and ordinary
commands. Direct-state fixtures are useful for failures and boundaries, but
cannot establish that prerequisite items and puzzle transitions are reachable.
Record random seeds and command prefixes with each failure so a future repair
can reproduce the same encounter.

## Measured implementation lessons

The [native ATOM release](implementation-status.md) occupies 22,726 bytes,
including its private 512-byte stack. CP/M entry at 0100h and BDOS function 0
termination work without retaining a foreign runtime's stack convention.
Keep the entire allocation in the manifest: checking only code size would omit
state, disk buffers and stack. The [stack audit](cpm-stack.md) separates the
reserved size from observed use; a short run's high-water mark is not a universal
bound.

The [54-room tour](room-matrix.md) starts with an ordinary winning route and
visits the remaining rooms physically. This is stronger room-access evidence
than graph reachability, while still leaving untried exits and puzzle orders.
For HyperDrive, retain both static map checks and player-command progression.
Classify deliberate one-way movement rather than forcing every edge into a
reciprocal pair.

## Saves and media

[Puzzle replay](../../test/puzzle-replay.test.mjs) saves and restores around every
full-route action, comparing future state and narrative as well as the current
room. Persist the RNG alongside puzzle flags; otherwise a restored command can
produce a different encounter and make regressions difficult to reproduce.

[Real CP/M full-media tests](evidence/save-failure-proof.json) exhaust both disk
space and directory entries. They complement injected write/close/rename faults:
one exercises the operating system, the other selects precise failure boundaries.
Keep temporary, primary and backup recovery states explicit. Neither proof makes
CP/M rename power-loss atomic, and browser disk persistence needs separate tests.

## Presentation and performance

The 25-row terminal required pagination for the complete introduction and HELP.
Pager state is presentation state, so continuing or skipping text must leave
turns, randomness and saved gameplay unchanged. Tests should wait for the complete
command prompt and explicitly advance page prompts; an early output fragment is
not proof that input is ready.

The [release measurements](performance.md) record 397,268 guest cycles at the
95th percentile for ordinary route commands, and 18.74 ms Enter-to-observed-prompt
p95 in one local Chromium run. Those measure different costs. Guest cycles exclude
BDOS and rendering; browser observations include automation overhead. Pagination
increased guest work, so the report retains the regression rather than presenting
all refactoring as a speedup. Record host and artifact identities before using
such samples for future comparisons.

## Release boundary

The upstream COM release and the browser site's deployment are separate outcomes.
Triptych consumes an exact hash and provenance record; tests of a sibling checkout
do not prove what a player downloads. Hosted progression, save/reload and fresh-session
export/import remain acceptance work at this snapshot. For HyperDrive, schedule
those checks as delivery work and supply the playable website link explicitly.
Preserve existing user disks through the consumer's explicit update flow.
