CREATE PROCEDURE puppy.[spGetPossibleValuesForUdf]
	@UdfName NVARCHAR(50)
AS
	SELECT [Value], [Label]
	from Puppy.[ValidValuesConstraints]
	where UdfName = @UdfName
	order by [Label], [Value]