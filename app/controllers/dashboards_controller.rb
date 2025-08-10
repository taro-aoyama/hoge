class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    case current_user.role
    when 'general_user'
      @reservable_facilities_count = Facility.where(active: true).count
      @my_reservations_count = current_user.reservations.count
    when 'facility_manager'
      @managed_facilities_count = current_user.managed_facilities.count
      @pending_reservations_count = Reservation.where(facility: current_user.managed_facilities, status: :pending).count
    when 'system_admin'
      @total_users_count = User.count
      @total_facilities_count = Facility.count
      @total_reservations_count = Reservation.count
    end
  end
end
