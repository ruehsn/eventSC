import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option", "total", "summary"]
  static values = { costs: Object }

  connect() {
    this.updateTotal()
  }

  updateTotal() {
    let total = 0
    const selectedEvents = []
    
    // Group options by event to handle radio button groups
    const eventGroups = {}
    this.optionTargets.forEach(option => {
      const eventId = this.getEventIdFromOption(option)
      if (!eventGroups[eventId]) {
        eventGroups[eventId] = []
      }
      eventGroups[eventId].push(option)
    })

    // Process each event group to find selected option
    Object.keys(eventGroups).forEach(eventId => {
      const options = eventGroups[eventId]
      const selectedOption = options.find(option => option.checked)
      
      if (selectedOption) {
        const optionId = selectedOption.value
        const cost = this.costsValue[optionId] || 0
        total += parseFloat(cost)
        
        // Get event info for summary
        const label = selectedOption.parentNode.querySelector('label')
        const eventName = this.getEventNameFromOption(selectedOption)
        const optionText = label ? label.textContent.trim() : `Option ${optionId}`
        
        // Only add to selectedEvents if cost is greater than 0
        if (cost > 0) {
          selectedEvents.push({
            event: eventName,
            option: optionText,
            cost: cost
          })
        }
      }
    })

    // Update total display
    const formattedTotal = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(total)

    this.totalTarget.textContent = formattedTotal
    
    // Update total styling
    if (total > 0) {
      this.totalTarget.classList.add('text-green-600')
      this.totalTarget.classList.remove('text-gray-500')
    } else {
      this.totalTarget.classList.add('text-gray-500')
      this.totalTarget.classList.remove('text-green-600')
    }

    // Update summary
    this.updateSummary(selectedEvents)
  }

  updateSummary(selectedEvents) {
    if (selectedEvents.length === 0) {
      this.summaryTarget.innerHTML = '<div class="text-sm text-gray-500 italic">No events selected yet</div>'
      return
    }

    const summaryHTML = selectedEvents.map(event => `
      <div class="text-xs border-l-2 border-blue-400 pl-2 py-1">
        <div class="font-medium text-gray-700">${event.event}</div>
        <div class="text-gray-600">${event.option}</div>
      </div>
    `).join('')

    this.summaryTarget.innerHTML = summaryHTML
  }

  getEventIdFromOption(option) {
    // Extract event ID from the option name attribute
    // Format: event_options[EVENT_ID]
    const match = option.name.match(/event_options\[(\d+)\]/)
    return match ? match[1] : null
  }

  getEventNameFromOption(option) {
    // Find the event container and extract the event name
    const eventContainer = option.closest('.bg-white.shadow.rounded-lg')
    if (eventContainer) {
      const heading = eventContainer.querySelector('h3')
      if (heading) {
        // Extract just the event name (before the dash and date)
        const fullText = heading.textContent.trim()
        const dashIndex = fullText.indexOf(' - ')
        return dashIndex > -1 ? fullText.substring(0, dashIndex) : fullText
      }
    }
    return 'Unknown Event'
  }
}