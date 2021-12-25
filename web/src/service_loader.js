import ServiceWrapper, { wrapFunction } from './wrap_service';

export default function loadAllServices() {
  const { services } = window.gc._config;
  const { global } = window.gc._config;
  const host = window[global].bridge;
  parseService(services, '', host);
  loadDefaultServices();

  function parseService(service, namespace, host) {
    if (Array.isArray(service)) {
      return service
    }
    Object.keys(service).forEach(name => {
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

function bridgeName(service) {
  return service[0].toLowerCase() + service.substring(1).split('Service')[0];
}

function loadDefaultServices() {
  var req = require.context("./services", true, /\.js$/);
  req.keys().forEach(function (key) {
    const js = req(key);
    injectService(js);
  });
}

export function injectService(service) {
  if (service.__esModule) {
    const namespace = service.default.namespace;
    const { global } = window.gc._config;
    let point = window[global].bridge;
    namespace.split('.').forEach(name => {
      if (!point[name]) {
        point[name] = Object()
      }
      point = point[name]
    })
    const methods = Object.getOwnPropertyNames(service.default.prototype);
    methods.forEach(m => {
      if (m !== 'constructor') {
        point[m] = function (arg) {
          // todo: service cache
          const serviceIns = (new service.default())
          const fn = serviceIns[m]
          return fn(arg)
        }
      }
    })
  }
}