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
    <form class="layui-form">

        <input type="hidden" id="${id}" name="${id}">


        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
            </div>
        </div>

    </form>
</div>
<script src="../plugin/layui-2.5.5/layui.all.js"></script>
<script src="../js/common.js"></script>
<script src="../js/view.js"></script>
<script>
    var init = function(id){
        if(id){ //查询编辑页面数据
            ajaxUtil.privateAjax({
                url: ctx+'/boss/private/${page}/search/'+id,
                success: function (response) {
                    if (response.status == "0"){
                        var data = response.data;
                        for (var prop in data)
                        {
                            $('#'+prop).val(data[prop]);
                        }
                        //单选框
                        $('[name=type]').each(function(i,item){
                            if($(item).val() == data.type){
                                $(item).prop('checked',true);
                            }
                        });
                        layui.form.render("radio");
                    } else{
                        var selfIndex = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        if(parent.searchByIdCallBack){
                            parent.searchByIdCallBack();
                        }
                        parent.layer.close(selfIndex);//关闭窗口
                    }
                }
            });
        }

    }

    layui.use(['form','layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        //监听提交
        form.on('submit(formDemo)', function(data){
            var loading = layer.load(1, {
                shade: [0.3,'#333'] //
            });
            var dataId = $('#${id}').val();
            var url = ctx+'/boss/private/${page}/create';
            if(dataId){
                url = ctx+'/boss/private/${page}/update';
            }
            ajaxUtil.privateAjax({
                url: url,
                data:data.field,
                success: function (response) {
                    if (response.status == "0"){
                        var selfIndex = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        if(parent.createCallBack){
                            parent.createCallBack();
                        }
                        parent.layer.close(selfIndex);//关闭窗口

                    } else{
                        layer.close(loading);
                        layer.alert('保存失败,'+response.msg, function(index){
                            layer.close(index);
                        });
                    }
                }
            });
            return false;
        });
    });

</script>
</body>
</html>