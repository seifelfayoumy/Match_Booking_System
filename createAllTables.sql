CREATE PROCEDURE createAllTables
AS
CREATE TABLE Stadium
(
  id INT IDENTITY,
  name VARCHAR(20),
  capacity INT,
  location VARCHAR(20),
  status VARCHAR(20),
  createdBy INT,
  PRIMARY KEY (id),
  FOREIGN KEY (createdBy) REFERENCES SystemAdmin
)
CREATE TABLE Match
(
  id INT IDENTITY,
  startTime DATE,
  endTime Date,
  allowedAttendees INT,
  stadiumId INT,
  hostClubId INT,
  secondClubId INT,
  createdBy INT,
  editedBy INT,
  PRIMARY KEY (id),
  FOREIGN KEY (stadiumId) REFERENCES Stadium,
  FOREIGN KEY (hostClubId) REFERENCES Club,
  FOREIGN KEY (secondClubId) REFERENCES Club,
  FOREIGN KEY (createdBy) REFERENCES AssociationManager,
  FOREIGN KEY (editebBy) REFERENCES AssociationManager,

)
CREATE TABLE StadiumManager
(
  id INT IDENTITY,
  name VARCHAR(20),
  username VARCHAR(20),
  password VARCHAR(20),
  stadiumId INT,
  PRIMARY KEY (id),
  FOREIGN KEY (stadiumId) REFERENCES Stadium
)
CREATE TABLE SystemAdmin
(
  id INT IDENTITY,
  name VARCHAR(20),
  username VARCHAR(20),
  password VARCHAR(20),
  PRIMARY KEY (id)
)
CREATE TABLE AssociationManager
(
  id INT IDENTITY,
  name VARCHAR(20),
  username VARCHAR(20),
  password VARCHAR(20),
  PRIMARY KEY (id)
)
CREATE TABLE ClubrRpresentitive
(

  id int IDENTITY primary key,
  CRname varchar(20),
  username varchar(20),
  CRpassword varchar(20),
  clubid int FOREIGN key REFERENCES Club
)

create table ClubStadiumRequest
(

  id int IDENTITY PRIMARY KEY,
  ClubRepresentitiveId int FOREIGN key REFERENCES ClubrRpresentitive,
  ManagerStadiumId int FOREIGN key REFERENCES StadiumManger,
  CRStatus varchar(20)
)
CREATE TABLE Ticket
(
  id INT IDENTITY PRIMARY KEY,
  sadiumId INT FOREIGN KEY REFERENCES Stadium,
  fanId INT FOREIGN KEY REFERENCES  Fan,
  Tstatus VARCHAR(20),
)
CREATE TABLE Fan
(

  id int IDENTITY PRIMARY key,
  Fname VARCHAR(20),
  username VARCHAR(20),
  Fpassword varchar(20),
  nationalId int,
  phoneNumber int,
  Faddress varchar(20),
  birthDate date,
  createdBy int FOREIGN KEY REFERENCES SystemAdmin,
  blockedBy int fOREIGN KEY REFERENCES SystemAdmin,
  isBlocked int
)