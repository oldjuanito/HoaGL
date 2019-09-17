CREATE TABLE [dbo].[Estoppels]
(
	[EstoppelId]  [EstoppelId] identity(1,1) PRIMARY KEY,
	[HouseNumber] [HouseNumber],
	Amount money not null, 
	DepositedOn date NOT NULL,
	TitleCompany varchar(130) NOT NULL,
	[GLTransactionId] [GLTransactionId] null, 
    CONSTRAINT [FK_Estoppels_Lots] FOREIGN KEY ([HouseNumber]) REFERENCES Lots([HouseNumber])

)
