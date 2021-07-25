--Разработать два сценария A и B 
--Сценарий A представляет собой явную транзакцию с уров-нем изолированности READ UNCOMMITED, 
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию). 
-- A ---
select * from AUDITORIUM_TYPE where AuditoriumType = 'ЛК-К';
use KRI_UNIVER;
	set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert AUDITORIUM_TYPE' 'результат', * from AUDITORIUM_TYPE 
	where AuditoriumType = 'ЛК-К';
	select @@SPID, 'update AUDITORIUM'  'результат',  Aud, 
    AudCapacity from AUDITORIUM   where Aud = '314-1';
	commit; 
	-------------------------- t2 -----------------

--Разработать два сценария A и B на примере базы данных 
--Сценарии A и В представляют собой явные транзакции с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает не-подтвержденного чтения, 
--но при этом возможно неповторя-ющееся и фантомное чтение. 
    -- A ---
    set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from AUDITORIUM where Aud = '443-1';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  'update AUDITORIUM'  'результат', count(*) from AUDITORIUM  where Aud = '443-1*';
	rollback; 

	--повторяющееся чтение
	-- A ---
    set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from AUDITORIUM where Aud = '443-1*';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  count(*) from AUDITORIUM where Aud = '443-1*';
	rollback; 


--Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности REPEATABLE READ. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демон-стрировать, что уровень REAPETABLE READ не допус-кает неподтвержденного чтения и неповторяющегося чтения, 
--но при этом возможно фантомное чтение. 
    -- A ---
    set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select Aud from AUDITORIUM;
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select * from AUDITORIUM;
	select 'insert  AUDITORIUM' 'результат', AudName from AUDITORIUM where Aud='443-1*';
	commit; 

--Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности SERIAL-IZABLE. 
--Сценарий B – явную транзак-цию с уровнем изолированно-сти READ COMMITED.
--Сценарий A должен демон-стрировать отсутствие фантом-ного, неподтвержденного и не-повторяющегося чтения.
    -- A ---
    set transaction isolation level SERIALIZABLE 
	begin transaction 
    select  Aud from AUDITORIUM  where Aud = '443-1'; 
	-------------------------- t1 -----------------
    select  Aud from AUDITORIUM  where Aud = '443-1'; 
	-------------------------- t2 ------------------ 
	commit; 