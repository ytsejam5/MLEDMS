xquery version "1.0-ml";
(: ignore the error XDMP-EVALLIBMOD in using XQDT (https://bugs.eclipse.org/bugs/show_bug.cgi?id=307910):)

module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils";

declare namespace search = "http://marklogic.com/appservices/search";

declare variable $mledms-utils:use-writer := fn:true();

declare function mledms-utils:random-hex($seq as xs:integer*) as xs:string+ {
    for $i in $seq
    return 
        fn:string-join(
            for $n in 1 to $i
                return xdmp:integer-to-hex(xdmp:random(15)),
            "")
};

declare function mledms-utils:guid() as xs:string {
    fn:string-join(mledms-utils:random-hex((8, 4, 4, 4, 12)), "-")
};

declare function mledms-utils:forward($view as xs:string, $request-attribute as map:map) as item()* {
    map:put($request-attribute, "view", $view),
    xdmp:invoke("/ytsejam5/mledms/view/framework/template.xqy", (xs:QName("mledms-utils:request-attribute"), $request-attribute), (
        <options xmlns="xdmp:eval">
            <isolation>same-statement</isolation>
        </options>))
};

declare function mledms-utils:import-viewpart($path as xs:string, $request-attribute as map:map) as item()* {
    let $view-part := fn:concat("/ytsejam5/mledms/view", $path)
    return
    xdmp:invoke($view-part, (xs:QName("mledms-utils:request-attribute"), $request-attribute), (
        <options xmlns="xdmp:eval">
            <isolation>same-statement</isolation>
        </options>))
};

declare function mledms-utils:nomalize-directory-path($path as xs:string) as xs:string {
    let $path := if (fn:starts-with($path, "/")) then $path else fn:concat("/", $path)
    let $path := if (fn:ends-with($path, "/")) then $path else fn:concat($path, "/")
    return
        $path
};

declare function mledms-utils:create-command-url($command as xs:string, $parameter as node()?) as xs:string {
    fn:concat(
        if ($mledms-utils:use-writer) then (
            fn:concat("/", $command, if ($parameter) then "?" else "")
            
        ) else (
             fn:concat(
                "/index.xqy?",
                fn:string-join(("command", $command), "="),
                if ($parameter) then "&amp;" else "")
        ),
        fn:string-join(for $i in $parameter/* return (fn:concat($i/@name, "=", xdmp:url-encode(fn:string($i/text())))), "&amp;"))
};

declare function mledms-utils:get-metadata($document-uri as xs:string) as node()* {
    xdmp:document-properties($document-uri)/*:properties/*:html/*:head/*:meta
};

        