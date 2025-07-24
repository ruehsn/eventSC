require "test_helper"

class LivingAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @living_area = living_areas(:one)
  end

  test "should get index" do
    get living_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_living_area_url
    assert_response :success
  end

  test "should create living_area" do
    assert_difference("LivingArea.count") do
      post living_areas_url, params: { living_area: { description: @living_area.description, name: @living_area.name } }
    end

    assert_redirected_to living_area_url(LivingArea.last)
  end

  test "should show living_area" do
    get living_area_url(@living_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_living_area_url(@living_area)
    assert_response :success
  end

  test "should update living_area" do
    patch living_area_url(@living_area), params: { living_area: { description: @living_area.description, name: @living_area.name } }
    assert_redirected_to living_area_url(@living_area)
  end

  test "should destroy living_area" do
    assert_difference("LivingArea.count", -1) do
      delete living_area_url(@living_area)
    end

    assert_redirected_to living_areas_url
  end
end
