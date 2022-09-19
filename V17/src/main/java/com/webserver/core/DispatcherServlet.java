package com.webserver.core;

import com.webserver.annotations.Controller;
import com.webserver.annotations.RequestMapping;
import com.webserver.controller.UserController;
import com.webserver.http.HttpServletRequest;
import com.webserver.http.HttpServletResponse;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.sql.Connection;

/**
 * 这个类是SpringMVC框架与tomcat容器整合的一个关键类，接管了处理请求的工作。
 * 这样当tomcat将请求对象和响应对象创建完毕后在处理请求的环节通过调用这个类来完成，从而
 * 将处理请求交给了SpringMVC框架
 * 并在处理后发送响应给浏览器
 */
public class DispatcherServlet {
    private static DispatcherServlet instance = new DispatcherServlet();
    private static File rootDir;
    private static File staticDir;

    static {
        try {
            //rootDir表示类加载路径:target/classes目录
            rootDir = new File(
                    DispatcherServlet.class.getClassLoader()
                            .getResource(".").toURI()
            );
            //定位static目录(static目录下存放的是所有静态资源)
            staticDir = new File(rootDir, "static");
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    private DispatcherServlet() {
    }

    public static DispatcherServlet getInstance() {
        return instance;
    }


    public void service(HttpServletRequest request, HttpServletResponse response) {
        String path = request.getRequestURI();
        //path:/regUser
        //首先判断是否为请求某个特定的业务
        /*
            当我们得到本次请求路径path的值后，我们首先要查看是否为请求业务:
            1:扫描controller包下的所有类
            2:查看哪些被注解@Controller标注的过的类(只有被该注解标注的类才认可为业务处理类)
            3:遍历这些类，并获取他们的所有方法，并查看哪些时业务方法
              只有被注解@RequestMapping标注的方法才是业务方法
            4:遍历业务方法时比对该方法上@RequestMapping中传递的参数值是否与本次请求
              路径path值一致?如果一致则说明本次请求就应当由该方法进行处理
              因此利用反射机制调用该方法进行处理。
            5:如果扫描了所有的Controller中所有的业务方法，均未找到与本次请求匹配的路径
              则说明本次请求并非处理业务，那么执行下面请求静态资源的操作
         */
        //定位controller目录
        try {
            File dir = new File(rootDir,"com/webserver/controller");
            File[] subs = dir.listFiles(f->f.getName().endsWith(".class"));
            for(File sub : subs){
                String className = sub.getName().replace(".class","");
                Class cls = Class.forName("com.webserver.controller."+className);
                //是否被注解Controller标注了
                if(cls.isAnnotationPresent(Controller.class)){
                    //扫描所有方法，查看是否为处理本次请求的方法
                    Method[] methods = cls.getDeclaredMethods();
                    for(Method method : methods){
                        //判断是否被注解@RequestMapping标注了
                        if(method.isAnnotationPresent(RequestMapping.class)){
                            RequestMapping rm = method.getAnnotation(RequestMapping.class);
                            //获取@RequestMapping注解的参数值
                            String value = rm.value();
                            //若本次请求路径和@RequestMapping注解参数值一样则说明本次请求应当有该方法处理
                            if(path.equals(value)){
                                Object controller = cls.newInstance();
                                method.invoke(controller,request,response);
                                return;
                            }
                        }
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            //处理业务过程中出错，可以设置响应500错误。
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }


        File file = new File(staticDir, path);
        if (file.isFile()) {//根据用户提供的抽象路径去static目录下定位到一个文件
            response.setContentFile(file);
            response.addHeader("Server", "BirdWebServer");
        } else {
            response.setStatusCode(404);
            response.setStatusReason("NotFound");
            file = new File(staticDir, "/root/404.html");
            response.setContentFile(file);
        }

    }
}
