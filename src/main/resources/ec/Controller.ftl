package ${package}.controller;

import ${package}.dto.${po}DTO;
import ${package}.passportInterface.BossPassport;
import ${package}.po.*;
import ${package}.service.${po}Service;
import ${package}.model.APIResponse;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;


@RestController
@RequestMapping("${controllerMapping}")
public class ${po}Controller {

    <#assign Example = po +"Example">
    <#assign service = prefixPo +"Service">

    @Autowired
    private ${po}Service ${service};


    /**
    * 创建
    * @param params
    * @return
    */
    @PostMapping(value = "create")
    @BossPassport(uri="${page}:create")
    public APIResponse<String> create(@RequestBody ${po} params,HttpServletRequest request) {
        SysUser customerInfo = (SysUser) request.getAttribute("customerInfo");
        APIResponse<String> apiResponse = new APIResponse<>();
        apiResponse.setSuccess(${service}.insertSelective(params,customerInfo.getUserId()));
        return apiResponse;
    }

    /**
    * 删除
    * @param id
    * @return
    */
    @PostMapping(value = "/delete/{id}")
    @BossPassport(uri="${page}:delete")
    public APIResponse<String> deleteById(@PathVariable  String id,HttpServletRequest request) {
        SysUser customerInfo = (SysUser) request.getAttribute("customerInfo");
        APIResponse<String> apiResponse = new APIResponse<>();
        ${service}.logicalDeleteByPrimaryKey(id,customerInfo.getUserId());
        apiResponse.setSuccess(id);
        return apiResponse;
    }

    /**
    * 单条更新
    * @param params
    * @return
    */
    @PostMapping(value = "/update")
    @BossPassport(uri="${page}:update")
    public APIResponse<Integer> update(@RequestBody ${po} params,HttpServletRequest request) {
        SysUser customerInfo = (SysUser) request.getAttribute("customerInfo");
        APIResponse<Integer> apiResponse = new APIResponse<>();
        if(StringUtils.isEmpty(params.get${ID}())){
            apiResponse.setFailed("1","主键不能为空");
            return apiResponse;
        }
        int i  = ${service}.updateByPrimaryKeySelective(params,customerInfo.getUserId());
        apiResponse.setSuccess(i);
        return apiResponse;
    }

    /**
    * 单条搜索
    * @param id
    * @return
    */
    @PostMapping(value = "/search/{id}")
    @BossPassport(uri="${page}:search")
    public APIResponse<${po}> searchById(@PathVariable  String id) {
        APIResponse<${po}> apiResponse = new APIResponse<>();
        ${po} result = ${service}.selectByPrimaryKey(id);
        apiResponse.setSuccess(result);
        return apiResponse;
    }

    /**
    * 分页查询
    * @param params
    * @return
    */
    @PostMapping(value = "/list-page")
    @BossPassport(uri="${page}:search")
    public APIResponse<PageInfo<${po}>> listPage(@RequestBody ${po}DTO params) {
        APIResponse<PageInfo<${po}>> apiResponse = new APIResponse<>();
        apiResponse.setSuccess(${service}.selectPageByDTO(params));
        return apiResponse;
    }


}
