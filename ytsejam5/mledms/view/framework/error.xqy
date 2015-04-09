xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $error := map:get($mledms-utils:request-attribute, "error")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>エラー</h3>
                <hr/>
            </div>
            <div class="col-lg-3 left-pane"> </div>
            <div class="col-lg-9 right-pane">
{   
    if ($error) then (
                <div class="alert alert-danger" role="alert">
                    <span class="sr-only">Error:</span>
                    { $error/error:message/text() }
                    <pre>{xdmp:quote($error)}</pre>
                </div>
    ) else ()
}
            </div>
        </div>