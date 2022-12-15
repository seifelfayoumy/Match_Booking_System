CREATE FUNCTION viewAvailableStadiumsOn
(@date DATETIME)
RETURNS @result TABLE (stadiumName VARCHAR(20),
  lstadiumLocation VARCHAR(20),
  stadiumCapacity VARCHAR(20))

AS
BEGIN

  INSERT INTO @result
  SELECT S.stName, S.stLocation, S.stCapacity
  FROM Stadium S
  WHERE S.sStatus = 1 AND S.stId NOT IN (
    SELECT M.stadiumId
    FROM MATCH M
    WHERE M.startTime = @date
  )
  RETURN

END