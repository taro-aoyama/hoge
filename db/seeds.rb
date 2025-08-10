# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 既存のデータをクリア（開発環境のみ）
if Rails.env.development?
  puts "🧹 既存データをクリアしています..."
  Reservation.destroy_all
  FacilityManager.destroy_all
  Facility.destroy_all
  User.destroy_all
  puts "✅ クリア完了"
end

# システム管理者の作成
puts "👤 システム管理者を作成しています..."
admin_user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  role: :system_admin
)
puts "✅ システム管理者作成完了: #{admin_user.email}"

# 施設管理者の作成
puts "👥 施設管理者を作成しています..."
facility_managers = []

# 体育館管理者
gym_manager = User.create!(
  email: 'gym_manager@example.com',
  password: 'password123',
  role: :facility_manager
)
facility_managers << gym_manager

# 会議室管理者
meeting_manager = User.create!(
  email: 'meeting_manager@example.com',
  password: 'password123',
  role: :facility_manager
)
facility_managers << meeting_manager

# ホール管理者
hall_manager = User.create!(
  email: 'hall_manager@example.com',
  password: 'password123',
  role: :facility_manager
)
facility_managers << hall_manager

puts "✅ 施設管理者作成完了: #{facility_managers.count}人"

# 一般ユーザーの作成
puts "👤 一般ユーザーを作成しています..."
general_users = []

5.times do |i|
  user = User.create!(
    email: "user#{i+1}@example.com",
    password: 'password123',
    role: :general_user
  )
  general_users << user
end

puts "✅ 一般ユーザー作成完了: #{general_users.count}人"

# 施設の作成
puts "🏢 施設を作成しています..."
facilities = []

# 市民体育館
gym = Facility.create!(
  name: '市民体育館 メインアリーナ',
  description: 'バスケットボール、バレーボール、バドミントンなどの競技に対応した総合体育館です。観客席200席を完備しています。',
  location: '〒100-0001 東京都千代田区千代田1-1-1',
  capacity: 200,
  hourly_rate: 2000,
  active: true
)
facilities << gym

# 小会議室A
meeting_room_a = Facility.create!(
  name: '市民センター 小会議室A',
  description: '20名程度の会議や研修に最適な会議室です。プロジェクター、ホワイトボード完備。',
  location: '〒100-0002 東京都千代田区千代田2-2-2',
  capacity: 20,
  hourly_rate: 500,
  active: true
)
facilities << meeting_room_a

# 小会議室B
meeting_room_b = Facility.create!(
  name: '市民センター 小会議室B',
  description: '15名程度の小規模会議や打ち合わせに適した会議室です。',
  location: '〒100-0002 東京都千代田区千代田2-2-2',
  capacity: 15,
  hourly_rate: 400,
  active: true
)
facilities << meeting_room_b

# 大会議室
meeting_room_large = Facility.create!(
  name: '市民センター 大会議室',
  description: '50名収容可能な大会議室。セミナーや講演会に最適。音響設備完備。',
  location: '〒100-0002 東京都千代田区千代田2-2-2',
  capacity: 50,
  hourly_rate: 1200,
  active: true
)
facilities << meeting_room_large

# 多目的ホール
hall = Facility.create!(
  name: '文化センター 多目的ホール',
  description: '300名収容の多目的ホール。コンサート、演劇、講演会など様々なイベントに対応。舞台・照明・音響設備完備。',
  location: '〒100-0003 東京都千代田区千代田3-3-3',
  capacity: 300,
  hourly_rate: 5000,
  active: true
)
facilities << hall

# 料理教室
cooking_room = Facility.create!(
  name: '生涯学習センター 料理教室',
  description: '20名まで対応の料理教室。調理台10台、オーブン、冷蔵庫完備。',
  location: '〒100-0004 東京都千代田区千代田4-4-4',
  capacity: 20,
  hourly_rate: 800,
  active: true
)
facilities << cooking_room

# メンテナンス中の施設
maintenance_room = Facility.create!(
  name: '図書館 研修室',
  description: 'リノベーション工事のため、現在ご利用いただけません。',
  location: '〒100-0005 東京都千代田区千代田5-5-5',
  capacity: 30,
  hourly_rate: 600,
  active: false
)
facilities << maintenance_room

puts "✅ 施設作成完了: #{facilities.count}箇所"

# 施設管理者の割り当て
puts "🔗 施設管理者を割り当てています..."

# 体育館管理者 → 体育館
FacilityManager.create!(user: gym_manager, facility: gym)

# 会議室管理者 → 会議室全般
FacilityManager.create!(user: meeting_manager, facility: meeting_room_a)
FacilityManager.create!(user: meeting_manager, facility: meeting_room_b)
FacilityManager.create!(user: meeting_manager, facility: meeting_room_large)

# ホール管理者 → ホール、料理教室
FacilityManager.create!(user: hall_manager, facility: hall)
FacilityManager.create!(user: hall_manager, facility: cooking_room)

# システム管理者 → メンテナンス中施設
FacilityManager.create!(user: admin_user, facility: maintenance_room)

puts "✅ 施設管理者割り当て完了"

# 予約データの作成
puts "📅 予約データを作成しています..."

# 今日から30日後までの範囲で予約を作成
base_date = Date.current
reservations_count = 0

# 承認済み予約の作成
15.times do |i|
  start_date = base_date + (i % 7).days
  start_time = start_date.beginning_of_day + [9, 10, 13, 14, 15, 16, 18, 19].sample.hours
  end_time = start_time + [1, 2, 3].sample.hours

  facility = facilities.select(&:active).sample
  user = general_users.sample

  reservation = Reservation.create!(
    user: user,
    facility: facility,
    start_time: start_time,
    end_time: end_time,
    status: :approved,
    purpose: [
      '地域サークル活動',
      '企業研修',
      '住民説明会',
      'スポーツ大会',
      '文化イベント',
      '会社会議',
      '勉強会',
      'セミナー開催'
    ].sample,
    total_fee: facility.calculate_fee(start_time, end_time)
  )
  reservations_count += 1
rescue ActiveRecord::RecordInvalid
  # 時間が重複した場合は次へ
  next
end

# 承認待ち予約の作成
5.times do |i|
  start_date = base_date + (15 + i).days
  start_time = start_date.beginning_of_day + [10, 14, 16].sample.hours
  end_time = start_time + [2, 3].sample.hours

  facility = facilities.select(&:active).sample
  user = general_users.sample

  begin
    reservation = Reservation.create!(
      user: user,
      facility: facility,
      start_time: start_time,
      end_time: end_time,
      status: :pending,
      purpose: [
        'イベント企画',
        '展示会',
        '発表会',
        'ワークショップ',
        '交流会'
      ].sample,
      total_fee: facility.calculate_fee(start_time, end_time)
    )
    reservations_count += 1
  rescue ActiveRecord::RecordInvalid
    # 時間が重複した場合は次へ
    next
  end
end

# 過去の予約（履歴として）
10.times do |i|
  start_date = base_date - (i + 1).days
  start_time = start_date.beginning_of_day + [9, 10, 13, 14, 15, 16].sample.hours
  end_time = start_time + [1, 2, 3].sample.hours

  facility = facilities.select(&:active).sample
  user = general_users.sample

  begin
    reservation = Reservation.create!(
      user: user,
      facility: facility,
      start_time: start_time,
      end_time: end_time,
      status: [:approved, :approved, :approved, :cancelled].sample, # 承認が多め
      purpose: [
        '定例会議',
        '研修会',
        'イベント',
        'スポーツ活動',
        '講演会'
      ].sample,
      total_fee: facility.calculate_fee(start_time, end_time)
    )
    reservations_count += 1
  rescue ActiveRecord::RecordInvalid
    # 時間が重複した場合は次へ
    next
  end
end

puts "✅ 予約データ作成完了: #{reservations_count}件"

# サマリー出力
puts "\n" + "="*50
puts "🎉 シードデータ作成完了！"
puts "="*50
puts "📊 作成されたデータ:"
puts "   👤 ユーザー: #{User.count}人"
puts "      - システム管理者: #{User.system_admin.count}人"
puts "      - 施設管理者: #{User.facility_manager.count}人"
puts "      - 一般ユーザー: #{User.general_user.count}人"
puts "   🏢 施設: #{Facility.count}箇所"
puts "      - 利用可能: #{Facility.active.count}箇所"
puts "      - メンテナンス中: #{Facility.inactive.count}箇所"
puts "   📅 予約: #{Reservation.count}件"
puts "      - 承認済み: #{Reservation.approved.count}件"
puts "      - 承認待ち: #{Reservation.pending.count}件"
puts "      - キャンセル: #{Reservation.cancelled.count}件"
puts "="*50
puts "\n🔐 ログイン情報:"
puts "   システム管理者: admin@example.com / password123"
puts "   体育館管理者: gym_manager@example.com / password123"
puts "   会議室管理者: meeting_manager@example.com / password123"
puts "   ホール管理者: hall_manager@example.com / password123"
puts "   一般ユーザー: user1@example.com ~ user5@example.com / password123"
puts "="*50
