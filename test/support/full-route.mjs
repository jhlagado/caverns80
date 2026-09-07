import assert from 'node:assert/strict';

export function proveFullRoute(game){
 game.run();
 const obj=id=>game.memory[game.symbols.objectLocation+id-1];
 const route=[];
 const checkpoints=[];
 const command=text=>{
  route.push(text);
  const response=game.command(text);
  assert.equal(game.exited,false,`unexpected exit after ${route.join('; ')}`);
  assert.doesNotMatch(response,/Another adventure/i,`unexpected death after ${route.join('; ')}`);
  assert.match(response,/\? $/,`missing prompt after ${text}: ${response}`);
  checkpoints.push({command:text,room:game.byte('playerLocation'),objects:[...game.memory.slice(game.symbols.objectLocation,game.symbols.objectLocation+24)]});
  return response;
 };
 const walk=(commands,room)=>{
  for(const text of commands)command(text);
  assert.equal(game.byte('playerLocation'),room,`route ended after ${route.join('; ')}`);
 };
 const defeat=(id,name)=>{
  for(let i=0;i<12&&obj(id)!==0;i++)command(`kill ${name} with sword`);
  assert.equal(obj(id),0,`${name} must be defeated through ordinary combat`);
 };
 const bank=items=>{for(const [id,name] of items){assert.equal(obj(id),255,`${name} carried before banking`);command(`drop ${name}`);assert.equal(obj(id),1);}};
 walk(['get compass','north','west','west','south','east','get coin','west','west','get sword','east','north','east','east','east','east','south'],10);
 defeat(3,'troll');
 walk(['south','south','east','get rope','west','west','south'],14);
 defeat(4,'dragon');
 walk(['south','south','get candle','west','north','get diamond','west','south','south','west','south','west','get key'],34);
 assert.equal(obj(19),255);
 walk(['east','south','west','west','south','east','south','east','down with rope'],35);
 assert.equal(obj(22),28,'rope left at balcony');
 walk(['open gate with key','read','vard','east','get grill','drop grill','east','south'],36);
 assert.equal(game.byte('gateDestination'),39);
 defeat(1,'wizard');
 assert.equal(obj(20),35,'wizard returns sword to temple');
 walk(['west','get sword','open gate with key','east','east','south','east','north','get ruby'],45);
 assert.equal(game.byte('waterExitLocation'),43);
 walk(['south','west','north','west','north','north','get pearl','west'],47);
 defeat(6,'goblin');
 walk(['south','south','west','north','west','north','west','west','west','get stone','south','east','north','read','east','get bomb','west','west','west'],48);
 assert.equal(game.byte('drawbridgeState'),49);
 walk(['galar','north','north','east','north','north','north','west','west','open door with key'],1);
 bank([[7,'coin'],[8,'compass'],[10,'ruby'],[11,'diamond'],[12,'pearl'],[13,'stone']]);
 walk(['north','east','east','south','south','south','west','south','south','south','west','north','west','north'],20);
 command('light bomb with candle');
 assert.equal(obj(9),0,'bomb consumed by door puzzle');
 assert.equal(game.byte('playerLocation'),20,'blast does not teleport player');
 walk(['east'],19);defeat(2,'demon');
 walk(['get ring','get pendant','get grail','get shield','galar','north','north','east','north','north','north','west','west','open door with key'],1);
 bank([[14,'ring'],[15,'pendant'],[16,'grail'],[17,'shield']]);
 assert.match(command('score'),/126/);
 assert.equal(game.byte('score'),126);
 for(const id of [7,8,10,11,12,13,14,15,16,17])assert.equal(obj(id),1,`treasure ${id} banked`);
 assert.equal(obj(9),0);
 return {route,checkpoints,metrics:game.metrics};
}
