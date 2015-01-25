xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $role-id := xdmp:get-request-field("role-id")
   
let $role-document-uri := fn:concat("/roles/", $role-id)
let $role := fn:doc($role-document-uri)
let $statement :=
    if (fn:not($role)) then
        fn:error((), fn:concat("role not found. [role-id:", $role-id, "]"))
    else ()
        
return (
    let $statement := mledms-security:remove-role(xs:unsignedLong($role-id))
    
    return (
        let $permissions := xdmp:document-get-permissions($role-document-uri)
        let $collections := xdmp:document-get-collections($role-document-uri)
        return (
            xdmp:document-delete($role-document-uri),
            xdmp:commit(),
            xdmp:log(fn:concat("role deleted. [", $role-id, "]")),
        
            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/role-search", ()))
        )
    )
)