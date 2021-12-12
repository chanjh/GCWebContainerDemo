import Global from './global'
import { global } from './constant'
import loaderAll from './service_loader';
import Bridge from './bridge'

export default class Launcher {
  injectBridge() {
    // 0. register gc on window
    this.registerGC()

    // 0. load all services
    loaderAll();
  }

  registerGC() {
    window[global] = new Global();
    window[global].bridge = new Bridge();
  }
}