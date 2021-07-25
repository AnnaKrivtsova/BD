use Krivtsova_MyBase;

--Task 1
create table TR_AUDIT_MYBASE(
ID int identity,
STMT varchar(20) check (STMT in ('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300),
)

go 
select * from �����������;

go
create trigger TR_INS on ����������� after insert
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Insert operation';
set @name = (select [�������� �����������] from inserted);
set @bank = (select [���������� ���������] from inserted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('INS','TR_INS',@in);
return;

go
insert �����������([�������� �����������], [���������� ���������], [���������� ����]) values('����������� 2',11423, 'htrh');
select * from TR_AUDIT_MYBASE;


drop trigger TR_INS;
drop table TR_AUDIT_MYBASE;

--Task 2
create trigger TR_DEL on ����������� after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [�������� �����������] from deleted);
set @bank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL',@in);
return;

go
delete from ����������� where [�������� �����������] = '����������� 2';
select * from �����������;

go 
select * from TR_AUDIT_MYBASE;

drop trigger TR_DEL;

--Task 3
create trigger TR_UPD on ����������� after update
as declare @name nvarchar(50), @bank int,
@oldname nvarchar(50), @oldbank int, @in varchar(300);
print 'Update operation';
set @name = (select [�������� �����������] from inserted);
set @bank = (select [���������� ���������] from inserted);

set @oldname = (select [�������� �����������] from deleted);
set @oldbank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank + '/' + @oldname + ' ' + @oldbank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('UPD','TR_UPD',@in);
return;

go
update ����������� set [���������� ���������] = 140 where [�������� �����������] = '�������';

go 
select * from TR_AUDIT_MYBASE;

drop trigger TR_UPD

--Task 4
create trigger TR_ALL on ����������� after insert, update,delete
as declare @name nvarchar(50), @bank int,
@oldname nvarchar(50), @oldbank int, @in varchar(300);

declare @ins int = (select count(*) from inserted),
@del int = (select count(*) from deleted)

if @ins>0 and @del=0
begin 
  print 'Insert operation';
  set @name = (select [�������� �����������] from inserted);
  set @bank = (select [���������� ���������] from inserted);
  set @in = @name + ' ' + @bank;
  insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('INS','TR_INS',@in);
end;
else
if @ins = 0 and @del > 0
begin
print 'Delete operation';
  set @name = (select [�������� �����������] from deleted);
  set @bank = (select [���������� ���������] from deleted);
  set @in = @name + ' ' + @bank;
  insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL',@in);
end;
else 
if @ins > 0 and @del > 0 
begin
 print 'Update operation';
  set @name = (select [�������� �����������] from inserted);
  set @bank = (select [���������� ���������] from inserted);

  set @name = (select [�������� �����������] from deleted);
  set @bank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank + '/' + @oldname + ' ' + @oldbank;
 insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('UPD','TR_UPD',@in);
end;
return;

go
insert into ����������� values('����������� 3',12);
update ����������� set [���������� ���������] = 3 where [�������� �����������] = '�������';
delete from ����������� where [�������� �����������] = '����������� 3';
select * from TR_AUDIT_MYBASE;

drop trigger TR_ALL; 


--Task 5
alter table �����������  add constraint [���������� ���������] check([���������� ���������] <= 3000)

update ����������� set [���������� ���������] = '3200' where [�������� �����������] = '��������';
select * from TR_AUDIT_MYBASE;

--Task 6
create trigger TR_DEL1 on ����������� after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [�������� �����������] from deleted);
set @bank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL1',@in);
return;

go
create trigger TR_DEL2 on ����������� after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [�������� �����������] from deleted);
set @bank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL2',@in);
return;

go
create trigger TR_DEL3 on ����������� after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [�������� �����������] from deleted);
set @bank = (select [���������� ���������] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL3',@in);
return;

use Krivtsova_MyBase;
go
exec  SP_SETTRIGGERORDER @triggername = 'TR_DEL3', 
@order = 'first', @stmttype = 'DELETE'

exec  SP_SETTRIGGERORDER @triggername = 'TR_DEL2', 
@order = 'Last', @stmttype = 'DELETE';
delete from ����������� where [�������� �����������] = '����������� 3';

drop trigger TR_DEL1 
drop trigger TR_DEL2 
drop trigger TR_DEL3 

--Task 7
create trigger TR_TRAN2 on ����������� after insert, update,delete
as declare @c int = (select count(*) from �����������);
if (@c > 7)
begin
  raiserror ('�� ����� 7 �����������', 10,1);
  rollback;
end;
return;

insert into ����������� values('����������� 4',10);
insert into ����������� values('����������� 5',11);

select * from �����������;

drop trigger TR_TRAN2

--Task 8
create trigger TR_INSTEAD_OF2 on ����������� instead of delete
as raiserror ('Cant delete', 10,1);
return;

delete from ����������� where [�������� �����������] = '��������';

select * from �����������;

drop trigger TR_INSTEAD_OF2;

create trigger TR_INSTEAD_OF_INS2 on ����������� instead of insert
as raiserror ('Cant insert', 10,1);
return;

update ����������� set [���������� ���������] = 14 where [�������� �����������] = '��������';

drop trigger TR_INSTEAD_OF_INS2;

--Task 9
use Krivtsova_MyBase;
go
create  trigger DDL_UNIVER on database 
                          for DDL_DATABASE_LEVEL_EVENTS  as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
    print @t;
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  print @t1;
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  print @t2;
  if @t1 = '�����������' 
  begin
       print 'Type of event: '+@t;
       print 'Name of object: '+@t1;
       print 'Object type: '+@t2;
       raiserror( N'operations with table ����������� forbiddened', 16, 1);  
       rollback;    
   end;

alter table ����������� add [���������� ���������]2 int;
select * from �����������;

drop trigger DDL_UNIVER;


