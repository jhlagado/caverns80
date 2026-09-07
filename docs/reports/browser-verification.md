# Repeatable hosted browser verification

Copyright 1982–83 John Hardy.

> **Spoilers:** The executable proof follows the complete winning route and records its commands. Run it after playing if you want to discover the game yourself.

`tools/prove-browser.mjs` verifies the hosted version against the current owner
build manifest. It uses Playwright and CP/M disk reading from an explicitly
selected Triptych checkout. It opens fresh browser contexts and private disk
copies; it never opens a user's browser profile or replaces their saved media.

After the normal owner build, Triptych dependency installation, and
`npx playwright install chromium` in the Triptych checkout:

```sh
TRIPTYCH_ROOT=/absolute/path/to/triptych \
CAVERNS_REPORT_DIR=/absolute/path/to/proof-output \
node tools/prove-browser.mjs
```

`CAVERNS_URL` defaults to `https://jhlagado.github.io/triptych/`. Reports default
to `build/browser-proof`. The tool first downloads the catalog, COM and default
disk, checks their hashes and verifies the exact game extracted from that disk.
A site serving another release fails before gameplay starts.

The browser then follows all 147 ordinary route commands, completes the quest
for 126 points, saves WEBWIN, quits, reloads the page and loads it again. It
exports that disk and imports it into another fresh browser context, restores
the winning save and continues with LOOK and SCORE. Output includes asset
identity, browser/reference-host details, per-command timings, a screenshot
and the saved disk. Exact prompt readiness, typed echo and explicit pager
continuation prevent queued commands from hiding incomplete output.

An optional existing-media proof imports a supplied old standard CP/M disk:

```sh
TRIPTYCH_ROOT=/absolute/path/to/triptych \
CAVERNS_OLD_DISK=/absolute/path/to/old-saved.img \
CAVERNS_OLD_SLOT=BROWSER \
CAVERNS_REPORT_DIR=/absolute/path/to/proof-output \
node tools/prove-browser.mjs
```

The old fixture must use the standard 77-track, 26-sector image layout and
contain the named save. Its file is read only. Reopening must preserve every
byte before the tool explicitly stages the verified CAVERNS.COM update. The
tool accepts only the two known replacement confirmation messages, compares
all other user-0 files and system tracks, loads the old save and exercises
voluntary cancellation. It records those bounded results separately from the
fresh full-game proof.

This tool consolidates previously executed workspace proofs. The consolidated
owner tool passed locally against 0.1.1, including the supplied v0.1.0 saved-disk
upgrade. Its hosted acceptance result must be recorded after deployment. Neither its presence nor the earlier scripts'
results certify a new deployment automatically.
