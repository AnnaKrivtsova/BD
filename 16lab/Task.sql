use KRI_UNIVER;

--Task 1
select TEACHER '���', Teacher '���', Gender '���', Pulpit '�������'
			from TEACHER where Pulpit = '����' 
			for xml path('�������������'),
			root('������_��������������');

--Task 2
select [���].AuditoriumType [���], [���������].Aud [���], [���������].AudCapacity [�����������]  
from AUDITORIUM [���������] inner join AUDITORIUM_TYPE [���] 
on [���].AuditoriumType = [���������].AudType 
and [���].AuditoriumType in ('��','��-�')
for xml auto, root ('������_���������');

--Task 3
declare @h int = 0,
@x nvarchar(2000) = N'<ROOT>
  <SUBJECTS Subject_="����">
    <Subject_>����</Subject_>
    <SubjectName>������������ ������� � ����</SubjectName>
    <Pulpit>����</Pulpit>
  </SUBJECTS>
  <SUBJECTS>
    <Subject_>����2</Subject_>
    <SubjectName>������������ ������� � ����2</SubjectName>
    <Pulpit>����</Pulpit>
  </SUBJECTS>
  <SUBJECTS>
    <Subject_>����3</Subject_>
    <SubjectName>������������ ������� � ����3</SubjectName>
    <Pulpit>����</Pulpit>
  </SUBJECTS>
</ROOT>'
exec sp_xml_preparedocument @h output, @x;
select * from openxml(@h, '/ROOT/SUBJECTS', 2)
with (Subject_ char(10), SubjectName varchar(100), Pulpit char(20));
insert SUBJECTS select Subject_, SubjectName, Pulpit
from openxml(@h, '/ROOT/SUBJECTS', 2)
with (Subject_ char(10), SubjectName varchar(100), Pulpit char(20))
select * from SUBJECTS
EXEC sp_xml_removedocument @h

delete SUBJECTS where Subject_ like '����%';

--Task 4
create table Student_xml
(
StudentName nvarchar(100),
Passport xml
);
go
insert into Student_xml(StudentName, Passport)
values('�������� ���� ��������', '<Passport><Seria>MC</Seria><Number>2910948</Number>
<Dv>24.04.15</Dv><Adress>Minsk, Nadezhdinskaya 21</Adress></Passport>');
go
insert into Student_xml(StudentName, Passport)
values('������ ����� �������������', '<Passport><Seria>��</Seria><Number>2388713</Number>
<Dv>12.12.16</Dv><Adress>Minsk, Vanaeva 32</Adress></Passport>');

update Student_xml set Passport = '<Passport><Seria>��</Seria><Number>3412842</Number>
<Dv>12.12.16</Dv><Adress>Minsk, Belorusskaya 2</Adress></Passport>' 
where Passport.value('(/Passport/Number)[1]', 'varchar(10)')=2388713;

select StudentName [���], 
Passport.value('(/Passport/Seria)[1]', 'varchar(2)') [�����],
Passport.value('(/Passport/Number)[1]', 'varchar(7)') [�����],
Passport.query('/Passport/Adress') [�����]
from Student_xml;

select * from Student_xml

drop table Student_xml

--Task 5
create xml schema collection STUDENT as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
elementFormDefault="qualified"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������"> 
<xs:complexType><xs:sequence>
  <xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required" >  
      <xs:simpleType>  
	    <xs:restriction base ="xs:string">
            <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
        </xs:restriction> 	
	  </xs:simpleType>
    </xs:attribute> 
  </xs:complexType> 
  </xs:element>
  <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
  <xs:element name="�����"> 
    <xs:complexType><xs:sequence>
       <xs:element name="������" type="xs:string" />
       <xs:element name="�����" type="xs:string" />
       <xs:element name="�����" type="xs:string" />
       <xs:element name="���" type="xs:string" />
       <xs:element name="��������" type="xs:string" />
    </xs:sequence></xs:complexType> 
  </xs:element>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:schema>';

create table STUDENTS
( 
IdStudent int identity(1000,1) primary key,
IdGroup int, 
StudentName nvarchar(100), 
BDay date,
Stamp timestamp,
Info xml(STUDENT), 
Foto varbinary
);

insert into STUDENTS(IdGroup, StudentName, BDay, INFO)
values ('8', '���� ��������', '2001-12-12', 
'<�������><������� �����="MC" �����="2910948" ����="17.03.2017"/>
<�������>9294198</�������><�����><������>��������</������><�����>�����</�����>
<�����>������������</�����><���>7</���>
<��������>7</��������></�����></�������>')

insert into STUDENTS(IdGroup, StudentName, BDay, INFO)
values ('8', '���� ��������', '2001-12-12', 
'<�������><������� �����="MC" �����="2910948" ����="177.03.2017"/>
<�������>9294198</�������><�����><������>��������</������><�����>�����</�����>
<�����>������������</�����><���>7</���>
<��������>7</��������></�����></�������>')

select * from STUDENTS;

drop table STUDENTS;
drop xml schema collection STUDENT;

--Task 6
(select pc.Faculty '@���',
(select count(*) from PULPIT where Faculty = pc.Faculty)[���������_������],
  (select p.Pulpit '�������/@���' ,
     (select t.Teacher '�������������/@���', t.TeacherName '�������������'
	 from dbo.TEACHER t where p.Pulpit = t.Pulpit
	 for xml path(''), type) as "�������������"
  from dbo.PULPIT p where p.Faculty = pc.Faculty 
  for xml path(''), type) as "�������"
from dbo.FACULTY pc)
for xml path('���������'), root ('�����������'), type

select * from PULPIT;
