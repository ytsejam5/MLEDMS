xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")
let $document := fn:doc($document-uri)

let $statement := if (fn:not($document)) then fn:error((), fn:concat("document not found. [", $document-uri, "]")) else ()

let $resource-type := xdmp:get-request-field("resource-type")
let $document :=
    if ($resource-type = "url") then
        let $resource-url := xdmp:get-request-field("resource-url")
        return xdmp:document-get($resource-url)
    else if ($resource-type = "upload") then xdmp:get-request-field("upload-file")
    else $document

let $collections := fn:tokenize(xdmp:get-request-field("collection"), "\s*,\s*")
let $permissions := xdmp:document-get-permissions($document-uri)
let $weight := xdmp:get-request-field("weight", "1")

return (
    xdmp:document-insert($document-uri, $document, $permissions, $collections, xs:int($weight)),
    xdmp:commit(),
    xdmp:log(fn:concat("document updated. [", $document-uri, "]")),
    
    xdmp:redirect-response(mledms-utils:create-command-url("detail", <params><param name="document-uri">{$document-uri}</param></params>))
)
