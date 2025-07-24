import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  connect() {
    // Safe initialization even if no options exist yet
    this.index = this.containerTarget.children.length
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.event-option')
    
    // Mark for destruction if it's a persisted record
    const destroyInput = wrapper.querySelector('input[name*="_destroy"]')
    if (destroyInput) {
      destroyInput.value = "1"
      wrapper.style.display = 'none'
    } else {
      // Remove if it's a new record
      wrapper.remove()
    }
  }
}