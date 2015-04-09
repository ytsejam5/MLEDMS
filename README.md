# MLEDMS
Enterprise Data / Document Management System prototype code with MarkLogic 7


## 概要
MarkLogic 7を使ったサンプルプログラムです。

[MarkLogic](http://www.marklogic.com/) はMongoDBに全文検索とトランザクションがくっついたようなドキュメントストア型のNoSQLデータベースです。<br>
使い勝手が良くて枯れているんですが日本語の技術情報が少ないようなので、やりたいことを探す逆引き的なリファレンスとしてコードを公開してみます。

Java API、RESTを使ってデータベースクライアント側でロジックを書く開発もできますが、XQueryを使ってデータベース側でWebアプリケーションを作ることもでき、このプログラムは後者です。<br>

あくまでサンプルですので、決まり文句ではありますが、ご利用にあたって発生した不利益については免責とさせていただきますのであしからずご了承ください。<br>

## 説明
以下のような機能を実現(しようと)しています。
- データCRUD
- コミット/ロールバック
- 全文検索
- ファセット検索
- セマンティクス検索 (SPARQL検索) ※
- オントロジー管理 ※
- 辞書管理 ※
- メタデータ抽出
- ロックステータス管理
- バージョン管理 (チェックイン/チェックアウト)
- 保存ルール管理 ※
- 発動アラート管理 (リバースクエリ) ※
- 所属クラスタ表示 ※
- 自然言語抽出 ※
- 類似ドキュメント抽出 ※
- アクセス権限管理
- 監査
- WebDAV接続

※は、このサンプルでは準備ができてないところです。これから時間を見つけて作っていく予定です。<br>
バリデーションも省いています。サンプルなので。。<br>

で、ほとんどがMarkLogicのAPIを呼び出しているだけです。楽です。<br>
あと、レスポンシブにしてるのでスマートフォンやタブレットでも見れると思います。


## スクリーンショット

検索画面 (スニペットとかハイライトとか、API呼ぶだけですね。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/search.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/search.png)<br>

詳細表示画面 (テキストは全文、画像はサムネイルを表示させてます。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/detail-text.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/detail-text.png)
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/detail-image.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/detail-image.png)<br>

メタデータ表示画面 (これもMarkLogicが属性抽出をやってくれます。対応するファイルフォーマット一覧は[こちら](http://www.marklogic.com/resources/marklogic-document-format-support/resource_download/datasheets/))<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/metadata.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/metadata.png)<br>

アクセス権限表示画面 (データ、ディレクトリ、コレクション単位でロールを割り当てます。設定機能はまだ作っていません。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/security.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/security.png)<br>

ロックステータス管理画面 (APIで共有ロックと排他ロックが選べます。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/lock.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/lock.png)<br>

バージョン管理画面 (チェックイン、チェックアウトとか。バージョン履歴にコメントも残せます。これもAPI呼んでいるだけです。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/version.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/version.png)<br>

WevDAV接続イメージ ([Carot DAV](http://rei.to/carotdav.html)を使って繋いでいる例です。一括取り込みも楽チンです。)<br>
[<img src="https://raw.githubusercontent.com/ytsejam5/mledms/master/screenshots/webdav.png" width="450"/>](https://github.com/ytsejam5/mledms/mledms/blob/master/screenshots/webdav.png)<br>

## 処理の流れ
/index.xqy がMVCでいうところのコントローラです。
/action 以下のクエリに処理を渡していますので、気になる処理の実装方法はこちらが参考になるかと思います。

データの登録・更新・チェックイン後には[CPF(Content Processing Framework)](https://docs.marklogic.com/guide/cpf)でイベントを拾って、テキストと属性を抽出しています。<br>
これで全文検索ができるようになります。
属性でも検索したいのでちょっと小細工をしていますが、検索時のクエリでなんとかなるかも。

URLリライタも作っています。これで怪しい.xqyの拡張子を隠せます。
リライタ設定無くても動きますが、/utils/utils.xqy最上段の$mledms-utils:use-writerをfalseにしてあげてください。


## インストール
後ほど。。




