import invoker from "./invoker";
import { bridgeName } from './service_loader'
import Lock from "./lock";
export default class ServiceWrapper {
  constructor(serviceInfo) {
    this.serviceInfo = serviceInfo;
    this._initMethods();
  }

  _initMethods() {
    const constructorFunc = "constructor";
    const { methods } = this.serviceInfo;
    methods.forEach(m => {
      if (m !== constructorFunc) {
        const wrapFunction = async function () {
          const callback = this.callback;
          this._initCallback(callback);
          const params = JSON.parse(JSON.stringify(arguments));
          // callback, need to be a function name but not a obj in window
          this.lock = new Lock();
          this.lock.lock();
          await invoker(`${this.serviceInfo.bridge}.${m}`, params, callback);
          return await this.lock.status
        }
        this[m] = wrapFunction
      }
    });
  }

  _initCallback(callback) {
    const name = bridgeName(this.serviceInfo.name);
    const { bridge } = this.serviceInfo;
    const wrapFunction = function () {
      const { global } = window.gc._config;
      let self = window[global].bridge;
      bridge.split('.').forEach(e => {
        self = self[e]
      });
      // 1. unlock
      // 2. send msg to wrapFunction on service
      self.lock.unlock(arguments[0])
      // 3. remove callback
      delete window[callback];
    }
    window[callback] = wrapFunction
  }

  get callback() {
    const { name } = this.serviceInfo;
    const max = 9999;
    const min = 0;
    const random = parseInt(Math.random() * (max - min + 1) + min, 10);
    const { global } = window.gc._config;
    return `${global}_${name}_callback_func_${random}`;
  }
}