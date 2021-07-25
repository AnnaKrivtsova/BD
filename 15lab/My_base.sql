use Krivtsova_MyBase;

--Task 1
create table TR_AUDIT_MYBASE(
ID int identity,
STMT varchar(20) check (STMT in ('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300),
)

go 
select * from Предприятия;

go
create trigger TR_INS on Предприятия after insert
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Insert operation';
set @name = (select [Название предприятия] from inserted);
set @bank = (select [Банковские реквизиты] from inserted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('INS','TR_INS',@in);
return;

go
insert Предприятия([Название предприятия], [Банковские реквизиты], [Контактное лицо]) values('Предприятие 2',11423, 'htrh');
select * from TR_AUDIT_MYBASE;


drop trigger TR_INS;
drop table TR_AUDIT_MYBASE;

--Task 2
create trigger TR_DEL on Предприятия after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [Название предприятия] from deleted);
set @bank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL',@in);
return;

go
delete from Предприятия where [Название предприятия] = 'Предприятие 2';
select * from Предприятия;

go 
select * from TR_AUDIT_MYBASE;

drop trigger TR_DEL;

--Task 3
create trigger TR_UPD on Предприятия after update
as declare @name nvarchar(50), @bank int,
@oldname nvarchar(50), @oldbank int, @in varchar(300);
print 'Update operation';
set @name = (select [Название предприятия] from inserted);
set @bank = (select [Банковские реквизиты] from inserted);

set @oldname = (select [Название предприятия] from deleted);
set @oldbank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank + '/' + @oldname + ' ' + @oldbank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('UPD','TR_UPD',@in);
return;

go
update Предприятия set [Банковские реквизиты] = 140 where [Название предприятия] = 'Прибыль';

go 
select * from TR_AUDIT_MYBASE;

drop trigger TR_UPD

--Task 4
create trigger TR_ALL on Предприятия after insert, update,delete
as declare @name nvarchar(50), @bank int,
@oldname nvarchar(50), @oldbank int, @in varchar(300);

declare @ins int = (select count(*) from inserted),
@del int = (select count(*) from deleted)

if @ins>0 and @del=0
begin 
  print 'Insert operation';
  set @name = (select [Название предприятия] from inserted);
  set @bank = (select [Банковские реквизиты] from inserted);
  set @in = @name + ' ' + @bank;
  insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('INS','TR_INS',@in);
end;
else
if @ins = 0 and @del > 0
begin
print 'Delete operation';
  set @name = (select [Название предприятия] from deleted);
  set @bank = (select [Банковские реквизиты] from deleted);
  set @in = @name + ' ' + @bank;
  insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL',@in);
end;
else 
if @ins > 0 and @del > 0 
begin
 print 'Update operation';
  set @name = (select [Название предприятия] from inserted);
  set @bank = (select [Банковские реквизиты] from inserted);

  set @name = (select [Название предприятия] from deleted);
  set @bank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank + '/' + @oldname + ' ' + @oldbank;
 insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('UPD','TR_UPD',@in);
end;
return;

go
insert into Предприятия values('Предприятие 3',12);
update Предприятия set [Банковские реквизиты] = 3 where [Название предприятия] = 'Прибыль';
delete from Предприятия where [Название предприятия] = 'Предприятие 3';
select * from TR_AUDIT_MYBASE;

drop trigger TR_ALL; 


--Task 5
alter table Предприятия  add constraint [Банковские реквизиты] check([Банковские реквизиты] <= 3000)

update Предприятия set [Банковские реквизиты] = '3200' where [Название предприятия] = 'Евроторг';
select * from TR_AUDIT_MYBASE;

--Task 6
create trigger TR_DEL1 on Предприятия after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [Название предприятия] from deleted);
set @bank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL1',@in);
return;

go
create trigger TR_DEL2 on Предприятия after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [Название предприятия] from deleted);
set @bank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL2',@in);
return;

go
create trigger TR_DEL3 on Предприятия after delete
as declare @name nvarchar(50), @bank int, @in varchar(300);
print 'Delete operation';
set @name = (select [Название предприятия] from deleted);
set @bank = (select [Банковские реквизиты] from deleted);
set @in = @name + ' ' + @bank;
insert into TR_AUDIT_MYBASE(STMT,TRNAME,CC) values ('DEL','TR_DEL3',@in);
return;

use Krivtsova_MyBase;
go
exec  SP_SETTRIGGERORDER @triggername = 'TR_DEL3', 
@order = 'first', @stmttype = 'DELETE'

exec  SP_SETTRIGGERORDER @triggername = 'TR_DEL2', 
@order = 'Last', @stmttype = 'DELETE';
delete from Предприятия where [Название предприятия] = 'Предприятие 3';

drop trigger TR_DEL1 
drop trigger TR_DEL2 
drop trigger TR_DEL3 

--Task 7
create trigger TR_TRAN2 on Предприятия after insert, update,delete
as declare @c int = (select count(*) from Предприятия);
if (@c > 7)
begin
  raiserror ('Не более 7 предприятий', 10,1);
  rollback;
end;
return;

insert into Предприятия values('Предприятие 4',10);
insert into Предприятия values('Предприятие 5',11);

select * from Предприятия;

drop trigger TR_TRAN2

--Task 8
create trigger TR_INSTEAD_OF2 on Предприятия instead of delete
as raiserror ('Cant delete', 10,1);
return;

delete from Предприятия where [Название предприятия] = 'Евроторг';

select * from Предприятия;

drop trigger TR_INSTEAD_OF2;

create trigger TR_INSTEAD_OF_INS2 on Предприятия instead of insert
as raiserror ('Cant insert', 10,1);
return;

update Предприятия set [Банковские реквизиты] = 14 where [Название предприятия] = 'Евроторг';

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
  if @t1 = 'Предприятия' 
  begin
       print 'Type of event: '+@t;
       print 'Name of object: '+@t1;
       print 'Object type: '+@t2;
       raiserror( N'operations with table Предприятия forbiddened', 16, 1);  
       rollback;    
   end;

alter table Предприятия add [Банковские реквизиты]2 int;
select * from Предприятия;

drop trigger DDL_UNIVER;


