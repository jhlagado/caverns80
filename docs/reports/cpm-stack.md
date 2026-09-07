# CP/M entry and stack audit

Copyright 1982–83 John Hardy. Audited 8 September 2026.

The current CAVERNS.COM uses a conventional private application stack and exits
through BDOS System Reset. It does not depend on the earlier machine's console
ports, restart vectors or high-memory stack assumptions. No stack-policy change
is required by this audit.

## Contract and implementation

Digital Research's [CP/M 2 System Interface](https://www.cpm.z80.de/manuals/archive/cpm22htm/ch5.htm)
defines the BDOS entry at 0005h and System Reset as function 0, with no return to
the application. This permits Caverns to replace the initial CCP stack: it exits
through the operating system instead of trying to RET using the displaced stack.

- `prologue.asm` establishes COM origin 0100h and jumps to START.
- `startup.asm` sets SP to STACKTOP before making its first subroutine call.
- `vars.asm` reserves exactly 512 bytes from 5870h to 5A70h exclusive.
- The v0.1.1 22,896-byte allocation, including buffers and stack, is contained in the COM. It ends below every supported Triptych resident boundary.
- `system.asm` implements termination as LD SP,STACKTOP; LD C,0; CALL 5. The following JP 0 is a defensive warm-boot fallback, not an application return.
- Restart jumps to START and resets SP, discarding pending command frames.
- Console and file operations use BDOS. The console adapter preserves its documented registers around those calls. Save operations close files and restore DMA to 0080h.

Voluntary QUIT/RESTART store cancellation permission on the current stack.
C/CANCEL removes that word and returns through the existing caller; death
prompts reject cancellation. Y removes the word before restarting, N before
exiting, and Ctrl-C uses the adapter's stack-reset exit. Empty or overlong
responses stay at the same prompt without accumulating stack entries.

## Evidence and limits

The current 57-test suite exercises full progression, nested output, paging,
save/load, all implemented terminal branches and repeated restarts. The earlier v0.1.0
Triptych A/B lifetime proof additionally traces application SP instruction by
instruction during startup, paging, inventory and exit. The observed minimum
application SP in that scenario was 5994h: 50 bytes below the 59C6h stack top,
within the 512-byte reservation. This is an observed scenario bound, not a claim
that every possible path uses at most 50 bytes.

The A/B proof observes BDOS function 0 as the termination boundary, verifies
resident preservation and subsequent CCP entry, and compares native console
behaviour and disk images. Earlier test assumptions about a shared E400h stack
and RET-to-zero were specific to other tools and were corrected for Caverns.
They were not CP/M requirements.

This qualifies the declared Z80 CP/M target. It does not claim that a Z80 binary
runs on an 8080-only machine, or that its memory requirement fits every historical
CP/M installation. The release manifest states the required allocation.
