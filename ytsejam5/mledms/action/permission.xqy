xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")       
let $document := fn:doc($document-uri)
let $statement :=
    if (fn:not($document)) then
        fn:error((), fn:concat("document not found. [", $document-uri, "]"))
    else ()
    
let $statement := map:put($request-attribute, "document-uri", $document-uri)

let $query := xdmp:get-request-field("q", "")
let $statement := map:put($request-attribute, "query", $query)

let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := mledms-security:search-roles($query, xs:unsignedLong($start), xs:unsignedLong($page-length), ())
let $statement := map:put($request-attribute, "search-result", $search-result)
    
let $permissions := xdmp:document-get-permissions($document-uri)
let $statement := map:put($request-attribute, "permissions", $permissions)

return
    mledms-utils:forward("/permission.xqy", $request-attribute)