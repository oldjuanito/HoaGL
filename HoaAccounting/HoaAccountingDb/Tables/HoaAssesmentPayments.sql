CREATE TABLE [dbo].[HoaAssesmentPayments]
(
	[HouseNumber] [HouseNumber] ,
	[AssesmentYear] [AssesmentYear] DEFAULT (2020), 
	[AmountPaid] money default (150) NOT NULL,
	[DateReceived] [AssesmentReceivedDate] default (GetDate()),
	[AssesmentDepositedDate] [AssesmentDepositedDate],
    PRIMARY KEY ([AssesmentYear], [HouseNumber]), 
    CONSTRAINT [CK_HoaAssesmentPayments_Dates] CHECK ([AssesmentDepositedDate] is null or [AssesmentDepositedDate] >= [DateReceived]),
)
