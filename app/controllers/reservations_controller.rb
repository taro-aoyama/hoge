class ReservationsController < ApplicationController
  before_action :set_facility, only: [:new, :create]
  before_action :set_reservation, only: [:show]

  def new
    @reservation = @facility.reservations.new
  end

  def show
  end

  def create
    @reservation = @facility.reservations.new(reservation_params)
    @reservation.user = current_user
    @reservation.status = :pending
    @reservation.total_fee = @facility.calculate_fee(@reservation.start_time, @reservation.end_time)

    if @reservation.save
      redirect_to facility_reservation_path(@facility, @reservation), notice: '予約が正常に作成されました。'
    else
      render :new
    end
  end

  private

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :purpose)
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
