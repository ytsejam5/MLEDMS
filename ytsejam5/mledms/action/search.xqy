xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-config = "https://github.com/ytsejam5/mledml/config" at "/ytsejam5/mledms/utils/config.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare variable $request-attribute as map:map external;

let $query := xdmp:get-request-field("q", "")
let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := search:search($query, $mledms-config:query-options, xs:unsignedLong($start), xs:unsignedLong($page-length))
    
let $statement := map:put($request-attribute, "query", $query)
let $statement := map:put($request-attribute, "search-result", $search-result)

return
    mledms-utils:forward("/search.xqy", $request-attribute)
