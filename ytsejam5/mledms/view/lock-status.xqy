xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace lock = "http://marklogic.com/xdmp/lock";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $lock := map:get($mledms-utils:request-attribute, "lock")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>データ詳細 <small>{$document-uri}</small></h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
{
    mledms-utils:import-viewpart("/parts/document-menu.xqy", $mledms-utils:request-attribute)
}
            </div>
            <div class="col-lg-9 right-pane">
                <fieldset>
                    <legend>ロックステータス</legend>
{
    if ($lock) then (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">ステータス</label>
                        <div class="col-sm-9">ロック中</div>
                    </div>,
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">lock:lock-type</label>
                        <div class="col-sm-9">{$lock/lock:lock/lock:lock-type/text()}</div>
                    </div>,
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">lock:lock-scope</label>
                        <div class="col-sm-9">{$lock/lock:lock/lock:lock-scope/text()}</div>
                    </div>,
        for $active-lock at $pos in $lock/lock:lock/lock:active-locks/*
        return (
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <label class="col-sm-3 control-label">現在のロック</label>
                                <div class="col-sm-9 text-right">
                                    <a class="btn btn-default" data-toggle="collapse" href="#lock{ $pos }" aria-expanded="false" aria-controls="lock{ $pos }">詳細</a>
                                </div>
                            </div>
                        </div>
                        <div id="lock{ $pos }" class="collapse panel-body">
            {
                for $i in $active-lock/*
                return (
                            <div class="row">
                                <label class="col-sm-3 control-label text-right">{ fn:string($i/name()) }</label>
                                <div class="col-sm-9">{ fn:string($i/text()) }</div>
                            </div>)
            }
                        </div>
                    </div>)
    ) else (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">ステータス</label>
                        <div class="col-sm-9">ロックなし</div>
                    </div>
    )
}
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
{
    if ($lock) then (
                            <a href="#" class="btn btn-default disabled" role="button">ロック</a>,
                            <span> | </span>,
                            <a href="{mledms-utils:create-command-url("lock-release", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">ロック解除</a>
    ) else (
                            <a href="{mledms-utils:create-command-url("lock", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">ロック</a>,
                            <span> | </span>,
                            <a href="#" class="btn btn-default disabled" role="button">ロック解除</a>
    )
} 
                        </div>
                    </div>
                </fieldset>
                <br/>
            </div>
        </div>