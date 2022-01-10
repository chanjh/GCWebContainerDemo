
// export default function Lock() {
//   this.callback = null
//   this.status = new Promise((resolve) => { resolve(true) })
//   this.lock = function () {
//     this.status = new Promise((resolve) => { this.callback = resolve })
//   }
//   this.unlock = function (result: any) { this.callback(result) }
// }

export default class Lock {
  status: Promise<any>;
  callback?: Function;
  constructor() {
    this.status = new Promise<any>((resolve) => { resolve(true) })
  }

  lock() {
    this.status = new Promise<any>((resolve) => { this.callback = resolve })
  }

  unlock(result: any) {
    this.callback(result)
  }
}