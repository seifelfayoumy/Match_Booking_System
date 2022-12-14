CREATE PROCEDURE blockFan
  @nationalId VARCHAR(20)

AS
BEGIN

  UPDATE Fan 
SET fStatus = 0
WHERE nationalId = @nationalId

END