exec createAllTables

exec addFan 'seif amr' ,'seif', 'password', 'ewdwed32232', '2008-11-11', 'nasr city', 12300
exec addNewMatch 

exec addClub 'Club1', 'nasr city'
exec addClub 'Club2', 'tagamo3'
exec addClub 'Club3', 'tagamo3'
exec addClub 'Club4', 'tagamo3'
exec addClub 'Club5', 'tagamo3'
exec addClub 'Club6', 'tagamo3'
exec addClub 'Club7', 'tagamo3'
exec addClub 'Club8', 'tagamo3'

exec addClub 'club10', 'tagamo3'

exec addNewMatch 'club10', 'Club2', '2024/12/3',  '2025/12/3'

SELECT * FROM allFans
SELECT * from allMatches
SELECT * FROM allClubs
SELECT * FROM allClubRepresentatives
SELECT * FROM SystemUser

SELECT * FROM allClubs WHERE cName = 'club10'
SELECT * FROM [dbo].upcomingMatchesOfClub('club10')
SELECT * FROM allUnassignedMatches('club10')
EXEC upcomingMatchesOfClub 'club10'
SELECT * FROM allMatches