import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["paragraphOpen","paragraphClose"]

  static selected = false

  connect() {
  }

  select() {
    this.element.classList.add("selected")

    let paragraph = this.element.getElementsByClassName("paragraph-content")
    let paragraphF = this.element.getElementsByClassName("paragraph-form")
    if( paragraph ) {
      paragraph[0].classList.add("d-none")
    }
    if( paragraphF ) {
      paragraphF[0].classList.remove("d-none")
    }

    this.selected = !this.selected
  }

  deSelect() {
    this.element.classList.remove("selected")
    let paragraph = this.element.getElementsByClassName("paragraph-content")
    let paragraphF = this.element.getElementsByClassName("paragraph-form")
    if( paragraph ) {
      paragraph[0].classList.remove("d-none")
    }
    if( paragraphF ) {
      paragraphF[0].classList.add("d-none")
    }

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
