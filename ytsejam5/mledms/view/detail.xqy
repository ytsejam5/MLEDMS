xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $directory := map:get($mledms-utils:request-attribute, "directory")
let $collections := map:get($mledms-utils:request-attribute, "collections")
let $properties := map:get($mledms-utils:request-attribute, "properties")
let $weight := map:get($mledms-utils:request-attribute, "weight")

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
                    <legend>基本情報</legend>
                    <div class="row form-group">
{
    if (fn:starts-with(fn:string($properties/*:properties/*:html/*:head/*:meta[@name eq "content-type"]/@content), "image/")) then (
                        <label class="col-sm-3 control-label text-right">サムネイル</label>,
                        <div class="col-sm-9">
                            <img src="{mledms-utils:create-command-url("display-image", <params><param name="document-uri">{$document-uri}</param></params>)}" class="thumbnail"/>
                        </div>
    ) else (
                        <label class="col-sm-3 control-label text-right">内容</label>,
                        <div class="col-sm-9">
                            <div>最初の10KBまで表示</div>
                            <textarea class="form-control" rows="10">{
                                let $content := fn:string($properties/*:properties/*:html/*:body)
                                return
                                    fn:substring($content, 1, fn:min((10240, fn:string-length($content)))) }</textarea>
                        </div>
    )
}
                    </div>
                    <div class="row form-group">
                        <label class="col-sm-3 control-label text-right">コレクション</label>
                        <div class="col-sm-9">{ fn:string-join($collections, ", ") }</div>
                    </div>
                    <div class="row form-group">
                        <label class="col-sm-3 control-label text-right">重み</label>
                        <div class="col-sm-9">{ $weight }</div>
                    </div>
                    <div class="row">
{
    if ($lock) then (
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("download", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">ダウンロード</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("update-form", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button" disabled="true">更新</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("delete", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button" disabled="true">削除</a>
                        </div>
    ) else (
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("download", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">ダウンロード</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("update-form", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">更新</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("delete", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">削除</a>
                          </div>
    )
}
                    </div>
                </fieldset>
                <br/>
            </div>
        </div>