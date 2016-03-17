<?php // vim: syntax=php so=100
/*
 * Dit bestand bevat het template voor het vullen van een mysql administratie.
 * Hiermee ontstaat een basis administratie met grootboekrekeningschema,
 * dagboeken en stamgegevens. Gebruiker kan het vervolgens naar eigen inzicht
 * aanpassen of hiermee verder gaan.
 *
 * Er bestaan meerdere van dit soort templates. Het verschil zit in het meer of
 * minder uitgebreide grootboekrekeningschema.
 *
 * Dit template is versie 'algemeen uitgebreid'
 *
 * Deze versie is sqlversie 1.3.2
 *
 */

// TODO de hier gebruikte manier van invoegen werkt alleen voor mysql en niet
// voor sqlite. sqlite wil alle INSERT regels als aparte INSERT querys en niet
// samengevoegd met komma's

$schema = array();

//
// Dumping data for table "btwaangiftelabels"
//
$schema['btwaangiftelabels'] =<<<EOT

INSERT INTO "btwaangiftelabels" VALUES ('rkg_btwinkopen', '5b. Voorbelasting');
INSERT INTO "btwaangiftelabels" VALUES ('rkg_btwverkoophoog', '1a. Leveringen/diensten belast met hoog tarief');
INSERT INTO "btwaangiftelabels" VALUES ('rkg_btwverkooplaag', '1b. Leveringen/diensten belast met laag tarief');
INSERT INTO "btwaangiftelabels" VALUES ('verkopen_verlegd', '1e. Leveringen/diensten verlegde BTW');
INSERT INTO "btwaangiftelabels" VALUES ('subtotaal5a', '5a. Verschuldigde omzetbelasting');
INSERT INTO "btwaangiftelabels" VALUES ('totaal5e', '5e. Totaal');
INSERT INTO "btwaangiftelabels" VALUES ('subtotaal5c', '5c. Subtotaal: 5a min 5b');
INSERT INTO "btwaangiftelabels" VALUES ('vermindering5d', '5d. Vermindering volgens kleinondernemersregeling');

EOT;

//
// Dumping data for table "dagboeken"
//

//
// Dumping data for table "grootboekstam"
//

//
// Dumping data for table "meta"
//
$schema['meta'] =<<<EOT

INSERT INTO "meta" VALUES ('versie','1.0.0');
INSERT INTO "meta" VALUES ('sqlversie','1.3.2');
INSERT INTO "meta" VALUES ('platform','linux');
EOT;

//
// Dumping data for table "stamgegevens"
//
$jaar = date('Y');
$schema['stamgegevens'] =<<<EOT

INSERT INTO "stamgegevens" VALUES (1, 2008,'a',1,'Naam administratie','adminnaam','Fa. Timmerman','');
INSERT INTO "stamgegevens" VALUES (2, 2008,'a',3,'Contactgegevens','adminomschrijving','Fa. Timmerman, meubels\r\natt. Rogier Timmerman\r\nDwarsbalk 18\r\n1234 ZZ Amsterdam\r\n\r\ntelefoon: 0123 456789\r\nfax: 0123 4455667\r\nmobiel: 062 1234567\r\nemail: rogier@timmerman.biz','');
INSERT INTO "stamgegevens" VALUES (3, 2008,'b',1,'Lopend jaar','lopendjaar','{$jaar}','');
INSERT INTO "stamgegevens" VALUES (4, 2008,'b',3,'Periode van','periodevan','1','');
INSERT INTO "stamgegevens" VALUES (5, 2008,'b',5,'Periode tot','periodetot','4','');
INSERT INTO "stamgegevens" VALUES (6, 2008,'b',7,'Extra periode','periodeextra','5','');
INSERT INTO "stamgegevens" VALUES (22, 2008,'e',25,'Verkopen verlegde BTW','rkg_verkoopverlegd','0','');
INSERT INTO "stamgegevens" VALUES (28, 2008,'e',26,'Verkopen geen BTW','rkg_verkoopgeenbtw','0','');
INSERT INTO "stamgegevens" VALUES (21, 2008,'e',5,'Rekening bankboek','rkg_bankboek','0','');
INSERT INTO "stamgegevens" VALUES (20, 2008,'e',3,'Rekening kasboek','rkg_kasboek','0','');
INSERT INTO "stamgegevens" VALUES (19, 2008,'e',13,'Rekening pinbetalingen','rkg_pinbetalingen','0','');
INSERT INTO "stamgegevens" VALUES (18, 2008,'g',3,'BTW percentage laag','btwlaag','6','');
INSERT INTO "stamgegevens" VALUES (17, 2008,'g',1,'BTW percentage hoog','btwhoog','19','');
INSERT INTO "stamgegevens" VALUES (14, 2008,'',0,'Verschillenrekening','rkg_verschillen','0','');
INSERT INTO "stamgegevens" VALUES (13, 2008,'e',17,'Rekening BTW verkoop laag','rkg_btwverkooplaag','0','');
INSERT INTO "stamgegevens" VALUES (12, 2008,'e',15,'Rekening BTW verkoop hoog','rkg_btwverkoophoog','0','');
INSERT INTO "stamgegevens" VALUES (8, 2008,'e',9,'Rekening debiteuren','rkg_debiteuren','0','');
INSERT INTO "stamgegevens" VALUES (9, 2008,'e',11,'Rekening crediteuren','rkg_crediteuren','0','');
INSERT INTO "stamgegevens" VALUES (10, 2008,'e',21,'Rekening BTW inkopen','rkg_btwinkopen','0','');
INSERT INTO "stamgegevens" VALUES (7, 2008,'e',1,'Rekening kapitaal/prive','rkg_kapitaalprive','0','');
INSERT INTO "stamgegevens" VALUES (23, 2008,'e',19,'Rekening BTW Privegebruik','rkg_btwprivegebruik','0','');
INSERT INTO "stamgegevens" VALUES (24, 2008,'e',27,'Rekening Diverse Opbrengsten','rkg_divopbrengsten','0','');
INSERT INTO "stamgegevens" VALUES (25, 2008,'e',23,'Rekening betaalde BTW','rkg_betaaldebtw','0','De tussenrekening waarop enerzijds het saldo van de BTW rekeningen en anderszijds de BTW afdracht wordt geboekt.');
INSERT INTO "stamgegevens" VALUES (26, 2008,'e',7,'Rekening Prive rekeningcourant','rkg_priverekeningcourant','0','');
INSERT INTO "stamgegevens" VALUES (27, 2008,'e',30,'Omslagrekening Balans/VW', 'omslag', '0', 'Bepaal vanaf welk rekeningnummer de Balansrekeningen eindigen en de VenW rekeningen beginnen.');

EOT;

//
// Dumping data for table "voorkeuren"
//
$schema['voorkeuren'] =<<<EOT

INSERT INTO "voorkeuren" VALUES (1,'Facturen tonen in debiteuren/crediteurenstam','facturen_tonen','true');
INSERT INTO "voorkeuren" VALUES (2, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');

EOT;

/* __END__ */
