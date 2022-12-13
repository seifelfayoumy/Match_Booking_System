CREATE VIEW allFans
AS
  SELECT F.username, F.fName, AU.suPassword, F.nationalId, F.birthDate, F.fStatus
  FROM Fan F INNER JOIN SystemUser SU ON F.username = SU.username