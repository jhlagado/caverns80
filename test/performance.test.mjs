import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';

// Guest cycles only: BDOS service time, rendering and disk latency are excluded.
// Limits leave about 20–30% margin over the qualified v0.1.1 baseline.
test('full-route, HELP and save/load guest-cycle costs stay within declared budgets',async()=>{
 const g=await createMachine();const samples=[];
 const command=g.command.bind(g);
 g.command=text=>{const start=g.metrics.cycles;const output=command(text);samples.push(g.metrics.cycles-start);return output;};
 proveFullRoute(g);
 assert.equal(samples.length,147);
 const sorted=[...samples].sort((a,b)=>a-b);
 assert(sorted[Math.ceil(sorted.length*.95)-1]<=500000,'route p95 exceeds 500,000 cycles');
 assert(sorted.at(-1)<=600000,'route maximum exceeds 600,000 cycles');
 g.command('help');assert(samples.at(-1)<=3500000,'HELP exceeds 3,500,000 cycles');
 assert.match(g.command('save PERF'),/Game saved/);
 assert(samples.at(-1)<=400000,'SAVE exceeds 400,000 cycles');
 assert.match(g.command('load PERF'),/Game loaded/);
 assert(samples.at(-1)<=600000,'LOAD exceeds 600,000 cycles');
 assert.equal(g.byte('score'),126);
});
