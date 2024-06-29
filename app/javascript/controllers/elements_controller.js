import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static prevElm = undefined

  connect() {
    //this.element.textContent = "Hello World!"
    
  }

  reSort() {
    // // I was trying to do live sorting with javascript but I couldnt update the database with gon variables
    // // If there is a way to do it, it's too late, Ive added buttons to controller actions which move elements up/down
    // const selector = element => element.querySelector("element").id
    //
    // const ascendingOrder = true
    // const isNumeric = true
    //
    // const elems = [...this.element.querySelectorAll("element")]
    //
    // const collator = new Intl.Collator(undefined, {numeric: isNumeric, sensitivity: 'base'});
    //
    // elems.sort((elementA, elementB) => {
    //     const [firstElement, secondElement] = ascendingOrder ? [elementA, elementB] : [elementB, elementA];
    //     const idOfFirstElement = selector(firstElement);
    //     const idOfSecondElement = selector(secondElement);
    //     return collator.compare(idOfFirstElement , idOfSecondElement)
    //   })
    //   .forEach(element => this.element.appendChild(element));
    // console.log("reSort() done")
  }

  editParagraph( { detail: {content} } ) {

    if( this.prevElm ) {
      this.prevElm.deSelect();
    }
    this.prevElm = content
  }

  selectImage({ detail: {content} }) {
    if( this.prevElm && this.prevElm != content  ) {
      this.prevElm.deSelect();
    }
    this.prevElm = content
  }
}
