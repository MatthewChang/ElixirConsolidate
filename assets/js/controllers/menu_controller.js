import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "menu","button" ]

  initialize() {
    this.open = false
    this.render()
  }

  render() {
    if(this.open) {
      this.menuTarget.classList.toggle("hidden",false)
    } else {
      this.menuTarget.classList.toggle("hidden",true)
    }
  }

  close(e) {
    if(!this.menuTarget.contains(e.target) && !this.buttonTarget.contains(e.target)) {
      this.open = false
      this.render()
    }
  }

  toggle() {
    this.open = !this.open
    this.render()
  }
}
