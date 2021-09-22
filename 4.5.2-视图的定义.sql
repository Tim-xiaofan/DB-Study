### 4.5.1 视图的定义 ###
#1.视图的定义
/**
CREATE VIEW<视图名>[(<列名 1>[, <列名 2>])]
 AS <SELECT 语句> 
 [WITH CHECK OPTION]; 
*/
SHOW DATABASES;
USE School;
-- 【例 4-41】建立年龄小于 23 岁的学生视图，并要求数据更新时进行检查。
CREATE VIEW Sage_23
	AS SELECT * FROM Student WHERE Sage < 23
    WITH CHECK OPTION;
SELECT * FROM Sage_23;
-- 【例 4-42】按系建立学生平均年龄的视图。
SELECT * FROM Student;
CREATE VIEW D_Sage(Sdept, Avgage)
	AS SELECT Sdept, AVG(Sage)
    FROM Student GROUP BY Sdept;
SELECT * FROM D_Sage;
-- 【例 4-43】建立计算机系选修了C2课的学生学号,姓名和成绩的视图。
SELECT * FROM Student, SC WHERE Student.Sno = SC.Sno;
-- DROP VIEW CS_SC;
CREATE VIEW CS_SC(Sno, Snam, Grade)  AS
	SELECT Student.Sno, Student.Sname, Grade 
    FROM Student, SC WHERE Student.Sno=SC.sno AND SC.Cno='C2'
    AND Student.Sdept='CS';
SELECT * FROM CS_SC;
-- 【例 4-44】建立计算机系选修了C2课且成绩在90分及以上的学生视图。
CREATE VIEW CS_90
	AS SELECT * FROM CS_SC WHERE Grade >= 90;-- 在已建立的视图上定义视图，以简化视图定义中的条件
SELECT * FROM CS_90;

#2. 删除视图
/** DROP VIEW <视图名>*/
DROP VIEW CS_90;