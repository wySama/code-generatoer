package com.mo.ec.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mo.ec.model.APIResponse;
import com.mo.ec.model.SysPermissionVO;
import com.mo.ec.model.TreeNode;
import com.mo.ec.po.SysPermission;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class SysUtil {


    public static ArrayList<SysPermissionVO> convertSysPermissionVO(List<SysPermission> list){
        ArrayList<SysPermissionVO> all = new ArrayList<>();
        list.forEach(sysPermission -> {
            SysPermissionVO vo = new SysPermissionVO();
            try {
                CommonUtil.cpoyObjAttr(sysPermission,vo,SysPermission.class);
            } catch (Exception e) {
            }
            all.add(vo);
        });
        return all;
    }
    /**
     * 准备权限树
     * @param list
     * @return
     */
    public static ArrayList<SysPermissionVO> preparePermissionTree(List<SysPermission> list){
        ArrayList<SysPermissionVO> tree = new ArrayList<>();
        ArrayList<SysPermissionVO> all = convertSysPermissionVO(list);
        all.forEach(vo -> {
            if(StringUtils.isEmpty(vo.getParentId())){
                tree.add(prepareChild(vo,all));
            }
        });
        SysPermissionSortByOrder sysPermissionSortByOrder = new SysPermissionSortByOrder();
        Collections.sort(tree,sysPermissionSortByOrder);
        return tree;
    }

    /**
     * 准备权限树
     * @param all
     * @return
     */
    public static ArrayList<SysPermissionVO> preparePermissionTreeByVO(List<SysPermissionVO> all){
        ArrayList<SysPermissionVO> tree = new ArrayList<>();
        all.forEach(vo -> {
            if(StringUtils.isEmpty(vo.getParentId())){
                tree.add(prepareChild(vo,all));
            }
        });
        SysPermissionSortByOrder sysPermissionSortByOrder = new SysPermissionSortByOrder();
        Collections.sort(tree,sysPermissionSortByOrder);
        return tree;
    }


    /**
     * 根据父级权限，设置子集权限
     * @param parent
     * @param all
     * @return
     */
    public static SysPermissionVO prepareChild(SysPermissionVO parent,List<SysPermissionVO> all){
        ArrayList<SysPermissionVO> childs = new ArrayList<>();
        String parentId = parent.getPermissionId();
        all.forEach(child->{
            if(parentId.equals(child.getParentId())){
                childs.add(child);
            }
        });
        if(childs.size() > 0){
            childs.forEach(child->{
                prepareChild(child,all);
            });
        }
        SysPermissionSortByOrder sysPermissionSortByOrder = new SysPermissionSortByOrder();
        Collections.sort(childs,sysPermissionSortByOrder);
        parent.setChilds(childs);
        return parent;
    }

    /**
     * 权限排序算法
     */
    static class SysPermissionSortByOrder implements Comparator {

        @Override
        public int compare(Object o1, Object o2) {
            SysPermission s1 = (SysPermission) o1;
            SysPermission s2 = (SysPermission) o2;
            return s1.getOrders().compareTo(s2.getOrders());
        }
    }

    public static ArrayList<TreeNode> convertTreeNodes(ArrayList<SysPermissionVO> voTree){
        ArrayList<TreeNode> nodes = new ArrayList<>();
        voTree.forEach(vo->{
            TreeNode node = new TreeNode();
            node.setId(vo.getPermissionId());
            node.setChecked(vo.isChecked());
            node.setTitle(vo.getName());
            node.setField("permissionId");
            ArrayList<SysPermissionVO> childs = vo.getChilds();
            if(childs.size() > 0 ){
                node.setChildren(convertTreeNodes(childs));
                node.setChecked(false);
            }else{
                node.setChildren(null);
            }
            nodes.add(node);
        });
        return nodes;
    }

    /**
     * 针对请求被拦截下来的响应
     * @param httpResponse
     */
    public static void builFaildResponse(HttpServletResponse httpResponse,String msg) {
        APIResponse apiResponse = new APIResponse();
        apiResponse.setFailed("-1",msg);
        httpResponse.setCharacterEncoding("UTF-8");
        httpResponse.setContentType("application/json; charset=utf-8");
        httpResponse.setHeader("Access-Control-Allow-Origin", "*");
        httpResponse.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        httpResponse.setHeader("Access-Control-Allow-Credentials","true");
        PrintWriter writer = null;
        try {
            writer = httpResponse.getWriter();
            ObjectMapper mapper=new ObjectMapper();
            String str = mapper.writeValueAsString(apiResponse);
            writer.print(str);
            httpResponse.flushBuffer();

        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if (writer!=null) writer.close();
        }
    }

}
