xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

let $command := xdmp:get-request-field("command", "search")
let $request-attribute :=  map:map()
return
    try {
        let $statement := map:put($request-attribute, "command", $command)
        let $action-query := fn:concat("/ytsejam5/mledms/action/", $command, ".xqy")
        let $statement := xdmp:log(fn:concat("invoking ", $action-query, " action"))
        return
            xdmp:invoke(
                $action-query,
                (xs:QName("request-attribute"), $request-attribute), (
                    <options xmlns="xdmp:eval">
                        <isolation>different-transaction</isolation>
                        <prevent-deadlocks>true</prevent-deadlocks>
                        <transaction-mode>update</transaction-mode>
                    </options>))

    } catch($e) {
        xdmp:log($e, "error"),

        let $statement := map:put($request-attribute, "error", $e)
        return
            mledms-utils:forward("/framework/error.xqy", $request-attribute)
    }