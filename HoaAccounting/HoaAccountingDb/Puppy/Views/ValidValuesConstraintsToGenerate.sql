CREATE VIEW Puppy.ValidValuesConstraintsToGenerate
AS
SELECT Cols.ColTypeName
	,ColumnName
	,'
ALTER TABLE ' + Cols.TableFullName + '
	ADD CONSTRAINT [' + Cols.ColTypeName + 'ValidValuesConstraint] 
	CHECK (' + ColumnName + ' in (' + definedValues.ValidValues + ') )' AddConstraintSql
	,'ALTER TABLE ' + Cols.TableFullName + ' DROP CONSTRAINT IF EXISTS [' + Cols.ColTypeName + 'ValidValuesConstraint]' DropConstraintSql
FROM (
	SELECT col.name ColumnName
		,'[' + sch.name + '].[' + o.name + ']' TableFullName
		--,col.user_type_id
		,o.type_desc ObjectType
		,t.name ColTypeName
	FROM sys.columns col
	INNER JOIN sys.types t ON col.user_type_id = t.user_type_id
		AND t.is_user_defined = 1
	INNER JOIN sys.objects o ON col.object_id = o.object_id
	INNER JOIN sys.schemas sch ON sch.schema_id = o.schema_id
		AND sch.name <> 'Puppy'
		AND sch.name <> 'sys'
		AND sch.name <> 'test'
	WHERE o.type_desc = 'USER_TABLE'
	) Cols
inner join (
	SELECT c.UdfName
	,STRING_AGG('''' + c.Value + '''', ',')  ValidValues
	FROM Puppy.ValidValuesConstraints c
	group by c.UdfName
	) definedValues
on definedValues.UdfName = Cols.ColTypeName