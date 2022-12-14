CREATE PROCEDURE addClub
  @clubName VARCHAR(20),
  @clubLocation VARCHAR(20)

AS
BEGIN

  INSERT INTO Club
  VALUES(@clubName, @clubLocation)
END