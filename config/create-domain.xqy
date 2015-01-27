xquery version "1.0-ml";
(: for trigger database :)

import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
import module namespace p = "http://marklogic.com/cpf/pipelines" at "/MarkLogic/cpf/pipelines.xqy";

declare variable $module-database-name as xs:string external;

let $domain := dom:create(
      "MLEDMS Domain", "", 
      dom:domain-scope("directory", "/", "infinity"),
      dom:evaluation-context(xdmp:database($module-database-name),  "/"),
      p:get("Document Filter Pipeline")/p:pipeline-id, ())

return ()