### 索引的建立和删除 ###
USE School;
#建立索引 ：CREATE [UNIQUE] [CLUSTER] INDEX <索引名> 
#ON <基本表名> (<列名> [<次序>] [，<列名> [<次序>],...]);
#【例 4-8】在学生表Student 的列学号上按升序建立惟一索引。
CREATE UNIQUE INDEX S_SNO ON Student(Sno ASC);
#【例 4-9】在学生表 Student 上，班级按降序、年龄按升序建立索引。
CREATE INDEX SCLASS_AGE ON Student(CLASS DESC, Sage ASC);

#查看索引
SELECT * FROM Student;
SHOW INDEX FROM Student;

#删除索引的语句格式为：DROP INDEX <索引名>;
#【例 4-10】删除学生表上建立的 SSNO 索引
DROP INDEX S_SNO on Student;#mysql 需要指定表名