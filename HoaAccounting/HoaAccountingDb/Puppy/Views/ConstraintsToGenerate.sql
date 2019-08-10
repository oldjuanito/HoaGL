CREATE VIEW Puppy.[ConstraintsToGenerate]
AS
SELECT globalC.constraintDef
	,Cols.ColTypeName
	,ColumnName
	,'
ALTER TABLE ' + Cols.TableFullName + '
	ADD CONSTRAINT [' + Cols.ColTypeName + 'Constraint] 
	CHECK (' + replace(globalC.constraintDef, Cols.ColTypeName, ColumnName) + ')' AddConstraintSql
	,'ALTER TABLE ' + Cols.TableFullName + ' DROP CONSTRAINT IF EXISTS [' + Cols.ColTypeName + 'Constraint]' DropConstraintSql
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
OUTER APPLY (
	SELECT chk.DEFINITION constraintDef
		,col.name
		,st.schema_id
	FROM sys.check_constraints chk
	INNER JOIN sys.columns col ON chk.parent_object_id = col.object_id
	INNER JOIN sys.tables st ON chk.parent_object_id = st.object_id
	WHERE 1 = 1
		AND st.name = 'ConstraintDefinitions'
		AND col.column_id = chk.parent_column_id
		AND col.name = Cols.ColTypeName
	) globalC
WHERE globalC.constraintDef IS NOT NULL