### 4.7.5 动态 SQL###
# 1. 立即执行的动态 SQL
/** 
EXEC SQL EXECUTE IMMEDIATE <主变量>; 
*/
-- 【例 4-66】 通过输入SQL语句，立即执行动态 SQL。
/*
scanf (“%s”,dstring);
EXEC SQL EXECUTE IMMEDIATE :dstring;
*/
# 2.非立即执行的动态 SQL
/**
 预处理 SQL 语句格式为：
	SQL EXEC PREPARE <语句名> FROM <主变量>;
 非立即执行的 EXECUTE 语句格式为：
	SQL EXEC EXECUTE <语句名> [USING <主变量>];
*/
-- 【例 4-67】动态 SQL 语句经预处理后再执行。
/**
strcpy (dstring, "UPDATE SC SET Grade=:g WHERE Cno='C005' "); 
EXEC SQL PREPARE S1 FROM :dstring;
EXEC SQL EXECUTE S1 USING :HGrade;
*/