CREATE PROCEDURE dropAllProceduresFunctionsViews
AS
BEGIN

DECLARE @procName VARCHAR(500)
DECLARE cur CURSOR 
for SELECT [name] from sys.objects where type = 'p'
open cur
fetch next from cur into @procName
while @@fetch_status = 0
if @procName != 'dropAllProceduresFunctionsViews'
begin
    exec('drop procedure [dbo]. [' + @procName + ']')
    fetch next from cur into @procName
end
close cur
deallocate cur

DECLARE @viewName VARCHAR(500)
DECLARE cur CURSOR 
for SELECT [name] from sys.objects where type = 'v'
open cur
fetch next from cur into @viewName
while @@fetch_status = 0
begin
    exec('drop view [dbo]. [' + @viewName + ']')
    fetch next from cur into @viewName
end
close cur
deallocate cur

Declare @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + N' DROP FUNCTION ' 
                   + QUOTENAME(SCHEMA_NAME(schema_id)) 
                   + N'.' + QUOTENAME(name)
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%';
Exec sp_executesql @sql

END