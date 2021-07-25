use master;
create database TMP_KRI_UNIVER;

create table FACULTY(    
Faculty char(10) constraint PK_Faculty primary key,
FacultyName varchar(50) default '???'
);

create table AUDITORIUM_TYPE 
(    
AuditoriumType char(10) constraint PK_AuditoriumType  primary key,  
AuditoriumTypename varchar(30)       
);

create table PROFESSION(
Profession char(20) constraint PK_Profession  primary key,
Faculty char(10) constraint FK_Profession_Faculty foreign key references FACULTY(Faculty),
ProfessionName varchar(100),    
Qualification varchar(50)  
);

create table PULPIT(
Pulpit char(20) constraint PK_Pulpit primary key,
PulpitName varchar(100),
Faculty char(10) not null constraint FK_Pulpit_Faculty foreign key references FACULTY(Faculty),
);

create table TEACHER(
Teacher char(10) constraint PK_Teacher  primary key,
TeacherName varchar(100), 
Gender char(1) CHECK (GENDER in ('м', 'ж')),
Pulpit char(20) not null constraint FK_Pulpit_Teacher foreign key references PULPIT(Pulpit) 
);

create table SUBJECTS(
Subject_ char(10) constraint PK_Sublect primary key, 
SubjekcName varchar(100) unique,
Pulpit char(20) constraint FK_Subject_Pulpit foreign key references PULPIT(Pulpit)   
);

create table AUDITORIUM(
Aud char(20) constraint PK_Aud primary key,
AudType char(10) not null constraint FK_AudType_Aud foreign key references AUDITORIUM_TYPE(AuditoriumType),
AudCapacity integer constraint AudCapacityCheck default 1 check (AudCapacity between 1 and 300),
AudName nvarchar(50),
);

create table GROUPS(
IdGroup integer identity(1,1) constraint PK_Group  primary key,              
Faculty char(10) constraint  FK_Groups_Faculty foreign key references FACULTY(Faculty), 
Profession char(20) constraint  FK_Group_Profession foreign key references PROFESSION(Profession),
YearFirst smallint check (YearFirst<=YEAR(GETDATE())),    
Course as YEAR(GETDATE())- YearFirst
);

create table STUDENT (
IdStudent integer identity(1000,1) constraint PK_Student primary key,
IdGroup integer  constraint FK_Student_group foreign key references GROUPS(IdGroup),        
Name_ nvarchar(100), 
BDay date,
Stamp timestamp,
Info xml default null,
Foto varbinary(max) default null
);

insert into AUDITORIUM_TYPE(AuditoriumType,  AuditoriumTypename ) values 
('ЛК','Лекционная'),('ЛБ-К','Компьютерный класс');
insert into FACULTY (Faculty, FacultyName )values
('ХТиТ','Химическая технология и техника'),('ЛХФ','Лесохозяйственный факультет'),
('ИТ', 'Факультет информационных технологий'); 
insert into PULPIT (Pulpit, PulpitName, Faculty ) values  
('ИСиТ', 'Информационных систем и технологий ','ИТ'),
('ЛПиСПС','Ландшафтного проектирования и садово-паркового строительства','ЛХФ');
insert into SUBJECTS (Subject_,   SubjekcName, Pulpit ) values 
('СУБД','Системы управления базами данных', 'ИСиТ'), ('БД','Базы данных','ИСиТ');
insert into  AUDITORIUM   (Aud, AudName, AudType, AudCapacity) values
('206-1', '206-1','ЛБ-К', 15),('301-1','301-1','ЛБ-К', 15);
insert into TEACHER(Teacher,TeacherName,Gender,Pulpit) values
('СМЛВ','Смелов Владимир Владиславович', 'м','ИСиТ'),
('АКНВЧ','Акунович Станислав Иванович', 'м', 'ИСиТ');
insert into PROFESSION(Faculty, Profession, ProfessionName, Qualification) values    
('ИТ',  '1-40 01 02','Информационные системы и технологии', 'инженер-программист-системотехник' ),
('ХТиТ','1-36 01 08','Конструирование и производство изделий из композиционных материалов', 'инженер-механик' );
insert into GROUPS (Faculty,  Profession, YearFirst)values 
('ИТ','1-40 01 02', 2018),('ИТ','1-40 01 02', 2019),('ИТ','1-40 01 02', 2020)
insert into STUDENT (IdGroup, Name_, BDay) values 
(1, 'Хартанович Екатерина Александровна', '11.03.2000'),        
(1, 'Горбач Елизавета Юрьевна',    '07.12.2000');

select * from AUDITORIUM_TYPE;
select * from FACULTY;
select * from PULPIT;
select * from SUBJECTS;
select * from AUDITORIUM;
select * from TEACHER;
select * from PROFESSION;
select * from GROUPS;
select * from STUDENT;







