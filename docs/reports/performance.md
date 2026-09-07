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
older implementation. The figures above remain a historical CPU baseline; they are not attributed
to the later paginated executable. The currently available raw CPU report is
for hash `7eb48a09bfbf59618dd9fee08ceae0470fb4058646d2233a54a5fe7994d31958`,
so a fresh measurement is required before publishing paginated-build CPU costs.

## Current paginated build and local browser

Revision `c2926e2be370e574b80666ecbe6db5c459674fa5` produces 22,726 bytes,
SHA-256 `662445028d6c55d58f5497032853803d181e128082ed1f1264db1e010cd162e3`.
The allocation is 0100h–59C6h exclusive, including the 512-byte stack.

One local Chromium run completed all 147 route commands and reached 126 points.
Eight introduction pages were traversed; human pager waiting is excluded from
the command samples. Enter-dispatch to observed-prompt wall time, including
automation overhead, was **18.74 ms at p95**, with a **26.22 ms maximum**.
The raw samples are in the coordinator workspace at
`work/caverns/browser-full-report.json`.

This is a local browser observation, not physical display latency, an ESP32
measurement or a hosted-site result. The report does not identify a complete
reference-machine configuration, so retain that configuration with release
measurements before using this as a cross-machine comparison. No CPU-cycle
speedup follows from comparing these wall times with the historical CPU table.

## Paginated release measurements

The current release's [raw CPU samples](evidence/command-costs.json) record
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
excluded from those command samples. Hosted measurements remain outstanding.
