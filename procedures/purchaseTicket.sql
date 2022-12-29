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