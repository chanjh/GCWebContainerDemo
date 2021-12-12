import ServiceWrapper from './wrap_service';
import { global } from './constant'
import ContextMenuService from './services/contextMenu';
import Test from './services/test';

export default function loaderAll() {
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
    window[global].bridge[name] = wrapper;
  });
}

export function bridgeName(service) {
  return service[0].toLowerCase() + service.substring(1).split('Service')[0];
}