package com.webserver.controller;

import com.webserver.entity.User;
import com.webserver.http.HttpServletRequest;
import com.webserver.http.HttpServletResponse;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.URISyntaxException;

public class UserController {
    private static File rootDir;
    private static File staticDir;
    private static File userDir;//用来表示存放所有用户信息的目录
    static {
        userDir = new File("./users");
        if(!userDir.exists()){
            userDir.mkdirs();
        }
        try {
            //rootDir表示类加载路径:target/classes目录
            rootDir = new File(
                    UserController.class.getClassLoader()
                            .getResource(".").toURI()
            );
            //定位static目录(static目录下存放的是所有静态资源)
            staticDir = new File(rootDir,"static");
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }



    public void reg(HttpServletRequest request, HttpServletResponse response){
        System.out.println("开始处理注册!!!!");
        //获取表单信息
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");
        String ageStr = request.getParameter("age");
        //必要验证
        if(username==null||username.isEmpty()||
            password==null||password.isEmpty()||
            nickname==null||nickname.isEmpty()||
            ageStr==null||ageStr.isEmpty()||!ageStr.matches("[0-9]+")
        ){
            //信息输入有误提示页面
            File file = new File(staticDir,"reg_info_error.html");
            response.setContentFile(file);
            return;
        }

        System.out.println(username+","+password+","+nickname+","+ageStr);

        int age = Integer.parseInt(ageStr);
        //2
        User user = new User(username,password,nickname,age);
        //参数1:userDir表示父目录 参数2:userDir目录下的子项
        File file = new File(userDir,username+".obj");
        if(file.exists()){//文件存在则说明该用户已经注册过了
            response.setContentFile(new File(staticDir,"have_user.html"));
            return;
        }
        try (
                FileOutputStream fos = new FileOutputStream(file);
                ObjectOutputStream oos = new ObjectOutputStream(fos);
        ){
            oos.writeObject(user);
            //利用响应对象要求浏览器访问注册成功页面
            response.setContentFile(new File(staticDir,"reg_success.html"));
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
