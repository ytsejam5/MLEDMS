xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare variable $request-attribute as map:map external;

let $query := xdmp:get-request-field("q", "")
let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $search-result := search:search($query,
    <options xmlns="http://marklogic.com/appservices/search">
        <searchable-expression>xdmp:document-properties()//html</searchable-expression>
        <additional-query>
        {
            cts:and-query((
                cts:not-query( (: including unmanaged documents and execluding version-document :)
                    cts:properties-query(
                        cts:element-query(fn:QName("http://marklogic.com/xdmp/dls", "dls:document-uri"), cts:and-query(())))
                ),
                cts:not-query(( (: execluding directories :)
                    cts:element-query(fn:QName("http://marklogic.com/xdmp/property", "prop:directory"), cts:and-query(()))
                ))
            ))
        }
        </additional-query>
        <constraint name="collection">
            <collection facet="true">
                <facet-option>frequency-order</facet-option>
                <facet-option>descending</facet-option>
                <facet-option>limit=20</facet-option>
            </collection>
        </constraint>
        <return-facets>true</return-facets>
        <return-metrics>true</return-metrics>
        <return-results>true</return-results>
    </options>, xs:unsignedLong($start), xs:unsignedLong($page-length))
    
let $statement := map:put($request-attribute, "query", $query)
let $statement := map:put($request-attribute, "search-result", $search-result)

return
    mledms-utils:forward("/search.xqy", $request-attribute)
