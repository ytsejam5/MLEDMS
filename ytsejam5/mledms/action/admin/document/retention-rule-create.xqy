xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-config = "https://github.com/ytsejam5/mledms/config" at "/ytsejam5/mledms/utils/config.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

let $name := xdmp:get-request-field("name")
let $comment := xdmp:get-request-field("comment")
let $num-versions := xdmp:get-request-field("num-versions")
let $duration := xdmp:get-request-field("duration")
let $document-query := xdmp:get-request-field("document-query", "")
let $document-query-text := xdmp:get-request-field("document-query-text")

let $retention-rule := dls:retention-rule(
    $name, $comment, 
    if ($num-versions) then xs:unsignedInt($num-versions) else (),
    if ($duration) then xs:duration($duration) else (),
    $document-query-text,
    if ($document-query) then cts:query(search:parse($document-query, $mledms-config:query-options)) else cts:and-query(()))

return (
    dls:retention-rule-insert($retention-rule),
    xdmp:commit(),
    xdmp:log(fn:concat("retention rule created. [", $name, "]")),

    xdmp:redirect-response(mledms-utils:create-command-url("admin/document/retention-rule-list", ()))
)