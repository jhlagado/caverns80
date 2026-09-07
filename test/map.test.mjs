import assert from 'node:assert/strict';
import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';

test('all ordinary compass exits reverse, except six documented puzzle returns',async()=>{
 const game=await createMachine();
 const table=game.memory.slice(game.symbols.movementTable,game.symbols.movementTable+54*4);
 const opposite=[1,0,3,2];
 const exceptions=new Map([
  ['1,0,2','hut door needs key'],
  ['19,2,20','oak door needs bomb'],
  ['37,1,35','temple gate needs key'],
  ['39,2,38','cell grille opens east'],
  ['43,1,38','waterfall discovery opens north'],
  ['49,2,48','drawbridge lowering opens east'],
 ]);
 const seen=[];
 for(let room=1;room<=54;room++)for(let dir=0;dir<4;dir++){
  const dest=table[(room-1)*4+dir];
  assert(dest===0||dest===128||(dest>=1&&dest<=54),`invalid exit ${room}/${dir}`);
  if(dest===0||dest===128)continue;
  const key=`${room},${dir},${dest}`;
  if(exceptions.has(key)){seen.push(key);continue;}
  assert.equal(table[(dest-1)*4+opposite[dir]],room,`nonreversible ${room} ${'NSWE'[dir]} ${dest}`);
 }
 assert.deepEqual(seen.sort(),[...exceptions.keys()].sort(),'all intended puzzle edges retained');
 // Keep all rooms reachable in the completed graph. Include the command-only
 // rope descent and key gate; reverse traversal alone must not lose side rooms.
 const edges=Array.from({length:55},()=>[]);
 for(let room=1;room<=54;room++)for(const dest of table.slice((room-1)*4,room*4))if(dest>0&&dest<=54)edges[room].push(dest);
 for(const [from,to] of [[2,1],[20,19],[35,37],[37,38],[38,39],[38,43],[48,49],[28,35]])edges[from].push(to);
 const reached=new Set([1]),queue=[1];
 while(queue.length)for(const dest of edges[queue.shift()])if(!reached.has(dest)){reached.add(dest);queue.push(dest);}
 assert.equal(reached.size,54,'completed world retains every room');
});
