CREATE TABLE [dbo].[Lots]
(
	[HouseNumber] [HouseNumber] ,
	[Address] varchar(120) not null, 
	[Name]  varchar(120) not null DEFAULT '', 
    CONSTRAINT [PK_Lots] PRIMARY KEY ([HouseNumber])

)
