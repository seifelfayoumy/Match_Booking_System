CREATE FUNCTION requestsFromClub
(@stadiumName VARCHAR(20), @clubName VARCHAR(20))
RETURNS @result TABLE (hostName VARCHAR(20) ,guestName VARCHAR(20))

AS
BEGIN

INSERT INTO @result
SELECT ClubStadiumRequest CSR INNER JOIN 

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
-- SELECT @smId = smId FROM StadiumManger WHERE @stId = stadiumId

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