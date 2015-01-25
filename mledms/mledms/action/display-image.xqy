xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")
let $document := fn:doc($document-uri)
let $statement :=
            if (fn:not($document)) then
                fn:error((), fn:concat("document not found. [", $document-uri, "]"))
            else ()

let $mime-type := mledms-utils:get-metadata($document-uri)/meta[@name eq "content-type"]/@content

let $statement := xdmp:add-response-header("Content-Type", $mime-type)
return
    fn:doc($document-uri)