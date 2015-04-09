xquery version "1.0-ml";

import module namespace mledms-utils = "https://github.com/ytsejam5/mledms/utils" at "/ytsejam5/mledms/utils/utils.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace mledms = "https://github.com/ytsejam5/mledms/mledms";

declare variable $mledms-utils:request-attribute as map:map external;


        <div xmlns="http://www.w3.org/1999/xhtml">
            <div class="col-lg-12 row">
                <h3><a href="{mledms-utils:create-command-url("admin/document/retention-rule-list", ())}">保存ルール管理</a> &gt; 保存ルール登録</h3>
                <hr/>
            </div>
        
            <div class="col-lg-3 left-pane">
            
            </div>
            <div class="col-lg-9 right-pane">
                <form class="form-horizontal" method="post" action="{mledms-utils:create-command-url("admin/document/retention-rule-create", ())}">

                    <fieldset>
                        <legend>保存ルール</legend>
 
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">名前</label>
                            <div class="col-sm-9">
                                <input type="text" name="name" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">説明</label>
                            <div class="col-sm-9">
                                <input type="text" name="comment" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">保持バージョン数</label>
                            <div class="col-sm-3">
                                <input type="text" name="num-versions" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">保持期間</label>
                            <div class="col-sm-3">
                                <input type="text" name="duration" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">合致条件</label>
                            <div class="col-sm-9">
                                <input type="text" name="document-query" class="form-control" value="" placeholder="検索クエリを指定"/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <label class="col-sm-3 control-label">合致条件の説明</label>
                            <div class="col-sm-9">
                                <input type="text" name="document-query-text" class="form-control" value="" placeholder=""/>
                            </div>
                        </div>
                    </fieldset>

                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-9 text-right">
                            <button type="submit" class="btn btn-default">登録</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>