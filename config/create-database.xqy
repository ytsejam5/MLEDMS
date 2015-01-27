xquery version "1.0-ml";
(: for admin :)

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $database-name as xs:string external;

let $config := admin:get-configuration()

let $forest-name := fn:concat($database-name, "-forest")

let $config := admin:forest-create($config, $forest-name, xdmp:host(), ())
let $statement := admin:save-configuration-without-restart($config)
let $statement := xdmp:log(fn:concat("created forest. [", $forest-name, "]"))

let $config := admin:database-create($config, $database-name, xdmp:database("Security"), xdmp:database("Schemas"))

let $database-id := admin:database-get-id($config, $database-name)
let $statement := admin:save-configuration-without-restart($config)
let $statement := xdmp:log(fn:concat("created database. [", $database-name, "]"))

let $config := admin:database-attach-forest($config, $database-id, xdmp:forest($forest-name))
let $statement := admin:save-configuration-without-restart($config)
let $statement := xdmp:log(fn:concat("attached forest to database. [", $forest-name, " -> ", $database-name, "]"))

return ()