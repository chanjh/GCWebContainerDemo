import Service from "../../service";

export default class Test extends Service {
  constructor() {
    super()
  }
  static _bridgeName = 'util.test';
  static _methods = ['okk'];
}