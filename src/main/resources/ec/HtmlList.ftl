<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title></title>
    <link rel="stylesheet" href="../plugin/layui-2.5.5/css/layui.css">
    <link rel="stylesheet" href="../css/view.css">
</head>
<body>
<div class="layui-fluid">

    <table class="layui-hide" id="table" lay-filter="table"></table>

</div>


<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="create">新建</button>
    </div>
</script>

<script type="text/html" id="bar">
    <a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
</script>


<script src="../plugin/layui-2.5.5/layui.all.js"></script>
<script src="../js/common.js"></script>
<script src="../js/view.js"></script>
<script>
    layui.use(['form','layer', 'table'], function(){
        var table = viewInfo.table = layui.table;
        var layer = viewInfo.layer = layui.layer;
        viewInfo.tableIns = table.render($.extend({
            url:ctx+'/boss/private/${page}/list-page'
            ,cols: [[
                {type:'checkbox',field:'${id}'}

                ,{field:'createTime', title:'创建时间'}
                ,{fixed: 'right', title:'操作', toolbar: '#bar',align:'center',minWidth:200}
            ]]
            ,module:'${page}'
            ,selfInitButtons:[]
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

        //监听行工具事件
        table.on('tool(table)', function(obj){
            var data = obj.data;
            var id = data.${id};
            if(obj.event === 'delete'){
                deleteData(id);
            } else if(obj.event === 'update'){
                openEdit(id);
            }
        });


        //新增或编辑
        var openEdit = function(id){
            var params = {
                title:'新增',
                type: 2,
                content:'../view/${page}-edit.html',
                maxmin: true,
                area: ['800px', '600px']
            }
            if(id){
                params.title = '编辑';
                params.success = function(layero, index){
                    var window = $(layero).find('iframe')[0].contentWindow;
                    if(window.init){
                        window.init(id);
                    }
                }
            }
            layer.open(params);
        }

        //删除
        var deleteData = function(id){
            layer.confirm('是否确认删除数据', function(index){
                var loading = layer.load(1, commonLoadingParam);
                ajaxUtil.privateAjax({
                    url: ctx+'/boss/private/${page}/delete/'+id,
                    success: function (response) {
                        console.log(response)
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

    });
</script>

</body>
</html>