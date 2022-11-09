use Library;
go

insert into Authors
values 
(N'Джон', N'Сомнез', N'США', '1952-01-01'),
(N'Уэйн', N'Седжвик', N'США', '1962-01-02'),
(N'Кори', N'Альтхофф', N'Великобритания', '1972-03-01'),
(N'Эрик', N'Эванс', N'Канада', '1980-01-08')
go

insert into Books
values 
(N'Путь программиста', (select Id from Authors where FirstName = N'Джон' and LastName = N'Сомнез'), 2010),
(N'Алгоритмы на Java', (select Id from Authors where FirstName = N'Уэйн' and LastName = N'Седжвик'), 2011),
(N'Сам себе программист', (select Id from Authors where FirstName = N'Кори' and LastName = N'Альтхофф'), 2012),
(N'Предметно-ориентированное проектирование', (select Id from Authors where FirstName = N'Эрик' and LastName = N'Эванс'), 1999)
go

insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
(N'Павел', N'Леванок', 'pavel.levanok@gmail.com', '1985-09-16', N'Минск, ул.Руссиянова'),
(N'Дмитрий', N'Петров', 'petrov@gmail.com', '1990-07-10', N'Минск, ул.Шугаева'),
(N'Александр', N'Иванов', 'Ivanov@gmail.com', '1991-11-11', N'Минск, ул.Гинтовта'),
(N'Юлия', N'Незабудкина', 'nezabud@gmail.com', '1993-10-01', N'Минск, ул.Широкая')
go


insert into UserBooks (UserId, BookId)
values
((select Id from Users where LastName = N'Леванок'),(select Id from Books where Name = N'Предметно-ориентированное проектирование')),
((select Id from Users where LastName = N'Петров'),(select Id from Books where Name = N'Сам себе программист')),
((select Id from Users where LastName = N'Иванов'),(select Id from Books where Name = N'Алгоритмы на Java')),
((select Id from Users where LastName = N'Незабудкина'),(select Id from Books where Name = N'Путь программиста'))



