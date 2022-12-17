CREATE FUNCTION clubsNeverPlayed
(@clubName VARCHAR(20))
RETURNS @result TABLE(
  clubName VARCHAR(20)
)

AS
BEGIN

INSERT INTO @result 
SELECT C.cName
FROM Club C
WHERE NOT EXISTS(
  SELECT * 
  FROM Match M 
  INNER JOIN C ON C.cId = M.hostClubId
  INNER JOIN C2 ON C2.cId = M.guestClubId
  WHERE C2.cName = @clubName
)
AND NOT EXISTS(
    SELECT * 
  FROM Match M2 
  INNER JOIN C ON C.cId = M2.guestClubId
  INNER JOIN C2 ON C2.cId = M2.hostClubId
  WHERE C2.cName = @clubName
)

RETURN
END