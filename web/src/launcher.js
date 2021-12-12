import Global from './global'
import Loader from './service_loader';
import Bridge from './bridge'

export default class Launcher {
  injectBridge() {
    // 0. register gc on window
    this.registerGC()

    // 0. load all services
    const loader = new Loader();
    loader.loadAll();
  }

  registerGC() {
    window.gc = new Global();
    window.gc.bridge = new Bridge();
  }
}

// window.gc.bridge.contextMenu.set()