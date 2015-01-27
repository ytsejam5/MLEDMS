xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $database-name as xs:string external;
declare variable $trigger-database-name as xs:string external;

let $config := admin:get-configuration()

let $database-id := admin:database-get-id($config, $database-name)

let $config := admin:database-set-collection-lexicon($config, $database-id, fn:true())
let $config := admin:database-set-fast-reverse-searches($config, $database-id, fn:true())
let $config := admin:database-set-language($config, $database-id, "ja")
let $config := admin:database-set-triple-index($config, $database-id, fn:true())

let $config := admin:database-set-one-character-searches($config, $database-id, fn:true())
let $config := admin:database-set-two-character-searches($config, $database-id, fn:true())

let $config := admin:database-set-triggers-database($config, $database-id, xdmp:database($trigger-database-name))

let $statement := admin:save-configuration-without-restart($config)

return ()