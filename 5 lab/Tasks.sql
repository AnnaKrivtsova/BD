use KRI_UNIVER

Select AUDITORIUM_TYPE.AuditoriumType, AUDITORIUM.Aud from AUDITORIUM_TYPE inner join AUDITORIUM 
on AUDITORIUM_TYPE.AuditoriumType = AUDITORIUM.AudType;

Select AUDITORIUM_TYPE.AuditoriumType, AUDITORIUM.Aud from AUDITORIUM_TYPE inner join AUDITORIUM 
on AUDITORIUM_TYPE.AuditoriumType = AUDITORIUM.AudType and AUDITORIUM_TYPE.AuditoriumType in ('ЛК','ЛК-К');

Select AUDITORIUM_TYPE.AuditoriumType, AUDITORIUM.Aud from AUDITORIUM_TYPE,AUDITORIUM 
where AUDITORIUM_TYPE.AuditoriumType = AUDITORIUM.AudType;

Select AUDITORIUM_TYPE.AuditoriumType, AUDITORIUM.Aud from AUDITORIUM_TYPE,AUDITORIUM 
where AUDITORIUM_TYPE.AuditoriumType = AUDITORIUM.AudType and AUDITORIUM_TYPE.AuditoriumTypename like '%омпьютер%';

use KRI_UNIVER
create table PROGRESS
(  
 Subject_ char(10) constraint FK_Progress_Subject foreign key references SUBJECTS(Subject_),                
 IdStudent integer constraint PROGRESS_IDSTUDENT_FK foreign key references STUDENT(IdStudent),        
 PDate date, 
 Note integer check (Note between 1 and 10)
)
insert into PROGRESS (Subject_, IdStudent, PDate, Note)
    values ('ОАиП', 1000,  '01.10.2020',4),
           ('ОАиП', 1001,  '01.10.2020',8),
		   ('СУБД', 1000,  '01.12.2020',5),
           ('СУБД', 1001,  '01.12.2020',9),
		   ('БД', 1000, '06.05.2020',4),
           ('БД', 1001, '06.05.2020',7);

Select FACULTY.Faculty,PULPIT.Pulpit, PROFESSION.ProfessionName, SUBJECTS.Subject_,GROUPS.IdGroup,STUDENT.Name_,
case
when (PROGRESS.Note = 6) then 'шесть'
when (PROGRESS.Note = 7) then 'семь'
when (PROGRESS.Note = 8) then 'восемь'
else 'не входит в диапазон'
end Marks 
from FACULTY inner join PULPIT
on FACULTY.Faculty = PULPIT.Faculty
inner join PROFESSION on FACULTY.Faculty = PROFESSION.Faculty
inner join SUBJECTS on PULPIT.Pulpit = SUBJECTS.Pulpit
inner join GROUPS on FACULTY.Faculty = GROUPS.Faculty
inner join STUDENT on GROUPS.IdGroup = STUDENT.IdGroup
inner join PROGRESS on STUDENT.IdStudent = PROGRESS.IdStudent
where PROGRESS.NOTE = 6 or PROGRESS.NOTE = 7 or PROGRESS.NOTE = 8
order by PROGRESS.Note Desc;

Select FACULTY.Faculty,PULPIT.Pulpit, PROFESSION.ProfessionName, SUBJECTS.Subject_,STUDENT.Name_,
case
when (PROGRESS.Note = 6) then 'шесть'
when (PROGRESS.Note = 7) then 'семь'
when (PROGRESS.Note = 8) then 'восемь'
else 'не входит в диапазон'
end Marks 
from FACULTY inner join PULPIT
on FACULTY.Faculty = PULPIT.Faculty
inner join PROFESSION on FACULTY.Faculty = PROFESSION.Faculty
inner join SUBJECTS on PULPIT.Pulpit = SUBJECTS.Pulpit
inner join GROUPS on FACULTY.Faculty = GROUPS.Faculty
inner join STUDENT on GROUPS.IdGroup = STUDENT.IdGroup
inner join PROGRESS on STUDENT.IdStudent = PROGRESS.IdStudent
where PROGRESS.NOTE = 6 or PROGRESS.NOTE = 7 or PROGRESS.NOTE = 8
order by
(
case 
when (PROGRESS.Note = 8) then 2
when (PROGRESS.Note = 6) then 3
when (PROGRESS.Note = 7) then 1
else 4
end
);

Select isnull (TEACHER.TeacherName,'***')[Teacher],PULPIT.PulpitName from PULPIT left outer join TEACHER
on PULPIT.Pulpit = TEACHER.Pulpit;

Select isnull (TEACHER.TeacherName,'***')[Teacher],PULPIT.PulpitName from PULPIT right outer join TEACHER  
on PULPIT.Pulpit = TEACHER.Pulpit;

use KRI_UNIVER
create table COMPANIES(
[Name] nvarchar(50) constraint PK_Company primary key,
Town nvarchar(30),
)
create table WORKERS(
Id int identity(1,1) primary key,
[Name] nvarchar(20),
Surname nvarchar(30),
Company nvarchar(50) constraint FK_Workers_Company foreign key references COMPANIES([Name]),
);
insert into COMPANIES([Name], Town)
    values ('БелТранс', 'г.Минск'),('БелПочта', 'г.Витебск'),('Луч', 'г.Орша');
insert into WORKERS([Name], Surname, Company)
    values ('Виталий', 'Иванов', 'БелТранс'),('Иван', 'Сергеев', 'БелПочта'),('Наталья', 'Фелорова', 'Луч');
insert into COMPANIES([Name], Town)
    values ('Виталюр', 'г.Минск');
insert into WORKERS([Name], Surname)
    values ('Ирина', 'Павлова');

select * from COMPANIES full outer join WORKERS on COMPANIES.[Name] = WORKERS.Company;
select * from WORKERS full outer join COMPANIES on WORKERS.Company = COMPANIES.[Name];

select isnull (COMPANIES.[Name],'***')[Company name] ,WORKERS.[Name],WORKERS.Surname,isnull (COMPANIES.Town, '***')[Town] from WORKERS left outer join COMPANIES on WORKERS.Company = COMPANIES.[Name];
select isnull (WORKERS.[Name],'***')[Worker name] ,isnull (WORKERS.Surname, '***')[Surname],COMPANIES.[Name],COMPANIES.Town from WORKERS right outer join COMPANIES on WORKERS.Company = COMPANIES.[Name];

Select WORKERS.[Name], WORKERS.Surname,COMPANIES.[Name],COMPANIES.Town from WORKERS inner join COMPANIES on WORKERS.Company = COMPANIES.[Name];

Select AUDITORIUM_TYPE.AuditoriumType, AUDITORIUM.Aud from AUDITORIUM_TYPE cross join AUDITORIUM 
where AUDITORIUM_TYPE.AuditoriumType = AUDITORIUM.AudType;

use KRI_UNIVER
create table TIMETABLE(
IdLesson int identity(1,1) primary key,
Groupe int constraint FK_Group_IdGroup foreign key references GROUPS(IdGroup),
Auditoria char(20) constraint FK_Auditoria_Aud foreign key references AUDITORIUM(Aud),
Subject_ char(10) constraint FK_Subject_Subject foreign key references SUBJECTS(Subject_),
Teacher char(10) constraint FK_Teacher_TeacherName foreign key references TEACHER(Teacher),
Day_of_week char(2),
Lesson int default 0,
);
insert into TIMETABLE(Groupe,Auditoria,Subject_,Teacher,Day_of_week,Lesson)
    values (1,'236-1', 'БД','АКНВЧ','пн',1),(2,'301-1', 'ОАиП','СМЛВ','пн',2),(3,'313-1', 'СУБД','АКНВЧ','пн',2);
insert into TIMETABLE(Groupe,Auditoria,Subject_,Teacher,Day_of_week,Lesson)
    values (1,'206-1', 'ОАиП','АКНВЧ','пн',3),(2,'314-1', 'СУБД','СМЛВ','пн',1);
insert into TIMETABLE(Groupe,Auditoria,Subject_,Teacher,Day_of_week,Lesson)
    values (1,'206-1', 'ОАиП','АКНВЧ','вт',3),(2,'314-1', 'СУБД','СМЛВ','вт',1);

select TIMETABLE.Auditoria[Free auditoria] ,TIMETABLE.Lesson, AUDITORIUM.AudType from AUDITORIUM left outer join TIMETABLE 
on AUDITORIUM.Aud = TIMETABLE.Auditoria
where TIMETABLE.Groupe is null;

select TIMETABLE.Auditoria, AUDITORIUM.AudType, TIMETABLE.Day_of_week from AUDITORIUM left outer join TIMETABLE 
on TIMETABLE.Auditoria = AUDITORIUM.Aud
where TIMETABLE.Day_of_week like 'пн' and TIMETABLE.Subject_ is null;

select TIMETABLE.Teacher, TIMETABLE.Day_of_week, TEACHER.TeacherName, TIMETABLE.Lesson from TEACHER left outer join TIMETABLE 
on TIMETABLE.Teacher = TEACHER.Teacher
where TIMETABLE.Groupe is null;

select TIMETABLE.Day_of_week, GROUPS.IdGroup, GROUPS.Course,TIMETABLE.Lesson from GROUPS left outer join TIMETABLE 
on TIMETABLE.Groupe = GROUPS.IdGroup
where TIMETABLE.Subject_ is null; 
