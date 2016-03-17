<?php // vim: syntax=php so=100
/*
 * Dit bestand bevat het struct voor het opzetten van een lege mysql administratie.
 *
 * Deze versie is sqlversie 1.3.0
 */
$struct = array();

$struct['ansi-mode'] =<<<EOT

set SESSION sql_mode='ANSI_QUOTES,PIPES_AS_CONCAT';

EOT;

//
// Table structure for table "boekregelsTrash"
//
$struct['boekregelsTrash'] =<<<EOT

CREATE TABLE "boekregelsTrash" (
  "id" int(11) NOT NULL default '0',
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "grootboekrekening" int(11) NOT NULL default '0',
  "btwrelatie" int(11) default '0' COMMENT 'het boekstuknummer van een automatische btw boeking op deze boekregel',
  "factuurrelatie" int(11) default '0',
  "relatie" varchar(32) NOT NULL default '' COMMENT 'debiteurnr/crediteurnr',
  "nummer" varchar(16) NOT NULL default '' COMMENT 'b.v. factuurnr/bonnr etc.',
  "oorsprong" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer bankafrekening etc.',
  "bomschrijving" varchar(128) NOT NULL default '',
  "bedrag" decimal(12,2) NOT NULL default '0.00',
  KEY "journaalid" ("journaalid"),
  KEY "grootboekrekening" ("grootboekrekening"),
  KEY "id" ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "boekregels"
//
$struct['boekregels'] =<<<EOT

CREATE TABLE "boekregels" (
  "id" int(11) NOT NULL auto_increment,
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "grootboekrekening" int(11) NOT NULL default '0',
  "btwrelatie" int(11) default '0' COMMENT 'het boekstuknummer van een automatische btw boeking op deze boekregel',
  "factuurrelatie" int(11) default '0' COMMENT 'als dit een factuurbetlaing/ontvangst betreft, hier het id van inkoop/verkoopfacturen',
  "relatie" varchar(32) NOT NULL default '' COMMENT 'debiteurnr/crediteurnr',
  "nummer" varchar(16) NOT NULL default '' COMMENT 'b.v. factuurnr/bonnr etc.',
  "oorsprong" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer bankafrekening etc.',
  "bomschrijving" varchar(128) NOT NULL default '',
  "bedrag" decimal(12,2) NOT NULL default '0.00',
  UNIQUE KEY "idboekjaar" ("id","boekjaar"),
  KEY "journaalid" ("journaalid"),
  KEY "grootboekrekening" ("grootboekrekening")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "btwaangiftelabels"
//
$struct['btwaangiftelabels'] =<<<EOT

CREATE TABLE "btwaangiftelabels" (
  "key" varchar(24) NOT NULL default '',
  "label" varchar(64) NOT NULL default '',
  PRIMARY KEY  ("key")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "btwaangiftes"
//
$struct['btwaangiftes'] =<<<EOT

CREATE TABLE "btwaangiftes" (
  "id" int(11) NOT NULL auto_increment,
  "journaalid" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "boekjaar" int(11) NOT NULL default '0',
  "periode" int(11) NOT NULL default '0',
  "labelkey" varchar(32) NOT NULL default '',
  "omzet" decimal(12,2) NOT NULL default '0.00',
  "btw" decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "crediteurenstam"
//
$struct['crediteurenstam'] =<<<EOT

CREATE TABLE "crediteurenstam" (
  "id" int(11) NOT NULL auto_increment,
  "datum" date NOT NULL default '0000-00-00',
  "code" varchar(16) NOT NULL default '',
  "naam" varchar(128) NOT NULL default '',
  "contact" varchar(128) NOT NULL default '',
  "telefoon" varchar(15) NOT NULL default '',
  "fax" varchar(15) NOT NULL default '',
  "email" varchar(64) NOT NULL default '',
  "adres" varchar(255) NOT NULL default '',
  "crediteurnummer" varchar(32) NOT NULL default '',
  "omzet" decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "dagboeken"
//
$struct['dagboeken'] =<<<EOT

CREATE TABLE "dagboeken" (
  "id" int(11) NOT NULL auto_increment,
  "type" varchar(8) NOT NULL default '',
  "code" varchar(16) NOT NULL default '',
  "naam" varchar(64) NOT NULL default '',
  "grootboekrekening" int(11) NOT NULL default '0',
  "boeknummer" int(11) NOT NULL default '0' COMMENT 'laatste bladnummer van kas/bankbladen in bewerking',
  "saldo" decimal(12,2) NOT NULL default '0.00' COMMENT 'evt. saldo b.v. bij kas of bank',
  "slot" int(11) NOT NULL default '0' COMMENT 'zolang een journaalpost in bewerking is op dagboeken met boeknummer en saldo: hier het journaalid',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "dagboekhistorie"
//
$struct['dagboekhistorie'] =<<<EOT

CREATE TABLE "dagboekhistorie" (
  "code" varchar(12) NOT NULL default '',
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "vorigeboeknummer" int(11) NOT NULL default '0',
  "saldo" decimal(12,2) NOT NULL default '0.00',
  "huidigeboeknummer" int(11) NOT NULL default '0',
  "nieuwsaldo" decimal(12,2) NOT NULL default '0.00'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "debiteurenstam"
//
$struct['debiteurenstam'] =<<<EOT

CREATE TABLE "debiteurenstam" (
  "id" int(11) NOT NULL auto_increment,
  "datum" date NOT NULL default '0000-00-00',
  "code" varchar(16) NOT NULL default '',
  "naam" varchar(128) NOT NULL default '',
  "contact" varchar(128) NOT NULL default '',
  "telefoon" varchar(15) NOT NULL default '',
  "fax" varchar(15) NOT NULL default '',
  "email" varchar(64) NOT NULL default '',
  "adres" varchar(255) NOT NULL,
  "type" int(11) NOT NULL default '0',
  "omzet" decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "eindbalansen"
//
$struct['eindbalansen'] =<<<EOT

CREATE TABLE "eindbalansen" (
  "id" int(11) NOT NULL auto_increment,
  "boekdatum" date NOT NULL default '0000-00-00',
  "boekjaar" int(11) NOT NULL default '0',
  "saldowinst" decimal(12,2) NOT NULL default '0.00',
  "saldoverlies" decimal(12,2) NOT NULL default '0.00',
  "saldobalans" decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// table structure for table "eindbalansregels"
//
$struct['eindbalansregels'] =<<<EOT

CREATE TABLE "eindbalansregels" (
  "id" int(11) not null auto_increment,
  "ideindbalans" int(11) not null default '0',
  "grootboekrekening" int(11) not null default '0',
  "grootboeknaam" varchar(64) not null default '',
  "debet" decimal(12,2) not null default '0.00',
  "credit" decimal(12,2) not null default '0.00',
  "saldo" decimal(12,2) not null default '0.00',
  primary key  ("id"),
  key "ideindbalans" ("ideindbalans")
) engine=myisam default charset=latin1;
EOT;
//
// dumping data for table "eindbalansregels"
//


//
// table structure for table "eindcheck"
//
$struct['eindcheck'] =<<<EOT

CREATE TABLE "eindcheck" (
  "id" int(11) not null auto_increment,
  "date" date not null default '0000-00-00',
  "boekjaar" int(11) not null default '0',
  "sortering" smallint(6) not null default '0',
  "label" varchar(64) not null default '',
  "naam" varchar(32) not null default '',
  "type" tinyint(1) not null default '0' comment '0=reminder, 1=aktie',
  "value" tinyint(1) not null default '0' comment '0=red-1=greenlit (aktie) 2=blue-3=bluelit (reminder)',
  "tekst" text not null,
  primary key  ("id")
) engine=myisam default charset=latin1 comment='checkpoints voor eindejaarsafsluiting vastleggen';
EOT;
//
// dumping data for table "eindcheck"
//


//
// Table structure for table "grootboeksaldi"
//
$struct['grootboeksaldi'] =<<<EOT

CREATE TABLE "grootboeksaldi" (
  "id" int(11) NOT NULL auto_increment,
  "nummer" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "saldo" decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  ("id"),
  KEY "boekjaar" ("boekjaar"),
  KEY "nummer" ("nummer")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "grootboekstam"
//
//DROP TABLE IF EXISTS "grootboekstam";
$struct['grootboekstam'] =<<<EOT

CREATE TABLE "grootboekstam" (
  "id" int(11) NOT NULL auto_increment,
  "nummer" int(11) NOT NULL default '0',
  "populariteit" int(11) default '0',
  "type" int(11) NOT NULL default '0' COMMENT '1.balans/2.resultaten/3.totaalkaart',
  "nivo" int(11) NOT NULL default '0',
  "verdichting" int(11) NOT NULL default '0',
  "btwtype" int(11) NOT NULL default '0' COMMENT '1.inkopen/3.verkoophoog/4.verkooplaag/5.geenbtw/6.verlegdebtw',
  "naam" varchar(64) NOT NULL default '',
  PRIMARY KEY  ("id"),
  UNIQUE KEY "nummer" ("nummer")
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "inkoopfacturen"
//
$struct['inkoopfacturen'] =<<<EOT

CREATE TABLE "inkoopfacturen" (
  "id" int(11) NOT NULL auto_increment,
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "omschrijving" varchar(128) NOT NULL default '',
  "factuurbedrag" decimal(12,2) NOT NULL default '0.00',
  "relatiecode" varchar(32) NOT NULL default '',
  "relatieid" int(11) NOT NULL default '0',
  "factuurnummer" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer bankafrekening/factuur etc.',
  "voldaan" decimal(12,2) NOT NULL default '0.00',
  "betaaldatum" date NOT NULL default '0000-00-00',
  PRIMARY KEY  ("id"),
  UNIQUE KEY "idboekjaar" ("id","boekjaar")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "journaal"
//
$struct['journaal'] =<<<EOT

CREATE TABLE "journaal" (
  "id" int(11) NOT NULL auto_increment,
  "journaalpost" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "periode" int(11) NOT NULL default '0',
  "dagboekcode" varchar(16) NOT NULL default '',
  "jomschrijving" varchar(128) NOT NULL default '',
  "saldo" decimal(12,2) NOT NULL default '0.00',
  "jrelatie" varchar(32) NOT NULL default '',
  "jnummer" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer factuur/bonnr etc.',
  "joorsprong" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer bankafrekening etc.',
  "tekst" text NOT NULL,
  PRIMARY KEY  ("id"),
  UNIQUE KEY "idboekjaar" ("journaalpost","boekjaar"),
  KEY "periode" ("periode"),
  KEY "dagboekcode" ("dagboekcode")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "meta"
//
$struct['meta'] =<<<EOT

CREATE TABLE "meta" (
  "key" varchar(64) NOT NULL,
  "value" text NOT NULL,
  PRIMARY KEY  ("key")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "pinbetalingen"
//
$struct['pinbetalingen'] =<<<EOT

CREATE TABLE "pinbetalingen" (
  "id" int(11) NOT NULL auto_increment,
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "omschrijving" varchar(128) NOT NULL default '',
  "factuurbedrag" decimal(12,2) NOT NULL default '0.00',
  "relatiecode" varchar(32) NOT NULL default '',
  "relatieid" int(11) NOT NULL default '0',
  "factuurnummer" varchar(16) NOT NULL default '' COMMENT 'b.v. nummer bankafrekening/factuur etc.',
  "voldaan" decimal(12,2) NOT NULL default '0.00',
  "betaaldatum" date NOT NULL default '0000-00-00',
  PRIMARY KEY  ("id"),
  UNIQUE KEY "idboekjaar" ("id","boekjaar")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "stamgegevens"
//
$struct['stamgegevens'] =<<<EOT

CREATE TABLE "stamgegevens" (
  "id" int(11) NOT NULL auto_increment,
  "boekjaar" int(11) NOT NULL,
  "code" char(1) NOT NULL default '' COMMENT 'a)administratie gegevens,c)boekjaar en periodes, e)standaard rekeningen, g)btw tarieven',
  "subcode" int(11) default 0 COMMENT 'sortering binnen de groep',
  "label" varchar(128) NOT NULL default '',
  "naam" varchar(32) NOT NULL default '',
  "value" varchar(255) NOT NULL default '',
  "tekst" text NOT NULL,
  PRIMARY KEY  ("id")
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "verkoopfacturen"
//
$struct['verkoopfacturen'] =<<<EOT

CREATE TABLE "verkoopfacturen" (
  "id" int(11) NOT NULL auto_increment,
  "journaalid" int(11) NOT NULL default '0',
  "boekjaar" int(11) NOT NULL default '0',
  "datum" date NOT NULL default '0000-00-00',
  "omschrijving" varchar(128) NOT NULL default '',
  "factuurbedrag" decimal(12,2) NOT NULL default '0.00',
  "relatiecode" varchar(32) NOT NULL default '',
  "relatieid" int(11) NOT NULL default '0',
  "factuurnummer" varchar(16) NOT NULL default '' COMMENT 'nummer factuur',
  "voldaan" decimal(12,2) NOT NULL default '0.00',
  "betaaldatum" date NOT NULL default '0000-00-00',
  PRIMARY KEY  ("id"),
  UNIQUE KEY "idboekjaar" ("id","boekjaar")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "voorkeuren"
//
$struct['voorkeuren'] =<<<EOT

CREATE TABLE "voorkeuren" (
  "id" int(11) NOT NULL auto_increment,
  "label" varchar(128) NOT NULL default '',
  "naam" varchar(32) NOT NULL default '',
  "value" varchar(255) NOT NULL default '',
  PRIMARY KEY  ("id")
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
EOT;

//
// Table structure for table "notities"
//
$struct['notities'] =<<<EOT

CREATE TABLE  "notities" (
  "id" int(11) NOT NULL auto_increment,
  "tabel" VARCHAR( 32 ) NOT NULL default '',
  "tabelid" INT NOT NULL,
  "tekst" TEXT NOT NULL,
  PRIMARY KEY  ("id")
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
EOT;

//
// VIEWS
//
//set SESSION sql_mode='ANSI_QUOTES,PIPES_AS_CONCAT';
$struct['vw_btwaangifte'] =<<<EOT

CREATE VIEW "vw_btwaangifte" AS
SELECT 
  "j"."boekjaar" AS "boekjaar"
  ,"j"."periode" AS "periode"
  ,"b"."ccode" AS "ccode"
  ,substring("b"."type",1,3) AS "type"
  ,(CASE WHEN (sum("r"."bedrag") < 0) 
   THEN (sum("r"."bedrag") * -(1)) ELSE sum("r"."bedrag") end) AS "bedrag" 
FROM ((("btwkeys" "b" join "grootboekstam" "g" ON(("b"."key" = "g"."btwtype"))) 
JOIN "boekregels" "r" ON(("g"."nummer" = "r"."grootboekrekening"))) 
LEFT JOIN "journaal" "j" ON(("r"."journaalid" = "j"."id"))) 
WHERE ((1 = 1) AND (NOT(("b"."ccode" LIKE ''))) 
    AND (NOT(("j"."joorsprong" LIKE 'egalisatie')))) 
GROUP BY "j"."boekjaar","j"."periode","b"."ccode" 
ORDER BY "j"."boekjaar","j"."periode","b"."ccode";
EOT;

$struct['vw_btwbedragen'] =<<<EOT

CREATE VIEW "vw_btwbedragen" AS 
SELECT 
  "b"."key" AS "key"
  ,"b"."type" AS "type"
  ,"b"."actief" AS "actief"
  ,"b"."ccode" AS "ccode"
  ,"b"."acode" AS "acode"
  ,"g"."nummer" AS "nummer"
  ,"g"."naam" AS "naam"
  ,sum("r"."bedrag") AS "bedrag"
  ,"r"."boekjaar" AS "boekjaar"
  ,"j"."periode" AS "periode" 
FROM ((("btwkeys" "b" 
JOIN "grootboekstam" "g" ON(("b"."key" = "g"."btwtype"))) 
JOIN "boekregels" "r" ON(("g"."nummer" = "r"."grootboekrekening"))) 
LEFT JOIN "journaal" "j" ON(("r"."journaalid" = "j"."id"))) 
GROUP BY "b"."key","b"."type","b"."actief","b"."ccode","b"."acode","g"."nummer","g"."naam","r"."boekjaar","j"."periode" 
ORDER BY "r"."boekjaar","j"."periode","g"."nummer";
EOT;




/* __END__ */
