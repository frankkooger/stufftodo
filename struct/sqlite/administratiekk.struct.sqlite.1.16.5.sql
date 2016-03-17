-- vim: syntax=sql so=100
--
-- template for creating 'fadministratie' as Firebird or sqlite3 database
--
--
-- Domains
-- 

--CREATE DOMAIN SIGNED
--AS Integer DEFAULT 0 ;



-- DROP TABLE IF EXISTS "boekregelsTrash";
CREATE TABLE "boekregelsTrash" (
  "boekregelid" INTEGER NOT NULL,
  "journaalid" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "grootboekrekening" INTEGER NOT NULL,
  "btwrelatie" INTEGER default 0,
  "factuurrelatie" INTEGER default 0,
  "relatie" varchar(32) default '',
  "nummer" varchar(16) default '',
  "oorsprong" varchar(16) default '',
  "bomschrijving" varchar(128) default '',
  "bedrag" decimal(12,2) default '0.00'
) ;


--
-- Dumping data for table "boekregelsTrash"
--


--
-- Table structure for table "boekregels"
--

-- DROP TABLE IF EXISTS "boekregels";
CREATE TABLE "boekregels" (
  "boekregelid" INTEGER PRIMARY KEY,
  "journaalid" INTEGER DEFAULT 0 NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "grootboekrekening" INTEGER NOT NULL,
  "btwrelatie" INTEGER default 0,
  "factuurrelatie" INTEGER default 0,
  "relatie" varchar(32) default '',
  "nummer" varchar(16) default '',
  "oorsprong" varchar(16) default '',
  "bomschrijving" varchar(128) default '',
  "bedrag" decimal(12,2) default '0.00'
) ;

--
-- Table structure for table "btwaangiftes"
--

-- DROP TABLE IF EXISTS btwaangiftes;
CREATE TABLE "btwaangiftes" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER,
  "datum" date DEFAULT '1900-01-01' ,
  "boekjaar" INTEGER NOT NULL,
  "periode" INTEGER NOT NULL,
  "labelkey" varchar(32) default '',
  "omzet" decimal(12,2) default '0.00',
  "btw" decimal(12,2) default '0.00',
  "acode" varchar(2) default ''
) ;

--
-- Name: btwkeys; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE "btwkeys" (
    "id" INTEGER PRIMARY KEY,
    "key" varchar(32) DEFAULT '',
    "type" varchar(10) DEFAULT '',
    "actief" smallint DEFAULT '0',
    "ccode" varchar(2) DEFAULT '',
    "acode" varchar(2) DEFAULT '',
    "label" varchar(64) DEFAULT '',
    "labelstam" varchar(64) DEFAULT '',
    "labeldefaults" varchar(64) DEFAULT '',
    "boekjaar" integer DEFAULT 0 NOT NULL,
    "active" integer DEFAULT 1 NOT NULL
);

--
-- Table structure for table "crediteurenstam"
--

-- DROP TABLE IF EXISTS "crediteurenstam";
CREATE TABLE "crediteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date DEFAULT '1900-01-01' ,
  "code" varchar(16) default '',
  "naam" varchar(128) default '',
  "contact" varchar(128) default '',
  "telefoon" varchar(15) default '',
  "fax" varchar(15) default '',
  "email" varchar(64) default '',
  "adres" varchar(255) default '',
  "crediteurnummer" varchar(32) default '',
  "omzet" decimal(12,2) default '0.00'
) ;

--
-- Table structure for table "dagboeken"
--

-- DROP TABLE IF EXISTS "dagboeken";
CREATE TABLE "dagboeken" (
  "id" INTEGER PRIMARY KEY,
  "type" varchar(8) default '',
  "code" varchar(16) default '',
  "naam" varchar(64) default '',
  "grootboekrekening" INTEGER default '0',
  "boeknummer" INTEGER default '0',
  "saldo" decimal(12,2) default '0.00',
  "slot" INTEGER default '0',
  "boekjaar" integer NOT NULL,
  "active" integer NOT NULL
) ;

--
-- Table structure for table "dagboekhistorie"
--

-- DROP TABLE IF EXISTS "dagboekhistorie";
CREATE TABLE "dagboekhistorie" (
  "code" varchar(12) default '',
  "journaalid" INTEGER default '0',
  "boekjaar" INTEGER default '0',
  "vorigeboeknummer" INTEGER default '0',
  "saldo" decimal(12,2) default '0.00',
  "huidigeboeknummer" INTEGER default '0',
  "nieuwsaldo" decimal(12,2) default '0.00'
) ;

--
-- Table structure for table "debiteurenstam"
--

-- DROP TABLE IF EXISTS "debiteurenstam";
CREATE TABLE "debiteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date DEFAULT '1900-01-01' ,
  "code" varchar(16) default '',
  "naam" varchar(128) default '',
  "contact" varchar(128) default '',
  "telefoon" varchar(15) default '',
  "fax" varchar(15) default '',
  "email" varchar(64) default '',
  "adres" varchar(255) NOT NULL,
  "type" INTEGER default 0,
  "omzet" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "debiteurenstam"
--

--
-- Table structure for table "eindbalansen"
--

-- DROP TABLE IF EXISTS "eindbalansen";
CREATE TABLE "eindbalansen" (
  "id" INTEGER PRIMARY KEY,
  "boekdatum" date DEFAULT '1900-01-01' ,
  "boekjaar" INTEGER NOT NULL,
  "saldowinst" decimal(12,2) default '0.00',
  "saldoverlies" decimal(12,2) default '0.00',
  "saldobalans" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "eindbalansen"
--

--
-- Table structure for table "eindbalansregels"
--

-- DROP TABLE IF EXISTS "eindbalansregels";
CREATE TABLE "eindbalansregels" (
  "id" INTEGER PRIMARY KEY,
  "ideindbalans" INTEGER NOT NULL,
  "grootboekrekening" INTEGER NOT NULL,
  "grootboeknaam" varchar(64) default '',
  "debet" decimal(12,2) default '0.00',
  "credit" decimal(12,2) default '0.00',
  "saldo" decimal(12,2) default '0.00'
) ;

--
-- Table structure for table "eindcheck"
--

-- DROP TABLE IF EXISTS "eindcheck";
CREATE TABLE "eindcheck" (
  "id" INTEGER PRIMARY KEY,
  "date" date DEFAULT '1900-01-01' ,
  "boekjaar" INTEGER default '0',
  "sortering" INTEGER default '0',
  "label" varchar(64) default '',
  "naam" varchar(32) default '',
  "type" INTEGER default '0',
  "value" INTEGER default '0',
  "tekst" varchar(7000) default ''
) ;

--
-- Dumping data for table "eindcheck"
--

--
-- Table structure for table "grootboeksaldi"
--

-- DROP TABLE IF EXISTS "grootboeksaldi";
CREATE TABLE "grootboeksaldi" (
  "id" INTEGER NOT NULL,
  "nummer" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "saldo" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "grootboeksaldi"
--

--
-- Table structure for table "grootboekstam"
--

-- DROP TABLE IF EXISTS "grootboekstam";
CREATE TABLE "grootboekstam" (
  "id" INTEGER PRIMARY KEY,
  "boekjaar" INTEGER NOT NULL,
  "active" INTEGER default '1',
  "nummer" INTEGER NOT NULL,
  "populariteit" INTEGER default '0',
  "type" INTEGER default '0',
  "nivo" INTEGER default '0',
  "verdichting" INTEGER default '0',
  "naam" varchar(64) default '',
  "btwkey" varchar(32) default '',
  "btwdefault" varchar(32) default ''
) ;

--
-- Table structure for table "inkoopfacturen"
--

-- DROP TABLE IF EXISTS "inkoopfacturen";
CREATE TABLE "inkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "omschrijving" varchar(128) default '',
  "factuurbedrag" decimal(12,2) default '0.00',
  "relatiecode" varchar(32) default '',
  "relatieid" INTEGER NOT NULL,
  "factuurnummer" varchar(16) default '',
  "voldaan" decimal(12,2) default '0.00',
  "betaaldatum" date DEFAULT '1900-01-01' 
) ;
--
-- Dumping data for table "inkoopfacturen"
--

--
-- Table structure for table "journaal"
--

-- DROP TABLE IF EXISTS "journaal";
CREATE TABLE "journaal" (
  "journaalid" INTEGER PRIMARY KEY,
  "journaalpost" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "periode" INTEGER NOT NULL,
  "dagboekcode" varchar(16) default '',
  "jomschrijving" varchar(128) default '',
  "saldo" decimal(12,2) default '0.00',
  "jrelatie" varchar(32) default '',
  "jnummer" varchar(16) default '',
  "joorsprong" varchar(16) default '',
  "tekst" varchar(7000) default ''
) ;

--
-- Dumping data for table "journaal"
--

--
-- Table structure for table "meta"
--

-- DROP TABLE IF EXISTS "meta";
CREATE TABLE "meta" (
  "key" varchar(64) NOT NULL,
  "value" varchar(9600) default ''
) ;

--
-- Dumping data for table "meta"
--

--
-- Table structure for table "pinbetalingen"
--

-- DROP TABLE IF EXISTS "pinbetalingen";
CREATE TABLE "pinbetalingen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "omschrijving" varchar(128) default '',
  "factuurbedrag" decimal(12,2) default '0.00',
  "relatiecode" varchar(32) default '',
  "relatieid" INTEGER NOT NULL,
  "factuurnummer" varchar(16) default '',
  "voldaan" decimal(12,2) default '0.00',
  "betaaldatum" date DEFAULT '1900-01-01' 
) ;

--
-- Dumping data for table "pinbetalingen"
--

--
-- Table structure for table "stamgegevens"
--

-- DROP TABLE IF EXISTS "stamgegevens";
CREATE TABLE "stamgegevens" (
  "id" INTEGER PRIMARY KEY,
  "boekjaar" INTEGER NOT NULL,
  "code" char(1) default '',
  "subcode" INTEGER default 0,
  "label" varchar(128) default '',
  "naam" varchar(32) default '',
  "value" varchar(255) default '',
  "tekst" varchar(7000) default ''
) ;

--
-- Dumping data for table "stamgegevens"
--

--
-- Table structure for table "verkoopfacturen"
--

-- DROP TABLE IF EXISTS "verkoopfacturen";
CREATE TABLE "verkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "datum" date DEFAULT '1900-01-01' ,
  "omschrijving" varchar(128) default '',
  "factuurbedrag" decimal(12,2) default '0.00',
  "relatiecode" varchar(32) default '',
  "relatieid" INTEGER NOT NULL,
  "factuurnummer" varchar(16) default '',
  "voldaan" decimal(12,2) default '0.00',
  "betaaldatum" date DEFAULT '1900-01-01' 
) ;

--
-- Dumping data for table "verkoopfacturen"
--

--
-- Table structure for table "voorkeuren"
--

-- DROP TABLE IF EXISTS "voorkeuren";
CREATE TABLE "voorkeuren" (
  "id" INTEGER PRIMARY KEY,
  "label" varchar(128) default '',
  "naam" varchar(32) default '',
  "value" varchar(255) default ''
) ;

--
-- Dumping data for table "voorkeuren"
--

CREATE TABLE  "notities" (
  "id" INTEGER PRIMARY KEY,
  "tabel" VARCHAR( 32 ) default '',
  "tabelid" INTEGER NOT NULL,
  "tekst" varchar(7000) default ''
);


CREATE TABLE  "periodes" (
  "periode" INTEGER PRIMARY KEY
);


INSERT INTO "periodes" VALUES (1);
INSERT INTO "periodes" VALUES (2);
INSERT INTO "periodes" VALUES (3);
INSERT INTO "periodes" VALUES (4);
INSERT INTO "periodes" VALUES (5);
INSERT INTO "periodes" VALUES (6);
INSERT INTO "periodes" VALUES (7);
INSERT INTO "periodes" VALUES (8);
INSERT INTO "periodes" VALUES (9);
INSERT INTO "periodes" VALUES (10);
INSERT INTO "periodes" VALUES (11);
INSERT INTO "periodes" VALUES (12);
INSERT INTO "periodes" VALUES (13);



  CREATE UNIQUE INDEX  "k_keyboekjaar" ON "btwkeys" ("key","boekjaar");

  CREATE INDEX  "b_trash_journaalid" ON "boekregelsTrash" ("journaalid");
  CREATE INDEX  "b_trash_grootboekrekening" ON "boekregelsTrash" ("grootboekrekening");
  CREATE INDEX  "b_trash_id" ON "boekregelsTrash" ("boekregelid");

  CREATE UNIQUE INDEX  "b_boekjaarid" ON "boekregels" ("boekjaar","boekregelid");
  CREATE INDEX  "b_journaalid" ON "boekregels" ("journaalid");
  CREATE INDEX  "b_grootboekrekening" ON "boekregels" ("grootboekrekening");

  CREATE INDEX  "eindb_ideindbalans" ON "eindbalansregels" ("ideindbalans");

  CREATE INDEX  "grootboeksaldi_boekjaar" ON "grootboeksaldi" ("boekjaar");
  CREATE INDEX  "grootboeksaldi_nummer" ON "grootboeksaldi" ("nummer");

  CREATE UNIQUE INDEX  "journaal_idboekjaar" ON "journaal" ("journaalpost","boekjaar");
  CREATE INDEX  "journaal_periode" ON "journaal" ("periode");
  CREATE INDEX  "journaal_dagboekcode" ON "journaal" ("dagboekcode");
  
  CREATE UNIQUE INDEX  "dagboeken_code_boekjaar" ON "dagboeken" ("code","boekjaar");

  CREATE UNIQUE INDEX  "grootboekstam_nummer_boekjaar" ON "grootboekstam" ("nummer","boekjaar");
  CREATE UNIQUE INDEX  "grootboekstam_boekjaar_nummer" ON "grootboekstam" ("boekjaar","nummer");

  CREATE UNIQUE INDEX  "inkoopfacturen_idboekjaar" ON "inkoopfacturen" ("id","boekjaar");

  CREATE UNIQUE INDEX  "pinbetalingen_idboekjaar" ON "pinbetalingen" ("id","boekjaar");

  CREATE UNIQUE INDEX  "verkoopfacturen_idboekjaar" ON "verkoopfacturen" ("id","boekjaar");

  CREATE UNIQUE INDEX  "stam_naam_boekjaar" ON "stamgegevens" ("naam","boekjaar");
  

--
-- Procedures
-- 

--
-- Views
-- 

-- Bijgewerkt tot 1.16.5
--
-- Bedenk dat voor type 'Signed' een Domain is opgenomen in alle databases.
-- Normaal wordt dit gekend als 'Integer' maar mysql kent 'Signed'
--
-- Voor het type 'decimal' is een Domain As 'numeric' opgenomen in Postgresql
-- Dit om de casts gelijk te kunnen stellen met andere databases
--
;

CREATE  VIEW "vw_boekjaar" AS 
SELECT
  CAST("value" As Signed) As "boekjaar"
FROM
  "stamgegevens"
WHERE
  "naam"='lopendjaar'
;



CREATE  VIEW "vw_boekregelsaldi" AS
SELECT
  SUM(br."bedrag") As "Regelsaldo"
  ,bs."saldo" As "Saldisaldo" 
  ,br."boekjaar"
  ,br."grootboekrekening"
FROM
  "boekregels" br
LEFT JOIN
  "grootboeksaldi" bs
ON
  br."boekjaar"=bs."boekjaar"
AND
  br."grootboekrekening"=bs."nummer"
WHERE
  br."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar")
GROUP BY
  br."boekjaar", "grootboekrekening", bs."saldo"
ORDER BY
  br."boekjaar", "grootboekrekening"
;
  


CREATE  VIEW "vw_grootboekstam" As
SELECT sub1."id", sub1."boekjaar" As "historie", sub1."nummer", sub1."active", sub1."populariteit"
      ,sub1."type", sub1."nivo", sub1."verdichting", sub1."naam", sub1."btwkey", sub1."btwdefault"
FROM
	"grootboekstam" As sub1
JOIN
(
	SELECT MAX(boekjaar) As "boekjaar", "nummer" FROM "grootboekstam"
	WHERE "boekjaar"<=(SELECT "boekjaar" FROM "vw_boekjaar")
	GROUP BY "nummer"
) b
ON
	sub1."boekjaar"=b."boekjaar"
AND
	sub1."nummer"=b."nummer"
AND
  sub1."active"=1
ORDER BY 
	sub1."nummer",sub1."boekjaar"
;



CREATE  VIEW "vw_grootboekstamsaldo" AS
SELECT 
  st."id"
  ,st."historie" As "historie"
  ,st."nummer"
  ,st."active"
  ,st."populariteit"
  ,st."type"
  ,st."nivo"
  ,st."verdichting"
  ,st."naam"
  ,st."btwkey"
  ,st."btwdefault"
  ,sa."saldo"
  ,sa."boekjaar"
FROM
  "vw_grootboekstam" st
LEFT JOIN
  "grootboeksaldi" sa
ON
  st."nummer"=sa."nummer"
AND
  sa."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar")
;



CREATE  VIEW "vw_dagboeken" As
SELECT *
FROM
  ( --sub1
  SELECT 
    "id"
    ,"boekjaar" As "historie"
    ,"active"
    ,"type"
    ,"code"
    ,"naam"
    ,"grootboekrekening"
    ,"boeknummer"
    ,"saldo"
    ,"slot"
  FROM 
    "dagboeken"
  WHERE 
    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "dagboeken"
      WHERE    "boekjaar"<=CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As Signed)
      GROUP BY "code"
    )
  ) sub1
WHERE
  "active"=1
ORDER BY "code", "historie"
;


CREATE  VIEW "vw_stamgegevens" As
SELECT
  s."id"
  ,s."code"
  ,s."subcode"
  ,s."label"
  ,s."naam"
  ,s."value"
  ,s."boekjaar"
  ,g."nummer" As "grootboekrekening"
  ,d."code" As "dagboek"
FROM
  "stamgegevens" As s
LEFT JOIN
  "vw_grootboekstam" As g
ON
  s."value"=CAST(g."nummer" As varchar(8))
LEFT JOIN
  "vw_dagboeken" As d
ON
  g."nummer"=d."grootboekrekening"
WHERE
    s."id" IN
    (
        SELECT MAX("id") FROM "stamgegevens"
        WHERE "boekjaar" <= CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As SIGNED)
        GROUP BY "naam"
    )
ORDER BY
    s."code", s."subcode"
; 



CREATE  VIEW "vw_btwkeys" AS
SELECT * FROM
( --a
SELECT "id", "key", "type", "actief", "ccode", "acode", "label", "labelstam", "labeldefaults", "boekjaar","active"
  FROM "btwkeys"
WHERE

    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "btwkeys"
      WHERE    "boekjaar"<=CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As Signed)
      GROUP BY "key"
    )

  AND "actief" = 1
  AND "ccode" NOT LIKE ''
  AND "key" NOT LIKE '%part%'
  AND "type" NOT IN ('sub','tot')
ORDER BY
  "ccode"
  ,"acode" desc
  ,"key"
) a

UNION

SELECT * FROM
( --b
SELECT "id", "key", "type", "actief", "ccode", "acode", "label", "labelstam", "labeldefaults", "boekjaar","active"
  FROM "btwkeys"
WHERE

    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "btwkeys"
      WHERE    "boekjaar"<=CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As Signed)
      GROUP BY "key"
    )
    
  AND "actief" = 1
  AND (   "key" LIKE '%part%'
       OR "key" LIKE '%vrijgesteld%'
       OR "key" LIKE 'verkopen%'
      )
ORDER BY
  "ccode" desc
  ,"acode" desc
  ,"key"
) b
;



CREATE  VIEW "vw_btwrubrieken" AS
SELECT  
  * 
FROM 
  "btwkeys"
WHERE

    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "btwkeys"
      WHERE    "boekjaar"<=CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As Signed)
      GROUP BY "key"
    )
    
  AND 
	("ccode" NOT LIKE ''
	AND "type" NOT IN ('sub','tot')
	)
  OR
	(   "key" LIKE '%vrijgesteld%'
	OR "key" LIKE 'verkopen%'
	)
ORDER BY
  "ccode", "acode" DESC, "key", "boekjaar" DESC
; 



CREATE  VIEW "vw_boekregels" AS
SELECT 
  b."boekregelid"
  ,b."journaalid"
  ,j."journaalpost"
  ,j."boekjaar"
  ,j."periode"
  ,b."datum" As "boekdatum"
  ,j."datum" As "journaaldatum"
  ,b."grootboekrekening"
  ,g."naam" As "grootboeknaam"
  ,b."bedrag"
  ,b."btwrelatie"
  ,b."factuurrelatie"
  ,b."relatie"
  ,b."nummer"
  ,g."btwkey"
  ,b."bomschrijving"
  ,b."oorsprong" As "boorsprong"
  ,j."joorsprong"
  ,j."dagboekcode"
  ,j."jomschrijving"
  ,j."saldo" As "journaalsaldo"
  ,j."jrelatie"
  ,j."jnummer"
FROM
  "boekregels" b
JOIN
  "journaal" j
ON
  b."journaalid"=j."journaalid"
-- 436 0.069 sec
JOIN
    "vw_grootboekstam" g
ON
    b."grootboekrekening"=g."nummer"
-- 436  0.084
WHERE
  j."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar")
;



-- journaalposten met dagboekinformatie en boekregelsaldi
--
CREATE  VIEW "vw_journaalposten" AS
SELECT
  j."journaalid"
 ,j."journaalpost"
 ,j."boekjaar" 
 ,j."datum" 
 ,j."periode" 
 ,j."dagboekcode" 
 ,d."type" AS "dagboektype"
 ,d."grootboekrekening" AS "dagboekgrootboekrekening"
 ,j."jomschrijving" 
 ,j."saldo" 
 ,s."saldo" As "boekregelsaldo"
 ,j."jrelatie"
 ,j."jnummer"
 ,j."joorsprong"
 ,j."tekst"
FROM 
  "journaal" AS j 
LEFT JOIN 
  "vw_dagboeken" AS d 
  ON (j."dagboekcode"=d."code")
LEFT JOIN 
  ( SELECT SUM("bedrag") As "saldo","journaalid" FROM "boekregels" GROUP BY "journaalid") s 
  ON j."journaalid"=s."journaalid"
WHERE 
  j."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar")
;


-- een verzameling boekregels gerangschikt als journaalpost
-- met journaal-gegevens als journaalid en journaalstuk
CREATE  VIEW "vw_boekstuk" As
SELECT
  b."journaalid"
 ,b."journaalpost"
 ,b."boekregelid"
 ,b."boekdatum"
 ,b."periode"
 ,b."boekjaar"
 ,b."grootboekrekening"
 ,b."btwrelatie"
 ,b."factuurrelatie"
 ,b."grootboeknaam"
 ,b."relatie"
 ,b."nummer"
 ,b."boorsprong"
 ,b."dagboekcode"
 ,b."jomschrijving"
 ,b."bomschrijving"
 ,b."bedrag"
 ,'0' AS "debet"
 ,'0' AS "credit"
FROM 
  "vw_boekregels" AS b
ORDER BY 
  b."journaalid", b."boekregelid"
;


-- met vw_boekstuk is het makkelijk om bepaalde journaalposten op
-- grootboekkaarten te verdichten. Dit is specifiek om te voorkomen dat elke
-- afzonderlijke post op kasbladen op de btw-rekeningen terecht komt.
CREATE VIEW "vw_grootboekkaart" As
SELECT 
  "journaalid"
  ,"journaalpost"
  ,"grootboekrekening"
  ,MAX("boekdatum") As "boekdatum"
  ,"periode"
  ,"dagboekcode"
  ,"jomschrijving" || CASE WHEN "relatie"<>'' THEN ' (' || "relatie" || ')' ELSE '' END As "jomschrijving"
  ,SUM("bedrag") As "bedrag"
FROM
  "vw_boekstuk"
GROUP BY
  "journaalid","journaalpost","grootboekrekening","periode","dagboekcode","jomschrijving", "relatie"
ORDER BY
  "grootboekrekening", "periode","journaalid"
;


-- Als hierboven, echter
-- Als verdichting niet gewenst is, kan deze view worden ingeschakeld.
--
CREATE VIEW "vw_grootboekkaartExp" As
SELECT 
  "journaalid"
  ,"journaalpost"
  ,"grootboekrekening"
  ,"boekdatum"
  ,"periode"
  ,"dagboekcode"
  ,"bomschrijving" || CASE WHEN "relatie"<>'' THEN ' (' || "relatie" || ')' ELSE '' END As "jomschrijving"
  ,"bedrag"
FROM
  "vw_boekstuk"
ORDER BY
  "grootboekrekening", "periode","journaalid"
;


-- View: vw_btwtarieven
--
-- Om deze view in de btw views te laten werken moeten
-- we een extra record in btwkeys opnemen met als
-- key: 'rkg_divopbrengsten', active: 0, type: 'calc'. De rest mag leeg blijven.
-- Dit record is nodig om de rekening diverse opbrengsten, waarop BTW afronding 
-- en evt 5d teruggaaf wordt geboekt, in stamgegevens herkend te maken.
--

-- DROP VIEW vw_btwtarieven;

CREATE  VIEW "vw_btwtarieven" AS 
SELECT 
	s."naam" As "key"
	,CAST(s."value" As decimal) As "value"
FROM
	"stamgegevens" As s 
WHERE
	s."naam" IN ('btwverkoophoog','btwverkooplaag','rkg_divopbrengsten','lopendjaar','periodeextra') 
AND
	s."id" IN (
		SELECT MAX(id) FROM stamgegevens
		WHERE boekjaar<=(SELECT "boekjaar" FROM "vw_boekjaar")
		GROUP BY naam 
		)
	
UNION ALL

SELECT 
	b."key" As "key"
	, g."nummer" As "value"
FROM 
	"btwkeys" As b
INNER JOIN 
	"vw_grootboekstam" As g 
ON
	b."key"=g."btwkey"
;


-- ------------------------------------------------
-- Partbtw views
-- ------------------------------------------------

-- Om onderstaande view correct te laten werken moet van de boekregels in de
-- journaalpost die btwcorrectie tussen 2220 en 4620 doet, alleen de 2220
-- boekregel in boorsprong worden gemarkeerd met 'btwcorrectie'. Als dit ook in de
-- 4620 boekregel zou staan dan wordt 4620 in de view niet gezien.

CREATE  VIEW "vw_partbtwbedragen" AS
SELECT 
  b."boekjaar"
  ,b."periode"
  ,b."grootboekrekening"
  ,SUM(b."bedrag") As "bedrag"
  ,g."btwkey"
FROM 
  "vw_boekregels" b
JOIN 
  "vw_grootboekstam" g
ON 
  b."grootboekrekening" = g."nummer"
AND
  g."historie" <= b."boekjaar"
WHERE
  g."btwkey" IN (
  'verkopen_partbtwmateriaal'
  ,'verkopen_vrijgesteldebtw'
  ,'inkopen_partbtwmateriaal'
  ,'rkg_btwpartmateriaal'
  ,'dervingbtw_partbtwmateriaal'
  )
AND
  b."boorsprong" NOT IN ('egalisatie','btwcorrectie')
GROUP BY
  b."boekjaar"
  ,b."periode"
  ,b."grootboekrekening"
  ,g."btwkey"
ORDER BY
  "boekjaar"
  ,"periode"
  ,"grootboekrekening";


CREATE  VIEW "vw_partbtw_periode" AS
SELECT
  "boekjaar"
  ,"periode"
  ,SUM("bedrag") As "bedrag"
  ,"btwkey"
FROM
  "vw_partbtwbedragen"
GROUP BY
  "boekjaar"
  ,"periode"
  ,"btwkey"
ORDER BY
  "boekjaar"
  ,"periode";


CREATE  VIEW "vw_partbtw_year" AS
SELECT
  "boekjaar"
  ,SUM("bedrag") As "bedrag"
  ,"btwkey"
FROM
  "vw_partbtwbedragen"
GROUP BY
  "boekjaar"
  ,"btwkey"
ORDER BY
  "boekjaar";


-- Voor onderstaande view is een nieuwe hulptabel "periodes" nodig
-- Deze bestaat in sqlversie 1.9.3
-- Herstel: we hebben hier een view van gemaakt zodat een tabel niet nodig is
-- Dit herstellen we in sqlversie 1.9.3
CREATE  VIEW "vw_periodes" As
SELECT * FROM
(
SELECT 1 As "periode"
UNION ALL
SELECT 2
UNION ALL
SELECT 3
UNION ALL
SELECT 4
UNION ALL
SELECT 5
UNION ALL
SELECT 6
UNION ALL
SELECT 7
UNION ALL
SELECT 8
UNION ALL
SELECT 9
UNION ALL
SELECT 10
UNION ALL
SELECT 11
UNION ALL
SELECT 12
UNION ALL
SELECT 13
) x
ORDER BY "periode";


CREATE  VIEW "vw_partbtw_periode_jbedragen" As 
SELECT
  p."periode" As "periode"
  ,b."boekjaar" As "boekjaar"
  ,f1."bedrag" As "verkopen_partbtwmateriaal"
  ,f2."bedrag" As "verkopen_vrijgesteldebtw"
  ,f3."bedrag" As "inkopen_partbtwmateriaal"
  ,f4."bedrag" As "rkg_btwpartmateriaal"
  ,CAST (
   CASE 
    WHEN f1."bedrag" IS NULL THEN f3."bedrag"
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE ((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ) END As decimal(8,2) )
   As "dervingbtw_bedrag"
FROM
  "vw_periodes" As p
LEFT JOIN
  "vw_boekjaar" As b
ON
  1=1
LEFT JOIN
  "vw_partbtw_periode" As f1
ON
  b."boekjaar"=f1."boekjaar"
AND
  p."periode"=f1."periode"
AND
  f1."btwkey"='verkopen_partbtwmateriaal'
LEFT JOIN
  "vw_partbtw_periode" As f2
ON
  b."boekjaar"=f2."boekjaar"
AND
  p."periode"=f2."periode"
AND
  f2."btwkey"='verkopen_vrijgesteldebtw'
LEFT JOIN
  "vw_partbtw_periode" As f3
ON
  b."boekjaar"=f3."boekjaar"
AND
  p."periode"=f3."periode"
AND
  f3."btwkey"='inkopen_partbtwmateriaal'
LEFT JOIN
  "vw_partbtw_periode" As f4
ON
  b."boekjaar"=f4."boekjaar"
AND
  p."periode"=f4."periode"
AND
  f4."btwkey"='rkg_btwpartmateriaal';


CREATE  VIEW "vw_partbtw_year_jbedragen" As 
SELECT
  b."boekjaar" As "boekjaar"
  ,COALESCE(f1."bedrag",0) As "verkopen_partbtwmateriaal"
  ,COALESCE(f2."bedrag",0) As "verkopen_vrijgesteldebtw"
  ,COALESCE(f3."bedrag",0) As "inkopen_partbtwmateriaal"
  ,COALESCE(f4."bedrag",0) As "rkg_btwpartmateriaal"
  ,COALESCE(f5."bedrag",0) As "dervingbtw_partbtwmateriaal"
  ,CAST (
   CASE 
    WHEN f1."bedrag" IS NULL THEN f3."bedrag"
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE ((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ) - COALESCE(f5."bedrag",0)  END As decimal(8,2) )
   As "derving_correctie"
FROM
  "vw_boekjaar" As b
LEFT JOIN
  "vw_partbtw_year" As f1
ON
  b."boekjaar"=f1."boekjaar"
AND
  f1."btwkey"='verkopen_partbtwmateriaal'
LEFT JOIN
  "vw_partbtw_year" As f2
ON
  b."boekjaar"=f2."boekjaar"
AND
  f2."btwkey"='verkopen_vrijgesteldebtw'
LEFT JOIN
  "vw_partbtw_year" As f3
ON
  b."boekjaar"=f3."boekjaar"
AND
  f3."btwkey"='inkopen_partbtwmateriaal'
LEFT JOIN
  "vw_partbtw_year" As f4
ON
  b."boekjaar"=f4."boekjaar"
AND
  f4."btwkey"='rkg_btwpartmateriaal'
LEFT JOIN
  "vw_partbtw_year" As f5
ON
  b."boekjaar"=f4."boekjaar"
AND
  f5."btwkey"='dervingbtw_partbtwmateriaal';



-- ------------------------------------------------
-- BTW views
-- ------------------------------------------------

CREATE  VIEW "vw_btwbase" AS 
SELECT * FROM
(
SELECT
	b."boekjaar"
	,b."periode"
	,g."nummer"
	,k."ccode"
  ,SUBSTR(k."type",1,3) As "type"
	,sum(b."bedrag") As "bedrag"
FROM
	"vw_grootboekstam" As g
INNER JOIN
	"btwkeys" As k
ON
	g."btwkey"=k."key"
LEFT JOIN
	"vw_boekregels" As b
ON 
	g."nummer"=b."grootboekrekening"
WHERE 
	COALESCE(k."ccode", '') NOT LIKE ''
	AND b."joorsprong" NOT LIKE 'egalisatie'
GROUP BY
	k."ccode"
  ,k."type"
	,g."nummer"
	,b."boekjaar"
	,b."periode"

-- Ingeval we werken met inkopen/verkopen met zowel hoge als vrijgestelde BTW
UNION ALL

SELECT
	j."boekjaar"
	,j."periode"
	,0 As "nummer"
	,'5b' As "ccode"
  ,'cal' As "type"
  ,j."dervingbtw_bedrag" * -1
FROM
  "vw_partbtw_periode_jbedragen" j
JOIN
  "vw_btwkeys" k
ON
  k."key"='rkg_btwpartmateriaal'
  -- als "btwkeys"."actief" van 'rkg_btwpartmateriaal' = 0 dan is deze regel 
  -- niet in vw_btwkeys en toont deze UNION geen resultaat
WHERE
  j."dervingbtw_bedrag" <> 0

) x
ORDER BY
	"boekjaar","periode","ccode","nummer"
;




CREATE  VIEW "vw_btwbedragen0" AS
SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,ROUND(SUM( CASE WHEN "type"='sal' THEN "bedrag" ELSE 0 END)) * -1
	 As "omzet"
	,ROUND(SUM( CASE WHEN "type" IN ('btw','cal') THEN "bedrag" ELSE 0 END)) * 
              CASE WHEN "ccode"='5b' THEN 1 ELSE -1 END
	 As "btwbedrag"
FROM
	"vw_btwbase"
WHERE "ccode" IN ('1a','1b','1c','1d','1e','2a','3a','3b','3c','4a','4b','5b','5d')
GROUP BY
	"boekjaar"
	,"periode"
	,"ccode"
;



CREATE  VIEW "vw_btwbedragen1" AS
-- De omzetbedragen van 1a, 1b en 1d worden sinds 2012 (verhoging BTW tarief
-- in okt 2012) NIET meer teruggerekend vanuit het BTW bedrag
-- Voor 1d (Privegebruik) is dat globaal genomen niet helemaal goed omdat
-- betreffende BTW percentages voor Privegebruik kunnen verschillen (denk aan
-- voedingsmiddelen etc) maar omdat we het in KoogerKunst alleen gebruiken
-- voor 19% goederen (meer specifiek: alleen voor de prive bijdrage auto)
-- berekenen we het saldo op hoog tarief.
-- ERRATA: dat klopt natuurlijk niet. Prive bijdrage auto heeft niets met
-- omzetbedragen te maken. Omdat we de omzetbedragen nu niet meer terugrekenen is
-- dit probleem gelijk ook opgelost: omzetbedragen moeten nu van een
-- omzetrekening komen.
-- Om omzetbedragen en btw bedragen te scheiden, moeten we de omzetbedragen
-- van een aparte omzetrekening en -- de BTW bedragen optellen maar de 1 in
-- "btwbedrag" en de andere in "omzet"
-- We doen dit door 2 verschillende btwkeys te maken met dezelfde ccode.
-- Bv.: 1c zijn leveringen met een afwijkend BTW tarief. We maken 2 btwkeys:
--   key=verkopen_afwijkendebtw, type=sal, ccode=1c, acode=''
--   key=rkg_afwijkendebtw,      type=btw, ccode=1c, acode=1c
-- De keys kunnen aan meerdere rekeningen worden gehangen; via het groepeermechanisme
-- in vw_btwbase en vw_btwbedragen0 komen de bedragen op deze rekeningen bij elkaar.
-- Doordat vw_btwbedragen0 groepeert op ccode en op type zullen hier 2 aparte records
-- ontstaan: 1 met het totaal aan omzetbedragen en 1 idem met btwbedragen.
-- vw_btwbedragen1 groepeert alleen op ccode en deze zal er 1 regel van maken met totaal
-- omzet- en btwbedrag.

SELECT * FROM
( --xx
-- 1a, 1b, 1c, 1d
SELECT 
	"boekjaar","periode","ccode"
	,SUM("omzet") As "omzet"
	,SUM("btwbedrag") As "btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" IN ('1a','1b','1c','1d')
GROUP BY
	"ccode","boekjaar","periode"

UNION ALL
-- 1e
SELECT 
	"boekjaar","periode","ccode"
	,SUM("omzet") As "omzet"
	,0 As "btwbedrag" 
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" = '1e'
GROUP BY
	"ccode","boekjaar","periode"

UNION ALL
-- 2, 3 en 4
SELECT
	"boekjaar","periode"
	,"ccode"
	,SUM("omzet") As "omzet"
	,SUM("btwbedrag") As "btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" IN ('2a','3a','3b','3c','4a','4b')
GROUP BY
	"ccode","boekjaar","periode"

UNION ALL

SELECT
	"boekjaar","periode"
	,'5a' As "ccode"
	,0 As "omzet"
	,SUM("btwbedrag") As "btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" IN ('1a','1b','1c','1d','2a','4a','4b')
GROUP BY
	"boekjaar","periode"

UNION ALL

SELECT 
	"boekjaar","periode","ccode"
	,0 As "omzet"
	,"btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" = '5b'

UNION ALL

SELECT
	"boekjaar","periode"
	,'5c' As "ccode"
	,0 As "omzet"
	,SUM(CASE WHEN "ccode"='5b' AND "btwbedrag">0.0 THEN ("btwbedrag" *-1) ELSE "btwbedrag" END) As "btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" IN ('1a','1b','1c','1d','1e','2a','3a','3b','3c','4a','4b','5b')
GROUP BY
	"boekjaar","periode"

UNION ALL

SELECT 
	"boekjaar","periode","ccode"
	,0 As "omzet"
	,"btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" = '5d'

UNION ALL

SELECT
	"boekjaar","periode"
	,'5e' As "ccode"
	,0 As "omzet"
	,SUM(CASE WHEN "ccode" IN ('5b','5d') AND "btwbedrag">0.0 THEN ("btwbedrag" *-1) ELSE "btwbedrag" END) As "btwbedrag"
FROM
	"vw_btwbedragen0"
WHERE
	"ccode" IN ('1a','1b','1c','1d','1e','2a','3a','3b','3c','4a','4b','5b','5d')
GROUP BY
	"boekjaar","periode"
) xx
ORDER BY "boekjaar","periode","ccode"
;



CREATE  VIEW "vw_btw" AS
SELECT 
	v."boekjaar"
	,v."periode"
	,v."ccode"
	,v."ccode" || '. ' || k."label" As "label"
	,CASE v."omzet" WHEN 0 THEN NULL ELSE v."omzet" END AS "omzet"
	,CASE v."btwbedrag" WHEN 0 THEN NULL ELSE v."btwbedrag" END AS "btwbedrag"
FROM 
	"vw_btwbedragen1" As v
LEFT JOIN
	"btwkeys" As k
ON 
	v."ccode"=k."acode"
ORDER BY
	v."boekjaar"
	,v."periode"
	,v."ccode"
;



CREATE  VIEW "vw_btwjournaal" AS
SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,"nummer" As "rekening"
	,'BTW EGALISATIE periode ' || CAST("periode" AS char(2)) || ' naar ' || t."value" 
	 As "omschrijving"
	,("bedrag" * -1)
	 As "bedrag"
FROM
	"vw_btwbase"
LEFT JOIN
    "vw_btwtarieven" As t
ON  
    t."key"='rkg_betaaldebtw'
WHERE
	"type"='btw' 
AND
  "ccode" NOT LIKE '5d'

UNION ALL

SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,t."value" As "rekening"
	,'BTW EGALISATIE periode ' || CAST("periode" AS char(2)) || ' van ' || CAST("nummer" AS char(4)) 
	 As "omschrijving"
	,("bedrag")
	 As "bedrag"
FROM
	"vw_btwbase"
LEFT JOIN
    "vw_btwtarieven" As t
ON  
  t."key"='rkg_betaaldebtw'
WHERE
	"type"='btw' 
AND
  "ccode" NOT LIKE '5d'

UNION ALL

SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,max(t."value") As "rekening"
	,'Afronding: ' ||  CAST("ccode" AS char(2))
	 As "omschrijving"
	,ROUND(SUM("bedrag")) - (SUM("bedrag"))
	 As "bedrag"
FROM
	"vw_btwbase"
LEFT JOIN
    "vw_btwtarieven" As t
ON  
    t."key"='rkg_betaaldebtw'
WHERE
	"type"='btw' 
AND
  "ccode" NOT LIKE '5d'
GROUP BY
	"boekjaar","periode","ccode"

UNION ALL

SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,max(t."value") As "rekening"
	,'Afronding BTW groep: ' || CAST("ccode" AS char(2)) 
	 As "omschrijving"
	,(ROUND(SUM("bedrag")) - (SUM("bedrag"))) * -1
	 As "bedrag"
FROM
	"vw_btwbase"
LEFT JOIN
  "vw_btwtarieven" As t
ON  
  t."key"='rkg_divopbrengsten'
WHERE
	"type"='btw' 
AND
  "ccode" NOT LIKE '5d'
GROUP BY
	"boekjaar","periode","ccode"
;



-- ------------------------------------------------
-- 5d berekeningen
-- ------------------------------------------------

CREATE  VIEW "vw_btw5dbedragen" AS 

-- Deze view moet in samenhang met de aggregatie in "vw_btw5d" 3 soorten records per boekjaar tonen:
--   1. Het totaalsaldo verkopen_verlegdebtw: 1e bedragen van grootboekrekening(en) met key 'verkopen_verlegdebtw'
--   1a. afgeleid van 2 een BTW bedrag, 19% omdat verlegde omzet in de categorie van 6% denkelijk niet voorkomt??!! (nog nakijken)
--   2. Het totaal afgedragen en nog af te dragen betaalde BTW: de positieve 5e bedragen
--   3. Het alreeds teruggevorderde bedrag 5d regeling: 5d

SELECT
  b."boekjaar"
  ,b."periode"
  ,CAST('1e' As char(2)) As "ccode"
  ,ROUND(SUM("bedrag")) As "verlegdeomzet"
  ,CASE WHEN COALESCE(SUM("bedrag"),0) = 0 THEN 0
   ELSE ROUND(SUM("bedrag") * ( max( CAST(t."value" As decimal) )/100) ) END
     As "btwbedrag"
FROM
  "vw_boekregels" As b
LEFT JOIN
    "vw_btwtarieven" As t
ON
    t."key"='btwverkoophoog'
WHERE
  b."btwkey"='verkopen_verlegdebtw'
GROUP BY
  b."boekjaar",b."periode"

UNION ALL

SELECT
    b."boekjaar"
  ,b."periode"
  ,CAST('5d' As char(2)) As "ccode"
  ,0 As "verlegdeomzet"
  ,CASE WHEN SUM("bedrag") < 0 THEN 0
   ELSE SUM(ROUND("bedrag")) END
  As "btwbedrag"
FROM
  "vw_boekregels" As b
WHERE
  b."btwkey"='rkg_betaaldebtw'
AND
  b."joorsprong"='5dregeling'
GROUP BY
  b."boekjaar",b."periode"

UNION ALL

SELECT
  "boekjaar"
  ,"periode"
  ,CAST('5e' As char(2)) As "ccode"
  ,0 As "verlegdeomzet"
  ,SUM(
    CASE WHEN "btwbedrag" < 0 
    THEN 0 ELSE "btwbedrag" END)
  As "btwbedrag"
FROM
  "vw_btw"
WHERE 
  "ccode"='5e'
GROUP BY
  "boekjaar","periode"
;



CREATE  VIEW "vw_btw5d" AS
SELECT
	"boekjaar"
	,"ccode"
	,ROUND(SUM("verlegdeomzet")) As "verlegdeomzet"
	,ROUND(SUM("btwbedrag")) As "btwbedrag"
FROM
	"vw_btw5dbedragen"
GROUP BY
	"boekjaar","ccode"
ORDER BY
	"boekjaar","ccode"
;



-- --------------------------------------------
-- Lijst grootboeknummers die niet in pup
-- verschijnen van meest gebruikte (popular)
-- grootboekrekeningen tijdens inboeken
--
CREATE  VIEW "vw_notinpopular" AS
SELECT
  b."key" As "key"
  , g."nummer" As "value"
FROM
  "btwkeys" As b
INNER JOIN
  "vw_grootboekstam" As g
ON
  b."key"=g."btwkey"
WHERE
  b."key" LIKE 'rkg%btw%'

UNION

SELECT
  "naam"
  ,"grootboekrekening"
FROM
  "dagboeken"
WHERE
  "type" NOT IN ('begin','memo')
;

