export default function initGC() {
  injectBridge: {
    // 0. load all services
    const loader = require('./service_loader');
    loader.loadAll();
    // 1. inject each service info
  }
}