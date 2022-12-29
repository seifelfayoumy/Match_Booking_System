CREATE PROCEDURE addStadiumManager
  @stadiumManagerName VARCHAR(20),
  @stadiumName VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20)

AS
BEGIN


  DECLARE @stadiumId INT
  SET @stadiumId = (SELECT TOP 1 S.stId
  FROM Stadium S
  WHERE S.stName = @stadiumName)

  INSERT INTO SystemUser
  VALUES(@username, @password)

  INSERT INTO StadiumManager
  VALUES(@stadiumManagerName, @username, @stadiumId)

END
