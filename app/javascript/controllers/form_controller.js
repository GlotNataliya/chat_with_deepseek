import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chat", "form"];

  hideForm() {
    this.chatTarget.classList.add("d-none");
  }

  hideChat() {
    this.chatTarget.classList.add("d-none");
  }
}
