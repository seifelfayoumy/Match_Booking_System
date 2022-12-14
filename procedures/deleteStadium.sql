CREATE PROCEDURE deleteStadium
  @stadiumName VARCHAR(20)

AS
BEGIN

  DELETE S FROM Stadium S
WHERE S.stName = @stadiumName

END