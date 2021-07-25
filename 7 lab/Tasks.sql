use KRI_UNIVER;
--вычисляющий максимальную, минимальную и среднюю вместимость аудиторий, 
--суммарную вместимость всех аудиторий и общее количество аудиторий
select 
max(AudCapacity) [Max Capacity],
min(AudCapacity) [Min Capacity],
avg(AudCapacity) [Avg Capacity],
sum(AudCapacity) [Sum Capacity],
count (*) [Count of auditories]
from AUDITORIUM;

--вычисляющий для каждого типа аудиторий максимальную, минимальную, среднюю вместимость аудиторий,
--суммарную вместимость всех аудиторий и общее количество аудиторий данного типа. 
select AUDITORIUM.AudType,
max(AudCapacity) [Max Capacity],
min(AudCapacity) [Min Capacity],
avg(AudCapacity) [Avg Capacity],
sum(AudCapacity) [Sum Capacity],
count (*) [Count of auditories]
from AUDITORIUM 
group by AudType;

--количество экзаменационных оценок в заданном интервале
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

 --среднюю экзаменационную оценку для каждого курса каждой специальности
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

  --в расчете среднего значения оценок использовались оценки только по дисциплинам с кодами БД и ОАиП
  select f.Faculty,p.Profession,g.Course, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join PROFESSION p 
  on f.Faculty = p.Faculty
  inner join GROUPS g 
  on g.Profession = p.Profession
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where pg.Subject_ = 'БД' or pg.Subject_ = 'ОАиП'
  group by f.Faculty,p.Profession,g.Course;

  --выводятся специальность, дисциплины и средние оценки при сдаче экзаменов на факультете ХТиТ. 
  --rollup
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ХТиТ'
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

  --должны отражаться специальности, дисциплины, средние оценки студентов на факультете ХТиТ
  --запрос, в котором определяются результаты сдачи экзаменов на факультете ИТ
  --Объединить результаты двух запросов с использованием операторов UNION и UNION ALL
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ХТиТ'
  group by g.Profession,pg.Subject_
  union
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ИТ'
  group by g.Profession,pg.Subject_;

  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ХТиТ'
  group by g.Profession,pg.Subject_
  union all
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ИТ'
  group by g.Profession,pg.Subject_;

  --Получить пересечение двух множеств строк, созданных в результате выполнения 
    select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  --where f.Faculty = 'ХТиТ'
  group by g.Profession,pg.Subject_
  intersect
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ИТ'
  group by g.Profession,pg.Subject_;

  --Получить разницу между множеством строк, созданных в результате запросов 
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ХТиТ'
  group by g.Profession,pg.Subject_
  except
  select g.Profession,pg.Subject_, round(avg(cast(pg.Note as float(4))),2)[Avg Mark]
  from FACULTY f inner join GROUPS g 
  on f.Faculty = g.Faculty
  inner join STUDENT s
  on s.IdGroup = g.IdGroup
  inner join PROGRESS pg
  on pg.IdStudent = s.IdStudent
  where f.Faculty = 'ИТ'
  group by g.Profession,pg.Subject_;

  --определить для каждой дисциплины количество студентов, получивших оценки 8 и 9
  select p1.Subject_, p1.Note,
  (select count (*) from PROGRESS p2
  where p1.Note = p2.Note and p1.Subject_ = p2.Subject_)[Count]
  from PROGRESS p1
  group by p1.Subject_, p1.Note having Note between 8 and 9;

  --Подсчитать количество студентов в каждой группе, на каждом факультете и всего в университете одним запросом. 
  select cast(IdGroup as nvarchar) + ' группа'[Category],
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
  select 'В университете' ,count(*)[Count in university] 
  from STUDENT;
  
  --Подсчитать количество аудиторий по типам и суммарной вместимости в корпусах и всего одним запросом.
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
