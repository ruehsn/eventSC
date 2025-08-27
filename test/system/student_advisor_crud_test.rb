require "application_system_test_case"

class StudentAdvisorCrudTest < ApplicationSystemTestCase
  test "admin can create, edit, and delete students" do
    admin = User.find_or_create_by!(email: "admin2@shepherdscollege.edu", is_admin: true)
    token = admin.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text admin.email

    # Create student
    visit students_path
    click_link "New student"
    fill_in "Short name", with: "TestStudent"
    fill_in "First name", with: "Test"
    fill_in "Last name", with: "Student"
  # Select first valid (non-placeholder) living area
  living_area_select = find("select[name='student[living_area_id]']")
  living_area_select.find_all("option").reject { |opt| opt.text.include?("Select") }.first.select_option
  # Select first valid (non-placeholder) advisor
  advisor_select = find("select[name='student[advisor_id]']")
  advisor_select.find_all("option").reject { |opt| opt.text.include?("Select") }.first.select_option
  find("input[name='student[year]']").set(Date.today.year + 3)
  click_button "Create Student"
  assert_text "Student was successfully created."
  assert_text "TestStudent"

    # Edit student
    visit students_path(admin_view: true)
    within(:xpath, "//tr[td[contains(., 'TestStudent')]]") do
      click_link "Edit"
    end
    fill_in "First name", with: "TestUpdated"
    click_button "Update Student"
    assert_text "Student was successfully updated."
    assert_text "TestUpdated"

    # Delete student
    visit students_path(admin_view: true)
    within(:xpath, "//tr[td[contains(., 'TestStudent')]]") do
      click_link "Delete"
    end
    assert_text "Student was successfully destroyed."
    assert_no_text "TestStudent"
  end

  test "admin can create, edit, and delete advisors" do
    admin = User.find_or_create_by!(email: "admin2@shepherdscollege.edu", is_admin: true)
    token = admin.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text admin.email

  # Create advisor
  visit advisors_path
  click_link "New advisor"
  fill_in "First name", with: "Test"
  fill_in "Last name", with: "Advisor"
  fill_in "Email", with: "testadvisor@shepherdscollege.edu"
  click_button "Create Advisor"
  assert_text "Advisor was successfully created."
  visit advisors_path
  assert_text "Test Advisor"

    # Edit advisor
    visit advisors_path(admin_view: true)
    within(:xpath, "//tr[td[contains(., 'Test Advisor')]]") do
      click_link "Edit"
    end
    fill_in "First name", with: "TestUpdated"
    click_button "Update Advisor"
    assert_text "Advisor was successfully updated."
    assert_text "TestUpdated"

    # Delete advisor
    visit advisors_path(admin_view: true)
    within(:xpath, "//tr[td[contains(., 'TestUpdated')]]") do
      click_link "Delete"
    end
    assert_text "Advisor was successfully destroyed."
    assert_no_text "TestUpdated"
  end
end
