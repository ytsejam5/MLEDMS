xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
return
                <div class="panel panel-default">
                    <div class="panel-heading">メニュー</div>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("detail", <params><param name="document-uri">{$document-uri}</param></params>)}">基本情報</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("metadata", <params><param name="document-uri">{$document-uri}</param></params>)}">メタデータ</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("permission", <params><param name="document-uri">{$document-uri}</param></params>)}">アクセス権限</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("lock-status", <params><param name="document-uri">{$document-uri}</param></params>)}">ロックステータス</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("version", <params><param name="document-uri">{$document-uri}</param></params>)}">バージョン情報</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("retention", <params><param name="document-uri">{$document-uri}</param></params>)}">保存ルール</a></li>
                        <li class="list-group-item"><a href="#(:{mledms-utils:create-command-url("alert",        <params><param name="document-uri">{$document-uri}</param></params>)}:)">発動アラート</a></li>
                        <li class="list-group-item"><a href="#(:{mledms-utils:create-command-url("cluster",      <params><param name="document-uri">{$document-uri}</param></params>)}:)">所属クラスタ</a></li>
                        <li class="list-group-item"><a href="#(:{mledms-utils:create-command-url("nlp",          <params><param name="document-uri">{$document-uri}</param></params>)}:)">自然言語抽出</a></li>
                        <li class="list-group-item"><a href="#(:{mledms-utils:create-command-url("similar",      <params><param name="document-uri">{$document-uri}</param></params>)}:)">類似ドキュメント</a></li>
                    </ul>
                </div> 