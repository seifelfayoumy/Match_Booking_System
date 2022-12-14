CREATE VIEW clubsWithNoMatches
AS
  SELECT C.cName
  FROM Club C, allMatches M
  WHERE C.cName <> M.Host AND C.cName <> M.Guest