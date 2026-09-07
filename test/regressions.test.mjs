import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

test('pseudo-nouns cannot be taken or dropped outside the object array',async()=>{
 const game=await createMachine();game.run();
 const address=game.symbols.objectLocation;
 const before=game.memory.slice(address,address+24);
 game.command('get door');game.command('drop gate');
 assert.deepEqual(game.memory.slice(address,address+24),before);
});

test('informational commands are free and the action counter crosses 255',async()=>{
 const game=await createMachine();game.run();
 const turn=game.symbols.turnCounter;
 for(const command of ['look','list','score','help'])game.command(command);
 assert.equal(game.memory[turn]|game.memory[turn+1]<<8,0);
 for(let i=0;i<260;i++)game.command('south');
 assert.equal(game.memory[turn]|game.memory[turn+1]<<8,260);
 assert.equal(game.byte('candleIsLitFlag'),0);
 assert.equal(game.byte('playerLocation'),1);
});

test('disk save cannot change live object locations',async()=>{
 const game=await createMachine();game.run();
 const address=game.symbols.objectLocation;
 const before=game.memory.slice(address,address+24);
 game.command('save');
 assert.deepEqual(game.memory.slice(address,address+24),before);
});

test('a save slot named LOOK cannot dispatch the look verb',async()=>{
 const game=await createMachine();game.run();
 game.command('save look');
 assert(game.files.has('LOOK.SAV'));
 assert.equal(game.byte('turnCounter'),0);
});

test('information in a bat room is free and stage shortcuts are unavailable',async()=>{
 const game=await createMachine();game.run();
 game.memory[game.symbols.playerLocation]=17;
 const before=game.memory[game.symbols.objectLocation+4];
 for(const command of ['look','help','i','stage2'])game.command(command);
 assert.equal(game.byte('playerLocation'),17);
 assert.equal(game.memory[game.symbols.objectLocation+4],before);
 assert.equal(game.byte('turnCounter'),0);
});

test('a bat leaving the world becomes removed and the resulting game is saveable',async()=>{
 const game=await createMachine();game.run();
 game.memory[game.symbols.playerLocation]=52;
 game.memory[game.symbols.objectLocation+4]=52;
 game.command('get compass');
 assert.equal(game.byte('playerLocation'),33);
 assert.equal(game.memory[game.symbols.objectLocation+4],0);
 game.command('save');
 assert(game.files.has('CAVERNS.SAV'));
});

test('overlong commands are drained and rejected, and backspace edits input',async()=>{
 const game=await createMachine();game.run();
 const result=game.command('north'+' '.repeat(40));
 assert.match(result,/too long/);
 assert.equal(game.byte('playerLocation'),1);
 assert.equal(game.byte('turnCounter'),0);
 game.send('nortx\b h\b\bh\r');
 assert.equal(game.byte('playerLocation'),2);
});

 test('LIST, INVENT, INVENTORY and I show the same inventory without spending turns',async()=>{
 const game=await createMachine();game.run();game.command('get compass');
 const turn=game.byte('turnCounter');
 const outputs=['list','invent','inventory','i','INVENTORY'].map(command=>{
  const text=game.command(command);
  assert.match(text,/You are carrying/);
  assert.match(text,/compass/);
  assert.equal(game.byte('turnCounter'),turn);
  return text.slice(text.indexOf('You are carrying'));
 });
 for(const output of outputs)assert.equal(output,outputs[0]);
});
