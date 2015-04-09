xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $query := map:get($mledms-utils:request-attribute, "query")
let $start := map:get($mledms-utils:request-attribute, "start")
let $end := map:get($mledms-utils:request-attribute, "end")
let $total := map:get($mledms-utils:request-attribute, "total")
let $has-prev := map:get($mledms-utils:request-attribute, "has-prev")
let $has-next := map:get($mledms-utils:request-attribute, "has-next")
let $search-result := map:get($mledms-utils:request-attribute, "search-result")
return
                <div class="row">
{
    if ($search-result/@start > 1) then (
                    <div class="col-sm-2 text-left previous"><a href="{mledms-utils:create-command-url("search", <params><param name="q">{$query}</param><param name="start">{fn:max((1, $search-result/@start - $search-result/@page-length))}</param></params>)}"><span aria-hidden="true">&larr;</span> PREV</a></div>
    ) else (
                    <div class="col-sm-2">&nbsp;</div>
    )
}
                    <div class="col-sm-8 text-center">該当件数 { fn:string($total) } 件中 { fn:min((fn:string($search-result/@start), fn:string($total))) } 件目から { fn:min(($total, ($search-result/@start + $search-result/@page-length - 1))) } 件目を表示</div>
{
    if ($search-result/@start + $search-result/@page-length < $total) then (
                    <div class="col-sm-2 text-right next"><a href="{mledms-utils:create-command-url("search", <params><param name="q">{$query}</param><param name="start">{fn:min(($total, $search-result/@start + $search-result/@page-length))}</param></params>)}">NEXT <span aria-hidden="true">&rarr;</span></a></div>
    ) else (
                    <div class="col-sm-2">&nbsp;</div>
    )
}
                </div>