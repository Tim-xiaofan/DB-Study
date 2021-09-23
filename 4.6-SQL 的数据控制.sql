### 4.6 SQL的数据控制 ###
SHOW DATABASES;
USE mysql;
SHOW TABLES;
SELECT * FROM user;

#4.6.1 授权
/**
GRANT {<权限 1>, <权限 2>, …}
 ON [主人.] <表名或视图名>
 TO {<用户名 1>,<用户名 2>, … | PUBLIC}
 [WITH GRANT OPTION];
*/
CREATE USER 'User1'@'%' IDENTIFIED BY 'User1';
CREATE USER 'User2'@'%' IDENTIFIED BY 'User2';
CREATE USER 'User3'@'%' IDENTIFIED BY 'User3';
CREATE USER 'User4'@'%' IDENTIFIED BY 'User4';
-- 【例 4-54】授予用户 User1 在表 Student 上的查询权。
GRANT SELECT ON TABLE School.Student TO User1;
FLUSH PRIVILEGES;
-- 【例 4-55】授予用户 User2 在表 Student 上的查询权和删除权，同时使 User2 拥有将
-- 所得权限授予其他用户的权力。
GRANT SELECT, DELETE
	ON TABLE School.Student TO User2
    WITH GRANT OPTION;
FLUSH PRIVILEGES; -- User2可以通过执行如下语句将拥有的权限授予其他用户，如用户 User3
-- 【例 4-56】授予用户 User4 对表 SC 中的列 Grade 的修改权。
GRANT UPDATE(Grade)
	ON TABLE School.SC TO User4;
-- 【例 4-57】 把学生表 Student 上的查询权授予所有用户。
GRANT SELECT
	ON TABLE School.Student
    TO PUBLIC; -- MYSQL不支持

#4.6.2 权限回收
/**
REVOKE {<权限 1>, <权限 2>, …} 
 ON [主人.] <表名或视图名>
 FROM {<用户名 1>,<用户名 2>, … | PUBLIC}
 [RESTRICT|CASCADE];
 */
 -- 【例 4-58】回收用户 User2 对学生表 Student 的查询权和删除权。
 REVOKE SELECT, DELETE
	ON School.Student
    FROM User2 CASCADE; -- MYSQL不支持CASCADE