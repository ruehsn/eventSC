require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  def login_as(email)
    user = User.find_by(email: email)
    unless user
      user = User.create!(email: email, is_admin: email.start_with?("admin@"))
    end
    # Generate magic login token and visit login show action
    token = user.generate_token_for(:magic_login)
    visit login_path(token: token)
    # After redirect we should be at root
    assert_current_path root_path
    user
  end

  test "regular user sees base nav links and no admin dropdown" do
  user = users(:one)
  login_as(user.email)

    assert_selector "nav a", text: "All Students"
    assert_selector "nav a", text: "Advisors"
    assert_selector "nav a", text: "Events"
    refute_text "User Management"
    refute_text "Create New Event"
  end

  test "admin user sees admin dropdown links" do
  admin = users(:admin)
  login_as(admin.email)

    # Hover not easily triggered headless; just assert presence in DOM (they are rendered conditionally by helper)
    assert_text "Admin"
    assert_text "User Management"
    assert_text "Create New Event"
  end
end
