import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

const snapshot=g=>({
 room:g.byte('playerLocation'),
 objects:[...g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24)],
 turns:[...g.memory.slice(g.symbols.turnCounter,g.symbols.turnCounter+2)],
 rng:[...g.memory.slice(g.symbols.rngState,g.symbols.rngState+2)],
 candle:g.byte('candleIsLitFlag'),score:g.byte('score'),
});
for(const verb of ['quit','restart'])test(`${verb} cancellation preserves progress and returns on the original stack`,async()=>{
 const g=await createMachine();g.run();g.command('get compass');g.command('score');
 const before=snapshot(g),sp=g.runtime.cpu.sp,pc=g.runtime.cpu.pc;
 for(const cancel of ['c','CANCEL','cancel']){
  assert.match(g.command(verb),/C.*cancel/i);
  assert.match(g.command('cabbage'),/don't understand/);
  assert.match(g.command(cancel),/\? $/);
  assert.equal(g.exited,false);assert.deepEqual(snapshot(g),before);
  assert.equal(g.runtime.cpu.sp,sp);assert.equal(g.runtime.cpu.pc,pc);
 }
 assert.match(g.command('inventory'),/compass/i);
});
test('death never permits cancellation back into a dead adventure',async()=>{
 const g=await createMachine();g.run();g.memory[g.symbols.playerLocation]=7;
 assert.match(g.command('west'),/Another adventure/);
 const sp=g.runtime.cpu.sp;
 for(const cancel of ['c','cancel']){
  const out=g.command(cancel);assert.match(out,/don't understand/);
  assert.equal(g.exited,false);assert.equal(g.runtime.cpu.sp,sp);
  assert.doesNotMatch(out,/\? $/);
 }
 g.command('n');assert.equal(g.exited,true);
});
test('READ reveals room17 inscription without spending a turn or moving',async()=>{
 const g=await createMachine();g.run();g.memory[g.symbols.playerLocation]=17;
 const before=snapshot(g),sp=g.runtime.cpu.sp;
 assert.match(g.command('read'),/Sacred Key of Thialfi/);
 assert.deepEqual(snapshot(g),before);assert.equal(g.runtime.cpu.sp,sp);
});
