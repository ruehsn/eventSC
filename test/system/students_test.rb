require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  setup do
    @student = students(:one)
  end

  # test "visiting the index" do
  #   visit students_url
  #   assert_selector "h1", text: "Students"
  # end
  #
  # test "should create student" do
  #   visit students_url
  #   click_on "New student"
  #
  #   fill_in "Advisor", with: @student.advisor_id
  #   fill_in "First name", with: @student.first_name
  #   fill_in "Gender", with: @student.gender
  #   fill_in "Last name", with: @student.last_name
  #   fill_in "Living area", with: @student.living_area_id
  #   fill_in "Major", with: @student.major
  #   fill_in "Notes url", with: @student.notes_url
  #   fill_in "Short name", with: @student.short_name
  #   fill_in "Year", with: @student.year
  #   click_on "Create Student"
  #
  #   assert_text "Student was successfully created"
  #   click_on "Back"
  # end
  #
  # test "should update Student" do
  #   visit student_url(@student)
  #   click_on "Edit this student", match: :first
  #
  #   fill_in "Advisor", with: @student.advisor_id
  #   fill_in "First name", with: @student.first_name
  #   fill_in "Gender", with: @student.gender
  #   fill_in "Last name", with: @student.last_name
  #   fill_in "Living area", with: @student.living_area_id
  #   fill_in "Major", with: @student.major
  #   fill_in "Notes url", with: @student.notes_url
  #   fill_in "Short name", with: @student.short_name
  #   fill_in "Year", with: @student.year
  #   click_on "Update Student"
  #
  #   assert_text "Student was successfully updated"
  #   click_on "Back"
  # end
  #
  # test "should destroy Student" do
  #   visit student_url(@student)
  #   click_on "Destroy this student", match: :first
  #
  #   assert_text "Student was successfully destroyed"
  # end
end
