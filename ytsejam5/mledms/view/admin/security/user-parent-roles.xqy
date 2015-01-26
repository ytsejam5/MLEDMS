xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $user-id := map:get($mledms-utils:request-attribute, "user-id")
let $user := map:get($mledms-utils:request-attribute, "user")
let $query := map:get($mledms-utils:request-attribute, "query")
let $search-result := map:get($mledms-utils:request-attribute, "search-result")
let $parent-roles := map:get($mledms-utils:request-attribute, "parent-roles")

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
                <form class="form-horizontal" method="get" action="{mledms-utils:create-command-url("admin/security/user-parent-roles", ())}">
                    <fieldset>
                        <legend>上位ロール</legend>
                        <div class="row">
                            <div class="col-sm-offset-1 col-sm-8 text-right">
                                
                                    <input type="hidden" name="user-id" value="{ $user-id }"/>
                                    <fieldset>
                                        <div class="input-group">
                                            <input type="text" name="q" class="form-control" placeholder="Search for..." value="{ $query }"/>
                                            <span class="input-group-btn"><button class="btn btn-default" type="submit">検索</button></span>
                                        </div>
                                     </fieldset>
                                
                            </div>
                        </div>
                    </fieldset>
                </form>
                <hr/>
                <form class="form-horizontal" method="post" action="{mledms-utils:create-command-url("admin/security/user-parent-roles-update", ())}">
                    <input type="hidden" name="user-id" value="{ $user-id }"/>
{
    mledms-utils:import-viewpart("/parts/search-pagenation.xqy", $mledms-utils:request-attribute)
} 
                    <hr/>                    
                    <fieldset>
{   for $i in $search-result/search:result
    return
        let $role-id := $i/mledms:role/mledms:role-id/text()
        let $role-name := $i/mledms:role/mledms:role-name/text()
        return
                        <div class="row">
                            <div class="col-sm-offset-1 col-sm-2">
                                <label>
                                    <input type="hidden" name="role-id" value="{ $role-id }"/>
                                    <input type="hidden" name="{ fn:concat("original-parent-role:", $role-id) }"
                                                value="{ if (fn:index-of($parent-roles, $role-name)) then "true" else "false" }"/>
        {
            if (fn:index-of($parent-roles, $role-name)) then (
                                    <input type="checkbox" name="{ fn:concat("updating-parent-role:", $role-id) }" value="true" checked="true"/>
            ) else (
                                    <input type="checkbox" name="{ fn:concat("updating-parent-role:", $role-id) }" value="true"/>
            )
        }
                                    &nbsp;{ $role-name }
                                </label>
                            </div>
                            <div class="col-sm-9">{ fn:string($i/mledms:role/mledms:description/text()) }</div>
                        </div>
}
                    
                        <hr/>
{
    mledms-utils:import-viewpart("/parts/search-pagenation.xqy", $mledms-utils:request-attribute)
} 
                        <hr/>
                        <div class="row">
                            <div class="col-sm-offset-3 col-sm-9 text-right">
                                <button type="submit" class="btn btn-default">更新</button>
                            </div>
                        </div>  
                    </fieldset>
                </form>
                <br/>
            </div>
        </div>