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
        fn:concat($MODULE-ROOT, "/config/configuration.xqy"),
        (),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/cleanup-server.xqy"),
        (xs:QName("server-name"), $APPLICATION-SERVER-NAME),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/cleanup-database.xqy"),
        (xs:QName("database-name"), $CONTENT-DATABASE-NAME),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/cleanup-database.xqy"),
        (xs:QName("database-name"), $trigger-database-name),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/cleanup-database.xqy"),
        (xs:QName("database-name"), $module-database-name),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-database.xqy"),
        (xs:QName("database-name"), $module-database-name),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-database.xqy"),
        (xs:QName("database-name"), $trigger-database-name),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-database.xqy"),
        (xs:QName("database-name"), $CONTENT-DATABASE-NAME),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/setup-content-database.xqy"),
        ((xs:QName("database-name"), $CONTENT-DATABASE-NAME),
         (xs:QName("trigger-database-name"), $trigger-database-name)),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
    
    xdmp:invoke(
        fn:concat($MODULE-ROOT, "/config/create-server.xqy"),
        ((xs:QName("server-name"), $APPLICATION-SERVER-NAME),
         (xs:QName("server-port"), $APPLICATION-SERVER-PORT),
         (xs:QName("content-database-name"), $CONTENT-DATABASE-NAME),
         (xs:QName("module-root-path"), $MODULE-ROOT)),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
        </options>),
        
    "Done."
)

