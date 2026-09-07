import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
const prompt='[Space/Enter: more, Q: skip] ';
test('story waits at bounded pages until the player continues',async()=>{
 const g=await createMachine({autoPage:false});g.run();
 let previous=0,pages=0;
 while(g.output.endsWith(prompt)){
  const page=g.output.slice(previous);
  assert(page.split('\r\n').length<=25,'page fits terminal height');
  previous=g.output.length;pages++;
  g.send(pages%2?' ':'\r');
  assert(pages<20,'paging makes progress');
 }
 assert(pages>=2,'long story really pauses');
 assert.match(g.output,/\? $/);
 assert.equal(g.byte('playerLocation'),1);
 assert.equal(g.byte('turnCounter'),0);
 assert.match(g.command('get compass'),/taken/);
});
test('Q skips the remainder and HELP can be paged again without spending a turn',async()=>{
 const g=await createMachine({autoPage:false});g.run();assert(g.output.endsWith(prompt));
 g.send('q');assert.match(g.output,/\? $/);const sp=g.runtime.cpu.sp;
 const text=g.command('help');assert(text.endsWith(prompt));
 g.send('Q');assert.match(g.output,/\? $/);
 assert.equal(g.runtime.cpu.sp,sp);assert.equal(g.byte('turnCounter'),0);
 assert.match(g.command('inventory'),/You are carrying/);
});
test('Ctrl-C at a page prompt exits to CP/M',async()=>{
 const g=await createMachine({autoPage:false});g.run();assert(g.output.endsWith(prompt));
 g.send('\x03');assert.equal(g.exited,true);
});
