# 公共施設予約システム

このプロジェクトは、複数の公共施設の予約管理を行うWebアプリケーションです。通常の予約だけでなく、人気施設での抽選予約機能も提供します。

## 🏗️ アーキテクチャ

- **バックエンド**: Ruby on Rails 7.2.2
- **データベース**: PostgreSQL 15
- **認証**: Devise
- **フロントエンド**: Hotwire (Turbo + Stimulus)
- **スタイル**: Bootstrap 5 + CSS Bundling
- **コンテナ**: Docker + Docker Compose

## 👥 ユーザーロール

- **システム管理者**: 全体管理、施設・ユーザー管理
- **施設管理者**: 担当施設の予約管理、抽選実行
- **一般ユーザー**: 施設予約、抽選申込

## 🚀 開発環境セットアップ

このプロジェクトは**Docker環境**と**ローカル環境**の両方で開発可能です。

### 🐳 Docker環境（推奨）

#### 1. セットアップ
```bash
# リポジトリクローン
git clone https://github.com/taro-aoyama/hoge.git
cd hoge

# コンテナビルド・起動
docker compose build
docker compose up -d

# データベース初期化
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```

#### 2. アクセス
- **アプリケーション**: http://localhost:3001
- **データベース**: localhost:5433 (外部接続用)

#### 3. よく使うコマンド
```bash
# ログ確認
docker compose logs web -f

# Railsコンソール
docker compose exec web rails console

# マイグレーション
docker compose exec web rails db:migrate

# コンテナ再起動
docker compose restart web

# 停止・削除
docker compose down
```

### 💻 ローカル環境（Jules対応）

AI開発支援ツール（Jules）を使用する場合は、ローカル環境での開発が推奨されます。

#### 1. 前提条件
- Ruby 3.2.2
- Node.js 18.x以上
- PostgreSQL 15
- Yarn 1.22以上

#### 2. セットアップ
```bash
# 依存関係インストール
bundle install
yarn install

# データベースセットアップ
rails db:create db:migrate db:seed

# アセットビルド
yarn build
```

#### 3. 開発サーバー起動
```bash
# Railsサーバー起動
rails server
# => http://localhost:3000

# アセット自動ビルド（別ターミナル）
yarn build --watch
```

詳細なローカル環境セットアップ手順は [LOCAL_DEVELOPMENT.md](./LOCAL_DEVELOPMENT.md) を参照してください。

## 📊 テストデータ

シード実行後、以下のアカウントでログイン可能です：

| ロール | メールアドレス | パスワード |
|--------|-------------|----------|
| システム管理者 | admin@example.com | password123 |
| 体育館管理者 | gym_manager@example.com | password123 |
| 会議室管理者 | meeting_manager@example.com | password123 |
| ホール管理者 | hall_manager@example.com | password123 |
| 一般ユーザー | user1@example.com ~ user5@example.com | password123 |

## 🏢 機能概要

### 基本機能
- ユーザー認証・認可
- 施設一覧・詳細表示
- 通常予約（即時予約）
- 予約管理（承認・拒否）

### 抽選機能
- 抽選期間設定（施設管理者）
- 抽選申込（一般ユーザー）
- 抽選実行・結果通知
- 当選辞退・補欠繰り上げ

### 管理機能
- 施設管理（CRUD）
- ユーザー管理
- 利用統計・レポート
- 通知システム

## 🔧 開発

### データベース操作
```bash
# マイグレーション作成
rails generate migration AddColumnToUsers column:string

# モデル作成
rails generate model ModelName field:type

# シードデータリセット
rails db:seed:replant
```

### テスト実行
```bash
# 全テスト
rails test

# 特定テスト
rails test test/models/user_test.rb
```

### デバッグ
```bash
# Rails console
rails console

# ログ確認（ローカル）
tail -f log/development.log

# ログ確認（Docker）
docker compose logs web -f
```

## 📋 開発タスク

開発タスクは GitHub Issues で管理されています。
[Issues一覧](https://github.com/taro-aoyama/hoge/issues) から `assign-to-jules` ラベルのついたタスクを確認してください。

### 開発フェーズ
1. **Phase 1**: 基盤機能 (Issues #22-23)
2. **Phase 2**: 施設管理 (Issues #24-26)  
3. **Phase 3**: 通常予約 (Issues #27-29)
4. **Phase 4**: 抽選機能 (Issues #30-34)
5. **Phase 5**: 追加機能 (Issues #35-39)
6. **Phase 6**: UX向上 (Issues #40-41)

## 🤖 AI開発について

このプロジェクトはGoogle Julesによる自動開発に対応しています：

- ローカル環境での開発を推奨
- 各Issueに詳細な要件定義を記載
- `assign-to-jules` ラベルでタスクを識別

## 📝 プロジェクト構成

```
hoge/
├── app/
│   ├── controllers/     # コントローラー
│   ├── models/         # モデル（User, Facility, Reservation等）
│   ├── views/          # ビューテンプレート
│   └── assets/         # スタイルシート、JavaScript
├── config/
│   ├── routes.rb       # ルーティング設定
│   └── database.yml    # DB設定（Docker/ローカル対応）
├── db/
│   ├── migrate/        # マイグレーションファイル
│   └── seeds.rb        # テストデータ
├── docker-compose.yml  # Docker構成
├── Dockerfile         # Docker設定
└── scripts/           # 自動化スクリプト
```

## 🚨 トラブルシューティング

### Docker環境
```bash
# コンテナ削除・再構築
docker compose down -v
docker compose build --no-cache
docker compose up -d

# データベース接続エラー
docker compose exec web rails db:reset
```

### ローカル環境
```bash
# PostgreSQL起動
brew services start postgresql@15

# 依存関係再インストール
bundle install
yarn install

# キャッシュクリア
rails tmp:clear
```

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. Pull Requestを作成

## 📞 サポート

- GitHub Issues: https://github.com/taro-aoyama/hoge/issues
- Documentation: [LOCAL_DEVELOPMENT.md](./LOCAL_DEVELOPMENT.md)