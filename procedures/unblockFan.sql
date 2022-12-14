CREATE PROCEDURE unblockFan
  @nationalId VARCHAR(20)

AS
BEGIN

  UPDATE Fan 
SET fStatus = 1
WHERE nationalId = @nationalId

END