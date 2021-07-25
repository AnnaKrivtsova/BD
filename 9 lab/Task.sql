use KRI_UNIVER;
--Разработать T-SQL-скрипт, в котором: 
 --объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
  --первые две переменные проинициа-лизировать в операторе объявления;
 declare @a char = 'a',
         @b varchar(3) = 'BBB',
		 @c datetime,
		 @e time,
		 @d int,
		 @f smallint,
		 @g tinyint,
		 @h numeric(12,5);
 --присвоить произвольные значения следующим двум переменным с помо-щью оператора SET, 
 --одной из этих пе-ременных присвоить значение, получен-ное в результате запроса SELECT; 
 set @c = (select top 1 PDate from PROGRESS); 
 set @e = getdate();

 --одну из переменных оставить без инициализации и не присваивать ей зна-чения, 
 --оставшимся переменным присво-ить некоторые значения с помощью оператора SELECT; 
 select @f = 1;
 select @g = 0;
 select @h = 12;
 --значения одной половины переменных вывести с помощью оператора SELECT, 
 select @a a,@b b,@c c,@e e,@d d;
 --значения другой половины переменных распечатать с помощью оператора PRINT. 
 print 'e = ' +cast(@e as varchar(10));
 print 'f = ' +cast(@f as varchar(10));
 print 'g = ' +cast(@g as varchar(10));
 print 'h = ' +cast(@h as varchar(10));

 --Разработать скрипт, в котором опреде-ляется общая вместимость аудиторий. 
 --Когда общая вместимость превышает 200, то вывести количество аудиторий, среднюю вместимость аудиторий, 
 --коли-чество аудиторий, вместимость которых меньше средней, и процент таких ауди-торий. 
 --Когда общая вместимость ауди-торий меньше 200, то вывести сообще-ние о размере общей вместимости.
 declare @capacity int;
 select @capacity = sum(AudCapacity) from AUDITORIUM;
 if @capacity > 200
  begin 
   declare @count numeric(5,3),
   @avgCapacity numeric(5,3),
   @percentCapacityLessAvg numeric(5,3),
   @countCapacityLessAvg numeric(5,3);
   set @count = (select count(*) from AUDITORIUM);
   set @avgCapacity  = (select avg(AudCapacity) from AUDITORIUM);
   set @countCapacityLessAvg = (select count(*) from AUDITORIUM where AudCapacity < @avgCapacity);
   set @percentCapacityLessAvg  = (@countCapacityLessAvg/@count)*100;

   select @count 'Count',
   @avgCapacity 'Avg', 
   @countCapacityLessAvg 'Count capacity < avg',
   @percentCapacityLessAvg 'Percent'
  end
 else 
  begin
   print 'All capacity ' + cast(@capacity as varchar(10));
  end

  --Разработать T-SQL-скрипт, ко-торый выводит на печать глобальные переменные: 
  --@@ROWCOUNT (число обрабо-танных строк); 
  --@@VERSION (версия SQL Server);
  --@@SPID (возвращает системный идентификатор процесса, назначен-ный сервером текущему подключе-нию); 
  --@@ERROR (код последней ошибки); 
  --@@SERVERNAME (имя сервера); 
  --@@TRANCOUNT (возвращает уровень вложенности транзакции); 
  --@@FETCH_STATUS (проверка ре-зультата считывания строк результи-рующего набора); 
  --@@NESTLEVEL (уровень вложен-ности текущей процедуры).

     print 'rowcount = ' +cast(@@rowcount as varchar(10));
	 print 'version = ' +cast(@@version as varchar(10));
     print 'spid = ' +cast(@@spid as varchar(10));
     print 'error = ' +cast(@@error as varchar(10));
     print 'servername = ' +cast(@@servername as varchar(10));
     print 'trancount = ' +cast(@@trancount as varchar(10));
     print 'fetch_status = ' +cast(@@fetch_status as varchar(10));
     print 'nestlevel = ' +cast(@@nestlevel as varchar(10));

 --вычисление значений переменной z 
 declare @z float,@t int = 2,@x int = 3;
 if @t > @x
 set @z = sin(@t)*sin(@t);
 else if @t < @x
 set @z = 4*(@t+@x)
 else
 set @z = 1 - exp(@x-2);
 print 'z = ' +cast(@z as varchar(10));

 --преобразование полного ФИО студента в сокращенное
declare @fullname varchar(50) = 'Krivtsova Anna Pavlovna';
select @fullname;
declare @surname varchar(50) = (select top(1) * from string_split(@fullname,' '));
set @fullname = ltrim(replace(@fullname,@surname,''));
declare @name varchar(50) = (select top(1) * from string_split(@fullname,' '));
set @fullname = ltrim(replace(@fullname,@name,''));
declare @middlename varchar(50) = (select top(1) * from string_split(@fullname,' '));
declare @output varchar(50) = @surname + ' ' + substring(@name,1,1) + '. ' + substring(@middlename,1,1) + '. ';
select @output;

 --поиск студентов, у которых день рож-дения в следующем месяце, и определе-ние их возраста;
 declare @currentDate date = getdate();
   print cast(@currentDate as varchar(10));
 declare @nextmohth int = month(@currentDate)+1;
    print cast(@nextmohth as varchar(10));
 select Name_, BDay, datediff(year, BDay, @currentDate) [Years old] from STUDENT
 where month(BDAY) = @nextmohth;

 --поиск дня недели, в который сту-денты некоторой группы сдавали экза-мен по СУБД.
 select distinct datename(dw,PDate) [День сдачи] from PROGRESS 
where Subject_ in ('СУБД');

 --Продемонстрировать конструкцию IF… ELSE на примере анализа данных таб-лиц базы данных Х_UNIVER.
 declare @countOfStudents int = (select count(*) from STUDENT)
 if(@countOfStudents > 100)
 begin
  print 'Count of students more then 100';
  print 'Count of students = ' + cast(@countOfStudents as varchar(10));
 end
 begin 
  print 'Count of students less then 100';
  print 'Count of students = ' + cast(@countOfStudents as varchar(10));
 end

 --Разработать сценарий, в котором с по-мощью CASE анализируются оценки, 
 --полученные студентами некоторого фа-культета при сдаче экзаменов.
 select IdStudent,Subject_,Note as Note, 
  case 
  when Note between 5 and 6 then 'Удовлетворительно'
  when Note between 7 and 8 then 'Хорошо'
  when Note between 9 and 10 then 'Отлично'
  else 'Плохо'
  end as Comment
 from PROGRESS

 --Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. 
 --Использовать оператор WHILE.
 create table #task7
 ( 
   Id int identity(1000,1),
   Name_ nvarchar(50) default 'A' null,
   Surname nvarchar(50) default 'B' null
 )
 declare @i int = 1;
 while @i<11
  begin
	insert #task7(Name_, Surname) values(replicate('A',@i),replicate('B',@i));
	set @i=@i+1;
  end
 select * from #task7
 drop table #task7

 --Разработать скрипт, демонстрирующий использование оператора RETURN. 
 declare @variable int = 5
 print @variable *2
 return
 print @variable *5

 --Разработать сценарий с ошибками, в ко-тором используются для обработки ошибок блоки TRY и CATCH. 
 --Приме-нить функции ERROR_NUMBER (код последней ошибки), ERROR_MESSAGE (сообщение об ошибке), 
 --ERROR_LINE (код последней ошибки), ER-ROR_PROCEDURE (имя процедуры или NULL),
 --ERROR_SEVERITY (уровень серьезности ошибки), ERROR_STATE (метка ошибки)
 go
 declare @i int = 5, @z int = 0;
 begin try
 print @i/@z;
 end try
 begin catch
 print 'Код последней ошибки ' + cast(ERROR_NUMBER() as varchar(200));
 print 'Сообщение об ошибке ' + ERROR_MESSAGE()
 print 'Номер строки с ошибкой ' +cast(ERROR_LINE() as varchar(200));
 print 'Имя процедуры или NULL ' + cast(ERROR_PROCEDURE() as varchar(200));
 print 'Уровень серьезности ошибки ' + cast(ERROR_SEVERITY() as varchar(200));
 print 'Метка ошибки ' + cast(ERROR_STATE() as varchar(200));
 end catch


