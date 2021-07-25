use KRI_UNIVER;
go
--Task 1
--Разработать хранимую процедуру без параметров с именем PSUBJECT. 
drop procedure PSUBJECT;
create procedure PSUBJECT
as begin 
 declare @k int = (select count(*) from SUBJECTS);
 select * from SUBJECTS;
 return @k;
end;
go
declare @psubject int = 0;
exec @psubject = PSUBJECT;
select @psubject[Count of subjects:];

--Task 2
--Изменить процедуру PSUBJECT, чтобы она принимала два параметра с именами @p и @c
alter procedure PSUBJECT @p varchar(20) = null,@c int output
as begin
 declare @k int = (select count(*) from SUBJECTS);
 print 'params: @p = ' + @p + ',@c = ' + cast(@c as varchar(3));
 select * from SUBJECTS where Pulpit = @p;
 set @c = (select count(*) from SUBJECTS where Pulpit = @p);
 return @k;
end;
go
declare @psubject int = 0, @count int = 0,@pulpit varchar(20) = 'ИСиТ';
exec @psubject = PSUBJECT @p = @pulpit,@c = @count output;
select @psubject[Count of subjects:];
select @count[Count of subjects on pulpit:];

--Task 3
--Создать временную локальную таблицу с именем #SUBJECT. 
create table #SUBJECT(
Subject_ char(10),
SubjectName varchar(100),
Pulpit char(20)
)
--Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
alter procedure PSUBJECT @p varchar(20)
as begin
 declare @k int = (select count(*) from SUBJECTS);
 print 'params: @p = ' + @p;
 select * from SUBJECTS where Pulpit = @p;
 return @k;
end;
go
--Применив конструкцию INSERT… EXECUTE с мо-дифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT.
insert #SUBJECT exec PSUBJECT @p = 'ИСиТ';
go
insert #SUBJECT exec PSUBJECT @p = 'ПОИТ';
go
select * from #SUBJECT;

--Task 4
--Разработать процедуру с именем PAUDITORIUM_INSERT
drop procedure PAUDITORIUM_INSERT;
create procedure PAUDITORIUM_INSERT @a char(20),@n varchar(50),@c int = 0,@t char(10)
as begin
 begin try
  insert into AUDITORIUM values(@a,@t,@c,@n);
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
exec @result = PAUDITORIUM_INSERT @a = '102-1',@n = '102-1', @c = 20,@t = 'ЛК';
if(@result != 1)
print 'Error: ' + cast(@result as varchar(3));

select * from AUDITORIUM;
delete AUDITORIUM where Aud = '102-1';

--Task 5 
--Разработать процедуру с именем SUBJECT_REPORT
create or alter procedure SUBJECT_REPORTS @param varchar(20)
as begin
declare @countOfSubjects int;
 begin try
  set @countOfSubjects = 0;
  declare @subject char(10), @subjects char(100) = '';
  print 'Parametr:'
  print @param;
  declare SUBJECTS cursor for 
    select Subject_ from SUBJECTS where Pulpit = @param;
  if not exists (select Subject_ from SUBJECTS where Pulpit = @param)
  begin
   raiserror('Error in params',11,1);
  end
  else
  begin
   open SUBJECTS
   fetch SUBJECTS into @subject;
   print 'Subjects in pulit ';
   while @@FETCH_STATUS = 0
    begin
	 set @subjects = RTRIM(@subject) + ', ' + @subjects;
	 set @countOfSubjects = @countOfSubjects + 1;
	 fetch SUBJECTS into @subject;
	end;
	print @subjects;
	close SUBJECTS;
	deallocate SUBJECTS;
  end;
  print @countOfSubjects;
  return @countOfSubjects;
 end try
 begin catch
  print 'Error in params'
  if ERROR_PROCEDURE() is not null
   print 'Name of procedure: '+ error_procedure();
  return @countOfSubjects;
 end catch;
end;
go

declare @countS int;
exec @countS = SUBJECT_REPORTS @param = 'ИСиТ';
print 'Count of subjects: ' + cast(@countS as varchar(10));

select * from SUBJECTS;
select Subject_ from SUBJECTS where Pulpit = 'ИСиТ';
drop procedure SUBJECT_REPORTS;

--Task 6
--Разработать процедуру с именем PAUDITORIUM_INSERTX
drop procedure PAUDITORIUM_INSERTX;
create procedure PAUDITORIUM_INSERTX @a char(20),@n varchar(50),@c int = 0,@t char(10),@tn varchar(50)
as declare @rc int = 1;
 begin try
    set transaction isolation level SERIALIZABLE;
	begin tran
	  insert into AUDITORIUM_TYPE values(@t,@tn);
	  exec @rc = PAUDITORIUM_INSERT @a,@n,@c,@t;
	commit tran;
	return @rc;
 end try
 begin catch
      print 'Number of error: ' + cast(error_number() as varchar(6));
	  print 'Level: ' + cast(error_severity() as varchar(6));
	  print 'Message: ' + error_message();
	  if error_procedure() is not null
	    print 'Name of the procedure: ' + error_procedure();
		if @@TRANCOUNT > 0
		 rollback tran;
	  return -1;
 end catch;
 go
declare @result int;
exec @result = PAUDITORIUM_INSERTX @a='180-1',@n='180-1',@c = 30,@t = 'ЛБ-Х1',@tn ='Химическая лаборатория 1';
print 'Error: ' + cast(@result as varchar(3));

select * from AUDITORIUM_TYPE;
select * from AUDITORIUM;

delete AUDITORIUM where Aud = '180-1';
delete AUDITORIUM_TYPE where AuditoriumType = 'ЛБ-Х1';

drop procedure PAUDITORIUM_INSERTX;

--Task 7
drop procedure PRINT_REPORT;
create procedure PRINT_REPORT @f char(10) = null,@p char(10) = null
as begin 
 begin try
   declare @countOfPulpit int = 0;
   if(@p is null and @f is not null)
   begin
	 if not exists (select * from FACULTY where Faculty = @f)
	   raiserror('Error in params',11,1);
	 else
	 begin
	   select * from FACULTY where Faculty = @f;
	   set @countOfPulpit = 0;
     end;
   end;

   else if(@p is not null and @f is not null)
   begin
     if not exists (select * from PULPIT where Faculty = @f and Pulpit = @p)
	   raiserror('Error in params',11,1);
	 else
	 begin
	   select * from PULPIT where Faculty = @f and Pulpit = @p;
	   set @countOfPulpit = (select count(*) from PULPIT where Faculty = @f and Pulpit = @p);
     end;
   end;

   else if(@p is not null and @f is null)
   begin
     if not exists (select * from PULPIT where Pulpit = @p)
	   raiserror('Error in params',11,1);
     set @f = (select Faculty from PULPIT where Pulpit = @p);
	 if not exists (select * from PULPIT where Faculty = @f and Pulpit = @p)
	   raiserror('Error in params',11,1);
	 else
	 begin
	   select * from PULPIT where Faculty = @f and Pulpit = @p;
	   set @countOfPulpit = (select count(*) from PULPIT where Faculty = @f and Pulpit = @p);
     end;
   end;

   else
   begin
     if not exists (select * from PULPIT where Pulpit = @p)
	   raiserror('Error in params',11,1);
   end; 

   return @countOfPulpit;
 end try
 begin catch
      print 'Number of error: ' + cast(error_number() as varchar(6));
	  print 'Level: ' + cast(error_severity() as varchar(6));
	  print 'Message: ' + error_message();
	  if error_procedure() is not null
	    print 'Name of the procedure: ' + error_procedure();
		if @@TRANCOUNT > 0
		 rollback tran;
	  return -1;
 end catch;
end;
go
declare @task8 int;
exec @task8 = PRINT_REPORT;
exec @task8 = PRINT_REPORT @f = 'ИТ';
exec @task8 = PRINT_REPORT @f = 'ИТ', @p = 'ИСиТ';
exec @task8 = PRINT_REPORT @p = 'ПОИТ';
select @task8;