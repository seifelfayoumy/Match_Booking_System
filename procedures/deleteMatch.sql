CREATE PROCEDURE deleteMatch
  @hostClubName VARCHAR(20),
  @guestClubName VARCHAR(20)
AS
BEGIN

  DELETE M FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId
WHERE C1.cName = @hostClubName AND C2.cName = @guestClubName

END