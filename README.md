# README

## 初期セットアップ
### ターミナルで以下のコマンドを実行します。
```Bash
docker compose build
docker compose up -d
```

### コンテナ内でマイグレーションとシードを実行します。
```Bash
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```
