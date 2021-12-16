import Global from './global'
import loadAllServices from './service_loader';
import Bridge from './bridge'
import * as defaultConfig from "./config.default";

export default function launcher(config) {
  let finalConfig = config;
  if (!config) {
    finalConfig = defaultConfig.default;
  }
  const { global } = finalConfig;
  // 0. register gc on window
  window[`${global}`] = new Global();
  window[`${global}`].bridge = new Bridge();
  window.gc._config = finalConfig;

  // 1. load all services
  loadAllServices();
}
