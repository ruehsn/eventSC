require "test_helper"

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:one) 
    # Associations are now handled by fixtures in test/fixtures/student_event_options.yml
  end

  test "sc_office_managed_cash_event returns correct students" do
    result = @event.sc_office_managed_cash_event
    
    assert_includes result, students(:SL_O)
    assert_includes result, students(:S_O)
    assert_equal 2, result.size
  end

  test "student_life_managed_students returns correct students" do
    result = @event.student_life_managed_students
    
    assert_includes result, students(:SL_S)
    assert_includes result, students(:SL_S2)
    assert_equal 2, result.size
  end

  test "cash_to_sc_office returns correct students" do
    result = @event.cash_to_sc_office

    assert_includes result, students(:SL_S)
    assert_includes result, students(:SL_S2)
    assert_includes result, students(:SL_O)
    assert_includes result, students(:S_O)
    assert_equal 4, result.size
  end

  test "cash_to_students returns correct students" do
    result = @event.cash_to_students
  
    assert_includes result, students(:S_S)
    assert_includes result, students(:S_S2)
    assert_equal 2, result.size
  end

  test "cash_to_students with advisor returns correct students" do
    result = @event.cash_to_students(advisors(:two).id)
  
    assert_includes result, students(:S_S2)
    assert_equal 1, result.size
  end

  # test "cash_to_sc_office with advisor returns correct students" do
  #   result = @event.cash_to_sc_office

  #   assert_includes result, students(:SL_S2)
  #   assert_equal 1, result.size
  # end
end