import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["bar"];
  static values = { load: Number, updateUrl: String };

  initialize() {
    this.updateBar(this.loadValue);
  }

  off() {
    this.updateBar(0);
  }

  down() {
    this.updateBar(Math.max(this.load - 10, 0));
  }

  up(event) {
    const amount = event.type === "progress:up" ? event.detail.amount : 10;
    this.updateBar(Math.min(this.load + amount, 100));
  }

  on() {
    this.updateBar(100);
  }

  updateBar(load) {
    if (this.updateUrlValue && this.load) {
      this.notifyServer(load);
    }

    this.load = load;
    this.barTarget.style.width = `${load}%`;
    this.barTarget.innerHTML = `${load}%`;
  }

  notifyServer(load) {
    const csrfToken = document.getElementById("authenticity_token").value;

    fetch(this.updateUrlValue, {
      method: "put",
      credentials: "same-origin",
      body: JSON.stringify({ load }),
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
      },
    });
  }
}
