### 数据查询 ###
USE School;
#查询语句的格式为：
/*SELECT [ALL|DISTINCT] <目标表列> 
FROM <基本表或视图名> [,<基本表或视图名>]…
[WHERE <条件表达式 1>]
[GROUP BY <列名 l> [HAVING <条件表达式 2>]]
[ORDER BY <列名 2> [ASC| DESC]];*/

-- Student数据
insert into `School`.`Student`
(`Sno`,`Sname`,`Ssex`,`Sage`,`Sdept`) values
("201215121","李勇","男",20,"CS"),
("201215122","刘晨","女",19,"CS"),
("201215123","王敏","女",18,"MA"),
("201215125","张立","男",19,"IS");
/*INSERT INTO Student(`Sno`,`Sname`,`Ssex`,`Sage`,`Sdept`)
value("201215127", '王敏', '女', 19, 'CS');*/
SELECT * FROM Student;
-- Course数据
#course数据
insert into Course(Cno, Cname, Ccredit)values
("1", "数据库", 4),
("2", "数学", 2),
("3", "信息系统", 4),
("4", "操作系统", 3),
("5", "数据结构", 4),
("6", "数据处理", 2),
("7", "PASCALL", 4);
SELECT * FROM Course;

-- SC数据
insert into SC(Sno, Cno, Grade)values
("201215121", "1", 92),
("201215121", "2", 82),
("201215121", "3", 88),
("201215122", "2", 90),
("201215122", "3", 80);
INSERT INTO SC(Sno, Cno) value ("201215125", "5");
INSERT INTO SC(Sno, Cno, Grade) value ("201215123", "1");
update SC set Grade = "90" where Sno = "201215123";
SELECT * FROM SC;

### 1.单表查询
-- 【例 4-11】查询计算机系学生的学号和姓名。
SELECT Sno, Sname from Student WHERE Sdept = 'CS';
-- 【例 4-12】查询选修了课的学生学号，并按学号升序排列。
SELECT DISTINCT Sno FROM SC ORDER BY Sno;
-- 【例 4-14】查询学生的学号和出生年份。
SELECT Sno, 2021-Sage FROM Student;

-- 聚集函数
-- 【例 4-15】查询选修了每门课的学生人数。
SELECT Cno, COUNT(*) FROM SC GROUP BY Cno;
-- 【例 4-16】查询平均成绩在85分以上的学生的学号和平均成绩。
SELECT Sno, AVG(Grade) FROM SC GROUP BY Sno;
SELECT Sno, AVG(Grade) FROM SC GROUP BY Sno HAVING AVG(Grade) > 86;
-- 【例 4-17】查询成绩在 75－85 分之间的学生的学号和平均成绩。
SELECT Sno, AVG(Grade) FROM SC 
	WHERE Grade BETWEEN 75 AND 85 
	GROUP BY Sno ;
-- 【例 4-18】查询年龄为20所有姓李的学生姓名
SELECT Sname FROM Student
	WHERE Sname LIKE '李%' AND Sage = 20;
-- 【例 4-19】查询缺考学生的学号和课程号
SELECT Sno, Cno FROM SC
	WHERE Grade IS NULL;

# 2.连接查询:涉及两个或两个以上表的查询
-- 【例 4-20】查询成绩在70～80分之间的学生学号和姓名。
SELECT Sname, Student.Sno  FROM Student, SC
	WHERE (Grade BETWEEN 70 AND 80)
    AND SC.Sno = Student.Sno;
-- 【例 4-21】查询缺考学生的学号、姓名和缺考的课程名
SELECT Student.Sno, Sname, SC.Cno 
	from Student, SC
	WHERE (Grade IS NULL) AND SC.Sno = Student.Sno;
-- 【例 4-22】查询与李利在同一个系的学生
INSERT INTO Student(`Sno`,`Sname`,`Ssex`,`Sage`,`Sdept`) 
VALUE("201215126","李利","男",19, "CS");
SELECT S2.* FROM Student AS S2, Student AS S1
	WHERE(S1.Sname = '李利' AND S2.Sdept = S1.Sdept);
-- 【例 4-23】查询计算机系学生选修了数据库课的平均成绩
SELECT Student.Sdept AS '计算机系', AVG(Grade) AS '数据库平均成绩'
	FROM Student, SC, Course
    WHERE (Student.Sdept='CS' AND Course.Cname='数据库' 
    AND SC.Cno = Course.Cno AND SC.Sno = Student.Sno);
-- 【例 4-24】查询计算机系学生的选课情况
SELECT Student.*, SC.*
	FROM Student LEFT JOIN SC ON Student.Sno = SC.Sno
    where Student.Sdept="CS";

### 3.嵌套查询
-- 【例 4-25】查询与学生李利在同一个系的学生信息。
-- method 1(不相关子查询):
SELECT Student.* FROM Student
	WHERE Student.Sdept IN(
    SELECT Sdept FROM Student WHERE Sdept = 'CS');
-- method 2(相关子查询):
SELECT S1.* FROM Student AS S1
	WHERE EXISTS(SELECT S2.* FROM Student AS S2
    WHERE (S2.Sname='李利' AND S2.Sdept = S1.Sdept));
-- 【例 4-26】查询没有选1号课的学生姓名。
-- method 1(NOT EXISTS)
SELECT Sname FROM Student
	WHERE NOT EXISTS(SELECT * FROM SC 
    WHERE (SC.Cno='1' AND SC.Sno = Student.Sno));
-- method 1(NOT IN )
SELECT Sname FROM Student
	WHERE Sno NOT IN(SELECT Sno FROM SC WHERE (SC.Cno='1'));
-- 【例 4-27】查询选修了所有课的学生姓名
-- 在查询结果中的学生，不存在一门课是他没选的(SQL没有全称量词)
SELECT Sname FROM Student
	WHERE NOT EXISTS(SELECT * FROM Course
    WHERE NOT EXISTS(SELECT * FROM SC WHERE(
    Course.Cno=SC.Cno AND SC.Sno = Student.Sno)));
-- 【例 4-28】查询选修了1号课且成绩比王敏高的学生姓名。
SELECT Sname FROM Student, SC
	WHERE Cno='1' AND Student.Sno = SC.Sno AND SC.Grade > 
    (SELECT Grade FROM Student, SC
    WHERE Sname='王敏' AND SC.Cno='1' AND Student.Sno = SC.Sno);
-- 【例 4-29】查询选修了1号课且成绩最低的学生的学号
-- method 1
SELECT Sno FROM SC WHERE Cno='1' AND Grade <= 
	ALL(SELECT Grade FROM SC WHERE Cno='1');
-- method 2
SELECT Sno FROM SC WHERE Cno='1' AND Grade = 
	(SELECT MIN(Grade) FROM SC WHERE Cno='1');
    
#3.集合查询
-- 【例 4-30】查询计算机系的学生的学号以及选修了1号课的学生的学号的并集.
SELECT * FROM Student;
SELECT * FROM SC;
SELECT Sno FROM Student WHERE Sdept='CS' UNION 
SELECT Sno FROM SC WHERE Cno='1';
-- 【例 4-31】查询选修了1号课的学生姓名与计算机系选修了1号课的学生姓名的差集。(MYSQL不支持MINUS)
--  即非计算机学院选了1号课程
SELECT Sname FROM SC, Student
	WHERE SC.Sno=Student.Sno AND SC.Cno='1' AND Student.Sdept!='CS';
-- 【例 4-32】查询选修了1号课的学生姓名与选修了2号课的学生姓名的交集。(MYSQL不支持INTERSECT)
-- 即同时选修了1号课和2号课的学生姓名
SELECT * FROM Student, SC;
SELECT Sname FROM Student, SC
	WHERE SC.Sno=Student.Sno AND 
    NOT EXISTS(SELECT *FROM Course WHERE (Cno='1' or Cno='2')  AND
    NOT EXISTS(SELECT * FROM SC WHERE SC.Cno=Course.Cno 
    AND Student.Sno= SC.Sno));