import { Controller } from "@hotwired/stimulus"

// note: dont name controllers
// image_elements_controller.js
// the underscore breaks the recognition
export default class extends Controller {

  static selected = false
  connect() {

  }

  select() {
    this.element.classList.add("selected")

    this.selected = !this.selected
  }

  deSelect() {
    this.element.classList.remove("selected")

    this.selected = !this.selected
  }

  click(event) {

    if( !this.selected ) {
      this.select()
    } else {
      this.deSelect()
    }

    this.dispatch("click", { detail: { content: this } })
  }
}
