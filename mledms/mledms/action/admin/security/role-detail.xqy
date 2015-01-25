xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $request-attribute as map:map external;

let $role-id := xdmp:get-request-field("role-id")
   
let $role-document-uri := fn:concat("/roles/", $role-id)
let $role := fn:doc($role-document-uri)
let $statement :=
    if (fn:not($role)) then
        fn:error((), fn:concat("role not found. [role-id:", $role-id, "]"))
    else ()

let $role-name := $role/mledms:role/mledms:role-name/text()
let $statement :=
    if (fn:not(mledms-security:role-exists($role-name))) then
        fn:error((), fn:concat("role not found. [role-name", $role-name, "]"))
    else ()

let $statement := map:put($request-attribute, "role-id", $role-id)
let $statement := map:put($request-attribute, "role", $role)

return
    mledms-utils:forward("admin/security/role-detail.xqy", $request-attribute)