import invoker from "./invoker";
import Lock from "./lock";

export function wrapFunction(name, bridge, method) {
  let callbackFunc = function () {
    const max = 9999;
    const min = 0;
    const random = parseInt(Math.random() * (max - min + 1) + min, 10);
    const { global } = window.gc._config;
    return `${global}_${name}_callback_func_${random}`;
  }
  function _initCallback(callback) {
    window[callback] = function () {
      const { global } = window.gc._config;
      // 1. unlock
      // 2. send msg to wrapFunction on service
      lock.unlock(arguments[0])
      // 3. remove callback
      delete window[callback];
    }
  }
  let lock = new Lock();
  return async function () {
    const callback = callbackFunc();
    _initCallback(callback);
    const params = JSON.parse(JSON.stringify(arguments));
    // callback, need to be a function name but not a obj in window
    lock = new Lock();
    lock.lock();
    await invoker(`${bridge}.${method}`, params, callback);
    return await lock.status
  }
}

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
        const { name, bridge } = this.serviceInfo;
        this[m] = wrapFunction(name, bridge, m)
      }
    });
  }
}
