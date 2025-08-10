class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :confirm, :decline]

  def index
    @reservations = current_user.reservations.order(created_at: :desc)
  end

  def show
  end

  def confirm
    if @reservation.won?
      @reservation.update(status: :approved)
      redirect_to @reservation, notice: '予約を確定しました。'
    else
      redirect_to @reservation, alert: 'この予約は確定できません。'
    end
  end

  def decline
    if @reservation.won?
      @reservation.update(status: :cancelled)
      promote_waitlisted_user(@reservation.facility, @reservation.start_time)
      redirect_to reservations_path, notice: '予約を辞退しました。'
    else
      redirect_to @reservation, alert: 'この予約は辞退できません。'
    end
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def promote_waitlisted_user(facility, start_time)
    waitlisted_reservations = Reservation.where(facility: facility, start_time: start_time, status: :waitlisted).order(:waitlist_rank)

    next_winner = waitlisted_reservations.first
    if next_winner
      next_winner.update(status: :won, waitlist_rank: nil)

      # 他の補欠者のランクを繰り上げる
      waitlisted_reservations.where.not(id: next_winner.id).each do |reservation|
        reservation.decrement!(:waitlist_rank)
      end
    end
  end
end
