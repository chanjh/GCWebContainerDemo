import Service from "../service";

export default class TestService extends Service {
  constructor() {
    super()
  }
  static _bridgeName = 'util.test';
  static _methods = ['okk'];
}