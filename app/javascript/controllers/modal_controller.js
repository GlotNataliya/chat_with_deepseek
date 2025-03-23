import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    document.addEventListener("click", this.closeMenus.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenus.bind(this))
  }

  toggleMenu(event) {
    event.stopPropagation()

    const clickedItem = event.currentTarget.closest(".chat-modal")
    const menu = clickedItem.querySelector(".options-modal")

    this.menuTargets.forEach(el => {
      if (el !== menu) el.classList.add("hidden")
    })

    menu.classList.toggle("hidden")
  }

  closeMenus(event) {
    if (!event.target.closest(".options-modal") && !event.target.closest(".options-btn")) {
      this.menuTargets.forEach(menu => menu.classList.add("hidden"))
    }
  }
}
