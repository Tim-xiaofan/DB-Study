------ϰ��7------
------��10��------
USE Company;
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';
--salaried-worker (name, office, phone, salary)
CREATE TABLE salary_worker(
	 name char(40) PRIMARY KEY,
	 office char(40),
	 phone char(11),
	 salary int
);
INSERT INTO salary_worker(name) VALUES('����');
SELECT * FROM salary_worker;
--hourly-worker (name, hourly-wage)
CREATE TABLE hourly_worker(
	name char(40) PRIMARY KEY,
	hourly_wage int
);
INSERT INTO hourly_worker(name) VALUES('����');
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
			RAISERROR (15600,-1,-1, '������address�е�nameͬʱ����salary_worker��hourly_worker��');
			ROLLBACK TRANSACTION
		END
INSERT INTO address(name) VALUES('����');
INSERT INTO address(name) VALUES('����');
UPDATE address set name='����' WHERE name='����';




/**
------��12��------
books (��ţ������������磬����) 
readers (��ţ��������������ͣ��ѽ�����)
borrowinf (ͼ���ţ����߱�ţ����ڣ�����)
readertype (���ͱ�ţ���������)
*/
DROP DATABASE library;
CREATE DATABASE library;
USE library;
-- books (��ţ������������磬����) 
CREATE TABLE books(
	book_no char(20) PRIMARY KEY,
	book_name char(40) NOT NULL,
	book_publisher char(40),
	book_price float(2)
);
INSERT INTO books VALUES('1', '����Ϧʰ', '�������������', 27.80);
INSERT INTO books VALUES('2', '��ի־��', '�Ϻ����������', 17.8);
INSERT INTO books VALUES('3', '��Ϫ��̸', '���ϳ�����', 25.5);
INSERT INTO books VALUES('4', '�㷨����', '��е��ҵ������', 78);
INSERT INTO books VALUES('5', '���ݿ�ϵͳ����', '�ߵȽ���������', 39.60);
INSERT INTO books VALUES('6', '��ɢ��ѧ', '�ߵȽ���������', 37.00);
SELECT * FROM books;
--readertype (���ͱ�ţ���������)
CREATE TABLE readertype(
	type_no char(10) PRIMARY KEY,
	type_name char(40) NOT NULL
);
INSERT INTO readertype VALUES('3', '����');
SELECT * FROM readertype;
--readers (��ţ��������������ͣ��ѽ�����)
DROP TABLE readers;
CREATE TABLE readers(
	reader_no char(20) PRIMARY KEY,
	reader_name char (20) NOT NULL,
	reader_typeno char(10) DEFAULT '3',
	reader_bcount smallint CHECK(reader_bcount >= 0),
	CONSTRAINT readers_fk FOREIGN KEY(reader_typeno) REFERENCES readertype(type_no)
);
INSERT INTO readers VALUES('1', '������', '3', 1);
INSERT INTO readers VALUES('2', '������', '3', 6);
INSERT INTO readers VALUES('3', '����ʯ', '3', 5);
SELECT * FROM readers;
--borrowinf (ͼ���ţ����߱�ţ����ڣ�����)
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
--��1��Borrowinf �С����ڡ�����С�ڡ����ڡ������ҡ����ڡ���ȱʡֵΪ��ǰ�����ڡ��� 1 ���¡�
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
INSERT INTO borrowinf VALUES('1','2', GETDATE(), '2021-10-01');--�����ڡ�����С�ڡ����ڡ�






------��13��------
--��1���� books ���н��� UPDATE ������ tr1���������� books ���е�ͼ���ţ�����Ӧ���� borrowinf ���ͼ���š�
DROP TRIGGER tr1;
CREATE TRIGGER tr1 ON books
FOR UPDATE
AS
	BEGIN
		/*������ʱ����*/
		DECLARE @_book_no char(20)--new
		DECLARE @_book_no1 char(20)--old
		SELECT @_book_no=book_no FROM INSERTED
		SELECT @_book_no1=book_no FROM DELETED 
		UPDATE brrowinf SET book_no = @_book_no WHERE book_no = @_book_no1;
	END

SELECT * FROM borrowinf;
SELECT * FROM books;
UPDATE books SET book_no='2' WHERE book_no='1'; --����������
--��2����2�� �� readers ���н��� DELETE ������ tr2����ɾ�� readers ���еļ�¼ʱ����borrowinf ��������Ӧ�Ľ��ļ�¼��������ɾ���ü�¼������������޷����ԣ�

--��3���� borrowinf ���н��� INSERT ������ tr3����ĳλ���ߵ��������ѳ���5�����������ٽ��ˡ�
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
			RAISERROR (15600,-1,-1, '���ߵ�����鲻�ܳ���5��');
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


--��4���� borrowinf ���н��� INSERT ������ tr4�������������¼���Զ��ڱ� readers�ġ��ѽ������������� 1��
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