# Caverns80 implementation and delivery status

> **Spoilers:** This report links development evidence and complete-game replays. The [player guide](../player-guide.md) contains the story and rules without solutions.

8 September 2026. Copyright 1982–83 John Hardy. Development began on the ZX81
in 1982; the Microbee release followed in 1983.

[Caverns is playable in published Triptych](https://jhlagado.github.io/triptych/).
Type `CAVERNS` at the CP/M prompt. The hosted v0.1.1 acceptance run completed
the adventure, saved, reloaded, exported and reimported its disk, and continued
playing. The [delivery acceptance record](delivery-acceptance.md) maps the
roadmap requirements to their evidence.

## Release identity

The published [v0.1.1 release](https://github.com/jhlagado/caverns80/releases/tag/v0.1.1)
comes from source `0a0a67fda6163fdad982be7d5d20031d2b151c4d`. CAVERNS.COM is
22,896 bytes with SHA-256
`6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.
Triptych revision `54bc6385f846233fc6430d9bd655857dd6ba86fd` consumes these
exact bytes. [Deployment 34146693090](https://github.com/jhlagado/triptych/actions/runs/34146693090)
succeeded. [Fetched catalog, COM and default-disk checks](evidence/hosted-assets-v011.json)
verify the published identities.

The native ATOM allocation is 0100h–5A70h exclusive, including the private
512-byte stack at 5870h–5A70h. The [memory account](memory-account.md) separates
5,198 instruction bytes, 16,614 immutable bytes, 572 workspace bytes and the
stack. There is no dynamic allocation. The [stack audit](cpm-stack.md) records
CP/M entry, balanced return paths and BDOS termination.

## Qualification

The owner suite has 58 passing tests, including full progression, alternate
puzzle order, save/restore replay, all-room travel, input, pagination, terminal
paths, corruption/failure handling and CPU regression limits. Owner and consumer
Linux checks passed; the consumer's complete local checks also passed. Native and WASM CP/M full-route proofs and real WASM CP/M full-media failure
proofs supplement the development BDOS harness.

[Coverage](coverage.md) and the [room matrix](room-matrix.md) distinguish ordinary
command progression from injected boundary fixtures. The winning route banks
all ten treasures for 126 points. The physical tour visits all 54 rooms with
the candle lit. Version 0.1.1 also tests voluntary cancellation without losing
state, rejection of cancellation after death, and READ at the dead-end inscription.

The [hosted full-game record](evidence/hosted-full-v011.json) proves 147 ordinary
route commands, victory, saving WEBWIN, page reload, restoration, disk export,
import into a fresh browser context and continued LOOK/SCORE at 126 points.
The [old-media upgrade record](evidence/hosted-upgrade-v011.json) proves byte-exact
reopening before explicit update, preservation of seven other files and
system tracks, loading the previous save and cancelling QUIT back into play.
These runs used isolated browser contexts and copies of media.

Hosted command-to-prompt p95 was 17.930 ms, maximum 18.830 ms, on Chromium
151.0.7922.34, Apple M2, Darwin 25.5.0. Separate HELP/SAVE/LOAD observations
were 84.472/18.440/17.383 ms; HELP includes automated page advancement.
These include automation overhead and are not physical-device guarantees.
The [performance report](performance.md)
keeps guest-cycle accounting separate from browser observations and retains
historical v0.1.0 measurements with their own identities.

## Reproduction and limits

Run the owner checks with `npm run check`. The [browser verification guide](browser-verification.md)
describes the maintained hosted proof and optional old-disk fixture. The
[architecture](../design/cpm-game.md) records command rules and bounded feature
choices. Tests establish the exercised paths, not every possible exploration,
combat seed or storage interruption. John's playthrough remains valuable for
atmosphere and clue quality. [HyperDrive lessons](reusable-lessons.md) are retained;
no HyperDrive implementation is included.
