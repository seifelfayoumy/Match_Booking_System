CREATE FUNCTION allUnassignedMatches
(@clubName VARCHAR(20))
RETURNS @result TABLE (
  guestClubName VARCHAR(20),
  startTime DATETIME)

AS 
BEGIN

  INSERT INTO @result
  SELECT C2.cName , M.startTime
  FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId
  WHERE C1.cName = @clubName AND M.stadiumId IS NULL

  RETURN

END