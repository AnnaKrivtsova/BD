use Krivtsova_MyBase;
--����������� ��������, ����������� ������ ��������� �� ������� ����. 
--� ����� ������ ���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� �������. 
--������������ ���������� ������� RTRIM.
declare NName cursor for select �������� from ���������� where �������� = '�������';
declare @nn char(40), @s char(300) = '';
open NName;
fetch NName into @nn;
print '����������';
while @@FETCH_STATUS = 0
  begin
    set @s = RTRIM(@nn) + ',' + @s;
	fetch NName into @nn;
  end;
print @s;
close NName;
deallocate NName;

--����������� ��������, ��������������� ������� ����������� ������� �� ���������� �� ������� ���� ������ X_UNIVER.
declare LocalCursor cursor local for
select ��������,�������� from ����������;
declare @nm char(50),@bd int;
open LocalCursor;
fetch LocalCursor into @nm,@bd;
print '1.' + @nm + ' ' + cast(@bd as varchar(6));
go 
declare @nm char(50),@bd datetime;
fetch LocalCursor into @nm,@bd;
print '2.' + @nm + ' ' + cast(@bd as varchar(6));
go 

declare GlobalCursor cursor global for
select ��������,�������� from ����������;
declare @nm char(50),@bd datetime;
open GlobalCursor;
fetch GlobalCursor into @nm,@bd;
print '1.' + @nm + ' ' + cast(@bd as varchar(6));
go 
declare @nm char(50),@bd datetime;
fetch GlobalCursor into @nm,@bd;
print '2.' + @nm + ' ' + cast(@bd as varchar(6));
close GlobalCursor;
deallocate GlobalCursor;

--����������� ��������, ������������-��� ������� ����������� �������� �� ������������ �� ������� ���� ������ X_UNIVER.
declare LocalStaticCursor cursor static local for
select [�������� ����������],[�������� ����������] from ������_�����������;
declare @au char(10),@aut char(10);
open LocalStaticCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete ������_����������� where [�������� �����������] = '�������';
fetch LocalStaticCursor into @au,@aut;
while @@FETCH_STATUS = 0
 begin
  print cast(@au as varchar(6)) + ' ' + @aut;
  fetch LocalStaticCursor into @au,@aut;
 end;
close LocalStaticCursor;

declare LocalDynamicCursor cursor dynamic local for
select [�������� ����������],[�������� ����������] from ������_�����������;
declare @aud char(10),@autd char(10);
open LocalDynamicCursor;
print 'Count auditory:' + cast(@@CURSOR_ROWS as varchar(6));
delete ������_����������� where [�������� �����������] = '�������';
fetch LocalDynamicCursor into @aud,@autd;
while @@FETCH_STATUS = 0
 begin
  print cast(@aud as varchar(6)) + ' ' + @autd;
  fetch LocalDynamicCursor into @aud,@autd;
 end;
close LocalDynamicCursor;

--����������� ��������, ������������-��� �������� ��������� � ����������-���� ������ ������� � ��������� SCROLL �� ������� ���� ������ X_UNIVER.
--������������ ��� ��������� �������� ����� � ��������� FETCH.

declare @sbj char(10), @sbjn char(20);
declare ScrollCursor cursor local dynamic scroll for
select ROW_NUMBER() over (order by [�������� ����������]) N,[�������� ����������] from ������_�����������;
open ScrollCursor;
fetch ScrollCursor into @sbj, @sbjn;
print 'Next string: ' + @sbj + ' ' + @sbjn;
fetch last from ScrollCursor into @sbj,@sbjn;
print 'Last string: ' + @sbj + ' ' + @sbjn;
fetch first from ScrollCursor into @sbj,@sbjn;
print 'First string: ' + @sbj + ' ' + @sbjn;
fetch next from ScrollCursor into @sbj,@sbjn;
print 'Next string: ' + @sbj + ' ' + @sbjn;
fetch prior from ScrollCursor into @sbj,@sbjn;
print 'Prior string: ' + @sbj + ' ' + @sbjn;
fetch absolute 3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute 3 string: ' + @sbj + ' ' + @sbjn;
fetch absolute -3 from ScrollCursor into @sbj,@sbjn;
print 'Absolute -3 string: ' + @sbj + ' ' + @sbjn;
fetch relative 3 from ScrollCursor into @sbj,@sbjn;
print 'Relative 3 string: ' + @sbj + ' ' + @sbjn;
fetch relative -3 from ScrollCursor into @sbj,@sbjn;
print 'Relative -3 string: ' + @sbj + ' ' + @sbjn;
close ScrollCursor;

--������� ������, ��������������� ���������� ����������� CURRENT OF � ������ WHERE � �������������� ���������� UPDATE � DELETE.
declare UpdateCursor cursor dynamic local for
select ��������,�������� from ����������;
declare @auu char(10),@autu char(10);
open UpdateCursor;
fetch UpdateCursor into @auu,@autu;
update ���������� set �������� = '10' where current of UpdateCursor;
close UpdateCursor;

--����������� SELECT-������, � ������� �������� �� ������� PROGRESS ��������� ������, ���������� ���������� � ���������, 
--���������� ������ ���� 4 (������������ ������-����� ������ PROGRESS, STUDENT, GROUPS). 
declare DeleteStudentCursor cursor dynamic local for
select ����������.��������,[�������� ����������]
from ������_����������� inner join ����������
on ������_�����������.[�������� ����������] = ����������.�������� 
declare @idd char(20),@ntd char(20);
open DeleteStudentCursor;
fetch DeleteStudentCursor into @idd,@ntd;
while @@FETCH_STATUS = 0
 begin
  delete ���������� where �������� > 10;
  print @idd + ' ' + @ntd;
  fetch DeleteStudentCursor into @idd,@ntd;
 end;
close DeleteStudentCursor;


--����������� SELECT-������, � ��-����� �������� � ������� PROGRESS ��� �������� � ���������� ������� IDSTUDENT �������������� ������ (������������� �� �������).
declare CorrectMarkCursor cursor dynamic local for
select ��������,�������� from ����������;
declare @ids char(15),@nt char(15);
open CorrectMarkCursor;
fetch CorrectMarkCursor into @ids,@nt;
while @@FETCH_STATUS = 0
 begin
  update ���������� set �������� = �������� + 1 where �������� = '�������';
  print @ids + ' ' + @nt;
  fetch CorrectMarkCursor into @ids,@nt;
 end;
close CorrectMarkCursor;

