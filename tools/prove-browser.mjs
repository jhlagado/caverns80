// Fresh, isolated browser contexts only. Never opens a user's browser profile.
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {resolve,join} from 'node:path';
import {pathToFileURL} from 'node:url';
import os from 'node:os';
import {createMachine} from '../test/support/machine.mjs';
import {proveFullRoute} from '../test/support/full-route.mjs';
assert(process.env.TRIPTYCH_ROOT,'Set TRIPTYCH_ROOT to the qualified Triptych checkout');
const consumer=resolve(process.env.TRIPTYCH_ROOT);
const {chromium}=createRequire(pathToFileURL(join(consumer,'package.json')))('@playwright/test');
const {readCpm22File,CPM22_LOGICAL_BYTES,CPM22_BACKING_BYTES}=await import(pathToFileURL(join(consumer,'tools/lib/cpm22-disk.mjs')));
const manifest=JSON.parse(await readFile(new URL('../build/manifest.json',import.meta.url)));
const sha=b=>createHash('sha256').update(b).digest('hex');
assert.equal(sha(await readFile(new URL('../build/CAVERNS.COM',import.meta.url))),manifest.sha256);
const url=process.env.CAVERNS_URL??'https://jhlagado.github.io/triptych/';
const out=resolve(process.env.CAVERNS_REPORT_DIR??new URL('../build/browser-proof',import.meta.url).pathname);
await mkdir(out,{recursive:true});
const save=async(name,data)=>writeFile(join(out,name),JSON.stringify(data,null,2)+'\n');
const get=async name=>{const r=await fetch(new URL(name,url),{cache:'no-store'});assert(r.ok,`${name}: ${r.status}`);return Buffer.from(await r.arrayBuffer());};
const catalog=JSON.parse(await get('tool-catalog.json'));
const game=catalog.tools.find(t=>t.id==='caverns80');assert(game,'Caverns absent from hosted catalog');
assert.equal(game.raw.sha256,manifest.sha256);assert.equal(game.raw.bytes,manifest.bytes);
const asset=await get(game.asset),disk=await get('cpm22.img');
assert.equal(sha(asset),game.padded.sha256);assert.equal(sha(asset.subarray(0,manifest.bytes)),manifest.sha256);
assert.equal(sha(disk),catalog.distribution.diskSha256);
assert.deepEqual(Buffer.from(readCpm22File(disk,'CAVERNS.COM')),asset);
await save('assets.json',{status:'passed',url,observedAt:new Date().toISOString(),version:manifest.version,distribution:catalog.distribution,game,diskSha256:sha(disk)});
const route=proveFullRoute(await createMachine()).route;
assert.equal(route.length,147,'review a changed route before changing this acceptance count');
const browser=await chromium.launch();let pages=0;
const text=p=>p.locator('#terminal').textContent();
async function until(p,expected){
 for(let i=0;i<20;i++){
  await p.waitForFunction(expected=>{const last=document.querySelector('#terminal').textContent.split('\n').map(s=>s.trimEnd()).filter(Boolean).at(-1);return last===expected||last==='[Space/Enter: more, Q: skip]';},expected);
  const before=await text(p);if(!before.trimEnd().endsWith('[Space/Enter: more, Q: skip]'))return;
  pages++;await p.locator('#terminal').focus();await p.keyboard.press('Space');
  await p.waitForFunction(before=>document.querySelector('#terminal').textContent!==before,before);
 }
 throw Error('pagination did not finish');
}
async function command(p,cmd,expected='?'){
 await p.locator('#terminal').focus();await p.keyboard.type(cmd);
 // Await echo on the current input line, not an earlier copy in the transcript.
 await p.waitForFunction(cmd=>document.querySelector('#terminal').textContent.split('\n').map(s=>s.trimEnd()).filter(Boolean).at(-1)?.endsWith(cmd),cmd);
 const start=performance.now();await p.keyboard.press('Enter');await until(p,expected);
 return {command:cmd,elapsedMs:performance.now()-start};
}
async function quit(p){await command(p,'QUIT','Another adventure?');await command(p,'N','A>');await p.waitForFunction(()=>document.querySelector('#save-status').textContent.includes('saved in this browser'));}
async function manage(p){await p.locator('#files').click();await p.locator('#saved-and-exited').check();await p.locator('#begin-management').click();await p.waitForFunction(()=>document.querySelector('#files-status').textContent.includes('CPU paused.'));}
async function apply(p){await p.locator('#commit-disk').click();await p.waitForFunction(()=>document.querySelector('#files-status').textContent.includes('Disk committed'));await p.locator('#close-files').click();await until(p,'A>');}
async function importDisk(p,path){await manage(p);await p.waitForFunction(()=>!document.querySelector('#disk-input').disabled);await p.locator('#disk-input').setInputFiles(path);await apply(p);}
async function download(p,name){const event=p.waitForEvent('download');await p.locator('#download').click();const d=await event;const path=join(out,name);await d.saveAs(path);return readFile(path);}
async function fresh(){const context=await browser.newContext({viewport:{width:1280,height:1000}});const p=await context.newPage();await p.goto(url);await until(p,'A>');return p;}
try{
 const p=await fresh();await command(p,'CAVERNS');assert(pages>=2);
 const samples=[];for(const cmd of route)samples.push(await command(p,cmd));
 assert.match(await text(p),/quest is complete/);await command(p,'SCORE');assert.match(await text(p),/You have a score of 126/);
 const helpTiming=await command(p,'HELP');
 const saveTiming=await command(p,'SAVE WEBWIN');assert.match(await text(p),/Game saved/);await quit(p);
 await p.reload();await until(p,'A>');await command(p,'CAVERNS');const loadTiming=await command(p,'LOAD WEBWIN');assert.match(await text(p),/Game loaded/);
 await command(p,'SCORE');assert.match(await text(p),/You have a score of 126/);await quit(p);
 const savedDisk=await download(p,'winning-save.img');
 const other=await fresh();await importDisk(other,join(out,'winning-save.img'));
 await command(other,'CAVERNS');await command(other,'LOAD WEBWIN');assert.match(await text(other),/Game loaded/);
 await command(other,'LOOK');await command(other,'SCORE');assert.match(await text(other),/You have a score of 126/);
 await other.screenshot({path:join(out,'reimported-win.png'),fullPage:true});
 const sorted=samples.map(s=>s.elapsedMs).sort((a,b)=>a-b);
 const report={status:'passed',url,observedAt:new Date().toISOString(),version:manifest.version,comSha256:manifest.sha256,distribution:catalog.distribution,browserVersion:browser.version(),host:{platform:os.platform(),release:os.release(),arch:os.arch(),cpu:os.cpus()[0]?.model},commands:samples.length,score:126,pages,auxiliaryTimings:{help:helpTiming,save:saveTiming,load:loadTiming},reload:true,reimportFreshContext:true,continuedAfterImport:true,diskSha256:sha(savedDisk),method:'Enter dispatch to complete observed prompt, including Playwright observation overhead. Human typing/page pauses excluded from ordinary-command samples.',p95Ms:sorted[Math.ceil(sorted.length*.95)-1],maxMs:sorted.at(-1),samples};
 await save('full-game.json',report);
 if(process.env.CAVERNS_OLD_DISK){
  const oldPath=resolve(process.env.CAVERNS_OLD_DISK),old=await readFile(oldPath),u=await fresh();
  const dialogs=[];let dialogError;
  u.on('dialog',async d=>{
   const allowed=['CAVERNS.COM differs from this release. It may be another valid version. Replace it with the verified release?','Replace CAVERNS.COM? A full-disk backup is created when you apply.'];
   if(!allowed.includes(d.message())){dialogError=Error(`Unexpected confirmation: ${d.message()}`);await d.dismiss();return;}
   dialogs.push(d.message());await d.accept();
  });
  await importDisk(u,oldPath);await u.reload();await until(u,'A>');
  assert.deepEqual(await download(u,'old-reopened.img'),old,'reopen must preserve every byte');
  await manage(u);await u.locator('#tool-list li').filter({hasText:'CAVERNS.COM'}).getByRole('button').click();
  if(dialogError)throw dialogError;
  await u.waitForFunction(()=>document.querySelector('#files-status').textContent.includes('Staged CAVERNS.COM'));await apply(u);
  const updated=await download(u,'old-updated.img');assert.deepEqual(Buffer.from(readCpm22File(updated,'CAVERNS.COM')),asset);
  // This optional fixture is the standard 77-track, 26-sector CP/M disk.
  assert([CPM22_LOGICAL_BYTES,CPM22_BACKING_BYTES].includes(old.length),'old fixture must use the standard CP/M image layout (logical or backing-sector padded)');
  const names=new Set();for(let i=0;i<64;i++){const e=old.subarray(52*128+i*32,52*128+(i+1)*32);if(e[0]!==0)continue;const name=Buffer.from(e.subarray(1,9).map(x=>x&127)).toString().trim();const ext=Buffer.from(e.subarray(9,12).map(x=>x&127)).toString().trim();names.add(name+(ext?'.'+ext:''));}
  for(const name of names)if(name!=='CAVERNS.COM')assert.deepEqual(readCpm22File(updated,name),readCpm22File(old,name),name+' preserved');
  assert.deepEqual(updated.subarray(0,52*128),old.subarray(0,52*128),'system tracks preserved');
  const slot=process.env.CAVERNS_OLD_SLOT??'BROWSER';assert(/^[A-Za-z0-9_]{1,8}$/.test(slot));
  await command(u,'CAVERNS');await command(u,`LOAD ${slot}`);assert.match(await text(u),/Game loaded/);
  await command(u,'QUIT','Another adventure?');await command(u,'C');await command(u,'LOOK');
  await save('upgrade.json',{status:'passed',url,observedAt:new Date().toISOString(),comSha256:manifest.sha256,reopenedByteExact:true,oldDiskSha256:sha(old),updatedDiskSha256:sha(updated),preservedFiles:[...names].filter(n=>n!=='CAVERNS.COM'),systemTracksPreserved:true,oldSaveLoaded:true,cancellationResumed:true,dialogs});
 }
 console.log(JSON.stringify({status:'passed',url,version:manifest.version,reportDirectory:out,commands:147,score:126,upgradeChecked:Boolean(process.env.CAVERNS_OLD_DISK)}));
}finally{await browser.close();}
