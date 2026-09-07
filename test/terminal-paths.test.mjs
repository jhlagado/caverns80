import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';

// Branch fixtures deliberately inject encounter state. They are separate from
// the fresh-start ordinary-command playthrough and do not establish reachability.
const cases=[
 {name:'fatal chasm movement',command:'west',message:/fall|chasm|rocks/i,setup(g){g.memory[g.symbols.playerLocation]=7;}},
 {name:'exhausted sword combat',command:'kill troll with sword',message:/swing|skull/i,setup(g){const s=g.symbols;g.memory[s.playerLocation]=10;g.memory[s.objectLocation+19]=255;g.memory[s.swordSwingCount]=31;}},
 {name:'hostile creature attack',command:'north',message:/killed/i,setup(g){const s=g.symbols;g.memory[s.playerLocation]=10;g.memory[s.rngState]=0;g.memory[s.rngState+1]=1;}},
 {name:'explicit quit',command:'quit',message:/score/i,setup(){}},
 {name:'explicit restart',command:'restart',message:/Another adventure/i,setup(){}},
];
for(const path of cases)test(`${path.name} restarts repeatedly and can exit cleanly`,async()=>{
 const g=await createMachine();g.run();const sp=g.runtime.cpu.sp;
 const initial=g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24);
 for(let repeat=0;repeat<3;repeat++){
  path.setup(g);const response=g.command(path.command);
  assert.match(response,path.message);assert.match(response,/Another adventure/i);
  assert.equal(g.exited,false);
  const restarted=g.command('y');assert.match(restarted,/darkened room/);assert.match(restarted,/\? $/);
  assert.equal(g.byte('playerLocation'),1);
  assert.equal(g.byte('turnCounter'),0);assert.equal(g.memory[g.symbols.turnCounter+1],0);
  assert.deepEqual(g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24),initial);
  assert.equal(g.runtime.cpu.sp,sp,'restart discards all former activation frames');
 }
 path.setup(g);assert.match(g.command(path.command),/Another adventure/i);
 g.command('n');assert.equal(g.exited,true);
 assert.equal(g.runtime.cpu.pc,5,'exit reaches BDOS warm boot');
 assert.equal(g.runtime.cpu.c,0);assert.equal(g.runtime.cpu.sp,g.symbols.StackTop-2);
});

test('Ctrl-C exits from both ordinary input and restart confirmation',async()=>{
 for(const confirmation of [false,true]){
  const g=await createMachine();g.run();if(confirmation)assert.match(g.command('quit'),/Another adventure/i);
  g.send('\x03');assert.equal(g.exited,true);assert.equal(g.runtime.cpu.c,0);assert.equal(g.runtime.cpu.sp,g.symbols.StackTop-2);
 }
});

test('full victory remains possible after safe physical exploration detours',async()=>{
 const baseline=proveFullRoute(await createMachine());const g=await createMachine();const original=g.command.bind(g);const seen=new Set();
 g.command=text=>{
  const room=g.byte('playerLocation');
  if((room===2||room===6)&&!seen.has(room)){
   seen.add(room);const route=room===2?['west','east']:['east','west'];
   for(const command of route){const out=original(command);assert.doesNotMatch(out,/Another adventure/i);assert.match(out,/\? $/);}
   assert.equal(g.byte('playerLocation'),room,'physical detour returns to origin');
  }
  return original(text);
 };
 const replay=proveFullRoute(g);assert.equal(seen.size,2);
 assert.deepEqual(replay.checkpoints,baseline.checkpoints,'detours preserve route outcomes');
 assert.equal(g.byte('candleIsLitFlag'),1,'four extra movement turns leave sufficient candle life');
 assert.equal(g.byte('score'),126);
});
