xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $query := map:get($mledms-utils:request-attribute, "query")
let $current := map:get($mledms-utils:request-attribute, "current")
let $search-result := map:get($mledms-utils:request-attribute, "search-result")
let $directories := map:get($mledms-utils:request-attribute, "directories")

return 
        <div xmlns="http://www.w3.org/1999/xhtml">   
            <div class="col-lg-12 row">
                <h3>データ検索</h3>
                <hr/>
            </div>         
            <div class="col-lg-3 left-pane">
{
    if ($directories) then (

                <div class="panel panel-default">
                    <div class="panel-heading">ディレクトリ</div>
<div class="panel-body" style="overflow:auto">
<table class="tree">
{
       for $directory in $directories
       return (
       <tr class="treegrid-{ $directory/@id } {if ($directory/@parent-id ne "") then fn:concat("treegrid-parent-", $directory/@parent-id) else ("")}">
       <td nowrap="nowrap"><a href="{mledms-utils:create-command-url("directory-search", (<params><param name="q">{ $query }</param><param name="current">{ xdmp:quote($directory/@uri) }</param></params>))}">{ $directory/text() }</a></td>
       </tr>
       )
}


</table>
</div>
                </div>
 
    ) else ()
}
            </div>
            <div class="col-lg-9 right-pane">
                <fieldset>
                    <legend>データ検索</legend>
                    <div class="row">
                        <div class="col-sm-offset-1 col-sm-8 text-right">
                            <form class="form-horizontal" method="get" action="{mledms-utils:create-command-url("directory-search", ())}">
                                <fieldset>
                                    <div class="input-group">
                                        <input type="hidden" name="current" value="{ $current }"/>
                                        <input type="text" name="q" class="form-control" placeholder="Search for..." value="{ $query }"/>
                                        <span class="input-group-btn"><button class="btn btn-default" type="submit">検索</button></span>
                                    </div>
                                 </fieldset>
                            </form>
                        </div>
                    </div>
                    <hr/>

{
    for $result in $search-result/search:result
    return (
                    <div class="panel panel-default col-sm-offset-1">
                        <div class="panel-heading">
                            <a class="search-result" href="{mledms-utils:create-command-url("detail", <params><param name="document-uri">{ fn:string($result/@uri) }</param></params>)}">{ fn:string($result/@uri) }</a>
                        </div>
                        <div class="panel-body">
        {
                for $i at $pos in $result/node()/search:match
                return (
                    if ($pos ne 1) then text {" ... "} else (),
                            <span data-toggle="tooltip" data-placement="bottom" title="{ fn:replace(xdmp:quote($i/@path), "^.*""\)/prop:properties(.*)", "$1") }">
                    {
                        if (fn:matches(xdmp:quote($i), "<search:highlight")) then (
                            xdmp:unquote(
                                fn:replace(
                                    fn:replace(
                                        xdmp:quote($i),
                                        "<search:highlight[^>]*>([^<]*)</search:highlight>",
                                        "<strong>$1</strong>"),
                                    "<search:match[^>]*>([^<]*)</search:match>",
                                    "$1")
                                )
                        ) else (
                            $i
                        )
                    }
                            </span>
                )
        }
                            <br/><br/>
                            <div class="text-right">Score:{ fn:string($result/@score) }, Confidence:{ fn:string($result/@confidence) }, Fitness:{ fn:string($result/@fitness) }</div>
                        </div>
                    </div>
    )
}
                    <hr/>

{
    if ($search-result/search:metrics) then (
                    <div class="row text-right">
                        <small>
                                            クエリ解析時間:{ $search-result/search:metrics/search:query-resolution-time/text() }(ms) -
                                            ファセット解析時間:{ $search-result/search:metrics/search:facet-resolution-time/text() }(ms) -
                                            スニペット解析時間:{ $search-result/search:metrics/search:snippet-resolution-time/text() }(ms) -
                                            総処理時間:{ $search-result/search:metrics/search:total-time/text() }(ms)
                        </small>
                    </div>
    ) else ()
}
                    <br/>
                </fieldset>
            </div>
        </div>