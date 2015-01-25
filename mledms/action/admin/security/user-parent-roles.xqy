xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

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

let $query := xdmp:get-request-field("q", "")
let $statement := map:put($request-attribute, "query", $query)

let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := mledms-security:search-roles($query, xs:unsignedLong($start), xs:unsignedLong($page-length))
let $statement := map:put($request-attribute, "search-result", $search-result)

let $parent-roles := mledms-security:user-get-roles($user/mledms:user/mledms:user-name/text())
let $statement := map:put($request-attribute, "parent-roles", $parent-roles)

return
    mledms-utils:forward("admin/security/user-parent-roles.xqy", $request-attribute)