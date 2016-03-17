<?php // vim: syntax=php st=100
/*
 * structe voor administratiestructuur. Geschikt voor sqlite3
 *
 * Database: sqlite:/pub/webs/opensaministratie/dbase/administratie
 *
 * Deze versie is sqlversie 1.3.2
 */

// TODO er mag niet meer dan 1 sql statement in een query staan! De INDEX querys moeten in aparte array-leden.

$struct = array();

//
// Table structure for table "boekregelsTrash"
//
$struct['boekregelsTrash'] =<<<EOT

CREATE TABLE "boekregelsTrash" (
  "id" INTEGER,
  "journaalid" INTEGER,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "grootboekrekening" INTEGER default 0,
  "btwrelatie" INTEGER default 0,
  "factuurrelatie" INTEGER default 0,
  "relatie" varchar(32)  default '',
  "nummer" varchar(16)  default '',
  "oorsprong" varchar(16)  default '',
  "bomschrijving" varchar(128)  default '',
  "bedrag" decimal(12,2)  default '0.00'
) ;
  CREATE INDEX  "bt_journaalid" ON "boekregelsTrash" ("journaalid");
  CREATE INDEX  "bt_grootboekrekening" ON "boekregelsTrash" ("grootboekrekening");
  CREATE INDEX  "bt_id" ON "boekregelsTrash" ("id");
EOT;

//
// Table structure for table "boekregels"
//
$struct['boekregels'] =<<<EOT

CREATE TABLE "boekregels" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "grootboekrekening" INTEGER default 0,
  "btwrelatie" INTEGER default 0,
  "factuurrelatie" INTEGER default 0,
  "relatie" varchar(32)  default '',
  "nummer" varchar(16)  default '',
  "oorsprong" varchar(16)  default '',
  "bomschrijving" varchar(128)  default '',
  "bedrag" decimal(12,2)  default '0.00'
) ;
  CREATE UNIQUE INDEX  "br_idboekjaar" ON "boekregels" ("id","boekjaar");
  CREATE INDEX  "br_journaalid" ON "boekregels" ("journaalid");
  CREATE INDEX  "br_grootboekrekening" ON "boekregels" ("grootboekrekening");
EOT;

//
// Table structure for table "btwaangiftelabels"
//
$struct['btwaangiftelabels'] =<<<EOT

CREATE TABLE "btwaangiftelabels" (
  "key" varchar(24)  default '',
  "label" varchar(64)  default ''
) ;
EOT;

//
// Table structure for table "btwaangiftes"
//
$struct['btwaangiftes'] =<<<EOT

CREATE TABLE "btwaangiftes" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER,
  "datum" date  default '1900-01-01',
  "boekjaar" INTEGER default 0,
  "periode" INTEGER default 0,
  "labelkey" varchar(32)  default '',
  "omzet" decimal(12,2)  default '0.00',
  "btw" decimal(12,2)  default '0.00'
) ;
EOT;

//
// Table structure for table "crediteurenstam"
//
$struct['crediteurenstam'] =<<<EOT

CREATE TABLE "crediteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date  default '1900-01-01',
  "code" varchar(16)  default '',
  "naam" varchar(128)  default '',
  "contact" varchar(128)  default '',
  "telefoon" varchar(15)  default '',
  "fax" varchar(15)  default '',
  "email" varchar(64)  default '',
  "adres" varchar(255)  default '',
  "crediteurnummer" varchar(32)  default '',
  "omzet" decimal(12,2)  default '0.00'
) ;
EOT;

//
// Table structure for table "dagboeken"
//
$struct['dagboeken'] =<<<EOT

CREATE TABLE "dagboeken" (
  "id" INTEGER PRIMARY KEY,
  "type" varchar(8)  default '',
  "code" varchar(16)  default '',
  "naam" varchar(64)  default '',
  "grootboekrekening" INTEGER default 0,
  "boeknummer" INTEGER default 0,
  "saldo" decimal(12,2)  default '0.00',
  "slot" INTEGER default 0
) ;
EOT;

//
// Table structure for table "dagboekhistorie"
//
$struct['dagboekhistorie'] =<<<EOT

CREATE TABLE "dagboekhistorie" (
  "code" varchar(12)  default '',
  "journaalid" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "vorigeboeknummer" INTEGER default 0,
  "saldo" decimal(12,2)  default '0.00',
  "huidigeboeknummer" INTEGER default 0,
  "nieuwsaldo" decimal(12,2)  default '0.00'
) ;
EOT;

//
// Table structure for table "debiteurenstam"
//
$struct['debiteurenstam'] =<<<EOT

CREATE TABLE "debiteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date  default '1900-01-01',
  "code" varchar(16)  default '',
  "naam" varchar(128)  default '',
  "contact" varchar(128)  default '',
  "telefoon" varchar(15)  default '',
  "fax" varchar(15)  default '',
  "email" varchar(64)  default '',
  "adres" varchar(255) ,
  "type" INTEGER default 0,
  "omzet" decimal(12,2)  default '0.00'
) ;
EOT;

//
// Table structure for table "eindbalansen"
//
$struct['eindbalansen'] =<<<EOT

CREATE TABLE "eindbalansen" (
  "id" INTEGER PRIMARY KEY,
  "boekdatum" date  default '1900-01-01',
  "boekjaar" INTEGER default 0,
  "saldowinst" decimal(12,2)  default '0.00',
  "saldoverlies" decimal(12,2)  default '0.00',
  "saldobalans" decimal(12,2)  default '0.00'
) ;
EOT;

//
// Table structure for table "eindbalansregels"
//
$struct['eindbalansregels'] =<<<EOT

CREATE TABLE "eindbalansregels" (
  "id" INTEGER PRIMARY KEY,
  "ideindbalans" INTEGER default 0,
  "grootboekrekening" INTEGER default 0,
  "grootboeknaam" varchar(64)  default '',
  "debet" decimal(12,2)  default '0.00',
  "credit" decimal(12,2)  default '0.00',
  "saldo" decimal(12,2)  default '0.00'
) ;
  CREATE INDEX  "ebr_ideindbalans" ON "eindbalansregels" ("ideindbalans");
EOT;

//
// Table structure for table "eindcheck"
//
$struct['eindcheck'] =<<<EOT

CREATE TABLE "eindcheck" (
  "id" INTEGER PRIMARY KEY,
  "date" date  default '1900-01-01',
  "boekjaar" INTEGER default 0,
  "sortering" INTEGER  default 0,
  "label" varchar(64)  default '',
  "naam" varchar(32)  default '',
  "type" INTEGER  default 0,
  "value" INTEGER  default 0,
  "tekst" varchar(9600) default '' 
) ;
EOT;

//
// Table structure for table "grootboeksaldi"
//
$struct['grootboeksaldi'] =<<<EOT

CREATE TABLE "grootboeksaldi" (
  "id" INTEGER PRIMARY KEY,
  "nummer" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "saldo" decimal(12,2)  default '0.00'
) ;
  CREATE INDEX  "gbs_boekjaar" ON "grootboeksaldi" ("boekjaar");
  CREATE INDEX  "gbs_nummer" ON "grootboeksaldi" ("nummer");
EOT;

//
// Table structure for table "grootboekstam"
//
$struct['grootboekstam'] =<<<EOT

CREATE TABLE "grootboekstam" (
  "id" INTEGER PRIMARY KEY,
  "nummer" INTEGER default 0,
  "populariteit" INTEGER default 0,
  "type" INTEGER default 0,
  "nivo" INTEGER default 0,
  "verdichting" INTEGER default 0,
  "btwtype" INTEGER default 0,
  "naam" varchar(64)  default ''
) ;

  CREATE UNIQUE INDEX  "gbst_nummer" ON "grootboekstam"("nummer");
EOT;

//
// Table structure for table "inkoopfacturen"
//
$struct['inkoopfacturen'] =<<<EOT

CREATE TABLE "inkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" INTEGER default 0,
  "factuurnummer" varchar(16)  default '',
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '1900-01-01'
) ;

  CREATE UNIQUE INDEX  "if_idboekjaar" ON "inkoopfacturen" ("id","boekjaar");
EOT;

//
// Table structure for table "journaal"
//
$struct['journaal'] =<<<EOT

CREATE TABLE "journaal" (
  "id" INTEGER PRIMARY KEY,
  "journaalpost" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "periode" INTEGER default 0,
  "dagboekcode" varchar(16)  default '',
  "jomschrijving" varchar(128)  default '',
  "saldo" decimal(12,2)  default '0.00',
  "jrelatie" varchar(32)  default '',
  "jnummer" varchar(16)  default '',
  "joorsprong" varchar(16)  default '',
  "tekst" varchar(9600) default '' 
) ;
  CREATE UNIQUE INDEX  "j_idboekjaar" ON "journaal" ("journaalpost","boekjaar");
  CREATE INDEX  "j_periode" ON "journaal" ("periode");
  CREATE INDEX  "j_dagboekcode" ON "journaal" ("dagboekcode");
EOT;

//
// Table structure for table "meta"
//
$struct['meta'] =<<<EOT

CREATE TABLE "meta" (
  "key" varchar(64) ,
  "value" varchar(9600) default '' 
) ;
EOT;

//
// Table structure for table "pinbetalingen"
//
$struct['pinbetalingen'] =<<<EOT

CREATE TABLE "pinbetalingen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" INTEGER default 0,
  "factuurnummer" varchar(16)  default '',
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '1900-01-01'
) ;

  CREATE UNIQUE INDEX  "pb_idboekjaar" ON "pinbetalingen" ("id","boekjaar");
EOT;

//
// Table structure for table "stamgegevens"
//
$struct['stamgegevens'] =<<<EOT

CREATE TABLE "stamgegevens" (
  "id" INTEGER PRIMARY KEY,
  "boekjaar" INTEGER NOT NULL,
  "code" char(1)  default '',
  "subcode" INTEGER default 0,
  "label" varchar(128)  default '',
  "naam" varchar(32)  default '',
  "value" varchar(255)  default '',
  "tekst" varchar(9600) default '' 
) ;
EOT;

//
// Table structure for table "verkoopfacturen"
//
$struct['verkoopfacturen'] =<<<EOT

CREATE TABLE "verkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" INTEGER default 0,
  "boekjaar" INTEGER default 0,
  "datum" date  default '1900-01-01',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" INTEGER default 0,
  "factuurnummer" varchar(16)  default '',
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '1900-01-01'
) ;

  CREATE UNIQUE INDEX  "vf_idboekjaar" ON "verkoopfacturen" ("id","boekjaar");
EOT;

//
// Table structure for table "voorkeuren"
//
$struct['voorkeuren'] =<<<EOT

CREATE TABLE "voorkeuren" (
  "id" INTEGER PRIMARY KEY,
  "label" varchar(128)  default '',
  "naam" varchar(32)  default '',
  "value" varchar(255)  default ''
) ;
EOT;

//
// Table structure for table "notities"
//
$struct['notities'] =<<<EOT

CREATE TABLE  "notities" (
  "id" INTEGER PRIMARY KEY,
  "tabel" varchar(32) default '',
  "tabelid" INTEGER default 0 ,
  "tekst" varchar(9600) default ''
) ;
EOT;

//
// Domains
// 

$struct['SIGNED'] =<<<EOT

CREATE DOMAIN SIGNED
AS Integer DEFAULT 0 ;

CREATE DOMAIN DECIMAL
AS Numeric DEFAULT 0.00 ;
EOT;

//
// Views
// 

//
// Procedures
// 

/* __END__ */
