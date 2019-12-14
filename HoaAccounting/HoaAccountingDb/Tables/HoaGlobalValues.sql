CREATE TABLE [dbo].[HoaGlobalValues]
(
	[DefaultAddressCity] [AddressCity] NOT NULL ,
	[DefaultAddressStateCode] [AddressStateCode] NOT NULL ,
	[DefaultAddressZipCode] [AddressZipCode] NOT NULL ,
	[CurrentAssesmentYear] [AssesmentYear] default(datepart(year,getdate())),
	[CurrentAssesmentAmount] money default(0)
)
