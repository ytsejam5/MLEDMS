xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

xdmp:set-response-content-type("text/html; charset=UTF-8"),

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>MLEDMS</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="/resource/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="/resource/css/custom.css"/>
        <script src="/resource/js/jquery-1.11.2.min.js"/>
        <script src="/resource/js/bootstrap.min.js"/>
        <script src="/resource/js/custom.js"/>
    </head>
    <body>
        <div class="page-header">
            <h1>MLEDMS <small>データ管理システム</small></h1>
        </div>
        
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                </div>
        
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
        {
            if (map:get($mledms-utils:request-attribute, "command") eq "search") then (
                        <li class="active"><a href="{mledms-utils:create-command-url("search", ())}">コレクショナル検索</a></li>
            ) else (
                        <li><a href="{mledms-utils:create-command-url("search", ())}">コレクショナル検索</a></li>
            )
        }
                        <li><a href="#">ディレクトリ検索</a></li>
                        <li><a href="#">ユーザ検索</a></li>
                        <li><a href="#">セマンティクス検索</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">データ登録 <span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="{mledms-utils:create-command-url("create-form", ())}">ドキュメント</a></li>
                                <hr/>
                                <li><a href="#">Doblin Core</a></li>
                                <li><a href="#">FAOF</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">ログイン中：{ xdmp:get-current-user() } <span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="#">ログアウト</a></li>
                                <hr/>
                                <li><a href="#">アカウント情報管理</a></li>
                                <li><a href="#">パスワード変更</a></li>
                                <hr/>
                                <li><a href="#">検索条件管理</a></li>
                                <li><a href="#">発動アラート管理</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">管理メニュー <span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="{mledms-utils:create-command-url("admin/security/role-search", ())}">ロール管理</a></li>
                                <li><a href="{mledms-utils:create-command-url("admin/security/user-search", ())}">ユーザ管理</a></li>
                                <hr/>
                                <li><a href="#">コレクション管理</a></li>
                                <li><a href="#">ID体系管理</a></li>
                                <li><a href="#">保存ポリシー管理</a></li>
                                <hr/>
                                <li><a href="#">クラスタ管理</a></li>
                                <li><a href="#">辞書管理</a></li>
                                <li><a href="#">オントロジー管理</a></li>
                                <hr/>
                                <li><a href="#">アクセス統計情報</a></li>
                                <li><a href="#">検索統計情報</a></li>
                                <li><a href="#">監査</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
{
    let $view := fn:concat("/ytsejam5/mledms/view", map:get($mledms-utils:request-attribute, "view"))
    return
        xdmp:invoke($view, (xs:QName("mledms-utils:request-attribute"), $mledms-utils:request-attribute),
            <options xmlns="xdmp:eval">
                <isolation>same-statement</isolation>
            </options>)
}
    </body>
</html>