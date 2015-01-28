xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledml/utils" at "/ytsejam5/mledms/utils/utils.xqy";

declare variable $mledms-utils:request-attribute as map:map external;

let $document-uri := map:get($mledms-utils:request-attribute, "document-uri")
let $document := map:get($mledms-utils:request-attribute, "document")
let $directory := map:get($mledms-utils:request-attribute, "directory")
let $collections := map:get($mledms-utils:request-attribute, "collections")
let $weight := map:get($mledms-utils:request-attribute, "weight")

let $form-type := map:get($mledms-utils:request-attribute, "form-type")

return
        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3>{if ($form-type eq "create") then 
                        ("データ登録")
                     else if ($form-type eq "update") then
                        ("データ更新 ", <small>{ $document-uri }</small>)
                     else if ($form-type eq "checkin") then
                        ("データチェックイン ", <small>{ $document-uri }</small>) else ""  }</h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane"></div>
            <div class="col-lg-9 right-pane">
                <form class="form-horizontal" enctype="multipart/form-data" method="post" action="{mledms-utils:create-command-url($form-type, ())}">
 { if (fn:not(fn:matches($document-uri, "^\s*$"))) then (
                    <input type="hidden" name="document-uri" class="form-control" value="{ $document-uri }"/>
) else () }
                    <fieldset>
                        <legend>基本情報</legend>
                        <div class="row">
                            <label class="col-sm-3 control-label">リソース</label>
                            <div class="col-sm-9">
                                <div class="row form-group">
                                    <div class="col-sm-3 text-right">
                                        <label>
                                            URL・パスを指定 <input type="radio" name="resource-type" id="resource-type-url" value="url" />
                                        </label>
                                    </div>
                                    <div class="col-sm-9">
                                        <div class="input-group">
                                            <input type="text" name="resource-url" id="file" class="form-control" placeholder="URL" onfocus="getElementById('resource-type-url').checked=true"/>
                                            <span class="input-group-addon"><input type="checkbox" name="" value="url" checked="true" disabled="true" /> 取り込む</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row form-group">
                                    <div class="col-sm-3 text-right">
                                        <label>
                                           アップロード <input type="radio" name="resource-type" id="resource-type-upload" value="upload" checked="true"/>
                                        </label>
                                    </div>
                                    <div class="col-sm-9">
                                        <input type="file" name="upload-file" id="upload-file" onfocus="getElementById('resource-type-upload').checked=true"/>
                                    </div>
                                </div>
 {  if (fn:not($form-type eq "create")) then (
                                <div class="row form-group text-right">
                                    <div class="col-sm-3">
                                        <label>
                                            上書きしない <input type="radio" name="resource-type" id="resource-type-none" value="" checked="true"/>
                                        </label>
                                    </div>
                                    <div class="col-sm-9">
                                    </div>
                                </div>                            
    ) else ()  }
                            </div>
                        </div>
 {  if ($form-type eq "create") then (
                         <div class="row form-group">
                            <label class="col-sm-3 control-label">ID体系</label>
                            <div class="col-sm-9">
                                <select class="form-control" name="id-type">
                                    <option value="file-name">ファイル名を利用</option>
                                    <option value="guid">GUIDを生成</option>
                                    <option disabled="true">ISMS文書体系に準拠</option>
                                    <option disabled="true">ISO14001文書体系に準拠</option>
                                </select>
                            </div>
                        </div>,
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">ディレクトリ</label>
                            <div class="col-sm-9">
                                <input type="text" name="directory" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
    ) else (
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">ディレクトリ</label>
                            <div class="col-sm-9">
                                <input type="text" name="directory" class="form-control" value="{ $directory }" placeholder="" readonly="true"/>
                            </div>
                        </div>
    )  }
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">コレクション</label>
                            <div class="col-sm-9">
                                <input type="text" name="collection" class="form-control" value="{ fn:string-join($collections, ", ") }" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">重み</label>
                            <div class="col-sm-3">
                                <input type="text" name="weight" class="form-control text-right" value="{ $weight }" placeholder=""/>
                            </div>
                        </div>
                    </fieldset>
 {  if ($form-type eq "checkin") then (
                     <br/>,
                     <fieldset>
                        <legend>バージョン管理情報</legend>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">コメント</label>
                            <div class="col-sm-9">
                                <textarea name="comment" class="form-control" placeholder="コメント" rows="3"></textarea>
                            </div>
                        </div>
                    </fieldset>                
    ) else ()  }
                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <button type="submit" class="btn btn-default">{if ($form-type eq "create") then 
                        ("登録")
                     else if ($form-type eq "update") then
                        ("更新 ")
                     else if ($form-type eq "checkin") then
                        ("チェックイン") else ""  }</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>