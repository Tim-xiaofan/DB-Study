---7.5 触发器
USE School;
SELECT * FROM Student;
INSERT INTO Student VALUES('20053409', '李贤','男', 17 ,'计算机科学技术学院');
SELECT * FROM Course;
INSERT INTO Course VALUES
('0004', '数据库', NULL, 3.5),
('0003', '数据结构', NULL, 5);
SELECT * FROM SC;
INSERT INTO SC VALUES
('20053409', '0003', 59),
('20053409', '0004', 61)
;
-----定义触发器-----
/**
CREATE TRIGGER <触发器名> 
 {BEFORE | AFTER} <触发事件> ON <表名>
 FOR EACH {ROW | STATEMENT}
 ［WHEN <触发条件>］
 <触发动作体>
**/

------删除触发器------
/**
删除触发器的 SQL 语法如下：
DROP TRIGGER <触发器名> ON <表名>;
**/

--【例 7-9】创建限制更新数据的触发器，限制将SC表中不及格学生的成绩改为及格。
CREATE TRIGGER tri_grade
ON SC FOR UPDATE
AS
	IF UPDATE (Grade)
			IF EXISTS (SELECT * FROM INSERTED JOIN DELETED
				ON INSERTED.Sno=DELETED.Sno
				WHERE INSERTED.Grade >= 60 AND
				DELETED.Grade < 60)
			BEGIN
				RAISERROR (15600,-1,-1, '不允许将不及格学生的成绩改为及格');  
				ROLLBACK
			END
-- 尝试
UPDATE SC SET Grade= 60 WHERE Grade < 60; --失败
UPDATE SC SET Grade= 100 WHERE Grade >= 60; --成功

--【例 7-10】创建删除触发器，当删除一本书的相关信息时，需要首先检查这本书是否
-- 已经被卖出过，即是否已经和订单关联，如果已经和订单关联则该书的信息不能被删除，
-- 删除动作需要回滚。
CREATE TRIGGER Products_Delete
ON Products FOR DELETE
AS
	IF (SELECT * COUNT (*)
		FROM [Order Details] INNER JOIN deleted 
		ON [Order Details].ProductID = deleted.ProductID
		) > 0
	BEGIN
		RAISERROR ('该产品有订购历史，事务无法进行。',10, 1)
		ROLLBACK TRANSACTION
	END