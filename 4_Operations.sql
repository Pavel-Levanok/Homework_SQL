use Library;
go

create or alter view UsersInfo as
select
Users.Id as UserId,
concat (Users.FirstName, ' ',Users.LastName) as UserFullName,
Users.Age as UserAge,
concat (Authors.FirstName, ' ',Authors.LastName) as AuthorFullName,
Books.Name as BookName,
Books.Year as BookYear
from UserBooks
		right join Users on Users.Id = UserBooks.UserId
		left join Books on Books.Id = UserBooks.BookId
		left join Authors on Authors.Id = Books.AuthorId;
go

create or alter procedure DeleteUsersByExpiredDate as
begin
	delete from Users where Id = (select Id from UsersInfo where ExpiredDate < GETDATE() and BookName is null);
end;
go


create or alter view UsersWithBook as     
select
Users.Id as UserId,
concat (Users.FirstName, ' ',Users.LastName) as UserFullName,
Books.Name as BookName
from UserBooks
		right join Users on Users.Id = UserBooks.UserId
		left join Books on Books.Id = UserBooks.BookId;
go

use Library;
go

create or alter procedure GiveBookToUser 
@EmailUser nvarchar(50),
@FirstNameAuthors nvarchar(50),
@LastNameAuthors  nvarchar(50),
@BookName nvarchar(50) 
as
begin
		declare @UserId int;
		declare @AuthorId int;
		declare @BookId int;

		set @UserId = (select Id from Users where Email = @EmailUser);
		set @AuthorId = (select Id from Authors where FirstName = @FirstNameAuthors and LastName = @LastNameAuthors);
		set @BookId = (select Id from Books where Name = @BookName and AuthorId = @AuthorId);
    
		if (@BookId is null) or (@AuthorId is null) 
		begin
			print N'Такой книги нет'
			return;
		end;

		if((select BookName from UsersInfo where (select CONCAT(FirstName,' ',LastName) from Users 
		where Email = @EmailUser) = UserFullName and BookName = @BookName) = @BookName) begin 
		print N'Книга уже у пользователя';
		return;
	    end;

		if(exists(select BookName from UsersInfo where BookName = @BookName)) begin
        print('Книга у другого пользователя')
		return;
	    end;

	insert into UserBooks(UserId, BookId) values (@UserId, @BookId);
end;


alter table UserBooks
add ToCharge money null;
go

create or alter function GetCharge(@CreatedDate date, @MaxTerm int) 
returns money
begin
	declare @PriceDay money
	declare @ExtraDays int

	set @PriceDay =  2.7
	set @ExtraDays = DATEDIFF(day, @CreatedDate, GETDATE()) - @MaxTerm
	
	return iif(@ExtraDays > 0, @ExtraDays * @PriceDay, 0);
end;
go


create or alter procedure ChargeUser 
@EmailUser nvarchar(50),
@BookId int
as
begin
	declare @UserId int
	set @UserId = (select Id from Users where Email = @EmailUser)
	declare @CreatedDate date
	set @CreatedDate = (select CreatedDate from UserBooks where BookId = @BookId)
	update UserBooks
	set ToCharge = (select dbo.GetCharge(@CreatedDate,60)) where UserId = @UserId and BookId = @BookId
end;
go

create or alter procedure ReturnBook @EmailUser nvarchar(50),
									 @FirstNameAuthors nvarchar(50),
									 @LastNameAuthors nvarchar(50),
									 @BookName nvarchar(100)
as
begin
	declare @BookId int
	set @BookId = (select Id from Books where Name = @BookName)
	execute ChargeUser @EmailUser, @BookId
	declare @PenaltySum money
	set @PenaltySum = (select ToCharge from UserBooks where BookId = @BookId)
	print concat('Пеня юзера ',@EmailUser,':', @PenaltySum)
	delete from UserBooks where BookId = @BookId
end;

-- ------------------------------------------------------------------------------

SELECT TOP (100) [UserId]
      ,[UserFullName]
      ,[BookName]
  FROM [Library].[dbo].[UsersWithBook]
go

  select * from Users
go
select * from Authors
go


exec GiveBookToUser 'Ivanov@gmail.com', N'Уэйн', N'Седжвик', N'Алгоритмы на Java'
go
exec GiveBookToUser 'Ivanov@gmail.com', N'Джон', N'Сомнез', N'Путь программиста'
go
exec ReturnBook 'Ivanov@gmail.com', N'Уэйн', N'Седжвик', N'Алгоритмы на Java'
go
exec DeleteUsersByExpiredDate






	