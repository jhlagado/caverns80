import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';

test('fresh ordinary-command victory and post-victory exploration visit all 54 rooms',async()=>{
 const g=await createMachine();const victory=proveFullRoute(g);
 const visited=new Set([1,...victory.checkpoints.map(c=>c.room)]);
 const step=(command,room)=>{
  const out=g.command(command);
  assert.equal(g.exited,false);assert.doesNotMatch(out,/Another adventure/i);
  assert.match(out,/\? $/);assert.equal(g.byte('playerLocation'),room,`after ${command}`);
  visited.add(room);return out;
 };
 step('galar',16);step('east',17);
 assert.match(step('look',17),/Thialfi/i,'dead-end inscription is visible before bat transport');
 const carried=step('west',33);
 assert.match(carried,/bat.*picked|bat.*carr/i,'bat transport explicitly overrides requested movement');
 assert.equal(g.memory[g.symbols.objectLocation+4],24,'bat relocation remains valid');
 step('north',29);step('east',26);step('east',25);
 step('west',26);step('south',27);step('east',28);
 step('get rope',28);step('down with rope',35);
 step('east',36);step('north',39);step('west',38);step('north',43);step('east',44);
 assert.deepEqual([...visited].sort((a,b)=>a-b),Array.from({length:54},(_,i)=>i+1));
 assert.equal(g.byte('candleIsLitFlag'),1,'full physical tour remains lit');
 assert.match(step('score',44),/126/,'exploration preserves completed treasure score');
 for(const id of [7,8,10,11,12,13,14,15,16,17])assert.equal(g.memory[g.symbols.objectLocation+id-1],1);
});
