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
    
let $directory := xdmp:directory($document-uri)
let $collections := xdmp:document-get-collections($document-uri)
let $properties :=  xdmp:document-properties($document-uri)
let $weight := xdmp:document-get-quality($document-uri)

let $statement := map:put($request-attribute, "document-uri", $document-uri)
let $statement := map:put($request-attribute, "document", $document)
let $statement := map:put($request-attribute, "properties", $properties)
let $statement := map:put($request-attribute, "directory", $directory)
let $statement := map:put($request-attribute, "collections", $collections)
let $statement := map:put($request-attribute, "weight", $weight)

let $lock := xdmp:document-locks($document-uri)
let $statement := map:put($request-attribute, "lock", $lock)

return
    mledms-utils:forward("/detail.xqy", $request-attribute)