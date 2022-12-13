CREATE VIEW allAssocManagers
AS
  SELECT AM.username, AM.amName, AU.suPassword
  FROM AssociationManager AM INNER JOIN SystemUser SU ON AM.username = SU.username