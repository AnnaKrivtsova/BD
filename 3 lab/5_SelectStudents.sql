SELECt * From STUDENT;
SELECT Фамилия_студента, Номер_группы From STUDENT;
SELECT count(*) From STUDENT;
SELECT Фамилия_студента [Фамилия из группы] From STUDENT Where Номер_группы < 7;
SELECT Distinct Top(3) * From STUDENT Order by Номер_группы Asc;