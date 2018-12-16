
--
-- Anki X 基础服务数据库
--

CREATE DATABASE IF NOT EXISTS `ankix_base`;


--
-- 用户表
--

create table `user` (
`uid` bigint unsigned not null AUTO_INCREMENT COMMENT '用户ID',
`username` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
`password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
`nickname` varchar(20) NOT NULL DEFAULT '' COMMENT '用户昵称',
`name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户姓名',
`email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
`phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
`gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别(0:未知,1:男,2:女)',
`birthday` date NOT NULL DEFAULT '0000-00-00' COMMENT '出生日期',
`groupid` SMALLINT UNSIGNED NOT NULL DEFAULT '1' COMMENT '用户组ID(1:普通用户组,2:高级用户组)',
`status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '用户状态(0:正常,10:注销,20:禁用)',
`regist_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '注册时间',
`last_login_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '最后登录时间',
`last_login_ip` varchar(32) NOT NULL DEFAULT '' COMMENT '最后登录IP',
primary key (`uid`),
UNIQUE KEY `uk_phone` (`phone`)
KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=100000001 DEFAULT CHARSET=utf8 COMMENT='用户主表'


--
-- 主题分类体系表
--

create table `topic_category` (
`cid` int unsigned not null AUTO_INCREMENT COMMENT '自增主键',
`cname` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '分类名称',
`parent_cid` int unsigned not null DEFAULT '0' COMMENT '父类目ID',
`description` varchar(128) NOT NULL DEFAULT '' COMMENT '类目说明',
`display_order` int NOT NULL DEFAULT '0' COMMENT '显示顺序',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`cid`),
KEY `idx_parent_cid` (`parent_cid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题分类体系表'

INSERT IGNORE INTO `topic_category` (cid,cname,parent_cid,description) VALUES
(1,'幼儿',0,'学龄前儿童认知训练'),
(2,'语言',0,'语言类主题,如英语单词'),
(201,'英语单词',2,'英语单词')


--
-- 主题表（一个主题对应Anki的一个记忆库=Deck=牌组,对应导出的一个数据包）
--

CREATE TABLE `topic` (
`tid` bigint unsigned not null AUTO_INCREMENT COMMENT '主题ID(自增主键)',
`cateid` int unsigned not null DEFAULT '0' COMMENT '主题类目ID',
`description` VARCHAR(256) NOT NULL DEFAULT '' COMMENT '主题描述',
`status` int unsigned not null DEFAULT '1' COMMENT '状态(1:私有,2:公开)',
`uid` bigint unsigned not null DEFAULT '0' COMMENT '创建者UID',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`tid`),
key `idx_uid_status` (`uid`,`status`),
KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题表'


--
-- 主题单元表
--

CREATE TABLE `topic_unit` (
`id` bigint unsigned not null AUTO_INCREMENT COMMENT '单元ID(自增主键)',
`tid` bigint unsigned not null DEFAULT '0' COMMENT '主题ID',
`name` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '单元名称',
`description` VARCHAR(256) NOT NULL DEFAULT '' COMMENT '主题描述',
`status` int unsigned not null DEFAULT '1' COMMENT '状态(1:私有,2:公开)',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`id`),
key `idx_tid_status` (`tid`,`status`),
KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题单元表'


--
-- 主题数据记录表
--

CREATE TABLE `topic_unit_item` (
`imid` bigint unsigned not null AUTO_INCREMENT COMMENT '数据记录ID(自增主键)',
`unit_id` bigint unsigned not null DEFAULT '0' COMMENT '主题单元ID',
`fields` text not null DEFAULT '' COMMENT '数据项(||分割)',
`status` int unsigned not null DEFAULT '1' COMMENT '状态',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`imid`),
key `idx_unid_status` (`unit_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题数据记录表';


--
-- 主题字段表
--

CREATE TABLE `topic_fields` (
`fid` bigint unsigned not null AUTO_INCREMENT COMMENT '字段ID',
`tid` bigint unsigned not null DEFAULT '0' COMMENT '主题ID',
`fname` VARCHAR(64) not null DEFAULT '' COMMENT '字段Key',
`ftype` INT NOT NULL DEFAULT '1' COMMENT '字段类型(1:文本,2:数字,3:图片,4:音频,5:视频)',
`fdesc` VARCHAR(64) not null DEFAULT '' COMMENT '字段描述',
`status` int unsigned not null DEFAULT '1' COMMENT '字段状态(1:显示,2:隐藏)',
`uid` bigint unsigned not null DEFAULT '0' COMMENT '创建者UID',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`fid`),
key `idx_tid` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题字段表';


--
-- 主题卡片表
--

CREATE TABLE `topic_cards` (
`cid` bigint unsigned not null AUTO_INCREMENT COMMENT '模板ID',
`tid` bigint unsigned not null DEFAULT '0' COMMENT '主题ID',
`cname` VARCHAR(50) NOT NULL DEFAULT '' COMMENT '卡片名称',
`front_code` text NOT NULL DEFAULT '' COMMENT '正面代码',
`back_code` text NOT NULL DEFAULT '' COMMENT '背面代码',
`format_code` text not null default '' COMMENT '格式刷代码',
`display_order` int not null DEFAULT '0' COMMENT '卡片顺序',
`uid` bigint unsigned not null DEFAULT '0' COMMENT '创建者UID',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`cid`),
key `idx_tid` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='主题卡片表';


--
-- 模板表
--

CREATE TABLE `template` (
`id` bigint unsigned not null AUTO_INCREMENT COMMENT '模板ID',
`name` VARCHAR(50) NOT NULL DEFAULT '' COMMENT '模板名称',
`description` VARCHAR(256) NOT NULL DEFAULT '' COMMENT '模板描述',
`status` tinyint(3) NOT NULL DEFAULT '1' COMMENT '状态(1:私有,2:公开)',
`uid` bigint not null DEFAULT '0' COMMENT '创建者UID(-1为系统创建)',
`create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`id`),
key `idx_uid_status` (`uid`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='模板表';

INSERT IGNORE INTO template (id,name,description,status,uid) VALUES
(1,'Basic','Basic',2,-1),
(2,'Basic (and reversed card)','Basic (and reversed card)',2,-1),
(3,'Basic (optional reversed card)','Basic (optional reversed card)',2,-1),
(4,'Basic (type in answer)','Basic (type in answer)',2,-1),
(5,'Cloze','Cloze',2,-1)


--
-- 模板字段表
--

CREATE TABLE `template_fields` (
`fid` bigint unsigned not null AUTO_INCREMENT COMMENT '字段ID',
`tid` bigint unsigned not null DEFAULT '0' COMMENT '模板ID',
`fname` VARCHAR(64) not null DEFAULT '' COMMENT '字段Key',
`ftype` INT NOT NULL DEFAULT '1' COMMENT '字段类型(1:文本,2:数字,3:图片,4:音频,5:视频)',
`fdesc` VARCHAR(64) not null DEFAULT '' COMMENT '字段描述',
`display_order` int not null DEFAULT '0' COMMENT '顺序',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
primary key (`fid`),
key `idx_tid` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='模板字段表';

INSERT IGNORE INTO template_fields (fid,tid,fname,ftype,fdesc,display_order) VALUES
(1,1,'Front','1','正面字段',1),
(2,1,'Back','1','反面字段',2)

--
-- 模板卡片表
--

CREATE TABLE `template_cards` (
`cid` bigint unsigned not null AUTO_INCREMENT COMMENT '卡片ID',
`tid` bigint unsigned not null DEFAULT '0' COMMENT '模板ID',
`cname` VARCHAR(50) NOT NULL DEFAULT '' COMMENT '卡片名称',
`front_code` text NOT NULL DEFAULT '' COMMENT '正面代码',
`back_code` text NOT NULL DEFAULT '' COMMENT '背面代码',
`format_code` text not null default '' COMMENT '格式刷代码',
`display_order` int not null DEFAULT '0' COMMENT '卡片顺序',
`update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`isdel` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
primary key (`cid`),
key `idx_tid` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='模板卡片表';

INSERT IGNORE INTO template_cards (cid,tid,cname,front_code,back_code,format_code,display_order) VALUES
(1,1,'Front->Back','{{Front}}','{{Back}}','.card {font-family:"microsoft yahei";font-size:20px;}"}',1)