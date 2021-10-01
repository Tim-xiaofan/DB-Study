-- 6.9 SQL Server �İ�ȫ����
Use School;

-- 2. �� SQL Server ��¼���й���
--��1��������¼:sp_addlogin ��ʹ��SQL Server�����֤ΪSQL Server���Ӷ����¼�ʻ�
/**
sp_addlogin [ @loginame = ] 'login'
 [ , [ @passwd = ] 'password' ]
 [ , [ @defdb = ] 'database' ]
 [ , [ @deflanguage = ] 'language' ]
 [ , [ @sid = ] sid ]
 [ , [ @encryptopt = ] 'encryption_option' ]
*/
--���� 6-2��Ϊ�û� Albert ����һ�� SQL Server ��¼����ָ������ food �Լ���Ϊcorporate ��Ĭ�����ݿ⡣
EXEC sp_addlogin 'Albert','food1234A' ,'School';
--��2��ɾ����¼
/**sp_droplogin [ @loginame = ] 'login'*/
--���� 6-3����SQL Server��ɾ����¼ Albert��
EXEC sp_droplogin 'Albert';
-- 6.9.3 ���ݿ��û�����
--��1���������ݿ��û�

/**
sp_grantdbaccess [@loginame =] 'login' [,[@name_in_db =] 'name_in_db' [OUTPUT]]
*/
--���� 6-4���ڵ�ǰ���ݿ���Ϊ Windows NT �û� Corporate\GeorgeW ����ʻ�����ȡ��Ϊ Georgie��
EXEC sp_grantdbaccess 'Corporate\GeorgeW', 'Georgie';
--��2��ɾ�����ݿ��û�
/** sp_revokedbaccess [ @name_in_db = ] 'name'*/
EXEC sp_revokedbaccess 'Corporate\GeorgeW' ;
--��3���鿴���ݿ��û�
/** sp_helpuser [ [ @name_in_db = ] 'security_account' ]*/
--���� 6-6���г������û����г��û� dbo ����Ϣ��������£�
EXEC sp_helpuser 'dbo';
EXEC sp_helpuser 'guest';
-- ���� 6-7�����û� Mary �� John �Լ� Windows NT �� Corporate\BobJ ���������Ȩ��
GRANT CREATE DATABASE, CREATE TABLE TO Mary, John, [Corporate\BobJ];