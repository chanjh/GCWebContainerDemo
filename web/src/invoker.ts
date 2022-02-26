import Lock from "./lock";
import wrapCallback from "./callback_wrapper";

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

export async function jsbridge(action: string, params?: {}, callback?: Function) {
  return await wrapCallback(action,
    (callbackName: string) => invoker(action, params, callbackName),
    callback
  );
  // let callbackFunc = function () {
  //   const max = 9999;
  //   const min = 0;
  //   const random = parseInt(`${Math.random() * (max - min + 1) + min}`, 10);
  //   const { global } = window.gc._config;
  //   return `${global}_${action.replaceAll(".", "")}_callback_func_${random}`;
  // }
  // function _initCallback(callbackName: string) {
  //   (window as any)[callbackName] = async function (...arg: any[]) {
  //     const { global } = window.gc._config;
  //     // 1. unlock
  //     // 2. send msg to wrapFunction on service
  //     if (callback) {
  //       await callback(arg[0])
  //     }
  //     lock.unlock(arg[0])
  //     // 3. remove callback
  //     console.log('delete callback:', callbackName);
  //     delete (window as any)[callbackName];
  //   }
  // }
  // let lock = new Lock();
  // const callbackName = callbackFunc();
  // console.log(callbackName);
  // _initCallback(callbackName);
  // // callback, need to be a function name but not a obj in window
  // lock = new Lock();
  // lock.lock();
  // await invoker(action, params, callbackName);
  // return await lock.status
}