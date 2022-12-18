CREATE PROCEDURE addAssociationManager
  @name VARCHAR(20),
  @username VARCHAR(20),
  @password VARCHAR(20)
AS
BEGIN

INSERT INTO SystemUser
VALUES(@username, @password)
Insert into AssociationManager
VALUES(@name, @username)

END