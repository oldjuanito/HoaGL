CREATE TABLE [dbo].[GLTransactions]
(
[GLTransactionId] int not null identity(1,1),
[AccountId] [AccountId],
	[CreditDebitFlag] CreditDebitFlag,
[Description] [GLDescription],
[ReportDescription] [GLDescription],
[TransactionDate] [TransactionDate],
[BillPayConfirmation]  [BillPayConfirmation],
[CheckNumber] [CheckNumber],
 [Amount] [GLAmount], 
TranCount int not null,
[GLCategory] [GLCategory], 
    [CreatedOn] DATETIME NOT NULL DEFAULT GetDate() , 
    CONSTRAINT [PK_GLTransactions] PRIMARY KEY ([GLTransactionId]), 

)
