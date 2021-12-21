
export default function Lock() {
  this.callback = null
  this.status = new Promise((resolve) => { resolve(true) })
  this.lock = function () {
    this.status = new Promise((resolve) => { this.callback = resolve })
  }
  this.unlock = function (result) { this.callback(result) }
}