CREATE TABLE [dbo].[Lots]
(
	[HouseNumber] [HouseNumber] ,
	[Address] varchar(120) not null, 
	[Name]  varchar(120) not null DEFAULT '', 
    [NonHomeLot] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_Lots] PRIMARY KEY ([HouseNumber])

)
