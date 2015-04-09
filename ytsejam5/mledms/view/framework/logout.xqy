xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>ログアウト</h3>
                <hr/>
            </div>
            <div class="col-lg-3 left-pane"> </div>
            <div class="col-lg-9 right-pane">
                <div class="alert text-center" role="alert">
                    ログアウトしました。<br/>
                    <br/>
                    [ <a href="{mledms-utils:create-command-url("search", ())}">再ログイン<a> ]
                </div>
            </div>
        </div>