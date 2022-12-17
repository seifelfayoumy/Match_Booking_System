CREATE PROCEDURE  updateMatchHost
@clubName VARCHAR(20),
@guestName VARCHAR(20),
@startTime datetime

AS
BEGIN

DECLARE @temp int
set @temp = (
SELECT C.cId 
FROM Club C 
WHERE C.cName = @clubName
 )

DECLARE @temp2 int 
set @temp2 = (
SELECT C.cId 
FROM Club C 
WHERE C.cName = @guestName
 )

UPDATE Match 
SET 
hostClubId = @temp2,
guestClubId = @temp
WHERE hostClubId = @temp AND guestClubId = @temp2 AND startTime = @startTime 

END