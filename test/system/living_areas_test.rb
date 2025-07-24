require "application_system_test_case"

class LivingAreasTest < ApplicationSystemTestCase
  setup do
    @living_area = living_areas(:one)
  end

  test "visiting the index" do
    visit living_areas_url
    assert_selector "h1", text: "Living areas"
  end

  test "should create living area" do
    visit living_areas_url
    click_on "New living area"

    fill_in "Description", with: @living_area.description
    fill_in "Name", with: @living_area.name
    click_on "Create Living area"

    assert_text "Living area was successfully created"
    click_on "Back"
  end

  test "should update Living area" do
    visit living_area_url(@living_area)
    click_on "Edit this living area", match: :first

    fill_in "Description", with: @living_area.description
    fill_in "Name", with: @living_area.name
    click_on "Update Living area"

    assert_text "Living area was successfully updated"
    click_on "Back"
  end

  test "should destroy Living area" do
    visit living_area_url(@living_area)
    click_on "Destroy this living area", match: :first

    assert_text "Living area was successfully destroyed"
  end
end
