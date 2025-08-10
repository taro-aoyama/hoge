# Rubyの公式イメージをベースにする
FROM ruby:3.2.2

# 必要なパッケージをインストールする
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    nodejs \
    npm \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Railsアプリケーションのディレクトリを作成
RUN mkdir -p /app

# GemfileとGemfile.lockをコピーして依存関係をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# エントリポイントスクリプトを先にコピーして権限設定
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

# 残りのソースコードをコピー
COPY . .

# ポート3000を公開
EXPOSE 3000

# エントリポイントスクリプトを設定
ENTRYPOINT ["./docker-entrypoint.sh"]

# デフォルトコマンドを設定
CMD ["rails", "server", "-b", "0.0.0.0"]
