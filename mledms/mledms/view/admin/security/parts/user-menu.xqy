xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $user-id := map:get($mledms-utils:request-attribute, "user-id")
return
                <div class="panel panel-default">
                    <div class="panel-heading">ユーザ管理メニュー</div>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("admin/security/user-detail", <params><param name="user-id">{$user-id}</param></params>)}">基本情報</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("admin/security/user-parent-roles", <params><param name="user-id">{$user-id}</param></params>)}">所属ロール</a></li>
                        <li class="list-group-item"><a href="#">デフォルトアクセス権限</a></li>
                        <li class="list-group-item"><a href="#">デフォルトコレクション</a></li>
                        <li class="list-group-item"><a href="#">外部名マッピング</a></li>
                    </ul>
                </div> 