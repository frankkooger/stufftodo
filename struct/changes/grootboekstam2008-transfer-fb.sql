-- Voeg de grootboekstam tabellen samen in 1 grootboekstamtemp tabel
-- Doe dat 3 keer: 
-- grootboekstam2008 (2008 As boekjaar)
-- grootboekstam2009 (2009 As boekjaar) 
-- grootboekstam (2010 As boekjaar)
--
-- Verhoog eerst de id reeksen van 2009 en stam:
Update "grootboekstam2009" Set "id"="id" + 64;
COMMIT;

Update "grootboekstam" Set "id"="id" + 128;
COMMIT;

--

/*
CREATE TABLE "grootboekstamtemp"
(
  "id" integer NOT NULL,
  "boekjaar" integer NOT NULL,
  "active" integer DEFAULT 1,
  "nummer" integer DEFAULT 0,
  "populariteit" integer DEFAULT 0,
  "type" integer DEFAULT 0,
  "nivo" integer DEFAULT 0,
  "verdichting" integer DEFAULT 0,
  "naam" varchar(64) DEFAULT '',
  "btwkey" varchar(32) DEFAULT '',
  "btwdefault" varchar(32) DEFAULT ''
);
COMMIT;

*/

INSERT INTO "grootboekstamtemp"
  ("id"
  ,"boekjaar"
  ,"active"	
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault")
SELECT
  "id"
  ,2008 As "boekjaar"
  ,1 As "active"
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault"
FROM
	"grootboekstam2008";
  COMMIT;


INSERT INTO "grootboekstamtemp"
  ("id"
  ,"boekjaar"
  ,"active"	
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault")
SELECT
  "id"
  ,2009 As "boekjaar"
  ,1 As "active"
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault"
FROM
	"grootboekstam2009";
  COMMIT;


INSERT INTO "grootboekstamtemp"
  ("id"
  ,"boekjaar"
  ,"active"	
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault")
SELECT
  "id"
  ,2010 As "boekjaar"
  ,1 As "active"
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault"
FROM
	"grootboekstam";
  COMMIT;


-- Na het samenvoegen in grootboekstamtemp, draai 
--  "grootboekstamtemp-deletedubbele.sql"
--
-- Daarna, verwijder grootboekstam en rename grootboekstamtemp naar grootboekstam
-- of truncate grootboekstam, voeg de 2 nieuwe velden "boekjaar" en "active" toe en doe:
/*
INSERT INTO grootboekstam
(
  "id"
  ,"boekjaar"
  ,"active"
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault"
)
SELECT 
  "id"
  ,"boekjaar"
  ,"active"
  ,"nummer"
  ,"populariteit"
  ,"type"
  ,"nivo"
  ,"verdichting"
  ,"naam"
  ,"btwkey"
  ,"btwdefault"
FROM "grootboekstamtemp";
COMMIT;

*/
