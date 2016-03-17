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
$schema['dagboeken'] =<<<EOT

INSERT INTO "dagboeken" VALUES (1, 'begin', 'begin', 'Beginbalans', 0, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (2, 'memo', 'memo', 'Memoriaal', 0, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (3, 'kas', 'kas', 'Kasboek', 1000, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (4, 'bank', 'rabo', 'Rabobank', 1050, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (5, 'inkoop', 'inkoop', 'Inkoopboek', 1600, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (6, 'verkoop', 'verkoop', 'Verkoopboek', 1200, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES (7, 'pin', 'pin', 'Pinbetalingen', 2020, 0, 0.00, 0);

EOT;

//
// Dumping data for table "grootboekstam"
//
$schema['grootboekstam'] =<<<EOT

INSERT INTO "grootboekstam" VALUES (1, 100, 0, 1, 0, 0, 1, 'Inventaris');
INSERT INTO "grootboekstam" VALUES (2, 150, 0, 1, 0, 0, 5, 'Afschrijving inventaris');
INSERT INTO "grootboekstam" VALUES (3, 200, 0, 1, 0, 0, 1, 'Transportmiddelen');
INSERT INTO "grootboekstam" VALUES (4, 250, 0, 1, 0, 0, 5, 'Afschrijving transportmiddelen');
INSERT INTO "grootboekstam" VALUES (5, 300, 0, 1, 0, 0, 1, 'Software');
INSERT INTO "grootboekstam" VALUES (6, 350, 0, 1, 0, 0, 5, 'Afschrijving software');
INSERT INTO "grootboekstam" VALUES (7, 500, 0, 1, 0, 0, 5, 'Leningen');
INSERT INTO "grootboekstam" VALUES (8, 900, 0, 1, 0, 0, 5, 'Kapitaal/prive');
INSERT INTO "grootboekstam" VALUES (9, 1000, 0, 1, 0, 0, 5, 'Kas');
INSERT INTO "grootboekstam" VALUES (10, 1050, 0, 1, 0, 0, 5, 'Rabobank');
INSERT INTO "grootboekstam" VALUES (11, 1060, 0, 1, 0, 0, 5, 'Rekening courant prive');
INSERT INTO "grootboekstam" VALUES (12, 1100, 0, 1, 0, 0, 5, 'Nog te ontvangen');
INSERT INTO "grootboekstam" VALUES (13, 1200, 0, 1, 0, 0, 5, 'Debiteuren');
INSERT INTO "grootboekstam" VALUES (14, 1500, 0, 1, 0, 0, 5, 'Nog te betalen');
INSERT INTO "grootboekstam" VALUES (15, 1600, 0, 1, 0, 0, 5, 'Crediteuren');
INSERT INTO "grootboekstam" VALUES (16, 1999, 0, 3, 3, 0, 5, 'Totaal activa/passiva');
INSERT INTO "grootboekstam" VALUES (17, 2010, 0, 1, 0, 0, 5, 'Kruisposten');
INSERT INTO "grootboekstam" VALUES (18, 2020, 0, 1, 0, 0, 5, 'Betalingen onderweg');
INSERT INTO "grootboekstam" VALUES (19, 2099, 0, 3, 1, 0, 5, 'Totaal hulprekeningen');
INSERT INTO "grootboekstam" VALUES (20, 2110, 0, 1, 0, 0, 5, 'Af te dragen BTW hoog tarief');
INSERT INTO "grootboekstam" VALUES (21, 2120, 0, 1, 0, 0, 5, 'Af te dragen BTW laag tarief');
INSERT INTO "grootboekstam" VALUES (22, 2200, 0, 1, 0, 0, 5, 'Te ontvangen BTW');
INSERT INTO "grootboekstam" VALUES (23, 2300, 0, 1, 0, 0, 5, 'Betaalde BTW');
INSERT INTO "grootboekstam" VALUES (24, 2399, 0, 3, 1, 0, 5, 'Totaal periodieke BTW');
INSERT INTO "grootboekstam" VALUES (25, 2500, 0, 1, 0, 0, 5, 'Verschillenrekening');
INSERT INTO "grootboekstam" VALUES (26, 2899, 0, 3, 3, 0, 5, 'Totaal tussenrekeningen');
INSERT INTO "grootboekstam" VALUES (27, 3010, 0, 1, 0, 0, 5, 'Voorraad');
INSERT INTO "grootboekstam" VALUES (28, 3999, 0, 3, 7, 0, 5, 'Totaal balans');
INSERT INTO "grootboekstam" VALUES (29, 4010, 0, 2, 0, 0, 5, 'Personeelskosten');
INSERT INTO "grootboekstam" VALUES (30, 4020, 0, 2, 0, 0, 1, 'Uitbesteed werk');
INSERT INTO "grootboekstam" VALUES (31, 4100, 0, 2, 0, 0, 1, 'Huisvestingskosten');
INSERT INTO "grootboekstam" VALUES (32, 4200, 0, 2, 0, 0, 1, 'Documentatiekosten');
INSERT INTO "grootboekstam" VALUES (33, 4210, 0, 2, 0, 0, 1, 'Klein apparatuur');
INSERT INTO "grootboekstam" VALUES (34, 4220, 0, 2, 0, 0, 1, 'Atelierkosten');
INSERT INTO "grootboekstam" VALUES (35, 4230, 0, 2, 0, 0, 1, 'Kantoorkosten');
INSERT INTO "grootboekstam" VALUES (36, 4235, 0, 2, 0, 0, 1, 'Kantinekosten');
INSERT INTO "grootboekstam" VALUES (37, 4240, 0, 2, 0, 0, 1, 'Telefoonkosten');
INSERT INTO "grootboekstam" VALUES (38, 4245, 0, 2, 0, 0, 1, 'Internetkosten');
INSERT INTO "grootboekstam" VALUES (39, 4250, 0, 2, 0, 0, 1, 'Portikosten');
INSERT INTO "grootboekstam" VALUES (40, 4300, 0, 2, 0, 0, 1, 'Afschrijvingen');
INSERT INTO "grootboekstam" VALUES (41, 4350, 0, 2, 0, 0, 1, 'Bankkosten');
INSERT INTO "grootboekstam" VALUES (42, 4400, 0, 2, 0, 0, 1, 'Reiskosten');
INSERT INTO "grootboekstam" VALUES (43, 4490, 0, 2, 0, 0, 1, 'Diverse kosten');
INSERT INTO "grootboekstam" VALUES (44, 4499, 0, 3, 3, 0, 5, 'Totaal algemene kosten');
INSERT INTO "grootboekstam" VALUES (45, 4500, 0, 2, 0, 0, 1, 'Promotiekosten');
INSERT INTO "grootboekstam" VALUES (46, 4510, 0, 2, 0, 0, 1, 'Acquisitiekosten');
INSERT INTO "grootboekstam" VALUES (47, 4520, 0, 2, 0, 0, 1, 'Productiekosten');
INSERT INTO "grootboekstam" VALUES (48, 4600, 0, 2, 0, 0, 1, 'Inkopen');
INSERT INTO "grootboekstam" VALUES (49, 4699, 0, 3, 3, 0, 5, 'Totaal specifieke kosten');
INSERT INTO "grootboekstam" VALUES (50, 4900, 0, 2, 0, 0, 1, 'Voordelig/nadelig saldo');
INSERT INTO "grootboekstam" VALUES (51, 4999, 0, 3, 5, 0, 5, 'Totaal kosten');
INSERT INTO "grootboekstam" VALUES (52, 8010, 0, 2, 0, 0, 3, 'Verkopen');
INSERT INTO "grootboekstam" VALUES (53, 8199, 0, 3, 3, 0, 5, 'Totaal verkopen');
INSERT INTO "grootboekstam" VALUES (54, 8410, 0, 2, 0, 0, 5, 'Rente opbrengsten');
INSERT INTO "grootboekstam" VALUES (55, 8900, 0, 2, 0, 0, 5, 'Diverse opbrengsten');
INSERT INTO "grootboekstam" VALUES (56, 8980, 0, 3, 3, 0, 5, 'Totaal diverse opbrengsten');
INSERT INTO "grootboekstam" VALUES (57, 8985, 0, 3, 5, 0, 5, 'Totaal opbrengsten');
INSERT INTO "grootboekstam" VALUES (58, 8990, 0, 3, 7, 0, 5, 'Totaal verlies en winst');
INSERT INTO "grootboekstam" VALUES (59, 8999, 0, 3, 8, 0, 5, 'Totaal administratie');
INSERT INTO "grootboekstam" VALUES (60, 8020, 0, 2, 0, 0, 3, 'Verkopen Atelier');
INSERT INTO "grootboekstam" VALUES (61, 4099, 0, 3, 3, 0, 5, 'Totaal personeelskosten');
INSERT INTO "grootboekstam" VALUES (62, 8100, 0, 2, 0, 0, 4, 'Verkopen kunst laag tarief');

EOT;

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
INSERT INTO "stamgegevens" VALUES (21, 2008,'e',5,'Rekening bankboek','rkg_bankboek','1050','');
INSERT INTO "stamgegevens" VALUES (20, 2008,'e',3,'Rekening kasboek','rkg_kasboek','1000','');
INSERT INTO "stamgegevens" VALUES (19, 2008,'e',13,'Rekening pinbetalingen','rkg_pinbetalingen','2020','');
INSERT INTO "stamgegevens" VALUES (18, 2008,'g',3,'BTW percentage laag','btwlaag','6','');
INSERT INTO "stamgegevens" VALUES (17, 2008,'g',1,'BTW percentage hoog','btwhoog','19','');
INSERT INTO "stamgegevens" VALUES (14, 2008,'',0,'Verschillenrekening','rkg_verschillen','2500','');
INSERT INTO "stamgegevens" VALUES (13, 2008,'e',17,'Rekening BTW verkoop laag','rkg_btwverkooplaag','2120','');
INSERT INTO "stamgegevens" VALUES (12, 2008,'e',15,'Rekening BTW verkoop hoog','rkg_btwverkoophoog','2110','');
INSERT INTO "stamgegevens" VALUES (8, 2008,'e',9,'Rekening debiteuren','rkg_debiteuren','1200','');
INSERT INTO "stamgegevens" VALUES (9, 2008,'e',11,'Rekening crediteuren','rkg_crediteuren','1600','');
INSERT INTO "stamgegevens" VALUES (10, 2008,'e',21,'Rekening BTW inkopen','rkg_btwinkopen','2200','');
INSERT INTO "stamgegevens" VALUES (7, 2008,'e',1,'Rekening kapitaal/prive','rkg_kapitaalprive','900','');
INSERT INTO "stamgegevens" VALUES (23, 2008,'e',19,'Rekening BTW Privegebruik','rkg_btwprivegebruik','0','');
INSERT INTO "stamgegevens" VALUES (24, 2008,'e',27,'Rekening Diverse Opbrengsten','rkg_divopbrengsten','8900','');
INSERT INTO "stamgegevens" VALUES (25, 2008,'e',23,'Rekening betaalde BTW','rkg_betaaldebtw','2300','De tussenrekening waarop enerzijds het saldo van de BTW rekeningen en anderszijds de BTW afdracht wordt geboekt.');
INSERT INTO "stamgegevens" VALUES (26, 2008,'e',7,'Rekening Prive rekeningcourant','rkg_priverekeningcourant','1060','');
INSERT INTO "stamgegevens" VALUES (27, 2008,'e',30,'Omslagrekening Balans/VW', 'omslag', '4000', 'Bepaal vanaf welk rekeningnummer de Balansrekeningen eindigen en de VenW rekeningen beginnen.');

EOT;

//
// Dumping data for table "voorkeuren"
//
$schema['voorkeuren'] =<<<EOT

INSERT INTO "voorkeuren" VALUES (1,'Facturen tonen in debiteuren/crediteurenstam','facturen_tonen','true');
INSERT INTO "voorkeuren" VALUES (2, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');

EOT;

/* __END__ */
