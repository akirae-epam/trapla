# Trapla
旅行計画を作成するWebアプリケーションです。
サンプルは以下URLで確認できます。
http://13.228.52.57
テストユーザアカウント：test-user
パスワード：foobar

## 使い方
Docker, Docker-composeがインストールされている必要があります。
このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。

１．dockerイメージのビルド

```
$ docker-compose build
```

２．dockerイメージの起動

```
$ docker-compose up -d
```

３．データベースの作成とマイグレーション

```
$ docker-compose run --rm app rails db:create
$ docker-compose run --rm app rails db:migrate
```

４．テスト実行

```
$ docker-compose run --rm app rails test
$ docker-compose run --rm app rails spec
```

以上で、http://0.0.0.0:3000 にアクセスできるはずです。
