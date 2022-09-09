package com.webserver.core;

import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;

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
    public ClientHandler(Socket socket){
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
            InputStream in = socket.getInputStream();
            StringBuilder builder = new StringBuilder();
            char pre='a',cur='a';//pre表示上次读取的字符，cur表示本次读取的字符
            int d;
            while((d = in.read())!=-1){
                cur = (char)d;//本次读取到的字符
                if(pre==13&&cur==10){//若上次读取的是回车符并且本次读取的是换行符
                    break;
                }
                builder.append(cur);//拼接本次读取到的字符
                pre = cur;//进入下次循环前将本次读取的字符记作上次读取的字符
            }
            String line = builder.toString().trim();
            System.out.println("请求行内容:"+line);
            //请求的相关信息
            String method;//请求方式
            String uri;//抽象路径
            String protocol;//协议版本

            String[] data = line.split("\\s");
            method = data[0];
            uri = data[1];
            protocol = data[2];
            System.out.println("method:"+method);
            System.out.println("uri:"+uri);
            System.out.println("protocol:"+protocol);

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
}
