require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @general_user = users(:general_user)
    @facility_manager = users(:facility_manager_user)
    @system_admin = users(:system_admin_user)
  end

  test "should redirect to sign in page if not authenticated" do
    get dashboard_url
    assert_redirected_to new_user_session_path
  end

  test "should get dashboard for general user" do
    sign_in @general_user
    get dashboard_url
    assert_response :success
    assert_not_nil assigns(:reservable_facilities_count)
    assert_not_nil assigns(:my_reservations_count)
  end

  test "should get dashboard for facility manager" do
    sign_in @facility_manager
    get dashboard_url
    assert_response :success
    assert_not_nil assigns(:managed_facilities_count)
    assert_not_nil assigns(:pending_reservations_count)
  end

  test "should get dashboard for system admin" do
    sign_in @system_admin
    get dashboard_url
    assert_response :success
    assert_not_nil assigns(:total_users_count)
    assert_not_nil assigns(:total_facilities_count)
    assert_not_nil assigns(:total_reservations_count)
  end
end
