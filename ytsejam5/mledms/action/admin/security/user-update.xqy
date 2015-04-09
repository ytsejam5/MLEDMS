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

let $old-user-name := $user/mledms:user/mledms:user-name/text()
let $new-user-name := xdmp:get-request-field("user-name")
let $statement :=
    if ($old-user-name ne $new-user-name) then (
        if (mledms-security:user-exists($new-user-name)) then (
            fn:error((), fn:concat("user name already exists. [user-name", $new-user-name, "]"))
        ) else ()
    ) else ()
    
let $description := xdmp:get-request-field("description")
let $password := xdmp:get-request-field("password")
let $password := 
    if (fn:not(fn:matches($password, "^[\s]*$"))) then (
        let $password-confirm := xdmp:get-request-field("password-confirm")
        
        let $statement :=
            if ($password ne $password-confirm)
            then fn:error((), fn:concat("invalid password. [", $old-user-name, "]")) 
            else ()
            
        return
            $password
            
    ) else ()

return (
    let $statement := mledms-security:update-user(xs:unsignedLong($user-id), $new-user-name, $description, $password, (), (), (), ())
    return (
        let $user-document :=
            element mledms:user {
                element mledms:user-id { $user-id },
                element mledms:user-name { $new-user-name },
                element mledms:description { $description }
            }
        let $permissions := xdmp:document-get-permissions($user-document-uri)
        let $collections := xdmp:document-get-collections($user-document-uri)
        return (
            xdmp:document-insert($user-document-uri, $user-document, $permissions, $collections),
            xdmp:commit(),
            xdmp:log(fn:concat("user updated. [", $user-id, "]")),
    
            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/user-detail", (<params><param name="user-id">{ $user-id }</param></params>)))
        )
    )    
)
