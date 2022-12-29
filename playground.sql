exec createAllTables

exec addFan 'seif amr' ,'seif', 'password', 'ewdwed32232', '2008-11-11', 'nasr city', 12300
exec addNewMatch 

exec addClub 'club1', 'nasr city'
exec addClub 'Club2', 'tagamo3'
exec addClub 'Club3', 'tagamo3'
exec addClub 'Club4', 'tagamo3'
exec addClub 'Club5', 'tagamo3'
exec addClub 'Club6', 'tagamo3'
exec addClub 'Club7', 'tagamo3'
exec addClub 'Club8', 'tagamo3'

exec addClub 'club10', 'tagamo3'

exec addNewMatch 'club10', 'club1', '2024/12/3',  '2025/12/3'
exec addNewMatch 'club10', 'Club1', '2024/12/3',  '2025/12/3'

exec addStadium 'stadium3', 'nasr city', 3000

SELECT * FROM allFans
SELECT * from allMatches
SELECT * FROM allClubs
SELECT * FROM allClubRepresentatives
SELECT * FROM allStadiumManagers
SELECT * FROM SystemUser

SELECT * FROM allClubs WHERE cName = 'club10'
SELECT * FROM [dbo].upcomingMatchesOfClub('club10')
SELECT * FROM allUnassignedMatches('club10')
EXEC upcomingMatchesOfClub 'club10'
SELECT * FROM allMatches
SELECT * FROM allStadiums
SELECT * FROM viewAvailableStadiumsOn('2023/2/2')

SELECT * FROM allRequests
SELECT * FROM ClubStadiumRequest

EXEC addHostRequest 'club10', 'stadium3', '2024/12/3'
SELECT * FROM allRequestsForManager('man')
SELECT * FROM allPendingRequests('man')

exec clearAllTables
EXEC dropAllTables
EXEC dropAllProceduresFunctionsViews

SELECT * FROM loginClubRep('repo', 'repo')

