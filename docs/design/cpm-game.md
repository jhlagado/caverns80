# Caverns80 CP/M architecture

> **Spoilers:** This development document discusses the map, puzzles, game rules, or solutions. Read it after playing if you want to discover the adventure yourself.

8 September 2026. Implementation contract grounded in the
[baseline assessment](../reports/cpm-baseline.md), with the implemented release
and remaining playability limits recorded below. The original acceptance
requirements remain in force; hosted delivery has its own verification gate.

## Player journey and ownership

The player boots Triptych's browser CP/M, enters `CAVERNS`, plays with ordinary
text commands, saves, and quits to the CP/M prompt. A later launch can restore
that save. Browser reload and downloaded/reimported media must preserve it.
The same COM must work through the native CP/M host.

Caverns80 contains the game, data, CP/M adapter, ATOM build and game tests.
Triptych consumes a pinned release and contains machine/browser integration
tests. Portable CP/M continues to provide the OS. No direct terminal ports,
custom reset vectors, browser API calls or Debug80 dependency belong in the
production game.

## Selected structure

Keep the existing assembly project and extract small, explicit boundaries as
needed. A new adventure engine or BASIC interpreter would add substantial work
without advancing the first playable release. A literal BASIC translation would
discard the author's revised gameplay. Reuse the current tables, text and
verified handlers, repairing defects against the intended rules.

| Boundary | Responsibility | Contract |
| --- | --- | --- |
| Game state | Room, objects, puzzle state, counters, random state | One initialized representation; no pointers in persisted state |
| Command parser | Bounded text to verb and up to two nouns | Case-insensitive input; documented alias and ambiguity precedence; no game mutation |
| Game rules | One command and state to new state and result | Explicit results: continue, death, restart, quit; no nested restart into an old turn |
| World data | Descriptions, exits, object metadata and conditions | Valid room/object indices; dynamic match distinct from blocked destination |
| Presentation | Text, wrapping, prompts and help | Complete prompt marks input readiness; gameplay independent of terminal width |
| CP/M adapter | Console, disk and process exit | BDOS calls with documented register contracts; no overwrite of OS memory |
| Save codec | Validated state to/from records | Validate a temporary candidate before replacing live state |

These are responsibility boundaries, not a requirement for a framework or a
file per row. Use ordinary subroutine calls. Document register/flag clobbers,
stack usage and results at each shared assembly entry point during implementation.

## Memory and toolchain

Build native ATOM source into `CAVERNS.COM`, loaded and entered at 0100h.
Replace asm80-specific includes/macros as required by the pinned ATOM version.
Use short native symbols or a descriptive debug-symbol ledger where required;
do not add a legacy assembler fallback.

Place code, immutable text/tables, writable state, input buffers, disk buffers
and an explicitly reserved stack within the supported transient program area.
Do not retain the old FF00h stack or write restart vectors. Select final addresses
after a measured build and comparison with every supported resident profile.
Report each memory account independently; a small COM does not prove stack safety.
Use at least a 16-bit turn counter with defined saturation or overflow behaviour.

Use a seeded pseudo-random generator with explicit state. Tests supply a seed or
controlled draws; interactive seeding is adapter work. Preserve design intent
for combat, but establish probabilities and maximum resource requirements with
tests before describing the game as balanced. Floating-point emulation is not
required for the proposed rules.

## Input and presentation

Use CP/M console services and a bounded line-input interface with CR completion,
backspace and deliberate overlength handling. An empty line returns to the
prompt. Quit returns safely to CP/M. General output should work as scrolling
text; optional ANSI clear-screen presentation must not be a gameplay dependency.
Reflow the historical fixed-width descriptions for the actual terminal, while
preserving their wording except for documented editorial improvements.

Proposed parser policy: preserve supported two-noun commands, provide useful
messages for missing tools, and reject genuinely ambiguous requests without
performing an arbitrary action. Record any change from current table-order
matching before implementation. Help must list only working player commands.
Stage shortcuts belong in development builds or harness fixtures.

## Playability improvements

John invited gameplay and development improvements on 8 September 2026, with
the 1982–1983 heritage retained. The following are design proposals for the
new implementation, not claims about features already working. Keep the
Viking setting, terse command interaction, exploration, object puzzles, humour
and danger. Improve the player's ability to understand and act on the world.

| Priority | Improvement | Player benefit and acceptance |
| --- | --- | --- |
| Required | Disk save/load with named slots and overwrite confirmation | The player can keep several points of progress; saving and cancelled overwrite do not advance time or damage an earlier save |
| Required | `N`, `S`, `E`, `W`, `I`, and familiar verb aliases | Common short forms perform the same action as their full commands; document the exact accepted forms |
| Required | Informational commands do not spend a turn | LOOK, INVENTORY, HELP, SCORE and save management neither consume candle time nor trigger a creature attack; advance time in one central action rule |
| Required | Helpful parser failures | Distinguish unknown words, absent targets and missing tools; failed parsing changes no state; give a working example without revealing a puzzle solution |
| Required | Consistent object references | An object named in a room description has a meaningful response to EXAMINE or a clear explanation of its scenery role |
| Required | Fair warnings and clues | Telegraph a visibly failing bridge, dimming candle and dangerous descent before commitment; every mandatory puzzle has an accessible clue |
| Required | Restart and quit confirmation | Accidental commands do not discard unsaved progress; EOF/control-input behaviour is documented and returns safely to CP/M |
| Required | Readable terminal text | Wrap prose at word boundaries, paginate long help, preserve typed-command editing and avoid erasing useful recent output on every turn |
| Playtest | EXAMINE/X and READ coverage | Short descriptions add actionable detail and atmosphere for significant objects and inscriptions; avoid padding every object with generic text |
| Playtest | More forgiving combat | Retain danger, but test a useful retreat path and understandable weapon requirements; avoid requiring repeated blind reloads to pass a mandatory fight |
| Playtest | Candle/resource pacing | A careful first-time player has room to explore; test a complete route with detours and failed physical actions, not only an optimal walkthrough |
| Playtest | Optional graduated hints | An explicit HINT command progresses from a nudge to a stronger clue; ordinary HELP stays spoiler-free |

Named slots use one to eight letters, digits or underscores, followed by the
fixed `.SAV` extension on the current CP/M drive. Drive prefixes and arbitrary
extensions are rejected. The default is `CAVERNS.SAV`. Save files describe game state, while downloaded disk images preserve the
whole CP/M session's files. Explain that distinction in the player guide.

Define successful actions, failed physical attempts and informational requests
separately. A failed physical action may consume time when it makes sense, but
the same rule must apply consistently. Being able to inspect a room safely
does not make escape or combat safe. Hostile encounters should advance on an
action, with a single explicit turn transition and no duplicate attack.

For irreversible puzzles, check whether losing a required object creates an
unwinnable state. Prefer a warning, a plausible recovery route or a clear ending
over many turns of undisclosed failure. Preserve intentional fatal choices and
discovery; do not disclose hidden exits automatically or mark every solution.
Replay tests should cover dropping tools, returning through changed passages,
and loading a save made before each permanent world change.

Defer a large natural-language parser, graphics, automatic mapping, quest markers,
an extensive undo system and new regions until the existing adventure is complete.
These are not needed for a strong first release. A deterministic test harness,
data validation and small assembly interfaces will improve development without
turning this game into a general-purpose adventure framework.

## Release disposition of playability proposals

Named recoverable saves, compass aliases, inventory aliases, free informational
commands, bounded line editing, 78-column wrapping and paged story/HELP are
implemented. The source is native ATOM with 8.3 module names and a 500-line
build limit. See the [player guide](../player-guide.md) for accepted commands.

EXAMINE/X has a 24-object description table and presence checks. Contextual READ
covers the crypt and castle inscriptions. The scenery and room-17 limits are
recorded below; the broader consistent-object-reference requirement is not
closed merely by the table's existence.

Combat retains risk. A carried sword is required, defeated opponents reset
fatigue, and the ordinary full route and alternate order complete with the
fixed initial seed. Four seeded stress runs exercise other histories. These
results do not establish every seed's solvability or replace retreat and
first-player balance review. The candle warns at turn 201 and expires at 230;
a route with physical detours and the complete 54-room tour finish while lit.
This establishes measured slack, not unlimited exploration time.

The parser retains deterministic table-order matching rather than a new
ambiguity resolver. Unknown input, absent objects and missing tools have
responses, but the proposed comprehensive ambiguity policy needs a separate
review. QUIT and RESTART use the existing “Another adventure?” prompt: yes
starts fresh and no exits to CP/M. This is an ending/restart choice, not a
cancel-and-resume confirmation for unsaved progress. Keep that distinction
visible when assessing the confirmation requirement.

Graduated HINT is deferred: no hint command is implemented, and the first
release uses contextual inscriptions and spoiler-free HELP. A larger parser,
graphics, automatic mapping, quest markers, undo and new regions remain deferred
to preserve the bounded first-release scope. These optional deferrals do not
waive required clue, input or persistence acceptance checks.

## Map legibility

John confirmed that simplifying the BASIC map was an intentional Caverns80
improvement. Prefer reversible east/west and north/south movement where the
described geography permits it. Fix unnecessary loops and confusing asymmetries;
preservation of the old map is not a reason to retain them. Keep deliberate
one-way routes, hazards and harmless deviations when the descriptions explain
the movement. Audit static and conditional exits separately, document changed
edges, and rerun full progression after each map revision.

## Persistent saves

The implemented default is `CAVERNS.SAV` on the current writable drive. Serialize a magic
identifier, format version, payload length, game-rules version, checksum and
complete gameplay state, including random state and combat/puzzle counters.
Define byte order and record padding. Derived descriptions and temporary parser
scratch need not be saved. Validate all indices and cross-field invariants.

Loading a missing, truncated, corrupt or incompatible save must leave the
current game unchanged and explain the problem. Loading before any save must
never deserialize uninitialized RAM. A round trip must preserve future outcomes
as well as the current room and inventory.

Save through a temporary file and verified close, with a backup/recovery protocol
for replacement. CP/M rename sequences are not automatically crash-atomic: the
implementation must define and test recovery from every intermediate disk state.
Disk-full, read-only, directory exhaustion and write/close failure must retain
a recoverable previous save and must not change live gameplay state.

Browser persistence is a separate layer: after the guest closes its save, verify
that Triptych commits the disk before declaring a reload-safe save. Follow the
existing saved-media flow for export/import and updates. Never silently replace
an existing user's system, game or save bytes on reopen.

## Verification and release boundary

The game harness executes assembled Z80 code and checks state, text, stack,
memory bounds and disk results. Scripted RNG makes puzzle/combat tests repeatable.
The BASIC supplies reference data and historical scenarios, not a byte-for-byte
behaviour oracle for revised rules.

Release assets include the COM, exact size/hash, source revision, pinned ATOM
identity, memory report and versioned save specification. Triptych's component
lock and provenance verification must select those exact assets. Fresh-disk
installation, native execution, WASM execution and real browser persistence are
separate acceptance gates. Final completion requires the published browser
release, not only a local host build.

## Magic words and inscription puzzles

The release uses VARD for the crypt and retains GALAR for return travel.
The old `CMDAPE` and `TOKENAPE` assembly labels remain internal names; the
player token is VARD. APE is no longer the advertised puzzle word.

In room 37, the description invites READ. READ or PRAY prints the keeper's
letters V, A, R, D in left-to-right order and explains that speaking the name
opens the eastern seal. VARD sets the dynamic eastern exit to room 38; it does
not move the player. The four carved stones are described scenery in one
inscription, rather than four new collectible objects. No knowledge of a real
historical language is needed.

In castle courtyard 50, the description contains `hzb tzozi`. READ or PRAY
supplies the mirrored-alphabet clue. Reversing the alphabet produces SAY GALAR.
GALAR returns to cave entrance 16 and resets sword fatigue. These commands do
not require a hidden “has read inscription” flag, so a returning player can use
the known words. Token matching accepts the bare word and SAY followed by it.

The [full route](../../test/support/full-route.mjs) reads both puzzle clues and
uses both words through ordinary commands. [Puzzle replay](../../test/puzzle-replay.test.mjs)
checks save/restore around every route action. The [54-room tour](../reports/room-matrix.md)
also uses GALAR after victory. Dedicated wrong-word and every-location repeat
partitions have not been established by those route tests; they remain separate
acceptance checks rather than inferred coverage.

READ in room 17 still returns “Nothing happens”, although LOOK displays its
Sacred Key inscription. The room-tour test proves that LOOK exposes that clue.
This is a known presentation inconsistency, not an inaccessible-room defect.
EXAMINE describes all 24 represented objects when present or carried; absent
objects are rejected. Unrecognized scenery falls through to contextual READ.
Consequently it inherits READ's limited room coverage. Executed checks confirm
EXAMINE STONES and X STONES show the crypt inscription; singular EXAMINE STONE
selects the collectible object and rejects it when absent. Broader scenery
handling and discovery testing remain explicit playability work.

## Automated game verification

John requested substantial automated testing so completing and checking the game
does not depend on repeated manual play. Implement this harness in M1 and extend
it with each region. Execute the actual ATOM-built COM through a development-only
Z80/CP/M adapter; do not certify a separate reimplementation of the game rules.
Reuse Triptych's headless WASM host and browser test infrastructure for consumer
proofs. Select the owner-repository runner during M1 based on deterministic
execution, register/memory access and bounded execution support.

Each scenario contains an initial state or fresh-game setup, a seed, ordinary
command lines and expected observations. At every completed turn, compare room,
inventory, puzzle flags, counters, random state and relevant output. Keep terminal
readiness explicit so tests cannot send the next command after only an early
fragment of a response. Failed runs retain the seed, command prefix, expected and
actual state, recent output, instruction/cycle totals and artifact identity.

Use short direct-state fixtures for isolated boundary tests, but require the
winning replay to start from a fresh game and acquire every prerequisite through
ordinary commands. Test fixtures and stage commands cannot substitute for this
proof. Maintain alternate valid routes and representative non-winning explorations.

| Test layer | Required observations |
| --- | --- |
| Data validation | Table sizes, valid room/object references, descriptor coverage, dynamic-exit records and deliberate terminal destinations |
| Parser/action scenarios | Aliases, missing tools, ambiguous/unknown input, inventory limits, repeated actions and rejected-action state preservation |
| Puzzle/encounter scenarios | Before/after state, all exits, irreversible changes, forced random success/failure boundaries, deaths and restart paths |
| Full-game replays | Fresh start to completion, intended maximum score, alternate ordering and a route with exploration detours |
| Save fault injection | Every write/close/replacement failure boundary, invalid format/ranges/checksum, recoverable prior save, unchanged live state |
| Invariant stress | Multiple seeded command sequences; valid indices, inventory consistency, stack canaries, bounded execution and no OS-memory writes |
| Cross-host acceptance | Same COM and scripted outcomes under native/WASM CP/M; real browser typing, save, reload and downloaded-media reopen |

Record code bytes, static data, workspace and maximum observed stack use separately.
Measure guest instructions and T-states per command independently of terminal
bytes and host elapsed time. Measure browser key/Enter-to-completed-prompt latency
on a named machine/browser; CPU results alone cannot establish visible speed.
Include long descriptions, inventory, combat, help, save/load and full-game replay.

Propose a warm ordinary-command browser response target of p95 under 100 ms on
the declared reference host. Establish guest-cycle budgets and separate save/load
budgets after the first working baseline; report all misses and worst cases.
This is a proposed target, not a measured claim or a guarantee for every device.
Keep deterministic cycle regressions as CI gates; use repeated host timing runs
to investigate changes without treating a noisy sample as a correctness failure.

Run fast data/parser/puzzle tests on each change and the full seeded route and
save-failure suite in CI. Run actual browser persistence and release-identity tests
before publication. Add a regression scenario for every corrected defect. Automated
coverage provides repeatable evidence for tested paths; John’s playthrough remains
necessary for atmosphere, clue quality and enjoyment.
