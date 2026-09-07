# Caverns: player guide

Copyright 1982–83 John Hardy. John began Caverns on the ZX81 in 1982 and
released the Microbee version in 1983. Caverns80 continues his adventure with
revised gameplay for CP/M.

## Beginning an adventure

At the CP/M prompt on the disk containing the game, enter `CAVERNS`. The story
and rules appear before your first command prompt. `HELP` repeats them during
play. This guide contains the opening story and general rules; puzzle solutions
remain yours to discover.

## The sign in the hut

You are standing in an old deserted hut. There is a door to the north and a
sign on the wall. The sign reads as follows…

Deep in the icy mountains of northern Iotunheim there lived a small band of
elves who called themselves “The Great Sons of Svartalfheim.” These elves
worked day and night underground in the limestone caves, mining precious
minerals which they fashioned into jewellery. So prized were their products
that merchants and traders came from distant Asgar and Fenris to purchase them.
The elves became prosperous and built a mighty underground empire linking all
the mines to a central city.

Then the King of the Danes, a very greedy man, sent his troops into the mines
to sack the golden city. Every elf they found was to be taken to the Royal
Palace to work in the foundry. All the inhabitants of Svartalfheim were forced
to live within the city walls.

To the surprise of everyone around them, the elves began to die as if from
some strange illness. Nothing could save them. Within a few weeks they were
all dead, and their wonderful gifts were lost forever. The King was furious
and executed several of his courtesans, but the damage had already been done.

Centuries passed. The story of Svartalfheim faded from memory until a goatherd
called Peter ran into town with an incredible story. “Way up in the hills,”
he said, “is the entrance to a cave guarded by a green serpent that breathes
flames!”

Peter described his escape from the dragon's fiery breath and a tiny room
filled with more gold and silver than he could carry. He had brought back
one jewel to prove his story: a tiny ruby ring, crafted with great skill.
He led a group of villagers into the mountains beyond Mt. Ymir, but they were
all killed in a rockfall before reaching the entrance. Svartalfheim was lost
again, and its hidden treasures became the subject of myths.

Four hundred years have passed since Peter's journey. You have come to
Iotunheim to search for the treasure yourself. Following the valley into a
forest in the foothills of Ymir, you have made your base in a small hut that
once belonged to a hermit.

## Your aim

Find the legendary treasure room of Svartalfheim and bring as much treasure
as possible back to the hut. Your score depends on your discoveries and the
treasures you recover. `SCORE` displays your current result; the maximum is
126 points.

Objects have practical uses as well as value. You can carry ten objects at a
time, so deciding what to take and what to leave is part of the adventure.
A map may help: paths can curve and double back, particularly in the forest.
The compass is valuable for finding your way.

## Commands

Enter one command at a time and press Enter. Uppercase and lowercase both
work. Backspace edits the line, and an empty line returns to the prompt.

| Command | Effect |
| --- | --- |
| `NORTH`, `SOUTH`, `EAST`, `WEST` | Travel in that direction; `N`, `S`, `E`, `W` and forms such as `GO NORTH` also work. |
| `LOOK` | Describe your surroundings again. |
| `LIST`, `INVENT`, `INVENTORY`, `I` | List the objects you carry. |
| `GET COMPASS` or `TAKE COMPASS` | Pick up a named object when it is present. |
| `DROP COMPASS` | Put a carried object down. |
| `EXAMINE` followed by an object | Examine a present or carried object. |
| `READ` | Read a contextual inscription or clue. |
| `SCORE` | Display your score. |
| `HELP` | Repeat the story and rules. |

For other tasks, name the action and the objects involved. Supported action
words include `OPEN`, `UNLOCK`, `KILL`, `ATTACK`, `LIGHT`, `BURN` and `DOWN`.
Some actions require both a target and a carried tool. The original
instructions give `KILL DRAGON WITH SWORD` as an example of a clear command.
Use explicit actions and tools in this version; the historical general-purpose
`USE` shorthand is not part of the current command set.

Looking, checking inventory, reading, examining, displaying your score and
requesting help cost no turns. Saving and loading are also free. Travel and
physical actions take time, including unsuccessful attempts at recognised
actions. Your candle burns down as time passes, and creatures may attack.
Saving before a risky action gives you a point to return to.

## Saving and returning

`SAVE` writes `CAVERNS.SAV` on the current disk; `LOAD` restores it. Named slots
let you retain several positions:

```text
SAVE CAMP
LOAD CAMP
```

A slot name has one to eight letters, digits or underscores. Supply the name
alone, without a drive prefix or extension. `SAVE CAMP` uses `CAMP.SAV`.
Replacing an existing save requires confirmation. Answer `Y` to replace it or
`N` to cancel; the previous committed save remains as a backup.

If a save is interrupted and the main file cannot be loaded, `LOAD` can
recover a valid backup or temporary file after confirmation. After recovery,
save under a different name. A “needs recovery” message means you should load
that slot before attempting to save elsewhere. A rejected or missing save
leaves the current game unchanged.

Saved games are files on the CP/M disk. In the browser, keep that disk through
Triptych's saved-media facilities and download a copy as a backup. Starting
with a fresh disk does not include saves from an older one. Wait for a save to
finish before leaving the game or exporting the disk.

`RESTART` begins another adventure after confirmation. `QUIT` displays your
score and prompts for another adventure: answer `N` to return to CP/M.
Ctrl-C returns immediately to CP/M. Save first if you want to continue later.

The sun is rising. It is time you were on your way… Good luck!

## Reading the introduction

The story and HELP pause before filling a 25-row terminal. Press Space or Enter
to continue, or Q to skip the remaining text and return to the game. HELP starts
the story again whenever you want to reread it. Reading pages does not use turns.
