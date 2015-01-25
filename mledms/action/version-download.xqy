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
            
let $version := xdmp:get-request-field("version")
            
let $filename := fn:tokenize($document-uri, "/")[fn:last()]
let $statement := xdmp:add-response-header("Content-Disposition", fn:concat("attachment; filename=", $filename))
return
    dls:document-version($document-uri, $version)