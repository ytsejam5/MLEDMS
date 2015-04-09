xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $request-attribute as map:map external;

let $role-id := xdmp:get-request-field("role-id")
   
let $role-document-uri := fn:concat("/roles/", $role-id)
let $role := fn:doc($role-document-uri)
let $statement :=
    if (fn:not($role)) then
        fn:error((), fn:concat("role not found. [role-id:", $role-id, "]"))
    else ()
    
let $statement := map:put($request-attribute, "role-id", $role-id)
let $statement := map:put($request-attribute, "role", $role)

let $query := xdmp:get-request-field("q", "")
let $statement := map:put($request-attribute, "query", $query)

let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := mledms-security:search-roles($query, xs:unsignedLong($start), xs:unsignedLong($page-length), $role-id)
let $statement := map:put($request-attribute, "search-result", $search-result)

let $parent-roles := mledms-security:role-get-roles($role/mledms:role/mledms:role-name/text())
let $statement := map:put($request-attribute, "parent-roles", $parent-roles)

return
    mledms-utils:forward("/admin/security/role-parent-roles.xqy", $request-attribute)