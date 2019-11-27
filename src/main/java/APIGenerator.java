import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * 生成简单表结构的画面和对应的MVC层
 */
public class APIGenerator {

    public static void main(String args[]){
        try {
            Map root = new HashMap();
            root.put("package", "com.mo.ec");//包路径
            root.put("po", "PayResponse");//前缀
            root.put("prefixPo", "payResponse");//实例前缀
            root.put("ID", "ResponseId");//主键字段
            root.put("id", "responseId");//主键字段实例
            root.put("page", "pay-response");//画面
            root.put("controllerMapping", "boss/private/"+root.get("page"));//

            Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
            cfg.setDirectoryForTemplateLoading(new File(new File("").getCanonicalPath()+ "/code-generatoer/src/main/resources/ec"));
            cfg.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_23));
            String targetPath = "E:/works/ec-parent/base_service/src/main/java/com/mo/ec/service/";

            {
                //service
                Template temp = cfg.getTemplate("Service.ftl");
                String fileName = root.get("po")+"Service.java";
                String destStr= targetPath;
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }

            targetPath = "E:/works/ec-parent/api/src/main/java/com/mo/ec/controller/";

            {
                //Controller
                Template temp = cfg.getTemplate("Controller.ftl");
                String fileName = root.get("po")+"Controller.java";
                String destStr= targetPath;
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }

            targetPath = "E:/works/ec-parent/base_service/src/main/java/com/mo/ec/dto/";

            {
                //DTO
                Template temp = cfg.getTemplate("DTO.ftl");
                String fileName = root.get("po")+"DTO.java";
                String destStr= targetPath;
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }

            targetPath = "E:/works/ec_site_boss/view/";

            {
                //HtmlList
                Template temp = cfg.getTemplate("HtmlList.ftl");
                String fileName = root.get("page")+".html";
                String destStr= targetPath;
                File file = new File(destStr + fileName);
                writeFile( file, destStr, fileName, temp, root);
            }

            {
                //HtmlEdit
                Template temp = cfg.getTemplate("HtmlEdit.ftl");
                String fileName = root.get("page")+"-edit.html";
                String destStr= targetPath;
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
