xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledml/mledms";

declare variable $mledms-utils:request-attribute as map:map external;

let $form-type := map:get($mledms-utils:request-attribute, "form-type")
let $user-id := map:get($mledms-utils:request-attribute, "user-id")
let $user := map:get($mledms-utils:request-attribute, "user")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>
{
    if ($form-type eq "admin/security/user-create") then "ユーザ登録"
    else if ($form-type eq "admin/security/user-update") then ("ユーザ更新 ", <small>{ $user/mledms:user/mledms:user-name/text() }</small>)
    else ""
}
                </h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane"></div>
            <div class="col-lg-9 right-pane">
                <form class="form-horizontal" method="post" action="{mledms-utils:create-command-url($form-type, ())}">
                    <input type="hidden" name="user-id" value="{ $user-id }"/>
                    <fieldset>
                        <legend>基本情報</legend>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">ユーザ名</label>
                            <div class="col-sm-9">
                                <input type="text" name="user-name" class="form-control" value="{ $user/mledms:user/mledms:user-name/text() }" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">説明</label>
                            <div class="col-sm-9">
                                <input type="text" name="description" class="form-control" value="{ $user/mledms:user/mledms:description/text() }" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">パスワード</label>
                            <div class="col-sm-9">
                                <input type="password" name="password" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">パスワード(再入力)</label>
                            <div class="col-sm-9">
                                <input type="password" name="password-confirm" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                    </fieldset>
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <button type="submit" class="btn btn-default">
{
    if ($form-type eq "admin/security/user-create") then "登録"
    else if ($form-type eq "admin/security/user-update") then "更新 "
    else ""
}
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>