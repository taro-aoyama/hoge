class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # ユーザーのロールに基づいて適切なダッシュボードにリダイレクト
  def show
    case current_user.role.to_sym
    when :general_user
      redirect_to dashboards_general_user_path
    when :facility_manager
      redirect_to dashboards_facility_manager_path
    when :system_admin
      redirect_to dashboards_system_admin_path
    else
      # 不明なロールの場合はルートパスにリダイレクト
      redirect_to root_path, alert: "不明なユーザーロールです。"
    end
  end

  def general_user
    @bookable_facilities_count = Facility.where(active: true).count
    @my_reservations_count = current_user.reservations.count
  end

  def facility_manager
    @managed_facilities_count = current_user.managed_facilities.count
    @pending_reservations_count = Reservation.where(facility_id: current_user.managed_facility_ids, status: :pending).count
  end

  def system_admin
    @total_users_count = User.count
    @total_facilities_count = Facility.count
    @total_reservations_count = Reservation.count
  end
end
