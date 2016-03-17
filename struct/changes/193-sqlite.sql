
-- ---------------------------------------
-- SQLVERSIE 1.9.0 <- 1.7.4
-- ---------------------------------------

-- 25 juli 2011
--
-- Views voor de overgang naar vw_grootboekstam
--
-- vw_grootboekstam is zelf al aangemaakt in 1.7.x omdat 'ie nodig was voor de btw views.
-- Wel kijkt 'ie daar nog naar de tabel "grootboekstamtemp". In 180 moet dat naar de 
-- originele tabel "grootboekstam" worden.
--
-- Versie van 1.8.1 naar 1.9.0:
-- in deze views is niets veranderd maar wel in de voorlopende views die nu van 1.7.4 naar 1.7.6 zijn genummerd
-- Hierin is 'grootboekstamtemp' veranderd naar het oorspronkelijke 'grootboekstam'
--
-- ---------------------------------------
-- SQLVERSIE 1.9.1 <- 1.9.0
-- ---------------------------------------

-- 14 aug 2011
--
-- in vw_boekregels "id" veranderd naar "boekregelid"
-- j.id veranderd in j.journaalid
-- De id velden in boekregels en journaal zijn ook veranderd naar boekregelid en journaalid
--
--
-- LET OP! Deze veranderingen aan de tabellen "boekregels", "boekregelsTrash" en "journaal" moeten in sqlite met de hand gebeuren!
-- en omdat sqlite geen ALTER COLUMN kent moet dat via een tussentabel
--

-- 28 aug 2011
-- Vanaf sqlversie 1.9.3 gaan alle views uit de sqlupdate files en worden vanuit 1 views.sql file ingelezen en onderhouden

UPDATE "meta" SET "value"='1.9.1' WHERE "key"='sqlversie';

-- ---------------------------------------
-- SQLVERSIE 1.9.2 <- 1.9.1
-- ---------------------------------------

-- Maatregelen om tabel "dagboeken" historiegevoelig te maken

ALTER TABLE "dagboeken"
ADD COLUMN "boekjaar" integer NOT NULL DEFAULT 0;

ALTER TABLE "dagboeken"
ADD COLUMN "active" integer NOT NULL DEFAULT 1;

UPDATE "dagboeken"
SET "boekjaar"=2008;


UPDATE "meta" SET "value"='1.9.2' WHERE "key"='sqlversie';

-- Update van btwkeys met historie attributen

ALTER TABLE "btwkeys"
ADD COLUMN "boekjaar" integer NOT NULL DEFAULT 0;

ALTER TABLE "btwkeys"
ADD COLUMN "active" integer NOT NULL DEFAULT 1;

UPDATE "btwkeys"
SET "boekjaar"=2008;

INSERT INTO "btwkeys" VALUES('verkopen_vrijgesteldebtw', 'sal', 1, '', '', '', 'Verkopen vrijgestelde BTW', '', 2008,1);

UPDATE "meta" SET "value"='1.9.3' WHERE "key"='sqlversie';

