go
use Library;
go

create trigger UserBooksGetDate
on UserBooks
after insert
as update UserBooks
set CreatedDate = getdate();
go

create trigger UsersExpiredDate
on Users
after insert
as update Users
set ExpiredDate = DATEADD(year, 1, getdate());
go

create trigger UsersAge
on Users
after insert, update
as update Users
set Age = DATEDIFF(year, BirthDate, getdate());
go

create unique nonclustered index IX_UserId_BookId_Unique
on UserBooks(UserId asc, BookId asc);
go

create unique nonclustered index IX_Name_AuthorId_Unique
on Books(Name asc, AuthorId asc);
go

create unique nonclustered index IX_FirstName_LastName_Country_Unique
on Authors(FirstName asc, LastName asc, Country asc);
go
