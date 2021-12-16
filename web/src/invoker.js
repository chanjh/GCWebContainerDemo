export default async function invoker(action, params, callback) {
  var message = {
    action: action,
    params: params,
    callback: callback,
  };
  const { bridgeName } = window.gc._config;
  await window.webkit.messageHandlers[bridgeName].postMessage(message)
}