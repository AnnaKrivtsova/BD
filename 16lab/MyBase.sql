use Krivtsova_MyBase;
--Task 1
select �������� '��������', �������� '��������'
			from ���������� 
			for xml path('����������'),
			root('������_�����������'), elements;

select [��������], [��������]
			from ����������
			for xml raw;

--Task 2
select [������_�����������].[�������� ����������] [��������_����������], [����������].�������� [��������], [����������].�������� [��������]  
from ���������� [����������] inner join ������_����������� [������_�����������] 
on [������_�����������].[�������� ����������] = [����������].�������� 
for xml auto, root ('������_������');

--Task 3
declare @h int = 0,
@x nvarchar(2000) = N'<ROOT>
  <���������� ��������="����������1">
    <��������>����������1</��������>
    <��������>1</��������>
  </����������>
  <����������>
    <��������>����������1</��������>
    <��������>2</��������>
  </����������>
  <����������>
    <��������>����������1</��������>
    <��������>3</��������>
  </����������>
</ROOT>'
exec sp_xml_preparedocument @h output, @x;
select * from openxml(@h, '/ROOT/����������', 2)
with (�������� nvarchar(MAX), �������� int);
insert ���������� select ��������, ��������
from openxml(@h, '/ROOT/����������', 2)
with (�������� nvarchar(MAX), �������� int)
select * from ����������
EXEC sp_xml_removedocument @h

select * from ����������;