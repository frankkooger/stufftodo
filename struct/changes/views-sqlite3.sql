﻿
-- ---------------------------------------
-- SQLVERSIE views
-- ---------------------------------------

-- 20 aug 2011
-- 09 jul 2013
-- Bijgewerkt tot 1.17.0
-- 11 okt 2014
-- database versienummer bijgewerkt tot 1.16.7 i.v.m. toevoegen tabel "kostenplaatsen"
-- alle code en views hieromheen moeten nog ontwikkeld worden.

-- Bijgewerken tot 1 hoger sub nummer indien de code is aangepast aan vw_stamgegevens
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
--     Hiervoor hebben we een script gemaakt 'viewsalter.sh' dat voor elke CREATE een ALTER regel maakt.
--   maak een DOMAIN "decimal" aan As numeric
-- Firebird:
--   Eindig elk statement met een COMMIT, als je dat niet doet kunnen net aangemaakte
--   views nog niet worden gezien door navolgende die erop leunen
--   Creeer velddefinities in elk statement waarin UNIONs of 'SELECT * FROM (SELECT..' voorkomen. Dit zou in versie 2.1
--   niet meer nodig moeten zijn maar nog niet gemerkt.
--   SUBSTRING("type",1,3) is in FB: SUBSTRING("type" FROM 1 FOR 3)
-- SQLITE:
--   Geen eigenaardigheden
-- MYSQL:
--   Bij Mysql zijn geen subselects toegestaan in View statements. Dit betekent dat subselects aparte 
--   views zijn die worden opgeroepen door een andere view.
--   Er moet een kopregel voorkomen die standaard ANSI sql instelt.
--   als echter mysql in de config de [mysqld] instelling 'sql-mode="ANSI" heeft, dan moet deze kopregel 
--   worden uitgecomment.
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
  round(SUM(br."bedrag"),2) As "Regelsaldo"
  ,round(bs."saldo",2) As "Saldisaldo" 
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
SELECT
  sub1."id"
  ,sub1."boekjaar" As "historie"
  ,sub1."nummer"
  ,sub1."kostenplaats"
  ,sub1."active"
  ,sub1."populariteit"
  ,sub1."type"
  ,sub1."nivo"
  ,sub1."verdichting"
  ,sub1."naam"
  ,sub1."btwkey"
  ,sub1."btwdefault"
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
  ,st."kostenplaats"
  ,st."active"
  ,st."populariteit"
  ,st."type"
  ,st."nivo"
  ,st."verdichting"
  ,st."naam"
  ,st."btwkey"
  ,st."btwdefault"
  ,round(sa."saldo",2) As "saldo"
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
    ,round("saldo",2) As "saldo"
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
SELECT 
  "id"
  ,"key"
  ,"type"
  ,"actief"
  ,"ccode"
  ,"acode"
  ,"label"
  ,"labelstam"
  ,"labeldefaults"
  ,"boekjaar"
  ,"active"
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
SELECT
  "id"
  ,"key"
  ,"type"
  ,"actief"
  ,"ccode"
  ,"acode"
  ,"label"
  ,"labelstam"
  ,"labeldefaults"
  ,"boekjaar"
  ,"active"
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
	( "ccode" NOT LIKE ''
    AND "type" NOT IN ('sub','tot')
	)
  OR
	( "key" LIKE '%vrijgesteld%'
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
  ,round(j."saldo",2) As "journaalsaldo"
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
 ,round(j."saldo",2) As "saldo"
 ,round(s."saldo",2) As "boekregelsaldo"
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
 ,b."kostenplaats"
 ,b."kostennaam"
 ,b."btwrelatie"
 ,b."factuurrelatie"
 ,b."grootboeknaam"
 ,b."relatie"
 ,b."nummer"
 ,b."boorsprong"
 ,b."dagboekcode"
 ,b."jomschrijving"
 ,b."bomschrijving"
 ,round(b."bedrag",2) As "bedrag"
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
  ,"kostenplaats"
  ,"kostennaam"
  ,MAX("boekdatum") As "boekdatum"
  ,"periode"
  ,"dagboekcode"
  ,"jomschrijving" || CASE WHEN "relatie"<>'' THEN ' (' || "relatie" || ')' ELSE '' END As "jomschrijving"
  ,round(SUM("bedrag"),2) As "bedrag"
FROM
  "vw_boekstuk"
GROUP BY
  "journaalid","journaalpost","grootboekrekening","kostenplaats","kostennaam","periode","dagboekcode","jomschrijving", "relatie"
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
  ,"kostenplaats"
  ,"kostennaam"
  ,"boekdatum"
  ,"periode"
  ,"dagboekcode"
  ,"bomschrijving" || CASE WHEN "relatie"<>'' THEN ' (' || "relatie" || ')' ELSE '' END As "jomschrijving"
  ,round("bedrag",2) As "bedrag"
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
	,round(s."value",2) As "value"
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
  ,round(SUM(b."bedrag"),2) As "bedrag"
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
  ,round(SUM("bedrag"),2) As "bedrag"
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
  ,round(SUM("bedrag"),2) As "bedrag"
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
  ,round(f1."bedrag",2) As "verkopen_partbtwmateriaal"
  ,round(f2."bedrag",2) As "verkopen_vrijgesteldebtw"
  ,round(f3."bedrag",2) As "inkopen_partbtwmateriaal"
  ,round(f4."bedrag",2) As "rkg_btwpartmateriaal"
  ,CASE 
    WHEN f1."bedrag" IS NULL THEN round(f3."bedrag",2)
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE round(((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ),2) END 
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
  ,round(COALESCE(f1."bedrag",0),2) As "verkopen_partbtwmateriaal"
  ,round(COALESCE(f2."bedrag",0),2) As "verkopen_vrijgesteldebtw"
  ,round(COALESCE(f3."bedrag",0),2) As "inkopen_partbtwmateriaal"
  ,round(COALESCE(f4."bedrag",0),2) As "rkg_btwpartmateriaal"
  ,round(COALESCE(f5."bedrag",0),2) As "dervingbtw_partbtwmateriaal"
  ,CASE 
    WHEN f1."bedrag" IS NULL THEN round(f3."bedrag",2)
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE round(((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ) - COALESCE(f5."bedrag",0),2)  END
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
	,round(SUM(b."bedrag"),2) As "bedrag"
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
  ,round(j."dervingbtw_bedrag",2) * -1
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
	,round(SUM("omzet"),2) As "omzet"
	,round(SUM("btwbedrag"),2) As "btwbedrag"
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
	,round(SUM("omzet"),2) As "omzet"
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
	,round(SUM("omzet"),0) As "omzet"
	,round(SUM("btwbedrag"),0) As "btwbedrag"
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
  ,CAST('5c' As char(2)) As "ccode"
  ,0 As "verlegdeomzet"
  ,SUM(
    CASE WHEN "btwbedrag" < 0 
    THEN 0 ELSE "btwbedrag" END)
  As "btwbedrag"
FROM
  "vw_btw"
WHERE 
  "ccode"='5c'
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


-- Deze view vervangt "vw_btw5dbedragen" en "vw_btw5d"
-- De view verzamelt wel het btwbedrag van verlegde omzet
-- maar niet de omzetbedragen zelf. Ook kijkt de view nog
-- niet naar reeds verrekende 5d bedragen die wellicht eerder
-- in het jaar al zijn verrekend. Dit laatste moet er nog in om
-- te voorkomen dat de view alleen aan het einde van het jaar
-- gebruikt kan worden zonder eerder in het jaar al 5d te
-- kunnen verrekenen. 
--
CREATE VIEW vw_btw5d_calculus AS
SELECT
  SUM(btwbedrag) As "btwbedrag"
  ,SUM(verlegdebtw) As "verlegdebtw"
FROM

( --x
  SELECT
    btwbedrag
    ,0 As verlegdebtw
  FROM
  ( --xx  
  SELECT
    SUM(btwbedrag) As btwbedrag
  FROM
    vw_btw
  WHERE
    ccode='5c'
  AND
    periode >= CAST((SELECT "value" FROM "vw_stamgegevens" WHERE "naam"='periodetot') As integer)
  ) xx  
  WHERE
    btwbedrag > 0

  UNION ALL

  SELECT
    SUM(btw) As btwbedrag
    ,0 As verlegdebtw
  FROM
    btwaangiftes
  WHERE
    boekjaar=(SELECT boekjaar FROM vw_boekjaar)
  AND
    periode < CAST((SELECT "value" FROM "vw_stamgegevens" WHERE "naam"='periodetot') As integer)
  AND
    acode='5c'
  AND
    btw>0

UNION ALL

  SELECT
    0 As btwbedrag
    ,verlegdebtw
  FROM
  ( --xy
  SELECT
    0 As btwbedrag
    ,SUM(btwbedrag) As verlegdebtw
  FROM
    vw_btw
  WHERE
    ccode='2a'
  AND
    periode >= CAST((SELECT "value" FROM "vw_stamgegevens" WHERE "naam"='periodetot') As integer)
  ) xy  
  WHERE
    btwbedrag > 0

  UNION ALL

  SELECT
    0 As btwbedrag
    ,COALESCE(SUM(btw),0) As verlegdebtw
  FROM
    btwaangiftes
  WHERE
    boekjaar=(SELECT boekjaar FROM vw_boekjaar)
  AND
    periode < CAST((SELECT "value" FROM "vw_stamgegevens" WHERE "naam"='periodetot') As integer)
  AND
    acode='2a'
  AND
    btw>0
  
) x
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


-- --------------------------------------------
-- View kostenplaatsen

CREATE VIEW "vw_kostenmatrix" AS
SELECT 
   a."ID" As "IDa", a."naam"  As "naama"
  ,b."ID" As "IDb", b."naam"  As "naamb"
  ,c."ID" As "IDc", c."naam"  As "naamc"
  ,d."ID" As "IDd", d."naam"  As "naamd"
  ,e."ID" As "IDe", e."naam"  As "naame"
  ,f."ID" As "IDf", f."naam"  As "naamf"
  ,g."ID" As "IDg", g."naam"  As "naamg"
  ,h."ID" As "IDh", h."naam"  As "naamh"
FROM "kostenplaatsen" As a
  LEFT JOIN "kostenplaatsen" As b ON a."ID" = b."parentID"
  LEFT JOIN "kostenplaatsen" As c ON b."ID" = c."parentID"
  LEFT JOIN "kostenplaatsen" As d ON c."ID" = d."parentID"
  LEFT JOIN "kostenplaatsen" As e ON d."ID" = e."parentID"
  LEFT JOIN "kostenplaatsen" As f ON e."ID" = f."parentID"
  LEFT JOIN "kostenplaatsen" As g ON f."ID" = g."parentID"
  LEFT JOIN "kostenplaatsen" As h ON g."ID" = h."parentID"
ORDER BY a."ID", b."ID", c."ID", d."ID", e."ID", f."ID", g."ID", h."ID"
;

