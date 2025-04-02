import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selector", "field"]

  toggle() {
    const selectedValue = this.selectorTarget.value;
    if (selectedValue === "true") {
      this.fieldTarget.style.display = "flex";
    } else {
      this.fieldTarget.style.display = "none";
    }
  }
}
