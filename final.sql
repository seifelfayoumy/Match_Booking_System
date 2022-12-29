-- IMPORTNAT NOTE: To run without compilation errors, you have to run the 'createAllTables' 
-- and execute it first, then run the rest of procedures/functions/views normally

-- STORED PROCEDURES

CREATE PROCEDURE createAllTables
AS
BEGIN

  CREATE TABLE SystemUser
  (
    username VARCHAR(20) UNIQUE,
    suPassword VARCHAR(20),
    PRIMARY KEY (username)
  )

  CREATE TABLE Club
  (
    cId INT IDENTITY,
    cName VARCHAR(20) UNIQUE,
    cLocation VARCHAR(20),
    PRIMARY KEY (cId)
  )

  CREATE TABLE Stadium
  (
    stId INT IDENTITY,
    stName VARCHAR(20) UNIQUE,
    stCapacity INT,
    stLocation VARCHAR(20),
    stStatus BIT,
    PRIMARY KEY (stId),
  )

  CREATE TABLE StadiumManager
  (
    smId INT IDENTITY,
    smName VARCHAR(20),
    username VARCHAR(20) UNIQUE,
    stadiumId INT UNIQUE,
    PRIMARY KEY (smId),
    FOREIGN KEY (stadiumId) REFERENCES Stadium (stId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE ClubRepresentative
  (

    crId INT IDENTITY primary KEY,
    crName VARCHAR(20),
    username VARCHAR(20) UNIQUE,
    clubId INT UNIQUE,
    FOREIGN KEY (clubId) REFERENCES Club (cId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE AssociationManager
  (
    amId INT IDENTITY,
    amName VARCHAR(20),
    username VARCHAR(20) UNIQUE,
    PRIMARY KEY (amId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE SystemAdmin
  (
    saId INT IDENTITY,
    saName VARCHAR(20),
    username VARCHAR(20) UNIQUE,
    PRIMARY KEY (saId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE Fan
  (
    nationalId VARCHAR(20) UNIQUE,
    fName VARCHAR(20),
    username VARCHAR(20),
    phoneNumber INT,
    fAddress VARCHAR(20),
    birthDate DATE,
    fStatus BIT,
    PRIMARY KEY (nationalId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE Match
  (
    mId INT IDENTITY,
    startTime DATETIME,
    endTime DATETIME,
    hostClubId INT,
    guestClubId INT,
    allowedAttendees INT,
    stadiumId INT,
    PRIMARY KEY (mId),
    FOREIGN KEY (stadiumId) REFERENCES Stadium (stId),
    FOREIGN KEY (hostClubId) REFERENCES Club (cId),
    FOREIGN KEY (guestClubId) REFERENCES Club (cId),

  )

  create table ClubStadiumRequest
  (

    csrId INT IDENTITY,
    clubRepresentativeId INT,
    stadiumManagerId INT,
    matchId INT,
    csrStatus VARCHAR(20),
    PRIMARY KEY (csrId),
    FOREIGN KEY (clubRepresentativeId) REFERENCES ClubRepresentative (crId),
    FOREIGN KEY (stadiumManagerId) REFERENCES StadiumManager (smId),
    FOREIGN KEY (matchId) REFERENCES Match (mId)

  )

  CREATE TABLE Ticket
  (
    tId INT IDENTITY,
    matchId INT,
    tStatus BIT,
    availableCount INT,
    PRIMARY KEY (tId),
    FOREIGN KEY (matchId) REFERENCES Match (mId),
  )

  CREATE TABLE TicketFan
  (
    tfId INT IDENTITY,
    fId VARCHAR(20),
    tId INT,
    PRIMARY KEY (tfId),
    FOREIGN KEY (fId) REFERENCES Fan (nationalId),
    FOREIGN KEY (tId) REFERENCES Ticket (tId)
  )

END
GO

CREATE PROCEDURE acceptRequest
  @stadiumManagerUsername VARCHAR(20),
  @hostClubName VARCHAR(20),
  @guestClubName VARCHAR(20),
  @startTime DATETIME

AS
BEGIN

  UPDATE CSR
SET CSR.csrStatus = 'accepted'
FROM ClubStadiumRequest CSR
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId
    INNER JOIN Match M ON CSR.matchId = M.mId
    INNER JOIN Club C1 ON M.hostClubId = C1.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
  WHERE SM.username = @stadiumManagerUsername
    AND C1.cName = @hostClubName
    AND C2.cName = @guestClubName
    AND M.startTime = @startTime

END
GO

CREATE PROCEDURE addAssociationManager
  @name VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20)
AS
BEGIN

INSERT INTO SystemUser
VALUES(@username, @password)
Insert into AssociationManager
VALUES(@name, @username)

END
GO

CREATE PROCEDURE addClub
  @clubName VARCHAR(20),
  @clubLocation VARCHAR(20)

AS
BEGIN

  INSERT INTO Club
  VALUES(@clubName, @clubLocation)
END
GO

CREATE PROCEDURE addFan
  @name VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20),
  @nationalId VARCHAR(20),
  @birthDate DATE,
  @address VARCHAR(20),
  @phoneNumber VARCHAR(20)

AS
BEGIN

  INSERT INTO SystemUser
  VALUES(@username, @password)

  INSERT INTO Fan
  VALUES(@nationalId, @name, @username, @phoneNumber, @address, @birthDate, 1)

END
GO

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
  FROM StadiumManager SM INNER JOIN Stadium S ON SM.stadiumId = S.stId
  WHERE S.stName = @stadiumName
  )

  DECLARE @stadiumCount INT
  SET @stadiumCount = (
  SELECT TOP 1 S.allowedAttendees
  FROM Stadium S 
  WHERE S.stName = @stadiumName
  )

  DECLARE @matchId INT
  SET @matchId = (
  SELECT TOP 1 M.mId
  FROM Match M INNER JOIN Club C ON M.hostClubId = C.cId
  WHERE C.cName = @clubName AND M.startTime = @startTime
  )

  INSERT INTO ClubStadiumRequest
  VALUES(@representativeId, @stadiumManagerId, @matchId, 'unhandled')

  INSERT INTO Ticket VALUES(@matchId, 1, @stadiumCount)

END
GO

CREATE PROCEDURE addNewMatch
  @hostClub VARCHAR(20),
  @guestClub VARCHAR(20),
  @startTime DATETIME,
  @endTime DATETIME
AS
BEGIN

BEGIN
  DECLARE @club1Id INT
  SET @club1Id = (SELECT TOP 1 C.cId
  FROM Club C
  WHERE C.cName = @hostClub)
END

BEGIN
    DECLARE @club2Id INT
  SET @club2Id = (SELECT TOP 1 C1.cId
  FROM Club C1
  WHERE C1.cName = @guestClub)
END

INSERT INTO Match
VALUES(@startTime, @endTime, @club1Id, @club2Id, 3000, NULL)

END
GO

CREATE PROCEDURE addRepresentative
  @representativeName VARCHAR(20),
  @clubName VARCHAR(20),
  @representativeUsername VARCHAR(20),
  @representativePassword VARCHAR(20)

AS
BEGIN

  DECLARE @clubId INT
  SET @clubId = (SELECT TOP 1 C.cId
  FROM Club C
  WHERE C.cName = @clubName)

  INSERT INTO SystemUser
  VALUES(@representativeUsername, @representativePassword)

  INSERT INTO ClubRepresentative
  VALUES(@representativeName, @representativeUsername, @clubId)

END
GO

CREATE PROCEDURE addStadium
  @stadiumName VARCHAR(20),
  @stadiumLocation VARCHAR(20),
  @stadiumCapacity INT

AS
BEGIN

  INSERT INTO Stadium
  VALUES(@stadiumName, @stadiumCapacity, @stadiumLocation, 1)

END
GO

CREATE PROCEDURE addStadiumManager
  @stadiumManagerName VARCHAR(20),
  @stadiumName VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20)

AS
BEGIN


  DECLARE @stadiumId INT
  SET @stadiumId = (SELECT TOP 1 S.stId
  FROM Stadium S
  WHERE S.stName = @stadiumName)

  INSERT INTO SystemUser
  VALUES(@username, @password)

  INSERT INTO StadiumManager
  VALUES(@stadiumManagerName, @username, @stadiumId)

END
GO

CREATE PROCEDURE addTicket
  @hostClubName VARCHAR(20),
  @guestClubName VARCHAR(20),
  @startTime DATETIME

AS
BEGIN

  DECLARE @matchId INT
  SET @matchId
  = (
    SELECT TOP 1 M.mId
  FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId
  WHERE C1.cName = @hostClubName AND C2.cName = @guestClubName AND M.startTime = @startTime
  )

  DECLARE @availableCount INT
  SET @availableCount = (
      SELECT TOP 1 M.allowedAttendees
  FROM Match M
  WHERE M.mId = @matchId
    )

  INSERT INTO Ticket
  VALUES(@matchId, 1, @availableCount)

END
GO

CREATE PROCEDURE blockFan
  @nationalId VARCHAR(20)

AS
BEGIN

  UPDATE Fan 
SET fStatus = 0
WHERE nationalId = @nationalId

END
GO

CREATE PROCEDURE clearAllTables
AS
BEGIN

DELETE FROM TicketFan
DELETE FROM Ticket
DELETE FROM ClubStadiumRequest
DELETE FROM Match
DELETE FROM Fan
DELETE FROM SystemAdmin
DELETE FROM AssociationManager
DELETE FROM ClubRepresentative
DELETE FROM StadiumManager
DELETE FROM Stadium
DELETE FROM Club
DELETE FROM SystemUser

END
GO

CREATE PROCEDURE deleteClub
  @clubName VARCHAR(20)

AS
BEGIN

  DELETE C FROM Club C 
WHERE C.cName = @clubName

END
GO

CREATE PROCEDURE deleteMatch
  @hostClubName VARCHAR(20),
  @guestClubName VARCHAR(20),
  @startTime DATETIME,
  @endTime DATETIME
AS
BEGIN

  DELETE M FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId
WHERE C1.cName = @hostClubName AND C2.cName = @guestClubName AND M.startTime = @startTime AND M.endTime = @endTime

END
GO

CREATE PROCEDURE deleteMatchesOnStadium
  @stadiumName VARCHAR(20)

AS
BEGIN

  DELETE M 
FROM Match M INNER JOIN Stadium S ON M.stadiumId = S.stId
WHERE S.stName = @stadiumName AND M.startTime > GETDATE()

END
GO

CREATE PROCEDURE deleteStadium
  @stadiumName VARCHAR(20)

AS
BEGIN

  DELETE S FROM Stadium S
WHERE S.stName = @stadiumName

END
GO

CREATE PROCEDURE dropAllProceduresFunctionsViews
AS
BEGIN

BEGIN
DROP PROCEDURE acceptRequest
DROP PROCEDURE addAssociationManager
DROP PROCEDURE addClub
DROP PROCEDURE addFan
DROP PROCEDURE addHostRequest
DROP PROCEDURE addNewMatch
DROP PROCEDURE addRepresentative
DROP PROCEDURE addStadium
DROP PROCEDURE addStadiumManager
DROP PROCEDURE addTicket
DROP PROCEDURE blockFan
DROP PROCEDURE clearAllTables
DROP PROCEDURE createAllTables
DROP PROCEDURE deleteClub
DROP PROCEDURE deleteMatch
DROP PROCEDURE deleteMatchesOnStadium
DROP PROCEDURE deleteStadium
DROP PROCEDURE dropAllTables
DROP PROCEDURE purchaseTicket
DROP PROCEDURE rejectRequest
DROP PROCEDURE unblockFan
DROP PROCEDURE updateMatchHost
END

BEGIN
DROP VIEW allAssocManagers
DROP VIEW allClubRepresentatives
DROP VIEW allClubs
DROP VIEW allFans
DROP VIEW allMatches
DROP VIEW allRequests
DROP VIEW allStadiumManagers
DROP VIEW allStadiums
DROP VIEW allTickets
DROP VIEW clubsNeverMatched
DROP VIEW clubsWithNoMatches
DROP VIEW matchesPerTeam
END

BEGIN
DROP FUNCTION allPendingRequests
DROP FUNCTION allUnassignedMatches
DROP FUNCTION availableMatchesToAttend
DROP FUNCTION clubsNeverPlayed
DROP FUNCTION matchesRankedByAttendance
DROP FUNCTION matchWithHighestAttendance
DROP FUNCTION requestsFromClub
DROP FUNCTION upcomingMatchesOfClub
DROP FUNCTION viewAvailableStadiumsOn
DROP FUNCTION allRequestsForManager
DROP FUNCTION loginClubRep
DROP FUNCTION loginAssocMan
DROP FUNCTION loginStadiumMan
DROP FUNCTION loginFan
END

END
GO

CREATE PROCEDURE dropAllTables
AS
BEGIN

DROP TABLE TicketFan
DROP TABLE Ticket
DROP TABLE ClubStadiumRequest
DROP TABLE Match
DROP TABLE Fan
DROP TABLE SystemAdmin
DROP TABLE AssociationManager
DROP TABLE ClubRepresentative
DROP TABLE StadiumManager
DROP TABLE Stadium
DROP TABLE Club
DROP TABLE SystemUser

END
GO

CREATE PROCEDURE purchaseTicket
  @national_id varchar(20),
  @host_club VARCHAR(20),
  @guest_club varchar(20),
  @start_time DATETIME

AS
BEGIN

  DECLARE @matchId INT
  SET @matchId
 =(
SELECT TOP 1 m.mId
  FROM match m
    INNER JOIN Ticket T
    ON T.matchId = m.mId
    INNER JOIN Club c1
    ON c1.cId = m.hostClubId
    INNER JOIN Club c2
    ON c2.cId = m.guestClubId
  WHERE c1.cName = @host_club AND c2.cName = @guest_club AND m.startTime = @start_time
  )

  DECLARE @ticketId int
  SET @ticketId = (
 SELECT TOP 1 T.tId
  from Ticket T
  WHERE T.matchid = @matchId AND T.tStatus = 1
  )

  IF (@ticketId IS NOT NULL)
    BEGIN
    
  INSERT INTO TicketFan
  VALUES(@national_id , @ticketId)

  UPDATE Ticket 
  SET 
  availableCount = availableCount - 1,
  tStatus = CASE WHEN availableCount = 0 THEN 0
  END
WHERE tId = @ticketId
END

END
GO

CREATE PROCEDURE rejectRequest
  @stadiumManagerUsername VARCHAR(20),
  @hostClubName VARCHAR(20),
  @guestClubName VARCHAR(20),
  @startTime DATETIME

AS
BEGIN

  UPDATE CSR
SET CSR.csrStatus = 'rejected'
FROM ClubStadiumRequest CSR
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId
    INNER JOIN Match M ON CSR.matchId = M.mId
    INNER JOIN Club C1 ON M.hostClubId = C1.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
  WHERE SM.username = @stadiumManagerUsername
    AND C1.cName = @hostClubName
    AND C2.cName = @guestClubName
    AND M.startTime = @startTime

END
GO

CREATE PROCEDURE unblockFan
  @nationalId VARCHAR(20)

AS
BEGIN

  UPDATE Fan 
SET fStatus = 1
WHERE nationalId = @nationalId

END
GO

CREATE PROCEDURE  updateMatchHost
@clubName VARCHAR(20),
@guestName VARCHAR(20),
@startTime datetime

AS
BEGIN

DECLARE @temp int
set @temp = (
SELECT C.cId 
FROM Club C 
WHERE C.cName = @clubName
 )

DECLARE @temp2 int 
set @temp2 = (
SELECT C.cId 
FROM Club C 
WHERE C.cName = @guestName
 )

UPDATE Match 
SET 
hostClubId = @temp2,
guestClubId = @temp
WHERE hostClubId = @temp AND guestClubId = @temp2 AND startTime = @startTime 

END
GO

-- FUNCTIONS

CREATE FUNCTION loginClubRep(
  @username VARCHAR(20),
  @password VARCHAR(20)
)
RETURNS @result TABLE(
  cRName VARCHAR(20),
  cNAME VARCHAR(20)
)
AS
BEGIN
INSERT INTO @result
SELECT CR.crName, C.cName
FROM Club C INNER JOIN ClubRepresentative CR ON CR.clubId = C.cId
INNER JOIN SystemUser SU ON  SU.username = CR.username
WHERE CR.username = @username AND SU.suPassword = @password

RETURN
END
GO

CREATE FUNCTION loginStadiumMan(
  @username VARCHAR(20),
  @password VARCHAR(20)
)
RETURNS @result TABLE(
  cRName VARCHAR(20),
  cNAME VARCHAR(20)
)
AS
BEGIN
INSERT INTO @result
SELECT SM.smName, S.stName
FROM STADIUM S INNER JOIN StadiumManager SM ON SM.stadiumId = S.stId
INNER JOIN SystemUser SU ON  SU.username = SM.username
WHERE SM.username = @username AND SU.suPassword = @password

RETURN
END
GO

CREATE FUNCTION loginAssocMan(
  @username VARCHAR(20),
  @password VARCHAR(20)
)
RETURNS @result TABLE(
  cRName VARCHAR(20)
)
AS
BEGIN
INSERT INTO @result
SELECT AM.amName
FROM AssociationManager AM 
INNER JOIN SystemUser SU ON  SU.username = AM.username
WHERE AM.username = @username AND SU.suPassword = @password

RETURN
END
GO

CREATE FUNCTION loginFan(
  @username VARCHAR(20),
  @password VARCHAR(20)
)
RETURNS @result TABLE(
  cRName VARCHAR(20),
  nationalId VARCHAR(20)
)
AS
BEGIN
INSERT INTO @result
SELECT F.fName, F.nationalId
FROM Fan F
INNER JOIN SystemUser SU ON  SU.username = F.username
WHERE f.username = @username AND SU.suPassword = @password

RETURN
END
GO

CREATE FUNCTION allRequestsForManager
(@stadiumManagerUsername VARCHAR(20))
RETURNS @result TABLE (
  clubRepresenatativeName VARCHAR(20),
  hostClubName VARCHAR(20),
  gustClubName VARCHAR(20),
  startTime DATETIME,
  endTime DATETIME,
  requestStatus VARCHAR(20)
)

AS
BEGIN

  INSERT INTO @result
  SELECT CR.crname AS ClubRepresntativeName, C.cName AS HostClubName, C2.cName AS guestClubName, M.startTime, M.endTime, CSR.csrStatus
  FROM ClubStadiumRequest CSR INNER JOIN ClubRepresentative CR ON CSR.clubRepresentativeId = CR.crId
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId
    INNER JOIN Match M ON M.mId = CSR.matchId
    INNER JOIN Club C ON M.hostClubId = C.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
  WHERE SM.username = @stadiumManagerUsername

  RETURN
END
GO

CREATE FUNCTION allPendingRequests
(@stadiumManagerUsername VARCHAR(20))
RETURNS @result TABLE (
  clubRepresenatativeName VARCHAR(20),
  gustClubName VARCHAR(20),
  startTime DATETIME
)

AS
BEGIN

  INSERT INTO @result
  SELECT CR.crname AS ClubRepresntativeName, C.cName AS guestClubName, M.startTime
  FROM ClubStadiumRequest CSR INNER JOIN ClubRepresentative CR ON CSR.clubRepresentativeId = CR.crId
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId
    INNER JOIN Match M ON M.mId = CSR.matchId
    INNER JOIN Club C ON C.clubRepresentativeId = CR.crId
  WHERE CSR.csrStatus = 'unhandled' AND SM.username = @stadiumManagerUsername

  RETURN
END
GO

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
GO

CREATE FUNCTION availableMatchesToAttend
(@date_time DATETIME)
RETURNS @availableMatchesToAttend
table(club_name VARCHAR(20),
  guest_club VARCHAR(20) ,
  start_time DATETIME ,
  stadium_hosting VARCHAR(20)
)
AS
BEGIN

  INSERT into @availableMatchesToAttend
  SELECT c1.cName as host, c2.cName as guest, m.startTime, s.stName
  FROM Ticket T
    INNER JOIN match m
    ON T.matchId = m.mId
    INNER JOIN Club c1
    ON c1.cId = m.hostClubId
    INNER JOIN Club c2
    ON c2.cId = m.guestClubId
    INNER JOIN stadium s
    ON s.stId = m.stadiumId
  WHERE t.tStatus = 1 AND m.startTime > @date_time

  RETURN

END
GO

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
GO

CREATE FUNCTION matchesRankedByAttendance()
RETURNS @RankedByAttendance TABLE(HOST_club VARCHAR(20),GUEST_club VARCHAR(20))

AS 
BEGIN

INSERT INTO @RankedByAttendance
 SELECT C1.cName AS Host , C2.cName AS Guest
 FROM Match M INNER JOIN Club C1 ON C1.cId = M.hostClubId
 INNER JOIN Club C2 ON C2.cId = M.guestClubId
 INNER JOIN Ticket T ON T.matchId = M.mId
 INNER JOIN TicketFan TF ON TF.tId = T.tId
    GROUP BY C1.cName, C2.cName
  ORDER BY COUNT(TF.tId) DESC

 RETURN

END
GO

CREATE FUNCTION matchWithHighestAttendance()
RETURNS @HighestAttendance TABLE(HOST_club VARCHAR(20),GUEST_club VARCHAR(20))

AS
BEGIN

INSERT INTO @HighestAttendance
 SELECT TOP(1) C1.cName AS Host , C2.cname AS Guest
 FROM Match M INNER JOIN Club C1 ON C1.cId = M.hostClubId
 INNER JOIN Club C2 ON C2.cId = M.guestClubId
 INNER JOIN Ticket T ON T.matchId = M.mId
 INNER JOIN TicketFan TF ON TF.tId = T.tId
     GROUP BY C1.cName, C2.cName
  ORDER BY COUNT(TF.tId) DESC

  RETURN

END
GO

CREATE FUNCTION requestsFromClub
(@stadiumName VARCHAR(20), @clubName VARCHAR(20))
RETURNS @result TABLE (hostName VARCHAR(20) ,guestName VARCHAR(20))

AS
BEGIN

  DECLARE @representativeId INT
  SET @representativeId
  = (
    SELECT TOP 1 CR.crId
  FROM ClubRepresentative CR INNER JOIN Club C ON CR.clubId = C.cId
  WHERE C.cName = @clubName
  )

    DECLARE @stadiumManagerId INT
  SET @stadiumManagerId
  = (
    SELECT TOP 1 SM.smId
  FROM StadiumManager SM INNER JOIN Stadium S ON SM.stadiumId = S.stId
  WHERE S.stName = @stadiumName
  )

INSERT INTO @result
SELECT C1.cName AS Host, C2.cName AS Guest
FROM ClubStadiumRequest CSR 
INNER JOIN Match M ON CSR.matchId = M.mId
INNER JOIN Club C1 on M.hostClubId = C1.cName
INNER JOIN Club C2 on M.guestClubId = C2.cName
WHERE CSR.clubRepresentativeId = @representativeId AND CSR.stadiumManagerId = @stadiumManagerId

RETURN
END
GO

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
    LEFT OUTER JOIN Stadium S ON S.stId = M.stadiumId
  WHERE  C1.cName = @clubName OR  C2.cName = @clubName

  RETURN 
END
GO

CREATE FUNCTION viewAvailableStadiumsOn
(@date DATETIME)
RETURNS @result TABLE (stadiumName VARCHAR(20),
  lstadiumLocation VARCHAR(20),
  stadiumCapacity VARCHAR(20))

AS
BEGIN

  INSERT INTO @result
  SELECT S.stName, S.stLocation, S.stCapacity
  FROM Stadium S
  WHERE S.stStatus = 1 AND S.stId NOT IN (
    SELECT M.stadiumId
    FROM MATCH M
    WHERE M.startTime = @date
  )
  RETURN

END
GO

-- VIEWS

CREATE VIEW allAssocManagers
AS
  SELECT AM.username AS username, AM.amName AS AssocManagerName, SU.suPassword AS AssocManagerPass
  FROM AssociationManager AM INNER JOIN SystemUser SU ON AM.username = SU.username
GO

CREATE VIEW allClubRepresentatives
AS
  SELECT CR.username AS RepUsername, CR.crName AS repName, SU.suPassword AS repPass, C.cName AS ClubName
  FROM ClubRepresentative CR INNER JOIN SystemUser SU ON CR.username = SU.username INNER JOIN Club C ON C.cId = CR.clubId
GO

CREATE VIEW allClubs
AS
  Select C.cName AS ClubName, C.cLocation AS ClubLocation
  From Club C
GO

CREATE VIEW allFans
AS
  SELECT F.username AS FanUsername, F.fName AS fanName, SU.suPassword AS fanPass, F.nationalId AS fanNationalId, F.birthDate AS fanBirthDate, F.fStatus AS fanStatus
  FROM Fan F INNER JOIN SystemUser SU ON F.username = SU.username
GO

CREATE VIEW allMatches
AS
  SELECT C1.cName AS Host, C2.cName AS Guest, M.startTime AS startTime
  FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId
GO

CREATE VIEW allRequests
AS
  SELECT CR.username AS ClubRepresntative, SM.username AS StadiumManager, CSR.csrStatus
  FROM ClubStadiumRequest CSR INNER JOIN ClubRepresentative CR ON CSR.clubRepresentativeId = CR.crId
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId
GO

CREATE VIEW allStadiumManagers
AS
  SELECT SM.username, SM.smName, SU.suPassword, S.stName
  FROM StadiumManager SM INNER JOIN SystemUser SU ON SM.username = SU.username INNER JOIN Stadium S ON S.stId = SM.stadiumId
GO

CREATE VIEW allStadiums
AS
  SELECT S.stName, S.stLocation, S.stCapacity, S.stStatus
  FROM Stadium S
GO

CREATE VIEW allTickets
AS
  SELECT C1.cName AS Host, C2.cName AS Guest, S.stName AS StadiumName, M.startTime AS startTime
  FROM Ticket T INNER JOIN Match M ON T.matchId = M.mId
    INNER JOIN Club C1 ON M.hostClubId = C1.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
    INNER JOIN Stadium S ON M.stadiumId = S.stId
GO

CREATE VIEW clubsNeverMatched AS
SELECT C1.cName AS Host, C2.cName AS Guest
FROM Club C1, Club C2
WHERE NOT EXISTS (SELECT * FROM Match M INNER JOIN Club C3 on M.hostClubId = C3.cId
    INNER JOIN Club C4 on M.guestClubId = C4.cId WHERE C3.cId = C1.cId AND C4.cId = C2.cId)
    AND NOT EXISTS (SELECT * FROM Match M2 INNER JOIN Club C5 on M2.guestClubId = C5.cId
    INNER JOIN Club C6 on M2.hostClubId = C6.cId WHERE C5.cId = C1.cId AND C6.cId = C2.cId)
GO

CREATE VIEW clubsWithNoMatches
AS
  SELECT C.cName
  FROM Club C, allMatches M
  WHERE C.cName <> M.Host AND C.cName <> M.Guest
GO

CREATE VIEW matchesPerTeam AS
Select C.cName, COUNT(M1.mId) + COUNT(M2.mId) AS numberOfMatches
FROM Club C 
INNER JOIN Match M1 on M1.hostClubId = C.cId
INNER JOIN Match M2 on M2.guestClubId = C.cId
GROUP BY C.cName
GO