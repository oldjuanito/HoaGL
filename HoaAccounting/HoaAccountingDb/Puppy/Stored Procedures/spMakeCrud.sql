/*
This is a simple, single-table CRUD Generator. It does not have a bunch of 
bells and whistles, and is easy to follow and modify. I wrote this to make
my job easier, and I am sharing it with you to do with it as you wish.

The Basics:
The TSQL below will create 3 procedures:
    1. An Upsert Procedure: Suffix _ups 
    2. A Select Procedure: Suffix _sel
    3. A Delete Procedure: Suffix _del

A Little More Detail:
Things you should know:
    All 3 procedures have a parameter called @MyID which is used to set 
    the Context, so that my audit procedures get the validated user. If you
    Have no use for it, you'll need to remove the piece of generator code 
    that adds it as a parameter to each of the 3 procedures. You will also
    need to remove the PRINT statement for each procedure that looks like:

            PRINT N'  SET CONTEXT_INFO @MyID;' + CHAR(13) + CHAR(10) 

    This generator expects to perform inserts, updates, and deletes on a
    table, and selects from a view. If you want to perform selects directly
    from the table, simply use the table name in both @TableName and 
    @ViewName.

The Upsert Procedure:
    If ID (Primary Key) is supplied it will perform an Update. Otherwise it 
    will perform an Insert. This generator is hard-coded to avoid inserting
    or updating these particular fields:
                                        Created
                                        CreatedBy
                                        Modified
                                        ModifiedBy
                                        RowVersion
                                        <The Primary Key Field>
    That's because in my databases I use those field names for audit, and they
    are never modified except internally within the database. You can modify
    the part of this procedure that performs this function to suit your needs.

    This generator always uses the Parameter name @ID to represent the Primary
    key defined for the table. This is my preference but you can modify to suit.

The Select Procedure:
    If ID (Primary Key) is supplied it will select a single row from the View 
    (Table) whose name you provide. Otherwise it will select all rows. If the 
    @ISACTIVE_SEL variable is set to 1 (True), then the Select Procedure expects
    your View (Table) to have a bit-type field named 'IsActive'. My tables are 
    standardized to this. If @ISACTIVE_SEL = 1 the Select Procedure will have an
    additional parameter called @IsActive (bit). When @ID is not supplied, and 
    @IsActive is not supplied, the procedure selects all rows. When @ID is not
    supplied, and @IsActive is supplied, the procedure selects all rows where
    the field IsActive matches the parameter @IsActive

The Delete Procedure:
    The Delete Pocedure requires that the Key value and the RowVersion value
    be supplied. I use an Int type RowVersion, so if you use TimeStamp (varbinary(128))
    then you will need to tweak the generator.


    --Casey W Little
    --Kaciree Software Solutions, LLC
    Version 1.00
*/
--Type Your Database Name in this Use statement:
CREATE PROC Puppy.spMakeCrud @TableName NVARCHAR(100)
	,@SchemaName NVARCHAR(100) = 'dbo'
AS
/*MODIFY THE VALUES BELOW TO SUIT YOUR NEEDS*/
DECLARE @DBName NVARCHAR(100) = DB_NAME();
DECLARE @ProcName NVARCHAR(100) = N'spGenerated' + replace(@TableName, ' ', '');
--DECLARE @DBRoleName nvarchar(100)=N'<Role that should have exec Rights>';
DECLARE @ViewName NVARCHAR(100) = @TableName;
DECLARE @OrderBy NVARCHAR(100) = N'';
DECLARE @OrderByDir NVARCHAR(4) = N'';
DECLARE @AUTHOR NVARCHAR(50) = '<Your Name & Company>';
DECLARE @DESC NVARCHAR(100) = '<Proc Information>';-- Ex. 'User Data' will return 'Description : Upsert User Data'
DECLARE @ISACTIVE_SEL BIT = 0;--Set to 1 if your table has a Bit field named IsActive
	/*DO NOT MODIFY BELOW THIS LINE!!!*/
DECLARE @NNND CHAR(23) = 'NOT_NULLABLE_NO_DEFAULT';
DECLARE @NNWD CHAR(22) = 'NOT_NULLABLE_W_DEFAULT';
DECLARE @NBLE CHAR(8) = 'NULLABLE';
DECLARE @LEGEND NVARCHAR(max) = '';
DECLARE @PRIMARY_KEY NVARCHAR(100);

--Set up Legend
--SET @LEGEND = N'USE [' + @DBName + N'];' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'GO' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'SET ANSI_NULLS ON' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'GO' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'SET QUOTED_IDENTIFIER ON' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'GO' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'-- ===================================================================' + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'-- Author      : ' + @AUTHOR + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'-- Create date : ' + CONVERT(NVARCHAR(30), GETDATE(), 101) + CHAR(13) + CHAR(10)
--SET @LEGEND = @LEGEND + N'-- Revised date: ' + CHAR(13) + CHAR(10)

--Get Primary Key Field
SELECT TOP 1 @PRIMARY_KEY = COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE OBJECTPROPERTY(OBJECT_ID(constraint_name), 'IsPrimaryKey') = 1
	AND TABLE_NAME = @TableName
	AND TABLE_CATALOG = @DBName;

DECLARE TableCol CURSOR
FOR
SELECT c.TABLE_SCHEMA
	,c.TABLE_NAME
	,c.COLUMN_NAME
	,c.DATA_TYPE
	,c.CHARACTER_MAXIMUM_LENGTH
	,IIF(c.COLUMN_NAME = 'RowVersion', @NBLE, IIF(c.IS_NULLABLE = 'NO'
				AND c.COLUMN_DEFAULT IS NULL, @NNND, IIF(c.IS_NULLABLE = 'NO'
					AND c.COLUMN_DEFAULT IS NOT NULL, @NNWD, @NBLE))) AS [NULLABLE_TYPE]
FROM INFORMATION_SCHEMA.Columns c
INNER JOIN INFORMATION_SCHEMA.Tables t ON c.TABLE_NAME = t.TABLE_NAME
WHERE t.Table_Catalog = @DBName
	AND t.TABLE_TYPE = 'BASE TABLE'
	AND t.TABLE_NAME = @TableName
ORDER BY c.ORDINAL_POSITION;

DECLARE @TableSchema VARCHAR(100)
	,@cTableName VARCHAR(100)
	,@ColumnName VARCHAR(100);
DECLARE @DataType VARCHAR(30)
	,@CharLength INT
	,@NullableType VARCHAR(30);
DECLARE @SQL_TO_EXEC NVARCHAR(max) = '';
DECLARE @SELECT_COLS NVARCHAR(max);
DECLARE @PARAMETERS NVARCHAR(max);
DECLARE @INSERT_FIELDS NVARCHAR(max)
	,@INSERT_VALUES NVARCHAR(max);
DECLARE @UPDATE_VALUES NVARCHAR(max);

SET @PARAMETERS = '';
SET @SELECT_COLS = '';
SET @INSERT_FIELDS = '';
SET @INSERT_VALUES = '';
SET @UPDATE_VALUES = '';

-- open the cursor
OPEN TableCol

-- get the first row of cursor into variables
FETCH NEXT
FROM TableCol
INTO @TableSchema
	,@cTableName
	,@ColumnName
	,@DataType
	,@CharLength
	,@NullableType

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @ColumnName NOT IN (
			'Created'
			,'Modified'
			)
	BEGIN
		SET @PARAMETERS = @PARAMETERS + '@' + @ColumnName + ' ' + iif(@CharLength IS NULL, @DataType, @DataType + '(' + CAST(@CharLength AS NVARCHAR(10)) + ')') + IIF(@NullableType = @NNND
				OR @NullableType = @NNWD, ',', '=NULL,');

		IF @ColumnName <> @PRIMARY_KEY
			AND @ColumnName <> N'RowVersion'
		BEGIN
			SET @INSERT_FIELDS = @INSERT_FIELDS + '[' + @ColumnName + '],';
			SET @INSERT_VALUES = @INSERT_VALUES + '@' + IIF(@ColumnName = @PRIMARY_KEY, 'ID', @ColumnName) + ',';
			SET @UPDATE_VALUES = @UPDATE_VALUES + '[' + @ColumnName + ']=@' + IIF(@ColumnName = @PRIMARY_KEY, 'ID', @ColumnName) + ',';
		END
	END

	SET @SELECT_COLS = @SELECT_COLS + '[' + @ColumnName + '],';

	FETCH NEXT
	FROM TableCol
	INTO @TableSchema
		,@cTableName
		,@ColumnName
		,@DataType
		,@CharLength
		,@NullableType
END;

SET @SELECT_COLS = case when LEN(@SELECT_COLS) > 0 then  LEFT(@SELECT_COLS, LEN(@SELECT_COLS) - 1) else '' end
SET @PARAMETERS = case when LEN(@PARAMETERS) > 0 then LEFT(@PARAMETERS, LEN(@PARAMETERS) - 1) else '' end
SET @INSERT_FIELDS = case when LEN(@INSERT_FIELDS) > 0 then LEFT(@INSERT_FIELDS, LEN(@INSERT_FIELDS) - 1) else '' end
SET @INSERT_VALUES = case when LEN(@INSERT_VALUES) > 0 then LEFT(@INSERT_VALUES, LEN(@INSERT_VALUES) - 1) else '' end
SET @UPDATE_VALUES = case when LEN(@UPDATE_VALUES) > 0 then LEFT(@UPDATE_VALUES, LEN(@UPDATE_VALUES) - 1) else '' end

-- ----------------
-- clean up cursor
-- ----------------
CLOSE TableCol;

DEALLOCATE TableCol;

--Print Upsert Statement
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'/****** Object:  StoredProcedure [Generated].[' + @ProcName + '_ups]    Script Date: ' + CAST(GETDATE() AS NVARCHAR(30)) + '  ******/' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + @LEGEND;
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- Description : Upsert ' + @DESC + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- ===================================================================' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'CREATE OR ALTER PROCEDURE [Generated].[' + @ProcName + '_ups]' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  (' + @PARAMETERS + N')' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'AS' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'BEGIN' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  IF @' + @PRIMARY_KEY + ' = 0' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'    BEGIN' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'      INSERT INTO ' + @SchemaName + '.[' + @TableName + ']' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'        (' + @INSERT_FIELDS + N')' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'      VALUES' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'        (' + @INSERT_VALUES + N');' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'      SELECT ' + @SELECT_COLS + ' FROM ' + @SchemaName + '.[' + @ViewName + '] WHERE [' + @PRIMARY_KEY + '] = SCOPE_IDENTITY();' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'    END' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  ELSE' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'    BEGIN' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'      UPDATE ' + @SchemaName + '.[' + @TableName + ']' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'        SET ' + @UPDATE_VALUES + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'        WHERE ([' + @PRIMARY_KEY + '] = @' + @PRIMARY_KEY + ') ;' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'      SELECT ' + @SELECT_COLS + ' FROM ' + @SchemaName + '.[' + @ViewName + '] WHERE [' + @PRIMARY_KEY + ']=@' + @PRIMARY_KEY + ';' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'    END' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'END;' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
--PRINT @SQL_TO_EXEC
exec sp_executesql @SQL_TO_EXEC
set @SQL_TO_EXEC = ''

----Now add GRANT and DENY permissions to the Role
--PRINT N'GRANT EXECUTE ON [Generated].[' + @ProcName + '_ups] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--PRINT N'GO' + CHAR(13) + CHAR(10) 
--PRINT N'DENY VIEW DEFINITION ON [Generated].[' + @ProcName + '_ups] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--PRINT N'GO' + CHAR(13) + CHAR(10) 
--PRINT CHAR(13) + CHAR(10) 
--PRINT CHAR(13) + CHAR(10) 
--Print Select Statement
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'/****** Object:  StoredProcedure [Generated].[' + @ProcName + '_sel]    Script Date: ' + CAST(GETDATE() AS NVARCHAR(30)) + '  ******/' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + @LEGEND;
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- Description : Select ' + @DESC + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- ===================================================================' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'CREATE OR ALTER PROCEDURE [Generated].[' + @ProcName + '_sel]' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  (@' + @PRIMARY_KEY + ' int)' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'AS' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'BEGIN' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'    SELECT ' + @SELECT_COLS + ' FROM ' + @SchemaName + '.[' + @TableName + '] WHERE [' + @PRIMARY_KEY + ']=@' + @PRIMARY_KEY + ';' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'END;' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
--PRINT @SQL_TO_EXEC
exec sp_executesql @SQL_TO_EXEC
set @SQL_TO_EXEC = ''

------Now add GRANT and DENY permissions to the Role
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GRANT EXECUTE ON [Generated].[' + @ProcName + '_sel] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10) 
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'DENY VIEW DEFINITION ON [Generated].[' + @ProcName +'_sel] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10) 
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10) 
--	SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10) 
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + Delete Statement
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'/****** Object:  StoredProcedure [Generated].[' + @ProcName + '_del]    Script Date: ' + CAST(GETDATE() AS NVARCHAR(30)) + '  ******/' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + @LEGEND;
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- Description : Delete ' + @DESC + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'-- ===================================================================' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'CREATE OR ALTER PROCEDURE [Generated].[' + @ProcName + '_del]' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  ( @' + @PRIMARY_KEY + ' int, @ModifiedBy AppUserName)' + CHAR(13) + CHAR(10);
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'AS' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'BEGIN' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  SET NOCOUNT ON;' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'  DELETE FROM ' + @SchemaName + '.[' + @TableName + '] WHERE [' + @PRIMARY_KEY + ']=@' + @PRIMARY_KEY + ' ;' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'END;' + CHAR(13) + CHAR(10)
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10)
SET @SQL_TO_EXEC = @SQL_TO_EXEC + CHAR(13) + CHAR(10)
--PRINT @SQL_TO_EXEC
exec sp_executesql @SQL_TO_EXEC
set @SQL_TO_EXEC = ''

----Now add GRANT and DENY permissions to the Role
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GRANT EXECUTE ON [Generated].[' + @ProcName + '_del] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10) 
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'DENY VIEW DEFINITION ON [Generated].[' + @ProcName +'_del] TO [' + @DBRoleName + ']' + CHAR(13) + CHAR(10) 
--SET @SQL_TO_EXEC = @SQL_TO_EXEC + N'GO' + CHAR(13) + CHAR(10)
--PRINT @SQL_TO_EXEC

exec sp_executesql @SQL_TO_EXEC