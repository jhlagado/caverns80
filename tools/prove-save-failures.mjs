import {createRequire} from 'node:module';
import {readFile,writeFile} from 'node:fs/promises';
import {pathToFileURL} from 'node:url';
import {createHash} from 'node:crypto';
import assert from 'node:assert/strict';
const root=process.env.TRIPTYCH_ROOT;
if(!root)throw Error('Set TRIPTYCH_ROOT to a built Triptych checkout.');
const {buildCpmDistribution}=await import(pathToFileURL(root+'/tools/lib/cpm-distribution.mjs'));
const {installCpm22File}=await import(pathToFileURL(root+'/tools/lib/cpm22-disk.mjs'));
const built=await buildCpmDistribution(root,{allowDirty:true});
const game=await readFile(new URL('../build/CAVERNS.COM',import.meta.url));
const symbols=JSON.parse(await readFile(new URL('../build/symbols.json',import.meta.url)));
const base=installCpm22File(built.disk,{name:'CAVERNS.COM',bytes:game,padByte:26});
const {TriptychCpu}=createRequire(import.meta.url)(root+'/dist/wasm/triptych_host_wasm.js');
const results=[];
for(const mode of ['data-full','directory-full']){
 let disk=base,allocated=0;
 if(mode==='data-full'){
  for(let size=1024;size<=256*1024;size+=1024){
   try{disk=installCpm22File(base,{name:'FILL.BIN',bytes:new Uint8Array(size)});allocated=size;}
   catch(error){assert.match(error.message,/blocks; only/);break;}
  }
 }else{
  for(let i=0;i<100;i++){
   try{disk=installCpm22File(disk,{name:`F${i}.BIN`,bytes:new Uint8Array(1)});allocated++;}
   catch(error){assert.match(error.message,/directory entries; only/);break;}
  }
 }
 assert(allocated>0);
 const cpu=new TriptychCpu(built.bootstrap);cpu.install_drive(0,disk,true);let output='';
 function until(suffix){for(let i=0;i<3000;i++){cpu.run_slice(50000,500000);output+=Buffer.from(cpu.take_serial_output()).toString('latin1');if(output.endsWith(suffix))return;if(output.endsWith('[Space/Enter: more, Q: skip] '))cpu.enqueue_serial_input(Uint8Array.of(32));}throw Error(mode+' timeout: '+output.slice(-500));}
 function command(text,suffix='? '){output='';cpu.enqueue_serial_input(Buffer.from(text+'\r'));until(suffix);return output;}
 try{
  until('A>');command('CAVERNS');command('GET COMPASS');
  const before=[...cpu.read_ram(symbols.objectLocation,24),...cpu.read_ram(symbols.turnCounter,2),...cpu.read_ram(symbols.rngState,2),...cpu.read_ram(symbols.playerLocation,1)];
  const response=command('SAVE');assert.match(response,/Save failed/);
  const after=[...cpu.read_ram(symbols.objectLocation,24),...cpu.read_ram(symbols.turnCounter,2),...cpu.read_ram(symbols.rngState,2),...cpu.read_ram(symbols.playerLocation,1)];
  assert.deepEqual(after,before,'failed save must preserve game progress');
  command('QUIT','Another adventure? ');command('N','A>');
  results.push({mode,allocated,status:'passed',response});
 }finally{cpu.free();}
}
const report={artifactSha256:createHash('sha256').update(game).digest('hex'),method:'Private full-media fixtures; real WASM CP/M BDOS, not injected return codes.',results};
await writeFile(new URL('../build/save-failure-proof.json',import.meta.url),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
