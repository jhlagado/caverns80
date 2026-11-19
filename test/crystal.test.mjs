import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

test('the flask clue leads back to the oak door and a dark crystal still opens it',async()=>{
 const game=await createMachine();
 game.run();
 const s=game.symbols;
 const flask=s.objectLocation+8;
 const crystal=s.objectLocation+20;
 game.memory[s.playerLocation]=51;
 game.memory[crystal]=255;
 assert.match(game.command('take flask'),/Use with the crystal/);
 assert.match(game.command('use crystal with flask'),/Nothing else happens/);
 assert.equal(game.memory[flask],255);
 assert.equal(game.byte('teleportDestination'),0);

 game.memory[s.playerLocation]=20;
 game.memory[s.candleIsLitFlag]=0;
 assert.match(game.command('inventory'),/a dark crystal/);
 const opened=game.command('use flask with crystal');
 assert.match(opened,/blue light[\s\S]*oak groans[\s\S]*passage leads east/);
 assert.equal(game.memory[flask],0);
 assert.equal(game.memory[crystal],255);
 assert.equal(game.byte('teleportDestination'),19);
 assert.equal(game.byte('playerLocation'),20);

 assert.match(game.command('save OAK'),/Game saved to disk/);
 const restarted=await createMachine({files:{'OAK.SAV':game.files.get('OAK.SAV')}});
 restarted.run();
 assert.match(restarted.command('load OAK'),/Game loaded/);
 assert.equal(restarted.byte('playerLocation'),20);
 assert.equal(restarted.byte('candleIsLitFlag'),0);
 assert.equal(restarted.byte('teleportDestination'),19);
 assert.equal(restarted.memory[restarted.symbols.objectLocation+8],0);
 assert.equal(restarted.memory[restarted.symbols.objectLocation+20],255);
});
