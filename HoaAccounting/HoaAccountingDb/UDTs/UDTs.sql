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
