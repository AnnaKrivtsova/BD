use master;
create database KRI_UNIVER on primary
(name = N'KRI_UNIVER_mdf',filename = N'D:\BD\4\KRI_UNIVER.mdf',
size = 5Mb,maxsize = 10Mb,filegrowth= 1Mb),
(name = N'KRI_UNIVER_ndf',filename = N'D:\BD\4\KRI_UNIVER.ndf',
size = 5Mb,maxsize = 10Mb,filegrowth= 10%),
filegroup G1
(name = N'KRI_UNIVER11_ndf',filename = N'D:\BD\4\KRI_UNIVER11.ndf',
size = 10Mb,maxsize = 15Mb,filegrowth= 1Mb),
(name = N'KRI_UNIVER12_ndf',filename = N'D:\BD\4\KRI_UNIVER12.ndf',
size = 2Mb,maxsize = 5Mb,filegrowth= 1Mb),
filegroup G2
(name = N'KRI_UNIVER21_ndf',filename = N'D:\BD\4\KRI_UNIVER21.ndf',
size = 5Mb,maxsize = 10Mb,filegrowth= 1Mb),
(name = N'KRI_UNIVER22_ndf',filename = N'D:\BD\4\KRI_UNIVER22.ndf',
size = 2Mb,maxsize = 5Mb,filegrowth= 1Mb)
log on
(name = N'KRI_UNIVER_log',filename = N'D:\BD\4\KRI_UNIVER.ldf',
size = 5Mb,maxsize = unlimited,filegrowth= 1Mb)

use KRI_UNIVER
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
) on G1;

create table TEACHER(
Teacher char(10) constraint PK_Teacher  primary key,
TeacherName varchar(100), 
Gender char(1) CHECK (GENDER in ('м', 'ж')),
Pulpit char(20) not null constraint FK_Pulpit_Teacher foreign key references PULPIT(Pulpit) 
) on G1;

create table SUBJECTS(
Subject_ char(10) constraint PK_Sublect primary key, 
SubjekcName varchar(100) unique,
Pulpit char(20) constraint FK_Subject_Pulpit foreign key references PULPIT(Pulpit)   
) on G1;

create table GROUPS(
IdGroup integer identity(1,1) constraint PK_Group  primary key,              
Faculty char(10) constraint  FK_Groups_Faculty foreign key references FACULTY(Faculty), 
Profession char(20) constraint  FK_Group_Profession foreign key references PROFESSION(Profession),
YearFirst smallint check (YearFirst<=YEAR(GETDATE())),    
Course as YEAR(GETDATE())- YearFirst
) on G1;

create table AUDITORIUM(
Aud char(20) constraint PK_Aud primary key,
AudType char(10) not null constraint FK_AudType_Aud foreign key references AUDITORIUM_TYPE(AuditoriumType),
AudCapacity integer constraint AudCapacityCheck default 1 check (AudCapacity between 1 and 300),
AudName nvarchar(50),
) on G2;

create table STUDENT (
IdStudent integer identity(1000,1) constraint PK_Student primary key,
IdGroup integer  constraint FK_Student_group foreign key references GROUPS(IdGroup),        
Name_ nvarchar(100), 
BDay date,
Stamp timestamp,
Info xml default null,
Foto varbinary(max) default null
) on G2;

insert into AUDITORIUM_TYPE(AuditoriumType,  AuditoriumTypename ) values 
('ЛК','Лекционная'),('ЛБ-К','Компьютерный класс'),('ЛБ-СК','Спец. компьютерный класс'),('ЛБ-X','Химическая лаборатория');
insert into FACULTY (Faculty, FacultyName )values
('ХТиТ','Химическая технология и техника'),('ЛХФ','Лесохозяйственный факультет'),
('ИТ', 'Факультет информационных технологий'); 
insert into PULPIT (Pulpit, PulpitName, Faculty ) values  
('ИСиТ', 'Информационных систем и технологий ','ИТ'),
('ЛПиСПС','Ландшафтного проектирования и садово-паркового строительства','ЛХФ');
insert into SUBJECTS (Subject_,   SubjekcName, Pulpit ) values 
('СУБД','Системы управления базами данных', 'ИСиТ'), ('БД','Базы данных','ИСиТ'),('ОАиП', 'Основы алгоритмизации и программирования', 'ИСиТ');
insert into  AUDITORIUM   (Aud, AudName, AudType, AudCapacity) values
('206-1', '206-1','ЛБ-К', 15),('301-1','301-1','ЛБ-К', 15),('313-1','313-1', 'ЛБ-СК',60),('314-1','314-1', 'ЛБ-СК',60),('236-1','236-1', 'ЛК',60);
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

drop table AUDITORIUM_TYPE;
drop table SUBJECTS;
drop table AUDITORIUM;
drop table TEACHER;
drop table STUDENT;
drop table GROUPS;
drop table PROFESSION;
drop table PULPIT;
drop table FACULTY;

drop database KRI_UNIVER;








