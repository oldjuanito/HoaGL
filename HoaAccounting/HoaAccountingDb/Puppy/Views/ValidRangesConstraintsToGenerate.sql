CREATE VIEW Puppy.ValidRangesConstraintsToGenerate
AS
SELECT Cols.ColTypeName
	,ColumnName
	,'
ALTER TABLE ' + Cols.TableFullName + '
	ADD CONSTRAINT [' + Cols.ColTypeName + 'ValidRangeConstraint] 
	CHECK (' + ValidRange + ' )' AddConstraintSql
	,'ALTER TABLE ' + Cols.TableFullName + ' DROP CONSTRAINT IF EXISTS [' + Cols.ColTypeName + 'ValidRangeConstraint]' DropConstraintSql
FROM (
	SELECT col.name ColumnName
		,'[' + sch.name + '].[' + o.name + ']' TableFullName
		--,col.user_type_id
		,o.type_desc ObjectType
		,t.name ColTypeName
		,type_name(t.system_type_id) BaseSqlTypeName
		,case 
		when c.[From] is null 
		then '' 
		else 
			'[' + col.name + ']'
			+ ' >= ' 
			+ (case when type_name(t.system_type_id) like '%char%' or type_name(t.system_type_id) like '%date%' then '''' else '' end) 
			+ c.[From] 
			+ (case when type_name(t.system_type_id) like '%char%' or type_name(t.system_type_id) like '%date%' then '''' else '' end) 
	end
	+ (case when c.[From] is null OR c.[To] is null then '' else ' AND ' end) + 
	case 
		when c.[To] is null 
		then '' 
		else 
	
			'[' + col.name + ']'
			+ ' <= ' 
			+ (case when type_name(t.system_type_id) like '%char%' or type_name(t.system_type_id) like '%date%' then '''' else '' end) 
			+ c.[To] 
			+ (case when type_name(t.system_type_id) like '%char%' or type_name(t.system_type_id) like '%date%' then '''' else '' end) 
	end

	ValidRange
	FROM sys.columns col
	INNER JOIN sys.types t ON col.user_type_id = t.user_type_id
		AND t.is_user_defined = 1
	INNER JOIN sys.objects o ON col.object_id = o.object_id
	INNER JOIN sys.schemas sch ON sch.schema_id = o.schema_id
		AND sch.name <> 'Puppy'
		AND sch.name <> 'sys'
		AND sch.name <> 'test'
	INNER JOIN  Puppy.ValidRangeConstraints c
		ON c.UdfName = t.name
		AND t.is_user_defined = 1
	WHERE o.type_desc = 'USER_TABLE'
	) Cols