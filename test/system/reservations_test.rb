require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:general_user)
    @facility = facilities(:meeting_room_a)
    sign_in @user
  end

  test "creating a new reservation" do
    visit new_reservation_path

    # フォームを埋める
    select @facility.name, from: "reservation_facility_id"

    start_time = Time.current.tomorrow.change(hour: 10)
    end_time = Time.current.tomorrow.change(hour: 12)

    fill_in "reservation_start_time", with: start_time
    fill_in "reservation_end_time", with: end_time
    fill_in "reservation_purpose", with: "部門の定例会議"

    # 料金が動的に計算されることを確認
    # 2時間 * 1000円/時間 = 2000円
    assert_text "¥2,000"

    click_on "確認画面へ"

    # 確認画面
    assert_current_path confirm_reservations_path
    assert_text @facility.name
    assert_text start_time.strftime('%Y/%m/%d %H:%M')
    assert_text end_time.strftime('%Y/%m/%d %H:%M')
    assert_text "部門の定例会議"
    assert_text "¥2,000"

    assert_difference("Reservation.count", 1) do
      click_on "予約を確定する"
    end

    # 詳細ページにリダイレクトされる
    assert_text "予約が正常に作成され、承認待ちです。"
    assert_text "承認待ち"

    # データベースの確認
    reservation = Reservation.last
    assert_equal @user, reservation.user
    assert_equal @facility, reservation.facility
    assert_equal "pending", reservation.status
  end

  test "cannot create a reservation for an overlapping time" do
    # 既存の承認済み予約を作成
    existing_reservation = Reservation.create!(
      user: @user,
      facility: @facility,
      start_time: Time.current.tomorrow.change(hour: 13),
      end_time: Time.current.tomorrow.change(hour: 15),
      purpose: "既存の予約",
      total_fee: 2000,
      status: :approved
    )

    visit new_reservation_path

    # 重複する時間帯でフォームを埋める
    select @facility.name, from: "reservation_facility_id"
    fill_in "reservation_start_time", with: existing_reservation.start_time
    fill_in "reservation_end_time", with: existing_reservation.end_time
    fill_in "reservation_purpose", with: "重複する会議"

    click_on "確認画面へ"
    click_on "予約を確定する"

    # エラーメッセージが表示される
    assert_text "この時間帯は既に予約されています"

    # 予約が作成されていないことを確認
    assert_no_difference("Reservation.count")
  end
end
