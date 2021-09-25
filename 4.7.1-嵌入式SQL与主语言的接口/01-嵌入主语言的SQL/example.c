#include <stdio.h>
#include <string.h>
EXEC SQL BEGIN DECLARE SECTION; /*定义主变量*/
CHAR uid(20);
CHAR pwd(20);
CHAR hsno(6);
CHAR hcno(6);
INT hgrade;
EXEC SQL END DECLARE SECTION; 
EXEC SQL INCLUDE SQLCA; /*定义 SQL 通讯区*/
int main(int ac, char * av[])
{
    char g(6);
    strcpy(uid, "SA");
    strcpy(pwd, "CRT");
    EXEC SQL CONNECT :uid IDENTIFIED BY : pwd /*建立与 DBMS 的连接*/
        Scanf ("%s", hcno); /*输入要查询的课程号*/
    EXEC SQL DECLARE C1 CURSOR FOR
        SELECT Sno, Grade 
        FROM SC
        WHERE Cno=:hcno ; /* (定义游标)*/
    EXEC SQL OPEN C1; /* (打开游标)*/
    while(1)
    {
        EXEC SQL FETCH C1 INTO :hsno, :hgrade; /*(推进游标)*/ 
        if (sqlca.sqlcode == 0)
          break;
        if (hgrade >= 85)
          g = "优";
        else if((hgrade < 85) && (hgrade >= 75))
          g = "良";
        else if ((hgrade <75) && (hgrade >= 60))
          g = "及格";
        else g="不及格";
        printf("sno: %s grade: %s\n", hsno, g)
    };
    EXEC SQL CLOSE C1; /*（关闭游标）*/
    EXEC SQL COMMIT WORK RELEASE; /*提交事务，退出 DBMS*/
    exit(0);
}
