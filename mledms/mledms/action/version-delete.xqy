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
        
return (
    dls:document-version-delete($document-uri, xs:integer($version), fn:false()),
    xdmp:commit(),
    xdmp:log(fn:concat("document deleted. [", $document-uri, ", version=(", $version, ")]")),

    xdmp:redirect-response(mledms-utils:create-command-url("version", <params><param name="document-uri">{$document-uri}</param></params>))
)