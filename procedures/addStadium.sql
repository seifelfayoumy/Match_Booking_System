CREATE PROCEDURE addStadium
  @stadiumName VARCHAR(20),
  @stadiumLocation VARCHAR(20),
  @stadiumCapacity INT

AS
BEGIN

  INSERT INTO Stadium
  VALUES(@stadiumName, @stadiumCapacity, @stadiumLocation, 1)

END