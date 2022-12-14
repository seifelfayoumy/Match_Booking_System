CREATE PROCEDURE deleteClub
  @clubName VARCHAR(20)

AS
BEGIN

  DELETE C FROM Club C 
WHERE C.cName = @clubName

END