xquery version "1.0-ml";

module namespace mledms-security = "https://github.com/ytsejam5/mledml/security";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare function mledms-security:search-roles($query as xs:string, $start as xs:long, $page-length as xs:long, $exclude-role-id as xs:string?) as node()* {
    let $search-result := search:search($query,
        <options xmlns="http://marklogic.com/appservices/search">
            <additional-query>
            {
                if ($exclude-role-id) then (
                    cts:and-query((
                        cts:directory-query("/roles/", "infinity"),
                        cts:not-query(cts:document-query(fn:concat("/roles/", $exclude-role-id)))
                    ))
                ) else (
                    cts:and-query((
                        cts:directory-query("/roles/", "infinity")
                    ))
                )
            }
            </additional-query>
            <transform-results apply="raw">
                <preferred-elements>
                </preferred-elements>
            </transform-results>
            <sort-order type="xs:string" collation="http://marklogic.com/collation/" direction="ascending">
                <element ns="https://github.com/ytsejam5/mledml/mledms" name="role-name"/>
            </sort-order>
            <operator name="sort">
                <sort-order type="xs:string" collation="http://marklogic.com/collation/" direction="ascending">
                    <element ns="https://github.com/ytsejam5/mledml/mledms" name="role-name"/>
                </sort-order>
            </operator>
            <return-results>true</return-results>
        </options>, xs:unsignedLong($start), xs:unsignedLong($page-length))
    return $search-result
};

declare function mledms-security:get-role-name($role-id as xs:unsignedLong) as xs:string {
    let $role-name := fn:doc(fn:concat("/roles/", fn:string($role-id)))/mledms:role/mledms:role-name/text()
    return
        if ($role-name)
        then ($role-name)
        else (
            xdmp:eval(
               'xquery version "1.0-ml";
                import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
                declare variable $role-id external;
                sec:get-role-names($role-id)',
                (xs:QName("role-id"), $role-id),
                <options xmlns="xdmp:eval">
                    <database>{ xdmp:security-database() }</database>
                    <user-id>{ xdmp:user("admin") }</user-id>
                </options>)
                )
};

declare function mledms-security:role-exists(
        $role-name as xs:string) as xs:boolean {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $role-name as xs:string external;
        sec:role-exists($role-name)', ((xs:QName("role-name"), $role-name)),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:serialize-role(
        $role-id as xs:unsignedLong,
        $role-name as xs:string,
        $description as xs:string?,
        $parent-role-names as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $compartment as xs:string?,
        $external-names as xs:string*) as xs:string {
    let $document := element role {
        element role-id { fn:string($role-id) },
        element role-name { $role-name },
        element description { $description },
        for $i in $parent-role-names return element parent-role-name { $i },
        for $i in $permissions return element permission { $i },
        for $i in $collections return element collection { $i },
        element compartment { $compartment },
        for $i in $external-names return element external-name { $i }
    }
    return xdmp:quote($document)
};

declare function mledms-security:create-role(
        $role-name as xs:string,
        $description as xs:string?,
        $parent-role-name as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $compartment as xs:string?,
        $external-names as xs:string*) as xs:unsignedLong {
        
    let $serialized-role := mledms-security:serialize-role(
            0,
            $role-name,
            $description,
            $parent-role-name,
            $permissions,
            $collections,
            $compartment,
            $external-names)
    return
        xdmp:eval(
           'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-role external;
            let $document := xdmp:unquote($serialized-role)
            return
                sec:create-role(
                  $document/role/role-name/text(),
                  $document/role/description/text(),
                  $document/role/parent-role-name/*,
                  $document/role/permission/*,
                  $document/role/collection/text(),
                  $document/role/compartment/text(),
                  $document/role/external-names/text())',
                ((xs:QName("serialized-role"), xdmp:quote($serialized-role))),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:update-role(
        $role-id as xs:unsignedLong,
        $new-role-name as xs:string,
        $description as xs:string?,
        $parent-role-name as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $compartment as xs:string?,
        $external-names as xs:string*) as empty-sequence() {
        
    let $serialized-role := mledms-security:serialize-role(
            $role-id,
            $new-role-name,
            $description,
            $parent-role-name,
            $permissions,
            $collections,
            $compartment,
            $external-names)
    return
        xdmp:eval(
           'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-role external;
            let $document := xdmp:unquote($serialized-role)
            let $role-name := sec:get-role-names($document/role/role-id/text())
            return (
                if ($role-name ne $document/role/role-name/text()) then (
                    sec:role-set-name($role-name, $document/role/role-name/text())
                ) else (),
                
                if ($document/role/description/text()) then (
                    sec:role-set-description($role-name, $document/role/description/text())
                ) else (),
                
                if ($document/role/parent-role-name/*) then (
                    sec:role-set-roles($role-name, $document/role/parent-role-name/*)
                ) else (),
                
                if ($document/role/permission/*) then (
                    sec:role-set-default-permissions($role-name, $document/role/permission/*)
                ) else (),
                
                if ($document/role/collection/text()) then (
                    sec:role-set-default-collections($role-name, $document/role/collection/text())
                ) else (),
                
                if ($document/role/compartment/text()) then (
                    (: immutable? :)
                ) else (),
                
                if ($document/role/external-names/text()) then (
                    sec:role-set-external-names($role-name, $document/role/external-names/text())
                ) else ()
            )',
            ((xs:QName("serialized-role"), xdmp:quote($serialized-role))),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:remove-role($role-id as xs:unsignedLong) as empty-sequence() {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $role-id external;
        let $role-name := sec:get-role-names($role-id)
        return sec:remove-role($role-name)',
        (xs:QName("role-id"), $role-id),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:role-set-default-permissions(
        $role-name as xs:string,
        $permissions as element(sec:permission)*) as empty-sequence() {
        
    let $serialized-role := mledms-security:serialize-role(
            0,
            $role-name,
            (),
            (),
            $permissions,
            (),
            (),
            ())
    return
        xdmp:eval(
           'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-role external;
            let $document := xdmp:unquote($serialized-role)
            return
                sec:role-set-default-permissions(
                  $document/role/role-name/text(),
                  $document/role/permission/*)',
                ((xs:QName("serialized-role"), xdmp:quote($serialized-role))),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:permission(
   $role as xs:string,
   $capability as xs:string
) as element() {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $role external;
            declare variable $capability external;
            xdmp:permission($role, $capability)',
            ((xs:QName("role"), $role), (xs:QName("capability"), $capability)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:get-user-name($user-id as xs:unsignedLong) as xs:string {
    let $user-name := fn:doc(fn:concat("/users/", fn:string($user-id)))/mledms:user/mledms:user-name/text()
    return
        if ($user-name)
        then ($user-name)
        else (  
            xdmp:eval(
               'xquery version "1.0-ml";
                import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
                declare variable $user-id external;
                sec:get-user-names($user-id)',
                (xs:QName("user-id"), $user-id),
                <options xmlns="xdmp:eval">
                    <database>{ xdmp:security-database() }</database>
                    <user-id>{ xdmp:user("admin") }</user-id>
                </options>)
                )
};

declare function mledms-security:user-exists(
        $user-name as xs:string) as xs:boolean {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $user-name as xs:string external;
        sec:user-exists($user-name)',
        ((xs:QName("user-name"), $user-name)),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:search-users($query as xs:string, $start as xs:long, $page-length as xs:long) as node()* {
    let $search-result := search:search($query,
        <options xmlns="http://marklogic.com/appservices/search">
            <additional-query>
            {
                cts:and-query((
                    cts:directory-query("/users/", "infinity")
                ))
            }
            </additional-query>
            <transform-results apply="raw">
                <preferred-elements>
                </preferred-elements>
            </transform-results>
            <sort-order type="xs:string" collation="http://marklogic.com/collation/" direction="ascending">
                <element ns="https://github.com/ytsejam5/mledml/mledms" name="user-name"/>
            </sort-order>
            <operator name="sort">
                <sort-order type="xs:string" collation="http://marklogic.com/collation/" direction="ascending">
                    <element ns="https://github.com/ytsejam5/mledml/mledms" name="user-name"/>
                </sort-order>
            </operator>
            <return-results>true</return-results>
        </options>, xs:unsignedLong($start), xs:unsignedLong($page-length))
    return $search-result
};

declare function mledms-security:serialize-user(
        $user-id as xs:unsignedLong,
        $user-name as xs:string,
        $description as xs:string?,
        $password as xs:string,
        $parent-role-names as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $external-names as xs:string*) as xs:string {
    let $document := element user {
        element user-id { fn:string($user-id) },
        element user-name { $user-name },
        element description { $description },
        element password { $password },
        for $i in $parent-role-names return element parent-role-name { $i },
        for $i in $permissions return element permission { $i },
        for $i in $collections return element collection { $i },
        for $i in $external-names return element external-name { $i }
    }
    return xdmp:quote($document)
};

declare function mledms-security:create-user(
        $user-name as xs:string,
        $description as xs:string?,
        $password as xs:string,
        $parent-role-name as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $external-names as xs:string*) as xs:unsignedLong {
        
    let $serialized-user := mledms-security:serialize-user(
            0,
            $user-name,
            $description,
            $password,
            $parent-role-name,
            $permissions,
            $collections,
            $external-names)
    return
        xdmp:eval(
           'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-user external;
            let $document := xdmp:unquote($serialized-user)
            return
                sec:create-user(
                  $document/user/user-name/text(),
                  $document/user/description/text(),
                  $document/user/password/text(),
                  $document/user/parent-role-name/*,
                  $document/user/permission/*,
                  $document/user/collection/text(),
                  $document/user/external-names/text())',
                ((xs:QName("serialized-user"), xdmp:quote($serialized-user))),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:update-user(
        $user-id as xs:unsignedLong,
        $new-user-name as xs:string,
        $description as xs:string?,
        $password as xs:string?,
        $parent-role-name as xs:string*,
        $permissions as element(sec:permission)*,
        $collections as xs:string*,
        $external-names as xs:string*) as empty-sequence() {
        
    let $serialized-user := mledms-security:serialize-user(
            $user-id,
            $new-user-name,
            $description,
            $password,
            $parent-role-name,
            $permissions,
            $collections,
            $external-names)
    return
        xdmp:eval(
           'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-user external;
            let $document := xdmp:unquote($serialized-user)
            let $user-name := sec:get-user-names($document/user/user-id/text())
            return (
                if ($user-name ne $document/user/user-name/text()) then (
                    sec:user-set-name($user-name, $document/user/user-name/text(), $document/user/password/text())
                    
                ) else if ($document/user/password/text()) then (
                    sec:user-set-password($user-name, $document/user/password/text())
                    
                ) else (),
                
                if ($document/user/description/text()) then (
                    sec:user-set-description($user-name, $document/user/description/text())
                ) else (),

                if ($document/user/parent-role-name/*) then (
                    sec:user-set-roles($user-name, $document/user/parent-role-name/*)
                ) else (),
                
                if ($document/user/permission/*) then (
                    sec:user-set-default-permissions($user-name, $document/user/permission/*)
                ) else (),
                
                if ($document/user/collection/text()) then (
                    sec:user-set-default-collections($user-name, $document/user/collection/text())
                ) else (),
                
                if ($document/user/external-names/text()) then (
                    sec:user-set-external-names($user-name, $document/user/external-names/text())
                ) else ()
            )',
            ((xs:QName("serialized-user"), xdmp:quote($serialized-user))),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:remove-user($user-id as xs:unsignedLong) as empty-sequence() {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $user-id external;
        let $user-name := sec:get-user-names($user-id)
        return sec:remove-user($user-name)',
        (xs:QName("user-id"), $user-id),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:user-get-roles($user-name as xs:string) as xs:string* {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $user-name external;
        sec:user-get-roles($user-name)',
        (xs:QName("user-name"), $user-name),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:role-get-roles($role-name as xs:string) as xs:string* {
    xdmp:eval(
       'xquery version "1.0-ml";
        import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
        declare variable $role-name external;
        sec:role-get-roles($role-name)',
        (xs:QName("role-name"), $role-name),
        <options xmlns="xdmp:eval">
            <database>{ xdmp:security-database() }</database>
            <user-id>{ xdmp:user("admin") }</user-id>
        </options>)
};

declare function mledms-security:serialize-user-roles(
        $user-name as xs:string,
        $role-names as xs:string*) as xs:string {
    let $document := element user-roles {
        element user-name { $user-name },
        for $i in $role-names return element role-name { $i }
    }
    return xdmp:quote($document)
};

declare function mledms-security:serialize-role-roles(
        $role-name as xs:string,
        $role-names as xs:string*) as xs:string {
    let $document := element role-roles {
        element role-name { $role-name },
        for $i in $role-names return element parent-role-name { $i }
    }
    return xdmp:quote($document)
};

declare function mledms-security:user-add-roles(
   $user-name as xs:string,
   $role-names as xs:string*
) as empty-sequence() {
    let $serialized-user-roles := mledms-security:serialize-user-roles(
            $user-name,
            $role-names)
    return
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-user-roles external;
            let $document := xdmp:unquote($serialized-user-roles)
            let $user-name := $document/user-roles/user-name/text()
            let $role-names := $document/user-roles/role-name/text()
            return sec:user-add-roles($user-name, $role-names)',
            (xs:QName("serialized-user-roles"), $serialized-user-roles),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:role-add-roles(
   $role-name as xs:string,
   $role-names as xs:string*
) as empty-sequence() {
    let $serialized-role-roles := mledms-security:serialize-role-roles(
            $role-name,
            $role-names)
    return
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-role-roles external;
            let $document := xdmp:unquote($serialized-role-roles)
            let $role-name := $document/role-roles/role-name/text()
            let $role-names := $document/role-roles/parent-role-name/text()
            return sec:role-add-roles($role-name, $role-names)',
            (xs:QName("serialized-role-roles"), $serialized-role-roles),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:user-remove-roles(
   $user-name as xs:string,
   $role-names as xs:string*
) as empty-sequence() {
    let $serialized-user-roles := mledms-security:serialize-user-roles(
            $user-name,
            $role-names)
    return
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-user-roles external;
            let $document := xdmp:unquote($serialized-user-roles)
            let $user-name := $document/user-roles/user-name/text()
            let $role-names := $document/user-roles/role-name/text()
            return sec:user-remove-roles($user-name, $role-names)',
            (xs:QName("serialized-user-roles"), $serialized-user-roles),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:role-remove-roles(
   $role-name as xs:string,
   $role-names as xs:string*
) as empty-sequence() {
    let $serialized-role-roles := mledms-security:serialize-role-roles(
            $role-name,
            $role-names)
    return
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $serialized-role-roles external;
            let $document := xdmp:unquote($serialized-role-roles)
            let $role-name := $document/role-roles/role-name/text()
            let $role-names := $document/role-roles/parent-role-name/text()
            return sec:role-remove-roles($role-name, $role-names)',
            (xs:QName("serialized-role-roles"), $serialized-role-roles),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:privilege-add-role(
   $action as xs:string,
   $kind as xs:string,
   $role-names as xs:string
) as empty-sequence() {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $action external;
            declare variable $kind external;
            declare variable $role-names external;
            sec:privilege-add-roles($action, $kind, $role-names)',
           ((xs:QName("action"), $action),
            (xs:QName("kind"), $kind),
            (xs:QName("role-names"), $role-names)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:privilege-exists(
   $action as xs:string,
   $kind as xs:string
) as xs:boolean {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $action external;
            declare variable $kind external;
            sec:privilege-exists($action, $kind)',
           ((xs:QName("action"), $action),
            (xs:QName("kind"), $kind)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:create-privilege(
    $privilege-name as xs:string,
    $action as xs:string,
    $kind as xs:string,
    $role-names as xs:string
) as xs:unsignedLong {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $privilege-name external;
            declare variable $action external;
            declare variable $kind external;
            declare variable $role-names external;
            sec:create-privilege($privilege-name, $action, $kind, $role-names)',
           ((xs:QName("privilege-name"), $privilege-name),
            (xs:QName("action"), $action),
            (xs:QName("kind"), $kind),
            (xs:QName("role-names"), $role-names)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};


declare function mledms-security:role-privileges(
    $role-name as xs:string)  as element(sec:privilege)* {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $role-name external;
            sec:role-privileges($role-name)',
           ((xs:QName("role-name"), $role-name)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};

declare function mledms-security:user-privileges(
    $user-name as xs:string)  as element(sec:privilege)* {
        xdmp:eval(
           'xquery version "1.0-ml";
            import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
            declare variable $user-name external;
            sec:user-privileges($user-name)',
           ((xs:QName("user-name"), $user-name)),
            <options xmlns="xdmp:eval">
                <database>{ xdmp:security-database() }</database>
                <user-id>{ xdmp:user("admin") }</user-id>
            </options>)
};
