xquery version "1.0-ml";

let $request-url := xdmp:get-request-url()
return
    if (fn:starts-with($request-url, "/resource/")) then (
        $request-url
        
    ) else if (fn:matches($request-url, "^/([^\?]+)\?(.*)$")) then (
        fn:replace($request-url, "^/([^\?]+)\?(.*)", "/index.xqy?command=$1&amp;$2")

    ) else if (fn:matches($request-url, "^/([^\?]+)$")) then (
        fn:replace($request-url, "^/([^\?]+)", "/index.xqy?command=$1")

    ) else (
        "/index.xqy"
    )


