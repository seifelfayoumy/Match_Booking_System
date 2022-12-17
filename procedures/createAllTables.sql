CREATE PROCEDURE createAllTables
AS

BEGIN
  CREATE TABLE SystemUser
  (
    username VARCHAR(20),
    suPassword VARCHAR(20),
    PRIMARY KEY (username)
  )

  CREATE TABLE Club
  (
    cId INT IDENTITY,
    cName VARCHAR(20),
    cLocation VARCHAR(20),
    PRIMARY KEY (cId)
  )

  CREATE TABLE Stadium
  (
    stId INT IDENTITY,
    stName VARCHAR(20),
    stCapacity INT,
    stLocation VARCHAR(20),
    stStatus BIT,
    PRIMARY KEY (stId),
  )

  CREATE TABLE StadiumManager
  (
    smId INT IDENTITY,
    smName VARCHAR(20),
    username VARCHAR(20),
    stadiumId INT,
    PRIMARY KEY (smId),
    FOREIGN KEY (stadiumId) REFERENCES Stadium,
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE ClubRepresentative
  (

    crId INT IDENTITY primary KEY,
    crName VARCHAR(20),
    username VARCHAR(20),
    clubId INT,
    FOREIGN KEY (clubId) REFERENCES Club,
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE AssociationManager
  (
    amId INT IDENTITY,
    amName VARCHAR(20),
    username VARCHAR(20),
    PRIMARY KEY (amId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE SystemAdmin
  (
    saId INT IDENTITY,
    saName VARCHAR(20),
    username VARCHAR(20),
    PRIMARY KEY (saId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE Fan
  (
    nationalId VARCHAR(20),
    fName VARCHAR(20),
    username VARCHAR(20),
    phoneNumber INT,
    fAddress VARCHAR(20),
    birthDate DATE,
    fStatus BIT,
    PRIMARY KEY (nationalId),
    FOREIGN KEY (username) REFERENCES SystemUser (username)
  )

  CREATE TABLE Match
  (
    mId INT IDENTITY,
    startTime DATETIME,
    endTime DATETIME,
    hostClubId INT,
    guestClubId INT,
    allowedAttendees INT,
    stadiumId INT,
    PRIMARY KEY (mId),
    FOREIGN KEY (stadiumId) REFERENCES Stadium,
    FOREIGN KEY (hostClubId) REFERENCES Club,
    FOREIGN KEY (guestClubId) REFERENCES Club,

  )

  create table ClubStadiumRequest
  (

    csrId INT IDENTITY,
    clubRepresentativeId INT,
    stadiumManagerId INT,
    matchId INT,
    csrStatus VARCHAR(20),
    PRIMARY KEY (csrId),
    FOREIGN KEY (clubRepresentativeId) REFERENCES ClubRepresentative,
    FOREIGN KEY (stadiumManagerId) REFERENCES StadiumManager,
    FOREIGN KEY (matchId) REFERENCES MATCH

  )

  CREATE TABLE Ticket
  (
    tId INT IDENTITY,
    matchId INT,
    tStatus BIT,
    availableCount INT,
    PRIMARY KEY (tId),
    FOREIGN KEY (matchId) REFERENCES Match,
  )

  CREATE TABLE TicketFan
  (
    tfId INT IDENTITY,
    fId VARCHAR(20),
    tId INT,
    PRIMARY KEY (tfId),
    FOREIGN KEY (fId) REFERENCES Fan,
    FOREIGN KEY (tId) REFERENCES Ticket
  )

END