xquery version "1.0-ml";
(: for trigger database :)

import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
import module namespace p = "http://marklogic.com/cpf/pipelines" at "/MarkLogic/cpf/pipelines.xqy";

declare variable $module-root-path as xs:string external;

let $pipeline-config-path := fn:concat($module-root-path, "/ytsejam5/mledms/cpf/document-filter-pipeline.xml")
let $pipeline-config := xdmp:document-get($pipeline-config-path)
let $pipeline-id := p:insert($pipeline-config)

return ()