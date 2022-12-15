CREATE FUNCTION upcomingMatchesOfClub
(@clubName VARCHAR(20))
RETURNS @result TABLE(
  clubName VARCHAR(20),
  secondClubName VARCHAR(20),
  startTime DATETIME,
  stadiumName VARCHAR(20)
)

AS
BEGIN

  INSERT INTO @result
  SELECT C1.cName, C2.cName, M.startTime, S.stName
  FROM Match M INNER JOIN Club C1 ON M.hostClubId = C1.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
    INNER JOIN Stadium S ON S.stId = M.stadiumId
  WHERE @clubName = C1.cName OR @clubName = C2.cName

  RETURN
END