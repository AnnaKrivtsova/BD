--����������� ��� �������� A � B 
--�������� A ������������ ����� ����� ���������� � ����-��� ��������������� READ UNCOMMITED, 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
-- A ---
select * from AUDITORIUM_TYPE where AuditoriumType = '��-�';
use KRI_UNIVER;
	set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert AUDITORIUM_TYPE' '���������', * from AUDITORIUM_TYPE 
	where AuditoriumType = '��-�';
	select @@SPID, 'update AUDITORIUM'  '���������',  Aud, 
    AudCapacity from AUDITORIUM   where Aud = '314-1';
	commit; 
	-------------------------- t2 -----------------

--����������� ��� �������� A � B �� ������� ���� ������ 
--�������� A � � ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ��-��������������� ������, 
--�� ��� ���� �������� ���������-������ � ��������� ������. 
    -- A ---
    set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from AUDITORIUM where Aud = '443-1';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  'update AUDITORIUM'  '���������', count(*) from AUDITORIUM  where Aud = '443-1*';
	rollback; 

	--������������� ������
	-- A ---
    set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from AUDITORIUM where Aud = '443-1*';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  count(*) from AUDITORIUM where Aud = '443-1*';
	rollback; 


--����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
--�������� A ������������ ��-��� ����� ���������� � ����-��� ��������������� REPEATABLE READ. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ �����-����������, ��� ������� REAPETABLE READ �� �����-���� ����������������� ������ � ���������������� ������, 
--�� ��� ���� �������� ��������� ������. 
    -- A ---
    set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select Aud from AUDITORIUM;
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select * from AUDITORIUM;
	select 'insert  AUDITORIUM' '���������', AudName from AUDITORIUM where Aud='443-1*';
	commit; 

--����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
--�������� A ������������ ��-��� ����� ���������� � ����-��� ��������������� SERIAL-IZABLE. 
--�������� B � ����� �������-��� � ������� ������������-��� READ COMMITED.
--�������� A ������ �����-���������� ���������� ������-����, ����������������� � ��-�������������� ������.
    -- A ---
    set transaction isolation level SERIALIZABLE 
	begin transaction 
    select  Aud from AUDITORIUM  where Aud = '443-1'; 
	-------------------------- t1 -----------------
    select  Aud from AUDITORIUM  where Aud = '443-1'; 
	-------------------------- t2 ------------------ 
	commit; 