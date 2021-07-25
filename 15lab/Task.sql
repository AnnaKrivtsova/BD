use KRI_UNIVER;

--Task 1
create table TR_AUDIT(
ID int identity,
STMT varchar(20) check (STMT in ('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(500),
)
drop table TR_AUDIT;
go 
select * from TEACHER;

go
create trigger TR_TEACHER_INS on TEACHER after insert
as declare @name char(10), @fullname varchar(100), 
@gender char(1), @pulpit char(20), @in varchar(300);
print 'Insert operation';
set @name = (select Teacher from inserted);
set @fullname = (select TeacherName from inserted);
set @gender = (select Gender from inserted);
set @pulpit = (select Pulpit from inserted);
set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit;
insert into TR_AUDIT(STMT,TRNAME,CC) values ('INS','TR_TEACHER_INS',@in);
return;

go
insert into TEACHER values('КЛСНВ','Колесников Виталий Леонидович','м','ИСиТ');
select * from TR_AUDIT;

drop trigger TR_TEACHER_INS
delete TEACHER where Teacher = 'КЛСНВ';

--Task 2
create trigger TR_TEACHER_DEL on TEACHER after delete
as declare @name char(10), @fullname varchar(100), 
@gender char(1), @pulpit char(20), @in varchar(300);
print 'Delete operation';
set @name = (select Teacher from deleted);
set @fullname = (select TeacherName from deleted);
set @gender = (select Gender from deleted);
set @pulpit = (select Pulpit from deleted);
set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit;
insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_TEACHER_DEL',@in);
return;

go
delete from TEACHER where Teacher = 'КЛСНВ';
select * from TEACHER;

go 
select * from TR_AUDIT;

drop trigger TR_TEACHER_DEL;

--Task 3
create trigger TR_TEACHER_UPD on TEACHER after update
as declare @name char(10), @fullname varchar(100), 
@gender char(1), @pulpit char(20),
@oldname char(10), @oldfullname varchar(100), 
@oldgender char(1), @oldpulpit char(20), @in varchar(300);
print 'Update operation';
set @name = (select Teacher from inserted);
set @fullname = (select TeacherName from inserted);
set @gender = (select Gender from inserted);
set @pulpit = (select Pulpit from inserted);

set @oldname = (select Teacher from deleted);
set @oldfullname = (select TeacherName from deleted);
set @oldgender = (select Gender from deleted);
set @oldpulpit = (select Pulpit from deleted);
set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit + '/'
+ @oldname + ' ' + @oldfullname + ' ' + @oldgender + ' ' + @oldpulpit;
insert into TR_AUDIT(STMT,TRNAME,CC) values ('UPD','TR_TEACHER_UPD',@in);
return;

go
update TEACHER set Pulpit = 'ПОиТ' where Teacher = 'АКНВЧ';

go 
select * from TR_AUDIT;

drop trigger TR_TEACHER_UPD

--Task 4
create trigger TR_TEACHER on TEACHER after insert, update,delete
as declare @name char(10), @fullname varchar(100), 
@gender char(1), @pulpit char(20), @in varchar(300),
@oldname char(10), @oldfullname varchar(100), 
@oldgender char(1), @oldpulpit char(20);

declare @ins int = (select count(*) from inserted),
@del int = (select count(*) from deleted)

if @ins>0 and @del=0
begin 
  print 'Insert operation';
  set @name = (select Teacher from inserted);
  set @fullname = (select TeacherName from inserted);
  set @gender = (select Gender from inserted);
  set @pulpit = (select Pulpit from inserted);
  set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit;
  insert into TR_AUDIT(STMT,TRNAME,CC) values ('INS','TR_TEACHER',@in);
end;
else
if @ins = 0 and @del > 0
begin
print 'Delete operation';
  set @name = (select Teacher from deleted);
  set @fullname = (select TeacherName from deleted);
  set @gender = (select Gender from deleted);
  set @pulpit = (select Pulpit from deleted);
  set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit;
  insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_TEACHER',@in);
end;
else 
if @ins > 0 and @del > 0 
begin
 print 'Update operation';
 set @name = (select Teacher from inserted);
 set @fullname = (select TeacherName from inserted);
 set @gender = (select Gender from inserted);
 set @pulpit = (select Pulpit from inserted);

 set @oldname = (select Teacher from deleted);
 set @oldfullname = (select TeacherName from deleted);
 set @oldgender = (select Gender from deleted);
 set @oldpulpit = (select Pulpit from deleted);
 set @in = @name + ' ' + @fullname + ' ' + @gender + ' ' + @pulpit + '/'
 + @oldname + ' ' + @oldfullname + ' ' + @oldgender + ' ' + @oldpulpit;
 insert into TR_AUDIT(STMT,TRNAME,CC) values ('UPD','TR_TEACHER',@in);
end;
return;

go
insert into TEACHER values('КЛСНВ','Колесников Виталий Леонидович','м','ИСиТ');
update TEACHER set Pulpit = 'ИСиТ' where Teacher = 'АКНВЧ';
delete from TEACHER where Teacher = 'КЛСНВ';
select * from TR_AUDIT;

drop trigger TR_TEACHER 

delete TR_AUDIT; 
--Task 5
update TEACHER set Gender = 'н' where Teacher = 'АКНВЧ';
select * from TR_AUDIT;

--Task 6
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE  
as print 'TR_TEACHER_DEL1';
 return;  
go 
create trigger TR_TEACHER_DEL2 on TEACHER after DELETE  
as print 'TR_TEACHER_DEL2';
 return;  
go  
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE  
as print 'TR_TEACHER_DEL3';
 return;  
go    
select t.name, e.type_desc 
  from sys.triggers  t join  sys.trigger_events e  on t.object_id = e.object_id  
  where OBJECT_NAME(t.parent_id)='TEACHER' and e.type_desc = 'DELETE' ;  
go
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order='first', @stmttype = 'DELETE';
							go
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order='last', @stmttype = 'DELETE';
							go
insert into TEACHER values('КЛСНВ','Колесников Виталий Леонидович','м','ИСиТ');
delete from TEACHER where Teacher = 'КЛСНВ';
select * from TEACHER;

drop trigger TR_TEACHER_DEL1 
drop trigger TR_TEACHER_DEL2 
drop trigger TR_TEACHER_DEL3 

--Task 7
create trigger TR_TRAN on AUDITORIUM after insert, update,delete
as declare @c int = (select sum(AudCapacity) from AUDITORIUM);
if (@c > 1000)
begin
  raiserror ('Cant be more than 1000', 10,1);
  rollback;
end;
return;

update AUDITORIUM set AudCapacity = 110 where Aud = '100-1'

select * from AUDITORIUM;

drop trigger TR_TRAN 

--Task 8
create trigger TR_INSTEAD_OF on TEACHER instead of delete
as raiserror ('Cant delete', 10,1);
return;
go
delete from TEACHER where Teacher = 'КЛСНВ';

select * from TEACHER;

drop trigger TR_INSTEAD_OF;

create trigger TR_INSTEAD_OF_INS on TEACHER instead of insert
as raiserror ('Cant insert', 10,1);
return;

insert into TEACHER values('КЛСНВ','Колесников Виталий Леонидович','м','ИСиТ');

drop trigger TR_INSTEAD_OF_INS;

--Task 9
use KRI_UNIVER
go
create or alter trigger DDL_UNIVER on database 
                          for DDL_DATABASE_LEVEL_EVENTS  as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
    print @t;
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  print @t1;
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  print @t2;
  if @t1 = 'WORKERS' 
  begin
       print 'Type of event: '+@t;
       print 'Name of object: '+@t1;
       print 'Object type: '+@t2;
       raiserror( N'operations with table WORKERS forbiddened', 16, 1);  
       rollback;    
   end;

alter table WORKERS add Surname int;
alter table WORKERS drop column Surname;
select * from WORKERS;

drop trigger DDL_UNIVER;

--Task 11
create table WEATHER(
city nvarchar(30),
startDate datetime,
endDate datetime,
temperature float
)
create or alter trigger TR_INSTEAD_OF_INS_WEATHER on WEATHER instead of insert
as declare @canInsert int, @city nvarchar(30), @startDate datetime, @endDate datetime, @temperature float;
  set @city = (select city from inserted);
  set @startDate = (select startDate from inserted);
  set @endDate = (select endDate from inserted);
  set @temperature = (select temperature from inserted);
if(exists (select * from WEATHER where city = @city and startDate = @startDate and endDate = @endDate))
begin
raiserror ('Cant insert', 10,1);
end;
else
 begin
  insert into WEATHER values(@city,@startDate,@endDate,@temperature);
 end;
return;

insert into WEATHER values('Minsk','01-01-2001 13:00','01-01-2001 13:01', 2);
insert into WEATHER values('Minsk','01-01-2001 13:00','01-01-2001 13:01', 3);
insert into WEATHER values('Minsk','01-01-2001 13:01','01-01-2001 13:02', 3);

select * from WEATHER;

drop trigger TR_INSTEAD_OF_INS_WEATHER;
drop table WEATHER;
