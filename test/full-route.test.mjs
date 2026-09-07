import {test} from 'node:test';
import {createMachine} from './support/machine.mjs';
import {proveFullRoute} from './support/full-route.mjs';
test('fresh ordinary-command adventure banks every treasure for 126 points',async()=>proveFullRoute(await createMachine()));
