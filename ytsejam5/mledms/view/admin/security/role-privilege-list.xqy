xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $role-id := map:get($mledms-utils:request-attribute, "role-id")
let $role := map:get($mledms-utils:request-attribute, "role")
let $privileges := map:get($mledms-utils:request-attribute, "privileges")

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
                    <legend>権限一覧</legend>
 {
    for $i in $privileges
    where $i/sec:kind/text() eq "uri"
    order by $i/sec:privilege-name/text() ascending
    return (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">{ $i/sec:privilege-name/text() }</label>
                        <div class="col-sm-1 text-center">{ fn:concat("[", $i/sec:kind/text(), "]") }</div>
                        <div class="col-sm-8">{ $i/sec:action/text() }</div>
                    </div> 
    ),
    for $i in $privileges
    where $i/sec:kind/text() eq "execute"
    order by $i/sec:privilege-name/text() ascending
    return (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">{ $i/sec:privilege-name/text() }</label>
                        <div class="col-sm-1 text-center">{ fn:concat("[", $i/sec:kind/text(), "]") }</div>
                        <div class="col-sm-8">{ $i/sec:action/text() }</div>
                    </div> 
    )
 }
                 </fieldset>
                <br/>
            </div>
        </div>