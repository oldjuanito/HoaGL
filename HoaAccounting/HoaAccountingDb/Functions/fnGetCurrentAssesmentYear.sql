CREATE FUNCTION [dbo].[fnGetCurrentAssesmentYear]
(
)
RETURNS INT
AS
BEGIN
	RETURN (select top 1 d.[CurrentAssesmentYear] from [dbo].[HoaGlobalValues] d)
END
