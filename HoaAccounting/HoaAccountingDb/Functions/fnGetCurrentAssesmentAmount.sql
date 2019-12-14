CREATE FUNCTION [dbo].fnGetCurrentAssesmentAmount
(
)
RETURNS INT
AS
BEGIN
	RETURN (select top 1 d.CurrentAssesmentAmount from [dbo].[HoaGlobalValues] d)
END
