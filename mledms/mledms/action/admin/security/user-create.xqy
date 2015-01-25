xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $request-attribute as map:map external;

let $user-name := xdmp:get-request-field("user-name")

let $statement :=
    if (mledms-security:user-exists($user-name))
    then fn:error((), fn:concat("user already exists. [", $user-name, "]")) 
    else ()

let $description := xdmp:get-request-field("description")
let $password := xdmp:get-request-field("password")
let $password-confirm := xdmp:get-request-field("password-confirm")

let $statement :=
    if ($password ne $password-confirm)
    then fn:error((), fn:concat("invalid password. [", $user-name, "]")) 
    else ()

let $parent-roles := ("dls-user")
let $permissions := ()
let $collections := ()
let $external-names := ()

return (
    let $user-id := mledms-security:create-user($user-name, $description, $password, $parent-roles, $permissions, $collections, $external-names)
        
    return (
        let $user-document-uri := fn:concat("/users/", $user-id)
        let $user-document :=
        element mledms:user {
            element mledms:user-id { $user-id },
            element mledms:user-name { $user-name },
            element mledms:description { $description }
        }
        
        return (
            xdmp:document-insert($user-document-uri, $user-document, xdmp:permission("dls-user", "read"), $collections),
            xdmp:commit(),
            xdmp:log(fn:concat("user created.  [", $user-id, ", ", $user-name, "]")), 
    
            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/user-search", ()))
        )
    )
)



