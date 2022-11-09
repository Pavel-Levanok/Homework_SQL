use Library;
go

insert into Authors
values 
(N'����', N'������', N'���', '1952-01-01'),
(N'����', N'�������', N'���', '1962-01-02'),
(N'����', N'��������', N'��������������', '1972-03-01'),
(N'����', N'�����', N'������', '1980-01-08')
go

insert into Books
values 
(N'���� ������������', (select Id from Authors where FirstName = N'����' and LastName = N'������'), 2010),
(N'��������� �� Java', (select Id from Authors where FirstName = N'����' and LastName = N'�������'), 2011),
(N'��� ���� �����������', (select Id from Authors where FirstName = N'����' and LastName = N'��������'), 2012),
(N'���������-��������������� ��������������', (select Id from Authors where FirstName = N'����' and LastName = N'�����'), 1999)
go

insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
(N'�����', N'�������', 'pavel.levanok@gmail.com', '1985-09-16', N'�����, ��.����������'),
(N'�������', N'������', 'petrov@gmail.com', '1990-07-10', N'�����, ��.�������'),
(N'���������', N'������', 'Ivanov@gmail.com', '1991-11-11', N'�����, ��.��������'),
(N'����', N'�����������', 'nezabud@gmail.com', '1993-10-01', N'�����, ��.�������')
go


insert into UserBooks (UserId, BookId)
values
((select Id from Users where LastName = N'�������'),(select Id from Books where Name = N'���������-��������������� ��������������')),
((select Id from Users where LastName = N'������'),(select Id from Books where Name = N'��� ���� �����������')),
((select Id from Users where LastName = N'������'),(select Id from Books where Name = N'��������� �� Java')),
((select Id from Users where LastName = N'�����������'),(select Id from Books where Name = N'���� ������������'))



