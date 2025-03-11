import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"]

  connect() {
    this.adjustHeight(); // Устанавливаем начальную высоту
  }

  adjustHeight() {
    this.textareaTarget.style.height = 'auto'; // Сначала сбрасываем
    this.textareaTarget.style.height = `${this.textareaTarget.scrollHeight}px` // Устанавливаем высоту по содержимому
  }
}
