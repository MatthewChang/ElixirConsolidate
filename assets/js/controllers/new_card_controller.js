import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "newCatName","category" ]

  initialize() {
    this.render()
  }

  render() {
    this.newCatNameTarget.classList.toggle("hidden",this.categoryTarget.value != "new")
  }
}
