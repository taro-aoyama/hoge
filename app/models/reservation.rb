class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :facility

  # ステータスの定義
  enum status: {
    pending: 0,         # 承認待ち
    approved: 1,        # 承認済み
    rejected: 2,        # 拒否
    cancelled: 3,       # キャンセル
    lottery_pending: 4, # 抽選待ち
    won: 5,             # 当選
    lost: 6,            # 落選
    waitlisted: 7       # 補欠
  }

  # バリデーション
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :purpose, presence: true, length: { maximum: 500 }
  validates :total_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :end_time_after_start_time
  validate :future_reservation
  validate :facility_available

  # スコープ
  scope :upcoming, -> { where('start_time > ?', Time.current) }
  scope :past, -> { where('end_time < ?', Time.current) }
  scope :current, -> { where('start_time <= ? AND end_time > ?', Time.current, Time.current) }

  private

  def end_time_after_start_time
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, 'は開始時刻より後である必要があります')
    end
  end

  def future_reservation
    return unless start_time

    if start_time <= Time.current
      errors.add(:start_time, 'は現在時刻より後である必要があります')
    end
  end

  def facility_available
    return unless facility && start_time && end_time

    unless facility.available_at?(start_time, end_time)
      errors.add(:base, 'この時間帯は既に予約されています')
    end
  end
end
