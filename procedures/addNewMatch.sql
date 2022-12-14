CREATE PROCEDURE addNewMatch
  @hostClub varchar(20),
  @guestClub varchar(20),
  @startTime DATETIME,
  @endTime DATETIME
AS
Insert into Match
VALUES(@startTime, @endTime, @hostClub, @guestClub)