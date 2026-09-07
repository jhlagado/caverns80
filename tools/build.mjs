import {mkdir,readFile,writeFile,readdir} from 'node:fs/promises';
import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import {assembleAtomProject,materializeAtomGeneration,renderAtomArtifacts} from 'atom-z80';

const root=fileURLToPath(new URL('../src/',import.meta.url));
for(const file of await readdir(root)){
 if(!file.endsWith('.asm'))continue;
 if(!/^[a-z0-9_]{1,8}\.asm$/i.test(file))throw new Error(`${file} is not a CP/M 8.3 ASM filename.`);
 const source=await readFile(new URL('../src/'+file,import.meta.url),'utf8');
 const lines=source.trimEnd().split('\n').length;
 if(lines>500)throw new Error(`${file} has ${lines} lines; split ASM modules at 500 lines.`);
}
const result=await assembleAtomProject({root,entry:'main.asm',target:{start:0x100,capacity:0xdf00},maxInstructions:100_000_000,maxCycles:1_000_000_000});
const bytes=materializeAtomGeneration(result.generation,{base:0x100}).bytes;
const artifacts=renderAtomArtifacts(result,{base:0x100,entryAddress:0x100});
const ledger=JSON.parse(await readFile(new URL('symbol-map.json',import.meta.url),'utf8'));
const emitted=new Set(artifacts.d8.symbols.map(s=>s.name.toUpperCase()));
for(const [name,native] of Object.entries(ledger))assert(emitted.has(native.toUpperCase()),`Stale symbol mapping: ${name} -> ${native}`);
const reverse=new Map(Object.entries(ledger).map(([name,native])=>[native.toUpperCase(),name]));
const symbols=Object.fromEntries(artifacts.d8.symbols.map(s=>[reverse.get(s.name.toUpperCase())??s.name,s.address??s.value]));
const memory={start:256,endExclusive:symbols.ProgramEnd,allocatedBytes:symbols.ProgramEnd-256,stackStart:symbols.StackBottom,stackEndExclusive:symbols.StackTop,stackBytes:symbols.StackTop-symbols.StackBottom,dynamicAllocationBytes:0};
assert.equal(memory.endExclusive,256+bytes.length,'COM includes the complete runtime allocation');
assert.equal(memory.stackBytes,512,'private stack reservation');
assert.equal(memory.stackEndExclusive,memory.endExclusive,'stack is the last allocation');
assert(memory.stackStart>=memory.start&&memory.endExclusive<=0xde00,'allocation fits the smallest supported Triptych resident ceiling');
const out=new URL('../build/',import.meta.url);
await mkdir(out,{recursive:true});
await writeFile(new URL('CAVERNS.COM',out),bytes);
await writeFile(new URL('symbols.json',out),JSON.stringify(symbols,null,2)+'\n');
await writeFile(new URL('CAVERNS.d8.json',out),JSON.stringify(artifacts.d8,null,2)+'\n');
const sourceFiles={};
for(const name of (await readdir(root,{withFileTypes:true})).filter(entry=>entry.isFile()).map(entry=>entry.name).sort()){
 const content=await readFile(new URL('../src/'+name,import.meta.url));
 sourceFiles['src/'+name]=createHash('sha256').update(content).digest('hex');
}
const sourceSha256=createHash('sha256').update(JSON.stringify(sourceFiles)).digest('hex');
const manifest={format:'caverns-build-v1',artifact:'CAVERNS.COM',version:'0.1.1',loadAddress:256,entryAddress:256,bytes:bytes.length,sha256:createHash('sha256').update(bytes).digest('hex'),assembler:{name:'atom-z80',revision:'802b5c2d320bec777f427755ff2d7338e3b80a05'},sourceFormat:'native-atom',memory,sourceSha256,sourceFiles};
await writeFile(new URL('manifest.json',out),JSON.stringify(manifest,null,2)+'\n');
console.log(JSON.stringify(manifest,null,2));
