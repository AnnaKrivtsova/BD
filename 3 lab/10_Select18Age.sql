SELECT * From Students 
Where Пол Like 'ж' And (YEAR(Дата_поступления)-YEAR(Дата_рождения)) >= 18 And FORMAT(Дата_поступления, '%m%d') < FORMAT(Дата_рождения, '%m%d');