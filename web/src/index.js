import launcher from '../src/launcher'
launcher();

window.gc.bridge.contextMenu.clear().then(function (result) {
  console.log(`res: ${JSON.stringify(result)}`);
});
