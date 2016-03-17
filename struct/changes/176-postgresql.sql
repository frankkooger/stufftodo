
-- ---------------------------------------
-- SQLVERSIE 1.7.6 <- 1.7.0
-- ---------------------------------------

-- 25 juli 2011
--
-- Onderstaande views vormen de input voor de vernieuwde BTW module in
-- openadmin.nl waarin we veel meer logic laten afhandelen door de database en
-- minder in de code.
-- Omdat mysql geen subqueries toelaat in een view moeten we met aparte
-- views per query werken en die in 1 query aggregeren
-- Voor onderstaande views komt dat wel goed uit omdat het de modulariteit
-- en de mogelijkheid om iets toe te voegen/ te veranderen ermee groter wordtn
--
-- De versie's voor sqlite, postgresql en mysql zijn gelijk, behalve dat in 
-- de mysql versie een kopregel voorkomt die standaard ANSI sql instelt.
-- De versie voor Firebird is licht anders: 
--   velddefinities in de declaratie van views waarin unions voorkomen
--   elke create view afgesloten met een COMMIT omdat die anders nog niet 
--   gezien wordt door een volgende view die afhankelijk is van een vorige.
--
-- In 1.7.6 is 'grootboekstamtemp' veranderd naar 'grootboekstam'
--
-- Bedenk dat voor type 'Signed' een Domain is opgenomen in alle databases.
-- Normaal wordt dit gekend als 'Integer' maar mysql kent 'Signed'
--

-- Een decimal domain om de casts gelijk te kunnen stellen met anderen

CREATE OR REPLACE DOMAIN "decimal"
AS numeric
DEFAULT 0.00
;
ALTER DOMAIN "decimal" OWNER TO webuser;


UPDATE "meta" SET "value"='1.7.6' WHERE "key"='sqlversie';

