CREATE VIEW allMatches
AS
  SELECT C1.cName AS Host, C2.cName AS Guest, M.startTime
  FROM Match M INNER JOIN Club C1 on M.hostClubId = C1.cId
    INNER JOIN Club C2 on M.guestClubId = C2.cId