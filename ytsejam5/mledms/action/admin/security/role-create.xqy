xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace mledms-security = "https://github.com/ytsejam5/mledms/security" at "/ytsejam5/mledms/utils/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $request-attribute as map:map external;

let $role-name := xdmp:get-request-field("role-name")
let $statement :=
    if (mledms-security:role-exists($role-name))
    then fn:error((), fn:concat("role already exists. [", $role-name, "]")) 
    else ()

let $description := xdmp:get-request-field("description")
    
let $parent-roles := ("dls-user")
let $permissions := ()
let $collections := ()
let $compartment := ()
let $external-names := ()

return (
    let $role-id := mledms-security:create-role($role-name, $description, $parent-roles, $permissions, $collections, $compartment, $external-names)

    (: here are temporary implementation :)
    let $statement := mledms-security:role-add-roles($role-name, ("dls-user"))

    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/dls-user", "execute", $role-name)
    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/xdmp-eval", "execute", $role-name)
    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/xdmp-eval-in", "execute", $role-name)
    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/xdmp-invoke", "execute",  $role-name)
    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/xdmp-login", "execute", $role-name)
    let $statement := mledms-security:privilege-add-role("http://marklogic.com/xdmp/privileges/unprotect-collection", "execute", $role-name)  
    
    let $statement := if (mledms-security:privilege-exists("/", "uri")) then () else (
        mledms-security:create-privilege("mledms", "/", "uri", "dls-user")
    )
    let $statement := mledms-security:privilege-add-role("/", "uri", $role-name) 
    
    let $statement := mledms-security:role-set-default-permissions($role-name, (
        mledms-security:permission($role-name, "read"), mledms-security:permission($role-name, "insert"),
        mledms-security:permission($role-name, "update"), mledms-security:permission($role-name, "execute")))
    (: end of the implementation :)

    return (
        let $role-document-uri := fn:concat("/roles/", $role-id)
        let $role-document :=
            element mledms:role {
                element mledms:role-id { $role-id },
                element mledms:role-name { $role-name },
                element mledms:description { $description }
            }
            
        return (
            xdmp:document-insert($role-document-uri, $role-document, xdmp:permission("dls-user", "read"), $collections),
            xdmp:commit(),
            xdmp:log(fn:concat("role created.  [", $role-id, ", ", $role-name, "]")), 
    
            xdmp:redirect-response(mledms-utils:create-command-url("admin/security/role-search", ()))
        )
    )
)