------7.6 SQL Server 中数据库完整性的实现------

------1. CHECK 约束-----
--【例 7-11】创建数据表时建立 CHECK 约束
CREATE DATABASE Company;
USE Company;
CREATE TABLE jobs(
	job_id smallint IDENTITY(1,1) PRIMARY KEY,
	job_desc varchar(50) NOT NULL DEFAULT 'New Position - title not formalized yet',
	min_lvl tinyint NOT NULL CHECK (min_lvl >= 10),
	max_lvl tinyint NOT NULL CHECK (max_lvl <= 250)
);
--【例 7-12】为 Employees 表中的 BrithDate 增加 CHECK 约束，使出生日期处于可接受的日期范围内
DROP TABLE Employees;
CREATE TABLE Employees(
	BirthDate date
);
SELECT * FROM Employees;
ALTER TABLE Employees ADD 
	CONSTRAINT CK_bithdate 
	CHECK(BirthDate > '01-01-2020' AND Birthdate < GETDATE());

-----2. PRIMARY KEY 约束------
--【例 7-13】使用 SQL 语句建立主键约束
CREATE TABLE publishers(
	pub_id char(4) NOT NULL PRIMARY KEY CHECK (pub_id IN ('1389', '0736', '0877', '1622', '1756') OR pub_id LIKE '99[0-9][0-9]'),
	pub_name varchar(40) ,
	city varchar(20),
	state char(2) NULL,
	country varchar(30)
);

--【例 7-14】 在 Customers 表上创建 PRIMARY KEY 约束，指明表的主键值是CustomerID
CREATE TABLE Customers(
	CustomerID char(4) NOT NULL,
	CustomerName char(40) NOT NULL
);
ALTER TABLE Customers ADD
	CONSTRAINT PK_Customers
	PRIMARY KEY(CustomerID);
SELECT *FROM Customers;

--【例 7-15】employee 表上引用 jobs 表和 publishers 表的列作为 FOREIGN KEY 约束
