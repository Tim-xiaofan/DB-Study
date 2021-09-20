### 基本表的修改 ###
#对基本表的修改有：增加列、删除列级约束和修改列的数据类型
USE School;
#在学生表 Student 中增加一列，列名为：班级
SELECT * FROM Student;
ALTER TABLE Student ADD CLASS CHAR(8);
SELECT * FROM Student;

#修改学生表Student中姓名列的长度为 20
#ALTER TABLE Student ALTER Sname CHAR(20);#mysql不是此语句
ALTER TABLE Student MODIFY COLUMN Sname CHAR(20);

#删除基本表：DROP TABLE <表名> [CASCADE | RECTRICT]
DROP TABLE Student RESTRICT;#只有没有视图或参照约束表时才能删除，否则拒绝删除该表
DROP TABLE Student CASCADE;#表上建立的索引和表上定义的视图也一起被删除
DROP TABLE Student;
#mysql都无法删除Student