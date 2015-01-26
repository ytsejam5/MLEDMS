xquery version "1.0-ml";

import module namespace dls = "http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";
import module namespace mledms-security = "https://github.com/ytsejam5/mledml/security" at "/ytsejam5/mledms/utils/security.xqy";
import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $is-managed := map:get($mledms-utils:request-attribute, "is-managed")
let $checkout-status := map:get($mledms-utils:request-attribute, "checkout-status")
let $document-history := map:get($mledms-utils:request-attribute, "document-history")

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
                    <legend>バージョン情報</legend>
{
    if ($is-managed) then (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">バージョン管理</label>
                        <div class="col-sm-9">有効</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="#" class="btn btn-default disabled" role="button">有効にする</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("unmanage", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">無効にする</a>
                         </div>
                    </div>
    ) else (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">バージョン管理</label>
                        <div class="col-sm-9">無効</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("manage", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">有効にする</a>
                            <span> | </span>
                            <a href="#" class="btn btn-default disabled" role="button">無効にする</a>
                        </div>
                    </div>
    )
}
                </fieldset>
                <br/>
{
    if ($is-managed) then (
                <fieldset>
                    <legend>チェックアウトステータス</legend>
        {
            if ($checkout-status) then (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">チェックアウト状態</label>
                        <div class="col-sm-9">チェックアウト中</div>
                    </div>,
                    
                for $i in $checkout-status/*
                return (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">{ fn:string($i/name()) }</label>
                        <div class="col-sm-9">{ fn:string($i/text()) }</div>
                    </div>),
                    <div class="row">
                        <div class="col-sm-12 text-right">
                            <a href="{mledms-utils:create-command-url("checkin-form", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">チェックイン</a>
                            <span> | </span>
                            <a href="#" class="btn btn-default disabled" role="button">チェックアウト</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("break-checkout", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">チェックアウト取り消し</a>
                        </div>
                    </div>
            ) else (
                    <div class="row">
                        <label class="col-sm-3 control-label text-right">チェックアウト状態</label>
                        <div class="col-sm-9">未チェックアウト</div>
                    </div>,
                    <div class="row">
                        <div class="col-sm-12 text-right">
                            <a href="#" class="btn btn-default disabled" role="button">チェックイン</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("checkout", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">チェックアウト</a>
                            <span> | </span>
                            <a href="#" class="btn btn-default disabled" role="button">チェックアウト取り消し</a>
                        </div>
                    </div>
            )
        }
                </fieldset>,
                <br/>,
                <fieldset>
                    <legend>バージョン履歴</legend>
        {
            for $version in $document-history/*
            order by $version/dls:version-id descending
            return (
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <label class="col-sm-3 control-label text-right">Version#{ $version/dls:version-id }</label>
                                <div class="col-sm-5">
                                    <div class="row">ユーザ:{ mledms-security:get-user-name(xs:unsignedLong($version/dls:author/text())) }, コメント:{ $version/dls:annotation/text() }</div>                         
                                </div>
                                <div class="col-sm-4 text-right">
                                    <a class="btn btn-default" data-toggle="collapse" href="#version{ $version/dls:version-id }" aria-expanded="false" aria-controls="version{ $version/dls:version-id }">詳細</a> |
                                    <a href="{mledms-utils:create-command-url("version-download", <params><param name="document-uri">{$document-uri}</param><param name="version">{$version/dls:version-id/text()}</param></params>)}" class="btn btn-default" role="button">ダウンロード</a> |
                                    <a href="{mledms-utils:create-command-url("version-delete", <params><param name="document-uri">{$document-uri}</param><param name="version">{$version/dls:version-id/text()}</param></params>)}" class="btn btn-default" role="button">削除</a>
                                </div>
                            </div>
                        </div>
                        <div id="version{ $version/dls:version-id }" class="collapse panel-body">
                {
                for $i in $version/*
                return (
                            <div class="row">
                                <label class="col-sm-3 control-label text-right">{ fn:string($i/name()) }</label>
                                <div class="col-sm-9">{ fn:string($i/text()) }</div>
                            </div>)
                }
                        </div>
                    </div>
            )
        }
                    <div class="row">
                        <div class="col-sm-12 text-right">
                            <a href="{mledms-utils:create-command-url("versions-purge", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">全バージョン削除</a>
                        </div>
                    </div> 
                </fieldset>,
                <br/>
    ) else ()
}
               </div>
        </div>