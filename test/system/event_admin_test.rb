require "application_system_test_case"

class EventAdminTest < ApplicationSystemTestCase
  test "admin can create, edit, and delete events" do
    # Log in as admin
    admin = User.find_or_create_by!(email: "admin1@shepherdscollege.edu", is_admin: true)
    token = admin.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text admin.email

  # Create a new event via nav bar
  visit root_path
  click_button "Admin"
  click_link "Create New Event"
  fill_in "Name", with: "Test Event"
  fill_in "Date", with: Date.today.strftime("%Y-%m-%d")
  click_button "Create Event"
  assert_text "Event was successfully created."
  assert_text "Test Event"

  # Edit the event (visit admin view for edit/delete links)
  visit events_path(admin_view: true)
  within(:xpath, "//tr[td[contains(., 'Test Event')]]") do
    click_link "Edit"
  end
  fill_in "Name", with: "Test Event Updated"
  click_button "Update Event"
  assert_text "Event was successfully updated."
  assert_text "Test Event Updated"

  # Delete the event
  visit events_path(admin_view: true)
  within(:xpath, "//tr[td[contains(., 'Test Event Updated')]]") do
    click_link "Delete"
  end
  assert_text "Event was successfully destroyed."
  assert_no_text "Test Event Updated"
  end
end
