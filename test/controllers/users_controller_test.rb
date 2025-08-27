require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_admin_integration
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get show" do
    get user_url(users(:admin))
    assert_response :success
  end

  test "should get update" do
    patch user_url(users(:admin)), params: { user: { name: "Updated" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
