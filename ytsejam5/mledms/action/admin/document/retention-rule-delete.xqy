xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-config = "https://github.com/ytsejam5/mledml/config" at "/ytsejam5/mledms/utils/config.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

let $name := xdmp:get-request-field("name")

return (
    dls:retention-rule-remove($name),
    xdmp:commit(),
    xdmp:log(fn:concat("retention rule deleted. [", $name, "]")),

    xdmp:redirect-response(mledms-utils:create-command-url("admin/document/retention-rule-list", ()))
)