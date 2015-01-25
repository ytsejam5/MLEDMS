xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $role-id := map:get($mledms-utils:request-attribute, "role-id")
return
                <div class="panel panel-default">
                    <div class="panel-heading">ロール管理メニュー</div>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("admin/security/role-detail", <params><param name="role-id">{$role-id}</param></params>)}">基本情報</a></li>
                        <li class="list-group-item"><a href="#">所属ロール</a></li>
                        <li class="list-group-item"><a href="#">実行権限</a></li>
                        <li class="list-group-item"><a href="#">デフォルトアクセス権限</a></li>
                        <li class="list-group-item"><a href="#">デフォルトコレクション</a></li>
                        <li class="list-group-item"><a href="#">コンパートメント</a></li>
                        <li class="list-group-item"><a href="#">外部名マッピング</a></li>
                    </ul>
                </div> 