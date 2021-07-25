use Krivtsova_MyBase;
go
--Task 1
--Разработать хранимую процедуру без параметров с именем PSUBJECT. 
drop procedure Показатели;
create procedure Показатели
as begin 
 declare @k int = (select count(*) from Показатели);
 select * from Показатели;
 return @k;
end;
go
declare @p int = 0;
exec @p = Показатели;
select @p[Количество показателей:];

--Task 2
--Изменить процедуру PSUBJECT, чтобы она принимала два параметра с именами @p и @c
alter procedure Показатели @p nvarchar(50) = null,@c int output
as begin
 declare @k int = (select count(*) from SUBJECTS);
 print 'параметры: @p = ' + @p + ',@c = ' + cast(@c as varchar(3));
 select * from Показатели where Название = @p;
 set @c = (select count(*) from Показатели where Название = @p);
 return @k;
end;
go
declare @ps int = 0, @count int = 0,@name varchar(20) = 'Прибыль';
exec @ps = Показатели @p = @name,@c = @count output;
select @ps[Количество показателей:];
select @count[Количество показателей с названием];

--Task 3
--Создать временную локальную таблицу с именем #SUBJECT. 
create table #Показатель(
Название nvarchar(50),
Важность int,
)
--Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
alter procedure Показатели @p varchar(20)
as begin
 declare @k int = (select count(*) from Показатели);
 print 'params: @p = ' + @p;
 select * from Показатели where Название = @p;
 return @k;
end;
go
--Применив конструкцию INSERT… EXECUTE с мо-дифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT.
insert #Показатель exec Показатели @p = 'Прибыль';
go
insert #Показатель exec Показатели @p = 'Себестоимость';
go
select * from #Показатель;

--Task 4
--Разработать процедуру с именем PAUDITORIUM_INSERT
create procedure Вставить_показатель @n nvarchar(50),@c int = 0
as begin
 begin try
  insert into Показатели values(@n,@c);
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
exec @result = Вставить_показатель @n = 'Показатель', @c = 20;
if(@result != 1)
print 'Error: ' + cast(@result as varchar(3));

select * from Показатели;

--Task 5 
--Разработать процедуру с именем SUBJECT_REPORT
create procedure Отчет @p char(10)
as begin
declare @count int;
 begin try
  declare @s char(10), @ss char(100) = '';
  declare ПоказателиКурсор cursor for 
    select Важность from Показатели where Название = @p;
  if not exists (select Важность from Показатели where Название = @p)
  begin
   raiserror('Error in params',11,1);
  end
  else
  begin
   open ПоказателиКурсор
   fetch ПоказателиКурсор into @s;
   print 'Важность по показателю ';
   while @@FETCH_STATUS = 0
    begin
	 set @ss = RTRIM(@s) + ', ' + @ss;
	 set @count = @count + 1;
	 fetch ПоказателиКурсор into @s;
	end;
	print @ss;
	close ПоказателиКурсор;
	deallocate ПоказателиКурсор;
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
exec @count = Отчет @p = 'Прибыль';
print 'Количество показателей: ' + cast(@count as varchar(10));

select * from Показатели;
select Важность from Показатели where Название = 'Прибыль';
drop procedure Отчет;