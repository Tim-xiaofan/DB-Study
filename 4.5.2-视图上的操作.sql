/** 4.5.2 视图上的操作*/
USE School;
#1.查询
-- 【例 4-46】查询计算机系年龄小于 23 岁的学生。
SELECT * FROM Sage_23
	WHERE Sdept = 'CS';
-- 【例 4-47】查询专业系，要求学生的平均年龄小于 21 岁。
SELECT Sdept FROM D_Sage
	WHERE Avgage < 21;
-- 等价基本表
SELECT Sdept FROM Student
	GROUP BY Sdept
    HAVING AVG(Sage) < 21;

#2.更新
-- 【例 4-48】通过视图 Sage_23 插入学生刘敏的信息（'20041' ,'刘敏' ,21,'女','数学'）
INSERT INTO Sage_23(Sno, Sname, Ssex, Sage, Sdept)
	VALUE('20041', '刘敏', '女', 21 ,'数学');
-- 【例 4-49】通过视图 D_Sage 插入计算机系学生的平均年龄（'计算机'，21）。
INSERT INTO D_Sage VALUE('计算机', 21); #无法执行（平均年龄是计算得到）
-- 【例 4-50】通过视图 Sage_23 删除学生王茵的记录。
DELETE FROM Sage_23 WHERE Sname='王茵';
-- 【例 4-51】通过视图 CS_SC 删除学生刘明亮的信息。
DELETE FROM CS_SC WHERE Sname='刘明亮';#这样的删除操作涉及二个表，是不能执行的。
SELECT CURRENT_USER();