require "application_system_test_case"

class AdminAccessTest < ApplicationSystemTestCase
  test "admin-only buttons are hidden for non-admins" do
    # Create and log in as a non-admin user
    user = User.find_or_create_by!(email: "student1@shepherdscollege.edu", is_admin: false)
    token = user.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text user.email

    # Check Advisors index for missing admin buttons
    visit advisors_path
    assert_no_text "New advisor"
    assert_no_selector "a", text: "Edit"
    assert_no_selector "a", text: "Delete"

    # Check Students index for missing admin buttons
    visit students_path
    assert_no_text "New student"
    assert_no_selector "a", text: "Edit"
    assert_no_selector "a", text: "Delete"

    # Check Events index for missing admin buttons
    visit events_path
    assert_no_text "New event"
    assert_no_selector "a", text: "Edit"
    assert_no_selector "a", text: "Delete"
  end
end
