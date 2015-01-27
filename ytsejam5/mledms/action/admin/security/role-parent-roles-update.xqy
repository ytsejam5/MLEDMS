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
    
let $statement := map:put($request-attribute, "role-id", $role-id)
let $statement := map:put($request-attribute, "role", $role)

let $parent-roles := xdmp:get-request-field("parent-role-id")

let $adding-parent-roles :=
    for $parent-role-id in $parent-roles
    let $parent-role-name := mledms-security:get-role-name(xs:unsignedLong($parent-role-id))
    let $original-parent-role := xdmp:get-request-field(fn:concat("original-parent-role:", $parent-role-id))
    let $updating-parent-role := xdmp:get-request-field(fn:concat("updating-parent-role:", $parent-role-id))
    where (fn:string($original-parent-role) ne "true") and (fn:string($updating-parent-role) eq "true")
    return
        $parent-role-name

let $removing-parent-roles :=
    for $parent-role-id in $parent-roles
    let $parent-role-name := mledms-security:get-role-name(xs:unsignedLong($parent-role-id))
    let $original-parent-role := xdmp:get-request-field(fn:concat("original-parent-role:", $parent-role-id))
    let $updating-parent-role := xdmp:get-request-field(fn:concat("updating-parent-role:", $parent-role-id))
    where (fn:string($original-parent-role) eq "true") and (fn:string($updating-parent-role) ne "true")
    return 
        $parent-role-name

let $role-name := $role/mledms:role/mledms:role-name/text()

return (
    mledms-security:role-add-roles($role-name, $adding-parent-roles),
    mledms-security:role-remove-roles($role-name, $removing-parent-roles),
    xdmp:commit(),
    
    xdmp:log(fn:concat("role roles updated. [", $role-name, "]")),
    xdmp:log("added:"),
    xdmp:log($adding-parent-roles),
    xdmp:log("removed:"),
    xdmp:log($removing-parent-roles),
    
    xdmp:redirect-response(mledms-utils:create-command-url("admin/security/role-parent-roles", (<params><param name="role-id">{ $role-id }</param></params>)))
)