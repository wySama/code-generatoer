import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

/**
 * 生成简单表结构的画面和对应的MVC层
 */
public class SimpleCodeGenerator {

    public static void main(String args[]){
        try {
            Map root = new HashMap();
            root.put("name", "BizGoods");//前缀
            root.put("controllerMapping", "bizGoods");//访问前缀
            root.put("package", "cn.com.artlife.sc");//包路径
            root.put("servicePackage", "cn.com.artlife.sc");//包路径
            root.put("bizPackage", "cn.com.artlife.sc");//包路径
            root.put("ID", "GoodsId");//主键字段
            root.put("id", "goodsId");//主键字段实例

            Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
            cfg.setDirectoryForTemplateLoading(new File(new File("").getCanonicalPath()+ "/src/main/resources"));
            cfg.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_23));
            String targetPath = "D:/intellij/sc/admin/src/main/";
            {
                //接口controller
                Template temp = cfg.getTemplate("Controller.ftl");
                String fileName = root.get("name") + "Controller.java";
                String destStr=targetPath + "java\\cn\\com\\artlife\\sc\\controller\\";
                File file = new File( destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }
            {
                //接口service
                Template temp = cfg.getTemplate("Service.ftl");
                String fileName = root.get("name")+"Service.java";
                String destStr= targetPath + "java\\cn\\com\\artlife\\sc\\service\\";
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }
            {
                //业务controller
                Template temp = cfg.getTemplate("BizController.ftl");
                String fileName = root.get("name")+"Controller.java";
                String destStr= targetPath + "java\\cn\\com\\artlife\\sc\\controller\\";
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }
            {
                //业务list页面
                Template temp = cfg.getTemplate("HtmlList.ftl");
                String fileName = root.get("controllerMapping")+".ftl";
                String destStr= targetPath + "resources\\templates\\views\\";
                System.out.println(destStr);
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }
            {
                //业务edit页面
                Template temp = cfg.getTemplate("HtmlEdit.ftl");
                String fileName = root.get("controllerMapping")+"Edit.ftl";
                String destStr= targetPath + "resources\\templates\\views\\";
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    /**
     * 写入代码文件
     * @param file 最终的文件
     * @param destStr
     * @param fileName
     * @param temp
     * @param root
     * @throws Exception
     */
    public static void writeFile(File file,String destStr,String fileName,Template temp,Map root) throws  Exception{
        if(!file.exists() || (file.exists() && file.renameTo(new File(destStr + fileName+".backup"+System.currentTimeMillis())))){
            BufferedWriter bw = new BufferedWriter (new OutputStreamWriter(new FileOutputStream (file,false),"UTF-8"));
            temp.process(root, bw);
            bw.flush();
            bw.close();
        }
    }

}
