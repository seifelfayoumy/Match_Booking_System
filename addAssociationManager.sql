CREATE PROCEDURE addAssociationManager
  @name VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20)
AS
INSERT INTO SystemUser
VALUES(@username, @password)
Insert into AssociationManger
VALUES(@name, @username)