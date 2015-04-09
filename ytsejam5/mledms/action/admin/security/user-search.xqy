xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $query := xdmp:get-request-field("q", "")
let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := mledms-security:search-users($query, xs:unsignedLong($start), xs:unsignedLong($page-length))
    
let $statement := map:put($request-attribute, "query", $query)
let $statement := map:put($request-attribute, "search-result", $search-result)
        
return (
    mledms-utils:forward("/admin/security/user-search.xqy", $request-attribute)
)