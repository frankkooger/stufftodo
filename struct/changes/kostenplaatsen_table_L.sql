-- DROP TABLE IF EXISTS kostenplaatsen CASCADE;

CREATE TABLE kostenplaatsen
(
  "identifier" SERIAL NOT NULL,
  "ID" integer,
  "parentID" integer,
  saldi integer DEFAULT 0,
  naam character varying(48) DEFAULT ''::character varying,
  CONSTRAINT kostenplaatsen_pkey PRIMARY KEY ("identifier")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kostenplaatsen OWNER TO webuser;


--TRUNCATE TABLE "kostenplaatsen";

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(100000,900000,0,'Activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(110000,100000,0,'Vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(120000,110000,0,'Immateriele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(121000,120000,0,'Overige immateriele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(122000,121000,1,'Intellectuele eigendom');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(123000,120000,1,'Goodwill');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(130000,110000,0,'Materiele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(131000,130000,0,'Bedrijfsgebouwen en terreinen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(132000,130000,0,'Machines en installaties');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(133000,130000,0,'Overige materiele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(134000,133000,0,'Bedrijfsauto''s');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(134100,134000,1,'Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(134200,134000,1,'Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(140000,110000,0,'Financiele vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(150000,100000,0,'Vlottende activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(160000,150000,0,'Voorraden excl. onderhanden werk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(161000,160000,1,'Voorraad atelier');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(170000,150000,0,'Vorderingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(171000,170000,1,'Debiteuren');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(180000,150000,0,'Effecten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(190000,150000,0,'Liquide middelen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(191100,190000,1,'Kas');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(191200,190000,1,'ABN-AMRO bank');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(191500,190000,1,'Prive rekening courant');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(300000,900000,0,'Passiva');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(310000,300000,0,'Eigen vermogen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(311000,310000,0,'Gestort en opgevraagd kapitaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(311100,311000,0,'Gestort kapitaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(311200,311000,0,'Opgevraagd kapitaal');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(320000,300000,0,'Voorzieningen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(321000,320000,0,'Voorzieningen voor pensioenen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(322000,320000,0,'Voorzieningen voor belastingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(322100,322000,1,'Voorziening voor Inkomstenbelasting');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(322200,322000,1,'Voorziening voor Omzetbelasting');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(323000,320000,0,'Voorzieningen overige');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(330000,300000,0,'Langlopende schulden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(331000,330000,0,'Schulden aan kredietinstellingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(331100,331000,1,'Financiering Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(332000,330000,0,'Schulden aan leveranciers en handelskredieten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(333000,330000,0,'Belastingen en premies sociale verzekeringen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(333100,333000,1,'Omzetbelasting af te dragen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(350000,300000,0,'Kortlopende schulden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(351000,350000,0,'Schulden aan kredietinstellingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(352000,350000,0,'Schulden aan leveranciers en handelskredieten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(352100,352000,1,'Crediteuren');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(353000,350000,0,'Belastingen en premies sociale verzekeringen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(400000,900000,0,'Kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(410000,400000,0,'Personeelskosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(420000,400000,0,'Overige bedrijfskosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(430000,420000,0,'Huisvestingskosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(431000,430000,1,'Huur atelier Boskoop');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(432000,430000,1,'Overige kosten huisvesting');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(440000,420000,0,'Onderhoudskosten overige materiele vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(450000,420000,0,'Verkoopkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(451000,450000,1,'Promotiekosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(452000,450000,1,'Acquisitiekosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(460000,420000,0,'Andere kosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(461000,460000,1,'Atelierkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(462000,460000,1,'Kantoorkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(463000,460000,1,'Kantinekosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(464000,460000,1,'Klein apparatuur');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(465000,460000,1,'Telefoon Internet Porti');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(468000,460000,1,'Diverse kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(470000,420000,0,'Kosten auto''s');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471000,470000,0,'Kosten Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471100,471000,1,'Brandstof Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471200,471000,1,'Onderhoud en reparatie Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471300,471000,1,'Verzekering Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471400,471000,1,'Wegenbelasting Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471500,471000,1,'Overige kosten Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471700,471000,1,'BTW privegebruik Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471800,471000,1,'Prive-bijtelling Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(471900,471000,1,'Saldo verkoop Opel');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481000,470000,0,'Kosten Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481100,481000,1,'Brandstof Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481200,481000,1,'Onderhoud en reparatie Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481300,481000,1,'Verzekering Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481400,481000,1,'Wegenbelasting Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481500,481000,1,'Overige kosten Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481700,481000,1,'BTW privegebruik Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481800,481000,1,'Prive-bijtelling Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(481900,481000,1,'Saldo verkoop Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(500000,400000,0,'Afschrijvingen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(510000,470000,0,'Afschrijvingen auto''s');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(511000,471000,1,'Afschrijving Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(512000,481000,1,'Afschrijving Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(520000,500000,0,'Afschrijvingen materiele activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(530000,500000,0,'Afschrijvingen vlottende activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(531000,530000,1,'Afschrijving materialen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(532000,530000,1,'Afschrijving debiteuren');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(600000,400000,0,'Inkoopkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(610000,600000,1,'Inkoop materialen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(620000,600000,1,'Kosten uitbesteed werk e.a. externe kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(700000,900000,0,'Financiele baten en lasten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(710000,700000,1,'Opbrengsten banktegoeden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(730000,700000,1,'Waardevermindering van vorderingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(770000,700000,1,'Kosten van schulden, rentelasten etc.');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(800000,900000,0,'Totaal opbrengsten: fiscaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(810000,800000,0,'Netto-omzet');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(820000,800000,1,'Overige opbrengsten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(820000,810000,0,'Opbrengsten zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(821000,820000,1,'Schilderijen zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(822000,820000,1,'Spuitwerk zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(823000,820000,1,'Ontwerp en logos zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(824000,820000,1,'Workshops zakelijk');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(830000,810000,0,'Opbrengsten prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(831000,830000,1,'Schilderijen prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(832000,830000,1,'Spuitwerk prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(833000,830000,1,'Ontwerp en logos prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(834000,830000,1,'Workshops prive');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(850000,810000,0,'Opbrengsten buitenland');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(851000,850000,1,'Opbrengsten Duitsland');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(852000,850000,1,'Opbrengsten Belgie');


INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(900000,Null,0,'Batig saldo');

