# 🗄️ Adminer データベース管理ガイド

このガイドでは、Docker環境で動作するAdminerを使用して、PostgreSQLデータベースを効率的に管理する方法を説明します。

## 📋 目次

- [アクセス方法](#アクセス方法)
- [初回ログイン](#初回ログイン)
- [基本操作](#基本操作)
- [よく使う機能](#よく使う機能)
- [開発で役立つSQL例](#開発で役立つsql例)
- [トラブルシューティング](#トラブルシューティング)

## 🌐 アクセス方法

### 1. Docker環境の起動確認
```bash
# コンテナの状態確認
docker compose ps

# Adminerのログ確認
docker compose logs adminer
```

### 2. ブラウザでアクセス
- **URL**: http://localhost:8080
- **対応ブラウザ**: Chrome, Firefox, Safari, Edge

## 🔐 初回ログイン

Adminerにアクセスすると、ログイン画面が表示されます：

| 項目 | 入力値 | 説明 |
|------|--------|------|
| **データベースシステム** | `PostgreSQL` | 自動選択済み |
| **サーバー** | `db` | Docker Composeサービス名 |
| **ユーザー名** | `postgres` | PostgreSQLユーザー |
| **パスワード** | `password` | 設定済みパスワード |
| **データベース** | `myapp_development` | 開発用DB |

### ログイン手順
1. ブラウザで http://localhost:8080 を開く
2. 上記情報を入力
3. **ログイン**ボタンをクリック

## 🎯 基本操作

### データベース一覧の確認
- 左サイドバーに利用可能なデータベースが表示
- `myapp_development`: 開発用データ
- `myapp_test`: テスト用データ

### テーブル一覧の表示
1. データベース名をクリック
2. メインエリアにテーブル一覧が表示
3. テーブル名をクリックで詳細表示

### 主要なテーブル

| テーブル名 | 説明 | 主要カラム |
|-----------|------|----------|
| **users** | ユーザー情報 | email, role, created_at |
| **facilities** | 施設情報 | name, description, capacity, hourly_rate |
| **reservations** | 予約情報 | user_id, facility_id, start_time, end_time, status |
| **facility_managers** | 施設管理者関連付け | user_id, facility_id |

## 🔧 よく使う機能

### 1. データの表示・検索
```sql
-- 全ユーザーの表示
SELECT * FROM users;

-- 特定ロールのユーザー検索
SELECT * FROM users WHERE role = 'facility_manager';

-- 施設の検索（名前部分一致）
SELECT * FROM facilities WHERE name LIKE '%会議室%';
```

### 2. データの並び替え
- カラムヘッダーをクリックで昇順・降順切り替え
- 複数カラムでの並び替えも可能

### 3. データのフィルタ
- 「検索」リンクをクリック
- 条件を入力してフィルタ実行
- 正規表現も使用可能

### 4. データのエクスポート
1. テーブル選択
2. 「エクスポート」をクリック
3. 形式選択（SQL, CSV, JSON等）
4. ダウンロード実行

## 📊 開発で役立つSQL例

### ユーザー・ロール関連
```sql
-- ロール別ユーザー数
SELECT role, COUNT(*) as user_count 
FROM users 
GROUP BY role;

-- 管理者の一覧
SELECT email, role, created_at 
FROM users 
WHERE role IN ('facility_manager', 'system_admin') 
ORDER BY created_at DESC;
```

### 施設・予約関連
```sql
-- 施設別予約数
SELECT f.name, COUNT(r.id) as reservation_count
FROM facilities f
LEFT JOIN reservations r ON f.id = r.facility_id
GROUP BY f.id, f.name
ORDER BY reservation_count DESC;

-- 今日の予約一覧
SELECT 
    u.email as user_email,
    f.name as facility_name,
    r.start_time,
    r.end_time,
    r.status
FROM reservations r
JOIN users u ON r.user_id = u.id
JOIN facilities f ON r.facility_id = f.id
WHERE DATE(r.start_time) = CURRENT_DATE
ORDER BY r.start_time;

-- 承認待ちの予約
SELECT 
    r.id,
    u.email,
    f.name,
    r.start_time,
    r.purpose,
    r.created_at
FROM reservations r
JOIN users u ON r.user_id = u.id
JOIN facilities f ON r.facility_id = f.id
WHERE r.status = 'pending'
ORDER BY r.created_at ASC;
```

### 統計・分析クエリ
```sql
-- 月別予約数
SELECT 
    DATE_TRUNC('month', start_time) as month,
    COUNT(*) as reservation_count
FROM reservations 
WHERE status = 'approved'
GROUP BY month 
ORDER BY month DESC;

-- 利用率の高い施設TOP5
SELECT 
    f.name,
    f.capacity,
    COUNT(r.id) as total_reservations,
    ROUND(
        COUNT(r.id)::numeric / 
        NULLIF(f.capacity, 0) * 100, 2
    ) as utilization_rate
FROM facilities f
LEFT JOIN reservations r ON f.id = r.facility_id 
    AND r.status = 'approved'
GROUP BY f.id, f.name, f.capacity
ORDER BY utilization_rate DESC
LIMIT 5;

-- ユーザー別予約回数ランキング
SELECT 
    u.email,
    u.role,
    COUNT(r.id) as total_reservations,
    COUNT(CASE WHEN r.status = 'approved' THEN 1 END) as approved_reservations
FROM users u
LEFT JOIN reservations r ON u.id = r.user_id
GROUP BY u.id, u.email, u.role
HAVING COUNT(r.id) > 0
ORDER BY total_reservations DESC;
```

## 🎨 画面カスタマイズ

### テーマの変更
1. ログイン画面右下の「テーマ」選択
2. おすすめテーマ：
   - `pepa-linha-dark`: ダークテーマ（目に優しい）
   - `hydra`: モダンなブルーテーマ
   - `flat`: シンプルなフラットデザイン

### 表示設定
- **行数制限**: 右上の設定で変更可能（デフォルト30行）
- **カラム幅**: ドラッグで調整
- **文字エンコーディング**: UTF-8固定

## 🔍 検索・分析機能

### 高度な検索
```sql
-- 複数条件での検索
SELECT * FROM reservations 
WHERE status = 'approved' 
    AND start_time >= '2024-01-01'
    AND total_fee > 1000;

-- JSON型データの検索（将来的な拡張用）
-- SELECT * FROM facilities 
-- WHERE settings->>'allow_lottery' = 'true';
```

### パフォーマンス分析
```sql
-- クエリの実行計画確認
EXPLAIN ANALYZE 
SELECT f.name, COUNT(r.id)
FROM facilities f
LEFT JOIN reservations r ON f.id = r.facility_id
GROUP BY f.id, f.name;
```

## 🚨 トラブルシューティング

### よくある問題と解決方法

#### 1. Adminerにアクセスできない
```bash
# コンテナの状態確認
docker compose ps

# Adminerコンテナが停止している場合
docker compose restart adminer

# ログの確認
docker compose logs adminer -f
```

#### 2. データベースに接続できない
- **原因**: データベースコンテナが起動していない
- **解決**: `docker compose up -d` でDB起動を確認

#### 3. ログイン認証に失敗
- **サーバー名**: `db` を使用（localhostではない）
- **認証情報**: docker-compose.ymlの設定値と一致させる

#### 4. テーブルが表示されない
```sql
-- スキーマの確認
SELECT schema_name FROM information_schema.schemata;

-- テーブル一覧の確認
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';
```

#### 5. SQLクエリが遅い
```sql
-- インデックスの確認
SELECT tablename, indexname, indexdef 
FROM pg_indexes 
WHERE schemaname = 'public';

-- クエリの最適化
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM your_query_here;
```

## 💡 開発効率化のTips

### 1. よく使うクエリをブックマーク
- SQLタブで実行したクエリは履歴に残る
- 頻用クエリは別途テキストファイルで管理推奨

### 2. データの一括更新
```sql
-- 施設の一括有効化
UPDATE facilities 
SET active = true 
WHERE name LIKE '%会議室%';

-- 予約ステータスの一括変更
UPDATE reservations 
SET status = 'cancelled' 
WHERE start_time < NOW() - INTERVAL '1 day' 
    AND status = 'pending';
```

### 3. テストデータの管理
```sql
-- テストユーザーの一括削除
DELETE FROM users 
WHERE email LIKE '%test%' 
    OR email LIKE '%example%';

-- シードデータの再投入前クリーンアップ
TRUNCATE TABLE reservations, facility_managers RESTART IDENTITY CASCADE;
```

## 📚 参考リソース

- **Adminer公式ドキュメント**: https://www.adminer.org/
- **PostgreSQL公式ドキュメント**: https://www.postgresql.org/docs/
- **SQLリファレンス**: https://www.postgresql.org/docs/current/sql.html

## 🔒 セキュリティ注意事項

### 本番環境での使用について
⚠️ **重要**: このAdminer設定は開発環境専用です

本番環境で使用する場合は以下を必ず実施：
1. **アクセス制限**: IP制限またはVPN経由のみ
2. **認証強化**: より複雑なパスワード設定
3. **HTTPS化**: SSL証明書の設定
4. **監査ログ**: アクセスログの記録・監視

### データの取り扱い
- 個人情報を含むデータの取り扱いに注意
- エクスポートしたファイルの適切な管理
- 本番データへの不要なアクセス禁止

---

このガイドを活用して、効率的なデータベース管理を行ってください！
質問や不明点があれば、プロジェクトのIssueまたはドキュメントを参照してください。