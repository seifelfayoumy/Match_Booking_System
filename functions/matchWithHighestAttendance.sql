CREATE FUNCTION matchWithHighestAttendance()
RETURNS @HighestAttendance TABLE(HOST_club VARCHAR(20),GUEST_club VARCHAR(20))

AS
BEGIN

INSERT INTO @RankedByAttendance
 SELECT TOP(1) C1.cName AS Host , C2.cname AS Guest
 FROM Match M INNER JOIN Club C1 ON C1.cId = M.hostClubId
 INNER JOIN Club C2 ON C2.cId = M.guestClubId
 INNER JOIN Ticket T ON T.matchId = M.mId
 INNER JOIN TicketFan TF ON TF.tId = T.tI
  ORDER BY COUNT(TF) DESC

  RETURN

END