class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @facilities = Facility.active
  end

  def confirm
    @reservation = Reservation.new(reservation_params)
    @facility = Facility.find(reservation_params[:facility_id])
    @reservation.total_fee = @facility.calculate_fee(
      @reservation.start_time,
      @reservation.end_time
    )

    if @reservation.valid?
      render :confirm
    else
      @facilities = Facility.active
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.status = :pending

    if @reservation.save
      redirect_to @reservation, notice: '予約が正常に作成され、承認待ちです。'
    else
      @facilities = Facility.active
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :facility_id,
      :start_time,
      :end_time,
      :purpose,
      :total_fee
    )
  end
end
