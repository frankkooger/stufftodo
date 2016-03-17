-- Function: func_kostenmatrix2(integer)

-- DROP FUNCTION func_kostenmatrix2(integer);

CREATE OR REPLACE FUNCTION func_kostenmatrix2(IN pnummer integer)
  RETURNS TABLE(id integer, saldi integer, naam character varying) AS
$BODY$

SELECT * FROM
(
SELECT DISTINCT a."ID" , a."saldi" , a."naam"
   FROM "kostenplaatsen" a
WHERE a."ID"=$1
UNION	SELECT 	b."ID", b."saldi", b."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
WHERE a."ID"=$1
UNION	SELECT 	c."ID", c."saldi", c."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
WHERE a."ID"=$1
UNION	SELECT 	d."ID", d."saldi", d."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
WHERE a."ID"=$1
UNION	SELECT 	e."ID", e."saldi", e."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
UNION	SELECT 	f."ID", f."saldi", f."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
   LEFT JOIN "kostenplaatsen" f ON e."ID" = f."parentID"
UNION	SELECT 	g."ID", g."saldi", g."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
   LEFT JOIN "kostenplaatsen" f ON e."ID" = f."parentID"
   LEFT JOIN "kostenplaatsen" g ON f."ID" = g."parentID"
WHERE a."ID"=$1
) x
WHERE "ID" IS NOT NULL
ORDER BY "ID" 
;

$BODY$
  LANGUAGE 'sql' VOLATILE
  COST 100
  ROWS 130;
ALTER FUNCTION func_kostenmatrix2(integer) OWNER TO webuser;
