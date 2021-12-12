import Launcher from './launcher'
(new Launcher()).injectBridge()

window.gc.bridge.contextMenu.clear().then(function (result) {
  console.log(`res: ${JSON.stringify(result)}`);
});
