import ServiceWrapper from './wrap_service';

export default function loadAllServices() {
  const { services } = window.gc._config;
  const { global } = window.gc._config;
  const host = window[global].bridge;
  parseService(services, '', host);

  function parseService(service, namespace, host) {
    if (Array.isArray(service)) {
      return service
    }
    Object.keys(service).map(name => {
      const newNamespace = namespace.length == 0 ? name : `${namespace}.${name}`;
      host[name] = Object()
      const methods = parseService(service[name], newNamespace, host[name])
      if (methods) {
        // wrap class, hook methods in class to `webkit.messageHandlers.invoke.postMessage()`
        // window.gc.bridge.contextMenu.set equal to =>
        // window.webkit.messageHandlers.invoke.postMessage(data)
        const wrapper = new ServiceWrapper({
          name,
          bridge: newNamespace,
          methods: methods,
        })
        host[name] = wrapper
      }
    })
  }
}

export function bridgeName(service) {
  return service[0].toLowerCase() + service.substring(1).split('Service')[0];
}