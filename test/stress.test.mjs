import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';

const word=(g,n)=>g.memory[g.symbols[n]]|g.memory[g.symbols[n]+1]<<8;
function guard(g){
 const end=g.symbols.ProgramEnd;
 g.memory.fill(0xA7,end,end+64);
 return ()=>{
  assert(g.memory.slice(end,end+64).every(v=>v===0xA7),'writes beyond program/stack end');
  assert(g.runtime.cpu.sp>=g.symbols.StackBottom&&g.runtime.cpu.sp<=g.symbols.StackTop,'stack remains in reserved region');
 };
}
for(const seed of [1,0x1234,0xACE1,0xFFFF])test(`bounded command stress with seed ${seed}`,async()=>{
 const g=await createMachine();g.run();const check=guard(g);
 g.memory[g.symbols.rngState]=seed&255;g.memory[g.symbols.rngState+1]=seed>>>8;
 let random=seed;
 const commands=['north','south','east','west','galar','look','help','list','read','vard','get compass','get candle','get sword','get grill','get door','drop gate','light bomb with candle','open gate with key','down with rope','kill dragon with sword','kill troll with sword','score','nonsense','quit'];
 for(let i=0;i<180;i++){
  random=(Math.imul(random,1664525)+1013904223)>>>0;
  const command=commands[random%commands.length];
  let response=g.command(command);
  if(/Another adventure\? $/i.test(response)){
   response=g.command('y');
   assert.equal(g.byte('playerLocation'),1,'restart returns to hut, without executing old command');
   assert.equal(word(g,'turnCounter'),0,'restart has no stale action');
  }
  assert.equal(g.exited,false);
  assert.match(response,/\? $/,`seed ${seed} command ${i}: ${command}`);
  assert(g.byte('playerLocation')>=1&&g.byte('playerLocation')<=54);
  for(const [id,loc] of [...g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24)].entries())assert(loc===0||loc===255||(loc>=1&&loc<=54),`invalid object ${id+1}: ${loc}`);
  check();
 }
});

test('full victory tolerates free informational detours before every command',async()=>{
 const plain=await createMachine();const baseline=proveFullRoute(plain);
 const g=await createMachine();g.run();const check=guard(g);const original=g.command.bind(g);
 g.command=text=>{
  for(const info of ['look','help','list']){
   const room=g.byte('playerLocation'),turns=word(g,'turnCounter'),rng=word(g,'rngState');
   const objects=g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24);
   assert.match(original(info),/\? $/);
   assert.equal(word(g,'turnCounter'),turns,`${info} must not consume candle time`);
   assert.equal(word(g,'rngState'),rng,`${info} must not consume combat randomness`);
   assert.equal(g.byte('playerLocation'),room);
   assert.deepEqual(g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24),objects);
   check();
  }
  const response=original(text);check();return response;
 };
 const detours=proveFullRoute(g);
 assert.deepEqual(detours.checkpoints,baseline.checkpoints,'free detours preserve every route outcome');
 assert.equal(word(g,'turnCounter'),word(plain,'turnCounter'));
});
