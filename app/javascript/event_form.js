document.addEventListener("DOMContentLoaded", () => {
  const eventOptionsContainer = document.querySelector("#event-options");
  const addEventOptionLink = document.querySelector("#add-event-option");

  if (addEventOptionLink) {
    addEventOptionLink.addEventListener("click", (e) => {
      e.preventDefault();
      const newOption = document.createElement("div");
      newOption.classList.add("event-option");
      newOption.style.marginBottom = "10px";
      newOption.style.border = "1px solid #ccc";
      newOption.style.padding = "10px";
      newOption.innerHTML = `
        <div>
          <label style="display: block">Option Description</label>
          <input type="text" name="event[event_options_attributes][][description]">
        </div>
        <div>
          <label style="display: block">Cost</label>
          <input type="number" step="0.01" name="event[event_options_attributes][][cost]">
        </div>
        <div>
          <label>office holds cash?</label>
          <input type="checkbox" name="event[event_options_attributes][][office_holds_cash]">
        </div>
        <div>
          <label>Transportation Required?</label>
          <input type="checkbox" name="event[event_options_attributes][][transportation_required]">
        </div>
        <div>
          <a href="#" class="remove-event-option" style="color: red;">Remove Option</a>
        </div>
      `;
      eventOptionsContainer.appendChild(newOption);
    });

    eventOptionsContainer.addEventListener("click", (e) => {
      if (e.target.classList.contains("remove-event-option")) {
        e.preventDefault();
        e.target.closest(".event-option").remove();
      }
    });
  }
});