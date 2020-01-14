CREATE FUNCTION [dbo].[fnGetMailingInfoOfPaidAssesment] (@AssesmentYear [AssesmentYear])
RETURNS TABLE
AS
RETURN (
		SELECT [m].[AddressName]
			,[m].[HouseNumber]
			,case when [AmountPaid] is null then 0 else 1 end Paid
			,[m].[AddressLine]
			,[m].[AddressCity]
			,[m].[AddressStateCode]
			,[m].[AddressZipCode]
			,[m].[IsAlternateAddress]
			,[AssesmentYear]
			,[AmountPaid]
			,[DateReceived]
			,[AssesmentDepositedDate]
		FROM [dbo].[vMailingAddresses] m
		LEFT JOIN [dbo].[HoaAssesmentPayments] p ON p.HouseNumber = m.HouseNumber
		and p.AssesmentYear = @AssesmentYear
		)
