${r"<#include "}"../inc/common-top.ftl"${r">"}
<!DOCTYPE html>
<html>
    <head>
        ${r"<#include "}"../inc/view-common-head.ftl"${r">"}
    </head>
    <body>
        <div class="layui-fluid">
            <form class="layui-form" action="" method="post">
                <div class="layui-form-item">
                    <label class="layui-form-label">主键</label>
                    <div class="layui-input-block">
                        <input type="text" id="${id}" name="${id}" required  lay-verify="required" placeholder="主键" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
                    </div>
                </div>
            </form>
        </div>

        ${r"<#include "}"../inc/view-common-body.ftl"${r">"}
        <script src="${r"${base}"}/static/js/view.js"></script>
        <script >
            var init = function(id){
                $.ajax({
                    url: ctx+'/${controllerMapping}/searchById',
                    dataType: 'json',
                    type: 'post',
                    data:{id:id},
                    success: function (response) {
                        console.log(response)
                        if (response.status == "0"){
                            var data = response.data;
                            for (var prop in data)
                            {
                                $('#'+prop).val(data[prop]);
                            }
                        } else{
                            var selfIndex = parent.layer.getFrameIndex(window.name); //获取窗口索引
                            if(parent.searchByIdCallBack){
                                parent.searchByIdCallBack();
                            }
                            parent.layer.close(selfIndex);//关闭窗口
                        }
                    }
                })
            }

            layui.use(['form','layer'], function(){
                var form = layui.form;
                var layer = layui.layer;
                //监听提交
                form.on('submit(formDemo)', function(data){
                    var loading = layer.load(1,commonLoadingParam);
                    var id = $('#${id}').val();
                    var url = ctx+'/${controllerMapping}/create';
                    if(id != ''){
                        url = ctx+'/${controllerMapping}/update';
                    }
                    $.ajax({
                        url: url,
                        dataType: 'json',
                        type: 'post',
                        data:data.field,
                        success: function (response) {
                            if (response.status == "0"){
                                var selfIndex = parent.layer.getFrameIndex(window.name); //获取窗口索引
                                if(parent.createCallBack){
                                    parent.createCallBack();
                                }
                                parent.layer.close(selfIndex);//关闭窗口
                                layui.form.render();
                            } else{
                                layer.close(loading);
                                layer.alert('保存失败,'+response.msg, function(index){
                                    layer.close(index);
                                });
                            }
                        }
                    })
                    return false;
                });
            });
        </script>

    </body>
</html>
