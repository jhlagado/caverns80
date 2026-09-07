# Repository file audit

Copyright 1982–83 John Hardy. Inspected 8 September 2026.

> **Spoilers:** This development audit names game systems and puzzle-related tests. The player guide is safe to read before playing.

The assembly modules, verification tools and retained historical documents have
clear purposes. The main cleanup candidates are misplaced symbol metadata,
obsolete debugger settings, stale introductory instructions and old generated
artifacts. The initial audit recorded recommendations. The author subsequently approved
the cleanup; the applied changes are recorded below.

## Original audit: symbol-map purpose

`src/symbols.json` contains 628 descriptive-name-to-native-label mappings.
`tools/build.mjs` reads it after ATOM assembly and uses it to name entries in
`build/symbols.json`. The test machine reads that generated address map so tests
can refer to names such as `playerLocation` rather than abbreviated labels.
The assembly itself does not read the JSON and the game does not need it at
runtime. The map also does not translate assembly source or invoke AZM.

Nine entries no longer match a defined source symbol: `cmdLoad`, `cmdSave`,
`sso_ret`, `cmdStage2`, `cmdStage3`, `cmdStage4`, `cmdStage5`, `saveBlock` and
`saveBlockSize`. These are remnants of removed routines/storage. The current
builder silently ignores unmatched entries. The map covers far more labels than
the tests need; it is useful metadata, but its present size is not a requirement.

Recommendation: move it to `tools/symbol-map.json`, prune stale entries and make
the build validate mappings. Alternatively, tests could use native labels and
the map could disappear entirely. Moving and pruning preserves readable tests
with less disruption. Neither choice should change a single COM byte.

## Original inventory and disposition

The pre-cleanup non-generated project files are listed below. `node_modules` and Git
internal files are excluded from the source inventory and addressed separately.

| File | Justification and recommendation |
| --- | --- |
| `docs/reports/file-audit.md` | Keep. This file-by-file audit records ownership, purpose and cleanup recommendations. |
| `.github/workflows/check.yml` | Keep. Linux assembly/tests and artifact upload; not yet proof of a completed remote run. |
| `.gitignore` | Keep. Excludes generated artifacts, dependencies and macOS metadata. |
| `.vscode/debug80.json` | Remove or replace. Obsolete entry address 0 and port-console target do not describe the CP/M COM at 0100h. |
| `.vscode/launch.json` | Remove with its obsolete target, or replace after a real CP/M debugger launch is supported. |
| `LICENSE` | Keep. GPLv3 licence text; its FSF copyright covers the licence document, not authorship of Caverns. |
| `README.md` | Keep, revise. Historical narrative is useful, but current-build section incorrectly says ATOM conversion is unfinished and still advertises asm80 and macros. |
| `docs/basic/caverns.mwb` | Keep. Recovered original BASIC source, historical/content reference, not production input. Contains spoilers. |
| `docs/design/cpm-game.md` | Keep, update status. Architecture and gameplay decisions; distinguish proposals from implemented behaviour. |
| `docs/design/source-modules.md` | Keep, update for examtext.asm. Source navigation and 500-line/8.3 conventions. |
| `docs/plans/cpm-roadmap.md` | Keep, update milestone status. Full delivery acceptance contract, not evidence that every gate has passed. |
| `docs/player-guide.md` | Keep. Spoiler-free story, commands, copyright and save instructions. |
| `docs/reports/coverage.md` | Keep. Terminal-path and exploration coverage, including explicit limits of injected-state tests. |
| `docs/reports/cpm-baseline.md` | Keep as dated historical audit. Old filenames refer to the inspected baseline, not current modules. |
| `docs/reports/implementation-status.md` | Keep, refresh. Requirement/evidence matrix; its count and artifact snapshot predate the latest examination change. |
| `docs/reports/map-revisions.md` | Keep. Author-approved navigation changes and puzzle exceptions. |
| `docs/reports/performance.md` | Keep as identified baseline; add latest measurements. Its artifact hash deliberately identifies an earlier build. |
| `docs/reports/reusable-lessons.md` | Keep. Requested lessons for the later HyperDrive project. |
| `package-lock.json` | Keep. Reproducible dependency graph for npm ci and CI; not a game runtime dependency. |
| `package.json` | Keep. Host build, test and measurement commands; pinned development dependencies. Not shipped into CP/M. |
| `src/actions.asm` | Keep. General actions, HELP/story, quitting and passage opening. |
| `src/combat.asm` | Keep. Reading inscriptions, sword combat and target selection. |
| `src/commands.asm` | Keep. Short aliases, SAVE/LOAD priority and examination dispatch. |
| `src/const.asm` | Keep. Shared numeric contracts, object IDs and room IDs. |
| `src/encountr.asm` | Keep. Creature attacks, bat relocation and encounter helpers. |
| `src/examtext.asm` | Keep. Object examination table/text added for gameplay feedback. |
| `src/game.asm` | Keep. Small ordered game-module index; flattening would save little and obscure the group boundary. |
| `src/invinput.asm` | Keep. Inventory display and bounded line input. |
| `src/main.asm` | Keep. Native ATOM top-level inclusion order. |
| `src/movement.asm` | Keep. Compass movement, dynamic passages and light/bomb actions. |
| `src/numbers.asm` | Keep. Unsigned 16-bit decimal output for long-game turn counts. |
| `src/objects.asm` | Keep. Taking/dropping objects and carrying limits. |
| `src/parser.asm` | Keep. Token scanning and command dispatch. |
| `src/prologue.asm` | Keep. COM origin and entry jump; tiny but establishes a clear output boundary. |
| `src/roomdisp.asm` | Keep. Room visibility, descriptions, candle warnings and visible object listing. |
| `src/savecode.asm` | Keep. Save record encoding, checksum and validation before state publication. |
| `src/savedisk.asm` | Keep. CP/M file I/O, replacement, backup and recovery. |
| `src/scoring.asm` | Keep. Treasure score and decimal byte output. |
| `src/startup.asm` | Keep. Entry, initial state and command loop. |
| `src/strings.asm` | Keep. Story, rules, room descriptions and messages. |
| `src/symbols.json` | Move and prune. Human-name to ATOM-label map consumed by tools/build.mjs, then used through generated build/symbols.json by tests. Not assembly input. |
| `src/system.asm` | Keep. BDOS console adapter, wrapping and deterministic random generator. |
| `src/tables.asm` | Keep. Map, vocabulary, objects and dynamic-passage tables. |
| `src/vars.asm` | Keep. Mutable game state, buffers and reserved stack. |
| `test/combat-sword.test.mjs` | Keep. Sword possession versus merely mentioning the word. |
| `test/examine.test.mjs` | Keep. Useful present-object examination and no turn cost. |
| `test/full-route.test.mjs` | Keep. Ordinary-command winning route. |
| `test/map.test.mjs` | Keep. Destination bounds, reachability and reversible exits. |
| `test/numbers.test.mjs` | Keep. Byte and word decimal boundaries. |
| `test/opening.test.mjs` | Keep. Entry and canonical opening progression. |
| `test/puzzle-replay.test.mjs` | Keep. Save/restore around full-route actions and a different puzzle order. |
| `test/regressions.test.mjs` | Keep. Input, aliases, pseudo-nouns and specific repaired defects. |
| `test/save-codec.test.mjs` | Keep. Record corruption and state validation. |
| `test/save-disk.test.mjs` | Keep. Named files, replacement failures and recovery. |
| `test/story-help.test.mjs` | Keep. Complete original narrative, current rules and repeatable HELP. |
| `test/stress.test.mjs` | Keep. Seeded commands, bounds, stack guards and informational detours. |
| `test/support/full-route.mjs` | Keep. One executable ordinary winning route shared by tests and measurements; spoiler-bearing. |
| `test/support/machine.mjs` | Keep. Development-only CPU/BDOS adapter; does not enter the COM and does not substitute for real CP/M proofs. |
| `test/terminal-paths.test.mjs` | Keep. Death/restart/quit/Ctrl-C paths and physical exploration detours. |
| `test/wrapping.test.mjs` | Keep. Line width, composed output and register preservation. |
| `tools/build.mjs` | Keep, separate symbol-map concern. Uses ATOM, enforces source limits and emits COM/provenance/debug metadata. |
| `tools/prove-cpm.mjs` | Keep. Explicit external Triptych checkout proof using a private disk; records game/host identities and full progression. |
| `tools/measure.mjs` | Keep. Reproducible per-command cycle samples for the assembled game. |

## Local generated material and empty directories

| Path | Finding |
| --- | --- |
| build/CAVERNS.COM | Current assembled game. Keep as a generated/release artifact, not hand-maintained source. |
| build/manifest.json | Exact executable and source hashes. Keep with releases; regenerate after source changes. |
| build/CAVERNS.d8.json | Native ATOM debug information. Optional for players, useful for verification/debugging. |
| build/symbols.json | Generated descriptive address map consumed by the tests; distinct from the input map in src. |
| build/command-costs.json | Measurement output tied to a COM hash; regenerate for the final artifact. |
| build/main.hex, build/main.lst, build/main.d8dbg.json | Old build outputs, not referenced by the current build/test pipeline. Remove during generated-output cleanup. |
| node_modules/ | Reinstallable npm dependencies used only on the development host. Already ignored. |
| .DS_Store | macOS Finder metadata. No project purpose; already ignored. |
| src/build/, src/examples/ | Empty directory trees, with no production input. Remove if no local tooling still expects them. |
| .git/ | Repository history and local Git state; preserve. |

The old tracked names `src/constants.asm`, `src/variables.asm` and
`src/macros.asm` appear in Git's index but are absent from the current working
tree. The first two were replaced by `const.asm` and `vars.asm`; macros were
removed during the native ATOM migration. They are pending changes, not duplicate
live source files.

## Recommended cleanup order

1. Move and validate the symbol map, then prove identical COM bytes and passing tests.
2. Remove obsolete debugger launch settings rather than presenting an unverified CP/M setup.
3. Replace README build instructions with the actual ATOM commands and current qualification status.
4. Remove old generated outputs and empty source directories; keep historical BASIC and dated audits.
5. Refresh module links, coverage/status snapshots and measurements for the release artifact.

No source, tests, historical game material or licensing file needs wholesale
removal. The distinction to make clearer is between native assembly input,
host-side verification metadata and generated output.

## Applied cleanup

The symbol map now lives at `tools/symbol-map.json`; the nine stale mappings
were removed and the build rejects any future stale mapping. The obsolete
VS Code launch files, old generated HEX/listing/debug outputs, empty source
directories and Finder metadata were removed. README now documents the actual
ATOM build. The current paginated build passes 50 executable checks. The earlier inventory
above records why those changes were made.


## Current inventory additions and corrections

Inspected against paginated source `c2926e2be370e574b80666ecbe6db5c459674fa5`.
The earlier table is a record of cleanup decisions, not a list of files still
awaiting removal. The dated BASIC baseline report remains unchanged.

| Current file | Purpose and disposition |
| --- | --- |
| `tools/symbol-map.json` | Keep. Current validated descriptive-symbol metadata; replaces the removed `src/symbols.json`. |
| `src/pager.asm` | Keep. Paged story and HELP output. Native ATOM source with an 8.3 filename. |
| `test/pager.test.mjs` | Keep. Pager continuation, completion and state/stack tests. |
| `tools/prove-cpm.mjs` | Keep. Real native/WASM CP/M full-route and save proof through an explicitly selected Triptych checkout. |
| `tools/prove-save-failures.mjs` | Keep. Private real WASM CP/M data-full and directory-full fixtures; both pass for the current COM. The tool is committed with the release qualification reports. |

Generated `build/symbols.json` now derives from `tools/symbol-map.json`.
The current COM is 22,726 bytes with SHA-256
`662445028d6c55d58f5497032853803d181e128082ed1f1264db1e010cd162e3`.
Current CPU samples for that hash are retained in
`docs/reports/evidence/command-costs.json`; historical samples remain identified
by their own executable hashes.

## Qualification and coverage additions

These files extend the inventory without entering the CP/M executable:

| File | Purpose and disposition |
| --- | --- |
| `docs/reports/cpm-stack.md` | Keep. CP/M entry, private allocation, BDOS termination and measured stack evidence. |
| `docs/reports/room-matrix.md` | Keep with spoiler notice. All 54 ordinary-command room visits and explicit clue limitations. |
| `test/world-tour.test.mjs` | Keep. Fresh victory followed by physical exploration of every room, including bat displacement. |
| `docs/reports/evidence/command-costs.json` | Keep. Reproducible per-command CPU samples tied to the release hash. |
| `docs/reports/evidence/cpm-proof.json` | Keep. Real WASM CP/M full-route proof with executable and host identities. |
| `docs/reports/evidence/save-failure-proof.json` | Keep. Real CP/M data-full and directory-full save failures using private media. |
| `docs/reports/evidence/browser-local.json` | Keep. Local browser route and timing samples; hosted acceptance and complete reference-host identity remain separate. |

Evidence files record bounded observations; they are not production inputs.
Future hosted records should retain their site revision, game hash and browser
identity, so the evidence remains interpretable after another deployment.

## Version 0.1.1 additions

| File | Purpose and disposition |
| --- | --- |
| `test/cancel-read.test.mjs` | Keep. Voluntary cancellation preserves state and stack; death cannot cancel; READ exposes the room-17 inscription. |
| `test/magic-words.test.mjs` | Keep. Wrong/repeated words, bare/SAY forms and contextual crypt scenery. |
| `docs/reports/evidence/native-proof.json` | Keep. Native CP/M full progression, saved score and return-to-CCP evidence, identified by its recorded artifact hash. |

Version 0.1.1 source `0a0a67fda6163fdad982be7d5d20031d2b151c4d` passes 57
owner tests and produces a 22,896-byte COM with SHA-256
`6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.
Earlier inventory and measurement sections remain historical snapshots.

## Final measurement and hosted evidence additions

| File | Purpose and disposition |
| --- | --- |
| `test/performance.test.mjs` | Keep. Full-route and HELP/SAVE/LOAD guest-cycle budgets run in CI. |
| `tools/memory-account.mjs` | Keep. Derives disjoint code/data/workspace/stack accounts from native emitted extents and verifies the current source and COM hashes. |
| `docs/reports/memory-account.md` | Keep. Explains the measured memory partitions and buffer ownership. |
| `docs/reports/evidence/*-v011.json` | Keep. Version-specific CPU, memory, native, WASM and save-failure records retain exact identities without replacing historical evidence. |
| `docs/reports/evidence/hosted-*-v010.json` | Keep with the reports' spoiler context. Public website asset, full-game and disk-transfer proof for the first deployed release. |

The current normal suite contains 58 tests after adding the CPU regression gate;
the published v0.1.1 source release was qualified with 57 tests. This later test
and reporting work does not alter the executable.

| Final file | Purpose and disposition |
| --- | --- |
| `tools/prove-browser.mjs` | Keep. Repeatable exact-asset, full-game, persistence and optional old-disk upgrade proof using isolated browser contexts. |
| `docs/reports/browser-verification.md` | Keep with spoiler warning. Documents the maintained browser proof and its required fixtures. |
| `docs/reports/delivery-acceptance.md` | Keep with spoiler warning. Maps each original milestone to authoritative evidence and the outstanding final hosted gate. |
