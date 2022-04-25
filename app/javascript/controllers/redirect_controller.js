import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  go(event) {
    Turbo.visit(event.detail.url);
  }
}
