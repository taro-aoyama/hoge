require "application_system_test_case"

class FacilitiesTest < ApplicationSystemTestCase
  setup do
    @facility_one = facilities(:one)
    @facility_two = facilities(:two)
  end

  test "visiting the index" do
    visit facilities_url
    assert_selector "h1", text: "Facilities"
  end

  test "searching for a facility" do
    visit facilities_url

    fill_in "Name", with: @facility_one.name
    click_on "Search"

    assert_text @facility_one.name
    assert_no_text @facility_two.name
  end
end
