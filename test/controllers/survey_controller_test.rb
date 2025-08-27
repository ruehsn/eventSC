require "test_helper"

class SurveyControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_admin_integration
  end

  test "should get index" do
    get survey_index_url
    assert_response :success
  end

  test "should get show" do
    event = events(:one)
    get survey_url(event)
    assert_response :success
  end
end
