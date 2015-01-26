xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $role-id := map:get($mledms-utils:request-attribute, "role-id")
let $role := map:get($mledms-utils:request-attribute, "role")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3><a href="{mledms-utils:create-command-url("admin/security/role-search", ())}">ロール管理</a> &gt; ロール詳細 <small>{ $role/mledms:role/mledms:role-name/text() }</small></h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/admin/security/parts/role-menu.xqy", $mledms-utils:request-attribute)
}  
            </div>
            <div class="col-lg-9 right-pane">
                <fieldset>
                    <legend>基本情報</legend>
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">ロール名</label>
                        <div class="col-sm-9">{ $role/mledms:role/mledms:role-name/text() }</div>
                    </div>
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">説明</label>
                        <div class="col-sm-9">{ $role/mledms:role/mledms:description/text() }</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("admin/security/role-update-form", <params><param name="role-id">{$role-id}</param></params>)}" class="btn btn-default" role="button">更新</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("admin/security/role-delete", <params><param name="role-id">{$role-id}</param></params>)}" class="btn btn-default" role="button">削除</a>
                        </div>
                    </div>
                </fieldset>
                <br/>
            </div>
        </div>