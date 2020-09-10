import { Controller } from "stimulus"

export default class extends Controller {
  static values = { fetchOnLoad: Boolean, url: String }

  connect(){
    if(this.fetchOnLoadValue) this.load()
  }

  load() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
      })
  }
}
