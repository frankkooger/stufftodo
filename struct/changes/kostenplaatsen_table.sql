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

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(10000,90000,0,'Activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(11000,10000,0,'Vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(12000,11000,0,'Immateriele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(12100,12000,0,'Overige immateriele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(12200,12100,1,'Intellectuele eigendom');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(12300,12000,1,'Goodwill');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13000,11000,0,'Materiele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13100,13000,0,'Bedrijfsgebouwen en terreinen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13200,13000,0,'Machines en installaties');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13300,13000,0,'Overige materiele vaste activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13400,13300,0,'Bedrijfsauto''s');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13410,13400,1,'Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(13420,13400,1,'Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(14000,11000,0,'Financiele vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(15000,10000,0,'Vlottende activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(16000,15000,0,'Voorraden excl. onderhanden werk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(16100,16000,1,'Voorraad atelier');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(17000,15000,0,'Vorderingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(17100,17000,1,'Debiteuren');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(18000,15000,0,'Effecten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(19000,15000,0,'Liquide middelen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(19110,19000,1,'Kas');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(19120,19000,1,'ABN-AMRO bank');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(19150,19000,1,'Prive rekening courant');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(30000,90000,0,'Passiva');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(31000,30000,0,'Eigen vermogen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(31100,31000,0,'Gestort en opgevraagd kapitaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(31110,31100,0,'Gestort kapitaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(31120,31100,0,'Opgevraagd kapitaal');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32000,30000,0,'Voorzieningen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32100,32000,0,'Voorzieningen voor pensioenen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32200,32000,0,'Voorzieningen voor belastingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32210,32200,1,'Voorziening voor Inkomstenbelasting');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32220,32200,1,'Voorziening voor Omzetbelasting');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(32300,32000,0,'Voorzieningen overige');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33000,30000,0,'Langlopende schulden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33100,33000,0,'Schulden aan kredietinstellingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33110,33100,1,'Financiering Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33200,33000,0,'Schulden aan leveranciers en handelskredieten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33300,33000,0,'Belastingen en premies sociale verzekeringen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(33310,33300,1,'Omzetbelasting af te dragen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(35000,30000,0,'Kortlopende schulden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(35100,35000,0,'Schulden aan kredietinstellingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(35200,35000,0,'Schulden aan leveranciers en handelskredieten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(35210,35200,1,'Crediteuren');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(35300,35000,0,'Belastingen en premies sociale verzekeringen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(40000,90000,0,'Kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(41000,40000,0,'Personeelskosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(42000,40000,0,'Overige bedrijfskosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47000,42000,0,'Kosten auto''s');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47100,47000,0,'Kosten Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47110,47100,1,'Brandstof Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47120,47100,1,'Onderhoud en reparatie Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47130,47100,1,'Verzekering Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47140,47100,1,'Wegenbelasting Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47150,47100,1,'Overige kosten Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47170,47100,1,'BTW privegebruik Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47180,47100,1,'Prive-bijtelling Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(47190,47100,1,'Saldo verkoop Opel');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48100,47000,0,'Kosten Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48110,48100,1,'Brandstof Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48120,48100,1,'Onderhoud en reparatie Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48130,48100,1,'Verzekering Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48140,48100,1,'Wegenbelasting Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48150,48100,1,'Overige kosten Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48170,48100,1,'BTW privegebruik Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48180,48100,1,'Prive-bijtelling Nissan');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(48190,48100,1,'Saldo verkoop Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(43000,42000,0,'Huisvestingskosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(43100,43000,1,'Huur atelier Boskoop');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(43200,43000,1,'Overige kosten huisvesting');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(44000,42000,0,'Onderhoudskosten overige materiele vaste activa');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(45000,42000,0,'Verkoopkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(45100,45000,0,'Promotiekosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(45200,45000,0,'Acquisitiekosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46000,42000,0,'Andere kosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46100,46000,0,'Atelierkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46200,46000,0,'Kantoorkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46300,46000,0,'Kantinekosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46400,46000,0,'Klein apparatuur');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46500,46000,0,'Telefoon Internet Porti');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(46800,46000,0,'Diverse kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(50000,40000,0,'Afschrijvingen');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(51000,47000,0,'Afschrijvingen auto''s');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(51100,47100,1,'Afschrijving Opel');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(51200,48100,1,'Afschrijving Nissan');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(52000,50000,0,'Afschrijvingen materiele activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(53000,50000,0,'Afschrijvingen vlottende activa');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(53100,53000,1,'Afschrijving materialen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(53200,53000,1,'Afschrijving debiteuren');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(60000,40000,0,'Inkoopkosten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(61000,60000,1,'Inkoop materialen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(62000,60000,1,'Kosten uitbesteed werk e.a. externe kosten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(70000,90000,0,'Financiele baten en lasten');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(71000,70000,1,'Opbrengsten banktegoeden');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(73000,70000,1,'Waardevermindering van vorderingen');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(77000,70000,1,'Kosten van schulden, rentelasten etc.');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(80000,90000,0,'Totaal opbrengsten: fiscaal');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(81000,80000,0,'Netto-omzet');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82000,80000,1,'Overige opbrengsten');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82000,81000,0,'Opbrengsten zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82100,82000,1,'Schilderijen zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82200,82000,1,'Spuitwerk zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82300,82000,1,'Ontwerp en logos zakelijk');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(82400,82000,1,'Workshops zakelijk');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(83000,81000,0,'Opbrengsten prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(83100,83000,1,'Schilderijen prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(83200,83000,1,'Spuitwerk prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(83300,83000,1,'Ontwerp en logos prive');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(83400,83000,1,'Workshops prive');

INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(85000,81000,0,'Opbrengsten buitenland');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(85100,85000,1,'Opbrengsten Duitsland');
INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(85200,85000,1,'Opbrengsten Belgie');


INSERT INTO "kostenplaatsen" ("ID","parentID","saldi","naam") VALUES(90000,Null,0,'Batig saldo');

