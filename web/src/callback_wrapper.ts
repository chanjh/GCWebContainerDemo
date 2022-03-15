import Lock from "./lock";

export default async function wrapCallback(uid: string, fn: Function, callback?: Function) {
  let callbackFunc = function () {
    const max = 9999;
    const min = 0;
    const random = parseInt(`${Math.random() * (max - min + 1) + min}`, 10);
    const { global } = window.gc._config;
    return `${global}_${uid.replaceAll(".", "")}_callback_func_${random}`;
  }
  function _initCallback(callbackName: string) {
    (window as any)[callbackName] = function (...arg: any[]) {
      const { global } = window.gc._config;
      // 1. unlock
      // 2. send msg to wrapFunction on service
      if (callback) {
        callback(arg[0])
      }
      lock.unlock(arg[0])
      // 3. remove callback
      console.log('delete callback:', callbackName);
      delete (window as any)[callbackName];
    }
  }
  let lock = new Lock();
  const callbackName = callbackFunc();
  console.log(callbackName, uid);
  _initCallback(callbackName);
  // callback, need to be a function name but not a obj in window
  lock.lock();
  fn(callbackName);
  return await lock.status
}
