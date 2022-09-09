package com.webserver.core;

import com.webserver.http.HttpServletRequest;

import java.io.*;
import java.net.Socket;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * 该线程任务负责处理与某个客户端的一次HTTP交互。
 * 由于HTTP协议要求客户端和服务端采取一问一答的原则，因此这里处理与客户端的一次交互规划
 * 为三个步骤:
 * 1:解析请求(将客户端发送过来的请求内容读取到)
 * 2:处理请求(根据请求内容进行对应的处理)
 * 3:发送响应(将处理结果回馈给浏览器)
 * 断开连接
 */
public class ClientHandler implements Runnable{
    private Socket socket;
    private static File rootDir;
    private static File staticDir;
    static{
        try {
            //rootDir表示类加载路径:target/classes目录
            rootDir = new File(
                    ClientHandler.class.getClassLoader()
                            .getResource(".").toURI()
            );
            //定位static目录(static目录下存放的是所有静态资源)
            staticDir = new File(rootDir,"static");
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }


    public ClientHandler(Socket socket){
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
//            1:解析请求(将客户端发送过来的请求内容读取到)
            HttpServletRequest request = new HttpServletRequest(socket);
//            2:处理请求(根据请求内容进行对应的处理)
            String path = request.getUri();
            File file = new File(staticDir,path);
            int statusCode;//状态代码
            String statusReason;//状态描述
            if(file.isFile()){//根据用户提供的抽象路径去static目录下定位到一个文件
                statusCode = 200;
                statusReason = "OK";
            }else{
                statusCode = 404;
                statusReason = "NotFound";
                file = new File(staticDir,"/root/404.html");
            }

//            3:发送响应(将处理结果回馈给浏览器)
            OutputStream out = socket.getOutputStream();
            //发送状态行
            println("HTTP/1.1"+" "+statusCode+" "+statusReason);
            //发送响应头
            //Content-Type: text/html(CRLF)
            println("Content-Type: text/html");
            //Content-Length: 2546(CRLF)
            println("Content-Length: "+file.length());
            //单独发送回车+换行表达响应头发送完毕
            println("");

            //发送响应正文
            //将index.html文件所有数据发送
            FileInputStream fis = new FileInputStream(file);
            byte[] data = new byte[1024*10];
            int len;
            while((len = fis.read(data))!=-1){
                out.write(data,0,len);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            //按照HTTP协议要求，处理最后要断开连接
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void println(String line) throws IOException {
        OutputStream out = socket.getOutputStream();
        out.write(line.getBytes(StandardCharsets.ISO_8859_1));
        out.write(13);
        out.write(10);
    }


    public static void main(String[] args) throws URISyntaxException {
        File rootDir = new File(
                ClientHandler.class.getClassLoader()
                        .getResource(".").toURI()
        );
        //定位static目录(static目录下存放的是所有静态资源)
        File staticDir = new File(rootDir,"static");
        //定位static目录下的index.html
        File file = new File(staticDir,"index.html");
        System.out.println("文件是否存在:"+file.exists());
        System.out.println(rootDir);
    }

}
