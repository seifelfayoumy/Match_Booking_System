CREATE VIEW allTickets
AS
  SELECT C1.cName AS Host, C2.cName AS Guest, S.stName AS StadiumName, M.startTime
  FROM Ticket T INNER JOIN Match M ON Ticket.matchId = M.mId
    INNER JOIN Club C1 ON M.hostClubId = C1.cId
    INNER JOIN Club C2 ON M.guestClubId = C2.cId
    INNER JOIN Stadium S ON M.stadiumId = S.stId