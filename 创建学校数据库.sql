CREATE SCHEMA School ;
use School;
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
primary key(Sno, Cno),#主码有两个属性构成
foreign key(Sno) references Student(Sno),
foreign key(Cno) references Course(Cno)
);
#student数据
insert into `School`.`Student`
(`Sno`,`Sname`,`Ssex`,`Sage`,`Sdept`) values
("201215121","李勇","男",20,"CS"),
("201215122","刘晨","女",19,"CS"),
("201215123","王敏","女",18,"MA"),
("201215125","张立","男",19,"IS");

#course数据
insert into Course(Cno, Cname, Ccredit)values
("1", "数据库", 4),
("2", "数学", 2),
("3", "信息系统", 4),
("4", "操作系统", 3),
("5", "数据结构", 4),
("6", "数据处理", 2),
("7", "PASCALL", 4);

insert into Course(Cno, Cname, Cpno,Ccredit) values("8", "软件工程", "6", 2);

update Course
set Cpno = "5"
where Cno = "1";

update Course
set Cpno = "1"
where Cno = "3";

update Course
set Cpno = "6"
where Cno = "4";

update Course
set Cpno = "7"
where Cno = "5";

update Course
set Cpno = "6"
where Cno = "7";

#SC数据
insert into SC(Sno, Cno, Grade)values
("201215121", "1", 92),
("201215121", "2", 82),
("201215121", "3", 88),
("201215122", "2", 90),
("201215122", "3", 80);

select * from Student;
select * from Course;
select * from SC;

#drop database School;
