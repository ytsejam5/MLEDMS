xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")

let $document := fn:doc($document-uri)
let $statement := if (fn:not($document)) then fn:error((), fn:concat("document not found. [", $document-uri, "]")) else ()

let $directory := if (fn:matches($document-uri, "/")) then fn:replace($document-uri, "^(.*/)([^/]+)$", "$1") else ""
let $collections := xdmp:document-get-collections($document-uri)
let $weight := xdmp:document-get-quality($document-uri)

let $statement := map:put($request-attribute, "document-uri", $document-uri)
let $statement := map:put($request-attribute, "document", $document)
let $statement := map:put($request-attribute, "directory", $directory)
let $statement := map:put($request-attribute, "collections", $collections)
let $statement := map:put($request-attribute, "weight", $weight)

let $statement := map:put($request-attribute, "form-type", "update")

return
    mledms-utils:forward("/document-form.xqy", $request-attribute)