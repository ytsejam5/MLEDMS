xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $APPLICATION-SERVER-NAME := "mledms-app"
let $APPLICATION-SERVER-PORT := 8018
let $APPLICATION-SERVER-MODULE-PATH := "C:/Users/mltraining/git/MLEDMS"
let $DATABASE-NAME := "mledms-database"

let $config := admin:get-configuration()

let $forest-name := fn:concat($DATABASE-NAME, "-forest")
let $config := admin:forest-create($config, $forest-name, xdmp:host(), ())
let $statement := admin:save-configuration($config)
let $statement := xdmp:log("created forest.")

let $config := admin:database-create($config, $DATABASE-NAME, xdmp:database("Security"), xdmp:database("Schemas"))

let $database-id := admin:database-get-id($config, $DATABASE-NAME)

let $config := admin:database-set-collection-lexicon($config, $database-id, fn:true())
let $config := admin:database-set-fast-reverse-searches($config, $database-id, fn:true())
let $config := admin:database-set-language($config, $database-id, "ja")
let $config := admin:database-set-one-character-searches($config, $database-id, fn:true())
let $config := admin:database-set-triple-index($config, $database-id, fn:true())
let $config := admin:database-set-two-character-searches($config, $database-id, fn:true())

let $statement := admin:save-configuration($config)
let $statement := xdmp:log("created database.")

let $config := admin:database-attach-forest($config, $database-id, xdmp:forest($forest-name))
let $statement := admin:save-configuration($config)
let $statement := xdmp:log("attached forest to database.")

let $groupid := admin:group-get-id($config, "Default")

let $config := admin:http-server-create($config, $groupid, $APPLICATION-SERVER-NAME, $APPLICATION-SERVER-MODULE-PATH, $APPLICATION-SERVER-PORT, 0, $database-id)
let $statement := admin:save-configuration($config)
let $statement := xdmp:log("created http server.")

return admin:save-configuration($config)
