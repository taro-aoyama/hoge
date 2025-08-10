class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ロールの定義
  enum role: {
    general_user: 0,        # 一般ユーザー（施設予約のみ）
    facility_manager: 1,    # 施設管理者（特定施設の管理）
    system_admin: 2         # システム管理者（全体管理）
  }

  # ロール判定のヘルパーメソッド
  def can_manage_facilities?
    facility_manager? || system_admin?
  end

  def can_manage_system?
    system_admin?
  end

  def can_make_reservations?
    true # 全ユーザーが予約可能
  end

  # アソシエーション
  has_many :facility_managers, dependent: :destroy
  has_many :managed_facilities, through: :facility_managers, source: :facility
  has_many :reservations, dependent: :destroy

  # 施設管理システムで必要になるモデル構造の例：
  #
  # Facility（施設）
  # - name: 施設名
  # - description: 施設説明
  # - location: 所在地
  # - capacity: 収容人数
  # - hourly_rate: 時間単価
  # - active: 利用可能フラグ
  #
  # FacilityManager（施設管理者の関連）
  # - user_id: ユーザーID
  # - facility_id: 施設ID
  # ※ facility_managerロールのユーザーが管理できる施設を定義
  #
  # Reservation（予約）
  # - user_id: 予約者
  # - facility_id: 施設
  # - start_time: 開始時刻
  # - end_time: 終了時刻
  # - status: 予約ステータス（pending, approved, rejected, cancelled）
  # - purpose: 利用目的
  # - total_fee: 利用料金
end
