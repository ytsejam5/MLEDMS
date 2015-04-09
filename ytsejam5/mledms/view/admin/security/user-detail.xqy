xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $user-id := map:get($mledms-utils:request-attribute, "user-id")
let $user := map:get($mledms-utils:request-attribute, "user")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3><a href="{mledms-utils:create-command-url("admin/security/user-search", ())}">ユーザ管理</a> &gt; ユーザ詳細 <small>{ $user/mledms:user/mledms:user-name/text() }</small></h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/admin/security/parts/user-menu.xqy", $mledms-utils:request-attribute)
} 
            </div>
            <div class="col-lg-9 right-pane">
                <fieldset>
                    <legend>基本情報</legend>
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">ユーザ名</label>
                        <div class="col-sm-9">{ $user/mledms:user/mledms:user-name/text() }</div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">説明</label>
                        <div class="col-sm-9">{ $user/mledms:user/mledms:description/text() }</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("admin/security/user-update-form", <params><param name="user-id">{$user-id}</param></params>)}" class="btn btn-default" user="button">更新</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("admin/security/user-delete", <params><param name="user-id">{$user-id}</param></params>)}" class="btn btn-default" user="button">削除</a>
                        </div>
                    </div>
                </fieldset>
                <br/>
            </div>
        </div>