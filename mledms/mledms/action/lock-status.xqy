xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")       
let $document := fn:doc($document-uri)
let $statement :=
    if (fn:not($document)) then
        fn:error((), fn:concat("document not found. [", $document-uri, "]"))
    else ()
    
let $statement := map:put($request-attribute, "document-uri", $document-uri)
    
let $lock := xdmp:document-locks($document-uri)
let $statement := map:put($request-attribute, "lock", $lock)

return
    mledms-utils:forward("lock-status.xqy", $request-attribute)