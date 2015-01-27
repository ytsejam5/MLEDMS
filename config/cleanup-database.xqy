xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $database-name as xs:string external;

let $config := admin:get-configuration()

let $forest-name := fn:concat($database-name, "-forest")

let $statement :=
    if (admin:forest-exists($config, $forest-name)) then (
        let $statement :=
            if (admin:forest-get-database($config, xdmp:forest($forest-name))) then (
                let $config := admin:database-detach-forest($config, xdmp:database($database-name), xdmp:forest($forest-name))
                let $statement := admin:save-configuration-without-restart($config)
                return ()
            ) else ()
        let $config := admin:forest-delete($config,  xdmp:forest($forest-name), fn:true())
        let $statement := admin:save-configuration-without-restart($config)
        return ()
    ) else ()
    
let $statement :=
    if (admin:database-exists($config, $database-name)) then (
        let $config := admin:database-delete($config, xdmp:database($database-name))
        let $statement := admin:save-configuration-without-restart($config)
        return ()
    ) else ()
    
return ()