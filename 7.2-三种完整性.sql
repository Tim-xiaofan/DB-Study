--7.2��7.3��7.4
------ 7.2.1 ʵ�������ԵĶ���------
USE School;
DROP TABLE Student;
--���� 7-1�����м���������
CREATE TABLE Student(
	Sno CHAR(9) PRIMARY KEY,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('��','Ů')),
	Sage SMALLINT,
	Sdept CHAR(20)
);
--���� 7-2���ڱ���������
CREATE TABLE Student(
	Sno CHAR(9) NOT NULL,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('��','Ů')),
	Sage SMALLINT,
	Sdept CHAR(20),
	PRIMARY KEY(Sno)
);
-- ���� 7-3����ӱ��Դ��ڱ��PRIMARY KEYԼ��
CREATE TABLE Student(
	Sno CHAR(9) NOT NULL,
	Sname CHAR(20) NOT NULL,
	Ssex CHAR(2) CHECK(Ssex IN('��','Ů')),
	Sage SMALLINT,
	Sdept CHAR(20),
);
ALTER TABLE Student ADD PRIMARY KEY(Sno);
SELECT * FROM Student;

------ 7.2.2 ʵ�������Լ���ΥԼ���� ------
--���� 7-4���� Student ���в����¼
INSERT INTO Student VALUES(NULL, '����','��', 17 ,'�������ѧ����ѧԺ');
--- ���� 7-5���ظ�ִ�� Student ���ϵĲ������
INSERT INTO Student VALUES('20053409', '����','��', 17 ,'�������ѧ����ѧԺ');

------ 7.3.1 ���������Զ��� ------
DROP TABLE Course;
create table Course(
Cno char(4) primary key,
Cname varchar(40) not null,
Cpno char(4),
Ccredit smallint,
foreign key(Cpno) references Course(Cno)
);
--���� 7-6������ SC �еĲ���������
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

------ 7.4.1 �û����������Զ��� ------
--���� 7-7���������ݱ�ָ�������� Grade ��ȡֵ��ΧΪ 0��100��
CREATE TABLE SC(
	Sno CHAR(9),
	Cno CHAR(4),
	Grade SMALLINT CHECK(Grade >=0 AND Grade <=100),
	PRIMARY KEY(Sno, Cno),
	FOREIGN KEY(Sno) REFERENCES Student(Sno),
	FOREIGN KEy(Cno) REFERENCES Course(Cno)
);
-- ���� 7-8������ table1��ָ�� c1 �ֶβ��ܰ����ظ�ֵ��c2 �ֶ�ֻ��ȡ�ض�ֵ��
DROP TABLE table1;
CREATE TABLE table1(
	c1 CHAR(2) UNIQUE,
	c2 CHAR(4) CHECK (c2 in('0000', '0001', '0002', '0003')),
	c3 INT DEFAULT 1
);

------ 7.4.2 �û�����������Լ���ΥԼ���� ------
SELECT * FROM table1;
--(1)
INSERT INTO table1 (c1,c2) VALUES ('10', '0000');
--(2)
INSERT INTO table1 VALUES ('10', '0001', 2);
--(3)
UPDATE table1 SET c2= '1111' WHERE c1='10';
--(4)
UPDATE table1 SET c2= '0002' WHERE c1='10';--����Լ������