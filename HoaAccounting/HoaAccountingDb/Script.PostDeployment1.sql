/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--select chk.definition, col.name, st.schema_id
--from sys.check_constraints chk
--inner join sys.columns col
--    on chk.parent_object_id = col.object_id
--inner join sys.tables st
--    on chk.parent_object_id = st.object_id
--where 1=1
--and st.name = 'ConstraintDefinitions'
--and col.column_id = chk.parent_column_id

DECLARE @constrainstSQL nvarchar(max)

SET @constrainstSQL = 'BEGIN TRAN; '
SELECT @constrainstSQL = @constrainstSQL + [ConstraintsToGenerate].DropConstraintSql  + '; '
FROM Puppy.[ConstraintsToGenerate]
SELECT @constrainstSQL = @constrainstSQL + [ConstraintsToGenerate].AddConstraintSql  + '; '
FROM Puppy.[ConstraintsToGenerate]
SET @constrainstSQL = @constrainstSQL + 'COMMIT TRAN '
--print @constrainstSQL
EXEC(@constrainstSQL)

--------------- CRUD Sps

DECLARE @crudSQL nvarchar(max) = ';'
SELECT @crudSQL = @crudSQL + [CallsToMakeCrudToGenerate].Cmd 
FROM Puppy.[CallsToMakeCrudToGenerate]
--print @crudSQL
EXEC(@crudSQL)
--------------- Valid Values constraints 


SET @constrainstSQL = 'BEGIN TRAN; '
SELECT @constrainstSQL = @constrainstSQL + g.DropConstraintSql  + '; '
FROM Puppy.ValidValuesConstraintsToGenerate g
SELECT @constrainstSQL = @constrainstSQL + g.AddConstraintSql  + '; '
FROM Puppy.ValidValuesConstraintsToGenerate g
SET @constrainstSQL = @constrainstSQL + 'COMMIT TRAN '
print @constrainstSQL
EXEC(@constrainstSQL)

--------------- Valid Ranges constraints 
SET @constrainstSQL = 'BEGIN TRAN; '
SELECT @constrainstSQL = @constrainstSQL + g.DropConstraintSql  + '; '
FROM Puppy.ValidRangesConstraintsToGenerate g
SELECT @constrainstSQL = @constrainstSQL + g.AddConstraintSql  + '; '
FROM Puppy.ValidRangesConstraintsToGenerate g
SET @constrainstSQL = @constrainstSQL + 'COMMIT TRAN '
print @constrainstSQL
EXEC(@constrainstSQL)
---------- ROle and security samples (needed for non dbo users)
if not exists (select 1 from sys.database_principals where name='WebAppRole' and Type = 'R')
begin
CREATE ROLE [WebAppRole]
end
--GRANT exec ON [dbo].[spAddStudent] TO [WebAppRole]
grant select on sys.parameters TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[GLDescription] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[TransactionDate] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].CreditDebitFlag TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[BillPayConfirmation] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[CheckNumber] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[GLCategory] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[GLAmount] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AccountId] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[EstoppelId] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[LotId] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[GLTransactionId] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[HouseNumber] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AddressLine] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AddressCity] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AddressStateCode] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AddressZipCode] TO [WebAppRole]
GRANT VIEW DEFINITION ON TYPE::[dbo].[AddressName] TO [WebAppRole]

--standard username
GRANT VIEW DEFINITION ON TYPE::[dbo].AppUserName TO [WebAppRole]
GO
