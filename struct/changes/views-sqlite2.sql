;

CREATE  VIEW "vw_boekjaar" AS 
SELECT
  "value" As "boekjaar"
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
  ( 
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
      WHERE    "boekjaar"<=(SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar')
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
  s."value"=g."nummer"
LEFT JOIN
  "vw_dagboeken" As d
ON
  g."nummer"=d."grootboekrekening"
WHERE
    s."id" IN
    (
        SELECT MAX("id") FROM "stamgegevens"
        WHERE "boekjaar" <= (SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar')
        GROUP BY "naam"
    )
ORDER BY
    s."code", s."subcode"
; 



CREATE  VIEW "vw_btwkeys" AS
SELECT * FROM
( 
SELECT "id", "key", "type", "actief", "ccode", "acode", "label", "labelstam", "labeldefaults", "boekjaar","active"
  FROM "btwkeys"
WHERE

    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "btwkeys"
      WHERE    "boekjaar"<=(SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar')
      GROUP BY "key"
    )

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
( 
SELECT "id", "key", "type", "actief", "ccode", "acode", "label", "labelstam", "labeldefaults", "boekjaar","active"
  FROM "btwkeys"
WHERE

    "id" IN
    (
      SELECT   max("id") As "id"
      FROM     "btwkeys"
      WHERE    "boekjaar"<=(SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar')
      GROUP BY "key"
    )
    
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
      WHERE    "boekjaar"<=(SELECT "value" FROM "stamgegevens" WHERE "naam"='lopendjaar')
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
JOIN
    "vw_grootboekstam" g
ON
    b."grootboekrekening"=g."nummer"
LEFT JOIN
    "kostenplaatsen" As k
ON
    k."ID"=CASE WHEN b."kostenplaats">0 THEN b."kostenplaats" ELSE g."kostenplaats" END
WHERE
  j."boekjaar"=(SELECT "boekjaar" FROM "vw_boekjaar")
;



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


CREATE  VIEW "vw_grootboekkaart" As
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


CREATE  VIEW "vw_grootboekkaartExp" As
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


CREATE  VIEW "vw_btwtarieven" AS 
SELECT 
	s."naam" As "key"
	,s."value" As "value"
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


CREATE  VIEW "vw_periodes" As
SELECT * FROM "periodes"
ORDER BY "periode";


CREATE  VIEW "vw_partbtw_periode_jbedragen" As 
SELECT
  p."periode" As "periode"
  ,b."boekjaar" As "boekjaar"
  ,f1."bedrag" As "verkopen_partbtwmateriaal"
  ,f2."bedrag" As "verkopen_vrijgesteldebtw"
  ,f3."bedrag" As "inkopen_partbtwmateriaal"
  ,f4."bedrag" As "rkg_btwpartmateriaal"
  ,
   CASE 
    WHEN f1."bedrag" IS NULL THEN f3."bedrag"
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE ((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ) END 
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
  ,
   CASE 
    WHEN f1."bedrag" IS NULL THEN f3."bedrag"
    WHEN f2."bedrag" IS NULL THEN 0 
    ELSE ((f2."bedrag" / (f1."bedrag" + f2."bedrag")) * COALESCE(f4."bedrag",0) ) - COALESCE(f5."bedrag",0)  END
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

SELECT * FROM
( 
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
	,'BTW EGALISATIE periode ' || "periode" || ' naar ' || t."value" 
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
	,'BTW EGALISATIE periode ' || "periode" || ' van ' || "nummer"
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

UNION ALL

SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,max(t."value") As "rekening"
	,'Afronding: ' ||  "ccode"
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
GROUP BY
	"boekjaar","periode","ccode"

UNION ALL

SELECT 
	"boekjaar"
	,"periode"
	,"ccode"
	,max(t."value") As "rekening"
	,'Afronding BTW groep: ' || "ccode"
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
GROUP BY
	"boekjaar","periode","ccode"
;




CREATE  VIEW "vw_btw5dbedragen" AS 


SELECT
  b."boekjaar"
  ,b."periode"
  ,'1e' As "ccode"
  ,ROUND(SUM("bedrag")) As "verlegdeomzet"
  ,CASE WHEN COALESCE(SUM("bedrag"),0) = 0 THEN 0
   ELSE ROUND(SUM("bedrag") * ( max( t."value" )/100) ) END
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
  ,'5d'  As "ccode"
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
  ,'5e' As "ccode"
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


