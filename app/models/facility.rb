class Facility < ApplicationRecord
  # アソシエーション
  has_many :facility_managers, dependent: :destroy
  has_many :managers, through: :facility_managers, source: :user
  has_many :reservations, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :hourly_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # スコープ
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # メソッド
  def available_at?(start_time, end_time)
    return false unless active?

    # 指定された時間帯に予約が重複していないかチェック
    overlapping_reservations = reservations.approved.where(
      "(start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?)",
      start_time, start_time, end_time, end_time
    )

    overlapping_reservations.empty?
  end

  def calculate_fee(start_time, end_time)
    duration_hours = ((end_time - start_time) / 1.hour).ceil
    duration_hours * hourly_rate
  end

  # 抽選機能で追加予定のモデル構造:
  #
  # LotteryPeriod（抽選期間）
  # - facility_id: 施設ID
  # - start_date: 抽選対象期間開始日
  # - end_date: 抽選対象期間終了日
  # - application_start: 申込開始日時
  # - application_end: 申込終了日時
  # - lottery_date: 抽選実行日
  # - status: ステータス（accepting, closed, executed）
  # - max_applications_per_user: 1ユーザーあたりの申込上限
  #
  # LotteryApplication（抽選申込）
  # - lottery_period_id: 抽選期間ID
  # - user_id: 申込者ID
  # - start_time: 希望開始時刻
  # - end_time: 希望終了時刻
  # - purpose: 利用目的
  # - priority: 希望優先順位
  # - status: ステータス（submitted, won, lost）
  # - total_fee: 利用料金
  #
  # LotteryResult（抽選結果）
  # - lottery_application_id: 抽選申込ID
  # - won: 当選フラグ
  # - executed_at: 抽選実行日時
  # - notification_sent_at: 通知送信日時
end
