xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $server-name as xs:string external;

let $config := admin:get-configuration()

let $statement :=
    if (admin:appserver-exists($config, xdmp:group("Default"), $server-name)) then (
        let $config := admin:appserver-delete($config, xdmp:server($server-name, xdmp:group("Default")))
        let $statement := admin:save-configuration-without-restart($config)
        return ()
    ) else ()

return ()