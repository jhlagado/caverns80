import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
test('examination describes present tools without changing progress or exposing absent objects',async()=>{
 const g=await createMachine();g.run();
 const turns=g.byte('turnCounter');
 assert.match(g.command('examine compass'),/needle keeps its bearing/);
 assert.match(g.command('x sword'),/can't see it/);
 g.command('get compass');
 const afterGet=g.byte('turnCounter');
 assert.match(g.command('x compass'),/needle keeps its bearing/);
 assert.equal(g.byte('turnCounter'),afterGet);
 assert.equal(afterGet,turns+1);
});
