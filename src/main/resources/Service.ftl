package cn.com.artlife.archiveCenterSDK.service;

import cn.com.artlife.archiveCenterSDK.model.*;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@FeignClient("zuul")
public interface ${name}Service {

    @RequestMapping("api/ac-manage/${controllerMapping}/list")
    CommonResponse list(@RequestBody ${name} params);

    @RequestMapping(value = "api/ac-manage/${controllerMapping}/list-page")
    CommonResponse listPage(@RequestBody ${name} params);

    @RequestMapping("api/ac-manage/${controllerMapping}/searchById")
    CommonResponse searchById(@RequestBody String id);

    @RequestMapping("api/ac-manage/${controllerMapping}/create")
    CommonResponse create(@RequestBody ${name} params);

    @RequestMapping("api/ac-manage/${controllerMapping}/deleteById")
    CommonResponse deleteById(@RequestBody String id);

    @RequestMapping("api/ac-manage/${controllerMapping}/update")
    CommonResponse update(@RequestBody ${name} params);
}
