xquery version "1.0-ml";

module namespace mledms-config = "https://github.com/ytsejam5/mledms/config";

declare variable $mledms-config:query-options := 
    <options xmlns="http://marklogic.com/appservices/search" xmlns:prop="http://marklogic.com/xdmp/property">
        <searchable-expression>xdmp:document-properties()/prop:properties/html</searchable-expression>
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
                <facet-option>properties</facet-option>
            </collection>
        </constraint>
        <return-constraints>true</return-constraints>
        <return-facets>true</return-facets>
        <return-metrics>true</return-metrics>
        <return-results>true</return-results>
    </options>;