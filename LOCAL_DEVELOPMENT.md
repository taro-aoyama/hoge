# ローカル開発環境セットアップガイド

このプロジェクトはDocker環境とローカル環境の両方で開発可能です。このガイドでは、ローカル環境でのセットアップ方法を説明します。

## 🐳 Docker vs ローカル開発

| 項目 | Docker環境 | ローカル環境 |
|------|-----------|------------|
| **セットアップ** | 簡単 | 要事前準備 |
| **起動速度** | やや遅い | 高速 |
| **依存関係** | 自動管理 | 手動管理 |
| **AI開発支援** | 一部制限 | フル対応 |

## 📋 前提条件

以下がローカル環境にインストールされている必要があります：

### 1. Ruby
```bash
# バージョン確認
ruby --version
# => ruby 3.2.2 (推奨)

# rbenvを使用する場合
rbenv install 3.2.2
rbenv local 3.2.2
```

### 2. Node.js & Yarn
```bash
# Node.jsバージョン確認
node --version
# => v18.x.x以上推奨

# Yarnバージョン確認
yarn --version
# => 1.22.x以上推奨
```

### 3. PostgreSQL
```bash
# Homebrewでインストール（Mac）
brew install postgresql@15
brew services start postgresql@15

# バージョン確認
psql --version
# => psql (PostgreSQL) 15.x.x
```

## 🚀 セットアップ手順

### 1. リポジトリのクローン
```bash
git clone https://github.com/taro-aoyama/hoge.git
cd hoge
```

### 2. 依存関係のインストール
```bash
# Ruby gems
bundle install

# Node.js packages
yarn install
```

### 3. データベースの準備
```bash
# PostgreSQLユーザーの作成（初回のみ）
createuser -s postgres
# パスワードを求められたら 'password' と入力

# データベースの作成
rails db:create

# マイグレーションの実行
rails db:migrate

# シードデータの投入
rails db:seed
```

### 4. 環境変数の確認
`.env.development` ファイルが存在することを確認してください：

```bash
cat .env.development
```

内容例：
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
RAILS_ENV=development
```

### 5. アセットのビルド
```bash
# CSS・JSのビルド
yarn build
# または
yarn build:css
yarn build:js
```

## 🖥️ 開発サーバーの起動

### 方法1: 通常の起動
```bash
rails server
# => http://localhost:3000 でアクセス可能
```

### 方法2: 開発用プロセス管理（推奨）
```bash
# Procfile.devを使用（foreman gem必要）
gem install foreman
foreman start -f Procfile.dev

# または、複数のターミナルで個別起動
# ターミナル1: Railsサーバー
rails server

# ターミナル2: CSS/JSウォッチ
yarn build --watch
```

## 🧪 テストの実行

```bash
# 全テストの実行
rails test

# 特定のテストファイル
rails test test/models/user_test.rb

# テストデータベースのリセット
RAILS_ENV=test rails db:reset
```

## 🔧 よくある問題と解決方法

### データベース接続エラー
```bash
# PostgreSQLサービスの状態確認
brew services list | grep postgresql

# サービスの再起動
brew services restart postgresql@15

# データベースの再作成
rails db:drop db:create db:migrate db:seed
```

### ポートが使用中の場合
```bash
# 使用中のプロセスを確認
lsof -i :3000

# プロセスを終了
kill -9 <PID>

# 別のポートで起動
rails server -p 3001
```

### アセットビルドエラー
```bash
# node_modulesの再インストール
rm -rf node_modules
yarn install

# キャッシュのクリア
yarn cache clean
rails tmp:clear
```

## 📊 開発用データの確認

### シードデータのログイン情報
```
システム管理者: admin@example.com / password123
体育館管理者: gym_manager@example.com / password123
会議室管理者: meeting_manager@example.com / password123
ホール管理者: hall_manager@example.com / password123
一般ユーザー: user1@example.com ~ user5@example.com / password123
```

### データベースの確認
```bash
# Railsコンソール
rails console

# 直接PostgreSQLに接続
psql -h localhost -U postgres -d myapp_development
```

## 🔄 Docker環境との切り替え

### ローカル → Docker環境
```bash
# ローカルサーバーを停止
# Ctrl+C

# Docker環境起動
docker compose up -d

# ブラウザで http://localhost:3001 にアクセス
```

### Docker → ローカル環境
```bash
# Dockerサーバーを停止
docker compose down

# ローカル環境起動
rails server

# ブラウザで http://localhost:3000 にアクセス
```

## 💡 開発のコツ

### 1. ログの確認
```bash
# Railsログ
tail -f log/development.log

# PostgreSQLログ（Mac）
tail -f /opt/homebrew/var/log/postgresql@15.log
```

### 2. データベースの状態確認
```bash
# マイグレーション状態
rails db:migrate:status

# 現在のスキーマ確認
rails db:schema:dump
```

### 3. パフォーマンス改善
```bash
# Bootスナップのプリコンパイル
rails runner "Bootsnap.compile_cache_dir('app')"

# テンプレートキャッシュの無効化（開発時）
# config/environments/development.rb で
# config.action_view.cache_template_loading = false
```

## 🚨 トラブルシューティング

### 症状別対処法

| 症状 | 考えられる原因 | 対処法 |
|------|-------------|-------|
| `rails server` が起動しない | gemの問題 | `bundle install` |
| データベース接続エラー | PostgreSQL未起動 | `brew services start postgresql@15` |
| アセットが反映されない | ビルド未実行 | `yarn build` |
| ポート3000が使用中 | 他プロセスが使用 | `lsof -i :3000` で確認・終了 |

### サポート情報
- GitHub Issues: https://github.com/taro-aoyama/hoge/issues
- Rails Guides: https://guides.rubyonrails.org/
- PostgreSQL Documentation: https://www.postgresql.org/docs/

---

## 📝 メモ

- このプロジェクトはJulesによるAI開発も想定しています
- Docker環境とローカル環境でデータは共有されません
- 本番環境への反映前には必ずテストを実行してください