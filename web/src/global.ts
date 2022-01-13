// instance injecting on `window`
export default class Global {
  constructor() { }
  _config: {bridgeName: string, global: string, services: {}};
  bridge: any;
}
