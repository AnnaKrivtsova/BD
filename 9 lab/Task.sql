use KRI_UNIVER;
--����������� T-SQL-������, � �������: 
 --�������� ���������� ���� char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
  --������ ��� ���������� ���������-���������� � ��������� ����������;
 declare @a char = 'a',
         @b varchar(3) = 'BBB',
		 @c datetime,
		 @e time,
		 @d int,
		 @f smallint,
		 @g tinyint,
		 @h numeric(12,5);
 --��������� ������������ �������� ��������� ���� ���������� � ����-��� ��������� SET, 
 --����� �� ���� ��-�������� ��������� ��������, �������-��� � ���������� ������� SELECT; 
 set @c = (select top 1 PDate from PROGRESS); 
 set @e = getdate();

 --���� �� ���������� �������� ��� ������������� � �� ����������� �� ���-�����, 
 --���������� ���������� ������-��� ��������� �������� � ������� ��������� SELECT; 
 select @f = 1;
 select @g = 0;
 select @h = 12;
 --�������� ����� �������� ���������� ������� � ������� ��������� SELECT, 
 select @a a,@b b,@c c,@e e,@d d;
 --�������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
 print 'e = ' +cast(@e as varchar(10));
 print 'f = ' +cast(@f as varchar(10));
 print 'g = ' +cast(@g as varchar(10));
 print 'h = ' +cast(@h as varchar(10));

 --����������� ������, � ������� ������-������ ����� ����������� ���������. 
 --����� ����� ����������� ��������� 200, �� ������� ���������� ���������, ������� ����������� ���������, 
 --����-������ ���������, ����������� ������� ������ �������, � ������� ����� ����-�����. 
 --����� ����� ����������� ����-����� ������ 200, �� ������� ������-��� � ������� ����� �����������.
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

  --����������� T-SQL-������, ��-����� ������� �� ������ ���������� ����������: 
  --@@ROWCOUNT (����� ������-������ �����); 
  --@@VERSION (������ SQL Server);
  --@@SPID (���������� ��������� ������������� ��������, ��������-��� �������� �������� ��������-���); 
  --@@ERROR (��� ��������� ������); 
  --@@SERVERNAME (��� �������); 
  --@@TRANCOUNT (���������� ������� ����������� ����������); 
  --@@FETCH_STATUS (�������� ��-�������� ���������� ����� ��������-������� ������); 
  --@@NESTLEVEL (������� ������-����� ������� ���������).

     print 'rowcount = ' +cast(@@rowcount as varchar(10));
	 print 'version = ' +cast(@@version as varchar(10));
     print 'spid = ' +cast(@@spid as varchar(10));
     print 'error = ' +cast(@@error as varchar(10));
     print 'servername = ' +cast(@@servername as varchar(10));
     print 'trancount = ' +cast(@@trancount as varchar(10));
     print 'fetch_status = ' +cast(@@fetch_status as varchar(10));
     print 'nestlevel = ' +cast(@@nestlevel as varchar(10));

 --���������� �������� ���������� z 
 declare @z float,@t int = 2,@x int = 3;
 if @t > @x
 set @z = sin(@t)*sin(@t);
 else if @t < @x
 set @z = 4*(@t+@x)
 else
 set @z = 1 - exp(@x-2);
 print 'z = ' +cast(@z as varchar(10));

 --�������������� ������� ��� �������� � �����������
declare @fullname varchar(50) = 'Krivtsova Anna Pavlovna';
select @fullname;
declare @surname varchar(50) = (select top(1) * from string_split(@fullname,' '));
set @fullname = ltrim(replace(@fullname,@surname,''));
declare @name varchar(50) = (select top(1) * from string_split(@fullname,' '));
set @fullname = ltrim(replace(@fullname,@name,''));
declare @middlename varchar(50) = (select top(1) * from string_split(@fullname,' '));
declare @output varchar(50) = @surname + ' ' + substring(@name,1,1) + '. ' + substring(@middlename,1,1) + '. ';
select @output;

 --����� ���������, � ������� ���� ���-����� � ��������� ������, � ��������-��� �� ��������;
 declare @currentDate date = getdate();
   print cast(@currentDate as varchar(10));
 declare @nextmohth int = month(@currentDate)+1;
    print cast(@nextmohth as varchar(10));
 select Name_, BDay, datediff(year, BDay, @currentDate) [Years old] from STUDENT
 where month(BDAY) = @nextmohth;

 --����� ��� ������, � ������� ���-����� ��������� ������ ������� ����-��� �� ����.
 select distinct datename(dw,PDate) [���� �����] from PROGRESS 
where Subject_ in ('����');

 --������������������ ����������� IF� ELSE �� ������� ������� ������ ���-��� ���� ������ �_UNIVER.
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

 --����������� ��������, � ������� � ��-����� CASE ������������� ������, 
 --���������� ���������� ���������� ��-�������� ��� ����� ���������.
 select IdStudent,Subject_,Note as Note, 
  case 
  when Note between 5 and 6 then '�����������������'
  when Note between 7 and 8 then '������'
  when Note between 9 and 10 then '�������'
  else '�����'
  end as Comment
 from PROGRESS

 --������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. 
 --������������ �������� WHILE.
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

 --����������� ������, ��������������� ������������� ��������� RETURN. 
 declare @variable int = 5
 print @variable *2
 return
 print @variable *5

 --����������� �������� � ��������, � ��-����� ������������ ��� ��������� ������ ����� TRY � CATCH. 
 --�����-���� ������� ERROR_NUMBER (��� ��������� ������), ERROR_MESSAGE (��������� �� ������), 
 --ERROR_LINE (��� ��������� ������), ER-ROR_PROCEDURE (��� ��������� ��� NULL),
 --ERROR_SEVERITY (������� ����������� ������), ERROR_STATE (����� ������)
 go
 declare @i int = 5, @z int = 0;
 begin try
 print @i/@z;
 end try
 begin catch
 print '��� ��������� ������ ' + cast(ERROR_NUMBER() as varchar(200));
 print '��������� �� ������ ' + ERROR_MESSAGE()
 print '����� ������ � ������� ' +cast(ERROR_LINE() as varchar(200));
 print '��� ��������� ��� NULL ' + cast(ERROR_PROCEDURE() as varchar(200));
 print '������� ����������� ������ ' + cast(ERROR_SEVERITY() as varchar(200));
 print '����� ������ ' + cast(ERROR_STATE() as varchar(200));
 end catch


