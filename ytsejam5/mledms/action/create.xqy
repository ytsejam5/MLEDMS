xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $resource-type := xdmp:get-request-field("resource-type")
let $resource :=
    if ($resource-type = "url") then
        let $resource-url := xdmp:get-request-field("resource-url")
        let $resource-name := fn:tokenize($resource-url, "\\|/")[fn:last()] 
        let $resource := xdmp:document-get($resource-url)
        return ($resource-name, $resource)
    else if ($resource-type = "upload") then
        let $resource-filepath := xdmp:get-request-field-filename("upload-file")
        let $resource-filename := fn:tokenize($resource-filepath, "\\|/")[fn:last()] 
        let $resource := xdmp:get-request-field("upload-file")
        return ($resource-filename, $resource)
   else ()
        
let $resource-name := $resource[1]

let $directory := mledms-utils:nomalize-directory-path(xdmp:get-request-field("directory", "/"))

let $id-type := xdmp:get-request-field("id-type", "file-name")
let $document-name := if (fn:string($id-type) eq "file-name") then $resource-name else mledms-utils:guid()

let $document-uri := fn:concat($directory, $document-name)

let $document := fn:doc($document-uri)
let $statement := 
    if ($document)
    then fn:error((), fn:concat("document already exists. [", $document-uri, "]")) 
    else ()
    
let $document := $resource[2]
    
let $collections := fn:tokenize(xdmp:get-request-field("collection"), "\s*,\s*")
let $permissions := xdmp:default-permissions()
let $weight := xdmp:get-request-field("weight", "1")

return (
    xdmp:document-insert($document-uri, $document, $permissions, $collections, xs:int($weight)),
    xdmp:commit(),
    xdmp:log(fn:concat("document inserted. [", $document-uri, "]")),

    xdmp:redirect-response(mledms-utils:create-command-url("search", ()))
)



