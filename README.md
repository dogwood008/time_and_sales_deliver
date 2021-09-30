# Time and Sales Deliver

## これは何？

歩み値を配信するサーバ。

## セットアップ

### DB (PostgreSQL)を起動

```sh
$ docker-compose --build up db
```

### CSVからDBへインポート

今は、 `7974_2021-09-09.csv` というファイル名で、Hyper SBIから取得した歩み値しか自動インポートには対応していない。

```sh
$ docker-compose --build up db_init
```

## Webサーバ

WIP
