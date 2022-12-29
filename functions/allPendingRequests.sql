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