import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $config := admin:appserver-set-request-timeout($config, admin:appserver-get-id($config, $groupid, "App-Services"), 600)
let $statement := admin:save-configuration($config)

return ()