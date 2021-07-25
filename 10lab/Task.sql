use KRI_UNIVER;
exec sp_helpindex 'TIMETABLE';
exec sp_helpindex 'AUDITORIUM';
exec sp_helpindex 'AUDITORIUM_TYPE';
exec sp_helpindex 'FACULTY';
exec sp_helpindex 'GROUPS';
exec sp_helpindex 'PULPIT';
exec sp_helpindex 'PROFESSION';
exec sp_helpindex 'PROGRESS';
exec sp_helpindex 'STUDENT';
exec sp_helpindex 'SUBJECTS';
exec sp_helpindex 'TEACHER';

select * from sys.indexes;
use tempdb;
--1
--������� ��������� ��������� �������. ��������� �� ������� (�� ����� 1000 �����). 
create table #explre
(
 tind int,
 tfield varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 1000
 begin
  insert #explre(tind,tfield)
   values(floor(20000*RAND()),REPLICATE('������',10));
   if(@i%100 = 0)
     print @i;
   set @i = @i +1;
  end;
go
select count(*)[Count] from #explre;

--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
select * from #explre where tind between 1500 and 2500 order by tind;

--������� ���������������� ������, ����������� ��������� SELECT-�������.
checkpoint;
DBCC dropcleanbuffers;

create clustered index #explre_cl on #explre(tind asc);
select * from #explre where tind between 1500 and 2500 order by tind;

--2
--������� ��������� ��������� �������. ��������� �� ������� (10000 ����� ��� ������). 
--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
create table #ex
(
 tkey int,
 cc int identity(1,1),
 tf varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 2000
 begin
  insert #ex(tkey,tf)
   values(floor(30000*RAND()),REPLICATE('������',10));
   set @i = @i +1;
  end;
go
select count(*)[Count] from #ex;
select * from #ex;

--������� ������������������ ������������ ��������� ������.
create index #ex_nonclu on #ex(tkey,cc);

--������� ��������� ������ ����������.
select * from #ex where tkey > 1500 and cc<4500;
select * from #ex order by tkey,cc;

select * from #ex where tkey = 566 and cc>3;

--3
--������� ������������������ ������ ��������, ����������� ��������� SELECT-�������. 
create index #ex_tkey_x on #ex(tkey) include(cc);
select cc from #ex where tkey>1500;

--4
--������� ������������������ ����������� ������, ��������-��� ��������� SELECT-�������.
select tkey from #ex where tkey between 5000 and 19999;
select tkey from #ex where tkey>15000 and tkey<20000;
select tkey from #ex where tkey = 17000;
create index #ex_where on #ex(tkey) where (tkey>15000 and tkey<20000);

--5
--������� ������������������ ��-����. ������� ������� ���������-��� �������. 
--����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%. ������� ������� ���������-��� �������. 
--��������� ��������� ��������-����� �������, ������� ������� ������������. 
--��������� ��������� ����-������� ������� � ������� ������� ������������ �������.
create index #ex_tkey on #ex(tkey)

--�������� ���������� � ������� ������������ �������
select name [������], avg_fragmentation_in_percent [������������ (%)]
from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#ex'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
where name is not null;

insert top(60000) #ex(tkey, tf) select tkey, tf from #ex;
--�������������
ALTER index #ex_tkey on #ex reorganize;
--�����������
ALTER index #ex_tkey_x on #ex rebuild with (online = off);

insert top(10000) #ex(tkey,tf) select tkey,tf from #ex;
alter index #ex_tkey on #ex reorganize;

alter index #ex_tkey on #ex rebuild with(online = off);
--6
--����������� ������, ��������������� ���������� ��������� FILL-FACTOR ��� �������� ������������������� �������.
--FILLFACTOR ��������� ������� ���������� ��������� ������� ������� ������
drop index #ex_tkey on #ex;
create index #ex_tkey on #ex(tkey) with (fillfactor = 65);

use tempdb;
select name [������], avg_fragmentation_in_percent [������������ (%)]
from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#ex'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
where name is not null;