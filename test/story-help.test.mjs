import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
const flat=s=>s.replace(/\s+/g,' ').trim();
const episodes=[
 'Deep in the icy mountains of northern Iotunheim',
 'The Great Sons of Svartalfheim.',
 'mining for precious minerals which they fashioned into jewellery',
 'merchants and traders came from distant Asgar and Fenris',
 'linked all the mines to a central city',
 'King of the Danes',
 'Royal Palace to work in the foundry',
 'all the inhabitants of Svartalfheim were forced to live within the city walls',
 'all of the elves were dead and their wonderful gifts lost forever',
 'executed several of his courtesans',
 'a goatherd called Peter',
 'a green serpent that breathes flames',
 'a tiny room filled with more gold and silver than he could possibly carry',
 'a tiny ruby ring',
 'they were all killed in a rock fall',
 'stories of its hidden treasures became myths',
 'four hundred years since the days of Peter',
 'a small hut which at one time belonged to a hermit'
];
function invariant(g){const s=g.symbols,m=g.memory;return [...m.slice(s.objectLocation,s.objectLocation+24),...m.slice(s.turnCounter,s.turnCounter+2),...m.slice(s.rngState,s.rngState+2),g.byte('playerLocation'),g.byte('candleIsLitFlag')];}

test('startup includes the whole original story, current rules and author heritage',async()=>{
 const g=await createMachine();assert(g.run().waiting);const text=flat(g.output);
 assert.match(text,/John Hardy \(c\) 1982-83/);assert.match(text,/ZX81 in 1982/);assert.doesNotMatch(text,/1981/);
 for(const episode of episodes)assert(text.includes(episode),episode);
 for(const rule of ['INVENTORY, INVENT, I and LIST','SAVE CAMP and LOAD CAMP','CAVERNS.SAV','HELP repeats this story','KILL DRAGON WITH SWORD'])assert(text.includes(rule),rule);
 assert.doesNotMatch(text,/Use sword|use candle|PLEASE PRESS PLAY/i);
 assert.match(g.output,/\? $/,'no introduction input gate');
 for(const line of g.output.split('\r\n'))assert(line.length<=78,`startup width ${line.length}`);
});

test('HELP repeats identical narrative and rules without changing progress or stack',async()=>{
 const g=await createMachine();g.run();const opening=g.output;
 g.command('get compass');const before=invariant(g),sp=g.runtime.cpu.sp;
 const out=g.command('help'),begin='WELCOME TO CAVERNS!!';
 const startupCopy=opening.slice(opening.indexOf(begin),opening.indexOf('You are standing in a darkened room'));
 const repeated=out.slice(out.indexOf(begin),out.lastIndexOf('? '));
 assert.equal(flat(repeated),flat(startupCopy),'same story/rules path at startup and help');
 assert.deepEqual(invariant(g),before);assert.equal(g.runtime.cpu.sp,sp);
 for(const episode of episodes)assert(flat(out).includes(episode),episode);
 assert.match(g.command('inventory'),/compass/);assert.match(g.command('invent'),/compass/);
 assert.match(g.command('i'),/compass/);assert.match(g.command('list'),/compass/);
});
