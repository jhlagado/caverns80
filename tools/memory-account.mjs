// Read-only accounting of the assembled extent. No build or source mutation.
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
const root=new URL('../',import.meta.url);
const json=async path=>JSON.parse(await readFile(new URL(path,root),'utf8'));
const manifest=await json('build/manifest.json');
const debug=await json('build/CAVERNS.d8.json');
const binary=await readFile(new URL('build/CAVERNS.COM',root));
const hash=bytes=>createHash('sha256').update(bytes).digest('hex');
assert.equal(binary.length,manifest.bytes);assert.equal(hash(binary),manifest.sha256);
const symbols=new Map(debug.symbols.filter(s=>s.kind==='label').map(s=>[s.name,s.address]));
const addr=name=>{assert(symbols.has(name),`missing symbol ${name}`);return symbols.get(name);};
const ranges=[
 ['stack',addr('STABOT'),addr('STACKTOP')],
 ['inputBuffers',addr('INPBUF'),addr('RNGSTATE')],
 ['saveCandidate',addr('SVBUF'),addr('SVBUFEND')],
 ['diskBuffers',addr('SDFMAIN'),addr('SDHAD')],
 ['diskStatus',addr('SDHAD'),addr('SDSTATUS')+1],
 ['consoleState',addr('TERCOL'),addr('TERCOL')+1],
 ['gameAndParserState',addr('WORSTA'),addr('INPBUF')],
 ['randomState',addr('RNGSTATE'),addr('SVBUF')],
 ['inputAndPagerState',addr('INPOVER'),addr('WOREND')],
];
const start=manifest.loadAddress,end=start+binary.length;
assert.deepEqual(debug.segments,[{start,end}]);
assert.equal(addr('PROEND'),end);assert.equal(addr('STACKTOP'),end);
assert.equal(addr('STACKTOP')-addr('STABOT'),manifest.memory.stackBytes);
const cells=Array(binary.length).fill(null),totals={instructions:0,immutableData:0};
for(const [name,lo,hi]of ranges){assert(lo>=start&&hi<=end&&lo<hi,name);totals[name]=0;}
for(const [file,entry]of Object.entries(debug.files)){
 const path=`src/${file}`,source=await readFile(new URL(path,root),'utf8');
 assert.equal(hash(source),manifest.sourceFiles[path],`stale source: ${file}`);
 const lines=source.split(/\r?\n/);
 for(const seg of entry.segments??[]){
  const statement=lines[seg.line-1].replace(/^\s*[A-Za-z_][A-Za-z_0-9]*:\s*/,'').trimStart();
  const directive=/^(DB|DW|DS)\b/i.exec(statement)?.[1].toUpperCase();
  for(let at=seg.start;at<seg.end;at++){
   assert(at>=start&&at<end,`out-of-extent ${file}:${seg.line}`);
   assert.equal(cells[at-start],null,`duplicate emission at ${at}`);
   const matches=ranges.filter(([,lo,hi])=>at>=lo&&at<hi);
   assert(matches.length<=1,`overlapping writable ranges at ${at}`);
   let category;
   if(matches.length){assert(directive,`instruction in writable range ${file}:${seg.line}`);category=matches[0][0];}
   else {assert.notEqual(directive,'DS',`unclassified reservation ${file}:${seg.line}`);category=directive?'immutableData':'instructions';}
   cells[at-start]=category;totals[category]++;
  }
 }
}
assert(cells.every(Boolean),'unmapped emitted bytes');
assert.equal(Object.values(totals).reduce((a,b)=>a+b,0),manifest.bytes);
const workspaceBytes=Object.entries(totals).filter(([k])=>!['instructions','immutableData','stack'].includes(k)).reduce((n,[,v])=>n+v,0);
console.log(JSON.stringify({format:'caverns-memory-account-v1',artifactSha256:manifest.sha256,version:manifest.version,start,endExclusive:end,allocatedBytes:manifest.bytes,instructionBytes:totals.instructions,immutableDataBytes:totals.immutableData,workspaceBytes,stackBytes:totals.stack,workspaceBreakdown:Object.fromEntries(Object.entries(totals).filter(([k])=>!['instructions','immutableData','stack'].includes(k))),method:'Emitted source-line extents from native ATOM debug map, classified by DB/DW/DS directives and explicit writable symbol ranges; source hashes and COM identity verified against manifest. All partitions are disjoint and cover every emitted byte.'},null,2));
