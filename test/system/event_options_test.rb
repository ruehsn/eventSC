require "application_system_test_case"

class EventOptionsTest < ApplicationSystemTestCase
  setup do
    @event_option = event_options(:one)
  end

  test "visiting the index" do
    visit event_options_url
    assert_selector "h1", text: "Event options"
  end

  test "should create event option" do
    visit event_options_url
    click_on "New event option"

    fill_in "Cost", with: @event_option.cost
    fill_in "Description", with: @event_option.description
    fill_in "Event", with: @event_option.event_id
    check "office holds cash" if @event_option.office_holds_cash
    check "Transportation required" if @event_option.transportation_required
    click_on "Create Event option"

    assert_text "Event option was successfully created"
    click_on "Back"
  end

  test "should update Event option" do
    visit event_option_url(@event_option)
    click_on "Edit this event option", match: :first

    fill_in "Cost", with: @event_option.cost
    fill_in "Description", with: @event_option.description
    fill_in "Event", with: @event_option.event_id
    check "office holds cash" if @event_option.office_holds_cash
    check "Transportation required" if @event_option.transportation_required
    click_on "Update Event option"

    assert_text "Event option was successfully updated"
    click_on "Back"
  end

  test "should destroy Event option" do
    visit event_option_url(@event_option)
    click_on "Destroy this event option", match: :first

    assert_text "Event option was successfully destroyed"
  end
end
