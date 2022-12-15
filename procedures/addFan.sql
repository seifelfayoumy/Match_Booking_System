CREATE PROCEDURE addFan
  @name VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20),
  @nationalId VARCHAR(20),
  @birthDate DATE,
  @address VARCHAR(20),
  @phoneNumber VARCHAR(20)

AS
BEGIN

  INSERT INTO SystemUser
  VALUES(@username, @password)

  INSERT INTO Fan
  VALUES(@nationalId, @name, @username, @phoneNumber, @address, @birthDate, 1)

END