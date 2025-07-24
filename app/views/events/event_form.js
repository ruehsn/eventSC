  clone(event) {
    const currentOption = event.target.closest('.event-option');
    const clonedOption = currentOption.cloneNode(true);

    // Clear input values in the cloned option
    clonedOption.querySelectorAll('input, select, textarea').forEach(input => {
      if (input.type === 'checkbox' || input.type === 'radio') {
        input.checked = input.defaultChecked;
      } else {
        input.value = input.defaultValue;
      }
    });

    // Append the cloned option to the container
    const container = document.querySelector('[data-event-options-target="container"]');
    container.appendChild(clonedOption);
  }