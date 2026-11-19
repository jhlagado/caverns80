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
- Gate and oak door. Describe each state accurately, including a passage
  opened by the crystal and flask. Add the new activation and consumption
  rules along with its narrated result.

Then review the rest of the room prose, the HELP text, monster reactions and
treasure banking together with prompt and combat behaviour. Keep the existing
disk recovery tests and add coverage for any state fields the port adds.
Qualify the exact assembly build on TEC-OS with a normal start, all 54 rooms,
126 points and SAVE/LOAD across process exit. Keep the historical release
records distinct from the port's evidence.
