CREATE TABLE [dbo].[stage_OLBImport] (
	[OlbTransactionId] int identity(1, 1)
	,[TranDate] date
	,[Amount] [OlbTranAmount]
	,Filler [char]
	,[CheckNumber] [CheckNumber]
	,[Description] [GLDescription], 
    [AccountId] [AccountId] NULL
	)
