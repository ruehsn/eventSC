require "application_system_test_case"

class LoginFlowTest < ApplicationSystemTestCase
  test "logout flow" do
    user = User.find_or_create_by!(email: "user4@shepherdscollege.edu")
    token = user.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text user.email
    # Click logout link/button
    click_link_or_button "Logout"
    assert_text "Logged out successfully."
    assert_current_path root_path
    assert_no_text user.email
  end

  test "login link email delivery notice" do
    visit login_path
    fill_in :email, with: "user1@shepherdscollege.edu"
    click_button "Send me login link"
    assert_text "Check your email to login."
  end

  test "unregistered shepherds email login" do
    visit login_path
    fill_in :email, with: "notfound@shepherdscollege.edu"
    click_button "Send me login link"
    assert_text "You do not currently have access to this system. Please contact Heather to be added."
  end
  test "non-shepherds email login" do
    visit login_path
    fill_in :email, with: "user@gmail.com"
    click_button "Send me login link"
    assert_text "Invalid email, reminder to use your work email address are allowed."
  end
  test "valid magic link login" do
    user = User.find_or_create_by!(email: "user1@shepherdscollege.edu")
    token = user.generate_token_for(:magic_login)
    visit login_path(token: token)
    assert_text "All Students"
    assert_text user.email
  end

  test "invalid magic link login" do
    visit login_path(token: "invalidtoken")
    assert_text "Invalid or expired login link."
  end

  test "expired magic link login" do
      user = User.find_or_create_by!(email: "user2@shepherdscollege.edu")
      token = user.generate_token_for(:magic_login)
      # Simulate expiry by traveling past the token's expiry
      travel_to 2.hours.from_now do
        visit login_path(token: token)
        assert_text "Invalid or expired login link."
      end
  end
end
