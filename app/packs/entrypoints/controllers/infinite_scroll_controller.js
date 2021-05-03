import { Controller } from "stimulus";

export default class extends Controller {
  static values = { url: String, startPage: Number, perPage: Number };
  static targets = ["loader", "result"];

  connect() {
    this.page = this.startPageValue || 1;
    this.perPage = this.perPageValue || 10;

    this.observer = new IntersectionObserver(this.onIntersection.bind(this));
    this.observer.observe(this.loaderTarget);
  }

  load() {
    return fetch(this.fullUrl)
      .then((response) => response.text())
      .then((html) => {
        this.resultTarget.innerHTML = this.resultTarget.innerHTML + html;
      });
  }

  get fullUrl() {
    const url = new URL(this.urlValue);
    url.searchParams.append("page", this.page);
    url.searchParams.append("per_page", this.perPage);
    return url.toString();
  }

  onIntersection(entries, observer) {
    const entry = entries[0];

    if (entry.isIntersecting) {
      observer.disconnect();
      this.load()
        .then((_) => this.page++)
        .then((_) => observer.observe(this.loaderTarget));
    }
  }
}
