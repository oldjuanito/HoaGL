CREATE TABLE [dbo].[GLTransactions]
(
[GLTransactionId] int not null identity(1,1),
	[CreditDebitFlag] CreditDebitFlag,
[Description] [GLDescription],
[TransactionDate] [TransactionDate],
[BillPayConfirmation]  [BillPayConfirmation],
[CheckNumber] [CheckNumber],
 [Amount] [GLAmount], 
TranCount int not null,
[GLCategory] [GLCategory], 
    CONSTRAINT [PK_GLTransactions] PRIMARY KEY ([GLTransactionId]), 

)
