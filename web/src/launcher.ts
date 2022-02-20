import Global from './global'
import loadAllServices from './service_loader';
import Bridge from './bridge'
import * as defaultConfig from "./config.default";
import { jsbridge } from './invoker';

export default function launcher(config?: any) {
  let finalConfig = config;
  if (!config) {
    finalConfig = defaultConfig.default;
  }
  const { global } = finalConfig;
  // 0. register gc on window
  (window as any)[`${global}`] = new Global();
  (window as any)[`${global}`].bridge = new Bridge();
  // (window as any)[`${global}`].bridge.jsbridge = jsbridge;
  window.gc._config = finalConfig;
  // 1. add event center
  require('./event_center');
  // 1. load all services
  // loadAllServices();
}
