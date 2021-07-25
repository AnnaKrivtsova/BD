CREATE Table Results(
ID int primary key identity(1,1),
Student_Name nvarchar(20) not null,
Math int not null,
Philosophy int not null,
Computer_systems int not null,
Aver_value as (Math + Philosophy + Computer_systems)/3
);
INSERT into Results values ('Иванова',7,9,6),('Федоров',8,7,9),('Сидоров',6,5,4);
SELECT * From Results;