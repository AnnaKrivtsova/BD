use KRI_UNIVER;

--Task 1
select TEACHER 'Код', Teacher 'Имя', Gender 'Пол', Pulpit 'Кафедра'
			from TEACHER where Pulpit = 'ИСиТ' 
			for xml path('Преподаватель'),
			root('Список_преподавателей');

--Task 2
select [Тип].AuditoriumType [Тип], [Аудитория].Aud [Имя], [Аудитория].AudCapacity [Вместимость]  
from AUDITORIUM [Аудитория] inner join AUDITORIUM_TYPE [Тип] 
on [Тип].AuditoriumType = [Аудитория].AudType 
and [Тип].AuditoriumType in ('ЛК','ЛБ-К')
for xml auto, root ('Список_аудиторий');

--Task 3
declare @h int = 0,
@x nvarchar(2000) = N'<ROOT>
  <SUBJECTS Subject_="КСИС">
    <Subject_>КСИС</Subject_>
    <SubjectName>Компьютерные системы и сети</SubjectName>
    <Pulpit>ИСиТ</Pulpit>
  </SUBJECTS>
  <SUBJECTS>
    <Subject_>КСИС2</Subject_>
    <SubjectName>Компьютерные системы и сети2</SubjectName>
    <Pulpit>ИСиТ</Pulpit>
  </SUBJECTS>
  <SUBJECTS>
    <Subject_>КСИС3</Subject_>
    <SubjectName>Компьютерные системы и сети3</SubjectName>
    <Pulpit>ИСиТ</Pulpit>
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

delete SUBJECTS where Subject_ like 'КСИС%';

--Task 4
create table Student_xml
(
StudentName nvarchar(100),
Passport xml
);
go
insert into Student_xml(StudentName, Passport)
values('Кривцова Анна Павловна', '<Passport><Seria>MC</Seria><Number>2910948</Number>
<Dv>24.04.15</Dv><Adress>Minsk, Nadezhdinskaya 21</Adress></Passport>');
go
insert into Student_xml(StudentName, Passport)
values('Зизико Дарья Александровна', '<Passport><Seria>МР</Seria><Number>2388713</Number>
<Dv>12.12.16</Dv><Adress>Minsk, Vanaeva 32</Adress></Passport>');

update Student_xml set Passport = '<Passport><Seria>МР</Seria><Number>3412842</Number>
<Dv>12.12.16</Dv><Adress>Minsk, Belorusskaya 2</Adress></Passport>' 
where Passport.value('(/Passport/Number)[1]', 'varchar(10)')=2388713;

select StudentName [Имя], 
Passport.value('(/Passport/Seria)[1]', 'varchar(2)') [Серия],
Passport.value('(/Passport/Number)[1]', 'varchar(7)') [Номер],
Passport.query('/Passport/Adress') [Адрес]
from Student_xml;

select * from Student_xml

drop table Student_xml

--Task 5
create xml schema collection STUDENT as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
elementFormDefault="qualified"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент"> 
<xs:complexType><xs:sequence>
  <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required" >  
      <xs:simpleType>  
	    <xs:restriction base ="xs:string">
            <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
        </xs:restriction> 	
	  </xs:simpleType>
    </xs:attribute> 
  </xs:complexType> 
  </xs:element>
  <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
  <xs:element name="адрес"> 
    <xs:complexType><xs:sequence>
       <xs:element name="страна" type="xs:string" />
       <xs:element name="город" type="xs:string" />
       <xs:element name="улица" type="xs:string" />
       <xs:element name="дом" type="xs:string" />
       <xs:element name="квартира" type="xs:string" />
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
values ('8', 'Анна Кривцова', '2001-12-12', 
'<студент><паспорт серия="MC" номер="2910948" дата="17.03.2017"/>
<телефон>9294198</телефон><адрес><страна>Беларусь</страна><город>Минск</город>
<улица>Надеждинская</улица><дом>7</дом>
<квартира>7</квартира></адрес></студент>')

insert into STUDENTS(IdGroup, StudentName, BDay, INFO)
values ('8', 'Анна Кривцова', '2001-12-12', 
'<студент><паспорт серия="MC" номер="2910948" дата="177.03.2017"/>
<телефон>9294198</телефон><адрес><страна>Беларусь</страна><город>Минск</город>
<улица>Надеждинская</улица><дом>7</дом>
<квартира>7</квартира></адрес></студент>')

select * from STUDENTS;

drop table STUDENTS;
drop xml schema collection STUDENT;

--Task 6
(select pc.Faculty '@Код',
(select count(*) from PULPIT where Faculty = pc.Faculty)[Количетво_кафедр],
  (select p.Pulpit 'Кафедра/@Код' ,
     (select t.Teacher 'Преподаватель/@Код', t.TeacherName 'Преподаватель'
	 from dbo.TEACHER t where p.Pulpit = t.Pulpit
	 for xml path(''), type) as "Преподаватели"
  from dbo.PULPIT p where p.Faculty = pc.Faculty 
  for xml path(''), type) as "Кафедры"
from dbo.FACULTY pc)
for xml path('Факультет'), root ('Университет'), type

select * from PULPIT;
