------7.6 SQL Server �����ݿ������Ե�ʵ��------

------1. CHECK Լ��-----
--���� 7-11���������ݱ�ʱ���� CHECK Լ��
CREATE DATABASE Company;
USE Company;
CREATE TABLE jobs(
	job_id smallint IDENTITY(1,1) PRIMARY KEY,
	job_desc varchar(50) NOT NULL DEFAULT 'New Position - title not formalized yet',
	min_lvl tinyint NOT NULL CHECK (min_lvl >= 10),
	max_lvl tinyint NOT NULL CHECK (max_lvl <= 250)
);
--���� 7-12��Ϊ Employees ���е� BrithDate ���� CHECK Լ����ʹ�������ڴ��ڿɽ��ܵ����ڷ�Χ��
DROP TABLE Employees;
CREATE TABLE Employees(
	BirthDate date
);
SELECT * FROM Employees;
ALTER TABLE Employees ADD 
	CONSTRAINT CK_bithdate 
	CHECK(BirthDate > '01-01-2020' AND Birthdate < GETDATE());

-----2. PRIMARY KEY Լ��------
--���� 7-13��ʹ�� SQL ��佨������Լ��
CREATE TABLE publishers(
	pub_id char(4) NOT NULL PRIMARY KEY CHECK (pub_id IN ('1389', '0736', '0877', '1622', '1756') OR pub_id LIKE '99[0-9][0-9]'),
	pub_name varchar(40) ,
	city varchar(20),
	state char(2) NULL,
	country varchar(30)
);

--���� 7-14�� �� Customers ���ϴ��� PRIMARY KEY Լ����ָ���������ֵ��CustomerID
CREATE TABLE Customers(
	CustomerID char(4) NOT NULL,
	CustomerName char(40) NOT NULL
);
ALTER TABLE Customers ADD
	CONSTRAINT PK_Customers
	PRIMARY KEY(CustomerID);
SELECT *FROM Customers;

--���� 7-15��employee �������� jobs ��� publishers �������Ϊ FOREIGN KEY Լ��
