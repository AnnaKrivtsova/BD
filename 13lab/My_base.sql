use Krivtsova_MyBase;
go
--Task 1
--����������� �������� ��������� ��� ���������� � ������ PSUBJECT. 
drop procedure ����������;
create procedure ����������
as begin 
 declare @k int = (select count(*) from ����������);
 select * from ����������;
 return @k;
end;
go
declare @p int = 0;
exec @p = ����������;
select @p[���������� �����������:];

--Task 2
--�������� ��������� PSUBJECT, ����� ��� ��������� ��� ��������� � ������� @p � @c
alter procedure ���������� @p nvarchar(50) = null,@c int output
as begin
 declare @k int = (select count(*) from SUBJECTS);
 print '���������: @p = ' + @p + ',@c = ' + cast(@c as varchar(3));
 select * from ���������� where �������� = @p;
 set @c = (select count(*) from ���������� where �������� = @p);
 return @k;
end;
go
declare @ps int = 0, @count int = 0,@name varchar(20) = '�������';
exec @ps = ���������� @p = @name,@c = @count output;
select @ps[���������� �����������:];
select @count[���������� ����������� � ���������];

--Task 3
--������� ��������� ��������� ������� � ������ #SUBJECT. 
create table #����������(
�������� nvarchar(50),
�������� int,
)
--�������� ��������� PSUBJECT ����� �������, ����� ��� �� ��������� ��������� ���������.
alter procedure ���������� @p varchar(20)
as begin
 declare @k int = (select count(*) from ����������);
 print 'params: @p = ' + @p;
 select * from ���������� where �������� = @p;
 return @k;
end;
go
--�������� ����������� INSERT� EXECUTE � ��-�������������� ���������� PSUBJECT, �������� ������ � ������� #SUBJECT.
insert #���������� exec ���������� @p = '�������';
go
insert #���������� exec ���������� @p = '�������������';
go
select * from #����������;

--Task 4
--����������� ��������� � ������ PAUDITORIUM_INSERT
create procedure ��������_���������� @n nvarchar(50),@c int = 0
as begin
 begin try
  insert into ���������� values(@n,@c);
  return 1;
 end try
 begin catch
  print 'Number of error: ' + cast(error_number() as varchar(6));
  print 'Level: ' + cast(error_severity() as varchar(6));
  print 'Message: ' + error_message();
  return -1;
 end catch;
end;

declare @result int;
exec @result = ��������_���������� @n = '����������', @c = 20;
if(@result != 1)
print 'Error: ' + cast(@result as varchar(3));

select * from ����������;

--Task 5 
--����������� ��������� � ������ SUBJECT_REPORT
create procedure ����� @p char(10)
as begin
declare @count int;
 begin try
  declare @s char(10), @ss char(100) = '';
  declare ���������������� cursor for 
    select �������� from ���������� where �������� = @p;
  if not exists (select �������� from ���������� where �������� = @p)
  begin
   raiserror('Error in params',11,1);
  end
  else
  begin
   open ����������������
   fetch ���������������� into @s;
   print '�������� �� ���������� ';
   while @@FETCH_STATUS = 0
    begin
	 set @ss = RTRIM(@s) + ', ' + @ss;
	 set @count = @count + 1;
	 fetch ���������������� into @s;
	end;
	print @ss;
	close ����������������;
	deallocate ����������������;
  end;
  return @count;
 end try
 begin catch
  print 'Error in params'
  if ERROR_PROCEDURE() is not null
   print 'Name of procedure: '+ error_procedure();
  return @count;
 end catch;
end;
go
declare @count int;
exec @count = ����� @p = '�������';
print '���������� �����������: ' + cast(@count as varchar(10));

select * from ����������;
select �������� from ���������� where �������� = '�������';
drop procedure �����;