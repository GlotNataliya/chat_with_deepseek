import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modelSelect", "temperatureField", "topField"]

  connect() {
    this.toggle()
  }

  toggle() {
    const selectedModel = this.modelSelectTarget.value

    if (selectedModel === "deepseek-reasoner") {
      this.temperatureFieldTarget.disabled = true
      this.topFieldTarget.disabled = true
    } else {
      this.temperatureFieldTarget.disabled = false
      this.topFieldTarget.disabled = false
    }
  }
}
