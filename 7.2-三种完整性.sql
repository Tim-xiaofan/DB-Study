--7.2，7.3，7.4
------ 7.2.1 实体完整性的定义------
USE School;
DROP TABLE Student;
--【例 7-1】在列级定义主键
CREATE TABLE Student(
	Sno CHAR(9) PRIMARY KEY,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('男','女')),
	Sage SMALLINT,
	Sdept CHAR(20)
);
--【例 7-2】在表级定义主键
CREATE TABLE Student(
	Sno CHAR(9) NOT NULL,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('男','女')),
	Sage SMALLINT,
	Sdept CHAR(20),
	PRIMARY KEY(Sno)
);
-- 【例 7-3】添加表以存在表的PRIMARY KEY约束
CREATE TABLE Student(
	Sno CHAR(9) NOT NULL,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('男','女')),
	Sage SMALLINT,
	Sdept CHAR(20),
);
ALTER TABLE Student ADD PRIMARY KEY(Sno);
SELECT * FROM Student;

------ 7.2.2 实体完整性检查和违约处理 ------
--【例 7-4】在 Student 表中插入记录
INSERT INTO Student VALUES(NULL, '李贤','男', 17 ,'计算机科学技术学院');
--- 【例 7-5】重复执行 Student 表上的插入语句
INSERT INTO Student VALUES('20053409', '李贤','男', 17 ,'计算机科学技术学院');

------ 7.3.1 参照完整性定义 ------
DROP TABLE Course;
create table Course(
Cno char(4) primary key,
Cname varchar(40) not null,
Cpno char(4),
Ccredit smallint,
foreign key(Cpno) references Course(Cno)
);
--【例 7-6】定义 SC 中的参照完整性
DROP TABLE SC;
CREATE TABLE SC(
	Sno CHAR(9),
	Cno CHAR(4),
	Grade SMALLINT,
	PRIMARY KEY(Sno, Cno),
	FOREIGN KEY(Sno) REFERENCES Student(Sno),
	FOREIGN KEy(Cno) REFERENCES Course(Cno)
);
SELECT * FROM SC;

------ 7.4.1 用户定义完整性定义 ------
--【例 7-7】创建数据表，指定属性列 Grade 的取值范围为 0～100。
CREATE TABLE SC(
	Sno CHAR(9),
	Cno CHAR(4),
	Grade SMALLINT CHECK(Grade >=0 AND Grade <=100),
	PRIMARY KEY(Sno, Cno),
	FOREIGN KEY(Sno) REFERENCES Student(Sno),
	FOREIGN KEy(Cno) REFERENCES Course(Cno)
);
-- 【例 7-8】创建 table1，指定 c1 字段不能包含重复值，c2 字段只能取特定值。
DROP TABLE table1;
CREATE TABLE table1(
	c1 CHAR(2) UNIQUE,
	c2 CHAR(4) CHECK (c2 in('0000', '0001', '0002', '0003')),
	c3 INT DEFAULT 1
);

------ 7.4.2 用户定义的完整性检查和违约处理 ------
SELECT * FROM table1;
--(1)
INSERT INTO table1 (c1,c2) VALUES ('10', '0000');
--(2)
INSERT INTO table1 VALUES ('10', '0001', 2);
--(3)
UPDATE table1 SET c2= '1111' WHERE c1='10';
--(4)
UPDATE table1 SET c2= '0002' WHERE c1='10';--满足约束条件