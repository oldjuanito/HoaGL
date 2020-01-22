CREATE TABLE [dbo].[GLTransactions] (
	[GLTransactionId] [GLTransactionId] identity(1, 1)
	,[AccountId] [AccountId]
	,[CreditDebitFlag] CreditDebitFlag
	,[Description] [GLDescription]
	,[ReportDescription] [GLDescription]
	,[TransactionDate] [TransactionDate]
	,[BillPayConfirmation] [BillPayConfirmation]
	,[CheckNumber] [CheckNumber]
	,[Amount] [GLAmount]
	,TranCount INT NOT NULL
	,[GLCategory] [GLCategory]
	,[CreatedOn] DATETIME NOT NULL DEFAULT GetDate()
	,ExcludeFromReport bit NOT NULL DEFAULT 0
	,CONSTRAINT [PK_GLTransactions] PRIMARY KEY ([GLTransactionId])
	,
	)
