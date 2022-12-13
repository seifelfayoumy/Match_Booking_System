CREATE PROCEDURE createAllTables
AS

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
  stStatus VARCHAR(20),
  createdBy INT,
  PRIMARY KEY (stId),
  FOREIGN KEY (createdBy) REFERENCES SystemAdmin
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
  birthDate date,
  createdBy INT,
  blockedBy INT,
  fStatus BIT,
  PRIMARY KEY (nationalId),
  FOREIGN KEY (createdBy) REFERENCES SystemAdmin,
  FOREIGN KEY (blockedBy) REFERENCES SystemAdmin,
  FOREIGN KEY (username) REFERENCES SystemUser (username)
)

CREATE TABLE Match
(
  mId INT IDENTITY,
  startTime DATE,
  endTime Date,
  allowedAttendees INT,
  stadiumId INT,
  hostClubId INT,
  secondClubId INT,
  createdBy INT,
  editedBy INT,
  PRIMARY KEY (mId),
  FOREIGN KEY (stadiumId) REFERENCES Stadium,
  FOREIGN KEY (hostClubId) REFERENCES Club,
  FOREIGN KEY (secondClubId) REFERENCES Club,
  FOREIGN KEY (createdBy) REFERENCES AssociationManager,
  FOREIGN KEY (editebBy) REFERENCES AssociationManager,

)

create table ClubStadiumRequest
(

  csrId INT IDENTITY,
  clubRepresentativeId INT,
  smId INT,
  csrStatus VARCHAR(20),
  PRIMARY KEY (csrId),
  FOREIGN KEY (clubRepresentativeId) REFERENCES ClubRepresentative,
  FOREIGN KEY (smId) REFERENCES StadiumManger

)

CREATE TABLE Ticket
(
  tId INT IDENTITY,
  matchId INT,
  tStatus VARCHAR(20),
  PRIMARY KEY (tId),
  FOREIGN KEY (matchId) REFERENCES Match,
  FOREIGN KEY (fanId) REFERENCES Fan
)

CREATE TABLE TicketFan
(
  tfId INT IDENTITY,
  fId INT,
  tId INT,
  PRIMARY KEY (tfId),
  FOREIGN KEY (fId) REFERENCES Fan,
  FOREIGN KEY (tId) REFERENCES Ticket
)

