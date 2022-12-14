CREATE VIEW allStadiumManagers
AS
  SELECT SM.username, SM.smName, AU.suPassword, S.stName
  FROM StadiumManager SM INNER JOIN SystemUser SU ON SM.username = SU.username INNER JOIN Stadium S ON S.stId = SM.stadiumId
