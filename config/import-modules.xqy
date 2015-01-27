xquery version "1.0-ml";

declare variable $module-root-path as xs:string external;

let $statement := 
    for $i in xdmp:filesystem-directory(fn:concat($module-root-path, "/ytsejam5/mledms/cpf"))/*
    let $module-path := fn:concat("/ytsejam5/mledms/cpf/", $i/*:filename/text())
    let $module := xdmp:document-get($i/*:pathname/text())
    return xdmp:document-insert($module-path, $module)

return ()
