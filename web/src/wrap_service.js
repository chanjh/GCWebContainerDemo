import invoker from "./invoker";
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
      if (m !== "constructor") {
        const wrapFunction = async function () {
          const params = JSON.parse(JSON.stringify(arguments));
          // todo: callback, need to be a function name but not a obj in window
          const callback = (function () { });
          await invoker(`${this.serviceInfo.bridge}.${m}`, params, 'callback_name');
        }
        this[m] = wrapFunction
      }
    });
  }

  _initService() {
    const { service } = this.serviceInfo;
    this.service = new service();
  }
}