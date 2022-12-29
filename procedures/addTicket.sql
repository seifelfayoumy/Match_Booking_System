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