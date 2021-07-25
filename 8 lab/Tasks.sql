use KRI_UNIVER;

--����������� ������������� � ������ �������������. 
create view ������������� 
as select Teacher,TeacherName, Gender,Pulpit from TEACHER;
go
select * from �������������;

drop view �������������;

--����������� � ������� ������������� � ������  ���������� ������
create view [���������� ������] as 
select FACULTY.FacultyName, count (*) [���������� ������ ]
from FACULTY inner join PULPIT on FACULTY.Faculty = PULPIT.Faculty
group by FACULTY.FacultyName;
go
select * from [���������� ������];

drop view [���������� ������];

--��������� ������������� ���������� ���-������� INSERT, UPDATE � DELETE ��� ������������� ���������� ������. 
--������ ��� ���� �������� group by � ����������� ��������, ������ ���� ���� �������

--����������� � ������� ������������� � ������ ���������
create view ���������(���, �����������_���������, ���_���������)
	as select Aud,AudName,AudType from AUDITORIUM
	where AudType like '��%';
go
select * from [���������];

drop view [���������];

--� ��������� ���������� ��������� INSERT, UPDATE � DELETE.
insert ��������� values('430-1','430-1','��')
insert ��������� values('500-1','500-1','��-�')
insert ��������� values('435-1','435-1','��')
select * from ���������

--����������� � ������� ������������� � ������ ����������_���������. 
create view ����������_��������� as 
select Aud,AudName,AudType
from AUDITORIUM 
where AudType like '��%'
with check option;
go
select * from ����������_���������;

insert ����������_��������� values('434-1','430-1','��');

drop view ����������_���������;

--����������� � ������� ������������� � ������ ����������
create view ���������� as 
select top 3 Subject_,SubjectName,Pulpit
from SUBJECTS
order by SubjectName;
go
select * from ����������;

drop view ����������;

--�������� ������������� ����������_������, ��������� � ������� 2 ���, ����� ��� ���� ��������� � ������� ��������. 
alter view [���������� ������] with schemabinding 
as select FACULTY.FacultyName, count (*) [���������� ������]
from dbo.FACULTY inner join dbo.PULPIT 
on FACULTY.Faculty = PULPIT.Faculty
group by FACULTY.FacultyName;
go
select * from [���������� ������];

alter table FACULTY drop column FacultyName;

drop view [���������� ������];

--����������� ������������� ��� ������� TIMETABLE � ���� ����������. ������� �������� PIVOT � ������������ ���.
create view ���������� as 
select *
from (select Day_of_week[���� ������],
     Auditoria[���������],
	 Subject_ [�������] from TIMETABLE) t
	 pivot (count(�������) for [���� ������] in ([��],[��],[��])) as pvt
go
select * from ����������;

drop view ����������;