--
-- PostgreSQL database dump
--


--
-- Name: decimal; Type: DOMAIN; Schema: public; Owner: -
--

-- CREATE DOMAIN "decimal" AS numeric DEFAULT 0.00;


--
-- Name: signed; Type: DOMAIN; Schema: public; Owner: -
--

-- CREATE DOMAIN signed AS integer DEFAULT 0;



--
-- Name: boekregels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE boekregels (
    boekregelid integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    grootboekrekening integer DEFAULT 0 NOT NULL,
    kostenplaats integer,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie varchar(32) DEFAULT '',
    nummer varchar(16) DEFAULT '',
    oorsprong varchar(16) DEFAULT '',
    bomschrijving varchar(128) DEFAULT '',
    bedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    CONSTRAINT boekregels_pkey PRIMARY KEY (boekregelid)
);


--
-- Name: boekregelsTrash; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "boekregelsTrash" (
    boekregelid integer PRIMARY KEY NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    grootboekrekening integer DEFAULT 0 NOT NULL,
    kostenplaats integer,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie varchar(32) DEFAULT '',
    nummer varchar(16) DEFAULT '',
    oorsprong varchar(16) DEFAULT '',
    bomschrijving varchar(128) DEFAULT '',
    bedrag numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: btwaangiftes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE btwaangiftes (
    "id" integer PRIMARY KEY NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    boekjaar integer DEFAULT 0 NOT NULL,
    periode integer DEFAULT 0 NOT NULL,
    labelkey varchar(32) DEFAULT '',
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL,
    btw numeric(12,2) DEFAULT 0.00 NOT NULL,
    acode varchar(2) DEFAULT ''
);


--
-- Name: btwkeys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE btwkeys (
    id integer NOT NULL,
    key varchar(32) DEFAULT '',
    type varchar(10) DEFAULT '',
    actief smallint DEFAULT (0),
    ccode varchar(2) DEFAULT '',
    acode varchar(2) DEFAULT '',
    label varchar(64) DEFAULT '',
    labelstam varchar(64) DEFAULT '',
    labeldefaults varchar(64) DEFAULT '',
    boekjaar integer DEFAULT 0 NOT NULL,
    active integer DEFAULT 1 NOT NULL,
    CONSTRAINT btk_prima PRIMARY KEY (key, boekjaar, ccode)
);


--
-- Name: btwrelaties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE btwrelaties (
    journaalid integer NOT NULL,
    boekregelid integer NOT NULL,
    grootboekrekening integer,
    btwrelatie integer NOT NULL,
    CONSTRAINT pkey PRIMARY KEY (journaalid, boekregelid, btwrelatie)
);


--
-- Name: btwsaldi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE btwsaldi (
    periode integer NOT NULL,
    ccode character(2) NOT NULL,
    "Omzet_Hoog" numeric(9,0),
    "BTW_Hoog" numeric(9,0),
    "Omzet_Laag" numeric(9,0),
    "BTW_Laag" numeric(9,0),
    "Omzet_Prive" numeric(9,0),
    "BTW_Prive" numeric(9,0),
    "Omzet_EU" numeric(9,0),
    "Inkoop_EU" numeric(9,0),
    "BTWInkoop_EU" numeric(9,0),
    "Verschuldigd" numeric(9,0),
    "Voorbelasting" numeric(9,0),
    "Subtotaal" numeric(9,0),
    "Kleinondern" numeric(9,0),
    "Totaal" numeric(9,0),
    CONSTRAINT btwsaldi_pkey PRIMARY KEY (periode, ccode)
);


--
-- Name: crediteurenstam; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE crediteurenstam (
    id integer PRIMARY KEY NOT NULL,
    datum date DEFAULT '1900-01-01',
    code varchar(16) DEFAULT '',
    naam varchar(128) DEFAULT '',
    contact varchar(128) DEFAULT '',
    telefoon varchar(15) DEFAULT '',
    fax varchar(15) DEFAULT '',
    email varchar(64) DEFAULT '',
    adres varchar(255) DEFAULT '',
    crediteurnummer varchar(32) DEFAULT '',
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: dagboeken; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dagboeken (
    id integer PRIMARY KEY NOT NULL,
    type varchar(8) DEFAULT '',
    code varchar(16) DEFAULT '',
    naam varchar(64) DEFAULT '',
    grootboekrekening integer DEFAULT 0 NOT NULL,
    boeknummer integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    slot integer DEFAULT 0 NOT NULL,
    boekjaar integer NOT NULL,
    active integer NOT NULL
);


--
-- Name: dagboekhistorie; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dagboekhistorie (
    code varchar(12) DEFAULT '',
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    vorigeboeknummer integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    huidigeboeknummer integer DEFAULT 0 NOT NULL,
    nieuwsaldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: debiteurenstam; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE debiteurenstam (
    id integer PRIMARY KEY NOT NULL,
    datum date DEFAULT '1900-01-01',
    code varchar(16) DEFAULT '',
    naam varchar(128) DEFAULT '',
    contact varchar(128) DEFAULT '',
    telefoon varchar(15) DEFAULT '',
    fax varchar(15) DEFAULT '',
    email varchar(64) DEFAULT '',
    adres varchar(255) NOT NULL,
    type integer DEFAULT 0 NOT NULL,
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL,
    "BTWnummer" varchar(15)
);


--
-- Name: eindbalansen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eindbalansen (
    id integer PRIMARY KEY NOT NULL,
    boekdatum date DEFAULT '1900-01-01',
    boekjaar integer DEFAULT 0 NOT NULL,
    saldowinst numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldoverlies numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldobalans numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: eindbalansregels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eindbalansregels (
    id integer PRIMARY KEY NOT NULL,
    ideindbalans integer DEFAULT 0 NOT NULL,
    grootboekrekening integer DEFAULT 0 NOT NULL,
    grootboeknaam varchar(64) DEFAULT '',
    debet numeric(12,2) DEFAULT 0.00 NOT NULL,
    credit numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: eindcheck; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eindcheck (
    id integer PRIMARY KEY NOT NULL,
    date date DEFAULT '1900-01-01',
    boekjaar integer DEFAULT 0 NOT NULL,
    sortering smallint DEFAULT (0),
    label varchar(64) DEFAULT '',
    naam varchar(32) DEFAULT '',
    type smallint DEFAULT (0),
    value smallint DEFAULT (0),
    tekst text NOT NULL
);


--
-- Name: grootboeksaldi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grootboeksaldi (
    id integer PRIMARY KEY NOT NULL,
    nummer integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: grootboekstam; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grootboekstam (
    id integer PRIMARY KEY NOT NULL,
    boekjaar integer NOT NULL,
    active integer DEFAULT 1,
    nummer integer DEFAULT 0,
    kostenplaats integer,
    populariteit integer DEFAULT 0,
    type integer DEFAULT 0,
    nivo integer DEFAULT 0,
    verdichting integer DEFAULT 0,
    naam varchar(64) DEFAULT '',
    btwkey varchar(32) DEFAULT '',
    btwdefault varchar(32) DEFAULT ''
);


--
-- Name: COLUMN grootboekstam.type; Type: COMMENT; Schema: public; Owner: -
--

--
-- Name: inkoopfacturen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inkoopfacturen (
    id integer PRIMARY KEY NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    omschrijving varchar(128) DEFAULT '',
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode varchar(32) DEFAULT '',
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer varchar(16) DEFAULT '',
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'
);


--
-- Name: journaal; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE journaal (
    journaalid integer PRIMARY KEY NOT NULL,
    journaalpost integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    periode integer DEFAULT 0 NOT NULL,
    dagboekcode varchar(16) DEFAULT '',
    jomschrijving varchar(128) DEFAULT '',
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    jrelatie varchar(32) DEFAULT '',
    jnummer varchar(16) DEFAULT '',
    joorsprong varchar(16) DEFAULT '',
    tekst text NOT NULL
);


--
-- Name: kostenplaatsen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kostenplaatsen (
    identifier integer PRIMARY KEY NOT NULL,
    "ID" integer,
    "parentID" integer,
    saldi integer DEFAULT 0,
    naam varchar(48) DEFAULT ''
);


--
-- Name: COLUMN kostenplaatsen.saldi; Type: COMMENT; Schema: public; Owner: -
--


--
-- Name: meta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meta (
    key varchar(64) PRIMARY KEY NOT NULL,
    value text NOT NULL
);


--
-- Name: notities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notities (
    id integer PRIMARY KEY NOT NULL,
    tabel varchar(32) DEFAULT '',
    tabelid integer NOT NULL,
    tekst text NOT NULL
);


--
-- Name: pinbetalingen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pinbetalingen (
    id integer PRIMARY KEY NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    omschrijving varchar(128) DEFAULT '',
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode varchar(32) DEFAULT '',
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer varchar(16) DEFAULT '',
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'
);


--
-- Name: stamgegevens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stamgegevens (
    id integer PRIMARY KEY NOT NULL,
    boekjaar integer NOT NULL,
    code character(1) DEFAULT '',
    subcode integer DEFAULT 0,
    label varchar(128) DEFAULT '',
    naam varchar(32) DEFAULT '',
    value varchar(255) DEFAULT '',
    tekst text NOT NULL
);


--
-- Name: verkoopfacturen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE verkoopfacturen (
    id integer PRIMARY KEY NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01',
    omschrijving varchar(128) DEFAULT '',
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode varchar(32) DEFAULT '',
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer varchar(16) DEFAULT '',
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'
);



--
-- Name: voorkeuren; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE voorkeuren (
    id integer NOT NULL,
    label varchar(128) DEFAULT '',
    naam varchar(32) DEFAULT '',
    value varchar(255) DEFAULT ''
);


--
-- Name: vwbtw; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vwbtw (
    boekjaar integer,
    periode integer,
    ccode varchar(20),
    label text,
    omzet numeric,
    btwbedrag numeric
);





--
-- Name: br_grootboekrekening; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX br_grootboekrekening ON boekregels (grootboekrekening);


--
-- Name: br_idboekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX br_idboekjaar ON boekregels (boekregelid, boekjaar);


--
-- Name: br_journaalid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX br_journaalid ON boekregels (journaalid);


--
-- Name: bt_grootboekrekening; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX bt_grootboekrekening ON "boekregelsTrash" (grootboekrekening);


--
-- Name: bt_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX bt_id ON "boekregelsTrash" (boekregelid);


--
-- Name: bt_journaalid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX bt_journaalid ON "boekregelsTrash" (journaalid);


--
-- Name: ebr_ideindbalans; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ebr_ideindbalans ON eindbalansregels (ideindbalans);


--
-- Name: gbs_boekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gbs_boekjaar ON grootboeksaldi (boekjaar);


--
-- Name: gbs_nummer; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gbs_nummer ON grootboeksaldi (nummer);


--
-- Name: grbst_combi; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX grbst_combi ON grootboekstam (nummer, boekjaar, active);


--
-- Name: grbst_combi2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX grbst_combi2 ON grootboekstam (boekjaar, nummer, active);


--
-- Name: grbst_nummer; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX grbst_nummer ON grootboekstam (nummer);


--
-- Name: if_idboekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX if_idboekjaar ON inkoopfacturen (id, boekjaar);


--
-- Name: j_dagboekcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX j_dagboekcode ON journaal (dagboekcode);


--
-- Name: j_idboekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX j_idboekjaar ON journaal (journaalpost, boekjaar);


--
-- Name: j_periode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX j_periode ON journaal (periode);


--
-- Name: pb_idboekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pb_idboekjaar ON pinbetalingen (id, boekjaar);


--
-- Name: vf_idboekjaar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX vf_idboekjaar ON verkoopfacturen (id, boekjaar);


