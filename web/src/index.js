import launcher from '../src/launcher'
launcher();

window.gc.bridge.util.contextMenu.clear().then(function (result) {
  console.log(`res: ${JSON.stringify(result)}`);
});
