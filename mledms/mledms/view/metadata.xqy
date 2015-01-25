xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $metadata := map:get($mledms-utils:request-attribute, "metadata")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>データ詳細 <small>{$document-uri}</small></h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/view/parts/document-menu.xqy", $mledms-utils:request-attribute)
}   
            </div>
            <div class="col-lg-9 right-pane">   
                <fieldset>
                    <legend>メタデータ</legend>
{   for $i in $metadata
    return
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">{ fn:string($i/@name) }</label>
                        <div class="col-sm-9">{ fn:string($i/@content) }</div>
                    </div>
}
                </fieldset>
                <br/>
            </div>
        </div>