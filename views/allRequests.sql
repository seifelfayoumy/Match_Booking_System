CREATE VIEW allRequests
AS
  SELECT CR.username AS ClubRepresntative, SM.usernmae AS StadiumManager, CSR.csrStatus
  FROM ClubStadiumRequest CSR INNER JOIN ClubRepresentative CR ON CSR.clubRepresentativeId = CR.crId
    INNER JOIN StadiumManager SM ON CSR.stadiumManagerId = SM.smId