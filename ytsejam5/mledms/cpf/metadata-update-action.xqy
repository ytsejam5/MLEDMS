xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:transition as node() external;
declare variable $cpf:options as element() external;

if (cpf:check-transition($cpf:document-uri, $cpf:transition)) then 
    try {

        let $document := fn:doc($cpf:document-uri)

        let $filtered-data := xdmp:document-filter($document)

 (:
        let $language := (
            for $i in xdmp:encoding-language-detect($filtered-data)
            where $i/*:score > 10
            order by $i/*:score descending
                return $i/*:language)[1]

        let $language := if ($language) then ($language) else ("ja")
:)

        let $language := "ja"
        
        let $filtered-data :=
            element html {
                attribute xml:lang { $language },
                element head {
                    for $i in $filtered-data/*:html/*:head/*:meta
                        return
                            element meta {
                                attribute name { $i/@name },
                                attribute content { $i/@content },
                                text {$i/@content  }
                            }
                    },
                $filtered-data/*:html/*:body
            }

        let $statement := xdmp:document-set-property($cpf:document-uri, $filtered-data)
    
        return
            xdmp:log(fn:concat("properties appended. [", $cpf:document-uri, "]")),
            cpf:success($cpf:document-uri, $cpf:transition, ())
    
    } catch ($e) {
        xdmp:log($e),
        cpf:failure($cpf:document-uri, $cpf:transition, $e, ())
}
else ()