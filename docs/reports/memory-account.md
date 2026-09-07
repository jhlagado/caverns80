# Caverns memory account

Copyright 1982–83 John Hardy.

> **Spoilers:** This engineering report names game-state and save structures. It contains no walkthrough.

Version 0.1.1 occupies 22,896 bytes from 0100h to 5A70h exclusive. Its SHA-256 is
`6e4c4154d7136645c18effccfc5d60ca3d59ae7b19a963b389608ecaf18e2dfb`.

| Partition | Bytes |
| --- | ---: |
| Emitted instructions | 5,198 |
| Immutable text and tables | 16,614 |
| Writable workspace, excluding stack | 572 |
| Reserved private stack | 512 |
| **Complete COM allocation** | **22,896** |

The workspace includes allocations embedded beside code as well as `vars.asm`:

| Workspace | Bytes |
| --- | ---: |
| Raw and padded command input | 112 |
| Candidate save record | 128 |
| Four 36-byte FCBs and 128-byte expected-record buffer | 272 |
| Disk operation status | 2 |
| Console column state | 1 |
| Game state, objects and parser scratch | 51 |
| Random-generator state | 2 |
| Input-overflow and pager state | 4 |
| **Workspace total** | **572** |

Run `node tools/memory-account.mjs` after the normal ATOM build. The reporter
reads the COM, manifest, native debug map and source without changing them.
It verifies the executable and source hashes, then assigns every emitted byte
to exactly one partition. Instruction/data classification uses the source
DB/DW/DS directives: ATOM's debug-map `kind` field alone labels some reserved
DS storage as code, which would overstate instruction bytes. Explicit symbol
ranges identify writable storage within otherwise code-bearing modules.
Unknown reservations, overlapping ranges, duplicate emissions and gaps fail
the account rather than disappearing into an estimated remainder.

The stack is reserved capacity; it is not an observed maximum depth. Refer to
the [stack audit](cpm-stack.md) for measured paths and their limits. All data and
stack bytes above are already included in the COM; there is no dynamic game
allocation or additional external game-text file.
