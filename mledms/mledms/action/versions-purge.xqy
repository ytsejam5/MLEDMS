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
        
return (
    dls:document-purge($document-uri, fn:true(), fn:false()),
    xdmp:commit(),
    xdmp:log(fn:concat("document purged. [", $document-uri, "]")),

    xdmp:redirect-response(mledms-utils:create-command-url("version", <params><param name="document-uri">{$document-uri}</param></params>))
)