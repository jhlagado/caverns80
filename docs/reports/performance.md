# Caverns command-cost baseline

Copyright 1982–83 John Hardy.

> **Spoilers:** The raw measurement samples name commands from the complete winning route.

The earlier, pre-pagination 8 September 2026 build occupies 21,233 bytes from CP/M address 0100h through
53F0h. The end address is exclusive: 53F1h. This includes the reserved 512-byte
stack. Its SHA-256 is `19f47683a6848d8438ae7dea602b2525034f1fee2fcfa3255e3104590244ad68`.

Run `npm run build && npm run measure` to reproduce `build/command-costs.json`.
The report records every command, instruction count, cycle count and output size,
plus the exact executable hash. The workload completes the 147-command winning
route with the fixed initial random seed, then requests HELP.

| Workload | Emulated game cycles |
| --- | ---: |
| Winning-route median command | 196,066 |
| Winning-route 95th percentile command | 384,818 |
| Winning-route slowest command | 447,606 |
| HELP, including complete story and rules | 2,222,854 |

HELP emits 4,601 bytes. Its greater cost is expected from the complete story and
rules requested by the author; it does not consume a game turn. The different
workloads show that the measurement captures their different execution costs.

These counts include executed game instructions but exclude the test adapter's
BDOS operations, terminal transport, disk access, browser rendering and host
scheduling. Dividing by a nominal CPU frequency therefore gives only a game-code
estimate, not an end-to-end response time. No hardware timing is claimed. This is
a current-build baseline, not evidence of an improvement over an unmeasured
older implementation. The figures above remain a historical CPU baseline.
The paginated release measurements and their archived raw samples appear below.

## Version 0.1.0 paginated build and local browser

Revision `c2926e2be370e574b80666ecbe6db5c459674fa5` produces 22,726 bytes,
SHA-256 `662445028d6c55d58f5497032853803d181e128082ed1f1264db1e010cd162e3`.
The allocation is 0100h–59C6h exclusive, including the 512-byte stack.

One local Chromium run completed all 147 route commands and reached 126 points.
Eight introduction pages were traversed; human pager waiting is excluded from
the command samples. Enter-dispatch to observed-prompt wall time, including
automation overhead, was **18.74 ms at p95**, with a **26.22 ms maximum**.
The raw samples are archived in [the local browser record](evidence/browser-local.json).

This is a local browser observation, not physical display latency, an ESP32
measurement or a hosted-site result. The report does not identify a complete
reference-machine configuration, so retain that configuration with release
measurements before using this as a cross-machine comparison. No CPU-cycle
speedup follows from comparing these wall times with the historical CPU table.

## Version 0.1.0 release measurements

The v0.1.0 release's [raw CPU samples](evidence/command-costs.json) record
210,030 median, 397,268 95th-percentile and 466,871 maximum cycles across the
147-command winning route. HELP costs 2,760,948 emulated game cycles and emits
4,841 bytes, including pager prompts and erasure. These counts exclude waiting
for a human to advance a page and exclude BDOS execution. The increase over the
earlier baseline includes the pager's output accounting; it is not a speedup.

The [local browser samples](evidence/browser-local.json) record the complete
winning route, page reload and restoration of the winning save. Its measured
95th-percentile Enter-to-observed-prompt time was 18.74 ms, maximum 26.22 ms.
This includes Playwright observation overhead on the local macOS host and is
not a guarantee for other machines. Human typing and story-page pauses are
excluded from those command samples. This historical record precedes the
v0.1.1 hosted measurements below.

## Version 0.1.1 qualification

Release source `0a0a67fda6163fdad982be7d5d20031d2b151c4d` produces 22,896 bytes,
SHA-256 `6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.
The allocation ends at 5A70h exclusive, with a 512-byte stack at 5870h–5A70h.
The 170-byte increase adds voluntary cancellation, its explanation and the
room-17 READ path.

Fresh measurements retain 210,030 median, 397,268 p95 and 466,871 maximum guest
cycles across the 147-command route. HELP now costs 2,790,364 cycles and emits
4,894 bytes, an increase of 29,416 cycles and 53 bytes over v0.1.0. The extra
help explains cancellation. These measurements use the same exclusions as the
prior CPU measurements; the earlier 18.74 ms browser result remains v0.1.0
only. The v0.1.1 hosted measurements below identify their own environment.

## Automated CPU regression limits

`test/performance.test.mjs` executes the complete route and asserts guest-cycle
limits: route p95 500,000, maximum 600,000, HELP 3,500,000, SAVE 400,000 and
LOAD 600,000. These leave roughly 20–30% margin over the qualified v0.1.1
baseline and run in the normal test suite. They detect substantial regressions;
they are not claims about disk or terminal latency.

The separate v0.1.1 save/load samples are 309,832 and 462,506 guest cycles.
[Raw samples](evidence/command-costs-v011.json) identify the executable and
include the full route. BDOS adapter time, physical storage and rendering are
excluded. Hosted persistence tests cover the actual browser path separately.

## Published v0.1.1 browser result

The [hosted full-game proof](evidence/hosted-full-v011.json) ran against
Triptych `54bc6385f846233fc6430d9bd655857dd6ba86fd` on Chromium 151.0.7922.34,
Apple M2, arm64 Darwin 25.5.0. Across 147 route commands, Enter-to-completed-prompt
p95 was **17.930 ms**, maximum **18.830 ms**. This meets the proposed p95 under
100 ms target on that reference host. The samples include Playwright observation
overhead and exclude human typing and page-reading pauses.

The same run completed the 126-point adventure, saved, reloaded the page,
exported/reimported the disk in a fresh context and continued. Artifact checks
matched the release hash. One reference-host run does not guarantee latency on
other devices or establish a speedup over the differently situated local sample.

The same hosted run separately measured HELP at **84.472 ms**, SAVE at
**18.440 ms** and LOAD at **17.383 ms**. HELP includes automated pager
advancement; these auxiliary commands are excluded from the 147-command warm
route distribution. Sixteen page continuations occurred across startup, reload,
reimport and HELP. The record was observed at 2026-09-07 17:37:28.495 UTC.
These are automated browser observations, including scheduling and observation
overhead, not physical terminal or disk performance guarantees.
