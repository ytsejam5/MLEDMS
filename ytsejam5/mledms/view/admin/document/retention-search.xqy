xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $query := map:get($mledms-utils:request-attribute, "query")
let $retention-rules := map:get($mledms-utils:request-attribute, "retention-rules")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>保存ポリシー管理</h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/admin/parts/admin-menu.xqy", $mledms-utils:request-attribute)
}  
            </div>
            <div class="col-lg-9 right-pane">
                <fieldset>
                    <legend>保存ポリシー検索</legend>
                    <div class="row">
                        <div class="col-sm-offset-1 col-sm-8 text-right">
                            <form class="form-horizontal" method="get" action="{mledms-utils:create-command-url("admin/security/role-search", ())}">
                                <fieldset>
                                    <div class="input-group">
                                        <input type="text" name="q" class="form-control" placeholder="Search for..." value="{ $query }"/>
                                        <span class="input-group-btn"><button class="btn btn-default" type="submit">検索</button></span>
                                    </div>
                                 </fieldset>
                            </form>
                        </div>
                        <div class="col-sm-3 text-right">
                            <a href="{mledms-utils:create-command-url("admin/security/role-create-form", ())}" class="btn btn-default" role="button">ロール作成</a>
                        </div>
                    </div>
                    <hr/>
{   for $i in $retention-rules
    return
                    <div class="row">
                        <label class="col-sm-offset-1 col-sm-2 control-label"><a href="">{ fn:string($i) }</a></label>
                        <div class="col-sm-9">{ fn:string($i) }</div>
                    </div>
}
                    <hr/>
                </fieldset>
                <br/>
            </div>
        </div>