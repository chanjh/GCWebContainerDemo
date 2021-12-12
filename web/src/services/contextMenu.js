import Service from "../service";

export default class ContextMenuService extends Service {
  constructor() {
    super()
  }
  static _bridgeName = 'util.contextMenu';
  clear() {
    console.log('clear');
  }
}