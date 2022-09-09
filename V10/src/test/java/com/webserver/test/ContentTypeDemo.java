package com.webserver.test;

import javax.activation.MimetypesFileTypeMap;

/**
 * java有现成的API可以解析不同的文件所对应的Content-Type的值
 */
public class ContentTypeDemo {
    public static void main(String[] args) {
        String contentType
                = new MimetypesFileTypeMap().getContentType("123.png");
        System.out.println(contentType);
    }
}
