FROM nginx

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
ADD ./trapla.conf /etc/nginx/conf.d/trapla.conf

# wwwディレクトリ作成
RUN mkdir /var/www

# ビルド完了後にNginxを起動
CMD /etc/init.d/nginx start

# 80ポートを開く
EXPOSE 80
