use KRI_UNIVER;

--Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ. 
--В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую. 
--Использовать встроенную функцию RTRIM.
declare @sb char(40), @s char(300) = '';
declare Isit cursor for select SubjectName from SUBJECTS where Pulpit = 'ИСиТ';
open Isit;
fetch Isit into @sb;
print 'Subjects';
while @@FETCH_STATUS = 0
  begin
    set @s = RTRIM(@sb) + ',' + @s;
	fetch Isit into @sb;
  end;
print @s;
close Isit;
deallocate Isit;

--Разработать сценарий, демонстрирующий отличие глобального курсора от локального на примере базы данных X_UNIVER.
declare LocalCursor cursor local for
select Name_,BDay from STUDENT;
declare @nm char(50),@bd datetime;
open LocalCursor;
fetch LocalCursor into @nm,@bd;
print '1.' + @nm + ' ' + cast(@bd as varchar(6));
go 
declare @nm char(50),@bd datetime;
fetch LocalCursor into @nm,@bd;
print '2.' + @nm + ' ' + cast(@bd as varchar(6));
go 

declare GlobalCursor cursor global for
select Name_,BDay from STUDENT;
declare @nm char(50),@bd datetime;
open GlobalCursor;
fetch GlobalCursor into @nm,@bd;
print '1.' + @nm + ' ' + cast(@bd as varchar(6));
go 
declare @nm char(50),@bd datetime;
fetch GlobalCursor into @nm,@bd;
print '2.' + @nm + ' ' + cast(@bd as varchar(6));
close GlobalCursor;
deallocate GlobalCursor;

--Разработать сценарий, демонстрирую-щий отличие статических курсоров от динамических на примере базы данных X_UNIVER.
select * from AUDITORIUM;
go
declare LocalStaticCursor cursor static local for
select Aud,AudType from AUDITORIUM;
declare @au char(10),@aut char(10);
open LocalStaticCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete AUDITORIUM where Aud = '435-1';
fetch LocalStaticCursor into @au,@aut;
while @@FETCH_STATUS = 0
 begin
  print cast(@au as varchar(6)) + ' ' + @aut;
  fetch LocalStaticCursor into @au,@aut;
 end;
close LocalStaticCursor;

insert into AUDITORIUM values ('435-1','ЛК',45,'435-1');

declare LocalDynamicCursor cursor dynamic local for
select Aud,AudType from AUDITORIUM;
declare @aud char(10),@autd char(10);
open LocalDynamicCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete AUDITORIUM where Aud = '435-1';
fetch LocalDynamicCursor into @aud,@autd;
while @@FETCH_STATUS = 0
 begin
  print cast(@aud as varchar(6)) + ' ' + @autd;
  fetch LocalDynamicCursor into @aud,@autd;
 end;
close LocalDynamicCursor;

--Разработать сценарий, демонстрирую-щий свойства навигации в результиру-ющем наборе курсора с атрибутом SCROLL на примере базы данных X_UNIVER.
--Использовать все известные ключевые слова в операторе FETCH.

declare @sbj char(10), @sbjn char(20);
declare ScrollCursor cursor local dynamic scroll for
select ROW_NUMBER() over (order by Subject_) N,PDate from PROGRESS;
open ScrollCursor;
fetch last from ScrollCursor into @sbj,@sbjn;
print 'Last string: ' + @sbj + ' ' + @sbjn;
fetch first from ScrollCursor into @sbj,@sbjn;
print 'First string: ' + @sbj + ' ' + @sbjn;
fetch relative 3 from ScrollCursor into @sbj,@sbjn;
print 'Relative 3 string: ' + @sbj + ' ' + @sbjn;
fetch relative -3 from ScrollCursor into @sbj,@sbjn;
print 'Relative -3 string: ' + @sbj + ' ' + @sbjn;
fetch next from ScrollCursor into @sbj,@sbjn;
print 'Next string: ' + @sbj + ' ' + @sbjn;
fetch prior from ScrollCursor into @sbj,@sbjn;
print 'Prior string: ' + @sbj + ' ' + @sbjn;
fetch absolute 3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute 3 string: ' + @sbj + ' ' + @sbjn;
fetch absolute -3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute -3 string: ' + @sbj + ' ' + @sbjn;
close ScrollCursor;

--Создать курсор, демонстрирующий применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE.
select * from AUDITORIUM;
go
declare UpdateCursor cursor dynamic local for
select Aud,AudCapacity from AUDITORIUM for update;
declare @auu char(10),@autu char(10);
open UpdateCursor;
fetch UpdateCursor into @auu,@autu;
update AUDITORIUM set AudCapacity = '50' where current of UpdateCursor;
close UpdateCursor;
go
select * from AUDITORIUM;

--Разработать SELECT-запрос, с помощью которого из таблицы PROGRESS удаляются строки, содержащие информацию о студентах, 
--получивших оценки ниже 4 (использовать объеди-нение таблиц PROGRESS, STUDENT, GROUPS). 
insert PROGRESS values ('ХИМ',1001,'2020-01-01',3);
go
select* from PROGRESS;
declare DeleteStudentCursor cursor dynamic local for
select PROGRESS.IdStudent,Note, STUDENT.Name_,GROUPS.IdGroup
from PROGRESS inner join STUDENT
on PROGRESS.IdStudent = STUDENT.IdStudent 
inner join GROUPS 
on STUDENT.IdGroup = GROUPS.IdGroup;
declare @idd char(10),@ntd char(10),@nmd char(50),@idg char(10);
open DeleteStudentCursor;
fetch DeleteStudentCursor into @idd,@ntd,@nmd,@idg;
while @@FETCH_STATUS = 0
 begin
  delete PROGRESS where Note < 5;
  print cast(@idd as varchar(6)) + ' ' + @ntd + ' ' + @nmd+ ' ' + @idg;
  fetch DeleteStudentCursor into @idd,@ntd,@nmd,@idg;
 end;
close DeleteStudentCursor;

--Разработать SELECT-запрос, с по-мощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу).
declare CorrectMarkCursor cursor dynamic local for
select IdStudent,Note from PROGRESS where IdStudent = 1006 and Subject_ = 'ХИМ';
declare @ids char(10),@nt char(10);
open CorrectMarkCursor;
fetch CorrectMarkCursor into @ids,@nt;
update PROGRESS set Note = Note + 1 where current of CorrectMarkCursor;
print cast(@ids as varchar(6)) + ' ' + @nt;
close CorrectMarkCursor;


--
declare FacultyCursor cursor static local for
select FACULTY.Faculty from FACULTY;
declare @fc char(10);
open FacultyCursor;
fetch FacultyCursor into @fc;
while @@FETCH_STATUS = 0
 begin
  print 'Факультет: ' + @fc;
  declare PulpitCursor cursor static local for
  select PULPIT.Pulpit from FACULTY inner join PULPIT 
  on FACULTY.Faculty = PULPIT.Faculty where FACULTY.Faculty = @fc;
  declare @pl char(10),@ctt int;
  open PulpitCursor;
  fetch PulpitCursor into @pl;
  while @@FETCH_STATUS = 0
  begin
    print '  Кафедра: ' + @pl;
	select @ctt = count(*) from TEACHER where Pulpit = @pl;
	print '  Количество преподавателей: ' + cast(@ctt as varchar(6));
	   declare SubjectCursor cursor static local for
	   select SUBJECTS.Subject_ from PULPIT inner join SUBJECTS 
	   on PULPIT.Pulpit = SUBJECTS.Pulpit where PULPIT.Pulpit = @pl;
	   declare @sbjct char(10), @ds char(10);
	   open SubjectCursor;
	   fetch SubjectCursor into @sbjct;
	   while @@FETCH_STATUS = 0
	   begin
	   set @ds = CONCAT(@ds,@sbjct);
	   fetch SubjectCursor into @sbjct;
	   end;
	   close SubjectCursor;
	   deallocate SubjectCursor;
	   if(@ds is null)
	   set @ds = 'нет'
	   print '  Дисциплины: ' + @ds;
	   set @ds = null;
  fetch PulpitCursor into @pl;
  end;
  close PulpitCursor;
  deallocate PulpitCursor;
  fetch FacultyCursor into @fc;
 end;
close FacultyCursor;

