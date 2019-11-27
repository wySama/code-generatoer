package ${package}.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import ${package}.dto.${po}DTO;
import ${package}.po.${po};
import ${package}.po.${po}Example;
import ${package}.mapper.${po}Mapper;
import ${package}.util.CommonUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

@Service
public class ${po}Service {



    <#assign mapper = prefixPo + "Mapper">
    <#assign example = prefixPo + "Example">
    <#assign Example = po + "Example">
    @Autowired
    ${po}Mapper ${mapper};


    public String insertSelective(${po} record,String userId){
        String id = CommonUtil.get32UUID();
        record.set${ID}(id);
        record.setCreateTime(CommonUtil.getCurrentTime());
        record.setCreateUser(userId);
        record.setDelFlag("0");
        ${mapper}.insertSelective(record);
        return id;
    }


    public void logicalDeleteByPrimaryKey(String id,String userId){
        ${po} record = new ${po}();
        record.setDelFlag("1");
        record.setDeleteTime(CommonUtil.getCurrentTime());
        record.setDeleteUser(userId);
        ${po}Example example = new ${po}Example();
        example.createCriteria().and${ID}EqualTo(id);

        updateByExampleSelective(record,example,userId);
    }

    public int updateByExampleSelective(${po} record, ${po}Example example,String userId){
        record.setUpdateTime(CommonUtil.getCurrentTime());
        record.setUpdateUser(userId);
        return ${mapper}.updateByExampleSelective(record,example);
    }

    public int updateByPrimaryKeySelective(${po} record,String userId){
        record.setUpdateTime(CommonUtil.getCurrentTime());
        record.setUpdateUser(userId);
        return ${mapper}.updateByPrimaryKeySelective(record);
    }

    public PageInfo<${po}> selectPageByDTO(${po}DTO params){
        int pageSize = params.getPageSize()==0 ? 20 : params.getPageSize();
        PageHelper.startPage(params.getPageNum(), pageSize);
        List<${po}> list = selectByDTO(params);
        PageInfo<${po}> pageInfo = new PageInfo<>(list);
        return pageInfo;
    }

    public List<${po}> selectByDTO(${po}DTO params){
        ${Example} example = prepareExample(params);
        List<${po}> list = ${mapper}.selectByExample(example);
        return list;
    }

    public ${po} selectByPrimaryKey(String id){
        return ${mapper}.selectByPrimaryKey(id);
    }

    /**
    * 准备搜索条件
    * @param params
    * @return
    */
    public ${Example} prepareExample(${po}DTO params){
        ${Example} example = new ${Example}();
        ${Example}.Criteria criteria = example.createCriteria();
        criteria.andDelFlagEqualTo("0");
        if (StringUtils.isNotEmpty(params.get${ID}())){
            criteria.and${ID}EqualTo(params.get${ID}());
        }
<#--        if (StringUtils.isNotEmpty(params.getCreateTimeFrom())){-->
<#--            criteria.andCreateTimeGreaterThanOrEqualTo(params.getCreateTimeFrom());-->
<#--        }-->
<#--        if (StringUtils.isNotEmpty(params.getCreateTimeTo())){-->
<#--            criteria.andCreateTimeLessThanOrEqualTo(params.getCreateTimeTo());-->
<#--        }-->
<#--        if (StringUtils.isNotEmpty(params.getUpdateTimeFrom())){-->
<#--            criteria.andUpdateTimeGreaterThanOrEqualTo(params.getUpdateTimeFrom());-->
<#--        }-->
<#--        if (StringUtils.isNotEmpty(params.getUpdateTimeTo())){-->
<#--            criteria.andUpdateTimeLessThanOrEqualTo(params.getUpdateTimeTo());-->
<#--        }-->
        return example;
    }
}
