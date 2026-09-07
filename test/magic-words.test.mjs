import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

// Focused state fixtures complement the ordinary-command full route.
test('crypt inscription, wrong word and repeated bare/SAY spell preserve the puzzle contract',async()=>{
 const g=await createMachine();g.run();
 g.memory[g.symbols.playerLocation]=37;
 const sp=g.runtime.cpu.sp;
 for(const command of ['read','examine stones','x stones']){
  assert.match(g.command(command),/V, A, R, D/);
  assert.equal(g.byte('secretExitLocation'),0);
 }
 g.command('say vord');
 assert.equal(g.byte('secretExitLocation'),0,'wrong word cannot open the seal');
 for(const command of ['say vard','vard','say vard']){
  g.command(command);
  assert.equal(g.byte('secretExitLocation'),38);
  assert.equal(g.byte('playerLocation'),37,'opening the wall does not teleport');
  assert.equal(g.runtime.cpu.sp,sp);
 }
});

test('return spell accepts bare and SAY forms without requiring inscription history',async()=>{
 for(const command of ['galar','say galar']){
  const g=await createMachine();g.run();
  const sp=g.runtime.cpu.sp;
  g.command(command);
  assert.equal(g.byte('playerLocation'),16);
  g.command(command);
  assert.equal(g.byte('playerLocation'),16);
  assert.equal(g.runtime.cpu.sp,sp);
 }
});
