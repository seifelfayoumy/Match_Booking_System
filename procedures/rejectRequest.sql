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