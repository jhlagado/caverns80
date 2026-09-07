# Caverns command-cost baseline

Copyright 1982–83 John Hardy.

> **Spoilers:** The raw measurement samples name commands from the complete winning route.

The 8 September 2026 build occupies 21,233 bytes from CP/M address 0100h through
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
older implementation. Browser latency qualification remains a separate gate.
