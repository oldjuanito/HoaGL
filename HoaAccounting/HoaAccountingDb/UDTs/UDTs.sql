CREATE TYPE [dbo].[GLDescription]
	FROM varchar(150) NOT NULL;
GO;
CREATE TYPE [dbo].[TransactionDate]
	FROM Date NOT NULL;
GO;
CREATE TYPE [dbo].CreditDebitFlag
	FROM smallint NOT NULL;
GO;
CREATE TYPE [dbo].[BillPayConfirmation]
	FROM varchar(20) NULL;
GO;
CREATE TYPE [dbo].[CheckNumber]
	FROM varchar(20) NULL;
GO;
CREATE TYPE [dbo].[GLCategory]
	FROM varchar(30) NOT NULL;
GO;

CREATE TYPE [dbo].[GLAmount]
	FROM money NOT NULL;
GO;
CREATE TYPE [dbo].AppUserName
	FROM varchar(150) NOT NULL;
GO;
CREATE TYPE [dbo].[AccountId]
	FROM int NOT NULL;
GO;

CREATE TYPE [dbo].[EstoppelId]
	FROM int NOT NULL;
GO;
CREATE TYPE [dbo].[LotId]
	FROM int NOT NULL;
GO;

CREATE TYPE [dbo].[GLTransactionId]
	FROM int NOT NULL;
GO;
CREATE TYPE [dbo].[HouseNumber]
	FROM int NOT NULL;
GO;
CREATE TYPE [dbo].[AddressName]
	FROM varchar(150) NOT NULL;
GO;
CREATE TYPE [dbo].[AddressLine]
	FROM varchar(150) NOT NULL;
GO;
CREATE TYPE [dbo].[AddressCity]
	FROM varchar(150) NOT NULL;
GO;
CREATE TYPE [dbo].[AddressStateCode]
	FROM varchar(2) NOT NULL;
GO;
CREATE TYPE [dbo].[AddressZipCode]
	FROM varchar(5) NOT NULL;
GO;

