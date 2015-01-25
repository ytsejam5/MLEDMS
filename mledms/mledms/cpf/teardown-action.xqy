xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:transition as node() external;
declare variable $cpf:options as element() external;

if (cpf:check-transition($cpf:document-uri, $cpf:transition)) then try {
    cpf:success($cpf:document-uri, $cpf:transition, ())
}
catch ($e) {
    cpf:failure($cpf:document-uri, $cpf:transition, $e, ())
}
else ()