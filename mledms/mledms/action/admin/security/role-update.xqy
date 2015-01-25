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

let $old-role-name := $role/mledms:role/mledms:role-name/text()
let $new-role-name := xdmp:get-request-field("role-name")
let $statement :=
    if (($old-role-name ne $new-role-name) and mledms-security:role-exists($new-role-name)) then
        fn:error((), fn:concat("role name already exists. [role-name", $new-role-name, "]"))
    else ()
    
let $description := xdmp:get-request-field("description")
    
return (
    let $statment := mledms-security:update-role(xs:unsignedLong($role-id), $new-role-name, $description, (), (), (), (), ())
    
    return (
        let $role-document :=
        element mledms:role {
            element mledms:role-id { $role-id },
            element mledms:role-name { $new-role-name },
            element mledms:description { $description }
        }
        let $permissions := xdmp:document-get-permissions($role-document-uri)
        let $collections := xdmp:document-get-collections($role-document-uri)
        return
            xdmp:document-insert($role-document-uri, $role-document, $permissions, $collections),
            xdmp:commit(),
            xdmp:log(fn:concat("role updated. [", $role-id, "]")),
    
            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/role-detail", (<params><param name="role-id">{ $role-id }</param></params>)))
    )
)
