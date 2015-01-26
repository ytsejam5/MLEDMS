xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $search-result := map:get($mledms-utils:request-attribute, "search-result")
let $permissions := map:get($mledms-utils:request-attribute, "permissions")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>データ詳細 <small>{$document-uri}</small></h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/parts/document-menu.xqy", $mledms-utils:request-attribute)
}   
            </div>
            <div class="col-lg-9 right-pane">
                <form class="form-horizontal" method="post" action="{mledms-utils:create-command-url("permission-update", ())}">
                    <input type="hidden" name="document-uri" class="form-control" value="{ $document-uri }"/>
                    <fieldset>
                        <legend>アクセス権限</legend>
                        <hr/>
{
    mledms-utils:import-viewpart("/parts/search-pagenation.xqy", $mledms-utils:request-attribute)
} 
                        <hr/>
{
    for $role in $search-result/search:result
    return
                        <div class="row form-group">
                            <label class="col-sm-3 text-right">{ $role/mledms:role/mledms:role-name/text() }</label>
                            <div class="col-sm-9">
                                <input type="hidden" name="role-id" value="{ $role/mledms:role/mledms:role-id/text() }"/>
        {
            for $capability in ("read", "insert", "update", "execute")
            return
                                <div class="col-sm-2">
                                    <label>
                                        <input type="hidden" name="{ fn:concat("original-permission:", $role/mledms:role/mledms:role-id/text(), "-", $capability) }"
                                            value="{ $permissions[/sec:role-id/text() eq $role/mledms:role/mledms:role-id/text()]/sec:capability/text() eq $capability }"/>
            {
                if ($permissions[/sec:role-id/text() eq $role/mledms:role/mledms:role-id/text()]/sec:capability/text() eq $capability) then (
                                        <input type="checkbox" name="{ fn:concat("updating-permission:", $role/mledms:role/mledms:role-id/text(), "-", $capability) }" value="true" checked="true"/>
                ) else (
                                        <input type="checkbox" name="{ fn:concat("updating-permission:", $role/mledms:role/mledms:role-id/text(), "-", $capability) }" value="true"/>
                )
            }
                                    &nbsp;{ fn:upper-case($capability) }</label>
                                </div>
        }
                            </div>
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