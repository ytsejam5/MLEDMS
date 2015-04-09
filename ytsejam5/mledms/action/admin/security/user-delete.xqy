xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $user-id := xdmp:get-request-field("user-id")
   
let $user-document-uri := fn:concat("/users/", $user-id)
let $user := fn:doc($user-document-uri)
let $statement :=
    if (fn:not($user)) then
        fn:error((), fn:concat("user not found. [user-id:", $user-id, "]"))
    else ()
        
return (
    let $statement := mledms-security:remove-user(xs:unsignedLong($user-id))
    return (
        let $permissions := xdmp:document-get-permissions($user-document-uri)
        let $collections := xdmp:document-get-collections($user-document-uri)
        return (
            xdmp:document-delete($user-document-uri),
            xdmp:commit(),
            xdmp:log(fn:concat("user deleted. [", $user-id, "]")),

            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/user-search", ()))
        )
    )
)