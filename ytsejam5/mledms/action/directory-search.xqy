xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare variable $request-attribute as map:map external;


let $query := xdmp:get-request-field("q", "")
let $current := xdmp:get-request-field("current")
let $expanded := xdmp:get-request-field("expanded", ("/"))
let $start := xdmp:get-request-field("start", "1")
let $page-length := xdmp:get-request-field("page-length", "10")

let $query-options := 
    <options xmlns="http://marklogic.com/appservices/search" xmlns:prop="http://marklogic.com/xdmp/property">
        <searchable-expression>xdmp:document-properties()/prop:properties/html</searchable-expression>
        <additional-query>
        {
            cts:and-query((
                if ($current) then cts:directory-query($current, "1") else (cts:directory-query("/", "infinity")),
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
                <facet-option>properties</facet-option>
            </collection>
        </constraint>
        <return-constraints>true</return-constraints>
        <return-facets>false</return-facets>
        <return-metrics>true</return-metrics>
        <return-results>true</return-results>
    </options>


let $search-result := search:search($query, $query-options, xs:unsignedLong($start), xs:unsignedLong($page-length))
let $total :=
    if ($current) then (xdmp:directory($current, "1")) else (
        fn:count(
            cts:search(
                xdmp:document-properties()/prop:properties/html,
                cts:query(search:parse($query, $query-options))
                )))
let $directories := mledms-utils:get-directories("/", $expanded, if ($current) then $current else "/")
let $dummy := xdmp:log($directories)
let $statement := map:put($request-attribute, "query", $query)
let $statement := map:put($request-attribute, "current", $current)
let $statement := map:put($request-attribute, "total", $total)
let $statement := map:put($request-attribute, "directories", $directories)
let $statement := map:put($request-attribute, "search-result", $search-result)

return
    mledms-utils:forward("/directory-search.xqy", $request-attribute)
