require "test_helper"

class EventOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_admin_integration
    @event_option = event_options(:one)
  end

  test "should get index" do
    get event_options_url
    assert_response :success
  end

  test "should get new" do
    get new_event_option_url
    assert_response :success
  end

  test "should create event_option" do
    assert_difference("EventOption.count") do
      post event_options_url, params: { event_option: { cost: @event_option.cost, description: @event_option.description, event_id: @event_option.event_id, office_holds_cash: @event_option.office_holds_cash, transportation_required: @event_option.transportation_required } }
    end

    assert_redirected_to event_option_url(EventOption.last)
  end

  test "should show event_option" do
    get event_option_url(@event_option)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_option_url(@event_option)
    assert_response :success
  end

  test "should update event_option" do
    patch event_option_url(@event_option), params: { event_option: { cost: @event_option.cost, description: @event_option.description, event_id: @event_option.event_id, office_holds_cash: @event_option.office_holds_cash, transportation_required: @event_option.transportation_required } }
    assert_redirected_to event_option_url(@event_option)
  end

  test "should destroy event_option" do
    assert_difference("EventOption.count", -1) do
      delete event_option_url(@event_option)
    end

    assert_redirected_to event_options_url
  end
end
