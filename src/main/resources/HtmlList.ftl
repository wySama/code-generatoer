${r"<#include "}"../inc/common-top.ftl"${r">"}
<!DOCTYPE html>
<html>
    <head>
        ${r"<#include "}"../inc/view-common-head.ftl"${r">"}
    </head>
    <body>
        <div class="layui-fluid">
            ${r"<#if"} hasPermission("/views/${controllerMapping}:search") ${r">"}
            <form class="layui-form" action="" id="searchForm">
                <div class="layui-form-item">
                    <div class="layui-input-inline">
                        <input type="text" id="${id}" name="${id}"  lay-verify="" placeholder="主键" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-input-inline">
                        <button type="button" class="layui-btn" id="search">查询</button>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="table" lay-filter="table"></table>
            ${r"<#else >"}
                ${r"${noSearchPermission}"}
            ${r"</#if>"}
        </div>


        <script type="text/html" id="toolbar">
            <div class="layui-btn-container">
                ${r"<#if"} hasPermission("/views/${controllerMapping}:add") ${r">"}
                <button class="layui-btn layui-btn-sm" lay-event="create">新建</button>
                ${r"</#if>"}
            </div>
        </script>

        <script type="text/html" id="bar">
            ${r"<#if"} hasPermission("/views/${controllerMapping}:edit") ${r">"}
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
            ${r"</#if>"}
            ${r"<#if"} hasPermission("/views/${controllerMapping}:delete") ${r">"}
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
            ${r"</#if>"}
        </script>


        ${r"<#include "}"../inc/view-common-body.ftl"${r">"}
        <script src="${r"${base}"}/static/js/view.js"></script>
        <script >
            layui.use(['form','layer', 'table'], function(){
                var table = viewInfo.table = layui.table;
                var layer = viewInfo.layer = layui.layer;
                viewInfo.tableIns = table.render($.extend({
                    url:ctx+'/${controllerMapping}/list-page'
                    ,cols: [[
                        {type: 'checkbox', field:'${id}',fixed: 'left'}
                        ,{field:'createTime', title:'创建时间'}
                        ,{fixed: 'right', title:'操作', toolbar: '#bar',align:'center'}
                    ]]
                },baseRenderParams));

                //头工具栏事件
                table.on('toolbar(table)', function(obj){
                    var checkStatus = table.checkStatus(obj.config.id);
                    switch(obj.event){
                        case 'getCheckData':
                            var data = checkStatus.data;
                            layer.alert(JSON.stringify(data));
                            break;
                        case 'getCheckLength':
                            var data = checkStatus.data;
                            layer.msg('选中了：'+ data.length + ' 个');
                            break;
                        case 'isAll':
                            layer.msg(checkStatus.isAll ? '全选': '未全选');
                            break;
                        case 'create':
                            openEdit();
                            break;
                    };
                });

                var openEdit = function(id){
                    var params = {
                        title:'新建',
                        type: 2,
                        content: ctx+'/views/${controllerMapping}Edit',
                        maxmin: true,
                        area: ['800px', '600px']
                    }
                    if(id){
                        params.success = function(layero, index){
                            var window = $(layero).find('iframe')[0].contentWindow;
                            if(window.init){
                                window.init(id);
                            }
                        }
                    }
                    layer.open(params);
                }

                var deleteData = function(id){
                    layer.confirm('是否确认删除数据', function(index){
                        var loading = layer.load(1, commonLoadingParam);
                        $.ajax({
                            url: ctx+'/${controllerMapping}/deleteById',
                            dataType: 'json',
                            type: 'post',
                            data:{id:id},
                            success: function (response) {
                                if (response.status == "0"){
                                    layer.close(loading);
                                    layer.msg('删除成功,刷新中');
                                    search();
                                } else{
                                    layer.close(loading);
                                    layer.alert('删除失败,'+response.msg, function(index){
                                        layer.close(index);
                                    });
                                }
                            }
                        })

                    });
                }


                //监听行工具事件
                table.on('tool(table)', function(obj){
                    var data = obj.data;
                    if(obj.event === 'del'){
                        deleteData(data.${id});
                    } else if(obj.event === 'edit'){
                        openEdit(data.${id});
                    }
                });


            });
        </script>

    </body>
</html>