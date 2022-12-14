CREATE PROCEDURE deleteMatchesOnStadium
  @stadiumName VARCHAR(20)

AS
BEGIN

  DELETE M 
FROM Match M INNER JOIN Stadium S ON M.stadiumId = S.stId
WHERE S.stName = @stadiumName AND M.startTime > GETDATE()

END