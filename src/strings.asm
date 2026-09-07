TITLE:                  DB "DREAMCARDS presents...",13,10,13,10
                        DB "C A V E R N S  by John Hardy (c) 1982-83",13,10
                        DB "BeeHive Software House",13,10,13,10
                        DB "Originally written for the ZX81 in 1982.",13,10
                        DB "Adapted by the author for CP/M",13,10
                        DB "GPL 3.0 Copyleft 2026 All wrongs reserved!",13,10,13,10,0

PROSTR:              DB "? ",0

STRCRLF:                DB 13,10,0
STRCOMSP:          DB ", ",0

STRTOOD1:             DB "It's very dark, too dark to see anything...I'm scared!",0
STRDARCA:          DB "You are deep in a dark cavern.",0
STRBRISN:       DB "Two of the ropes have snapped under your weight. It's "
                        DB "totally unfit to cross again.",0
STRDRACO:        DB "You can also see the bloody corpse of an enormous dragon.",0
STRGOLBR:          DB " A mighty golden drawbridge spans the waters.",0
STRCANDI:           DB "Your candle is growing dim.",0
STRCANOU:           DB "In fact...it went out!",0
STRSEEOB:          DB "You can also see...",0
STRSEECR:        DB "Nearby there lurks...",0
STRPRO:              DB ">",0
STRCARPR:      DB "You are carrying ",0
STRNOT:             DB "nothing.",0
STRANO:             DB "Another adventure? ",0
STRSCOPR:         DB "You have a score of ",0
STRSCOMI:            DB " out of a possible 126 points in ",0
STRSCOSU:         DB " moves.",0
STRGIABA:            DB "The giant bat picked you up and carried you to another "
                        DB "place.",0
STRMONKI:       DB "AUUUUUGH...you've just been killed by ",0
STRMONSU:       DB "!!",0
STRCANGO:       DB "You can't go that way",0
STRFATFA:           DB "You stumble and fall into the chasm and smash yourself to "
                        DB "a pulp on the rocks below.",0
STRMAGWI:           DB "The runes of Galar glow and a magic wind carries you to another place...",0
STRCRYWA:           DB "Hey! the eastern wall of the crypt slid open...",0
STREH:                  DB "Sorry, I don't understand.",0
STRCANSE:           DB "Where? I can't see it.",0
STRTOOMA:      DB "You are carrying too many objects.",0
STRUSEHO:              DB "How am I supposed to use it?",0
STRWONOP:            DB "It won't open!",0
STRDOOOP:          DB "You opened the door.",0
STRGATOP:          DB "You opened the gate.",0
STRNOTTO:       DB "But there's nothing to kill...",0
STRSWOMI:           DB "You swing with your sword but miss and the creature "
                        DB "smashes your skull.",0
STRATTMO:          DB "You attack but the creature moves aside.",0
STRATTDE:       DB "The creature deflects your blow.",0
STRATTST:          DB "The foe is stunned but quickly regains his balance.",0
STRATTHE:      DB "You missed and he deals a blow to your head.",0
STRSWOKI:          DB "The sword strikes home and your foe dies...",0
STRSWOCR:       DB "Hey! Your sword has just crumbled into dust!!",0
STRCORVA:         DB "Suddenly a black cloud descends and the corpse vaporizes "
                        DB "into nothing.",0
STRWONBU:            DB "That won't burn, Dummy...In fact, the candle went out.",0
STRCANO1:     DB "But the candle is out, stupid!!",0
STRBOMEX: DB "You shelter around the corner as the fuse burns. BOOM! The oak door splinters, revealing the treasure vault.",0
STRTOODA:        DB "It's too dangerous!!!",0
STRDESRO:         DB "You descend the rope, but it drops 10 feet short of the "
                        DB "floor. You jump the rest of the way.",0
STRNOTHA:      DB "Nothing happens!",0
STRNOTCA:         DB "You aren't carrying that.",0
STRTAKSU:         DB " taken.",0
STRCOMNO:       DB "You attack, but combat isn't implemented yet.",0
STRPLETE:          DB "Please tell me how.",0
STRICANT:               DB "I can't!",0
STRMONMI:         DB "The creature lunges at you but you dodge at the last moment.",0
STRGAMSA:           DB "Game saved.",0
STRGAMLO:          DB "Game loaded.",0
STRSTUVE:            DB "Not implemented: ",0
STRSTUTA:          DB " target=",0
STRSTUTO:            DB " tool=",0
STRDOOWO:            DB "door",0
STRGATWO:            DB "gate",0
STRGALCL:           DB "Speak the name that lies mirrored in the last light of the alphabet, and the ancient path shall open.",0
; Original1983 introduction, with display padding and split words repaired.
STORYTXT:
        DB "WELCOME TO CAVERNS!!",13,10,13,10
        DB "You are standing in an old deserted hut. There is a door to the north. "
        DB "On the wall is a sign. The sign reads as follows...",13,10,13,10
        DB "Deep in the icy mountains of northern Iotunheim there lived a small "
        DB "band of elves who called themselves `The Great Sons of Svartalfheim.'",13,10,13,10
        DB "These elves worked day and night deep underground in the limestone "
        DB "caves, mining for precious minerals which they fashioned into "
        DB "jewellery.",13,10,13,10
        DB "So prized were their products that merchants and traders came from "
        DB "distant Asgar and Fenris to purchase them.",13,10,13,10
        DB "The elves became very prosperous and built a mighty empire deep "
        DB "underground which linked all the mines to a central city.",13,10,13,10
        DB "Then one day, the King of the Danes, who was a very greedy man, sent "
        DB "his troops into the mines to sack the golden city. Every elf found was "
        DB "to be brought to the Royal Palace to work in the foundry. This was "
        DB "done and all the inhabitants of Svartalfheim were forced to live "
        DB "within the city walls.",13,10,13,10
        DB "Suddenly, to the surprise of all around, the elves began to die as if "
        DB "of some strange illness. Nothing could be done to save them and within "
        DB "a few weeks all of the elves were dead and their wonderful gifts lost "
        DB "forever. The King was furious and executed several of his courtesans, "
        DB "but the damage had already been done.",13,10,13,10
        DB "Centuries passed and the story of Svartalfheim faded from memory until "
        DB "one day a goatherd called Peter ran into town with an incredible "
        DB "story.",13,10,13,10
        DB "`Way up in the hills,' he said, `is the entrance to a cave guarded by "
        DB "a green serpent that breathes flames!'",13,10,13,10
        DB "Peter told a story of how he managed to escape the fiery breath of the "
        DB "dragon and found a tiny room filled with more gold and silver than he "
        DB "could possibly carry.",13,10,13,10
        DB "The only jewel he could bring back to prove his story was a tiny ruby "
        DB "ring which had obviously been crafted with great skill.",13,10,13,10
        DB "Peter led a group of his fellow villagers back up into the mountains "
        DB "beyond Mt. Ymir, but they were all killed in a rock fall before they "
        DB "could reach the entrance. So Svartalfheim was once again lost and "
        DB "stories of its hidden treasures became myths.",13,10,13,10
        DB "It is four hundred years since the days of Peter the goatherd and you "
        DB "have come to Iotunheim to search for the treasure yourself. You "
        DB "followed the valley to a forest in the foothills of Ymir and set up a "
        DB "base in a small hut which at one time belonged to a hermit.",13,10,13,10
        DB 0
STRHELTE:
        DB "RULES",13,10,13,10
        DB "Your aim is to obtain the highest possible score by collecting as much "
        DB "treasure as possible. Find the legendary treasure room of Svartalfheim "
        DB "and bring the treasures back to this hut to maximize your score. You "
        DB "will need to locate and manipulate several objects.",13,10,13,10
        DB "Give a clear action and name the objects involved: GET COMPASS, OPEN "
        DB "DOOR WITH KEY, or KILL DRAGON WITH SWORD. Carry a tool before using "
        DB "it. You can carry ten objects.",13,10,13,10
        DB "NORTH, SOUTH, EAST and WEST move you; N, S, E and W are short forms. "
        DB "GO NORTH works too.",13,10,13,10
        DB "LOOK describes your surroundings. INVENTORY, INVENT, I and LIST show "
        DB "what you carry. EXAMINE an object or READ an inscription for clues. "
        DB "SCORE shows your current score. HELP repeats this story and these "
        DB "rules.",13,10,13,10
        DB "GET or TAKE picks up an object. DROP puts it down. Name the action and "
        DB "tool for other tasks: OPEN, UNLOCK, KILL, ATTACK, LIGHT, BURN or DOWN. "
        DB "Some actions require both a target and a tool.",13,10,13,10
        DB "Looking, checking inventory, reading, examining, scoring and HELP cost "
        DB "no turns. Travel and physical actions take time; a candle burns down "
        DB "and creatures may attack. Plan a retreat and save before taking a "
        DB "risk.",13,10,13,10
        DB "SAVE stores your game as CAVERNS.SAV on the current disk. LOAD "
        DB "restores it. SAVE CAMP and LOAD CAMP use a named slot. Names have one "
        DB "to eight letters, digits or underscores. Replacing a save requires "
        DB "confirmation; the previous save remains as a backup.",13,10,13,10
        DB "Saving and loading cost no turns. If a save was interrupted, LOAD can "
        DB "recover a valid backup or temporary file after confirmation. Save "
        DB "recovered progress under a different name. Keep the disk image to keep "
        DB "your saved games.",13,10,13,10
        DB "RESTART starts another adventure after confirmation. QUIT displays "
        DB "your score and asks whether you want another adventure; answer N to "
        DB "return to CP/M. Ctrl-C returns immediately to CP/M, so save first.",13,10,13,10
        DB "When journeying through Iotunheim and Svartalfheim it may help to make "
        DB "a map. Beware of paths that curve and double back on themselves, "
        DB "particularly in the forest. You will also find a compass of "
        DB "immeasurable value.",13,10,13,10
        DB "Well, the sun is rising. It is time you were on your way... Good luck!",13,10,13,10
        DB 0
STRRAN:             DB "This gives you an adventurer's ranking of:",0
STRRANHO:        DB "Hopeless beginner",0
STRRANLO:           DB "Experienced loser",0
STRRANAV:         DB "Average Viking",0
STRRANEX:       DB "Excellent...but you've left something behind!",0
STRRANPE:         DB "Perfectionist and genius!!",0
STRENCWI:           DB "There, before you in a swirling mist stands an evil wizard "
                        DB "with his hand held outwards...`Thou shall not pass' he "
                        DB "cries.",0
STRENCDR:          DB "Realizing your presence, its eyes flicker open and it "
                        DB "leaps up, breathing jets fire at you.",0
STRENCD1:          DB "",0
STRENCGO:           DB "From around the corner trots a snarling goblin carrying "
                        DB "a lantern. `My job is to protect these stone steps!' "
                        DB "he says and lunges at you with his dagger.",0

DESDARRO:            DB "You are standing in a darkened room. There is a door to the "
                        DB "north.",0
DESFORCL:      DB "You are in a forest clearing before a small bark hut. There "
                        DB "are no windows, and locked door to the south. The latch was "
                        DB "engaged when you closed the door.",0
DESDARFO:          DB "You are deep in a dark forest. In the distance you can see "
                        DB "a mighty river.",0
DESCLOFI:         DB "You are standing in a field of four-leafed clovers. There "
                        DB "is a small hut to the west.",0
DESRIVCL:          DB "The forest has opened up at this point. You are standing on "
                        DB "a cliff overlooking a wide glacial river. A small "
                        DB "foot-beaten path leads south.",0
DESRIVBA:           DB "You are standing at the rocky edge of the mighty river "
                        DB "Gioll. The path forks east and west.",0
DESCRAED:          DB "You are on the edge of an enormous crater. The rim is "
                        DB "extremely slippery. Clouds of water vapour rise high in the "
                        DB "air as the Gioll pours into it.",0
DESRIVOU:        DB "The path to the east stops here. You are on a rocky "
                        DB "outcrop, projected about 15 feet above the river. In the "
                        DB "distance, a tiny bridge spans the river.",0
DESMTYMI:              DB "You are on the lower slopes of Mt. Ymir. The forest "
                        DB "stretches far away and to the west. Arctic winds blow "
                        DB "fiercely, it's very cold!",0
DESBRINO:         DB "You stand on a rocky precipice high above the river, Gioll; "
                        DB "Mt. Ymir stands to the north. A flimsy string bridge spans "
                        DB "the mighty river.",0
DESBRIMI:           DB "You have made your way half way across the creaking bridge. "
                        DB "It sways violently from side to side. It's going to "
                        DB "collapse any second!!",0
DESBRISO:         DB "You are on the southern edge of the mighty river, before "
                        DB "the string bridge. Paths lead west, and a cliff face lies east.",0
DESMUSRO:        DB "You are standing on a rock in the middle of a mighty oak "
                        DB "forest. Surrounding you are thousands of poisonous "
                        DB "mushrooms. To the east lies the bridge; to the south the "
                        DB "woods deepen.",0
DESCAVCL:        DB "You are in a clearing in the forest. An ancient basalt rock "
                        DB "formation towers above you. To the south is the entrance "
                        DB "of an interesting looking cave. The mushrooms are to the north.",0
DESCLIFA:           DB "You are on a cliff face over looking the river.",0
DESCAVEN:           DB "You are just inside the cave. Sunlight pours into the cave "
                        DB "lighting a path to the east and another to the south. I "
                        DB "don't mind saying I'm a bit scared!",0
DESDEAEN:             DB "This passage appears to be a dead end. On a wall before you "
                        DB "is carved `Find the Sacred Key of Thialfi'.",0
DESTRERO:        DB "You are in the legendary treasure room of the black elves "
                        DB "of Svartalfheim. Every red-blooded Viking has dreamed of "
                        DB "entering this sacred room.",0
DESOAKDO:             DB "You can see a small oak door to the east. It has been "
                        DB "locked from the inside.",0
DESWINCO:        DB "The corridor turns south and west. You can feel a "
                        DB "faint breeze coming from the south.",0
DESTORCH:      DB "You are standing in what appears to have once been a "
                        DB "torture chamber. Apart from the rather comprehensive range "
                        DB "of instumentsof absolutely inhuman agony,",0
DESTORC1:     DB "coagulated blood stains on the walls and mangled bits of "
                        DB "bone on the floor make me think that a number of would be "
                        DB "adventurers croaked it here!",0
DESNSTUN:            DB "You stand in a long tunnel which has been bored out of the "
                        DB "rock.It runs from north to south. A faint glow comes from a "
                        DB "narrow crack in the eastern wall.",0
DESROURO:           DB "You are in a large round room with a number of exits. The "
                        DB "walls have been painted in a mystical dark purple and a big "
                        DB "chalk staris drawn in the centre of",0
DESROUR1:          DB "the floor. Note: This is one of the hidden chambers of the "
                        DB "infamous pagan sect, the monks of Loki. Norse folk believe "
                        DB "them to be gods.",0
DESLEDRI:          DB "You are standing on a narrow ledge, high above a "
                        DB "subterranean river. Passages lead north and east.",0
DESTEMBA:       DB "You are on a balcony, overlooking a huge cavern which has "
                        DB "been converted into a pagan temple. Note: this temple has "
                        DB "been dedicated to Loki, the god of",0
DESTEMB1:      DB "fire, who came to live in Svartalfheim after he had been "
                        DB "banished to exile by Odin. Since then he has been waiting "
                        DB "for the `End Of All Things'.",0
DESBATCA:             DB "You are in the central cave of a giant bat colony. Above "
                        DB "you hundreds of giant bats hang from the ceiling and the "
                        DB "floor is covered in centuries of",0
DESBATC1:            DB "giant bat droppings. Careful where you step! Incidentally, "
                        DB "the smell is indescribable.",0
DESTEM:              DB "You are in the temple. To the north is a locked gate and on "
                        DB "the wall is a giant statue of Loki, carved out of the "
                        DB "living rock itself!",0
DESCRY: DB "You stand in an old, musty crypt, the resting place of Loki devotees. Four carved stones surround a sealed eastern wall. An inscription invites you to READ it.",0
DESCRY2: DB "The air is heavy with the dust of centuries.",0
DESTINCE:            DB "You are in a tiny cell. The western wall has now firmly "
                        DB "closed again. There is a ventilator shaft on the eastern "
                        DB "wall.",0
DESWATLE:      DB "You are on another ledge high above a subterranean river. "
                        DB "The water flows in through a hole in the cavern roof, to "
                        DB "the north.",0
STRDRASY:       DB "Somehow you have gotten into the complex drainage system of"
                        DB "this entire cavern network!!",0
DESWATBA:       DB "You are standing near an enormous waterfall which brings "
                        DB "water down from the surface, from the river Gioll.",0
DESSTOST:          DB "You are standing before a stone staircase which leads "
                        DB "southwards.",0
DESCASLE:         DB "You are on a narrow and crumbling ledge. On the other side "
                        DB "of the river you can see a magic castle. (Don't ask me why "
                        DB "it's magic...I just know it is)",0
DESDRA:          DB "You are by the drawbridge which has just lowered "
                        DB "itself....by magic!!",0
DESCASCO:     DB "You are in the courtyard of the magic castle. WOW! This "
                        DB "castle is really something! On the wall is inscribed 'hzb "
                        DB "tzozi'. A secret escape tunnel leads south",0
DESPOWMA:           DB "You are in the powder magazine of this really super "
                        DB "castle.",0
DESEASBA:            DB "You are on the eastern side of the river. A small tunnel "
                        DB "leads north into the cliff face.",0
DESWOOBR:        DB "You stand before a small wooden bridge which crosses the "
                        DB "river.",0
DESRIVCO:        DB "You are in a conduit draining into the river. The water "
                        DB "comes up to your knees and is freezing cold. A narrow "
                        DB "service path leads south.",0

TOKLOO:               DB " look ",0
TOKLIS:               DB " list ",0
TOKHEL:               DB " help ",0
TOKQUI:               DB " quit ",0
TOKGAL:              DB " galar ",0
TOKENAPE:                DB " vard ",0
TOKENGET:                DB " get ",0
TOKDRO:               DB " drop ",0
TOKTAK:               DB " take ",0
TOKINV:             DB " invent ",0
TOKKIL:               DB " kill ",0
TOKATT:             DB " attack ",0
TOKSTA2:             DB " examine ",0
TOKSTA3:             DB " inventory ",0
TOKSTA4:             DB " restart ",0
TOKSTA5:             DB " commands ",0
TOKSAV:               DB " save ",0
TOKLOA:               DB " load ",0
TOKREA:               DB " read ",0
TOKPRA:               DB " pray ",0
TOKSCO:              DB " score ",0
TOKENPUT:                DB " put ",0
TOKUSI:              DB " using ",0
TOKWIT:               DB " with ",0
TOKENCUT:                DB " cut ",0
TOKBRE:              DB " break ",0
TOKUNL:             DB " unlock ",0
TOKOPE:               DB " open ",0
TOKLIG:              DB " light ",0
TOKBUR:               DB " burn ",0
TOKENUP:                 DB " up ",0
TOKDOW:               DB " down ",0
TOKJUM:               DB " jump ",0
TOKSWI:               DB " swim ",0

; Non-object nouns used by some verbs (not part of nounTokenTable 1..24).
TOKDOO:               DB " door ",0
TOKGAT:               DB " gate ",0

TOKNOR:              DB " north ",0
TOKSOU:              DB " south ",0
TOKWES:               DB " west ",0
TOKEAS:               DB " east ",0

; Noun tokens (space-padded) for orderless input scanning (indices 1..24).
TOKWIZ:             DB " wizard ",0
TOKDEM:              DB " demon ",0
TOKTRO:              DB " troll ",0
TOKDRA:             DB " dragon ",0
TOKENBAT:                DB " bat ",0
TOKGOB:             DB " goblin ",0

TOKCOI:               DB " coin ",0
TOKCOM:            DB " compass ",0
TOKBOM:               DB " bomb ",0
TOKRUB:               DB " ruby ",0
TOKDIA:            DB " diamond ",0
TOKPEA:              DB " pearl ",0
TOKSTO:              DB " stone ",0
TOKRIN:               DB " ring ",0
TOKPEN:            DB " pendant ",0
TOKGRA:              DB " grail ",0
TOKSHI:             DB " shield ",0
TOKENBOX:                DB " box ",0
TOKENKEY:                DB " key ",0
TOKSWO:              DB " sword ",0
TOKCAN:             DB " candle ",0
TOKROP:               DB " rope ",0
TOKBRI:              DB " brick ",0
TOKGRI:              DB " grill ",0

MONNAMWI:              DB "an evil "
MONNOUWI:              DB "wizard",0
MONNAMDE:            DB "a fiery "
MONNOUDE:            DB "demon",0
MONNAMTR:            DB "an axe wielding "
MONNOUTR:            DB "troll",0
MONNAMDR:           DB "a fire breathing "
MONNOUDR:           DB "dragon",0
MONNAMBA:              DB "a giant "
MONNOUBA:              DB "bat",0
MONNAMGO:           DB "a snarling "
MONNOUGO:           DB "goblin",0

OBJNAMCO:             DB "a gold "
OBJNOUCO:             DB "coin",0
OBJNAMC1:          DB "a useful looking "
OBJNOUC1:          DB "compass",0
OBJNAMBO:             DB "a home made "
OBJNOUBO:             DB "bomb",0
OBJNAMRU:             DB "a blood red "
OBJNOURU:             DB "ruby",0
OBJNAMDI:          DB "a sparkling "
OBJNOUDI:          DB "diamond",0
OBJNAMPE:            DB "a moon-like "
OBJNOUPE:            DB "pearl",0
OBJNAMST:            DB "an interesting "
OBJNOUST:            DB "stone",0
OBJNAMRI:             DB "a diamond studded "
OBJNOURI:             DB "ring",0
OBJNAMP1:          DB "a magic "
OBJNOUP1:          DB "pendant",0
OBJNAMGR:            DB "a most holy "
OBJNOUGR:            DB "grail",0
OBJNAMSH:           DB "a mirror like "
OBJNOUSH:           DB "shield",0
OBJNAMB1:              DB "a nondescript black "
OBJNOUB1:              DB "box",0
OBJNAMKE:              DB "an old and rusty "
OBJNOUKE:              DB "key",0
OBJNAMSW:            DB "a double-bladed "
OBJNOUSW:            DB "sword",0
OBJNAMCA:           DB "a small "
OBJNOUCA:           DB "candle",0
OBJNAMRO:             DB "a thin and tatty "
OBJNOURO:             DB "rope",0
OBJNAMBR:            DB "a red house "
OBJNOUBR:            DB "brick",0
OBJNAMG1:            DB "a rusty ventilation "
OBJNOUG1:            DB "grill",0

VARDCLUE: DB "The keeper stands in four stones, from left to right: V, A, R, D. Speak his name, and the eastern seal shall yield.",0

DECDIV: DW 10000,1000,100,10,1

WINMSG: DB "The lost hoard of Svartalfheim is safe in your hut. Your quest is complete!",0
LONGMSG: DB 13,10,"That command is too long; please use at most 31 characters.",0
