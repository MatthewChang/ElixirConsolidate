import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "front", "back" ]

  initialize() {
    this.show()
  }

  show() {
    if(this.flipped) {
      this.frontTarget.classList.toggle("hidden",true)
      this.backTarget.classList.toggle("hidden",false)
    } else {
      this.frontTarget.classList.toggle("hidden",false)
      this.backTarget.classList.toggle("hidden",true)
    }
  }

  flip() {
    this.flipped = !this.flipped
  }

  get flipped() {
    return this.data.get('flipped') == 'true'
  }
  set flipped(val) {
    this.data.set('flipped',val ? 'true' : 'false')
    this.show()
  }
}
