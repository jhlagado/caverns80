# Gameplay verification coverage

This report contains puzzle and ending spoilers. Caverns preserves John Hardy's 1982–1983 adventure heritage and his canonical Caverns80 revisions. Authorship and licensing remain governed by the repository's existing notices; these tests do not establish any rights to other adventure games or their text.

## Executed coverage

The assembled CAVERNS.COM is exercised through a deterministic Z80 runtime and a development BDOS adapter. Tests never substitute a JavaScript implementation of game rules.

- The fresh ordinary-command route acquires and deposits all ten treasures, consumes the bomb, reaches score126 and covers the troll, dragon, wizard, goblin and demon. It checks the bridge, key, rope descent, VARD, grille, waterfall passage, castle approach and oak door.
- Every command in that route is replayed across actual COM disk-save and load operations. Before/after state, random-generator state and replay narrative match the unsaved baseline. This includes both sides of irreversible transitions.
- An alternative order opens the oak door and defeats the demon before the first banking trip. A separate full route adds physical out-and-back explorations in the forest and riverbank, completing with the candle still lit.
- Informational detours before every full-route action leave action count, randomness and all route checkpoints unchanged.
- Four nonzero random seeds exercise720 bounded commands with valid-state, prompt, restart, stack-range and program-end canary checks.
- Static map verification requires ordinary compass reversibility, explicitly enumerates six puzzle-gated exceptions and proves all54 rooms reachable in the completed graph. This graph proof does not substitute for playing every room.
- The [ordinary-command world tour](../../test/world-tour.test.mjs) completes the winning route and physically visits the remaining rooms, covering all 54 with the candle lit. The [room matrix](room-matrix.md) gives each room and the post-victory route.
- Save tests cover corruption, validation, missing files, replacement, backup recovery and injected disk failures. Source-specific test files contain the exact partitions.

## Clue and scenery limits

The route reads the crypt and castle inscriptions and uses VARD and GALAR. The added room tour sees the Sacred Key inscription through LOOK in room 17; READ there still returns “Nothing happens”. All 24 represented objects have examination text, with presence checks, but contextual scenery falls through to READ. This does not prove meaningful responses for every noun mentioned in prose. The [architecture disposition](../design/cpm-game.md#release-disposition-of-playability-proposals) records remaining parser, confirmation and playability checks.

## Terminal control flow

The terminal-path test enumerates all current game-ending dispatches: fatal movement, exhausted sword combat, hostile creature attack, QUIT and RESTART. Each path is triggered three times with affirmative restart, checks pristine object state, zero turn count and identical waiting stack depth, then checks a negative response reaches BDOS warm boot with the expected stack. Ctrl-C is also exercised from ordinary input and the restart confirmation.

Death fixtures inject a room, sword-fatigue count or random seed to select the branch deterministically. They establish branch behaviour and stack safety, not ordinary-command reachability. The complete adventure routes start fresh and use player commands; they do not inject puzzle state.

## Explicit limits

The development BDOS adapter is not a real CP/M filesystem, physical terminal or WebAssembly browser. Real CP/M, browser delivery, persistence across browser restart and user disk preservation require their separate integration evidence. The complete winning routes use the default deterministic combat seed; bounded multi-seed stress does not prove victory for every seed. Four extra exploration turns demonstrate modest slack, not an exhaustive candle-budget guarantee for arbitrary exploration. The suite does not exhaust all command combinations, save interruption timings, combat histories or every room visitation sequence. No claim of a flaw-free game follows from these tests.

HyperDrive remains a separate future project. Reusable methods here are command replays, explicit map exceptions, versioned saves, deterministic randomness and terminal-path assertions; no HyperDrive implementation is included.
