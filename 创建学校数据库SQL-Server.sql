CREATE DATABASE School;
USE School;
create table Student(
Sno char(9) primary key,
Sname varchar(20) unique,
Ssex char(2),
Sage smallint,
Sdept varchar(20)
);
create table Course(
Cno char(4) primary key,
Cname varchar(40) not null,
Cpno char(4),
Ccredit smallint,
foreign key(Cpno) references Course(Cno)
);
create table SC(
Sno char(9),
Cno char(4),
Grade smallint,
primary key(Sno, Cno), --�������������Թ���
foreign key(Sno) references Student(Sno),
foreign key(Cno) references Course(Cno)
);
-- student����
insert into Student
(Sno,Sname,Ssex,Sage,Sdept) values
('201215121','����','��',20,'CS'),
('201215122','����','Ů',19,'CS'),
('201215123','����','Ů',18,'MA'),
('201215124','����','Ů',18,'CS'),
('201215125','����','��',19,'IS'),
('201215126','����','Ů',18,'CS'),
('201215127','��Ԫ�','��',18,'����ϵ');

-- course����
insert into Course(Cno, Cname, Ccredit)values
('1', '���ݿ�', 4),
('2', '��ѧ', 2),
('3', '��Ϣϵͳ', 4),
('4', '����ϵͳ', 3),
('5', '���ݽṹ', 4),
('6', '���ݴ���', 2),
('7', 'PASCALL', 4);
insert into Course(Cno, Cname, Ccredit)values
('C1', '���ݿ�', 4),
('C2', '�ߵ���ѧ', 5),
('C3', '��Ϣϵͳ', 4),
('C12', '��ɢ��ѧI', 4),
('C02', '��ʷ', 5);

insert into Course(Cno, Cname, Cpno,Ccredit) values('8', '�������', '6', 2);

/* update Course
set Cpno = '5'
where Cno = '1';

update Course
set Cpno = '1'
where Cno = '3';

update Course
set Cpno = '6'
where Cno = '4';

update Course
set Cpno = '7'
where Cno = '5';

update Course
set Cpno = '6'
where Cno = '7';*/

-- SC����
insert into SC(Sno, Cno, Grade)values
('201215121', '1', 92),
('201215121', '2', 82),
('201215121', '3', 88),
('201215122', '2', 90),
('201215122', '3', 80),
('201215124', '2', 91),
('201215124', '3', 95),
('201215127', 'C02', 89);

insert into SC(Sno, Cno, Grade)values
('201215121', 'C1', 92),
('201215121', 'C2', 82),
('201215121', 'C3', 88),
('201215122', 'C2', 90),
('201215122', 'C1', 80);

select * from Student;
select * from Course;
select * from SC;
-- SET SQL_SAFE_UPDATES = 0;
-- drop database School;
-- use master;
