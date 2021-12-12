import ServiceWrapper from './wrap_service';
import ContextMenuService from './services/contextMenu';
import TestService from './services/test';

export default class Loader {
  constructor() { }
  // TODO: auto input all services by webpack loader
  static services = [ContextMenuService, TestService];
  loadAll() {
    // 0. get all services
    // 1. inject service name in window.gc.bridge.name
    Loader.services.forEach(s => {
      const name = this.bridgeName(s.name);
      // todo: 2. wrap class, hook methods in class to `webkit.messageHandlers.invoke.postMessage()`
      // window.gc.bridge.contextMenu.set ->
      // window.webkit.messageHandlers.invoke.postMessage(data)
      const wrapper = new ServiceWrapper({
        name: s.name,
        bridge: s._bridgeName,
        methods: s._methods,
        service: s
      })
      window.gc.bridge[name] = wrapper;
    });
  }

  bridgeName(service) {
    return service[0].toLowerCase() + service.substring(1);
  }
}