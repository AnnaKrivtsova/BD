--Разработать сценарий, демон-стрирующий работу в режиме неявной транзакции.
use KRI_UNIVER;
set nocount on
	if  exists (select * from  SYS.OBJECTS
	            where OBJECT_ID= object_id(N'DBO.UNIVER_EVENTS') )	            
	  drop table UNIVER_EVENTS;           
	declare @c int, @flag char = 'c';      
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table UNIVER_EVENTS(event_name char(20), capacity int );  -- начало транзакции 
		INSERT UNIVER_EVENTS values ('Конференция', 100),
									('Олимпиада', 30)								
		set @c = (select count(*) from UNIVER_EVENTS);
		print 'количество строк в таблице UNIVER_EVENTS: ' + cast( @c as varchar(2));
		if @flag = 'c'  
		  commit;                 
	    else     
		  rollback;                   
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS  
	            where OBJECT_ID= object_id(N'DBO.UNIVER_EVENTS') )
	  print 'таблица UNIVER_EVENTS есть';  
    else 
	  print 'таблицы UNIVER_EVENTS нет'
select * from UNIVER_EVENTS

--Разработать сценарий, демон-стрирующий свойство атомарности явной транзакции 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных операторов модификации таб-лиц.
use KRI_UNIVER;
select * from AUDITORIUM;

begin try
	begin tran -- начало явной транзакции
		delete AUDITORIUM where AudCapacity = 15;
		insert AUDITORIUM values ('403-4', 'ЛК', 20, '401-4');
		commit tran; -- фиксация транзакции
	end try
	begin catch
		print 'error: ' + case
		when error_number() = 2627 and patindex('%PK_Aud%', error_message()) > 0
		then 'Дублирование аудитории'
		else 'Неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
		end;
		if @@trancount > 0 
		  rollback tran;
	end catch;

--Разработать сценарий, демонстрирующий применение оператора SAVE TRAN
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных контрольных точек и различных операторов модификации таб-лиц.
select * from AUDITORIUM;
declare @point varchar(32)
begin try
	begin tran
		delete AUDITORIUM where AudCapacity = 15;
		set  @point = 'p1'; 
		save tran @point; -- контрольная точка
		insert AUDITORIUM values ('309-4', 'ЛК', 60, '300-4');
		set  @point = 'p2'; 
		save tran @point;
		insert AUDITORIUM values ('443-1', 'ЛК', 120, '443-1');
		commit tran;
	end try
	begin catch
		print 'error: ' + case
		when error_number() = 2627 and patindex('%PK_Aud%', error_message()) > 0
		then 'Дублирование аудитории'
		else 'Неизвестная ошибка: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
		end;
		if @@trancount > 0
			begin
				print 'контрольная точка: ' + @point;
				rollback tran @point; -- откат к контрольной точке
				commit tran; -- фиксация изменений, выполненных до контрольной точки
			end;
	end catch;

--Разработать два сценария A и B 
--Сценарий A представляет собой явную транзакцию с уров-нем изолированности READ UNCOMMITED, 
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию). 
--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение. 
select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;
    
	--- B --	
	begin transaction 
	select @@SPID
	insert AUDITORIUM_TYPE values ('ЛК-К', 'Лекционная с уст. проектором'); 
	update AUDITORIUM set AudCapacity  =  30 where Aud = '314-1' 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;
	

--Разработать два сценария A и B на примере базы данных 
--Сценарии A и В представляют собой явные транзакции с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает не-подтвержденного чтения, 
--но при этом возможно неповторя-ющееся и фантомное чтение. 
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
	insert AUDITORIUM_TYPE values ('ЛК-К', 'Лекционная с уст. проектором'); 
    update AUDITORIUM set Aud = '443-1*' where Aud = '443-1' 
    commit; 
	-------------------------- t2 --------------------	

	--повтор чтение
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
    delete from AUDITORIUM where Aud = '443-1' 
    commit; 
	-------------------------- t2 --------------------	
--Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности REPEATABLE READ. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демон-стрировать, что уровень REAPETABLE READ не допус-кает неподтвержденного чтения и неповторяющегося чтения, 
--но при этом возможно фантомное чтение. 
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
    insert AUDITORIUM values ('443-1','ЛБ-К',45,'443-1');
    commit; 
	-------------------------- t2 --------------------

--Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности SERIALIZABLE. 
--Сценарий B – явную транзак-цию с уровнем изолированно-сти READ COMMITED.
--Сценарий A должен демон-стрировать отсутствие фантом-ного, неподтвержденного и не-повторяющегося чтения.
	--- B ---	
	begin transaction 	  
	delete AUDITORIUM where Aud = '443-1';  
    insert AUDITORIUM values ('200-3','ЛБ-К',45,'200-3');
    update AUDITORIUM set AudType = 'ЛК' where AudCapacity = 60;
    -------------------------- t1 --------------------
    commit; 
    -------------------------- t2 --------------------
	
--Разработать сценарий, демон-стрирующий свойства вложен-ных транзакций, на примере ба-зы данных X_UNIVER.
select * from AUDITORIUM;

begin tran
    insert AUDITORIUM_TYPE values ('ЛК1-К','лекционная 1');
	begin tran
	 update AUDITORIUM set AudName='ЛК1-К' where AudType = 'ЛК1-К';
	 commit;
	 if @@TRANCOUNT > 0 
	  rollback;
	select (select count(*) from AUDITORIUM where AudName = 'ЛК1-К')'Auditorium',
	(select count(*) from AUDITORIUM_TYPE where AuditoriumType = 'ЛК1-К')'Auditorium type';