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

let $user-name := $user/mledms:user/mledms:user-name/text()
let $statement :=
    if (fn:not(mledms-security:user-exists($user-name))) then
        fn:error((), fn:concat("user not found. [user-name", $user-name, "]"))
    else ()

let $statement := map:put($request-attribute, "user-id", $user-id)
let $statement := map:put($request-attribute, "user", $user)

return
    mledms-utils:forward("/admin/security/user-detail.xqy", $request-attribute)