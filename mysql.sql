# 数据库
# 存储数据的仓库，就称为数据库。
# 我们创建的一个目录users,里面存放了很多的obj文件，每个文件保存了一组信息。users就是一个
# 数据库。只是我们管理起来要么手动，要么写一些代码进行维护。
# 低效，不通用。
#
# 数据库管理系统DBMS: DataBaseManagementSystem
# 常见的数据库管理系统:
# MySQL
# ORACLE
# SQLServer
# DB2

# 主要的学习目标:
# SQL：Structured Query Language
# 学习SQL语句。
# SQL语句是我们操作数据库的语言，通过执行SQL可以完成对数据的相关操作。


# 连接数据库的形式:
# 1:控制台(命令行)的客户端
# 2:第三方图形界面的软件
# 3:IDEA这样的集成开发环境中也带有连接数据库的操作
# 4:使用JDBC连接数据库
#
# SQL基础:
# 查看当前MySQL当中有多少个数据库:
SHOW DATABASES;

# 创建数据库:
# CREATE DATABASE 数据库名
# 创建数据库:mydb
CREATE DATABASE mydb;

# 数据库创建时可以指定字符集
# CREATE DATABASE 数据库名 CHARSET=UTF8/GBK

# 创建数据库:db1(字符集用gbk)  db2(字符集用utf8)
CREATE DATABASE db1 CHARSET=UTF8;
CREATE DATABASE db2 CHARSET=GBK;

# 查看数据库信息
# SHOW CREATE DATABASE 数据库名;
SHOW CREATE DATABASE db2;

# 删除数据库
# DROP DATABASE 数据库名
DROP DATABASE db1;
DROP DATABASE db2;

# 想保存数据,就要选取需要保存数据的数据库,然后才能在该数据库中建立表等操作.
# USE 数据库名
# 使用mydb这个数据库
USE mydb;

练习:
# 1. 创建 mydb1和mydb2 数据库 字符集分别为utf8和gbk
CREATE DATABASE mydb1 CHARSET=utf8;
CREATE DATABASE mydb2 CHARSET=gbk;
# 2. 查询所有数据库检查是否创建成功
SHOW DATABASES;
# 3. 检查两个数据库的字符集是否正确
SHOW CREATE DATABASE mydb1;
SHOW CREATE DATABASE mydb2;
# 4. 先使用mydb2 再使用 mydb1
USE mydb2;
USE mydb1;
# 5. 删除两个数据库
DROP DATABASE mydb1;
DROP DATABASE mydb2;

# 在mysql中,我们可以为不同的项目创建不同的数据库.而每个数据库中都可以创建若干张表.每张表
# 用来保存一组数据.比如我们为保存用户信息可以创建userinfo表.保存文章信息可以创建article表等

# SQL语句分类:
# DDL,DML,DQL,TCL,DCL

# 表相关的操作
# DDL语句:数据定义语言,用来操作数据库对象的.
# 数据库对象:表,视图,索引都属于数据库对象.

# 创建表
# CREATE TABLE 表名(
                                                                                                                                                                                   #     列名1 类型[(长度)] [DEFAULT 默认值] [约束条件],
                                                                                                                                                                                   #     列名2 类型...
                                                                                                                                                                                       # )[CHARSET=utf8/gbk]

# 创建userinfo表
CREATE TABLE userinfo(
                         id INT,
                         username VARCHAR(32),
                         password VARCHAR(32),
                         nickname VARCHAR(32),
                         age INT(3)
)
# 数字的长度表示位数,VARCHAR的长度表示最多占用的字节数

# 查看当前数据库创建的所有表
SHOW TABLES;

# 查看创建的某一张表的详细信息
# SHOW CREATE TABLE 表名
    SHOW CREATE TABLE userinfo;

#查看表结构
# DESC 表名
DESC userinfo;

#删除表
# DROP TABLE 表名
DROP TABLE userinfo;

#修改表
#修改表名
# RENAME TABLE 原表名 TO 新表名
RENAME TABLE userinfo TO user;

# 练习:
# 1. 创建数据库mydb3 字符集gbk 并使用
CREATE DATABASE mydb3 CHARSET=gbk;
USE mydb3;
# 2. 创建t_hero英雄表, 有名字和年龄字段 默认字符集
CREATE TABLE t_hero(
                       id INT,
                       name VARCHAR(32),
                       age INT(3)
);
# 3. 修改表名为hero
RENAME TABLE t_hero TO hero;
# 4. 查看表hero的字符集
SHOW CREATE TABLE hero;
# 5. 查询表hero结构
DESC hero;
# 6. 删除表hero
DROP TABLE hero;
# 7. 删除数据库mydb3
DROP DATABASE mydb3;

# 修改表结构:ALTER TABLE
    # 实际开发中,通常不建议在表中含有数据时修改表结构
    # 添加列
    # ALTER TABLE 表名 ADD 列名 类型[长度]
ALTER TABLE user ADD gender VARCHAR(10);
DESC user;

# CREATE TABLE hero(
                       #     username VARCHAR(32),
                       #     age INT(3)
                           # )

    # 在表的第一列上添加新列
# ALTER TABLE 表名 ADD 列名 类型[长度] FIRST
ALTER TABLE hero ADD id INT FIRST;
DESC hero;

# 在表中插入一个字段
# ALTER TABLE 表名 ADD 列名 类型[长度] AFTER 字段名
ALTER TABLE hero ADD gender VARCHAR(10) AFTER username;

#删除表中现有的列
# ALTER TABLE 表名 DROP 字段名(注:列名)
ALTER TABLE hero DROP gender;
DESC hero;

# 修改表中现有的列
# 注意,当表中含有数据后,字段类型尽量不要改变,长度修改尽量不要减少,否则都有可能违背表中现有
# 数据要求导致修改失败.

# ALTER TABLE 表名 CHANGE 原字段名 新字段名 新类型
    # 将age的类型从INT换成VARCHAR
ALTER TABLE hero CHANGE age age VARCHAR(10);
# 将age的长度改为100
ALTER TABLE hero CHANGE age age VARCHAR(100);
# 将age改为gender,长度改为10
ALTER TABLE hero CHANGE age gender VARCHAR(10);

# 练习:
# 1. 创建数据库mydb4 字符集utf8并使用
CREATE DATABASE mydb4 CHARSET=utf8;
USE mydb4;
# 2. 创建teacher表 有名字(name)字段
CREATE TABLE teacher(
    name VARCHAR(32)
);
# 3. 添加表字段: 最后添加age 最前面添加id(int型) , age前面添加salary工资(int型)
ALTER TABLE teacher ADD age INT(3);
ALTER TABLE teacher ADD id INT FIRST;
ALTER TABLE teacher ADD salary INT AFTER name;

# 4. 删除age字段
ALTER TABLE teacher DROP age;
# 5. 修改表名为t
RENAME TABLE teacher TO t;
# 6. 删除表t
DROP TABLE t;
# 7. 删除数据库mydb4
DROP DATABASE mydb4;

# 总结:
# DDL语言,数据定义语言,操作数据库对象
# CREARE,ALTER,DROP
# 创建表:CREATE TABLE
    # 修改表:ALTER TABLE
    # 删除表:DROP TABLE

    # DML语言:数据操作语言,是对表中的数据进行操作的语言,包含:增,删,改操作
CREATE TABLE person(
                       name VARCHAR(32),
                       age INT(3)
);

# 插入数据
# INSERT INTO 表名 [(字段1,字段2...)] VALUES (字段1的值，字段2的值...)
INSERT INTO person(name, age) VALUES ('张三',22);
INSERT INTO person(age, name) VALUES (22,'王五');

#未指定的列插入的都是列的默认值。当创建表时没有为列声明特定的默认值时，列默认值为null。
INSERT INTO person(name) VALUES('李四');


#字段名可以忽略不写，此时为全列插入，即:VALUES需要指定每一列的值，且顺序，个数，类型必须与表中的字段一致
INSERT INTO person VALUES('传奇',22);

# 查看person表中的所有数据
SELECT * FROM person

                  # 修改表数据操作:UPDATE语句
# UPDATE 表名 SET 字段名1=新值1[,字段名2=新值2,...][WHERE 过滤条件]

    #通常修改语句要添加WHERE子句，用于添加过滤条件来定位要修改的记录。不添加WHERE子句则是全表所有记录都修改。
    #下面的操作会将person表中每条记录的age字段值都改为55！！
UPDATE person SET age=55;

#将李四的年龄改成23岁
UPDATE person SET age=23 WHERE name='李四';

#WHERE中常用的条件:=,>,>=,<,<=,<>(不等于，!=不是所有数据库都支持)
#将年龄大于50岁的人的年龄改为25
UPDATE person SET age=25 WHERE age>50;

#修改字段时，可以将计算表达式的结果进行修改
#将每个人的年龄涨一岁
UPDATE person SET age=age+1;

#将年龄为24岁的人改名为李老四，年龄为55
UPDATE person
SET name='李老四',age=55
WHERE age=24;

SELECT * FROM person;

#删除数据:DELETE语句
# DELETE FROM 表名 [WHERE 过滤条件]
    # 注意！！！不添加WHERE条件则是全表删除！！！

    # 删除名字为李老四的记录
DELETE FROM person WHERE name='李老四';

# 删除年龄大于25岁的人
DELETE FROM person WHERE age>25;

#清空表操作
DELETE FROM person

练习:
1. 创建数据库day1db 字符集utf8并使用
create database day1db charset=utf8;
use day1db;
2. 创建t_hero表, 有name字段 字符集utf8
create table t_hero(name varchar(20))charset=utf8;
3. 修改表名为hero
rename table t_hero to hero;
4. 最后面添加价格字段money, 最前面添加id字段, name后面添加age字段
alter table hero add money int;
alter table hero add id int first;
alter table hero add age int after name;
5. 表中添加以下数据: 1,李白,50,6888 2,赵云,30,13888 3,刘备,25,6888
insert into hero values(1,'李白',50,6888);
insert into hero values(2,'赵云',30,13888);
insert into hero values(3,'刘备',25,6888);
6. 查询价格为6888的英雄名
select name from hero where money=6888;
7. 修改刘备年龄为52岁
update hero set age=52 where name='刘备';
8. 修改年龄小于等于50岁的价格为5000
update hero set money=5000 where age<=50;
9. 删除价格为5000的信息
delete from hero where money=5000;
10. 删除表, 删除数据库
drop table hero;
drop database day1db;