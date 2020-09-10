import { request } from "helpers/request_helpers"
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "bar" ]
  static values = { load: Number, updateUrl: String }

  initialize() {
    this.updateBar(this.loadValue)
  }

  off() {
    this.updateBar(0)
  }

  down() {
    this.updateBar(Math.max(this.load - 10, 0))
  }

  up() {
    this.updateBar(Math.min(this.load + 10, 100))
  }

  on() {
    this.updateBar(100)
  }

  updateBar(load)  {
    if (this.updateUrlValue && this.load) {
      request("put", this.updateUrlValue, {
        body: JSON.stringify({ load }),
        contentType: "application/json",
      })
    }

    this.load = load
    this.barTarget.style.width = `${load}%`
    this.barTarget.innerHTML = `${load}%`
  }
}
