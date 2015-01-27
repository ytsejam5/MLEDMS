xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $server-name as xs:string external;
declare variable $server-port as xs:int external;
declare variable $content-database-name as xs:string external;
declare variable $module-root-path as xs:string external;

let $rewriter-path := "/ytsejam5/mledms/rewriter/rewriter.xqy"

let $config := admin:get-configuration()

let $groupid := admin:group-get-id($config, "Default")
let $content-database-id := admin:database-get-id($config, $content-database-name)

let $config := admin:http-server-create($config, $groupid, $server-name, $module-root-path, $server-port, 0, $content-database-id)
let $server-id := admin:appserver-get-id($config, $groupid, $server-name)
let $config := admin:appserver-set-url-rewriter($config, $server-id, $rewriter-path)
let $statement := admin:save-configuration-without-restart($config)
let $statement := xdmp:log(fn:concat("created http server. [", $server-name, "]"))

return ()