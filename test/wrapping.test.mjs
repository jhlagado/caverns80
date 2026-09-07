import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

function call(g,name){
 const cpu=g.runtime.cpu,top=g.symbols.StackTop??g.symbols.STACKTOP;
 cpu.pc=g.symbols[name];assert.notEqual(cpu.pc,undefined,name);
 cpu.sp=top-2;g.memory[cpu.sp]=g.memory[cpu.sp+1]=0;
 const before=g.output.length;const result=g.run();assert(result.exited);assert.equal(cpu.sp,top);
 return g.output.slice(before);
}
function print(g,text){const address=0xb000;g.memory.set(Buffer.from(text+'\0','ascii'),address);g.runtime.cpu.h=address>>8;g.runtime.cpu.l=address&255;return call(g,'term_puts');}
function raw(g,ch){g.runtime.cpu.a=ch;return call(g,'term_putc');}

test('word wrapping preserves normal words and bounds descriptions to78columns',async()=>{
 const g=await createMachine();
 const prose=('The lantern illuminates ancient carvings beside the winding underground river. ').repeat(12);
 const out=print(g,prose);
 assert.deepEqual(out.trim().split(/\s+/),prose.trim().split(/\s+/));
 for(const line of out.split('\r\n'))assert(line.length<=78,`line length ${line.length}`);
 assert(out.includes('\r\n'));
});

test('wrapping tracks composed output and raw CR LF and backspace',async()=>{
 const g=await createMachine();
 assert.equal(print(g,'a'.repeat(70)), 'a'.repeat(70));
 assert.equal(print(g,' elephant'), ' \r\nelephant');
 raw(g,13);assert.equal(g.memory[g.symbols.TERCOL],0);
 print(g,'a'.repeat(77));raw(g,8);assert.equal(g.memory[g.symbols.TERCOL],76);
 assert.equal(print(g,'xy'),'xy');assert.equal(g.memory[g.symbols.TERCOL],78);
 raw(g,10);assert.equal(g.memory[g.symbols.TERCOL],0);
 raw(g,8);assert.equal(g.memory[g.symbols.TERCOL],0);
 assert.equal(print(g,'  indented title'),'  indented title');
});

test('long unbroken words make bounded progress and output preserves registers',async()=>{
 const g=await createMachine(),cpu=g.runtime.cpu;
 const text='x'.repeat(240);g.memory.set(Buffer.from(text+'\0'),0xb000);
 Object.assign(cpu,{a:0x5a,b:0x12,c:0x34,d:0x56,e:0x78,h:0xb0,l:0,ix:0x2468,iy:0x3579});
 const names=['a','b','c','d','e','h','l','ix','iy'];const before=Object.fromEntries(names.map(n=>[n,cpu[n]]));
 Object.assign(cpu.flags,{S:1,Z:0,Y:1,H:1,X:0,P:1,N:1,C:1});
 const flags={...cpu.flags};
 const out=call(g,'term_puts');
 assert.equal(out.replaceAll('\r\n',''),text);
 assert.deepEqual(out.split('\r\n').map(s=>s.length),[78,78,78,6]);
 assert.deepEqual(Object.fromEntries(names.map(n=>[n,cpu[n]])),before);assert.deepEqual(cpu.flags,flags);
 const rawBefore=Object.fromEntries(names.map(n=>[n,cpu[n]]));
 call(g,'term_putc');assert.deepEqual(Object.fromEntries(names.map(n=>[n,cpu[n]])),rawBefore);assert.deepEqual(cpu.flags,flags);
});
