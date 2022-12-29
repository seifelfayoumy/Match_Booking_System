CREATE PROCEDURE addHostRequest
  @clubName VARCHAR(20),
  @stadiumName VARCHAR(20),
  @startTime DATETIME

AS
BEGIN

  DECLARE @representativeId INT
  SET @representativeId = (
  SELECT TOP 1 CR.crId
  FROM ClubRepresentative CR INNER JOIN Club C ON C.cId = CR.clubId
  WHERE C.cName = @clubName
  )

  DECLARE @stadiumManagerId INT
  SET @stadiumManagerId = (
  SELECT TOP 1 SM.smId
  FROM StadiuManager SM INNER JOIN Stadium S ON SM.stadiumId = S.stId
  WHERE S.stName = @stadiumName
  )

  DECLARE @matchId INT
  SET @matchId = (
  SELECT TOP 1 M.mId
  FROM Match M INNER JOIN Stadium S ON M.stadiumId = S.stId
  WHERE S.stName = @stadiumName AND M.startTime = @startTime
  )

  INSERT INTO ClubStadiumRequest
  VALUES(@representativeId, @stadiumManagerId, @matchId, 'unhandled')

END