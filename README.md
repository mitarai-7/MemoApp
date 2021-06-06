# メモアプリの使い方

## 1.データベースを作成
本アプリではpostgresqlを利用するため、実行する環境へインストールを行ってください
インストールできているかは次のコマンドで確認してください。（バージョンは異なる可能性があります）
```
% psql --version
psql (PostgreSQL) 13.3
```

## 2.アプリケーションの取得・起動
```
$ git clone https://github.com/mitarai-7/MemoApp.git
$ cd memoapp
$ bundle install
$ bundle exec rackup
```

## 3.アプリケーションへアクセス
ブラウザで次のURLを開きます
http://localhost:9292/

