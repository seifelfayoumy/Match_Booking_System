CREATE VIEW allClubRepresentatives
AS
  SELECT CR.username, CR.crName, AU.suPassword, C.cName
  FROM ClubRepresentative CR INNER JOIN SystemUser SU ON CR.username = SU.username INNER JOIN Club C ON Club.cId = CR.clubId