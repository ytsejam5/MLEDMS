xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

                <div class="panel panel-default">
                    <div class="panel-heading">管理メニュー</div>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("admin/security/role-search", ())}">ロール管理</a></li>
                        <li class="list-group-item"><a href="{mledms-utils:create-command-url("admin/security/user-search", ())}">ユーザ管理</a></li>
                    </ul>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="#">コレクション管理</a></li>
                        <li class="list-group-item"><a href="#">ID体系管理</a></li>
                        <li class="list-group-item"><a href="#">保存ポリシー管理</a></li>
                    </ul>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="#">クラスタ管理</a></li>
                        <li class="list-group-item"><a href="#">辞書管理</a></li>
                        <li class="list-group-item"><a href="#">オントロジー管理</a></li>
                    </ul>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="#">アクセス統計情報</a></li>
                        <li class="list-group-item"><a href="#">検索統計情報</a></li>
                        <li class="list-group-item"><a href="#">監査</a></li>
                    </ul>
                </div> 