import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  initialize() {
    this.open = false
    this.menuTarget.classList.toggle("hidden",true)
  }

  toggle() {
    this.open = !this.open
    if(this.open) {
      this.menuTarget.classList.toggle("hidden",false)
    } else {
      this.menuTarget.classList.toggle("hidden",true)
    }
  }
}
