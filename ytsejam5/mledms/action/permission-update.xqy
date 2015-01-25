xquery version "1.0-ml";

import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $document-uri := xdmp:get-request-field("document-uri")
let $document := fn:doc($document-uri)
let $statement :=
            if (fn:not($document)) then
                fn:error((), fn:concat("document not found. [", $document-uri, "]"))
            else ()

let $roles := xdmp:get-request-field("role-id")

let $adding-permissions :=
    for $role-id in $roles
    let $role-name := mledms-security:get-role-name(xs:unsignedLong($role-id))
    return
        for $capability in ("read", "insert", "update", "execute")    
        let $original-permission := xdmp:get-request-field(fn:concat("original-permission:", $role-id, "-", $capability))
        let $updating-permission := xdmp:get-request-field(fn:concat("updating-permission:", $role-id, "-", $capability))
        where (fn:string($original-permission) ne "true") and (fn:string($updating-permission) eq "true")
        return
            xdmp:permission($role-name, $capability)

let $removing-permissions :=
    for $role-id in $roles
    let $role-name := mledms-security:get-role-name(xs:unsignedLong($role-id))
    return
        for $capability in ("read", "insert", "update", "execute")    
        let $original-permission := xdmp:get-request-field(fn:concat("original-permission:", $role-id, "-", $capability))
        let $updating-permission := xdmp:get-request-field(fn:concat("updating-permission:", $role-id, "-", $capability))
        where (fn:string($original-permission) eq "true") and (fn:string($updating-permission) ne "true")
        return 
            xdmp:permission($role-name, $capability)
               
return (
    xdmp:document-add-permissions($document-uri, $adding-permissions),
    xdmp:document-remove-permissions($document-uri, $removing-permissions),
    xdmp:commit(),
    
    xdmp:log(fn:concat("document permissions updated. [", $document-uri, "]")),
    xdmp:log("added:"),
    xdmp:log($adding-permissions),
    xdmp:log("removed:"),
    xdmp:log($removing-permissions),
    
    xdmp:redirect-response(mledms-utils:create-command-url("permission", <params><param name="document-uri">{$document-uri}</param></params>))
)