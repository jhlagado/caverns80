# Port the current BASIC adventure to Caverns80

Use TEC-OS commit `7c36f30d487222fcffbbe8a1410f4ecefa5354de` as the gameplay
reference. Its `programs/caverns/world.json` records the 54 rooms, exit data
and object slots. The labelled `programs/caverns/engine.bas.in` defines the
conditions beyond the exit table. `CAVERNS.TXT` is the current player manual.

The assembly output is `CAVERN80.COM`. The BASIC output is `CAVERNS.COM`.
Caverns80 already has named CP/M disk slots with recoverable saves, backup
files and exact random state. Keep that facility. If a port changes the
meaning of saved fields, explicitly handle the old record before loading it.

## Map and prose

The initial comparison found differences in 15 literal exit rows. Some are
representational. For example, the vault door is a destination flag in both
implementations, but BASIC marks the exit in its table with a negative number
and assembly overrides a blocked slot at runtime.

The first map pass ports the bat loop (rooms 29–34) and suppresses the old
unwarned fatal exits on the bridge, lower ledge, waterfall and castle bank.
It takes the prose for those rooms from the same reference. The crater keeps
its explicit warning and remains the one fatal compass exit. The full route
visits the new bat loop on its way back from retrieving the key.

The next map pass needs to handle these routes and their prose together:

- Balcony and temple. Secure, untie and climb the rope in both directions.
  Remove the old temple/wizard shortcut after a walking return is available.
- Crypt and cell. Keep the crypt seal reversible, apply the grille's carrying
  restriction and make the service hatch open from the drain junction.
- Lower river and castle. Keep the drawbridge's valid return and the walking
  route back from the castle. Visiting the waterfall must not move a latch.
- Temple gate. Describe both states accurately.

The oak-door batch ports the crystal, the castle flask, its seal and the
opening scene. The light flag and object slot numbers retain their disk
representation. An old save’s candle and bomb slots now refer to the crystal
and flask. A spent flask stays spent and an opened oak door stays open.

## Further differences to check against BASIC

| Area | Assembly still does | BASIC reference does |
| --- | --- | --- |
| Rope and temple | Drops the rope on the balcony on a one-way descent. The wizard cavern connects directly back to the temple. | Ties the rope explicitly and lets the player climb back. The temple and wizard cavern use their separate routes. |
| Crypt, grille and hatch | Opens the cell's north exit after a waterfall visit. Taking the grille opens the eastern shaft and carrying it does not block passage. | The drain junction's hatch opens directly and stays open. The grille must be left behind before using the shaft. Both sides of the crypt seal are traversable. |
| Temple gate | The key moves you into the crypt. The north exit is otherwise blocked. | The key also leaves the gate open so going north later works. |
| Bat and wizard | Relocates the transport bat and makes the wizard take the sword on defeat. | Removes the transport bat after the ride and leaves the sword with the player. |
| Combat and inventory | Uses its established attack, turn and carry rules, including a ten-object limit. | Has an eleven-object limit, different retaliation timing and a free weapon clarification. |
| Homecoming | Requires individual treasure drops. Carried treasures are worth their carried value even in the hut. | Banks carried treasures when you unlock the hut, retains equipment and shows the ranking and completion scene. |
| Instructions | Pages the story and rules at launch and on HELP. | Points to a separate manual and has a short HELP response. |

Keep the assembly disk recovery semantics while updating state that these
rules require. Compare fields and puzzle outcomes, as well as room IDs and
prose, during the full route. Use the same arrival paths in both builds when
checking room descriptions. Keep the existing
disk recovery tests and add coverage for any state fields the port adds.
Validate each batch on its own. The crystal batch passes the assembly suite
and a 146-command normal-start route in the TEC-OS emulator. Both executables
were on the test card. SAVE CAMP and LOAD CAMP preserved the 126-point result
across a reboot. Requalify the final port with all 54 rooms and the changed
puzzle state before replacing downstream builds. Keep historical release
records distinct from the port's evidence.
