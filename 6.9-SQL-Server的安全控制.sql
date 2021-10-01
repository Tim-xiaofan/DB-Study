-- 6.9 SQL Server 的安全控制
Use School;

-- 2. 对 SQL Server 登录进行管理
--（1）创建登录:sp_addlogin 则使用SQL Server身份验证为SQL Server连接定义登录帐户
/**
sp_addlogin [ @loginame = ] 'login'
 [ , [ @passwd = ] 'password' ]
 [ , [ @defdb = ] 'database' ]
 [ , [ @deflanguage = ] 'language' ]
 [ , [ @sid = ] sid ]
 [ , [ @encryptopt = ] 'encryption_option' ]
*/
--【例 6-2】为用户 Albert 创建一个 SQL Server 登录，并指定密码 food 以及名为corporate 的默认数据库。
EXEC sp_addlogin 'Albert','food1234A' ,'School';
--（2）删除登录
/**sp_droplogin [ @loginame = ] 'login'*/
--【例 6-3】从SQL Server中删除登录 Albert。
EXEC sp_droplogin 'Albert';
-- 6.9.3 数据库用户管理
--（1）创建数据库用户

/**
sp_grantdbaccess [@loginame =] 'login' [,[@name_in_db =] 'name_in_db' [OUTPUT]]
*/
--【例 6-4】在当前数据库中为 Windows NT 用户 Corporate\GeorgeW 添加帐户，并取名为 Georgie。
EXEC sp_grantdbaccess 'Corporate\GeorgeW', 'Georgie';
--（2）删除数据库用户
/** sp_revokedbaccess [ @name_in_db = ] 'name'*/
EXEC sp_revokedbaccess 'Corporate\GeorgeW' ;
--（3）查看数据库用户
/** sp_helpuser [ [ @name_in_db = ] 'security_account' ]*/
--【例 6-6】列出所有用户和列出用户 dbo 的信息的语句如下：
EXEC sp_helpuser 'dbo';
EXEC sp_helpuser 'guest';
-- 【例 6-7】给用户 Mary 和 John 以及 Windows NT 组 Corporate\BobJ 授予多个语句权限
GRANT CREATE DATABASE, CREATE TABLE TO Mary, John, [Corporate\BobJ];