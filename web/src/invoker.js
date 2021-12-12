import { bridgeName } from './constant';

export default async function invoker(action, params, callback) {
  var message = {
    action: action,
    params: params,
    callback: callback,
  };
  await window.webkit.messageHandlers[bridgeName].postMessage(message)
}