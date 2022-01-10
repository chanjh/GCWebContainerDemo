import Lock from "./lock";
// import { Window } from "./window";
export default async function invoker(action: string | undefined, params: {}, callback: string) {
  let arg = params
  if (!params) {
    arg = {}
  }
  var message = {
    action: action,
    params: arg,
    callback: callback,
  };
  const { bridgeName } = window.gc._config;
  await window.webkit.messageHandlers[bridgeName].postMessage(message)
}

export async function jsbridge(action: string, params: {}, callback: Function) {
  let callbackFunc = function () {
    const max = 9999;
    const min = 0;
    const random = parseInt(`${Math.random() * (max - min + 1) + min}`, 10);
    const { global } = window.gc._config;
    return `${global}_${action.replaceAll(".", "")}_callback_func_${random}`;
  }
  function _initCallback(callbackName: string) {
    (window as any)[callbackName] = async function (...arg: any[]) {
      const { global } = window.gc._config;
      // 1. unlock
      // 2. send msg to wrapFunction on service
      if (callback) {
        const res = await callback(arg[0])
        lock.unlock(res);
      } else {
        lock.unlock(arg[0])
      }
      // 3. remove callback
      delete (window as any)[callbackName];
    }
  }
  let lock = new Lock();
  // return async function () {
  const callbackName = callbackFunc();
  console.log(callbackName);
  _initCallback(callbackName);
  // const params = JSON.parse(JSON.stringify(arguments));
  // callback, need to be a function name but not a obj in window
  lock = new Lock();
  lock.lock();
  await invoker(action, params, callbackName);
  return await lock.status
}