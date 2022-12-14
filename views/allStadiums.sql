CREATE VIEW allStadiums
AS
  SELECT S.stName, S.stLocation, S.stCapacity, S.stStatus
  FROM Stadium S
