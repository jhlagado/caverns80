import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

// Invoke the real assembled routine, with a private sentinel return address.
// This bypasses only console parsing; all codec execution is Z80 code.
function invoke(game,name){
 const {cpu}=game.runtime,m=game.memory;
 const start=game.symbols[name];assert.notEqual(start,undefined,`missing ${name}`);
 const top=game.symbols.StackTop??game.symbols.STACKTOP;
 cpu.sp=top-2;m[cpu.sp]=0;m[cpu.sp+1]=0xf0;cpu.pc=start;
 const ix=cpu.ix,iy=cpu.iy;
 for(let i=0;i<200000;i++){
  if(cpu.pc===0xf000){assert.equal(cpu.sp,top,'balanced codec return');assert.equal(cpu.ix,ix);assert.equal(cpu.iy,iy);return cpu.a;}
  assert.notEqual(cpu.pc,5,'codec must not perform BDOS');game.runtime.step();
 }
 assert.fail(`codec budget: ${name}`);
}
const fields=['playerLocation','candleIsLitFlag','bridgeCondition','drawbridgeState','waterExitLocation','gateDestination','teleportDestination','secretExitLocation','generalFlagJ','hostileCreatureIndex','fearCounter','swordSwingCount','reshowFlag','score'];
function state(game){return [...fields.map(n=>game.byte(n)),...game.memory.slice(game.symbols.turnCounter,game.symbols.turnCounter+2),...game.memory.slice(game.symbols.rngState,game.symbols.rngState+2),...game.memory.slice(game.symbols.objectLocation,game.symbols.objectLocation+24)];}
function crc(record){let c=65535;for(let i=0;i<128;i++){c^=(i===8||i===9?0:record[i])<<8;for(let b=0;b<8;b++)c=((c<<1)^((c&32768)?0x1021:0))&65535;}return c;}
function repair(record){const c=crc(record);record[8]=c&255;record[9]=c>>8;}
async function setup(){const g=await createMachine();g.run();return g;}

test('save codec preserves complete state, turn16 and RNG16 with balanced roundtrip',async()=>{
 const g=await setup(),m=g.memory,s=g.symbols;
 m[s.turnCounter]=0x34;m[s.turnCounter+1]=0x12;
 m[s.rngState]=0x21;m[s.rngState+1]=0x43;
 m[s.bridgeCondition]=128;m[s.drawbridgeState]=49;m[s.waterExitLocation]=43;
 m[s.gateDestination]=39;m[s.teleportDestination]=19;m[s.secretExitLocation]=38;
 m[s.fearCounter]=42;m[s.swordSwingCount]=31;m[s.hostileCreatureIndex]=3;
 const expected=state(g);
 assert.equal(invoke(g,'SVENC'),0);assert.deepEqual(state(g),expected,'encoding leaves live state unchanged');
 const record=m.slice(s.SVBUF,s.SVBUF+128);
 assert.deepEqual([...record.slice(0,8)],[67,86,56,48,1,1,48,0]);
 assert.equal(record[8]|record[9]<<8,crc(record),'independent CRC oracle');
 assert.equal(invoke(g,'SVVALID'),0);
 for(const n of fields)m[s[n]]=0;
 m.fill(0,s.objectLocation,s.objectLocation+24);m.fill(0,s.turnCounter,s.turnCounter+2);m.fill(0,s.rngState,s.rngState+2);
 assert.equal(invoke(g,'SVAPPLY'),0);assert.deepEqual(state(g),expected);
});

test('every single-bit record corruption is rejected without publishing state',async()=>{
 const g=await setup();invoke(g,'SVENC');const p=g.symbols.SVBUF;
 const baseline=g.memory.slice(p,p+128),expected=state(g);
 for(let byte=0;byte<128;byte++)for(let bit=0;bit<8;bit++){
  g.memory.set(baseline,p);g.memory[p+byte]^=1<<bit;
  assert.equal(invoke(g,'SVAPPLY'),1,`corruption ${byte}:${bit}`);
  assert.deepEqual(state(g),expected,`rejected record ${byte}:${bit} mutated state`);
 }
});

test('valid-checksum records still reject bad versions, padding and state ranges atomically',async()=>{
 const g=await setup();invoke(g,'SVENC');const p=g.symbols.SVBUF;
 const baseline=g.memory.slice(p,p+128),expected=state(g);
 const bad=[[4,2],[5,2],[6,47],[7,1],[10,1],[33,1],[35,1],[60,1],[127,1],[16,0],[16,55],[17,2],[22,12],[23,48],[24,40],[25,38],[26,20],[27,37],[28,2],[29,7],[32,2],[34,127],[36,255],[41,55],[42,55],[59,254]];
 for(const [offset,value]of bad){const record=baseline.slice();record[offset]=value;repair(record);g.memory.set(record,p);assert.equal(invoke(g,'SVAPPLY'),1,`invalid field ${offset}`);assert.deepEqual(state(g),expected);}
 const record=baseline.slice();record[20]=record[21]=0;repair(record);g.memory.set(record,p);assert.equal(invoke(g,'SVAPPLY'),1);assert.deepEqual(state(g),expected);
});
