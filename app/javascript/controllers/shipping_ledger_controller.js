import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["shippingTotal", "taxTotal", "grandTotal"]
  static values = { subtotalCents: Number }

  connect() {
    this.updateTotals()
  }

  updateTotals() {
    const checked = this.element.querySelector('input[name="order[shipping_method]"]:checked')
    const shippingAmountCents = Number(checked?.dataset.amountCents || 0)
    const taxAmountCents = Math.round(this.subtotalCentsValue * 0.08)
    const totalCents = this.subtotalCentsValue + shippingAmountCents + taxAmountCents

    this.shippingTotalTarget.textContent = this.format(shippingAmountCents)
    this.taxTotalTarget.textContent = this.format(taxAmountCents)
    this.grandTotalTarget.textContent = this.format(totalCents)
  }

  format(amountCents) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD"
    }).format(amountCents / 100)
  }
}
