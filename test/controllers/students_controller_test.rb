require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_admin_integration
    @student = students(:one)
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      post students_url, params: { student: { advisor_id: @student.advisor_id, first_name: @student.first_name, gender: @student.gender, last_name: @student.last_name, living_area_id: @student.living_area_id, major: @student.major, notes_url: @student.notes_url, short_name: "NewUnique", year: @student.year } }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { advisor_id: @student.advisor_id, first_name: @student.first_name, gender: @student.gender, last_name: @student.last_name, living_area_id: @student.living_area_id, major: @student.major, notes_url: @student.notes_url, short_name: @student.short_name, year: @student.year } }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end

  # test "should split students into groups based on event option selection" do
  #   get split_students_url
  #   assert_response :success
  #   # Add assertions to verify the grouping logic
  # end

  test "should handle 'No, Thanks' and 'Off Campus' checkboxes" do
    event = events(:one)
    post events_url, params: { event: { name: "Test Event", date: Date.tomorrow, no_thanks: true, off_campus: false } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    # Add assertions to verify the checkbox handling
  end
end
