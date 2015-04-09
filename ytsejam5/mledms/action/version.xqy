xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")       
let $document := fn:doc($document-uri)
let $statement :=
    if (fn:not($document)) then
        fn:error((), fn:concat("document not found. [", $document-uri, "]"))
    else ()
    
let $statement := map:put($request-attribute, "document-uri", $document-uri)

let $is-managed := dls:document-is-managed($document-uri)
let $statement := map:put($request-attribute, "is-managed", $is-managed)

let $statement :=
    if ($is-managed) then (
        let $checkout-status := dls:document-checkout-status($document-uri)
        let $statement := map:put($request-attribute, "checkout-status", $checkout-status)
        
        let $document-history := dls:document-history($document-uri)
        let $statement := map:put($request-attribute, "document-history", $document-history)

        return ()
    ) else ()

return
    mledms-utils:forward("/version.xqy", $request-attribute)