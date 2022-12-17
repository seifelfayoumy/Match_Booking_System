CREATE VIEW matchesPerTeam AS
Select C.cName, COUNT(M1) + COUNT(M2) AS numberOfMatches
FROM Club C 
INNER JOIN Match M1 on M1.hostClubId = C.cId
INNER JOIN Match M2 on M2.guestClubId = C.cId
GROUP BY C.cName