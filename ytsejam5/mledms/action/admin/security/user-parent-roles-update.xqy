xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $request-attribute as map:map external;

let $user-id := xdmp:get-request-field("user-id")
   
let $user-document-uri := fn:concat("/users/", $user-id)
let $user := fn:doc($user-document-uri)
let $statement :=
    if (fn:not($user)) then
        fn:error((), fn:concat("user not found. [user-id:", $user-id, "]"))
    else ()
    
let $statement := map:put($request-attribute, "user-id", $user-id)
let $statement := map:put($request-attribute, "user", $user)

let $roles := xdmp:get-request-field("role-id")

let $adding-parent-roles :=
    for $role-id in $roles
    let $role-name := mledms-security:get-role-name(xs:unsignedLong($role-id))
    let $original-parent-role := xdmp:get-request-field(fn:concat("original-parent-role:", $role-id))
    let $updating-parent-role := xdmp:get-request-field(fn:concat("updating-parent-role:", $role-id))
    where (fn:string($original-parent-role) ne "true") and (fn:string($updating-parent-role) eq "true")
    return
        $role-name

let $removing-parent-roles :=
    for $role-id in $roles
    let $role-name := mledms-security:get-role-name(xs:unsignedLong($role-id))
    let $original-parent-role := xdmp:get-request-field(fn:concat("original-parent-role:", $role-id))
    let $updating-parent-role := xdmp:get-request-field(fn:concat("updating-parent-role:", $role-id))
    where (fn:string($original-parent-role) eq "true") and (fn:string($updating-parent-role) ne "true")
    return 
        $role-name

let $user-name := $user/mledms:user/mledms:user-name/text()

return (
    mledms-security:user-add-roles($user-name, $adding-parent-roles),
    mledms-security:user-remove-roles($user-name, $removing-parent-roles),
    xdmp:commit(),
    
    xdmp:log(fn:concat("user roles updated. [", $user-name, "]")),
    xdmp:log("added:"),
    xdmp:log($adding-parent-roles),
    xdmp:log("removed:"),
    xdmp:log($removing-parent-roles),
    
    xdmp:redirect-response(mledms-utils:create-command-url("admin/security/user-parent-roles", (<params><param name="user-id">{ $user-id }</param></params>)))
)