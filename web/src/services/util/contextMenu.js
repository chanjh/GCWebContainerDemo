import Service from "../../service";

export default class ContextMenuService extends Service {
  constructor() {
    super()
  }
  static _bridgeName = 'util.contextMenu';
  static _methods = ['clear']
}