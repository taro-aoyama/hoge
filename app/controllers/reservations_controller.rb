class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = case current_user.role
                    when 'system_admin'
                      Reservation.all
                    when 'facility_manager'
                      Reservation.where(facility_id: current_user.managed_facility_ids)
                    else
                      current_user.reservations
                    end

    # ページネーションを後で追加することを検討
    @reservations = @reservations.includes(:user, :facility)

    # フィルタリング
    if params[:status].present?
      @reservations = @reservations.where(status: params[:status])
    end
    if params[:start_date].present?
      @reservations = @reservations.where("start_time >= ?", Date.parse(params[:start_date]).beginning_of_day)
    end
    if params[:end_date].present?
      @reservations = @reservations.where("end_time <= ?", Date.parse(params[:end_date]).end_of_day)
    end

    @reservations = @reservations.order(start_time: :desc)
  end
end
