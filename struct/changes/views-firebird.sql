
-- ---------------------------------------
-- SQLVERSIE views
-- ---------------------------------------

-- 20 aug 2011
-- 09 jul 2013
-- Bijgewerkt tot 1.16.5
-- 11 okt 2014
-- database versienummer bijgewerkt tot 1.16.7 i.v.m. toevoegen tabel "kostenplaatsen"
-- alle code en views hieromheen moeten nog ontwikkeld worden.
--
-- Bijgewerken tot 1 hoger sub nummer indien de code is aangepast aan vw_stamgegevens
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! BELANGRIJK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
-- !!! BEFORE USING FIREBIRD !!!
-- Too many Contexts of Relation/Procedure/Views. Maximum allowed is 255
--
-- De vw_btw en ook al vw_btwbedragen1 geeft deze foutmelding nadat de partbtw UNION
-- aan vw_btwbase was toegevoegd.
-- Mogelijke oplossingen zijn:
--  de querys vereenvoudigen
--  delen van de querys in Stored Procedures laten uitvoeren. deze draaien in een eigen Context.
--  De laatste kan niet in Firebird <= 2.1, waarschijnlijk wel in 2.5
--  Om 2.5 te kunnen installeren is echter linux kernel <= 2.6.34 nodig
--  Als niet aan deze voorwaarde is voldaan, heeft het geen zin om de Firebird versie te gebruiken.
--  Tenzij de partBtw optie niet nodig is. Dan kunnen de partBtw views eruit blijven.
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! BELANGRIJK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
-- Onderstaande views vormen de input voor de vernieuwde BTW module in
-- openadmin.nl waarin we veel meer logic laten afhandelen door de database en
-- minder in de code.
-- Omdat mysql geen subqueries toelaat in een view moeten we met aparte
-- views per query werken en die in 1 query aggregeren
-- Voor onderstaande views komt dat wel goed uit omdat het de modulariteit
-- en de mogelijkheid om iets toe te voegen/ te veranderen ermee groter wordtn
--
-- De versie's voor sqlite, postgresql en mysql hebben allen min of meer grote verschillen:
-- Postgres: 
--   ALTER elke VIEW aan OWNER webuser
--   maak een DOMAIN "decimal" aan As numeric
-- Firebird:
--   Eindig elk statement met een COMMIT, als je dat niet doet kunnen net aangemaakte
--   views nog niet worden gezien door navolgende die erop leunen
--   Creeer velddefinities in elk statement waarin UNIONs voorkomen. Dit zou in versie 1.5
--   niet meer nodig moeten zijn maar nog niet gemerkt.
-- SQLITE:
--   Geen eigenaardigheden
-- MYSQL:
--   Bij Mysql zijn geen subselects toegestaan in View statements. Dit betekent dat subselects aparte 
--   views zijn die worden opgeroepen door een andere view.
--   Er moet een kopregel voorkomen die standaard ANSI sql instelt.
--
-- Bedenk dat voor type 'Signed' een Domain is opgenomen in alle databases.
-- Normaal wordt dit gekend als 'Integer' maar mysql kent 'Signed'
--
-- Voor het type 'decimal' is een Domain As 'numeric' opgenomen in Postgresql
-- Dit om de casts gelijk te kunnen stellen met andere databases
--

CREATE VIEW "vw_boekjaar"
AS 
SELECT
  CAST("value" As Signed) As "boekjaar"
FROM
  "stamgegevens"
WHERE
  "naam"='lopendjaar';
COMMIT;


CREATE VIEW "vw_boekregelsaldi" 
("Regelsaldo","Saldisaldo","boekjaar","grootboekrekening") AS
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
COMMIT;  



CREATE VIEW "vw_grootboekstam"
("id","historie","nummer","active","populariteit","type","nivo","verdichting","naam","btwkey","btwdefault") As
SELECT sub1."id", sub1."boekjaar" As "historie", sub1."nummer", sub1."active", sub1."populariteit"
      ,sub1."type", sub1."nivo", sub1."verdichting", sub1."naam", sub1."btwkey", sub1."btwdefault"
FROM
	"grootboekstam" As sub1
JOIN
(
	SELECT MAX("boekjaar") As "boekjaar", "nummer" FROM "grootboekstam"
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
COMMIT;



CREATE VIEW "vw_grootboekstamsaldo"
AS
SELECT 
  st."id",st."historie" As "historie",st."nummer",st."active",st."populariteit",st."type",st."nivo",st."verdichting",st."naam",st."btwkey",st."btwdefault"
  ,sa."saldo"
  ,sa."boekjaar"
FROM
  "vw_grootboekstam" st
LEFT JOIN
  "grootboeksaldi" sa
ON
  st."nummer"=sa."nummer"
AND
  sa."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar") ;
COMMIT;



CREATE VIEW "vw_dagboeken"
("id","historie","active","type","code","naam","grootboekrekening","boeknummer","saldo","slot") As
SELECT *
FROM
(
SELECT
  g."id"
  ,g."boekjaar" As "historie"
  ,g."active"
  ,g."type"
  ,g."code"
  ,g."naam"
  ,g."grootboekrekening"
  ,g."boeknummer"
  ,g."saldo"
  ,g."slot"
FROM
  "dagboeken" As g
WHERE
  g."id" IN
  (
      select   max(g."id") As "id"
      FROM     "dagboeken" As g
      WHERE    g."boekjaar" <= CAST((SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar') As Signed)
      GROUP BY g."code"
  )
) alias2
WHERE
  "active"=1
ORDER BY "code", "historie";
COMMIT;



CREATE VIEW "vw_stamgegevens"
("id","code","subcode","label","naam","value","boekjaar","grootboekrekening","dagboek") As
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
    s."code", s."subcode";
COMMIT; 



CREATE VIEW "vw_btwkeys"
("id", "key", "type", "actief", "ccode", "acode", "label", "labelstam", "labeldefaults", "boekjaar","active") AS
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
) b ;
COMMIT;



CREATE VIEW "vw_btwrubrieken"
("id", "key","type","actief","ccode","acode","label","labelstam","labeldefaults","boekjaar","active") As
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
  "ccode", "acode" DESC, "key", "boekjaar" DESC ; 
COMMIT;



CREATE VIEW "vw_boekregels"
As
SELECT 
  b."boekregelid"
  ,b."journaalid"
  ,j."journaalpost"
  ,j."boekjaar"
  ,j."periode"
  ,b."datum" As "boekdatum"
  ,j."datum" As "journaaldatum"
  ,b."grootboekrekening"
  ,CASE WHEN b."kostenplaats">0 THEN b."kostenplaats" ELSE g."kostenplaats" END As "kostenplaats"
  ,k."naam" As "kostennaam"
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
LEFT JOIN
    "kostenplaatsen" As k
ON
    k."ID"=CASE WHEN b."kostenplaats">0 THEN b."kostenplaats" ELSE g."kostenplaats" END
WHERE
  j."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar") ;
COMMIT;



-- journaalposten met dagboekinformatie
--
CREATE VIEW "vw_journaalposten"
As
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
  j."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar");
COMMIT;



-- een verzameling boekregels gerangschikt als journaalpost
-- met journaal-gegevens als journaalid en journaalstuk
CREATE VIEW "vw_boekstuk" 
As
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
  b."journaalid", b."boekregelid" ;
COMMIT;


-- met vw_boekstuk is het makkelijk om bepaalde journaalposten op
-- grootboekkaarten te verdichten. Dit is specifiek om te voorkomen dat elke
-- afzonderlijke post op kasbladen op de btw-rekeningen terecht komt.
CREATE VIEW "vw_grootboekkaart"
("journaalid","journaalpost","grootboekrekening","boekdatum","periode","dagboekcode","jomschrijving","bedrag") AS
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
  "grootboekrekening", "periode","journaalid" ;
COMMIT;


-- Als hierboven, echter
-- Als verdichting niet gewenst is, kan deze view worden ingeschakeld.
--
CREATE VIEW "vw_grootboekkaartExp"
("journaalid","journaalpost","grootboekrekening","boekdatum","periode","dagboekcode","jomschrijving","bedrag") AS
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
  "grootboekrekening", "periode","journaalid" ;
COMMIT;


-- View: vw_btwtarieven
--
-- Om deze view in de btw views te laten werken moeten
-- we een extra record in btwkeys opnemen met als
-- key: 'rkg_divopbrengsten', active: 0, type: 'calc'. De rest mag leeg blijven.
-- Dit record is nodig om de rekening diverse opbrengsten, waarop BTW afronding 
-- en evt 5d teruggaaf wordt geboekt, in stamgegevens herkend te maken.
--

-- DROP VIEW vw_btwtarieven;

CREATE VIEW "vw_btwtarieven"
("key","value") AS
SELECT 
	s."naam" As "key"
	,CAST(s."value" As decimal) As "value"
FROM
	"stamgegevens" As s 
WHERE
	s."naam" IN
	('btwverkoophoog','btwverkooplaag','rkg_divopbrengsten','lopendjaar','periodeextra') 
AND
	s."id" IN (
		SELECT MAX("id") FROM "stamgegevens"
		WHERE "boekjaar"<=(SELECT "boekjaar" FROM "vw_boekjaar")
		GROUP BY "naam" 
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
	b."key"=g."btwkey";
COMMIT;



-- ------------------------------------------------
-- Partbtw views
-- ------------------------------------------------

-- Om onderstaande view correct te laten werken moet van de boekregels in de
-- journaalpost die btwcorrectie tussen 2220 en 4620 doet, alleen de 2220
-- boekregel in boorsprong worden gemarkeerd met 'btwcorrectie'. Als dit ook in de
-- 4620 boekregel zou staan dan wordt 4620 in de view niet gezien.

CREATE VIEW "vw_partbtwbedragen"
("boekjaar","periode","grootboekrekening","bedrag","btwkey") As
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
COMMIT;


CREATE VIEW "vw_partbtw_periode"
("boekjaar","periode","bedrag","btwkey") As
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
COMMIT;



CREATE VIEW "vw_partbtw_year"
("boekjaar","bedrag","btwkey") AS
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
COMMIT;


-- Voor onderstaande view is een nieuwe hulptabel "periodes" nodig
-- Deze bestaat in sqlversie 1.9.3
-- Herstel: we hebben hier een view van gemaakt zodat een tabel niet nodig is
-- Dit herstellen we in sqlversie 1.9.3
-- In Firebird kan geen kale SELECT 1 direct gevolgd door een UNION
-- er moet altijd een FROM tussenzitten, in dit geval naar een willekeurige
-- table
-- DIT LATEN WE NU OVER AAN EEN TABEL periodes waarnaar deze view verwijst
-- zodat de naamgeving van de view in het programma gehandhaafd kan blijven.
CREATE VIEW "vw_periodes"
("periode") As
SELECT "periode" FROM "periodes"
ORDER BY "periode";
COMMIT;
/*
SELECT * FROM
(
SELECT 1 As "periode" FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 2 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 3 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 4 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 5 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 6 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 7 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 8 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 9 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 10 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 11 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 12 FROM "meta" WHERE "key"='sqlversie'
UNION ALL
SELECT 13 FROM "meta" WHERE "key"='sqlversie'
) x
ORDER BY "periode";
COMMIT;
*/

CREATE VIEW "vw_partbtw_periode_jbedragen"
("periode","boekjaar","verkopen_partbtwmateriaal","verkopen_vrijgesteldebtw","inkopen_partbtwmateriaal","rkg_btwpartmateriaal","dervingbtw_bedrag") As
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
COMMIT;


-- Een vreemde kronkel in firebird maakt dat met onderstaande view teveel resources worden opgenomen.
-- stored procedures hebben een eigen resource pool dus hebben we bovenstaande select in een SP opgenomen
-- UPDATE
-- Okay, we hebben nu succesvol stored procedures aangemaakt en nu blijkt dat je SP's niet vanuit
-- een view kan oproepen. Dat schijnt vanaf FB 2.5 te kunnen.
-- Ik heb nu al zoveel frustraties met FB(2.1) te verwerken gehad dat ik FB uit mijn lijstje schrap
-- tot kennelijk vs 2.5 wat meer verspreid is. Het zit nu nog niet in Mint en niet in Redhat
-- QUIT!!! (hopenlijk begrijpt Firebird dit wel! Wat een kut programma).

SET TERM @;
CREATE PROCEDURE "proc_partbtw_periode_jbedragen"
RETURNS 
(
  "periode" int
  ,"boekjaar" int
  ,"verkopen_partbtwmateriaal" decimal(12,2)
  ,"verkopen_vrijgesteldebtw" decimal(12,2)
  ,"inkopen_partbtwmateriaal" decimal(12,2)
  ,"rkg_btwpartmateriaal" decimal(12,2)
  ,"dervingbtw_bedrag" decimal(12,2)
) 
AS
BEGIN

FOR
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
  f4."btwkey"='rkg_btwpartmateriaal'

INTO
  :"periode"
  ,:"boekjaar"
  ,:"verkopen_partbtwmateriaal"
  ,:"verkopen_vrijgesteldebtw"
  ,:"inkopen_partbtwmateriaal"
  ,:"rkg_btwpartmateriaal"
  ,:"dervingbtw_bedrag"
DO
BEGIN
    SUSPEND;
END
  
END@
SET TERM ;@
COMMIT;



CREATE VIEW "vw_partbtw_year_jbedragen"
("boekjaar","verkopen_partbtwmateriaal","verkopen_vrijgesteldebtw","inkopen_partbtwmateriaal","rkg_btwpartmateriaal","dervingbtw_partbtwmateriaal","derving_correctie") As
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
COMMIT;


SET TERM @;
CREATE PROCEDURE "proc_partbtw_year_jbedragen"
RETURNS
(
    "boekjaar" INT
    ,"verkopen_partbtwmateriaal" DECIMAL(12,2)
    ,"verkopen_vrijgesteldebtw" DECIMAL(12,2)
    ,"inkopen_partbtwmateriaal" DECIMAL(12,2)
    ,"rkg_btwpartmateriaal" DECIMAL(12,2)
    ,"dervingbtw_partbtwmateriaal" DECIMAL(12,2)
    ,"dervingbtw_correctie" DECIMAL(12,2)
)
AS 
BEGIN

FOR

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
   As "dervingbtw_correctie"
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
  f5."btwkey"='dervingbtw_partbtwmateriaal'

INTO
    :"boekjaar"
    ,:"verkopen_partbtwmateriaal"
    ,:"verkopen_vrijgesteldebtw"
    ,:"inkopen_partbtwmateriaal"
    ,:"rkg_btwpartmateriaal"
    ,:"dervingbtw_partbtwmateriaal"
    ,:"dervingbtw_correctie"
DO
BEGIN
    SUSPEND;
END
  
END@
SET TERM ;@
-- GRANT EXECUTE
-- ON "proc_partbtw_year_jbedragen" TO  WEBUSER WITH GRANT OPTION;
COMMIT;


-- ------------------------------------------------
-- BTW views
-- ------------------------------------------------

CREATE VIEW "vw_btwbase"
("boekjaar","periode","nummer","ccode","type","bedrag") AS
SELECT * FROM
(
SELECT
	b."boekjaar"
	,b."periode"
	,g."nummer"
	,k."ccode"
  ,SUBSTRING(k."type" FROM 1 FOR 3) As "type"
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

/* Onderstaande UNION is de nieuwste versie 1.11.1 en werkt naar behoren
   We moeten hem echter in Firebird uitschakelen omdat met hem erbij
   teveel resources worden gebruikt.

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
*/
) xx
ORDER BY "boekjaar","periode","ccode","nummer";
COMMIT;



CREATE VIEW "vw_btwbedragen0"
("boekjaar","periode","ccode","omzet","btwbedrag") AS
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
COMMIT;



CREATE VIEW "vw_btwbedragen1"
("boekjaar","periode","ccode","omzet","btwbedrag") AS
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
ORDER BY "boekjaar","periode","ccode";
COMMIT;



CREATE VIEW "vw_btw"
("boekjaar","periode","ccode","label","omzet","btwbedrag") AS
SELECT 
	v."boekjaar"
	,v."periode"
	,v."ccode"
	,v."ccode" || '. ' || k."label" As "label"
  ,CASE v."omzet" WHEN 0 THEN NULL ELSE
      CASE WHEN v."omzet"<0 THEN (v."omzet" * -1) ELSE v."omzet" END
   END AS "omzet"
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
	,v."ccode";
COMMIT;



CREATE VIEW "vw_btwjournaal"
("boekjaar","periode","ccode","rekening","omschrijving","bedrag") AS
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
	"boekjaar","periode","ccode";
COMMIT;



CREATE VIEW "vw_btw5dbedragen"
("boekjaar","periode","ccode","verlegdeomzet","btwbedrag") AS

-- Deze view moet in samenhang met de aggregatie in "vw_btw5d" 3 soorten records per boekjaar tonen:
--   1. Het totaalsaldo verkopen_verlegdebtw: 1e bedragen van grootboekrekening(en) met key 'verkopen_verlegdebtw'
--   1a. afgeleid van 2 een BTW bedrag, 19% omdat verlegde omzet in de categorie van 6% denkelijk niet voorkomt??!! (nog nakijken)
--   2. Het totaal afgedragen en nog af te dragen betaalde BTW: de positieve 5e bedragen
--   3. Het alreeds teruggevorderde bedrag 5d regeling: 5d

-- recordtype 2

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
  "boekjaar","periode";
COMMIT;


CREATE VIEW "vw_btw5d"
("boekjaar","ccode","verlegdeomzet","btwbedrag") AS
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
	"boekjaar","ccode";
COMMIT;


-- --------------------------------------------
-- Lijst grootboeknummers die niet in pup
-- verschijnen van meest gebruikte (popular)
-- grootboekrekeningen tijdens inboeken
--
CREATE VIEW "vw_notinpopular" 
("key","value") AS
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

