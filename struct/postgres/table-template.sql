-- ------------------------------------------------------ --
-- MAAK EEN KOPIE VAN DIT BESTAND EN VOEG DAAR DE DATA IN --
-- ------------------------------------------------------ --
--
-- Als je van een MYSQL dump uitgaat vervang dan alle lege datumvalues
-- van '0000-00-00' naar '1900-01-01'
--
-- sqlversie 1.3.2
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: signed; Type: DOMAIN; Schema: public; Owner: webuser
--

CREATE DOMAIN signed AS integer DEFAULT 0;


ALTER DOMAIN public.signed OWNER TO webuser;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: boekregels; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE boekregels (
    id integer NOT NULL,
    journaalid integer,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    grootboekrekening integer DEFAULT 0,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie character varying(32) DEFAULT ''::character varying,
    nummer character varying(16) DEFAULT ''::character varying,
    oorsprong character varying(16) DEFAULT ''::character varying,
    bomschrijving character varying(128) DEFAULT ''::character varying,
    bedrag numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.boekregels OWNER TO webuser;

--
-- Name: boekregelsTrash; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE "boekregelsTrash" (
    id integer,
    journaalid integer,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    grootboekrekening integer DEFAULT 0,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie character varying(32) DEFAULT ''::character varying,
    nummer character varying(16) DEFAULT ''::character varying,
    oorsprong character varying(16) DEFAULT ''::character varying,
    bomschrijving character varying(128) DEFAULT ''::character varying,
    bedrag numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public."boekregelsTrash" OWNER TO webuser;

--
-- Name: btwaangiftelabels; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE btwaangiftelabels (
    key character varying(24) DEFAULT ''::character varying,
    label character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.btwaangiftelabels OWNER TO webuser;

--
-- Name: btwaangiftes; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE btwaangiftes (
    id integer NOT NULL,
    journaalid integer,
    datum date DEFAULT '1900-01-01'::date,
    boekjaar integer DEFAULT 0,
    periode integer DEFAULT 0,
    labelkey character varying(32) DEFAULT ''::character varying,
    omzet numeric(12,2) DEFAULT 0.00,
    btw numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.btwaangiftes OWNER TO webuser;

--
-- Name: crediteurenstam; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE crediteurenstam (
    id integer NOT NULL,
    datum date DEFAULT '1900-01-01'::date,
    code character varying(16) DEFAULT ''::character varying,
    naam character varying(128) DEFAULT ''::character varying,
    contact character varying(128) DEFAULT ''::character varying,
    telefoon character varying(15) DEFAULT ''::character varying,
    fax character varying(15) DEFAULT ''::character varying,
    email character varying(64) DEFAULT ''::character varying,
    adres character varying(255) DEFAULT ''::character varying,
    crediteurnummer character varying(32) DEFAULT ''::character varying,
    omzet numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.crediteurenstam OWNER TO webuser;

--
-- Name: dagboeken; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE dagboeken (
    id integer NOT NULL,
    type character varying(8) DEFAULT ''::character varying,
    code character varying(16) DEFAULT ''::character varying,
    naam character varying(64) DEFAULT ''::character varying,
    grootboekrekening integer DEFAULT 0,
    boeknummer integer DEFAULT 0,
    saldo numeric(12,2) DEFAULT 0.00,
    slot integer DEFAULT 0
);


ALTER TABLE public.dagboeken OWNER TO webuser;

--
-- Name: dagboeken2008; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE dagboeken2008 (
    id integer NOT NULL,
    type character varying(8) DEFAULT ''::character varying,
    code character varying(16) DEFAULT ''::character varying,
    naam character varying(64) DEFAULT ''::character varying,
    grootboekrekening integer DEFAULT 0,
    boeknummer integer DEFAULT 0,
    saldo numeric(12,2) DEFAULT 0.00,
    slot integer DEFAULT 0
);


ALTER TABLE public.dagboeken2008 OWNER TO webuser;

--
-- Name: dagboeken2009; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE dagboeken2009 (
    id integer NOT NULL,
    type character varying(8) DEFAULT ''::character varying,
    code character varying(16) DEFAULT ''::character varying,
    naam character varying(64) DEFAULT ''::character varying,
    grootboekrekening integer DEFAULT 0,
    boeknummer integer DEFAULT 0,
    saldo numeric(12,2) DEFAULT 0.00,
    slot integer DEFAULT 0
);


ALTER TABLE public.dagboeken2009 OWNER TO webuser;

--
-- Name: dagboekhistorie; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE dagboekhistorie (
    code character varying(12) DEFAULT ''::character varying,
    journaalid integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    vorigeboeknummer integer DEFAULT 0,
    saldo numeric(12,2) DEFAULT 0.00,
    huidigeboeknummer integer DEFAULT 0,
    nieuwsaldo numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.dagboekhistorie OWNER TO webuser;

--
-- Name: debiteurenstam; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE debiteurenstam (
    id integer NOT NULL,
    datum date DEFAULT '1900-01-01'::date,
    code character varying(16) DEFAULT ''::character varying,
    naam character varying(128) DEFAULT ''::character varying,
    contact character varying(128) DEFAULT ''::character varying,
    telefoon character varying(15) DEFAULT ''::character varying,
    fax character varying(15) DEFAULT ''::character varying,
    email character varying(64) DEFAULT ''::character varying,
    adres character varying(255),
    type integer DEFAULT 0,
    omzet numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.debiteurenstam OWNER TO webuser;

--
-- Name: eindbalansen; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE eindbalansen (
    id integer NOT NULL,
    boekdatum date DEFAULT '1900-01-01'::date,
    boekjaar integer DEFAULT 0,
    saldowinst numeric(12,2) DEFAULT 0.00,
    saldoverlies numeric(12,2) DEFAULT 0.00,
    saldobalans numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.eindbalansen OWNER TO webuser;

--
-- Name: eindbalansregels; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE eindbalansregels (
    id integer NOT NULL,
    ideindbalans integer DEFAULT 0,
    grootboekrekening integer DEFAULT 0,
    grootboeknaam character varying(64) DEFAULT ''::character varying,
    debet numeric(12,2) DEFAULT 0.00,
    credit numeric(12,2) DEFAULT 0.00,
    saldo numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.eindbalansregels OWNER TO webuser;

--
-- Name: eindcheck; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE eindcheck (
    id integer NOT NULL,
    date date DEFAULT '1900-01-01'::date,
    boekjaar integer DEFAULT 0,
    sortering integer DEFAULT 0,
    label character varying(64) DEFAULT ''::character varying,
    naam character varying(32) DEFAULT ''::character varying,
    type integer DEFAULT 0,
    value integer DEFAULT 0,
    tekst character varying(9600) DEFAULT ''::character varying
);


ALTER TABLE public.eindcheck OWNER TO webuser;

--
-- Name: grootboeksaldi; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE grootboeksaldi (
    id integer NOT NULL,
    nummer integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    saldo numeric(12,2) DEFAULT 0.00
);


ALTER TABLE public.grootboeksaldi OWNER TO webuser;

--
-- Name: grootboekstam; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE grootboekstam (
    id integer NOT NULL,
    nummer integer DEFAULT 0,
    populariteit integer DEFAULT 0,
    type integer DEFAULT 0,
    nivo integer DEFAULT 0,
    verdichting integer DEFAULT 0,
    btwtype integer DEFAULT 0,
    naam character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.grootboekstam OWNER TO webuser;

--
-- Name: grootboekstam2008; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE grootboekstam2008 (
    id integer NOT NULL,
    nummer integer NOT NULL,
    populariteit integer DEFAULT 0,
    type integer DEFAULT 0,
    nivo integer DEFAULT 0,
    verdichting integer DEFAULT 0,
    btwtype integer DEFAULT 0,
    naam character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.grootboekstam2008 OWNER TO webuser;

--
-- Name: grootboekstam2009; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE grootboekstam2009 (
    id integer NOT NULL,
    nummer integer NOT NULL,
    populariteit integer DEFAULT 0,
    type integer DEFAULT 0,
    nivo integer DEFAULT 0,
    verdichting integer DEFAULT 0,
    btwtype integer DEFAULT 0,
    naam character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.grootboekstam2009 OWNER TO webuser;

--
-- Name: inkoopfacturen; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE inkoopfacturen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    omschrijving character varying(128) DEFAULT ''::character varying,
    factuurbedrag numeric(12,2) DEFAULT 0.00,
    relatiecode character varying(32) DEFAULT ''::character varying,
    relatieid integer DEFAULT 0,
    factuurnummer character varying(16) DEFAULT ''::character varying,
    voldaan numeric(12,2) DEFAULT 0.00,
    betaaldatum date DEFAULT '1900-01-01'::date
);


ALTER TABLE public.inkoopfacturen OWNER TO webuser;

--
-- Name: journaal; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE journaal (
    id integer NOT NULL,
    journaalpost integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    periode integer DEFAULT 0,
    dagboekcode character varying(16) DEFAULT ''::character varying,
    jomschrijving character varying(128) DEFAULT ''::character varying,
    saldo numeric(12,2) DEFAULT 0.00,
    jrelatie character varying(32) DEFAULT ''::character varying,
    jnummer character varying(16) DEFAULT ''::character varying,
    joorsprong character varying(16) DEFAULT ''::character varying,
    tekst character varying(9600) DEFAULT ''::character varying
);


ALTER TABLE public.journaal OWNER TO webuser;

--
-- Name: meta; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE meta (
    key character varying(64),
    value character varying(9600) DEFAULT ''::character varying
);


ALTER TABLE public.meta OWNER TO webuser;

--
-- Name: notities; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE notities (
    id integer NOT NULL,
    tabel character varying(32) DEFAULT ''::character varying,
    tabelid integer DEFAULT 0,
    tekst character varying(9600) DEFAULT ''::character varying
);


ALTER TABLE public.notities OWNER TO webuser;

--
-- Name: pinbetalingen; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE pinbetalingen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    omschrijving character varying(128) DEFAULT ''::character varying,
    factuurbedrag numeric(12,2) DEFAULT 0.00,
    relatiecode character varying(32) DEFAULT ''::character varying,
    relatieid integer DEFAULT 0,
    factuurnummer character varying(16) DEFAULT ''::character varying,
    voldaan numeric(12,2) DEFAULT 0.00,
    betaaldatum date DEFAULT '1900-01-01'::date
);


ALTER TABLE public.pinbetalingen OWNER TO webuser;

--
-- Name: stamgegevens; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE stamgegevens (
    id integer NOT NULL,
    boekjaar integer NOT NULL,
    code character(1) DEFAULT ''::bpchar,
    subcode integer DEFAULT 0,
    label character varying(128) DEFAULT ''::character varying,
    naam character varying(32) DEFAULT ''::character varying,
    value character varying(255) DEFAULT ''::character varying,
    tekst character varying(9600) DEFAULT ''::character varying
);


ALTER TABLE public.stamgegevens OWNER TO webuser;

--
-- Name: verkoopfacturen; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE verkoopfacturen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0,
    boekjaar integer DEFAULT 0,
    datum date DEFAULT '1900-01-01'::date,
    omschrijving character varying(128) DEFAULT ''::character varying,
    factuurbedrag numeric(12,2) DEFAULT 0.00,
    relatiecode character varying(32) DEFAULT ''::character varying,
    relatieid integer DEFAULT 0,
    factuurnummer character varying(16) DEFAULT ''::character varying,
    voldaan numeric(12,2) DEFAULT 0.00,
    betaaldatum date DEFAULT '1900-01-01'::date
);


ALTER TABLE public.verkoopfacturen OWNER TO webuser;

--
-- Name: voorkeuren; Type: TABLE; Schema: public; Owner: webuser; Tablespace: 
--

CREATE TABLE voorkeuren (
    id integer NOT NULL,
    label character varying(128) DEFAULT ''::character varying,
    naam character varying(32) DEFAULT ''::character varying,
    value character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.voorkeuren OWNER TO webuser;

BEGIN;

-- -------------------------------- --
-- HIER DE INSERT DATA TUSSENVOEGEN --
-- -------------------------------- --



-- -------------------------------- --
-- HIER DE INSERT DATA TUSSENVOEGEN --
-- -------------------------------- --

COMMIT;

--
-- Name: boekregels_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY boekregels
    ADD CONSTRAINT boekregels_pkey PRIMARY KEY (id);


--
-- Name: btwaangiftes_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY btwaangiftes
    ADD CONSTRAINT btwaangiftes_pkey PRIMARY KEY (id);


--
-- Name: crediteurenstam_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY crediteurenstam
    ADD CONSTRAINT crediteurenstam_pkey PRIMARY KEY (id);


--
-- Name: dagboeken2008_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY dagboeken2008
    ADD CONSTRAINT dagboeken2008_pkey PRIMARY KEY (id);


--
-- Name: dagboeken2009_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY dagboeken2009
    ADD CONSTRAINT dagboeken2009_pkey PRIMARY KEY (id);


--
-- Name: dagboeken_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY dagboeken
    ADD CONSTRAINT dagboeken_pkey PRIMARY KEY (id);


--
-- Name: debiteurenstam_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY debiteurenstam
    ADD CONSTRAINT debiteurenstam_pkey PRIMARY KEY (id);


--
-- Name: eindbalansen_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY eindbalansen
    ADD CONSTRAINT eindbalansen_pkey PRIMARY KEY (id);


--
-- Name: eindbalansregels_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY eindbalansregels
    ADD CONSTRAINT eindbalansregels_pkey PRIMARY KEY (id);


--
-- Name: eindcheck_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY eindcheck
    ADD CONSTRAINT eindcheck_pkey PRIMARY KEY (id);


--
-- Name: grootboeksaldi_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY grootboeksaldi
    ADD CONSTRAINT grootboeksaldi_pkey PRIMARY KEY (id);


--
-- Name: grootboekstam2008_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY grootboekstam2008
    ADD CONSTRAINT grootboekstam2008_pkey PRIMARY KEY (id);


--
-- Name: grootboekstam2009_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY grootboekstam2009
    ADD CONSTRAINT grootboekstam2009_pkey PRIMARY KEY (id);


--
-- Name: grootboekstam_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY grootboekstam
    ADD CONSTRAINT grootboekstam_pkey PRIMARY KEY (id);


--
-- Name: inkoopfacturen_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY inkoopfacturen
    ADD CONSTRAINT inkoopfacturen_pkey PRIMARY KEY (id);


--
-- Name: journaal_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY journaal
    ADD CONSTRAINT journaal_pkey PRIMARY KEY (id);


--
-- Name: notities_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY notities
    ADD CONSTRAINT notities_pkey PRIMARY KEY (id);


--
-- Name: pinbetalingen_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY pinbetalingen
    ADD CONSTRAINT pinbetalingen_pkey PRIMARY KEY (id);


--
-- Name: stamgegevens_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY stamgegevens
    ADD CONSTRAINT stamgegevens_pkey PRIMARY KEY (id);


--
-- Name: verkoopfacturen_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY verkoopfacturen
    ADD CONSTRAINT verkoopfacturen_pkey PRIMARY KEY (id);


--
-- Name: voorkeuren_pkey; Type: CONSTRAINT; Schema: public; Owner: webuser; Tablespace: 
--

ALTER TABLE ONLY voorkeuren
    ADD CONSTRAINT voorkeuren_pkey PRIMARY KEY (id);


--
-- Name: br_grootboekrekening; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX br_grootboekrekening ON boekregels USING btree (grootboekrekening);


--
-- Name: br_idboekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX br_idboekjaar ON boekregels USING btree (id, boekjaar);


--
-- Name: br_journaalid; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX br_journaalid ON boekregels USING btree (journaalid);


--
-- Name: bt_grootboekrekening; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX bt_grootboekrekening ON "boekregelsTrash" USING btree (grootboekrekening);


--
-- Name: bt_id; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX bt_id ON "boekregelsTrash" USING btree (id);


--
-- Name: bt_journaalid; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX bt_journaalid ON "boekregelsTrash" USING btree (journaalid);


--
-- Name: ebr_ideindbalans; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX ebr_ideindbalans ON eindbalansregels USING btree (ideindbalans);


--
-- Name: gbs_boekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX gbs_boekjaar ON grootboeksaldi USING btree (boekjaar);


--
-- Name: gbs_nummer; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX gbs_nummer ON grootboeksaldi USING btree (nummer);


--
-- Name: gbst_nummer; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX gbst_nummer ON grootboekstam USING btree (nummer);


--
-- Name: if_idboekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX if_idboekjaar ON inkoopfacturen USING btree (id, boekjaar);


--
-- Name: j_dagboekcode; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX j_dagboekcode ON journaal USING btree (dagboekcode);


--
-- Name: j_idboekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX j_idboekjaar ON journaal USING btree (journaalpost, boekjaar);


--
-- Name: j_periode; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE INDEX j_periode ON journaal USING btree (periode);


--
-- Name: pb_idboekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX pb_idboekjaar ON pinbetalingen USING btree (id, boekjaar);


--
-- Name: vf_idboekjaar; Type: INDEX; Schema: public; Owner: webuser; Tablespace: 
--

CREATE UNIQUE INDEX vf_idboekjaar ON verkoopfacturen USING btree (id, boekjaar);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

