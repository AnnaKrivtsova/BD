SELECT * From STUDENT Where Номер_зачетки Between 1 And 4;
SELECT * From STUDENT Where Фамилия_студента Like 'К%';
SELECT * FROM STUDENT Where Номер_зачетки IN(1,3);
DROP Table STUDENT;