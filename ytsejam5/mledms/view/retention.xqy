xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $retention-rules := map:get($mledms-utils:request-attribute, "retention-rules")


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
                <fieldset>
                    <legend>保存ルール</legend>
{   for $i in $retention-rules
    return (
                    <div class="row">
                        <label class="col-sm-offset-1 col-sm-2 control-label text-right"><a href="">{ $i/dls:name/text() }</a></label>
                        <div class="col-sm-2">説明</div>
                        <div class="col-sm-7">{ $i/dls:comment/text() }</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-2">保持バージョン数</div>
                        <div class="col-sm-7">{ $i/dls:num-versions/text() }</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-2">保持期間</div>
                        <div class="col-sm-7">{ $i/dls:duration/text() }</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-2">合致条件</div>
                        <div class="col-sm-7"><div>説明: { $i/dls:document-query-text/text() }</div><div>条件: { xdmp:quote($i/dls:document-query) }</div></div>
                    </div>
    )
}
                </fieldset>
                <br/>
            </div>
        </div>