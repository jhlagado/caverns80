import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';

function state(g){
 const fields=['playerLocation','candleIsLitFlag','bridgeCondition','drawbridgeState','waterExitLocation','gateDestination','teleportDestination','secretExitLocation','generalFlagJ','hostileCreatureIndex','fearCounter','swordSwingCount'];
 return [...fields.map(n=>g.byte(n)),...g.memory.slice(g.symbols.turnCounter,g.symbols.turnCounter+2),...g.memory.slice(g.symbols.rngState,g.symbols.rngState+2),...g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24)];
}
function safe(g,text){const out=g.command(text);assert.equal(g.exited,false);assert.doesNotMatch(out,/Another adventure/i,text);assert.match(out,/\? $/,text);return out;}

test('every full-route action replays identically across disk save and restore',async()=>{
 const plain=await createMachine();const expected=[];const plainCommand=plain.command.bind(plain);
 plain.command=text=>{const out=plainCommand(text);expected.push(state(plain));return out;};
 const baseline=proveFullRoute(plain);
 const g=await createMachine();const original=g.command.bind(g);let index=0;
 g.command=text=>{
  const slot=`R${index}`,before=state(g);
  assert.match(original(`save ${slot}`),/Game saved to disk/);
  assert.deepEqual(state(g),before,`save before ${text}`);
  const first=original(text),after=state(g);
  assert.deepEqual(after,expected[index],`baseline after ${index}: ${text}`);
  assert.match(original(`load ${slot}`),/Game loaded/);
  assert.deepEqual(state(g),before,`restore before ${index}: ${text}`);
  const replay=original(text);
  assert.equal(replay,first,`identical narrative and RNG after reload: ${text}`);
  assert.deepEqual(state(g),after,`identical state after replay: ${text}`);
  // Save and restore the committed side of each transition as well.
  const afterSlot=`P${index}`;
  assert.match(original(`save ${afterSlot}`),/Game saved to disk/);
  assert.match(original(`load ${afterSlot}`),/Game loaded/);
  assert.deepEqual(state(g),after,`committed transition survives reload: ${text}`);
  index++;return replay;
 };
 const actual=proveFullRoute(g);
 assert.deepEqual(actual.checkpoints,baseline.checkpoints);
 assert.equal(index,baseline.route.length);
});

test('oak-door and demon puzzles can precede the first treasure banking trip',async()=>{
 const baseline=proveFullRoute(await createMachine());
 const g=await createMachine();g.run();let early=false,banked=false;
 const obj=id=>g.memory[g.symbols.objectLocation+id-1];
 for(const text of baseline.route){
  if(text==='light bomb with candle'||text==='kill demon with sword')continue;
  safe(g,text);
  if(text==='galar'&&!early){
   assert.equal(banked,false);assert.equal(obj(9),255);
   for(const command of ['south','west','north','west','north','light bomb with candle','east'])safe(g,command);
   assert.equal(g.byte('playerLocation'),19);assert.equal(obj(9),0);
   for(let tries=0;tries<12&&obj(2)!==0;tries++)safe(g,'kill demon with sword');
   assert.equal(obj(2),0,'demon defeated before banking');
   for(const command of ['west','south','east','south','east','north'])safe(g,command);
   assert.equal(g.byte('playerLocation'),16);early=true;
  }
  if(text==='drop coin'){assert(early,'door solved before first deposit');banked=true;}
 }
 assert(early&&banked);
 assert.equal(g.byte('score'),126);
 for(const id of [7,8,10,11,12,13,14,15,16,17])assert.equal(obj(id),1);
 assert.equal(obj(9),0);
});
