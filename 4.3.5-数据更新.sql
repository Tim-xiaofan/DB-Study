### 数据更新：插入（INSERT）、删除(DELETE)和修改(UPDATE) ###
USE School;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM SC;
#1.插入 INSERT INTO <表名>[(<列名 1>[, <列名 2>, ...])] VALUES (<常量 1> [, <常量 2>...])；
-- 【例 4-33】在学生表中插入一个学生元组，其学号为 101215，姓名为李斌，男，19岁，是计算机系的学生
INSERT INTO Student VALUES ('101215', '李斌', '男', 19, 'CS');
INSERT INTO Student VALUES ('101253', '李白', '男', 19, 'MATH');
-- 【例 4-34】学号为 101253 的学生选了 C2 号课，将其插入选课表中。
INSERT INTO Course(Cno, Cname, Ccredit) VALUES ('C2', 'YUWEN', 5);
INSERT INTO SC(Sno, Cno) VALUES('101253', 'C2');
-- 【例 4-35】计算计算机系学生的平均成绩，并保存在 CS-AVG 表中。
DROP TABLE CS_AVG;
CREATE TABLE CS_AVG(
	Sno CHAR(9) NOT NULL,
    Grade SMALLINT,
    PRIMARY KEY(Sno));

INSERT INTO CS_AVG(Sno, Grade)
SELECT Sno, AVG(Grade) FROM SC
WHERE Sno IN (SELECT Sno FROM Student WHERE Sdept='CS') GROUP BY Sno;

SELECT * FROM CS_AVG;

SHOW TABLES;

#2.修改
/** 
UPDATE <表名> 
 SET 列名 1 = <表达式 1>[，列名 2 = <表达式 2>]
 [WHERE <条件表达式>];
*/
-- 【例 4-36】修改数据库课的学分为5。
SET SQL_SAFE_UPDATES = 0;
UPDATE Course SET Ccredit='5' WHERE Cname='数据库';
-- 【例 4-37】将所有学生的年龄增加 1 岁。
UPDATE Student SET Sage=Sage+1;
-- 【例 4-38】将所有选修了数据库课的学生的成绩清空。
UPDATE SC SET Grade=NULL
	WHERE Cno IN(
    SELECT Cno FROM Course WHERE Cname='数据库'
    );

#3. 删除
/**
DELETE FROM <表名>
 [WHERE <条件表达式>];
*/
-- 【例 4-39】删除学号为201225的学生记录。
INSERT INTO Student VALUES ('201255', '杜甫', '男', 18, 'PHYSICS');
DELETE FROM Student WHERE Sno='201255';
-- 【例 4-40】删除所有选修数据库课学生的选课信息。
DELETE FROM SC WHERE Cno IN
	(SELECT Cno FROM Course WHERE Cname='数据库');