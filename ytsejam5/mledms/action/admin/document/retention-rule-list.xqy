xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $query := xdmp:get-request-field("q", "*")
let $retention-rules := dls:retention-rules($query)
    
let $statement := map:put($request-attribute, "query", $query)
let $statement := map:put($request-attribute, "retention-rules", $retention-rules)
        
return (
    mledms-utils:forward("/admin/document/retention-rule-list.xqy", $request-attribute)
)