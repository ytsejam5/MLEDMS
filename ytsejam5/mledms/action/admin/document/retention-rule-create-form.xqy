xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $request-attribute as map:map external;

    mledms-utils:forward("/admin/document/retention-rule-create-form.xqy", $request-attribute)
