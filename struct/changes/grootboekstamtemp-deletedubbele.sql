-- Toon alle rijen in grootboekstamtemp onder elkaar:
--  SELECT * FROM grootboekstamtemp
--  ORDER BY nummer,boekjaar
--
-- Selecteer als volgt uit:
-- - Van de meeste records zullen er 3 gelijke zijn, verwijder daarvan de 2 nieuwste.
-- - Zijn er 2 nieuwere, verwijder dan de nieuwste; is er 1 nieuwere dan laten staan.
-- - Is er een oudere maar geen nieuwere dan is de oudere in nieuwe jaargangen
--   verwijderd. Kopieer dan het oudere naar 1 jaar jonger en zet "active" op 0.
--
-- 'Verwijderen' wil zeggen: noteer de "id" en verwijder die records, zoals hieronder.
--
-- In de huidige ML "administratie" geeft dit het volgende resultaat:

DELETE FROM "grootboekstamtemp"
WHERE "id" IN
(65,129,66,130,67,131,68,132,69,133,70,134,71,135,72,136,73,137,74,138,75,139,192,76
 ,140,77,141,78,142,79,143,80,144,81,145,82,146,83,147,84,148,85,149,86,150,87,151,88
 ,152,89,153,90,154,91,155,92,156,93,157,94,158,125,189,95,159,96,160,97,161,98,162,99
 ,163,100,164,101,165,102,166,103,167,104,168,105,169,106,170,107,171,108,172,109,173
 ,110,174,111,175,112,176,113,177,114,178,115,179,116,180,124,188,190,191,181,118,182
 ,119,183,120,184,121,185,122,186,123,187)

