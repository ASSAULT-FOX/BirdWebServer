/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.5.68-MariaDB : Database - newdb3
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`empdb` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `empdb`;

/*Table structure for table `dept` */

DROP TABLE IF EXISTS `dept`;

CREATE TABLE `dept` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(14) NOT NULL,
  `loc` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `DNAME` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `dept` */

insert  into `dept`(`id`,`name`,`loc`) values (1,'神仙','天庭'),(2,'妖怪','盘丝洞'),(3,'普通人','北京'),(4,'赛亚人','外星球');

/*Table structure for table `emp` */

DROP TABLE IF EXISTS `emp`;

CREATE TABLE `emp` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `job` varchar(9) DEFAULT NULL,
  `manager` int(4) DEFAULT NULL,
  `hiredate` date DEFAULT NULL,
  `sal` double(7,2) DEFAULT NULL,
  `comm` double(7,2) DEFAULT NULL,
  `dept_id` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `emp` */

insert  into `emp`(`id`,`name`,`job`,`manager`,`hiredate`,`sal`,`comm`,`dept_id`) values (1,'孙悟空','销售',4,'1980-12-17',800.00,NULL,1),(2,'猪八戒','销售',4,'1981-02-20',1600.00,300.00,1),(3,'沙僧','销售',4,'1981-02-22',1250.00,500.00,1),(4,'唐僧','销售经理',8,'1981-04-02',2975.00,NULL,1),(5,'刘备','项目经理',NULL,'1981-09-28',1250.00,1400.00,3),(6,'关羽','程序员',5,'1981-05-01',2850.00,NULL,3),(7,'张飞','程序员',5,'1981-06-09',2450.00,NULL,3),(8,'观音','CEO',NULL,'1981-11-17',5000.00,NULL,1),(9,'白骨精','人事',8,'1981-09-08',1500.00,0.00,2),(10,'蜘蛛精','人事',8,'1981-12-03',950.00,NULL,2),(11,'黑熊怪','市场',8,'1981-12-03',3000.00,NULL,2);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
set names gbk;