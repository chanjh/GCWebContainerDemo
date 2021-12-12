// require('./bridge');
import Launcher from './launcher'
const launcher = new Launcher();
launcher.injectBridge()

// export default class ExApi {
//   ddd(str) {
//     console.log(str);
//   }
// }
// window.exAPI = new ExApi();