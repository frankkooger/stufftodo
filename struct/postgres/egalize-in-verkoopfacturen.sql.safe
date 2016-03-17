
-- --------------------- INKOOPFACTUREN ---------------------- --

SELECT
  ID
  ,datum
  ,factuurbedrag
  ,voldaan
  ,betaaldatum
FROM
  InkoopfacturenX
WHERE
  datum >= '20130101'
AND datum < '20140101'
AND voldaan = 0.00

-- DROP TABLE InkoopfacturenX
-- SELECT * INTO InkoopfacturenX FROM Inkoopfacturen
/*
UPDATE
  Inkoopfacturen
SET
  voldaan=X.factuurbedrag
  ,betaaldatum=X.datum
FROM
  Inkoopfacturen As X
WHERE
  Inkoopfacturen.ID = X.ID
AND X.datum >= '20130101'
AND X.datum < '20140101'
AND X.voldaan = 0.00
*/  

-- --------------------- VERKOOPFACTUREN ---------------------- --

SELECT
  ID
  ,datum
  ,factuurbedrag
  ,voldaan
  ,betaaldatum
FROM
  VerkoopfacturenX
WHERE
  datum >= '20130101'
AND datum < '20140101'
AND voldaan = 0.00

-- DROP TABLE VerkoopfacturenX
-- SELECT * INTO VerkoopfacturenX FROM Verkoopfacturen
/*
UPDATE
  Verkoopfacturen
SET
  voldaan=X.factuurbedrag
  ,betaaldatum=X.datum
FROM
  Verkoopfacturen As X
WHERE
  Verkoopfacturen.ID = X.ID
AND X.datum >= '20130101'
AND X.datum < '20140101'
AND X.voldaan = 0.00
*/  

