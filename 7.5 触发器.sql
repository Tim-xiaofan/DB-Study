---7.5 ������
USE School;
SELECT * FROM Student;
INSERT INTO Student VALUES('20053409', '����','��', 17 ,'�������ѧ����ѧԺ');
SELECT * FROM Course;
INSERT INTO Course VALUES
('0004', '���ݿ�', NULL, 3.5),
('0003', '���ݽṹ', NULL, 5);
SELECT * FROM SC;
INSERT INTO SC VALUES
('20053409', '0003', 59),
('20053409', '0004', 61)
;
-----���崥����-----
/**
CREATE TRIGGER <��������> 
 {BEFORE | AFTER} <�����¼�> ON <����>
 FOR EACH {ROW | STATEMENT}
 ��WHEN <��������>��
 <����������>
**/

------ɾ��������------
/**
ɾ���������� SQL �﷨���£�
DROP TRIGGER <��������> ON <����>;
**/

--���� 7-9���������Ƹ������ݵĴ����������ƽ�SC���в�����ѧ���ĳɼ���Ϊ����
CREATE TRIGGER tri_grade
ON SC FOR UPDATE
AS
	IF UPDATE (Grade)
			IF EXISTS (SELECT * FROM INSERTED JOIN DELETED
				ON INSERTED.Sno=DELETED.Sno
				WHERE INSERTED.Grade >= 60 AND
				DELETED.Grade < 60)
			BEGIN
				RAISERROR (15600,-1,-1, '������������ѧ���ĳɼ���Ϊ����');  
				ROLLBACK
			END
-- ����
UPDATE SC SET Grade= 60 WHERE Grade < 60; --ʧ��
UPDATE SC SET Grade= 100 WHERE Grade >= 60; --�ɹ�

--���� 7-10������ɾ������������ɾ��һ����������Ϣʱ����Ҫ���ȼ���Ȿ���Ƿ�
-- �Ѿ��������������Ƿ��Ѿ��Ͷ�������������Ѿ��Ͷ���������������Ϣ���ܱ�ɾ����
-- ɾ��������Ҫ�ع���
CREATE TRIGGER Products_Delete
ON Products FOR DELETE
AS
	IF (SELECT * COUNT (*)
		FROM [Order Details] INNER JOIN deleted 
		ON [Order Details].ProductID = deleted.ProductID
		) > 0
	BEGIN
		RAISERROR ('�ò�Ʒ�ж�����ʷ�������޷����С�',10, 1)
		ROLLBACK TRANSACTION
	END