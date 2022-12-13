CREATE VIEW allStadiums
AS
  Select S.stName, S.stLocation, S.stCapacity, S.stStatus
  From Stadium S
