import ServiceWrapper from './wrap_service';
import ContextMenuService from './services/util/contextMenu';
import Test from './services/util/test';

export default function loadAllServices() {
  const services = [ContextMenuService, Test];
  services.forEach(s => {
    const name = bridgeName(s.name);
    // 2. wrap class, hook methods in class to `webkit.messageHandlers.invoke.postMessage()`
    // window.gc.bridge.contextMenu.set equal to =>
    // window.webkit.messageHandlers.invoke.postMessage(data)
    const wrapper = new ServiceWrapper({
      name: s.name,
      bridge: s._bridgeName,
      methods: s._methods,
      service: s
    })
    const { global } = window.gc._config;
    window[global].bridge[name] = wrapper;
  });
}

export function bridgeName(service) {
  return service[0].toLowerCase() + service.substring(1).split('Service')[0];
}