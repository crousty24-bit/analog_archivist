import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { threshold: { type: Number, default: 320 } }

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll, { passive: true })
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  scroll(event) {
    event.preventDefault()

    const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches

    window.scrollTo({
      top: 0,
      behavior: prefersReducedMotion ? "auto" : "smooth"
    })
  }

  handleScroll() {
    const visible = window.scrollY > this.thresholdValue

    this.buttonTarget.classList.toggle("is-visible", visible)
    this.buttonTarget.setAttribute("aria-hidden", String(!visible))
    this.buttonTarget.tabIndex = visible ? 0 : -1
  }
}
