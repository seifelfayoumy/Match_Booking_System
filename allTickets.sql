CREATE VIEW allTickets
AS
  SELECT MATCH.FIRSTCLUB, match.sendondclub, stradium.name
  FROM Ticket INNER JOIN Match ON Ticket.MatchId = Match.id INNER JOIN Stadium ON MATCH.STADIUMID = STADOUM.ID