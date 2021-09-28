SHOW DATABASES;
USE mysql;
SELECT * FROM user;
CREATE USER 'wang'@'%' IDENTIFIED BY 'wang';
CREATE USER 'li'@'%' IDENTIFIED BY 'li';
CREATE USER 'zhao'@'%' IDENTIFIED BY 'zhao';
CREATE USER 'zhou'@'%' IDENTIFIED BY 'zhou';
-- 只有 Wang 具有创建数据表和视图的权限

GRANT CREATE TABLE, CREATE VIEW TO wang; -- mysql不支持
GRANT CREATE on School.* to wang@'%'; -- 替代
GRANT CREATE ON *.* TO wang@'%';
-- 切换到wang:mysql -u wang -p
-- Wang 创建了三个数据表，学生表 wang_student、选课表 wang_sc 和课程表 wang_course
CREATE TABLE wang_student(
	Sno char(9),
    Sname char(20) NOT NULL,
    Ssex char(2) NOT NULL, 
    Sage smallint,
    Sdept varchar(20),
    CONSTRAINT pk PRIMARY KEY(Sno),
    CONSTRAINT sc CHECK(Ssex in('男','女'))
);
create table wnag_course(
Cno char(4) primary key,
Cname varchar(40) not null,
Cpno char(4),
Ccredit smallint,
foreign key(Cpno) references Course(Cno)
);
create table wang_sc(
Sno char(9),
Cno char(4),
Grade smallint,
primary key(Sno, Cno),#主码有两个属性构成
foreign key(Sno) references Student(Sno),
foreign key(Cno) references Course(Cno)
);