use Krivtcova_UNIVER;

--Task1
create table Table1(
t1 int,
t2 int
);
insert Table1 values(1,1),(2,2),(3,3);
go
select * from Table1;

create table Table2(
t21 int,
t22 int,
t23 int
);
declare @x int,@y int,@z int;
select @x = COUNT(*) from Table1;
select @y = sum(t1) from Table1;
select @z = avg(t2) from Table1;
insert Table2 values(@x,@y,@z);
go
select * from Table2

--Task2
use KRI_UNIVER;
select distinct Subject_ from PROGRESS where Note >= 6;

--Task3
select IdStudent from PROGRESS where exists (select IdStudent from PROGRESS where IdStudent = 1100);

--Task4
select IdStudent, avg(Note) from PROGRESS 
group by IdStudent;

--Task5
create view Task5
as (select * from PROGRESS intersect select * from PROGRESS where Note >=6)
go
select * from Task5;

declare @check int, @check3 int;
set @check = (select count(*) from PROGRESS)
set @check3 =  (select count(*) from Task5)
if @check = @check3
print 'equal';
else
print 'not equal';

--Task6
create view Task6 with schemabinding 
as select FACULTY.FacultyName
from dbo.FACULTY
group by FACULTY.FacultyName;
go
select * from Task6;
drop view Task6;

alter table FACULTY drop column FacultyName;