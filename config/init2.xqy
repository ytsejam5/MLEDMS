xquery version "1.0-ml";

declare option xdmp:transaction-mode "auto";

let $APPLICATION-SERVER-NAME := "mledms-app"
let $APPLICATION-SERVER-PORT := 8018
let $MODULE-ROOT := "C:/Users/mltraining/git/MLEDMS"
let $CONTENT-DATABASE-NAME := "mledms-database"

let $module-database-name := "mledms-modules"
let $trigger-database-name := "mledms-triggers"

return (  
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/import-modules.xqy"),
        (xs:QName("module-root-path"), $MODULE-ROOT),
        <options xmlns="xdmp:eval">
            <database>{xdmp:database($module-database-name)}</database>
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-pipeline.xqy"),
        (xs:QName("module-root-path"), $MODULE-ROOT),
        <options xmlns="xdmp:eval">
            <database>{xdmp:database($trigger-database-name)}</database>
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-domain.xqy"),
        (xs:QName("module-database-name"), $module-database-name),
        <options xmlns="xdmp:eval">
            <database>{xdmp:database($trigger-database-name)}</database>
            <isolation>different-transaction</isolation>
        </options>),

    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/teardown.xqy"),
        (),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    "Done."
)

