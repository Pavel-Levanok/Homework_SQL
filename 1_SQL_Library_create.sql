create database Library;
go
use Library;
go

create table Authors
(
    Id           int           not null identity primary key,
    FirstName    nvarchar(50)  not null,
    LastName     nvarchar(50)  not null,
	Country      nvarchar(50)  not null,
	BirthDate    date          not null,    
);


create table Books
(
    Id           int           not null identity primary key,
    Name         nvarchar(100)  not null,
    AuthorId     int           not null references Authors (Id),
	Year         int           not null,    
);

create table Users
(
    Id           int           not null identity primary key,
    FirstName    nvarchar(50)  not null,
    LastName     nvarchar(50)  not null,
	Email        nvarchar(50)  not null unique,
	BirthDate    date          not null,
	Age          int           null,
	Address      nvarchar(100) not null,
	ExpiredDate  date          null,
);


create table UserBooks
(
    Id           int  not null identity primary key,
    UserId       int  not null references Users (Id) on delete cascade,
    BookId       int  not null references Books (Id) on delete cascade,
	CreatedDate  date null,
);






















