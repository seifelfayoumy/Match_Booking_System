CREATE FUNCTION requestsFromClub
(@stadiumName VARCHAR(20), @clubName VARCHAR(20))
RETURNS @result TABLE (hostName VARCHAR(20) ,guestName VARCHAR(20))

AS
BEGIN

  DECLARE @representativeId INT
  SET @representativeId
  = (
    SELECT TOP 1 CR.crId
  FROM ClubRepresentative CR INNER JOIN Club C ON CR.clubId = CR.cId
  WHERE C.cName = @clubName
  )

    DECLARE @stadiumManagerId INT
  SET @stadiumManagerId
  = (
    SELECT TOP 1 SM.smId
  FROM StadiumManager SM INNER JOIN Stadium S ON SM.stadiumId = SM.stId
  WHERE S.stName = @stadiumName
  )

INSERT INTO @result
SELECT C1.cName AS Host, C2.cName AS Guest
FROM ClubStadiumRequest CSR 
INNER JOIN Match M ON CSR.matchId = M.mId
INNER JOIN Club C1 on M.hostClubId = C1.cName
INNER JOIN Club C2 on M.guestClubId = C2.cName
WHERE CSR.representativeId = @representativeId AND CSR.stadiumManagerId = @stadiumManagerId

RETURN
END

-- CREATE FUNCTION requestsFromClub
-- (@stadiumName VARCHAR(20), @clubName VARCHAR(20))

-- RETURNS @result TABLE (hostName VARCHAR(20) ,guestName VARCHAR(20))

-- AS
-- BEGIN

-- DECLARE @cId AS INT
-- SELECT @cId = cId FROM Club WHERE cName = @ClubName

-- DECLARE @crId AS INT
-- SELECT @crId = crId FROM ClubRepresentative WHERE clubId = @cId

-- DECLARE @stId AS INT
-- SELECT @stId = stId FROM Stadium WHERE stName = @StadiumName

-- DECLARE @smId INT
-- SELECT @smId = smId FROM StadiumManager WHERE @stId = stadiumId

-- DECLARE @matchId AS INT
-- SELECT @matchId = matchId FROM ClubStadiumRequest WHERE @crId = clubRepresantativeId AND @stId = stadiumManagerId

-- DECLARE @hostClubId AS INT
-- SELECT @hostClubId = hostClubId FROM Match WHERE mId = @matchId

-- DECLARE @guestClubId AS INT
-- SELECT @guestClubId = guestClubId FROM Match WHERE mId = @matchId

-- DECLARE @hostName AS VARCHAR(20)
-- SELECT cName = @hostName FROM Club WHERE cId = @hostClubId

-- DECLARE @guestName AS VARCHAR(20)
-- SELECT cName = @guestName FROM Club WHERE cId = @guestClubId

-- RETURN @hostName, @guestName

-- END