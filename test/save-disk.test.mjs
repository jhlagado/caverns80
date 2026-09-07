import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
function gameplay(g){const names=['playerLocation','candleIsLitFlag','bridgeCondition','drawbridgeState','waterExitLocation','gateDestination','teleportDestination','secretExitLocation','generalFlagJ','hostileCreatureIndex','fearCounter','swordSwingCount'];return [...names.map(n=>g.byte(n)),...g.memory.slice(g.symbols.turnCounter,g.symbols.turnCounter+2),...g.memory.slice(g.symbols.rngState,g.symbols.rngState+2),...g.memory.slice(g.symbols.objectLocation,g.symbols.objectLocation+24)];}
async function boot(options){const g=await createMachine(options);g.run();return g;}
async function saved(){const g=await boot();assert.match(g.command('save'),/Game saved to disk/);assert.equal(g.dma,128);return g.files.get('CAVERNS.SAV').slice();}

test('disk default and named slots roundtrip state without spending a turn',async()=>{
 const g=await boot();const before=gameplay(g);
 assert.match(g.command('save'),/Game saved to disk/);assert.deepEqual(gameplay(g),before);
 assert.equal(g.files.get('CAVERNS.SAV').length,128);
 g.command('get compass');assert.notDeepEqual(gameplay(g),before);
 assert.match(g.command('load'),/Game loaded/);assert.deepEqual(gameplay(g),before);
 assert.match(g.command('save abc_1234'),/Game saved to disk/);assert(g.files.has('ABC_1234.SAV'));
 assert.match(g.command('  save spaced'),/Game saved to disk/);assert(g.files.has('SPACED.SAV'));
 assert.equal(g.dma,128);
});

test('slot validation and cancelled overwrite never alter files or gameplay',async()=>{
 const original=await saved();const g=await boot({files:{'CAVERNS.SAV':original}}),before=gameplay(g);
 for(const bad of ['a.b','a:b','123456789','abc def','a*'])assert.match(g.command('save '+bad),/1-8/);
 assert.match(g.command('save'),/Replace/);g.command('n');
 assert.deepEqual(g.files.get('CAVERNS.SAV'),original);assert.deepEqual(gameplay(g),before);
 assert.equal(g.files.size,1);assert.equal(g.dma,128);
});

test('overwrite keeps the previous committed save as backup',async()=>{
 const original=await saved();const g=await boot({files:{'CAVERNS.SAV':original}});
 g.command('get compass');const before=gameplay(g);assert.match(g.command('save'),/Replace/);
 assert.match(g.command('y'),/Game saved to disk/);
 assert.deepEqual(g.files.get('CAVERNS.BAK'),original);assert.notDeepEqual(g.files.get('CAVERNS.SAV'),original);
 assert(!g.files.has('CAVERNS.$$$'));assert.deepEqual(gameplay(g),before);assert.equal(g.dma,128);
});

test('missing and malformed saves leave live game unchanged',async()=>{
 const original=await saved();for(const data of [undefined,new Uint8Array(0),original.slice(0,127),new Uint8Array(256),original.map((v,i)=>i===50?v^1:v)]){
  const g=await boot({files:data?{'CAVERNS.SAV':data}:{}}),before=gameplay(g);
  assert.match(g.command('load'),/No valid save/);assert.deepEqual(gameplay(g),before);assert.equal(g.dma,128);
 }
});

test('recovery requires confirmation and never deletes sole valid backup or temporary',async()=>{
 const original=await saved();for(const extension of ['BAK','$$$']){
  const name='CAVERNS.'+extension,g=await boot({files:{[name]:original}});
  g.command('get compass');const altered=gameplay(g);
  assert.match(g.command('save'),/needs recovery/);assert.deepEqual(g.files.get(name),original);
  assert.match(g.command('load'),/Recover/);g.command('n');assert.deepEqual(gameplay(g),altered);
  assert.match(g.command('load'),/Recover/);assert.match(g.command('y'),/Game loaded/);
  assert.equal(g.memory[g.symbols.objectLocation+7],1);assert.deepEqual(g.files.get(name),original);assert.equal(g.dma,128);
 }
});

test('every replacement disk-call failure retains original save bytes and live state',async()=>{
 const original=await saved();const oldBackup=original.slice();
 const options={files:{'CAVERNS.SAV':original,'CAVERNS.BAK':oldBackup}};
 const baseline=await boot(options);baseline.command('get compass');baseline.command('save');baseline.command('y');
 assert.match(baseline.output,/Game saved to disk/);
 const occurrence=new Map();
 for(const call of baseline.diskCalls){const n=(occurrence.get(call.fn)??0)+1;occurrence.set(call.fn,n);if(![16,19,20,21,22,23].includes(call.fn))continue;
  const g=await boot({...options,diskFault:{fn:call.fn,occurrence:n,status:call.fn===20||call.fn===21?2:255}});
  g.command('get compass');const before=gameplay(g);
  const response=g.command('save');if(response.includes('Replace'))g.command('y');
  assert.deepEqual(gameplay(g),before,`live state fn${call.fn} call${n}`);
  assert([...g.files.values()].some(bytes=>Buffer.from(bytes).equals(Buffer.from(original))),`recoverable original fn${call.fn} call${n}`);
  assert.equal(g.dma,128);
 }
});

test('read-only drive or primary/temporary/backup file blocks save before destructive calls',async()=>{
 const original=await saved();
 for(const name of ['CAVERNS.SAV','CAVERNS.$$$','CAVERNS.BAK']){
  const files={'CAVERNS.SAV':original,[name]:original};
  const g=await boot({files,readOnlyFiles:new Set([name])});g.command('get compass');const before=gameplay(g);
  assert.match(g.command('save'),/Save failed/);
  assert.deepEqual(gameplay(g),before);assert.equal(g.dma,128);
  assert(!g.diskCalls.some(c=>[19,21,22,23].includes(c.fn)),`protected ${name} reached mutation`);
  assert.deepEqual(Object.fromEntries(g.files),files);
 }
 const g=await boot({files:{'CAVERNS.SAV':original},readOnlyDrive:true});const before=gameplay(g);
 assert.match(g.command('save'),/Save failed/);assert.deepEqual(gameplay(g),before);
 assert(!g.diskCalls.some(c=>[19,21,22,23].includes(c.fn)));assert.equal(g.dma,128);
});

test('after-effect failures retain recoverable saves across a fresh game process',async()=>{
 const original=await saved(),files={'CAVERNS.SAV':original,'CAVERNS.BAK':original};
 const baseline=await boot({files});baseline.command('get compass');baseline.command('save');baseline.command('y');
 const replacement=baseline.files.get('CAVERNS.SAV').slice(),count=new Map();
 for(const call of baseline.diskCalls){
  const occurrence=(count.get(call.fn)??0)+1;count.set(call.fn,occurrence);
  if(![16,19,21,22,23].includes(call.fn))continue;
  const g=await boot({files,diskFault:{fn:call.fn,occurrence,status:call.fn===21?2:255,afterEffect:true}});
  g.command('get compass');const before=gameplay(g);const response=g.command('save');if(response.includes('Replace'))g.command('y');
  assert.deepEqual(gameplay(g),before,`after-effect fn${call.fn}/${occurrence}`);
  assert.equal(g.dma,128);
  const recovered=await boot({files:Object.fromEntries(g.files)});
  let text=recovered.command('load');if(text.includes('Recover'))text+=recovered.command('y');
  assert.match(text,/Game loaded/,`fresh process recovery fn${call.fn}/${occurrence}`);
  const chosen=g.files.get('CAVERNS.SAV')??g.files.get('CAVERNS.BAK');
  assert(chosen&&[original,replacement].some(record=>Buffer.from(record).equals(Buffer.from(chosen))));
  assert.equal(recovered.dma,128);
 }
});
