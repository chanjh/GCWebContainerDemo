import invoker from "./invoker";
import { global } from './constant'
import { bridgeName } from './service_loader'
import Lock from "./lock";
export default class ServiceWrapper {
  constructor(serviceInfo) {
    this.serviceInfo = serviceInfo;
    this._initMethods();
    this._initService();
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
    const wrapFunction = function () {
      const self = window[global].bridge[name];
      // 1. unlock
      // 2. send msg to wrapFunction on service
      self.lock.unlock(arguments[0])
      // 3. remove callback
      delete window[callback];
    }
    window[callback] = wrapFunction
  }

  _initService() {
    const { service } = this.serviceInfo;
    this.service = new service();
  }
  get callback() {
    const { name } = this.serviceInfo;
    const random = Math.floor(Math.random() * 10);
    return `${global}_${name}_callback_func_${random}`;
  }
}