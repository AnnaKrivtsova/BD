CREATE Table Students(
Номер_зачетки int primary key not null,
ФИО nvarchar(50) not null,
Дата_рождения date not null,
Пол nvarchar(10) not null,
Дата_поступления date not null
);
INSERT into Students values (1,'Кривцова А.П.', '2001-12-13','ж','2019-07-15'),
(2,'Соловьева Л.Е.', '2001-10-12','м','2019-07-15'),
(3,'Иванов Г.Д.', '2001-02-03','м','2019-07-15'),
(4,'Федорова У.Л.', '2002-12-13','ж','2019-07-15'),
(5,'Сидорова Н.П.', '2000-10-07','ж','2019-07-15');
SELECT * From Students;