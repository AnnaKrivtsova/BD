--����������� ��������, �����-���������� ������ � ������ ������� ����������.
use KRI_UNIVER;
set nocount on
	if  exists (select * from  SYS.OBJECTS
	            where OBJECT_ID= object_id(N'DBO.UNIVER_EVENTS') )	            
	  drop table UNIVER_EVENTS;           
	declare @c int, @flag char = 'c';      
	SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������
	CREATE table UNIVER_EVENTS(event_name char(20), capacity int );  -- ������ ���������� 
		INSERT UNIVER_EVENTS values ('�����������', 100),
									('���������', 30)								
		set @c = (select count(*) from UNIVER_EVENTS);
		print '���������� ����� � ������� UNIVER_EVENTS: ' + cast( @c as varchar(2));
		if @flag = 'c'  
		  commit;                 
	    else     
		  rollback;                   
      SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������
	
	if  exists (select * from  SYS.OBJECTS  
	            where OBJECT_ID= object_id(N'DBO.UNIVER_EVENTS') )
	  print '������� UNIVER_EVENTS ����';  
    else 
	  print '������� UNIVER_EVENTS ���'
select * from UNIVER_EVENTS

--����������� ��������, �����-���������� �������� ����������� ����� ���������� 
--� ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
--���������� ������ �������� ��� ������������� ��������� ���������� ����������� ���-���.
use KRI_UNIVER;
select * from AUDITORIUM;

begin try
	begin tran -- ������ ����� ����������
		delete AUDITORIUM where AudCapacity = 15;
		insert AUDITORIUM values ('403-4', '��', 20, '401-4');
		commit tran; -- �������� ����������
	end try
	begin catch
		print 'error: ' + case
		when error_number() = 2627 and patindex('%PK_Aud%', error_message()) > 0
		then '������������ ���������'
		else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
		end;
		if @@trancount > 0 
		  rollback tran;
	end catch;

--����������� ��������, ��������������� ���������� ��������� SAVE TRAN
--� ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
--���������� ������ �������� ��� ������������� ��������� ����������� ����� � ��������� ���������� ����������� ���-���.
select * from AUDITORIUM;
declare @point varchar(32)
begin try
	begin tran
		delete AUDITORIUM where AudCapacity = 15;
		set  @point = 'p1'; 
		save tran @point; -- ����������� �����
		insert AUDITORIUM values ('309-4', '��', 60, '300-4');
		set  @point = 'p2'; 
		save tran @point;
		insert AUDITORIUM values ('443-1', '��', 120, '443-1');
		commit tran;
	end try
	begin catch
		print 'error: ' + case
		when error_number() = 2627 and patindex('%PK_Aud%', error_message()) > 0
		then '������������ ���������'
		else '����������� ������: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
		end;
		if @@trancount > 0
			begin
				print '����������� �����: ' + @point;
				rollback tran @point; -- ����� � ����������� �����
				commit tran; -- �������� ���������, ����������� �� ����������� �����
			end;
	end catch;

--����������� ��� �������� A � B 
--�������� A ������������ ����� ����� ���������� � ����-��� ��������������� READ UNCOMMITED, 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
--�������� A ������ ���������������, ��� ������� READ UNCOMMITED ��������� ����������������, ��������������� � ��������� ������. 
select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;
    
	--- B --	
	begin transaction 
	select @@SPID
	insert AUDITORIUM_TYPE values ('��-�', '���������� � ���. ����������'); 
	update AUDITORIUM set AudCapacity  =  30 where Aud = '314-1' 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;
	

--����������� ��� �������� A � B �� ������� ���� ������ 
--�������� A � � ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ��-��������������� ������, 
--�� ��� ���� �������� ���������-������ � ��������� ������. 
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
	insert AUDITORIUM_TYPE values ('��-�', '���������� � ���. ����������'); 
    update AUDITORIUM set Aud = '443-1*' where Aud = '443-1' 
    commit; 
	-------------------------- t2 --------------------	

	--������ ������
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
    delete from AUDITORIUM where Aud = '443-1' 
    commit; 
	-------------------------- t2 --------------------	
--����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
--�������� A ������������ ��-��� ����� ���������� � ����-��� ��������������� REPEATABLE READ. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ �����-����������, ��� ������� REAPETABLE READ �� �����-���� ����������������� ������ � ���������������� ������, 
--�� ��� ���� �������� ��������� ������. 
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
    insert AUDITORIUM values ('443-1','��-�',45,'443-1');
    commit; 
	-------------------------- t2 --------------------

--����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
--�������� A ������������ ��-��� ����� ���������� � ����-��� ��������������� SERIALIZABLE. 
--�������� B � ����� �������-��� � ������� ������������-��� READ COMMITED.
--�������� A ������ �����-���������� ���������� ������-����, ����������������� � ��-�������������� ������.
	--- B ---	
	begin transaction 	  
	delete AUDITORIUM where Aud = '443-1';  
    insert AUDITORIUM values ('200-3','��-�',45,'200-3');
    update AUDITORIUM set AudType = '��' where AudCapacity = 60;
    -------------------------- t1 --------------------
    commit; 
    -------------------------- t2 --------------------
	
--����������� ��������, �����-���������� �������� ������-��� ����������, �� ������� ��-�� ������ X_UNIVER.
select * from AUDITORIUM;

begin tran
    insert AUDITORIUM_TYPE values ('��1-�','���������� 1');
	begin tran
	 update AUDITORIUM set AudName='��1-�' where AudType = '��1-�';
	 commit;
	 if @@TRANCOUNT > 0 
	  rollback;
	select (select count(*) from AUDITORIUM where AudName = '��1-�')'Auditorium',
	(select count(*) from AUDITORIUM_TYPE where AuditoriumType = '��1-�')'Auditorium type';