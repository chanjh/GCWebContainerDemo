import launcher from '../src/launcher'
launcher();
console.log('index');

import { injectService } from '../src/service_loader';
const js = require('./test');
injectService(js);