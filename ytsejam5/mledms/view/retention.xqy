xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $directory := map:get($mledms-utils:request-attribute, "directory")
let $collections := map:get($mledms-utils:request-attribute, "collections")

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
                    <div class="row">
                        <label class="col-sm-3 control-label">Document URI</label>
                        <div class="col-sm-9">{ $document-uri }</div>
                    </div>
 
                    <div class="row">
                        <label class="col-sm-3 control-label">コレクション</label>
                        <div class="col-sm-9">{ fn:string-join($collections, ", ") }</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <a href="{mledms-utils:create-command-url("download", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">ダウンロード</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("update-form", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">更新</a>
                            <span> | </span>
                            <a href="{mledms-utils:create-command-url("delete", <params><param name="document-uri">{$document-uri}</param></params>)}" class="btn btn-default" role="button">削除</a>
                        </div>
                    </div>
                </fieldset>
                <br/>
            </div>
        </div>