# Reversible map revision

> **Spoilers:** This development document discusses the map, puzzles, game rules, or solutions. Read it after playing if you want to discover the adventure yourself.

The outdoor map already reverses normally. Its locked hut door remains a puzzle. The cave and drain changes below remove duplicate shortcuts and contradictory compass connections; no room is deleted. Dynamic puzzle exits remain separate from the static table.

| Room | Direction | Old destination | New destination | Reason |
|---|---|---|---|---|
| 20 roomOakDoor | N | 21 | 0 | Straighten central cave connections; remove duplicate shortcuts |
| 20 roomOakDoor | S | 23 | 21 | Straighten central cave connections; remove duplicate shortcuts |
| 21 roomDarkCavernB | N | 0 | 20 | Straighten central cave connections; remove duplicate shortcuts |
| 21 roomDarkCavernB | E | 20 | 22 | Straighten central cave connections; remove duplicate shortcuts |
| 22 roomWindCorridor | E | 16 | 0 | Straighten central cave connections; remove duplicate shortcuts |
| 23 roomTortureChamber | W | 18 | 0 | Straighten central cave connections; remove duplicate shortcuts |
| 24 roomNorthSouthTunnel | E | 18 | 0 | Straighten central cave connections; remove duplicate shortcuts |
| 25 roomDarkCavernC | S | 27 | 0 | Straighten central cave connections; remove duplicate shortcuts |
| 25 roomDarkCavernC | W | 24 | 26 | Straighten central cave connections; remove duplicate shortcuts |
| 27 roomLedgeOverRiver | N | 18 | 26 | Straighten central cave connections; remove duplicate shortcuts |
| 29 roomDarkCavernD | N | 0 | 30 | Make the bat/key loop reversible |
| 30 roomDarkCavernE | N | 29 | 0 | Make the bat/key loop reversible |
| 30 roomDarkCavernE | S | 31 | 29 | Make the bat/key loop reversible |
| 30 roomDarkCavernE | E | 0 | 32 | Make the bat/key loop reversible |
| 31 roomDarkCavernF | N | 32 | 33 | Make the bat/key loop reversible |
| 31 roomDarkCavernF | W | 0 | 32 | Make the bat/key loop reversible |
| 32 roomDarkCavernG | N | 33 | 0 | Make the bat/key loop reversible |
| 32 roomDarkCavernG | S | 30 | 0 | Make the bat/key loop reversible |
| 32 roomDarkCavernG | W | 0 | 30 | Make the bat/key loop reversible |
| 32 roomDarkCavernG | E | 0 | 31 | Make the bat/key loop reversible |
| 33 roomBatCave | N | 0 | 29 | Make the bat/key loop reversible |
| 35 roomTemple | E | 0 | 36 | Allow return to the temple |
| 41 roomDrainA | N | 46 | 0 | Straighten drain/service passages; preserve staircase route |
| 41 roomDrainA | S | 43 | 0 | Straighten drain/service passages; preserve staircase route |
| 42 roomDrainB | N | 46 | 0 | Straighten drain/service passages; preserve staircase route |
| 42 roomDrainB | S | 43 | 0 | Straighten drain/service passages; preserve staircase route |
| 44 roomDrainD | N | 47 | 0 | Straighten drain/service passages; preserve staircase route |
| 44 roomDrainD | S | 47 | 0 | Straighten drain/service passages; preserve staircase route |
| 44 roomDrainD | W | 0 | 43 | Straighten drain/service passages; preserve staircase route |
| 44 roomDrainD | E | 47 | 0 | Straighten drain/service passages; preserve staircase route |
| 45 roomWaterfallBase | N | 0 | 47 | Straighten drain/service passages; preserve staircase route |
| 46 roomDarkCavernK | N | 47 | 0 | Straighten drain/service passages; preserve staircase route |
| 46 roomDarkCavernK | S | 0 | 43 | Straighten drain/service passages; preserve staircase route |
| 46 roomDarkCavernK | E | 47 | 0 | Straighten drain/service passages; preserve staircase route |
| 47 roomStoneStaircase | W | 46 | 0 | Straighten drain/service passages; preserve staircase route |
| 47 roomStoneStaircase | E | 0 | 46 | Straighten drain/service passages; preserve staircase route |
| 52 roomEastRiverbank | E | 50 | 0 | Remove duplicate courtyard exit |
| 54 roomRiverConduit | W | 41 | 0 | Conduit and drain use opposite compass directions |
| 54 roomRiverConduit | E | 0 | 41 | Conduit and drain use opposite compass directions |

Central caves retain the diamond corridor, north/south tunnel, round room and balcony, but the oak door is now north of room21. Room25 is a reversible side chamber east of26. The key/bat area forms a loop:29 south33 south31 west32 west30 south29. Each connection has its inverse. Temple35 now has a normal east return to36.

Drains form an east/west chain41–42–43–44, with43 north46,46 west47 and47 south45. The conduit54 connects east to41, matching41 west54. The east-bank duplicate east exit to the courtyard is removed; north remains.

Intentional exceptions: hut1 north2 returns through OPEN DOOR WITH KEY; treasure19 west20 returns through the bomb-opened door; crypt37 south35 returns through OPEN GATE WITH KEY; cell38 north43 and east39 are discovered/unblocked by waterfall/grille; drawbridge49 west48 returns only after bridge lowering. Rope descent28→35 and GALAR teleport are commands, not compass edges. Fatal chasm exits128 remain fatal.

Route updates: after key34: EAST,SOUTH,WEST,WEST,SOUTH,EAST,SOUTH,EAST reaches balcony28. After first banking, approach oakdoor via18 WEST23 NORTH22 WEST21 NORTH20. Conduit stone excursion uses41 WEST54, with return EAST41 if required.
