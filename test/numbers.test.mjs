import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

test('decimal output covers every byte and word boundaries',async()=>{
 const game=await createMachine();
 function print(name,value,word=false){
  const cpu=game.runtime.cpu,top=game.symbols.StackTop;
  cpu.pc=game.symbols[name];cpu.sp=top-2;
  game.memory[cpu.sp]=game.memory[cpu.sp+1]=0;
  cpu.a=value&255;cpu.h=word?value>>>8:0;cpu.l=value&255;
  const before=game.output.length;game.run();
  assert.equal(cpu.sp,top);return game.output.slice(before);
 }
 for(let n=0;n<256;n++)assert.equal(print('printByteDecA',n),String(n));
 for(const n of [0,1,9,10,99,100,255,256,999,1000,9999,10000,32767,32768,65534,65535])assert.equal(print('PRIWOR',n,true),String(n));
});
