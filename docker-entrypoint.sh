#!/bin/bash
set -e

echo "Starting Rails application..."

# データベースが利用可能になるまで待機（シンプルな方法）
echo "Waiting for database to be ready..."
sleep 5

# データベース作成（既存の場合はスキップ）
echo "Ensuring database exists..."
bundle exec rails db:create 2>/dev/null || echo "Database already exists"

# マイグレーション実行
echo "Running migrations..."
bundle exec rails db:migrate

echo "Setup complete. Starting Rails server..."

# 引数で渡されたコマンドを実行
exec "$@"
