import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  connect() {
    // Safe initialization even if no options exist yet
    this.index = this.containerTarget.children.length
  }

  add(event) {
    event.preventDefault()
    const timestamp = Date.now()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
    this.containerTarget.insertAdjacentHTML('beforeend', content)

    const newOption = this.containerTarget.lastElementChild
    if (!newOption) return

    // Find first visible, not-destroy-marked option
    const firstOption = Array.from(this.containerTarget.children).find(el => {
      if (!el.classList.contains('event-option')) return false
      if (el.style.display === 'none') return false
      const destroyField = el.querySelector('input[name*="[_destroy]"]')
      return !(destroyField && destroyField.value === '1')
    })

    if (!firstOption || firstOption === newOption) {
      // Nothing to copy from or only one option
      const desc = newOption.querySelector('input[name*="[description]"]')
      if (desc) desc.value = ''
      return
    }

    const copyValue = (fragment) => {
      const src = firstOption.querySelector(`input[name*="[${fragment}]"]`)
      const dest = newOption.querySelector(`input[name*="[${fragment}]"]`)
      if (src && dest) dest.value = src.value
    }

    // Copy numeric/time fields
    copyValue('cost')
    copyValue('leave_time')
    copyValue('return_time')

    // Copy checkboxes
    ;['office_holds_cash', 'transportation_required'].forEach(name => {
      const src = firstOption.querySelector(`input[type="checkbox"][name*="[${name}]"]`)
      const dest = newOption.querySelector(`input[type="checkbox"][name*="[${name}]"]`)
      if (src && dest) dest.checked = src.checked
    })

    // Ensure description blank
    const desc = newOption.querySelector('input[name*="[description]"]')
    if (desc) desc.value = ''
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