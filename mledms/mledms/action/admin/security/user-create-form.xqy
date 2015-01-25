xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

let $statement := map:put($request-attribute, "form-type", "admin/security/user-create")
return
    mledms-utils:forward("admin/security/user-form.xqy", $request-attribute)
