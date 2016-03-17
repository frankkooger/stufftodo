CREATE OR REPLACE FUNCTION func_kostenmatrix(IN pnummer integer) RETURNS TABLE("ID" int, "naam" character varying) AS
$BODY$
TRUNCATE TABLE "tempkp";

INSERT INTO "tempkp"
SELECT * FROM "vw_kostenmatrix" WHERE "IDa"=$1;

SELECT DISTINCT "IDa" As "ID", "naama" As "Naam" FROM "tempkp"
UNION
SELECT "IDb", "naamb" FROM "tempkp"
UNION
SELECT "IDc", "naamc" FROM "tempkp"
UNION
SELECT "IDd", "naamd" FROM "tempkp"
UNION
SELECT "IDe", "naame" FROM "tempkp"
ORDER BY "ID";

$BODY$
LANGUAGE 'sql' VOLATILE
ROWS 100;
ALTER FUNCTION func_kostenmatrix(IN integer) OWNER TO "www";

-- SELECT * FROM func_kostenmatrix(90000);
