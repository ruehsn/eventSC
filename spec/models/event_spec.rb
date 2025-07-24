require 'rails_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:one) # Assuming a fixture or factory is set up for events
    @event_option1 = event_options(:one) # Assuming a fixture or factory for event options
    @event_option2 = event_options(:two)
    @student1 = students(:one) # Assuming a fixture or factory for students
    @student2 = students(:two)

    # Setting up associations and attributes
    @event_option1.update(office_holds_cash: false, cost: 100, event: @event)
    @event_option2.update(office_holds_cash: false, cost: 200, event: @event)
    @student1.student_event_options.create(event_option: @event_option1, student_life_holds_cash: true)
    @student2.student_event_options.create(event_option: @event_option2, student_life_holds_cash: true)
  end

  test "sc_office_managed_cash_event returns correct students" do
    result = @event.sc_office_managed_cash_event

    assert_includes result, @student1
    assert_includes result, @student2
    assert_equal 2, result.size
  end

  test "sc_office_managed_cash_event excludes students with incorrect conditions" do
    @event_option1.update(office_holds_cash: true) # Modify condition to exclude
    result = @event.sc_office_managed_cash_event

    refute_includes result, @student1
    assert_includes result, @student2
    assert_equal 1, result.size
  end
end

test "cash_to_students returns correct students" do
  @event_option1.update(office_holds_cash: true, cost: 100) # Modify to match conditions
  @event_option2.update(office_holds_cash: true, cost: 200)
  @student1.student_event_options.update_all(student_life_holds_cash: false)
  @student2.student_event_options.update_all(student_life_holds_cash: false)

  result = @event.cash_to_students

  assert_includes result, @student1
  assert_includes result, @student2
  assert_equal 2, result.size
end

test "cash_to_students excludes students with incorrect conditions" do
  @event_option1.update(office_holds_cash: false) # Modify condition to exclude
  @student1.student_event_options.update_all(student_life_holds_cash: true) # Modify condition to exclude

  result = @event.cash_to_students

  refute_includes result, @student1
  assert_includes result, @student2
  assert_equal 1, result.size
end
