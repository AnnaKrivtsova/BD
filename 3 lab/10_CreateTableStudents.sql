CREATE Table Students(
�����_������� int primary key not null,
��� nvarchar(50) not null,
����_�������� date not null,
��� nvarchar(10) not null,
����_����������� date not null
);
INSERT into Students values (1,'�������� �.�.', '2001-12-13','�','2019-07-15'),
(2,'��������� �.�.', '2001-10-12','�','2019-07-15'),
(3,'������ �.�.', '2001-02-03','�','2019-07-15'),
(4,'�������� �.�.', '2002-12-13','�','2019-07-15'),
(5,'�������� �.�.', '2000-10-07','�','2019-07-15');
SELECT * From Students;