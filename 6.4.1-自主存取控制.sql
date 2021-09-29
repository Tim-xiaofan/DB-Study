#1. 自主存取的实现
SHOW DATABASES;
USE mysql;
SELECT * FROM user;
CREATE USER 'wang'@'%' IDENTIFIED BY 'wang';
CREATE USER 'li'@'%' IDENTIFIED BY 'li';
CREATE USER 'zhao'@'%' IDENTIFIED BY 'zhao';
CREATE USER 'zhou'@'%' IDENTIFIED BY 'zhou';
-- 只有 Wang 具有创建数据表和视图的权限

GRANT CREATE TABLE, CREATE VIEW TO wang; -- mysql不支持
GRANT CREATE ON School.* to wang@'%'; -- 替代
GRANT CREATE ON *.* TO wang@'%';
GRANT CREATE ROLE ON School TO wang@'%';
GRANT SELECT ON TABLE School.wang_student TO wang@'%';
FLUSH PRIVILEGES;
-- 切换到wang:mysql -u wang -p
-- Wang 创建了三个数据表，学生表 wang_student、选课表 wang_sc 和课程表 wang_course
CREATE TABLE wang_student( -- ???wang法查询此表
	Sno char(9),
    Sname char(20) NOT NULL,
    Ssex char(2) NOT NULL, 
    Sage smallint,
    Sdept varchar(20),
    CONSTRAINT pk PRIMARY KEY(Sno),
    CONSTRAINT sc CHECK(Ssex in('男','女'))
);
create table wang_course( -- ???wang法查询创建此表
Cno char(4) primary key,
Cname varchar(40) not null,
Cpno char(4),
Ccredit smallint,
foreign key(Cpno) references wang_course(Cno) -- mysql权限报错
);
create table wang_sc(-- ???wang法查询创建此表
Sno char(9),
Cno char(4),
Grade smallint,
primary key(Sno, Cno),#主码有两个属性构成
foreign key(Sno) references wang_student(Sno), -- mysql权限报错
foreign key(Cno) references wang_course(Cno) -- mysql权限报错
);
-- 如果 wang 要给用户 li 授予在这三个关系上查询的权限，并且允许 li 把此权限传播给其他用户
GRANT SELECT ON TABLE wang_school, wang_sc, wang_course to li WITH GRANT OPTION; -- mysql不支持


# 2.数据库角色
/*（1）角色的创建
CREATE ROLE <角色名> 
（2）给角色授权
GRANT <权限>［，<权限>］...
ON <对象类型>对象名 
TO <角色>［，<角色>］...
（3）将一个角色授予其他的角色或用户
GRANT <角色 1>［，<角色 2>］„
TO <角色 3>［，<用户 1>］„
［WITH GRANT OPTION］
（4）角色权限的收回
REVOKE <权限>［，<权限>］...
ON <对象类型> <对象名>
FROM <角色>［，<角色>］...*/
-- 【例 6-1】用户 wang 通过角色实现将一组授权授予用户 Li 和 Zhao。
-- Wang 创建一个角色 R1
CREATE ROLE R1;
--  wang 授予角色 R1 拥有上面三个关系的查询权限
GRANT SELECT ON TABLE wang_student, wang_sc, wang_course TO R1; -- mysql不支持 
-- Wang 将角色 R1 授予用户 Li 和 Zhao，使他们具有角色 R1 所包含的全部权限
GRANT R1 TO li, zhao;