-- vim: syntax=sql so=100
--
-- template for creating 'fadministratie' as Firebird database
--
-- Database: webuser@localhost:/pub/webs/opensaministratie/dbase/fadministratie
-- ------------------------------------------------------
-- Server version 2.1

--
-- Create database
--
-- Windows:
-----------------------------------------------
--CREATE DATABASE 
-- "c:\openadmin\htdocs\dbase\administratie.fdb" 
-- user 'sysdba' password 'masterkey';
--COMMIT;

-- isql form of CONNECT:
--CONNECT
--  "c:\openadmin\htdocs\dbase\administratie.fdb" 
--  user 'sysdba' password 'masterkey';

--
-- Linux:
-----------------------------------------------
--CREATE DATABASE 
-- "/pub/webs/openadministratie/dbase/administratie.fdb" 
-- user 'sysdba' password 'OpenAdmin.nl';
--COMMIT;

-- isql form of CONNECT:
--CONNECT
--  "/pub/webs/openadministratie/dbase/administratie.fdb" 
--  user 'sysdba' password 'OpenAdmin.nl';

-- LET OP: de gebruikersnaam en het password zijn strings en moeten tussen enkele apostrophes.

-- De SQL vorm is wat uitgebreider en wordt voorafgegaan door een SET:
--  in SQL programs before a database can be opened with CONNECT, it must be
--  declared with the SET DATABASE statement. isql does not use SET DATABASE.
-- Zie SQL reference

-- Belangrijke documentatie
--   http://www.firebirdsql.org/index.php?op=doc&id=userdoc
--   http://www.ibphoenix.com/main.nfs?page=ibp_download_documentation
-- Voor een SQL reference kijk onder Interbase6
--   http://www.ibphoenix.com/main.nfs?a=ibphoenix&page=ibp_60_sqlref#RSf13665


-- Aandachtspunten voor create tables:
-- ----------------------------------------
--   objectnamen in dubbele quote of geen quotes
--     LET OP met dubbele quotes. Als een tabledefinitie is ingegeven als
--     CREATE TABLE "voorkeuren" dan moet die ook zo bevraagd worden. Als je bevraagt:
--     SELECT * FROM voorkeuren dan maakt Firebird daarvan:
--     SELECT * FROM VOORKEUREN
--
--   values in enkele quotes
--   id INTEGER NOT NULL DEFAULT 0,  // niet goed NOT NULL en DEFAULT kunnen niet bij elkaar gebruikt worden. Het is dus:
--   id INTEGER NOT NULL,  // of
--   id INTEGER DEFAULT 0, // of
--   id INTEGER DEFAULT 0 NOT NULL,
--   id int not null primary key,
--   txt varchar(32),
--  "oorsprong" varchar(16) default '',
--   ts timestamp default current_timestamp
--  "bedrag" decimal(12,2) default '0.00'

-- CREATE TABLE table_name
-- (
--    column_name {< datatype> | COMPUTED BY (< expr>) | domain}
--        [DEFAULT { literal | NULL | USER}] [NOT NULL]
--    ...
--    CONSTRAINT constraint_name
--        PRIMARY KEY (column_list),
--        UNIQUE      (column_list),
--        FOREIGN KEY (column_list) REFERENCES other_table (column_list),
--        CHECK       (condition),
--    ...
--);

-- Blobs can store infinite amounts of data. They can be used to store text,
-- images, videos, audio, or any other kind of data. Retrieving and writing data
-- to blobs is done with separate functions, so it is usable to have some basic
-- string (CHAR, VARCHAR) operations available for textual blob. Therefore the sub
-- types were added (as blob is a type). The subtypes are:
--
-- 0 - binary data (image, video, audio, whatever)
-- 1 - text (basic character functions work)
-- 2 - BLR (used for definitions of Firebird procedures, triggers, etc.)
--
-- User applications should only use subtypes 0 and 1. 


-- Aandachtspunten voor data manipulatie
-- ----------------------------------------
--  enkele quotes in strings escapen met een andere enkele quote (zoals in sqlite)
--  concatenate is ||  (zoals in sqlite)
--  value IS NULL (in mysql is het LIKE NULL)
--  zie voor meer comparison operators: http://ibexpert.info/ibe/index.php?n=Doc.ComparisonOperators
--  
--  Als je een query doet dan geeft dat weliswaar direct resultaat maar een
--  table is 'in use' zolang je nog geen commit; hebt gegeven.

--
-- Domains
-- 

CREATE DOMAIN SIGNED
AS Integer DEFAULT 0 ;

COMMIT;


-- DROP TABLE IF EXISTS "boekregelsTrash";
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


--
-- Dumping data for table "boekregelsTrash"
--


--
-- Table structure for table "boekregels"
--

-- DROP TABLE IF EXISTS "boekregels";
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
) ;

-- LET OP: indexnamen kunnen door de hele database niet hetzelfde zijn.

--
-- Dumping data for table "boekregels"
--

--
-- Table structure for table "btwaangiftes"
--

-- DROP TABLE IF EXISTS btwaangiftes;
CREATE TABLE "btwaangiftes" (
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

--
-- Dumping data for table "btwaangiftes"
--

--
-- Name: btwkeys; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

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

  CREATE UNIQUE INDEX  "k_keyboekjaar" ON "btwkeys" ("key","boekjaar");


--
-- Table structure for table "crediteurenstam"
--

-- DROP TABLE IF EXISTS "crediteurenstam";
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

--
-- Dumping data for table "crediteurenstam"
--

--
-- Table structure for table "dagboeken"
--

-- DROP TABLE IF EXISTS "dagboeken";
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

--
-- Table structure for table "dagboekhistorie"
--

-- DROP TABLE IF EXISTS "dagboekhistorie";
CREATE TABLE "dagboekhistorie" (
  "code" varchar(12) default '',
  "journaalid" INTEGER default '0',
  "boekjaar" INTEGER default '0',
  "vorigeboeknummer" INTEGER default '0',
  "saldo" decimal(12,2) default '0.00',
  "huidigeboeknummer" INTEGER default '0',
  "nieuwsaldo" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "dagboekhistorie"
--

--
-- Table structure for table "debiteurenstam"
--

-- DROP TABLE IF EXISTS "debiteurenstam";
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

--
-- Dumping data for table "debiteurenstam"
--

--
-- Table structure for table "eindbalansen"
--

-- DROP TABLE IF EXISTS "eindbalansen";
CREATE TABLE "eindbalansen" (
  "id" INTEGER PRIMARY KEY,
  "boekdatum" date DEFAULT '1900-01-01' ,
  "boekjaar" INTEGER NOT NULL,
  "saldowinst" decimal(12,2) default '0.00',
  "saldoverlies" decimal(12,2) default '0.00',
  "saldobalans" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "eindbalansen"
--

--
-- Table structure for table "eindbalansregels"
--

-- DROP TABLE IF EXISTS "eindbalansregels";
CREATE TABLE "eindbalansregels" (
  "id" INTEGER PRIMARY KEY,
  "ideindbalans" INTEGER NOT NULL,
  "grootboekrekening" INTEGER NOT NULL,
  "grootboeknaam" varchar(64) default '',
  "debet" decimal(12,2) default '0.00',
  "credit" decimal(12,2) default '0.00',
  "saldo" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "eindbalansregels"
--

--
-- Table structure for table "eindcheck"
--

-- DROP TABLE IF EXISTS "eindcheck";
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

--
-- Dumping data for table "eindcheck"
--

--
-- Table structure for table "grootboeksaldi"
--

-- DROP TABLE IF EXISTS "grootboeksaldi";
CREATE TABLE "grootboeksaldi" (
  "id" INTEGER PRIMARY KEY,
  "nummer" INTEGER NOT NULL,
  "boekjaar" INTEGER NOT NULL,
  "saldo" decimal(12,2) default '0.00'
) ;

--
-- Dumping data for table "grootboeksaldi"
--

--
-- Table structure for table "grootboekstam"
--

-- DROP TABLE IF EXISTS "grootboekstam";
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

--
-- Table structure for table "inkoopfacturen"
--

-- DROP TABLE IF EXISTS "inkoopfacturen";
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
--
-- Dumping data for table "inkoopfacturen"
--

--
-- Table structure for table "journaal"
--

-- DROP TABLE IF EXISTS "journaal";
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

--
-- Dumping data for table "journaal"
--

--
-- Table structure for table "meta"
--

-- DROP TABLE IF EXISTS "meta";
CREATE TABLE "meta" (
  "key" varchar(64) NOT NULL,
  "value" varchar(9600) default ''
) ;

--
-- Dumping data for table "meta"
--

--
-- Table structure for table "pinbetalingen"
--

-- DROP TABLE IF EXISTS "pinbetalingen";
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

--
-- Dumping data for table "pinbetalingen"
--

--
-- Table structure for table "stamgegevens"
--

-- DROP TABLE IF EXISTS "stamgegevens";
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

--
-- Dumping data for table "stamgegevens"
--

--
-- Table structure for table "verkoopfacturen"
--

-- DROP TABLE IF EXISTS "verkoopfacturen";
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

--
-- Dumping data for table "verkoopfacturen"
--

--
-- Table structure for table "voorkeuren"
--

-- DROP TABLE IF EXISTS "voorkeuren";
CREATE TABLE "voorkeuren" (
  "id" INTEGER PRIMARY KEY,
  "label" varchar(128) default '',
  "naam" varchar(32) default '',
  "value" varchar(255) default ''
) ;

--
-- Dumping data for table "voorkeuren"
--

CREATE TABLE  "notities" (
  "id" INTEGER PRIMARY KEY,
  "tabel" VARCHAR( 32 ) default '',
  "tabelid" INTEGER NOT NULL,
  "tekst" varchar(7000) default ''
);


CREATE TABLE  "periodes" (
  "periode" INTEGER PRIMARY KEY
);

COMMIT;

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

COMMIT;



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
  
COMMIT;

--
-- Views
-- 

--
-- Procedures
-- 

