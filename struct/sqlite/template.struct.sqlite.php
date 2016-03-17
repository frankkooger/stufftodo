<?php // vim: syntax=php st=100
/*
 * structe voor administratiestructuur. Geschikt voor sqlite3
 *
 * Database: sqlite:/pub/webs/opensaministratie/dbase/administratie
 *
 * Deze versie is sqlversie 1.16.2
 */

// TODO er mag niet meer dan 1 sql statement in een query staan! De INDEX querys moeten tijdens het inlezen gesplit worden in aparte array-leden.

$struct = array();

//
// Table structure for table "boekregelsTrash"
//
$struct['boekregelsTrash'] =<<<EOT

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
EOT;

//
// Table structure for table "boekregels"
//
$struct['boekregels'] =<<<EOT

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
EOT;

//
// Table structure for table "btwaangiftes"
//
$struct['btwaangiftes'] =<<<EOT

CREATE TABLE btwaangiftes (
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
EOT;

//
// Table structure for table "btwkeys"
//
$struct['btwkeys'] =<<<EOT

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
EOT;


//
// Table structure for table "crediteurenstam"
//
$struct['crediteurenstam'] =<<<EOT

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
EOT;

//
// Table structure for table "dagboeken"
//
$struct['dagboeken'] =<<<EOT

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
EOT;

//
// Table structure for table "dagboekhistorie"
//
$struct['dagboekhistorie'] =<<<EOT

CREATE TABLE "dagboekhistorie" (
  "code" varchar(12) default '',
  "journaalid" INTEGER default '0',
  "boekjaar" INTEGER default '0',
  "vorigeboeknummer" INTEGER default '0',
  "saldo" decimal(12,2) default '0.00',
  "huidigeboeknummer" INTEGER default '0',
  "nieuwsaldo" decimal(12,2) default '0.00'
) ;
EOT;

//
// Table structure for table "debiteurenstam"
//
$struct['debiteurenstam'] =<<<EOT

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
EOT;

//
// Table structure for table "eindbalansen"
//
$struct['eindbalansen'] =<<<EOT

CREATE TABLE "eindbalansen" (
  "id" INTEGER PRIMARY KEY,
  "boekdatum" date DEFAULT '1900-01-01' ,
  "boekjaar" INTEGER NOT NULL,
  "saldowinst" decimal(12,2) default '0.00',
  "saldoverlies" decimal(12,2) default '0.00',
  "saldobalans" decimal(12,2) default '0.00'
) ;
EOT;

//
// Table structure for table "eindbalansregels"
//
$struct['eindbalansregels'] =<<<EOT

CREATE TABLE "eindbalansregels" (
  "id" INTEGER PRIMARY KEY,
  "ideindbalans" INTEGER NOT NULL,
  "grootboekrekening" INTEGER NOT NULL,
  "grootboeknaam" varchar(64) default '',
  "debet" decimal(12,2) default '0.00',
  "credit" decimal(12,2) default '0.00',
  "saldo" decimal(12,2) default '0.00'
) ;
EOT;

//
// Table structure for table "eindcheck"
//
$struct['eindcheck'] =<<<EOT

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
EOT;

//
// Table structure for table "grootboeksaldi"
//
$struct['grootboeksaldi'] =<<<EOT

CREATE TABLE "grootboeksaldi" (
  "id" INTEGER NOT NULL,
  "nummer" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "saldo" decimal(12,2) default '0.00'
) ;
EOT;

//
// Table structure for table "grootboekstam"
//
$struct['grootboekstam'] =<<<EOT

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
EOT;

//
// Table structure for table "inkoopfacturen"
//
$struct['inkoopfacturen'] =<<<EOT

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
EOT;

//
// Table structure for table "journaal"
//
$struct['journaal'] =<<<EOT

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
EOT;

//
// Table structure for table "meta"
//
$struct['meta'] =<<<EOT

CREATE TABLE "meta" (
  "key" varchar(64) ,
  "value" text default ''
) ;
EOT;

//
// Table structure for table "pinbetalingen"
//
$struct['pinbetalingen'] =<<<EOT

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
EOT;

//
// Table structure for table "stamgegevens"
//
$struct['stamgegevens'] =<<<EOT

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
EOT;

//
// Table structure for table "verkoopfacturen"
//
$struct['verkoopfacturen'] =<<<EOT

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
EOT;

//
// Table structure for table "voorkeuren"
//
$struct['voorkeuren'] =<<<EOT

CREATE TABLE "voorkeuren" (
  "id" INTEGER PRIMARY KEY,
  "label" varchar(128) default '',
  "naam" varchar(32) default '',
  "value" varchar(255) default ''
) ;
EOT;

//
// Table structure for table "notities"
//
$struct['notities'] =<<<EOT

CREATE TABLE  "notities" (
  "id" INTEGER PRIMARY KEY,
  "tabel" VARCHAR(32) default '',
  "tabelid" INTEGER default '0' ,
  "tekst" text default ''
) ;
EOT;

//
// Table structure for table "periodes"
//
$struct['periodes'] =<<<EOT

CREATE TABLE  "periodes" (
  "periode" INTEGER PRIMARY KEY
);
EOT;


$struct['perioderegels'] =<<<EOT

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
) ;
EOT;


$struct['indexes'] =<<<EOT

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
EOT;

/* __END__ */
