# Ordinary-command room coverage

**Spoilers:** this matrix identifies the completed adventure route and hidden passages. Caverns is John Hardy's game; existing copyright and licence notices remain authoritative. No text or implementation from HyperDrive is included.

The assembled COM passed `test/world-tour.test.mjs`: a fresh score126 playthrough followed by physical exploration visited all54 rooms, with no memory injection, STAGE command or test teleport. GALAR is the ordinary player command. The candle remained lit and all ten treasures remained banked.

| Room | Name | Executed coverage |
|---|---|---|
| 1 | Dark Room | Fresh winning route |
| 2 | Forest Clearing | Fresh winning route |
| 3 | Dark Forest | Fresh winning route |
| 4 | Clover Field | Fresh winning route |
| 5 | River Cliff | Fresh winning route |
| 6 | River Bank | Fresh winning route |
| 7 | Crater Edge | Fresh winning route |
| 8 | River Outcrop | Fresh winning route |
| 9 | Mt Ymir Slope | Fresh winning route |
| 10 | Bridge North Anchor | Fresh winning route |
| 11 | Bridge Mid | Fresh winning route |
| 12 | Bridge South Anchor | Fresh winning route |
| 13 | Mushroom Rock | Fresh winning route |
| 14 | Cave Entrance Clearing | Fresh winning route |
| 15 | Cliff Face | Fresh winning route |
| 16 | Cave Entry | Fresh winning route |
| 17 | Dead End Inscription | Post-victory physical tour |
| 18 | Dark Cavern A | Fresh winning route |
| 19 | Treasure Room | Fresh winning route |
| 20 | Oak Door | Fresh winning route |
| 21 | Dark Cavern B | Fresh winning route |
| 22 | Wind Corridor | Fresh winning route |
| 23 | Torture Chamber | Fresh winning route |
| 24 | North South Tunnel | Fresh winning route |
| 25 | Dark Cavern C | Post-victory physical tour |
| 26 | Round Room | Fresh winning route |
| 27 | Ledge Over River | Fresh winning route |
| 28 | Temple Balcony | Fresh winning route |
| 29 | Dark Cavern D | Fresh winning route |
| 30 | Dark Cavern E | Fresh winning route |
| 31 | Dark Cavern F | Fresh winning route |
| 32 | Dark Cavern G | Fresh winning route |
| 33 | Bat Cave | Fresh winning route |
| 34 | Dark Cavern H | Fresh winning route |
| 35 | Temple | Fresh winning route |
| 36 | Dark Cavern I | Fresh winning route |
| 37 | Crypt | Fresh winning route |
| 38 | Tiny Cell | Fresh winning route |
| 39 | Dark Cavern J | Fresh winning route |
| 40 | Ledge Waterfall In | Fresh winning route |
| 41 | Drain A | Fresh winning route |
| 42 | Drain B | Fresh winning route |
| 43 | Drain C | Fresh winning route |
| 44 | Drain D | Post-victory physical tour |
| 45 | Waterfall Base | Fresh winning route |
| 46 | Dark Cavern K | Fresh winning route |
| 47 | Stone Staircase | Fresh winning route |
| 48 | Castle Ledge | Fresh winning route |
| 49 | Drawbridge | Fresh winning route |
| 50 | Castle Courtyard | Fresh winning route |
| 51 | Powder Mag | Fresh winning route |
| 52 | East Riverbank | Fresh winning route |
| 53 | Wooden Bridge | Fresh winning route |
| 54 | River Conduit | Fresh winning route |

## Post-victory tour

From the hut, GALAR reaches16; EAST enters17. LOOK exposes the Sacred Key inscription. WEST deliberately triggers the giant bat, taking the player to33 and relocating the bat to24. The test asserts this exception instead of pretending WEST is a normal map exit. NORTH29, EAST26, EAST25 visits the side chamber; WEST26, SOUTH27, EAST28 returns to the balcony. GET ROPE and DOWN WITH ROPE reach35. EAST36, NORTH39, WEST38, NORTH43, EAST44 reaches the last unvisited drain. Every command asserts its expected room and a complete prompt.

## Puzzle and clue coverage

The fresh route covers the key, rope descent, crypt READ/VARD, grille removal, waterfall return, castle READ/GALAR, bomb door, sword recovery, combat and treasure banking. The added tour covers the bat displacement and observes the dead-end key inscription through LOOK. The initial tour used LOOK because READ at17 returned “Nothing happens”. Version 0.1.1 fixes READ to show the same inscription; [cancel-read.test.mjs](../../test/cancel-read.test.mjs) verifies its text and unchanged state/stack.

## Limits

This proves visits to every room, not every exit in both directions or every possible puzzle ordering. Fatal exits have separate deterministic terminal-path tests. The test uses the development BDOS adapter and automatic pagination; native CP/M, browser display and disk persistence evidence belong to their separate integration reports.
