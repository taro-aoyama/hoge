# カスタマイズしたAdminer用のDockerfile
FROM adminer:4.8.1

# 作業者情報
LABEL maintainer="hoge-project"
LABEL description="Customized Adminer for PostgreSQL facility reservation system"

# カスタムファイルをコピー
COPY index.php /var/www/html/
COPY adminer-custom.css /var/www/html/

# 権限設定（既存ファイルの権限変更を回避）
USER root
RUN chmod 644 /var/www/html/index.php && \
    chmod 644 /var/www/html/adminer-custom.css
USER www-data

# 環境変数設定
ENV ADMINER_DEFAULT_SERVER=db
ENV ADMINER_DESIGN=pepa-linha-dark
ENV ADMINER_PLUGINS=tables-filter,tinymce

# ポート公開
EXPOSE 8080

# ヘルスチェック追加（curlの代わりにwgetを使用）
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1
