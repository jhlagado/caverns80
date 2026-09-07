import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

async function encounter(carried){
 const g=await createMachine();g.run();const s=g.symbols,m=g.memory;
 m[s.playerLocation]=10;m.fill(0,s.objectLocation,s.objectLocation+6);m[s.objectLocation+2]=10;
 m[s.objectLocation+19]=carried?255:7;
 // LFSR2 produces1: the monster's ordinary attack misses safely.
 m[s.rngState]=2;m[s.rngState+1]=0;
 return g;
}

test('mentioning an uncarried sword in either noun slot does not suppress monster attack',async()=>{
 for(const command of ['north sword','north coin sword']){
  const g=await encounter(false),before=g.runtime.cpu.sp;
  assert.match(g.command(command),/creature lunges/,command);
  assert.equal(g.memory[g.symbols.rngState],1,'one actual attack draw');
  assert.equal(g.byte('playerLocation'),9,'successful dodge permits movement');
  assert.equal(g.runtime.cpu.sp,before,'attack returns through the movement command');
  assert.equal(g.memory[g.symbols.objectLocation+19],7,'words do not acquire the sword');
 }
});

test('a carried sword retains the existing mentioned-tool defense',async()=>{
 for(const command of ['north sword','north coin sword']){
  const g=await encounter(true);assert.doesNotMatch(g.command(command),/creature lunges/);
  assert.equal(g.memory[g.symbols.rngState],2,'defense consumes no attack draw');
  assert.equal(g.byte('playerLocation'),9);
 }
});
