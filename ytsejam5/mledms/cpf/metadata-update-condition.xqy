xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:options as element() external;

if (
    fn:not(xdmp:document-properties($cpf:document-uri)//*:document-uri) and
    fn:not(fn:starts-with($cpf:document-uri, "/roles/")) and
    fn:not(fn:starts-with($cpf:document-uri, "/users/"))
    
) then fn:true() else fn:false()

