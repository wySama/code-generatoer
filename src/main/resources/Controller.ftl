package ${package}.controller;

import ${package}.mapper.${name}Mapper;
import cn.com.artlife.archiveCenterSDK.model.*;
import cn.com.artlife.archiveCenterSDK.util.CommonUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@RequestMapping("${controllerMapping}")
public class ${name}Controller {

    @Autowired
    <#assign mapper = controllerMapping +"Mapper">
    <#assign Example = name +"Example">
    private ${name}Mapper ${controllerMapping}Mapper;

    @PostMapping(value = "/list")
    public CommonResponse list(@RequestBody ${name} params) {
        CommonResponse commonResponse = new CommonResponse();
        List<${name}> list = ${mapper}.selectByExample(prepareExample(params));
        commonResponse.setSuccess(list);
        return commonResponse;
    }

    @PostMapping(value = "/list-page")
    public CommonResponse listPage(@RequestBody ${name} params) {
        CommonResponse commonResponse = new CommonResponse();
        int pageSize = params.getPageSize()==0 ? 20 : params.getPageSize();
        PageHelper.startPage(params.getPageNum(), pageSize);
        List<${name}> list = ${mapper}.selectByExample(prepareExample(params));
        PageInfo<${name}> pageInfo = new PageInfo<>(list);
        commonResponse.setSuccess(pageInfo);
        return commonResponse;
    }

    public ${Example} prepareExample(${name} params){
        ${Example} example = new ${Example}();
        ${Example}.Criteria criteria = example.createCriteria();
        //添加搜索条件
        if (StringUtils.isNotEmpty(params.get${ID}())){
            criteria.and${ID}EqualTo(params.get${ID}());
        }
        return example;
    }

    @RequestMapping(value = "/create")
    public CommonResponse create(@RequestBody ${name} params) {
        CommonResponse commonResponse = new CommonResponse();
        params.set${ID}(CommonUtil.get32UUID());
        params.setCreateTime(CommonUtil.getCurrentTime());
        ${mapper}.insertSelective(params);
        commonResponse.setSuccess();
        return commonResponse;
    }

    @RequestMapping(value = "/deleteById")
    public CommonResponse deleteById(@RequestBody String id) {
        CommonResponse commonResponse = new CommonResponse();
        ${mapper}.deleteByPrimaryKey(id);
        commonResponse.setSuccess();
        return commonResponse;
    }

    @RequestMapping(value = "/update")
    public CommonResponse update(@RequestBody ${name} params) {
        CommonResponse commonResponse = new CommonResponse();
        params.setUpdateTime(CommonUtil.getCurrentTime());
        ${mapper}.updateByPrimaryKeySelective(params);
        commonResponse.setSuccess();
        return commonResponse;
    }

    @RequestMapping(value = "/searchById")
    public CommonResponse searchById(@RequestBody String id) {
        CommonResponse commonResponse = new CommonResponse();
        ${name} result = ${mapper}.selectByPrimaryKey(id);
        commonResponse.setSuccess(result);
        return commonResponse;
    }
}
