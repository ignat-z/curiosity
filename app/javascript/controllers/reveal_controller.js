import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static classes = ['show', 'hide'];
  static targets = ['container'];

  show(_event) {
    this.hideToggle(false);
  }

  hide(_event) {
    this.hideToggle(true);
  }

  hideToggle(bool) {
    this.containerTarget.classList.toggle(this.showClass, !bool);
    this.containerTarget.classList.toggle(this.hideClass, bool);
  }
}
