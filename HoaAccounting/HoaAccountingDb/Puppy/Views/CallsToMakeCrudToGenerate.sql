CREATE VIEW Puppy.[CallsToMakeCrudToGenerate]
	AS 
SELECT 'exec Puppy.spMakeCrud @TableName=''' + s.TABLE_NAME + ''', @SchemaName = ''' + s.TABLE_SCHEMA + '''; ' +CHAR(13) + CHAR(10)  cmd
FROM information_schema.tables as s
where s.TABLE_SCHEMA not in ('Puppy', 'Sys', 'Generated') and s.TABLE_NAME not like '[_]%'
and s.TABLE_TYPE = 'BASE TABLE'