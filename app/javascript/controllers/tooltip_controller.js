import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap";

export default class extends Controller {
  connect() {
    const link = this.element;
    this.tooltip = new Tooltip(link);

    link.addEventListener('mouseenter', () => {
      this.tooltip.show();
    });

    link.addEventListener('mouseleave', () => {
      this.tooltip.hide();
    });
  }

  disconnect() {
    if (this.tooltip) {
      this.tooltip.dispose();

      const link = this.element;

      link.removeEventListener('mouseenter', this.tooltip.show);
      link.removeEventListener('mouseleave', this.tooltip.hide);
    }
  }
}
