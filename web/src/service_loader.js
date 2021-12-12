
import ContextMenuService from './services/contextMenu';
export default class Loader {
  constructor() { }
  // TODO: auto input all services by webpack loader
  static services = [ContextMenuService];
  loadAll() {
    // 0. get all services
    // 1. inject service name in window.gc.bridge.name
    Loader.services.forEach(s => {
      const name = this.bridgeName(s.name);
      window.gc.bridge[name] = new s();
    });
  }

  bridgeName(service) {
    return service[0].toLowerCase() + service.substring(1);
  }
}