import { Controller } from "@hotwired/stimulus";
import { cable } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ['listener'];
  static values = { channel: String };

  connect() {
    this.subscribeToChannel();
  }

  subscribeToChannel() {
    this.subscribeTo(this.channelValue, {
      target: this.listenerTarget,
      received: this.received
    });
  }

  received(data) {
    const { name, ...detail } = data;
    const event = new CustomEvent(name, { detail, bubbles: true, cancelable: true });
    this.target.dispatchEvent(event);
  }

  async subscribeTo(channelName, mixin) {
    return await cable.subscribeTo(channelName, mixin);
  }
}
