CREATE PROCEDURE addRepresentative
  @representativeName VARCHAR(20),
  @clubName VARCHAR(20),
  @representativeUsername VARCHAR(20),
  @representativePassword VARCHAR(20)

AS
BEGIN

  DECLARE @clubId INT
  SET @clubId = (SELECT TOP 1 C.cId
  FROM Club C
  WHERE C.cName = @clubName)

  INSERT INTO SystemUser
  VALUES(@representativeUsername, @representativePassword)

  INSERT INTO ClubRepresentative
  VALUES(@representativeName, @representativeUsername, @clubId)

END