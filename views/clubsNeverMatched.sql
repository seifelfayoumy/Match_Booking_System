CREATE VIEW clubsNeverMatched AS
SELECT C1.cName, C2.cName
FROM Club C1, Club C2
WHERE NOT EXISTS (SELECT * FROM Match M INNER JOIN C1 on M.hostClubId = C1.cId
    INNER JOIN C2 on M.guestClubId = C2.cId) AND NOT EXISTS (SELECT * FROM Match M1 INNER JOIN C1 on M1.guestClubId = C1.cId
    INNER JOIN C2 on M1.hostClubId = C2.cId)
    