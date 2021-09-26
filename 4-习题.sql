USE School;
select * from Student where Sage<20 and Sdept='CS';
select Cno, Grade from Student, SC
        where Student.Sno=SC.Sno and Student.Sname='李勇';
select * from SC;
select Sname,Sdept from Student, SC 
		where SC.Sno=Student.Sno and
        not exists(select * from Course where (Cno='C1'or Cno= 'C2') and
		not exists(select * from SC where SC.Cno=Course.Cno and SC.Sno= Student.Sno));
select Student.Sno,Sname,Grade from SC, Student,Course
        where Student.Sno=SC.Sno and SC.Cno=Course.Cno and Course.Cname='数据库';
select sum(Grade) from SC,Student
        where Student.Sno=SC.Sno and Student.Sname='李勇';
select Sname,Sdept from Student
        where not exists(
        select Student.Sno=SC.Sno and SC.Cno!='1' and SC.Cno!='2');
select Sname,Sdept from Student
        where Sname like '李%';
select DISTINCT Sname from Student, SC
        where Student.Sno=SC.Sno and
        not exists(select * from Student as S1, SC as SC1 where S1.Sno=SC1.Sno and S1.Sname='刘晨'and 
        not exists(select * from SC where SC.Cno=SC1.Cno and SC.Sno=Sno)) and 
        exists (select * from Student as S1,SC as SC1 where S1.Sno=SC1.Sno and S1.Sname='刘晨' and
        SC1.Cno=SC.Cno);
select * from Course 
         where Cno in(select Cno from Student as S1,SC where S1.Sno=SC.Sno and S1.Sname='刘晨');
-- (9) 把信息系的学生“董南”选修的 C12 号课加入选课表中。
insert into SC(Sno, Cno)
        select Student.Sno, 'C12' from Student
        where Student.Sname='董南';
-- (10) 修改“数据结构”课的学分为 3.5 学分。
update Course set Ccredit=3.5 where Cname='数据结构';
-- (11) 删除所有“电子系”的学生所选修的 C02 号课。
delete from SC 
	where SC.Cno='C02' and 
	SC.Sno in (select Sno from Student where Sdept='电子系');
-- 8.(l ) 创建计算机系的学生选课视图，包括学号、姓名、课程名、成绩。
drop view CS_SC;
create view CS_SC as select Student.Sno,Sname,Cname, SC.Grade 
	from (Student left join SC on SC.Sno=Student.Sno) left join Course on SC.Cno=Course.Cno
    where Student.Sdept='CS';
select * from CS_SC;
select * from Student left join SC on Student.Sno=SC.Sno where Sdept='CS';
-- 8.(2) 通过(1)中创建的视图查询成绩在 70 分～85 分的学生姓名和课程名。
select Sname, Grade from CS_SC where Grade between 70 and 85;