require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:general_user)
    @facility = facilities(:reservable_facility)
    sign_in @user
  end

  test "creating a new reservation" do
    visit facilities_url
    click_on "予約する", match: :first

    select "2025", from: "reservation_start_time_1i"
    select "December", from: "reservation_start_time_2i"
    select "25", from: "reservation_start_time_3i"
    select "10", from: "reservation_start_time_4i"
    select "00", from: "reservation_start_time_5i"

    select "2025", from: "reservation_end_time_1i"
    select "December", from: "reservation_end_time_2i"
    select "25", from: "reservation_end_time_3i"
    select "12", from: "reservation_end_time_4i"
    select "00", from: "reservation_end_time_5i"

    fill_in "利用目的", with: "Test reservation"

    assert_text "合計料金: 2000円"

    click_on "予約を確定する"

    assert_text "予約が正常に作成されました。"
    assert_text "保留"
    assert_text "合計料金: 2000"
  end
end
