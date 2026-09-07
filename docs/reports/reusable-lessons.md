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

These are inspection-derived lessons. Add measured implementation, persistence,
performance and hosted-release lessons as their evidence becomes available.
