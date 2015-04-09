xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")       
let $document := fn:doc($document-uri)
let $statement :=
    if (fn:not($document)) then
        fn:error((), fn:concat("document not found. [", $document-uri, "]"))
    else ()
        
return (
    xdmp:document-delete($document-uri),
    xdmp:commit(),
    xdmp:log(fn:concat("document deleted. [", $document-uri, "]")),

    xdmp:redirect-response(mledms-utils:create-command-url("search", ()))
)