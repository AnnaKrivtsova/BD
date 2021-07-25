use KRI_UNIVER;
select PULPIT.PulpitName, PROFESSION.Faculty,PROFESSION.ProfessionName from PULPIT, PROFESSION
where PULPIT.Faculty = PROFESSION.Faculty and ProfessionName in (select ProfessionName from PROFESSION where (ProfessionName like '%технолог%' ));

select PULPIT.PulpitName, PROFESSION.Faculty,PROFESSION.ProfessionName from PULPIT inner join PROFESSION
on PULPIT.Faculty = PROFESSION.Faculty and ProfessionName in (select ProfessionName from PROFESSION where (ProfessionName like '%технолог%' ));

select PULPIT.PulpitName, FACULTY.Faculty,PROFESSION.ProfessionName from PULPIT inner join FACULTY
on PULPIT.Faculty = FACULTY.Faculty inner join PROFESSION 
on PROFESSION.Faculty = FACULTY.Faculty where (ProfessionName like'%технолог%' );

select Aud,AudType,AudCapacity from AUDITORIUM a 
where AudCapacity = (select top(1) AudCapacity from AUDITORIUM aa where aa.AudType = a.AudType order by AudCapacity desc);

select FACULTY.FacultyName from FACULTY 
where not exists (select * from PULPIT where FACULTY.Faculty = PULPIT.Faculty);

select top 1 (select avg(Note) from PROGRESS where Subject_ like 'ОАиП')[ОАиП],
(select avg(Note) from PROGRESS where Subject_ like 'БД')[БД],
(select avg(Note) from PROGRESS where Subject_ like 'СУБД')[СУБД];

--Выбор студентов с оценкой больше или равной всех оценок по ОАиП
select IdStudent,Note,Subject_ from PROGRESS
where Note >=all(select Note from PROGRESS where Subject_ like 'ОАип')

select IdStudent,Note,Subject_ from PROGRESS
where Note >=any(select Note from PROGRESS where Subject_ like 'БД')

with DuplicateValue as (
        select BDay
        from STUDENT
        group by BDay
        having COUNT(*) > 1
   )
select Name_,BDay from STUDENT 
where BDay in (select BDay from DuplicateValue)
