import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['container'];
  static values = { mapping: Object };

  connect() {
    Object.keys(this.mappingValue).forEach((value) => {
      this.element[value] = false;
    })
    this.observeMutations(this.maintainState);
  }

  maintainState(_) {
    Object.keys(this.mappingValue).forEach((valueName) => {
      const isShown = this.element[valueName];

      if (isShown) {
        this.show(event, valueName);
      } else {
        this.hide(event, valueName);
      }

    })
  }

  show(event, value) {
    const valueName = value || event.target.dataset.value;
    const className = this.mappingValue[valueName];
    this.element[valueName] = true;
    this.containerTarget.classList.add(className);
  }

  hide(event, value) {
    const valueName = value || event.target.dataset.value;
    const className = this.mappingValue[valueName];
    this.element[valueName] = false;
    this.containerTarget.classList.remove(className);
  }

  toggle(event, value) {
    if (event) {
      event.preventDefault();
    }

    const valueName = value || event.target.dataset.value;
    const isShown = this.element[valueName];

    if (isShown) {
      this.hide(event, valueName);
    } else {
      this.show(event, valueName);
    }
  }

  observeMutations(
    callback,
    target = this.element,
    options = { childList: true, subtree: true }
  ) {
    const observer = new MutationObserver((mutations) => {
      observer.disconnect();
      Promise.resolve().then(start);
      callback.call(this, mutations);
    });
    function start() {
      if (target.isConnected) observer.observe(target, options);
    }
    start();
  }
}
