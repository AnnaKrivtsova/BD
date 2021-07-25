use Krivtsova_MyBase;
--Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ. 
--В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую. 
--Использовать встроенную функцию RTRIM.
declare NName cursor for select Название from Показатели where Название = 'Прибыль';
declare @nn char(40), @s char(300) = '';
open NName;
fetch NName into @nn;
print 'Показатели';
while @@FETCH_STATUS = 0
  begin
    set @s = RTRIM(@nn) + ',' + @s;
	fetch NName into @nn;
  end;
print @s;
close NName;
deallocate NName;

--Разработать сценарий, демонстрирующий отличие глобального курсора от локального на примере базы данных X_UNIVER.
declare LocalCursor cursor local for
select Название,Важность from Показатели;
declare @nm char(50),@bd int;
open LocalCursor;
fetch LocalCursor into @nm,@bd;
print '1.' + @nm + ' ' + cast(@bd as varchar(6));
go 
declare @nm char(50),@bd datetime;
fetch LocalCursor into @nm,@bd;
print '2.' + @nm + ' ' + cast(@bd as varchar(6));
go 

declare GlobalCursor cursor global for
select Название,Важность from Показатели;
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
declare LocalStaticCursor cursor static local for
select [Название показателя],[Значение показателя] from Анализ_показателей;
declare @au char(10),@aut char(10);
open LocalStaticCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete Анализ_показателей where [Название предприятия] = 'МегаФон';
fetch LocalStaticCursor into @au,@aut;
while @@FETCH_STATUS = 0
 begin
  print cast(@au as varchar(6)) + ' ' + @aut;
  fetch LocalStaticCursor into @au,@aut;
 end;
close LocalStaticCursor;

declare LocalDynamicCursor cursor dynamic local for
select [Название показателя],[Значение показателя] from Анализ_показателей;
declare @aud char(10),@autd char(10);
open LocalDynamicCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete Анализ_показателей where [Название предприятия] = 'МегаФон';
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
select ROW_NUMBER() over (order by [Значение показателя]) N,[Название показателя] from Анализ_показателей;
open ScrollCursor;
fetch ScrollCursor into @sbj, @sbjn;
print 'Next string: ' + @sbj + ' ' + @sbjn;
fetch last from ScrollCursor into @sbj,@sbjn;
print 'Last string: ' + @sbj + ' ' + @sbjn;
fetch first from ScrollCursor into @sbj,@sbjn;
print 'First string: ' + @sbj + ' ' + @sbjn;
fetch next from ScrollCursor into @sbj,@sbjn;
print 'Next string: ' + @sbj + ' ' + @sbjn;
fetch prior from ScrollCursor into @sbj,@sbjn;
print 'Prior string: ' + @sbj + ' ' + @sbjn;
fetch absolute 3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute 3 string: ' + @sbj + ' ' + @sbjn;
fetch absolute -3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute -3 string: ' + @sbj + ' ' + @sbjn;
fetch relative 3 from ScrollCursor into @sbj,@sbjn;
print 'Relative 3 string: ' + @sbj + ' ' + @sbjn;
fetch relative -3 from ScrollCursor into @sbj,@sbjn;
print 'Relative -3 string: ' + @sbj + ' ' + @sbjn;
close ScrollCursor;

--Создать курсор, демонстрирующий применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE.
declare UpdateCursor cursor dynamic local for
select Название,Важность from Показатели;
declare @auu char(10),@autu char(10);
open UpdateCursor;
fetch UpdateCursor into @auu,@autu;
update Показатели set Важность = '10' where current of UpdateCursor;
close UpdateCursor;

--Разработать SELECT-запрос, с помощью которого из таблицы PROGRESS удаляются строки, содержащие информацию о студентах, 
--получивших оценки ниже 4 (использовать объеди-нение таблиц PROGRESS, STUDENT, GROUPS). 
declare DeleteStudentCursor cursor dynamic local for
select Показатели.Название,[Значение показателя]
from Анализ_показателей inner join Показатели
on Анализ_показателей.[Название показателя] = Показатели.Название 
declare @idd char(20),@ntd char(20);
open DeleteStudentCursor;
fetch DeleteStudentCursor into @idd,@ntd;
while @@FETCH_STATUS = 0
 begin
  delete Показатели where Важность > 10;
  print @idd + ' ' + @ntd;
  fetch DeleteStudentCursor into @idd,@ntd;
 end;
close DeleteStudentCursor;


--Разработать SELECT-запрос, с по-мощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу).
declare CorrectMarkCursor cursor dynamic local for
select Название,Важность from Показатели;
declare @ids char(15),@nt char(15);
open CorrectMarkCursor;
fetch CorrectMarkCursor into @ids,@nt;
while @@FETCH_STATUS = 0
 begin
  update Показатели set Важность = Важность + 1 where Название = 'Прибыль';
  print @ids + ' ' + @nt;
  fetch CorrectMarkCursor into @ids,@nt;
 end;
close CorrectMarkCursor;

