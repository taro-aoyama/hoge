require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @general_user = users(:general_user)
    @facility_manager = users(:facility_manager)
    @system_admin = users(:system_admin)

    @facility1 = facilities(:facility1)
    @facility2 = facilities(:facility2)

    # General user's reservation
    @reservation1 = reservations(:reservation1) # Belongs to general_user, facility1
    # Facility manager's reservation for a facility they don't manage
    @reservation2 = reservations(:reservation2) # Belongs to facility_manager, facility2
    # Reservation for a facility managed by facility_manager
    @reservation3 = reservations(:reservation3) # Belongs to general_user, facility1 (managed by facility_manager)
  end

  test "general user sees only their own reservations" do
    sign_in @general_user
    visit reservations_path

    assert_text @reservation1.purpose
    assert_no_text @reservation2.purpose
    assert_no_text @reservation3.purpose
  end

  test "facility manager sees reservations for their managed facilities" do
    sign_in @facility_manager
    visit reservations_path

    assert_text @reservation1.purpose # In managed facility
    assert_no_text @reservation2.purpose # Not in managed facility
    assert_text @reservation3.purpose # In managed facility
  end

  test "system admin sees all reservations" do
    sign_in @system_admin
    visit reservations_path

    assert_text @reservation1.purpose
    assert_text @reservation2.purpose
    assert_text @reservation3.purpose
  end

  test "filtering by status" do
    sign_in @system_admin
    visit reservations_path

    select "承認済み", from: "status"
    click_on "絞り込み"

    assert_text @reservation1.purpose
    assert_no_text reservations(:pending_reservation).purpose
  end

  test "filtering by date range" do
    sign_in @system_admin
    visit reservations_path

    fill_in "start_date", with: Date.tomorrow
    fill_in "end_date", with: Date.tomorrow + 2.days
    click_on "絞り込み"

    assert_text reservations(:future_reservation).purpose
    assert_no_text @reservation1.purpose
  end
end
