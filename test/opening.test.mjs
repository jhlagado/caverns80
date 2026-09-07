import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

test('CP/M entry reaches a complete opening prompt and empty input stays in game',async()=>{
 const game=await createMachine();
 const result=game.run();
 assert(result.waiting);
 assert.match(game.output,/C A V E R N S/);
 assert.match(game.output,/darkened room/);
 assert.equal(game.byte('playerLocation'),1);
 const sp=game.runtime.cpu.sp;
 game.command('');
 assert.equal(game.exited,false);
 assert.equal(game.byte('playerLocation'),1);
 assert.equal(game.runtime.cpu.sp,sp,'empty input preserves stack depth');
});

test('opening inventory and compass acquisition preserve location table',async()=>{
 const game=await createMachine();game.run();
 const objects=game.symbols.objectLocation;
 const before=game.memory.slice(objects,objects+24);
 const response=game.command('get compass');
 assert.match(response,/taken/);
 const expected=before.slice();expected[7]=255;
 assert.deepEqual(game.memory.slice(objects,objects+24),expected);
 assert.equal(game.byte('playerLocation'),1);
});

test('ordinary-command opening route crosses bridge and reaches the cave candle',async()=>{
 const game=await createMachine();game.run();
 const commands=['get compass','north','west','west','south','west','get sword','east','north','east','east','east','east','south'];
 for(const command of commands)game.command(command);
 assert.equal(game.byte('playerLocation'),10);
 const defeat=(id,name)=>{for(let i=0;i<12&&game.memory[game.symbols.objectLocation+id-1];i++){
  assert.match(game.command(`kill ${name} with sword`),/\? $/,'combat returns to command prompt');
 }assert.equal(game.memory[game.symbols.objectLocation+id-1],0,`${name} defeated`);};
 defeat(3,'troll');
 for(const command of ['south','south','east','get rope','west','west','south'])game.command(command);
 assert.equal(game.byte('playerLocation'),14);
 defeat(4,'dragon');
 for(const command of ['south','south','get candle'])game.command(command);
 assert.equal(game.byte('playerLocation'),18);
 for(const id of [8,20,21,22])assert.equal(game.memory[game.symbols.objectLocation+id-1],255);
});
