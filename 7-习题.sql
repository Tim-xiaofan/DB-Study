------习题7------
------第10题------
USE Company;
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';
--salaried-worker (name, office, phone, salary)
CREATE TABLE salary_worker(
	 name char(40) PRIMARY KEY,
	 office char(40),
	 phone char(11),
	 salary int
);
INSERT INTO salary_worker(name) VALUES('李四');
SELECT * FROM salary_worker;
--hourly-worker (name, hourly-wage)
CREATE TABLE hourly_worker(
	name char(40) PRIMARY KEY,
	hourly_wage int
);
INSERT INTO hourly_worker(name) VALUES('李四');
SELECT * FROM hourly_worker;
--address (name, street, city)
DROP TABLE address;
CREATE TABLE address(
	name char(40) PRIMARY KEY,
	street char(40),
	city char(40)
);
SELECT *FROM address;

CREATE TRIGGER addr_trig
ON address AFTER INSERT,UPDATE
AS 
	IF EXISTS(SELECT INSERTED.name FROM INSERTED
		WHERE EXISTS(SELECT *FROM salary_worker JOIN hourly_worker ON
			salary_worker.name = hourly_worker.name 
			WHERE salary_worker.name = INSERTED.name))
		BEGIN
			RAISERROR (15600,-1,-1, '不允许address中的name同时存在salary_worker和hourly_worker中');
			ROLLBACK TRANSACTION
		END
INSERT INTO address(name) VALUES('李四');
INSERT INTO address(name) VALUES('张三');
UPDATE address set name='李四' WHERE name='张三';




/**
------第12题------
books (编号，书名，出版社，定价) 
readers (编号，姓名，读者类型，已借数量)
borrowinf (图书编号，读者编号，借期，还期)
readertype (类型编号，类型名称)
*/
DROP DATABASE library;
CREATE DATABASE library;
USE library;
-- books (编号，书名，出版社，定价) 
CREATE TABLE books(
	book_no char(20) PRIMARY KEY,
	book_name char(40) NOT NULL,
	book_publisher char(40),
	book_price float(2)
);
INSERT INTO books VALUES('1', '朝花夕拾', '人民教育出版社', 27.80);
INSERT INTO books VALUES('2', '聊斋志异', '上海商务出版社', 17.8);
INSERT INTO books VALUES('3', '梦溪笔谈', '海南出版社', 25.5);
INSERT INTO books VALUES('4', '算法导论', '机械工业出版社', 78);
INSERT INTO books VALUES('5', '数据库系统概论', '高等教育出版社', 39.60);
INSERT INTO books VALUES('6', '离散数学', '高等教育出版社', 37.00);
SELECT * FROM books;
--readertype (类型编号，类型名称)
CREATE TABLE readertype(
	type_no char(10) PRIMARY KEY,
	type_name char(40) NOT NULL
);
INSERT INTO readertype VALUES('3', '个人');
SELECT * FROM readertype;
--readers (编号，姓名，读者类型，已借数量)
DROP TABLE readers;
CREATE TABLE readers(
	reader_no char(20) PRIMARY KEY,
	reader_name char (20) NOT NULL,
	reader_typeno char(10) DEFAULT '3',
	reader_bcount smallint CHECK(reader_bcount >= 0),
	CONSTRAINT readers_fk FOREIGN KEY(reader_typeno) REFERENCES readertype(type_no)
);
INSERT INTO readers VALUES('1', '周树人', '3', 1);
INSERT INTO readers VALUES('2', '蒲松龄', '3', 6);
INSERT INTO readers VALUES('3', '王安石', '3', 5);
SELECT * FROM readers;
--borrowinf (图书编号，读者编号，借期，还期)
DROP TABLE borrowinf;
CREATE TABLE borrowinf(
	book_no char(20),
	reader_no char(20),
	borrow_date date NOT NULL,
	return_date date,
	CHECK(return_date >= borrow_date),
	PRIMARY KEY(book_no, reader_no),
	FOREIGN KEY(book_no) REFERENCES books(book_no),
	FOREIGN KEY(reader_no) REFERENCES readers(reader_no),
	DEFAULT DATEADD(month, 1, borrow_date) FOR return_date 
);
SELECT * FROM borrowinf;
--（1）Borrowinf 中“还期”不能小于“借期”，并且“还期”的缺省值为当前“借期”后 1 个月。
/**
RAISERROR (N'This is message %s %d.', -- Message text.  
           10(16), -- Severity,  
           1, -- State,  
           N'number', -- First argument.  
           5); -- Second argument. 
**/
DROP TRIGGER borrowinf_trig;
CREATE TRIGGER borrowinf_trig
ON borrowinf FOR INSERT
AS
	BEGIN
		DECLARE @_borrow_date date;
		DECLARE @_return_date date;
		DECLARE @_book_no char(20);
		DECLARE @_reader_no char(20);
		DECLARE @_str1 varchar(30);
		DECLARE @_str2 varchar(30);
		SELECT @_borrow_date=borrow_date, @_return_date = return_date,
			@_book_no=book_no, @_reader_no=reader_no
			FROM INSERTED;

		set @_str1 = cast(@_borrow_date as varchar);
		set @_str2 = cast(@_return_date as varchar);
		RAISERROR (N'@_borrow_date = %s, @_return_date = %s, @_book_no=%s, @_reader_no=%s.', 
			10, 1, @_str1, @_str2, @_book_no, @_reader_no);
		IF(@_return_date IS NULL)
		BEGIN
			RAISERROR (N'@_return_date IS NULL', 10, 1, @_str2);
			UPDATE borrowinf set return_date=DATEADD(month, 1, @_borrow_date)
				WHERE book_no = @_book_no AND reader_no = @_reader_no;
			--ROLLBACK TRANSACTION;
		END
	END 

DELETE borrowinf WHERE book_no='1';
INSERT INTO borrowinf(book_no, reader_no, borrow_date) VALUES('1','2', GETDATE());
SELECT * FROM borrowinf;
DELETE borrowinf WHERE book_no='1';
INSERT INTO borrowinf VALUES('1','2', GETDATE(), '2021-10-01');--“还期”不能小于“借期”






------第13题------
--（1）在 books 表中建立 UPDATE 触发器 tr1，若更新了 books 表中的图书编号，则相应更新 borrowinf 表的图书编号。
DROP TRIGGER tr1;
CREATE TRIGGER tr1 ON books
FOR UPDATE
AS
	BEGIN
		/*声明临时变量*/
		DECLARE @_book_no char(20)--new
		DECLARE @_book_no1 char(20)--old
		SELECT @_book_no=book_no FROM INSERTED
		SELECT @_book_no1=book_no FROM DELETED 
		UPDATE brrowinf SET book_no = @_book_no WHERE book_no = @_book_no1;
	END

SELECT * FROM borrowinf;
SELECT * FROM books;
UPDATE books SET book_no='2' WHERE book_no='1'; --参照完整性
--（2）（2） 在 readers 表中建立 DELETE 触发器 tr2，当删除 readers 表中的记录时，若borrowinf 表中有相应的借阅记录，则不允许删除该记录。（加了外键无法测试）

--（3）在 borrowinf 表中建立 INSERT 触发器 tr3，若某位读者当天借的书已超过5本，则不允许再借了。
DROP TRIGGER tr2;
CREATE TRIGGER tr2
ON borrowinf FOR INSERT
AS
	BEGIN
		DECLARE @_count int = 50;
		SELECT @_count=count(*) FROM borrowinf
			WHERE borrow_date=CAST(GETDATE() AS DATE) 
			AND reader_no = (SELECT reader_no FROM INSERTED);
		PRINT @_count;
		if(@_count > 5)
		BEGIN
			RAISERROR (15600,-1,-1, '读者当天借书不能超过5本');
			ROLLBACK TRANSACTION
		END
	END

DELETE borrowinf WHERE reader_no = '1';
SELECT * FROM borrowinf;
SELECT count(*) FROM borrowinf WHERE reader_no = '1';
SELECT count(*) FROM borrowinf WHERE borrow_date= CAST(GETDATE() AS DATE);
SELECT count(*) FROM borrowinf GROUP BY reader_no;
PRINT  CAST(GETDATE() AS DATE);
INSERT INTO borrowinf VALUES('1', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('2', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('3', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('4', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('5', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('6', '1', GETDATE(), DATEADD(month, 1, GETDATE()));


--（4）在 borrowinf 表中建立 INSERT 触发器 tr4，若新增借书记录则自动在表 readers的“已借数量”上增加 1。
DROP TRIGGER tr3;
CREATE TRIGGER tr3
ON borrowinf FOR INSERT
AS
BEGIN
	DECLARE @_reader_no char(20);
	SELECT @_reader_no=reader_no FROM INSERTED;
	UPDATE readers set reader_bcount = reader_bcount + 1 
		WHERE reader_no = @_reader_no;
END

DELETE borrowinf WHERE reader_no = '1';
SELECT * FROM readers;
INSERT INTO borrowinf VALUES('1', '1', GETDATE(), DATEADD(month, 1, GETDATE()));
INSERT INTO borrowinf VALUES('2', '1', GETDATE(), DATEADD(month, 1, GETDATE()));