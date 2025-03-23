import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-link"
export default class extends Controller {
  activate(event) {
    // // Удалить активный класс у всех ссылок
    // this.element.querySelectorAll(".nav-link").forEach((link) => {
    //   link.classList.remove("active");
    // });

    // Добавить активный класс к кликнутой ссылке
    event.target.classList.add("active");
  }
}
