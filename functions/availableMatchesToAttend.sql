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