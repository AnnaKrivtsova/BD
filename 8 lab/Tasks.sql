use KRI_UNIVER;

--Разработать представление с именем Преподаватель. 
create view Преподаватель 
as select Teacher,TeacherName, Gender,Pulpit from TEACHER;
go
select * from Преподаватель;

drop view Преподаватель;

--Разработать и создать представление с именем  Количество кафедр
create view [Количество кафедр] as 
select FACULTY.FacultyName, count (*) [Количество кафедр ]
from FACULTY inner join PULPIT on FACULTY.Faculty = PULPIT.Faculty
group by FACULTY.FacultyName;
go
select * from [Количество кафедр];

drop view [Количество кафедр];

--Объяснить невозможность выполнения опе-раторов INSERT, UPDATE и DELETE для представления Количество кафедр. 
--Потому что есть оператор group by и вычисляемое значение, должна быть одна таблица

--Разработать и создать представление с именем Аудитории
create view Аудитории(Код, Наименвание_аудитории, Тип_аудитории)
	as select Aud,AudName,AudType from AUDITORIUM
	where AudType like 'ЛК%';
go
select * from [Аудитории];

drop view [Аудитории];

--и допускать выполнение оператора INSERT, UPDATE и DELETE.
insert Аудитории values('430-1','430-1','ЛК')
insert Аудитории values('500-1','500-1','ЛБ-К')
insert Аудитории values('435-1','435-1','ЛК')
select * from Аудитории

--Разработать и создать представление с именем Лекционные_аудитории. 
create view Лекционные_аудитории as 
select Aud,AudName,AudType
from AUDITORIUM 
where AudType like 'ЛК%'
with check option;
go
select * from Лекционные_аудитории;

insert Лекционные_аудитории values('434-1','430-1','ЛБ');

drop view Лекционные_аудитории;

--Разработать и создать представление с именем Дисциплины
create view Дисциплины as 
select top 3 Subject_,SubjectName,Pulpit
from SUBJECTS
order by SubjectName;
go
select * from Дисциплины;

drop view Дисциплины;

--Изменить представление Количество_кафедр, созданное в задании 2 так, чтобы оно было привязано к базовым таблицам. 
alter view [Количество кафедр] with schemabinding 
as select FACULTY.FacultyName, count (*) [Количество кафедр]
from dbo.FACULTY inner join dbo.PULPIT 
on FACULTY.Faculty = PULPIT.Faculty
group by FACULTY.FacultyName;
go
select * from [Количество кафедр];

alter table FACULTY drop column FacultyName;

drop view [Количество кафедр];

--Разработать представление для таблицы TIMETABLE в виде расписания. Изучить оператор PIVOT и использовать его.
create view Расписание as 
select *
from (select Day_of_week[День недели],
     Auditoria[Аудитория],
	 Subject_ [Предмет] from TIMETABLE) t
	 pivot (count(Предмет) for [День недели] in ([пн],[вт],[ср])) as pvt
go
select * from Расписание;

drop view Расписание;