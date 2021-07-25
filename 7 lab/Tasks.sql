use KRI_UNIVER;
--����������� ������������, ����������� � ������� ����������� ���������, 
--��������� ����������� ���� ��������� � ����� ���������� ���������
select 
max(AudCapacity) [Max Capacity],
min(AudCapacity) [Min Capacity],
avg(AudCapacity) [Avg Capacity],
sum(AudCapacity) [Sum Capacity],
count (*) [Count of auditories]
from AUDITORIUM;

--����������� ��� ������� ���� ��������� ������������, �����������, ������� ����������� ���������,
--��������� ����������� ���� ��������� � ����� ���������� ��������� ������� ����. 
select AUDITORIUM.AudType,
max(AudCapacity) [Max Capacity],
min(AudCapacity) [Min Capacity],
avg(AudCapacity) [Avg Capacity],
sum(AudCapacity) [Sum Capacity],
count (*) [Count of auditories]
from AUDITORIUM 
group by AudType;

--���������� ��������������� ������ � �������� ���������
select * 
  from ( select 
    case 
	when Note = 10 then '10' 
	when Note between 8 and 9 then '8-9' 
	when Note between 6 and 7 then '6-7' 
	when Note between 4 and 5 then '4-5' 
	end Marks, count (*) [Count]
	from PROGRESS group by 
	case
	when Note = 10 then '10' 
	when Note between 8 and 9 then '8-9' 
	when Note between 6 and 7 then '6-7' 
	when Note between 4 and 5 then '4-5' 
	end) 
  PROGRESS order by 
  case Marks 
  when '10' then 1
  when '8-9' then 2
  when '6-7' then 3
  when '4-5' then 4
  else 0
  end;

 --������� ��������������� ������ ��� ������� ����� ������ �������������
 select f.Faculty,p.Profession,g.Course, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join PROFESSION p 
  on f.Faculty = p.Faculty
  inner join GROUPS g 
  on g.Profession = p.Profession
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  group by f.Faculty,p.Profession,g.Course;

  --� ������� �������� �������� ������ �������������� ������ ������ �� ����������� � ������ �� � ����
  select f.Faculty,p.Profession,g.Course, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join PROFESSION p 
  on f.Faculty = p.Faculty
  inner join GROUPS g 
  on g.Profession = p.Profession
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where pg.Subject_ = '��' or pg.Subject_ = '����'
  group by f.Faculty,p.Profession,g.Course;

  --��������� �������������, ���������� � ������� ������ ��� ����� ��������� �� ���������� ����. 
  --rollup
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '����'
  group by rollup (g.Profession,pg.Subject_);

  --cube
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  group by cube(g.Profession,pg.Subject_);

  --������ ���������� �������������, ����������, ������� ������ ��������� �� ���������� ����
  --������, � ������� ������������ ���������� ����� ��������� �� ���������� ��
  --���������� ���������� ���� �������� � �������������� ���������� UNION � UNION ALL
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '����'
  group by g.Profession,pg.Subject_
  union
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '��'
  group by g.Profession,pg.Subject_;

  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '����'
  group by g.Profession,pg.Subject_
  union all
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '��'
  group by g.Profession,pg.Subject_;

  --�������� ����������� ���� �������� �����, ��������� � ���������� ���������� 
    select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  --where f.Faculty = '����'
  group by g.Profession,pg.Subject_
  intersect
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '��'
  group by g.Profession,pg.Subject_;

  --�������� ������� ����� ���������� �����, ��������� � ���������� �������� 
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '����'
  group by g.Profession,pg.Subject_
  except
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = '��'
  group by g.Profession,pg.Subject_;

  --���������� ��� ������ ���������� ���������� ���������, ���������� ������ 8 � 9
  select p1.Subject_, p1.Note,
  (select count (*) from PROGRESS p2
  where p1.Note = p2.Note and p1.Subject_ = p2.Subject_)[Count]
  from PROGRESS p1
  group by p1.Subject_, p1.Note having Note between 8 and 9;

  --���������� ���������� ��������� � ������ ������, �� ������ ���������� � ����� � ������������ ����� ��������. 
  select cast(IdGroup as nvarchar) + ' ������'[Category],
  (select count (*) from STUDENT s2
  where s1.IdGroup = s2.IdGroup)[Count in group]
  from STUDENT s1
  group by IdGroup
  union all
  select g1.Faculty,
  (select count (*) from STUDENT s2 inner join GROUPS g2 on g2.IdGroup = s2.IdGroup
  where g1.Faculty = g2.Faculty)[Count in faculty]
  from GROUPS g1 
  group by g1.Faculty
  union all
  select '� ������������' ,count(*)[Count in university] 
  from STUDENT;
  
  --���������� ���������� ��������� �� ����� � ��������� ����������� � �������� � ����� ����� ��������.
  select AudType[Category],
  (select count (*) from AUDITORIUM a2
  where a1.AudType = a2.AudType)[Count]
  from AUDITORIUM a1
  group by AudType
  union all
  select *
  from 
  ( select 
    case 
	when AudName like '%1' then '1' 
	when AudName like '%2' then '2' 
	when AudName like '%3' then '3' 
	when AudName like '%4' then '4' 
	end Housing, sum (AudCapacity) [Capacity]
	from AUDITORIUM group by 
	case
	when AudName like '%1' then '1' 
	when AudName like '%2' then '2' 
	when AudName like '%3' then '3' 
	when AudName like '%4' then '4' 
	end) AUDITORIUM
	union all
	select 'Sum',sum (AudCapacity) from AUDITORIUM [Sum of capacity in all]
