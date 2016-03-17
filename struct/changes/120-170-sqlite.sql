-- sqlite versie

--  SQLVERSIE 1.3.0 <- 1.2.0

-- DROP COLUMN werkt niet in sqlite
-- laat de "tekst"velden in oudere versies maar bestaan

--ALTER TABLE  "btwaangiftes" DROP  "tekst";
--ALTER TABLE  "crediteurenstam" DROP  "tekst";
--ALTER TABLE  "debiteurenstam" DROP  "tekst";
--ALTER TABLE  "eindbalansen" DROP  "tekst";
--ALTER TABLE  "inkoopfacturen" DROP  "tekst";
--ALTER TABLE  "pinbetalingen" DROP  "tekst";
--ALTER TABLE  "verkoopfacturen" DROP  "tekst";
--ALTER TABLE  "voorkeuren" DROP  "tekst";

CREATE TABLE  "notities" (
"id" INT NOT NULL PRIMARY KEY ,
"tabel" VARCHAR( 32 ) NOT NULL ,
"tabelid" INT NOT NULL ,
"tekst" TEXT NOT NULL
) 

INSERT INTO "notities" ("id", "tabel", "tabelid", "tekst") VALUES (1, 'btwaangiftes', '13', 'Door handmatige verwerking van de BTW cijfers wijkt het aangiftebedrag af van het boekingsbedrag.');

UPDATE  "meta" SET  "value" =  '1.3.0' WHERE  "meta"."key" =  'sqlversie';

--  SQLVERSIE 1.3.1 <- 1.3.0 

--INSERT INTO "stamgegevens" VALUES(28, 2008,'e',26,'Verkopen geen BTW','rkg_verkoopgeenbtw','0','');

--  SQLVERSIE 1.3.2 <- 1.3.1 

INSERT INTO "voorkeuren" ("id", "label", "naam", "value") VALUES((SELECT MAX("id") FROM "voorkeuren") + 1, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');

--  SQLVERSIE 1.3.3 <- 1.3.2 

UPDATE "meta" SET "value" = '1.3.3' WHERE "key" = 'sqlversie';

INSERT INTO "stamgegevens" ("id", "boekjaar", "code", "subcode", "label", "naam", "value", "tekst") 
  VALUES ((SELECT MAX("id") FROM "stamgegevens") + 1, '2011', 'e', '22', 'Rekening BTW autokosten', 'rkg_btwautokosten', '', '');

DELETE FROM "stamgegevens" WHERE "naam"='rkg_verkoopverlegd';

--  SQLVERSIE 1.4.0 <- 1.3.3

uPDATE "btwaangiftes" SET "labelkey"='verkopen_verlegdebtw' WHERE "labelkey"='verkopen_verlegd';

DELETE FROM "stamgegevens" WHERE "naam"='rkg_verkoopgeenbtw';

UPDATE "meta" SET "value" = '1.4.0' WHERE "key" = 'sqlversie';

-- ---------------------------------------
-- SQLVERSIE 1.5.0 <- 1.4.0
-- ---------------------------------------

-- De nieuwe tabel 'btwkeys' komt in de plaats van 'btwaangiftelabels'
-- Om 'btwkeys' gaat de nieuwe BTW afhandeling, berekening, aanfgite etc. draaien.
--

DROP TABLE "btwaangiftelabels";

CREATE TABLE "btwkeys" (
     "key" varchar(32) DEFAULT ''
    ,"type" varchar(10) DEFAULT ''
    ,"actief" smallint DEFAULT 0
    ,"ccode" varchar(2) DEFAULT ''
    ,"acode" varchar(2) DEFAULT ''
    ,"label" varchar(64) DEFAULT ''
    ,"labelstam" varchar(64) DEFAULT ''
    ,"labeldefaults" varchar(64) DEFAULT ''
);

INSERT INTO "btwkeys" VALUES('rkg_btwverkoophoog', 'btwv', 1, '1a', '1a', 'Leveringen/diensten belast met hoog tarief', 'BTW bedragen verkopen hoog', 'Verkopen hoog');
INSERT INTO "btwkeys" VALUES('rkg_btwverkooplaag', 'btwv', 1, '1b', '1b', 'Leveringen/diensten belast met laag tarief', 'BTW bedragen verkopen laag', 'Verkopen laag');
INSERT INTO "btwkeys" VALUES('rkg_btwoverig', 'btwv', 0, '1c', '1c', 'Leveringen/diensten belast met overige tarieven behalve 0%', 'BTW bedragen verkopen overig', 'Verkopen overig');
INSERT INTO "btwkeys" VALUES('rkg_btwprivegebruik', 'btwv', 0, '1d', '1d', 'PrivÃ©gebruik', 'BTW bedragen privÃ©gebruik', 'BTW privÃ©gebruik');
INSERT INTO "btwkeys" VALUES('verkopen_geenbtw', 'sal', 1, '1e', '1e', 'Leveringen/diensten belast met 0% of niet bij u belast', 'Verkopen 0% BTW', '');
INSERT INTO "btwkeys" VALUES('verkopen_verlegdebtw', 'sal', 1, '1e', '', '', 'Verkopen verlegde BTW', '');
INSERT INTO "btwkeys" VALUES('verkopen_partbtwmateriaal', 'sal', 1, '', '', '', 'Verkopen part materialen', '');
INSERT INTO "btwkeys" VALUES('rkg_btwnaarmijverlegd', 'btwv', 0, '2a', '2a', 'Leveringen/diensten waarbij de heffing van BTW naar u is verlegd', 'BTW bedragen naar mij verlegd', 'BTW naar mij verlegd');
INSERT INTO "btwkeys" VALUES('verkopen_buiteneu', 'sal', 0, '3a', '3a', 'Leveringen naar landen buiten de EU (uitvoer)', 'Verkopen buiten EU', '');
INSERT INTO "btwkeys" VALUES('verkopen_binneneu', 'sal', 0, '3b', '3b', 'Leveringen naar/diensten in landen binnen de EU', 'Verkopen binnen EU', '');
INSERT INTO "btwkeys" VALUES('verkopen_installatieeu', 'sal', 0, '3c', '3c', 'Installatie/afstandsverkopen binnen de EU', 'Verkopen installaties binnen EU', '');
INSERT INTO "btwkeys" VALUES('rkg_btwbuiteneu', 'btwv', 0, '4a', '4a', 'Leveringen/diensten uit landen buiten de EU', 'BTW bedragen levering van buiten EU', 'Levering van buiten EU');
INSERT INTO "btwkeys" VALUES('rkg_btwbinneneu', 'btwv', 0, '4b', '4b', 'Leveringen/diensten uit landen buiten de EU', 'BTW bedragen levering van binnen EU', 'Levering van binnen EU');
INSERT INTO "btwkeys" VALUES('subtotaal5a', 'sub', 1, '5a', '5a', 'Verschuldigde omzetbelasting: rubrieken 1 tm 4', '', '');
INSERT INTO "btwkeys" VALUES('rkg_btwinkopen', 'btwi', 1, '5b', '5b', 'Voorbelasting', 'BTW bedragen inkopen', 'Inkopen');
INSERT INTO "btwkeys" VALUES('rkg_btwautokosten', 'btwi2', 1, '5b', '', 'Voorbelasting autokosten', 'BTW bedragen autokosten', 'BTW autokosten');
INSERT INTO "btwkeys" VALUES('rkg_btwpartmateriaal', 'btwi80', 1, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.');
INSERT INTO "btwkeys" VALUES('subtotaal5c', 'sub', 1, '5c', '5c', 'Subtotaal: 5a min 5b', '', '');
INSERT INTO "btwkeys" VALUES('rkg_betaaldebtw', 'calc5d', 1, '5d', '5d', 'Vermindering volgens kleinondernemersregeling', '', '');
INSERT INTO "btwkeys" VALUES('totaal5e', 'tot', 1, '5e', '5e', 'Totaal', '', '');
INSERT INTO "btwkeys" VALUES('rkg_betaaldebtw', 'betbtw', 1, '', '', '', 'Rekening betaalde BTW', '');
INSERT INTO "btwkeys" VALUES('dervingbtw_partbtwmateriaal', 'calc', 1, '', '', '', 'Derving BTW partiele materialen', '');
INSERT INTO "btwkeys" VALUES('inkopen_partbtwmateriaal', 'sal', 1, '', '', '', 'Inkopen partiele materialen', '');

CREATE INDEX "btk_prima" ON "btwkeys" ("key","ccode");

ALTER TABLE "btwaangiftes" ADD "acode" VARCHAR( 2 ) DEFAULT '';

update "btwaangiftes" set "acode"='1a' where "labelkey" LIKE 'rkg_btwverkoophoog';
update "btwaangiftes" set "acode"='1b' where "labelkey" LIKE 'rkg_btwverkooplaag';
update "btwaangiftes" set "acode"='1e' where "labelkey" LIKE 'verkopen_verlegdebtw';
update "btwaangiftes" set "acode"='5a' where "labelkey" LIKE 'subtotaal5a';
update "btwaangiftes" set "acode"='5b' where "labelkey" LIKE 'rkg_btwinkopen';
update "btwaangiftes" set "acode"='5c' where "labelkey" LIKE 'subtotaal5c';
update "btwaangiftes" set "acode"='5d' where "labelkey" LIKE 'vermindering5d';
update "btwaangiftes" set "acode"='5e' where "labelkey" LIKE 'totaal5e';

DELETE FROM "stamgegevens" WHERE "naam" LIKE 'rkg_btw%';
DELETE FROM "stamgegevens" WHERE "naam" LIKE 'rkg_betaaldebtw';
DELETE FROM "stamgegevens" WHERE "naam" LIKE 'rkg_verko%';
DELETE FROM "stamgegevens" WHERE "naam" LIKE 'rkg_inko%';

--ALTER TABLE "grootboekstam" CHANGE "btwtype" "btwdefaults" INT( 11 ) NOT NULL DEFAULT '0' 

ALTER TABLE "grootboekstam" ADD "btwkey" VARCHAR( 32 ) DEFAULT '';
ALTER TABLE "grootboekstam" ADD "btwdefault" VARCHAR( 32 ) DEFAULT '';

UPDATE "grootboekstam" SET "btwkey"='rkg_betaaldebtw' WHERE "nummer"=2300;
UPDATE "grootboekstam" SET "btwkey"='rkg_btwinkopen' WHERE "nummer"=2200;
UPDATE "grootboekstam" SET "btwkey"='rkg_btwverkoophoog' WHERE "nummer"=2110;
UPDATE "grootboekstam" SET "btwkey"='rkg_btwverkooplaag' WHERE "nummer"=2120;
UPDATE "grootboekstam" SET "btwkey"='verkopen_geenbtw' WHERE "naam" LIKE 'Verkopen geen BTW tarief';
UPDATE "grootboekstam" SET "btwkey"='verkopen_partbtwmateriaal' WHERE "naam" LIKE 'Verkopen Atelier';

UPDATE "grootboekstam" SET "btwdefault"='rkg_btwinkopen' WHERE "btwtype"=1;
UPDATE "grootboekstam" SET "btwdefault"='rkg_btwverkoophoog' WHERE "btwtype"=3;
UPDATE "grootboekstam" SET "btwdefault"='rkg_btwverkooplaag' WHERE "btwtype"=4;
UPDATE "grootboekstam" SET "btwdefault"='verkopen_geenbtw' WHERE "nummer"=8120;

--ALTER TABLE "grootboekstam" DROP "btwdefaults";

-- SQLVERSIE 1.6.0 <- 1.5.0

UPDATE "meta" SET "value"='1.6.0' WHERE "key"='sqlversie';

-- ---------------------------------------
-- SQLVERSIE 1.7.0 <- 1.6.0
-- ---------------------------------------

-- Voorbereiding op de BTW handling met de serie views in 1.7.1

UPDATE "stamgegevens" SET "naam"='btwverkoophoog' WHERE "naam"='btwhoog';
UPDATE "stamgegevens" SET "naam"='btwverkooplaag' WHERE "naam"='btwlaag';

UPDATE "meta" SET "value"='1.7.0' WHERE "key"='sqlversie';

