--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: administratiekk2014; Type: DATABASE; Schema: -; Owner: webuser
--

CREATE DATABASE administratiekk WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE administratiekk OWNER TO webuser;

\connect administratiekk

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: decimal; Type: DOMAIN; Schema: public; Owner: www
--

CREATE DOMAIN "decimal" AS numeric DEFAULT 0.00;


ALTER DOMAIN public."decimal" OWNER TO www;

--
-- Name: signed; Type: DOMAIN; Schema: public; Owner: www
--

CREATE DOMAIN signed AS integer DEFAULT 0;


ALTER DOMAIN public.signed OWNER TO www;

--
-- Name: func_kostenmatrix2(integer); Type: FUNCTION; Schema: public; Owner: www
--

CREATE FUNCTION func_kostenmatrix2(pnummer integer) RETURNS TABLE(id integer, saldi integer, naam character varying)
    LANGUAGE sql ROWS 130
    AS $_$

SELECT * FROM
(
SELECT DISTINCT a."ID" , a."saldi" , a."naam"
   FROM "kostenplaatsen" a
WHERE a."ID"=$1
UNION	SELECT 	b."ID", b."saldi", b."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
WHERE a."ID"=$1
UNION	SELECT 	c."ID", c."saldi", c."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
WHERE a."ID"=$1
UNION	SELECT 	d."ID", d."saldi", d."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
WHERE a."ID"=$1
UNION	SELECT 	e."ID", e."saldi", e."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
UNION	SELECT 	f."ID", f."saldi", f."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
   LEFT JOIN "kostenplaatsen" f ON e."ID" = f."parentID"
UNION	SELECT 	g."ID", g."saldi", g."naam"
   FROM "kostenplaatsen" a
   LEFT JOIN "kostenplaatsen" b ON a."ID" = b."parentID"
   LEFT JOIN "kostenplaatsen" c ON b."ID" = c."parentID"
   LEFT JOIN "kostenplaatsen" d ON c."ID" = d."parentID"
   LEFT JOIN "kostenplaatsen" e ON d."ID" = e."parentID"
   LEFT JOIN "kostenplaatsen" f ON e."ID" = f."parentID"
   LEFT JOIN "kostenplaatsen" g ON f."ID" = g."parentID"
WHERE a."ID"=$1
) x
WHERE "ID" IS NOT NULL
ORDER BY "ID" 
;

$_$;


ALTER FUNCTION public.func_kostenmatrix2(pnummer integer) OWNER TO www;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: boekregels; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE boekregels (
    boekregelid integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    grootboekrekening integer DEFAULT 0 NOT NULL,
    kostenplaats integer,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie character varying(32) DEFAULT ''::character varying NOT NULL,
    nummer character varying(16) DEFAULT ''::character varying NOT NULL,
    oorsprong character varying(16) DEFAULT ''::character varying NOT NULL,
    bomschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    bedrag numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.boekregels OWNER TO www;

--
-- Name: boekregelsTrash; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE "boekregelsTrash" (
    boekregelid integer DEFAULT 0 NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    grootboekrekening integer DEFAULT 0 NOT NULL,
    kostenplaats integer,
    btwrelatie integer DEFAULT 0,
    factuurrelatie integer DEFAULT 0,
    relatie character varying(32) DEFAULT ''::character varying NOT NULL,
    nummer character varying(16) DEFAULT ''::character varying NOT NULL,
    oorsprong character varying(16) DEFAULT ''::character varying NOT NULL,
    bomschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    bedrag numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public."boekregelsTrash" OWNER TO www;

--
-- Name: btwaangiftes; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE btwaangiftes (
    id integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    periode integer DEFAULT 0 NOT NULL,
    labelkey character varying(32) DEFAULT ''::character varying NOT NULL,
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL,
    btw numeric(12,2) DEFAULT 0.00 NOT NULL,
    acode character varying(2) DEFAULT ''::character varying
);


ALTER TABLE public.btwaangiftes OWNER TO www;

--
-- Name: btwkeys; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE btwkeys (
    id integer NOT NULL,
    key character varying(32) DEFAULT ''::character varying NOT NULL,
    type character varying(10) DEFAULT ''::character varying,
    actief smallint DEFAULT (0)::smallint,
    ccode character varying(2) DEFAULT ''::character varying NOT NULL,
    acode character varying(2) DEFAULT ''::character varying,
    label character varying(64) DEFAULT ''::character varying,
    labelstam character varying(64) DEFAULT ''::character varying,
    labeldefaults character varying(64) DEFAULT ''::character varying,
    boekjaar integer DEFAULT 0 NOT NULL,
    active integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.btwkeys OWNER TO www;

--
-- Name: btwrelaties; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE btwrelaties (
    journaalid integer NOT NULL,
    boekregelid integer NOT NULL,
    grootboekrekening integer,
    btwrelatie integer NOT NULL
);


ALTER TABLE public.btwrelaties OWNER TO www;

--
-- Name: btwsaldi; Type: TABLE; Schema: public; Owner: www; Tablespace: 
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
    "Totaal" numeric(9,0)
);


ALTER TABLE public.btwsaldi OWNER TO www;

--
-- Name: crediteurenstam; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE crediteurenstam (
    id integer NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    code character varying(16) DEFAULT ''::character varying NOT NULL,
    naam character varying(128) DEFAULT ''::character varying NOT NULL,
    contact character varying(128) DEFAULT ''::character varying NOT NULL,
    telefoon character varying(15) DEFAULT ''::character varying NOT NULL,
    fax character varying(15) DEFAULT ''::character varying NOT NULL,
    email character varying(64) DEFAULT ''::character varying NOT NULL,
    adres character varying(255) DEFAULT ''::character varying NOT NULL,
    crediteurnummer character varying(32) DEFAULT ''::character varying NOT NULL,
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.crediteurenstam OWNER TO www;

--
-- Name: dagboeken; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE dagboeken (
    id integer NOT NULL,
    type character varying(8) DEFAULT ''::character varying NOT NULL,
    code character varying(16) DEFAULT ''::character varying NOT NULL,
    naam character varying(64) DEFAULT ''::character varying NOT NULL,
    grootboekrekening integer DEFAULT 0 NOT NULL,
    boeknummer integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    slot integer DEFAULT 0 NOT NULL,
    boekjaar integer NOT NULL,
    active integer NOT NULL
);


ALTER TABLE public.dagboeken OWNER TO www;

--
-- Name: dagboekhistorie; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE dagboekhistorie (
    code character varying(12) DEFAULT ''::character varying NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    vorigeboeknummer integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    huidigeboeknummer integer DEFAULT 0 NOT NULL,
    nieuwsaldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.dagboekhistorie OWNER TO www;

--
-- Name: debiteurenstam; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE debiteurenstam (
    id integer NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    code character varying(16) DEFAULT ''::character varying NOT NULL,
    naam character varying(128) DEFAULT ''::character varying NOT NULL,
    contact character varying(128) DEFAULT ''::character varying NOT NULL,
    telefoon character varying(15) DEFAULT ''::character varying NOT NULL,
    fax character varying(15) DEFAULT ''::character varying NOT NULL,
    email character varying(64) DEFAULT ''::character varying NOT NULL,
    adres character varying(255) NOT NULL,
    type integer DEFAULT 0 NOT NULL,
    omzet numeric(12,2) DEFAULT 0.00 NOT NULL,
    "BTWnummer" character varying(15)
);


ALTER TABLE public.debiteurenstam OWNER TO www;

--
-- Name: eindbalansen; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE eindbalansen (
    id integer NOT NULL,
    boekdatum date DEFAULT '1900-01-01'::date NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    saldowinst numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldoverlies numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldobalans numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.eindbalansen OWNER TO www;

--
-- Name: eindbalansregels; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE eindbalansregels (
    id integer NOT NULL,
    ideindbalans integer DEFAULT 0 NOT NULL,
    grootboekrekening integer DEFAULT 0 NOT NULL,
    grootboeknaam character varying(64) DEFAULT ''::character varying NOT NULL,
    debet numeric(12,2) DEFAULT 0.00 NOT NULL,
    credit numeric(12,2) DEFAULT 0.00 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.eindbalansregels OWNER TO www;

--
-- Name: eindcheck; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE eindcheck (
    id integer NOT NULL,
    date date DEFAULT '1900-01-01'::date NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    sortering smallint DEFAULT (0)::smallint NOT NULL,
    label character varying(64) DEFAULT ''::character varying NOT NULL,
    naam character varying(32) DEFAULT ''::character varying NOT NULL,
    type smallint DEFAULT (0)::smallint NOT NULL,
    value smallint DEFAULT (0)::smallint NOT NULL,
    tekst text NOT NULL
);


ALTER TABLE public.eindcheck OWNER TO www;

--
-- Name: grootboeksaldi; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE grootboeksaldi (
    id integer NOT NULL,
    nummer integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.grootboeksaldi OWNER TO www;

--
-- Name: grootboekstam; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE grootboekstam (
    id integer NOT NULL,
    boekjaar integer NOT NULL,
    active integer DEFAULT 1,
    nummer integer DEFAULT 0,
    kostenplaats integer,
    populariteit integer DEFAULT 0,
    type integer DEFAULT 0,
    nivo integer DEFAULT 0,
    verdichting integer DEFAULT 0,
    naam character varying(64) DEFAULT ''::character varying,
    btwkey character varying(32) DEFAULT ''::character varying,
    btwdefault character varying(32) DEFAULT ''::character varying
);


ALTER TABLE public.grootboekstam OWNER TO www;

--
-- Name: COLUMN grootboekstam.type; Type: COMMENT; Schema: public; Owner: www
--

COMMENT ON COLUMN grootboekstam.type IS '1-balansrekening, 2-vwrekening, 3-totaalrekening';


--
-- Name: inkoopfacturen; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE inkoopfacturen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    omschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode character varying(32) DEFAULT ''::character varying NOT NULL,
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer character varying(16) DEFAULT ''::character varying NOT NULL,
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'::date NOT NULL
);


ALTER TABLE public.inkoopfacturen OWNER TO www;

--
-- Name: inkoopfacturenx; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE inkoopfacturenx (
    id integer,
    journaalid integer,
    boekjaar integer,
    datum date,
    omschrijving character varying(128),
    factuurbedrag numeric(12,2),
    relatiecode character varying(32),
    relatieid integer,
    factuurnummer character varying(16),
    voldaan numeric(12,2),
    betaaldatum date
);


ALTER TABLE public.inkoopfacturenx OWNER TO www;

--
-- Name: TABLE inkoopfacturenx; Type: COMMENT; Schema: public; Owner: www
--

COMMENT ON TABLE inkoopfacturenx IS 'deze tabel is een kopie van inkoopfacturen voordat we de betaald-saldi van 2013 hebben geneutraliseerd. Hetzelfde geldt voor verkoopfacturenx.';


--
-- Name: journaal; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE journaal (
    journaalid integer NOT NULL,
    journaalpost integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    periode integer DEFAULT 0 NOT NULL,
    dagboekcode character varying(16) DEFAULT ''::character varying NOT NULL,
    jomschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    saldo numeric(12,2) DEFAULT 0.00 NOT NULL,
    jrelatie character varying(32) DEFAULT ''::character varying NOT NULL,
    jnummer character varying(16) DEFAULT ''::character varying NOT NULL,
    joorsprong character varying(16) DEFAULT ''::character varying NOT NULL,
    tekst text NOT NULL
);


ALTER TABLE public.journaal OWNER TO www;

--
-- Name: kostenplaatsen; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE kostenplaatsen (
    identifier integer NOT NULL,
    "ID" integer,
    "parentID" integer,
    saldi integer DEFAULT 0,
    naam character varying(48) DEFAULT ''::character varying
);


ALTER TABLE public.kostenplaatsen OWNER TO www;

--
-- Name: COLUMN kostenplaatsen.saldi; Type: COMMENT; Schema: public; Owner: www
--

COMMENT ON COLUMN kostenplaatsen.saldi IS '0-hoofdrubriek rapportage, 1-rekeningsaldi, 2-saldi plus rapportage';


--
-- Name: kostenplaatsen_identifier_seq; Type: SEQUENCE; Schema: public; Owner: www
--

CREATE SEQUENCE kostenplaatsen_identifier_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kostenplaatsen_identifier_seq OWNER TO www;

--
-- Name: kostenplaatsen_identifier_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: www
--

ALTER SEQUENCE kostenplaatsen_identifier_seq OWNED BY kostenplaatsen.identifier;


--
-- Name: meta; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE meta (
    key character varying(64) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.meta OWNER TO www;

--
-- Name: notities; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE notities (
    id integer NOT NULL,
    tabel character varying(32) DEFAULT ''::character varying NOT NULL,
    tabelid integer NOT NULL,
    tekst text NOT NULL
);


ALTER TABLE public.notities OWNER TO www;

--
-- Name: pinbetalingen; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE pinbetalingen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    omschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode character varying(32) DEFAULT ''::character varying NOT NULL,
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer character varying(16) DEFAULT ''::character varying NOT NULL,
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'::date NOT NULL
);


ALTER TABLE public.pinbetalingen OWNER TO www;

--
-- Name: stamgegevens; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE stamgegevens (
    id integer NOT NULL,
    boekjaar integer NOT NULL,
    code character(1) DEFAULT ''::bpchar NOT NULL,
    subcode integer DEFAULT 0,
    label character varying(128) DEFAULT ''::character varying NOT NULL,
    naam character varying(32) DEFAULT ''::character varying NOT NULL,
    value character varying(255) DEFAULT ''::character varying NOT NULL,
    tekst text NOT NULL
);


ALTER TABLE public.stamgegevens OWNER TO www;

--
-- Name: verkoopfacturen; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE verkoopfacturen (
    id integer NOT NULL,
    journaalid integer DEFAULT 0 NOT NULL,
    boekjaar integer DEFAULT 0 NOT NULL,
    datum date DEFAULT '1900-01-01'::date NOT NULL,
    omschrijving character varying(128) DEFAULT ''::character varying NOT NULL,
    factuurbedrag numeric(12,2) DEFAULT 0.00 NOT NULL,
    relatiecode character varying(32) DEFAULT ''::character varying NOT NULL,
    relatieid integer DEFAULT 0 NOT NULL,
    factuurnummer character varying(16) DEFAULT ''::character varying NOT NULL,
    voldaan numeric(12,2) DEFAULT 0.00 NOT NULL,
    betaaldatum date DEFAULT '1900-01-01'::date NOT NULL
);


ALTER TABLE public.verkoopfacturen OWNER TO www;

--
-- Name: verkoopfacturenx; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE verkoopfacturenx (
    id integer,
    journaalid integer,
    boekjaar integer,
    datum date,
    omschrijving character varying(128),
    factuurbedrag numeric(12,2),
    relatiecode character varying(32),
    relatieid integer,
    factuurnummer character varying(16),
    voldaan numeric(12,2),
    betaaldatum date
);


ALTER TABLE public.verkoopfacturenx OWNER TO www;

--
-- Name: voorkeuren; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE voorkeuren (
    id integer NOT NULL,
    label character varying(128) DEFAULT ''::character varying NOT NULL,
    naam character varying(32) DEFAULT ''::character varying NOT NULL,
    value character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.voorkeuren OWNER TO www;

--
-- Name: vw_boekjaar; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_boekjaar AS
 SELECT (stamgegevens.value)::signed AS boekjaar
   FROM stamgegevens
  WHERE ((stamgegevens.naam)::text = 'lopendjaar'::text);


ALTER TABLE public.vw_boekjaar OWNER TO www;

--
-- Name: vw_grootboekstam; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_grootboekstam AS
 SELECT sub1.id,
    sub1.boekjaar AS historie,
    sub1.nummer,
    sub1.kostenplaats,
    sub1.active,
    sub1.populariteit,
    sub1.type,
    sub1.nivo,
    sub1.verdichting,
    sub1.naam,
    sub1.btwkey,
    sub1.btwdefault
   FROM (grootboekstam sub1
     JOIN ( SELECT max(grootboekstam.boekjaar) AS boekjaar,
            grootboekstam.nummer
           FROM grootboekstam
          WHERE (grootboekstam.boekjaar <= (( SELECT vw_boekjaar.boekjaar
                   FROM vw_boekjaar))::integer)
          GROUP BY grootboekstam.nummer) b ON ((((sub1.boekjaar = b.boekjaar) AND (sub1.nummer = b.nummer)) AND (sub1.active = 1))))
  ORDER BY sub1.nummer, sub1.boekjaar;


ALTER TABLE public.vw_grootboekstam OWNER TO www;

--
-- Name: vw_boekregels; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_boekregels AS
 SELECT b.boekregelid,
    b.journaalid,
    j.journaalpost,
    j.boekjaar,
    j.periode,
    b.datum AS boekdatum,
    j.datum AS journaaldatum,
    b.grootboekrekening,
        CASE
            WHEN (b.kostenplaats > 0) THEN b.kostenplaats
            ELSE g.kostenplaats
        END AS kostenplaats,
    g.naam AS grootboeknaam,
    b.bedrag,
    b.btwrelatie,
    b.factuurrelatie,
    b.relatie,
    b.nummer,
    g.btwkey,
    b.bomschrijving,
    b.oorsprong AS boorsprong,
    j.joorsprong,
    j.dagboekcode,
    j.jomschrijving,
    j.saldo AS journaalsaldo,
    j.jrelatie,
    j.jnummer
   FROM ((boekregels b
     JOIN journaal j ON ((b.journaalid = j.journaalid)))
     JOIN vw_grootboekstam g ON ((b.grootboekrekening = g.nummer)))
  WHERE (j.boekjaar = (( SELECT vw_boekjaar.boekjaar
           FROM vw_boekjaar))::integer);


ALTER TABLE public.vw_boekregels OWNER TO www;

--
-- Name: vw_boekregelsaldi; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_boekregelsaldi AS
 SELECT sum(br.bedrag) AS "Regelsaldo",
    bs.saldo AS "Saldisaldo",
    br.boekjaar,
    br.grootboekrekening
   FROM (boekregels br
     LEFT JOIN grootboeksaldi bs ON (((br.boekjaar = bs.boekjaar) AND (br.grootboekrekening = bs.nummer))))
  WHERE (br.boekjaar = (( SELECT vw_boekjaar.boekjaar
           FROM vw_boekjaar))::integer)
  GROUP BY br.boekjaar, br.grootboekrekening, bs.saldo
  ORDER BY br.boekjaar, br.grootboekrekening;


ALTER TABLE public.vw_boekregelsaldi OWNER TO www;

--
-- Name: vw_boekstuk; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_boekstuk AS
 SELECT b.journaalid,
    b.journaalpost,
    b.boekregelid,
    b.boekdatum,
    b.periode,
    b.boekjaar,
    b.grootboekrekening,
    b.kostenplaats,
    b.btwrelatie,
    b.factuurrelatie,
    b.grootboeknaam,
    b.relatie,
    b.nummer,
    b.boorsprong,
    b.dagboekcode,
    b.jomschrijving,
    b.bomschrijving,
    b.bedrag,
    '0' AS debet,
    '0' AS credit
   FROM vw_boekregels b
  ORDER BY b.journaalid, b.boekregelid;


ALTER TABLE public.vw_boekstuk OWNER TO www;

--
-- Name: vw_btwkeys; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwkeys AS
 SELECT a.id,
    a.key,
    a.type,
    a.actief,
    a.ccode,
    a.acode,
    a.label,
    a.labelstam,
    a.labeldefaults,
    a.boekjaar,
    a.active
   FROM ( SELECT btwkeys.id,
            btwkeys.key,
            btwkeys.type,
            btwkeys.actief,
            btwkeys.ccode,
            btwkeys.acode,
            btwkeys.label,
            btwkeys.labelstam,
            btwkeys.labeldefaults,
            btwkeys.boekjaar,
            btwkeys.active
           FROM btwkeys
          WHERE (((((btwkeys.id IN ( SELECT max(btwkeys_1.id) AS id
                   FROM btwkeys btwkeys_1
                  WHERE (btwkeys_1.boekjaar <= ((( SELECT stamgegevens.value
                           FROM stamgegevens
                          WHERE ((stamgegevens.naam)::text = 'lopendjaar'::text)))::signed)::integer)
                  GROUP BY btwkeys_1.key)) AND (btwkeys.actief = 1)) AND ((btwkeys.ccode)::text !~~ ''::text)) AND ((btwkeys.key)::text !~~ '%part%'::text)) AND ((btwkeys.type)::text <> ALL (ARRAY[('sub'::character varying)::text, ('tot'::character varying)::text])))
          ORDER BY btwkeys.ccode, btwkeys.acode DESC, btwkeys.key) a
UNION
 SELECT b.id,
    b.key,
    b.type,
    b.actief,
    b.ccode,
    b.acode,
    b.label,
    b.labelstam,
    b.labeldefaults,
    b.boekjaar,
    b.active
   FROM ( SELECT btwkeys.id,
            btwkeys.key,
            btwkeys.type,
            btwkeys.actief,
            btwkeys.ccode,
            btwkeys.acode,
            btwkeys.label,
            btwkeys.labelstam,
            btwkeys.labeldefaults,
            btwkeys.boekjaar,
            btwkeys.active
           FROM btwkeys
          WHERE (((btwkeys.id IN ( SELECT max(btwkeys_1.id) AS id
                   FROM btwkeys btwkeys_1
                  WHERE (btwkeys_1.boekjaar <= ((( SELECT stamgegevens.value
                           FROM stamgegevens
                          WHERE ((stamgegevens.naam)::text = 'lopendjaar'::text)))::signed)::integer)
                  GROUP BY btwkeys_1.key)) AND (btwkeys.actief = 1)) AND ((((btwkeys.key)::text ~~ '%part%'::text) OR ((btwkeys.key)::text ~~ '%vrijgesteld%'::text)) OR ((btwkeys.key)::text ~~ 'verkopen%'::text)))
          ORDER BY btwkeys.ccode DESC, btwkeys.acode DESC, btwkeys.key) b;


ALTER TABLE public.vw_btwkeys OWNER TO www;

--
-- Name: vw_partbtwbedragen; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_partbtwbedragen AS
 SELECT b.boekjaar,
    b.periode,
    b.grootboekrekening,
    sum(b.bedrag) AS bedrag,
    g.btwkey
   FROM (vw_boekregels b
     JOIN vw_grootboekstam g ON (((b.grootboekrekening = g.nummer) AND (g.historie <= b.boekjaar))))
  WHERE (((g.btwkey)::text = ANY (ARRAY[('verkopen_partbtwmateriaal'::character varying)::text, ('verkopen_vrijgesteldebtw'::character varying)::text, ('inkopen_partbtwmateriaal'::character varying)::text, ('rkg_btwpartmateriaal'::character varying)::text, ('dervingbtw_partbtwmateriaal'::character varying)::text])) AND ((b.boorsprong)::text <> ALL (ARRAY[('egalisatie'::character varying)::text, ('btwcorrectie'::character varying)::text])))
  GROUP BY b.boekjaar, b.periode, b.grootboekrekening, g.btwkey
  ORDER BY b.boekjaar, b.periode, b.grootboekrekening;


ALTER TABLE public.vw_partbtwbedragen OWNER TO www;

--
-- Name: vw_partbtw_periode; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_partbtw_periode AS
 SELECT vw_partbtwbedragen.boekjaar,
    vw_partbtwbedragen.periode,
    sum(vw_partbtwbedragen.bedrag) AS bedrag,
    vw_partbtwbedragen.btwkey
   FROM vw_partbtwbedragen
  GROUP BY vw_partbtwbedragen.boekjaar, vw_partbtwbedragen.periode, vw_partbtwbedragen.btwkey
  ORDER BY vw_partbtwbedragen.boekjaar, vw_partbtwbedragen.periode;


ALTER TABLE public.vw_partbtw_periode OWNER TO www;

--
-- Name: vw_periodes; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_periodes AS
 VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13);


ALTER TABLE public.vw_periodes OWNER TO www;

--
-- Name: vw_partbtw_periode_jbedragen; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_partbtw_periode_jbedragen AS
 SELECT p.column1 AS periode,
    b.boekjaar,
    f1.bedrag AS verkopen_partbtwmateriaal,
    f2.bedrag AS verkopen_vrijgesteldebtw,
    f3.bedrag AS inkopen_partbtwmateriaal,
    f4.bedrag AS rkg_btwpartmateriaal,
    (
        CASE
            WHEN (f1.bedrag IS NULL) THEN f3.bedrag
            WHEN (f2.bedrag IS NULL) THEN (0)::numeric
            ELSE ((f2.bedrag / (f1.bedrag + f2.bedrag)) * COALESCE(f4.bedrag, (0)::numeric))
        END)::numeric(8,2) AS dervingbtw_bedrag
   FROM (((((vw_periodes p
     LEFT JOIN vw_boekjaar b ON ((1 = 1)))
     LEFT JOIN vw_partbtw_periode f1 ON (((((b.boekjaar)::integer = f1.boekjaar) AND (p.column1 = f1.periode)) AND ((f1.btwkey)::text = 'verkopen_partbtwmateriaal'::text))))
     LEFT JOIN vw_partbtw_periode f2 ON (((((b.boekjaar)::integer = f2.boekjaar) AND (p.column1 = f2.periode)) AND ((f2.btwkey)::text = 'verkopen_vrijgesteldebtw'::text))))
     LEFT JOIN vw_partbtw_periode f3 ON (((((b.boekjaar)::integer = f3.boekjaar) AND (p.column1 = f3.periode)) AND ((f3.btwkey)::text = 'inkopen_partbtwmateriaal'::text))))
     LEFT JOIN vw_partbtw_periode f4 ON (((((b.boekjaar)::integer = f4.boekjaar) AND (p.column1 = f4.periode)) AND ((f4.btwkey)::text = 'rkg_btwpartmateriaal'::text))));


ALTER TABLE public.vw_partbtw_periode_jbedragen OWNER TO www;

--
-- Name: vw_btwbase; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwbase AS
 SELECT x.boekjaar,
    x.periode,
    x.nummer,
    x.ccode,
    x.type,
    x.bedrag
   FROM ( SELECT b.boekjaar,
            b.periode,
            g.nummer,
            k.ccode,
            "substring"((k.type)::text, 1, 3) AS type,
            sum(b.bedrag) AS bedrag
           FROM ((vw_grootboekstam g
             JOIN btwkeys k ON (((g.btwkey)::text = (k.key)::text)))
             LEFT JOIN vw_boekregels b ON ((g.nummer = b.grootboekrekening)))
          WHERE (((COALESCE(k.ccode, ''::character varying))::text !~~ ''::text) AND ((b.joorsprong)::text !~~ 'egalisatie'::text))
          GROUP BY k.ccode, k.type, g.nummer, b.boekjaar, b.periode
        UNION ALL
         SELECT j.boekjaar,
            j.periode,
            0 AS nummer,
            '5b'::character varying AS ccode,
            'cal'::text AS type,
            (j.dervingbtw_bedrag * ((-1))::numeric)
           FROM (vw_partbtw_periode_jbedragen j
             JOIN vw_btwkeys k ON (((k.key)::text = 'rkg_btwpartmateriaal'::text)))
          WHERE (j.dervingbtw_bedrag <> (0)::numeric)) x
  ORDER BY x.boekjaar, x.periode, x.ccode, x.nummer;


ALTER TABLE public.vw_btwbase OWNER TO www;

--
-- Name: vw_btwbedragen0; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwbedragen0 AS
 SELECT vw_btwbase.boekjaar,
    vw_btwbase.periode,
    vw_btwbase.ccode,
    (round(sum(
        CASE
            WHEN (vw_btwbase.type = 'sal'::text) THEN vw_btwbase.bedrag
            ELSE (0)::numeric
        END)) * ((-1))::numeric) AS omzet,
    (round(sum(
        CASE
            WHEN (vw_btwbase.type = ANY (ARRAY['btw'::text, 'cal'::text])) THEN vw_btwbase.bedrag
            ELSE (0)::numeric
        END)) * (
        CASE
            WHEN ((vw_btwbase.ccode)::text = '5b'::text) THEN 1
            ELSE (-1)
        END)::numeric) AS btwbedrag
   FROM vw_btwbase
  WHERE ((vw_btwbase.ccode)::text = ANY (ARRAY[('1a'::character varying)::text, ('1b'::character varying)::text, ('1c'::character varying)::text, ('1d'::character varying)::text, ('1e'::character varying)::text, ('2a'::character varying)::text, ('3a'::character varying)::text, ('3b'::character varying)::text, ('3c'::character varying)::text, ('4a'::character varying)::text, ('4b'::character varying)::text, ('5b'::character varying)::text, ('5d'::character varying)::text]))
  GROUP BY vw_btwbase.boekjaar, vw_btwbase.periode, vw_btwbase.ccode;


ALTER TABLE public.vw_btwbedragen0 OWNER TO www;

--
-- Name: vw_btwbedragen1; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwbedragen1 AS
 SELECT xx.boekjaar,
    xx.periode,
    xx.ccode,
    xx.omzet,
    xx.btwbedrag
   FROM ( SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            vw_btwbedragen0.ccode,
            sum(vw_btwbedragen0.omzet) AS omzet,
            sum(vw_btwbedragen0.btwbedrag) AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('1a'::character varying)::text, ('1b'::character varying)::text, ('1c'::character varying)::text, ('1d'::character varying)::text]))
          GROUP BY vw_btwbedragen0.ccode, vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            vw_btwbedragen0.ccode,
            sum(vw_btwbedragen0.omzet) AS omzet,
            0 AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = '1e'::text)
          GROUP BY vw_btwbedragen0.ccode, vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            vw_btwbedragen0.ccode,
            sum(vw_btwbedragen0.omzet) AS omzet,
            sum(vw_btwbedragen0.btwbedrag) AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('2a'::character varying)::text, ('3a'::character varying)::text, ('3b'::character varying)::text, ('3c'::character varying)::text, ('4a'::character varying)::text, ('4b'::character varying)::text]))
          GROUP BY vw_btwbedragen0.ccode, vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            '5a'::character varying AS ccode,
            0 AS omzet,
            sum(vw_btwbedragen0.btwbedrag) AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('1a'::character varying)::text, ('1b'::character varying)::text, ('1c'::character varying)::text, ('1d'::character varying)::text, ('2a'::character varying)::text, ('4a'::character varying)::text, ('4b'::character varying)::text]))
          GROUP BY vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            vw_btwbedragen0.ccode,
            0 AS omzet,
            vw_btwbedragen0.btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = '5b'::text)
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            '5c'::character varying AS ccode,
            0 AS omzet,
            sum(
                CASE
                    WHEN (((vw_btwbedragen0.ccode)::text = '5b'::text) AND (vw_btwbedragen0.btwbedrag > 0.0)) THEN (vw_btwbedragen0.btwbedrag * ((-1))::numeric)
                    ELSE vw_btwbedragen0.btwbedrag
                END) AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('1a'::character varying)::text, ('1b'::character varying)::text, ('1c'::character varying)::text, ('1d'::character varying)::text, ('1e'::character varying)::text, ('2a'::character varying)::text, ('3a'::character varying)::text, ('3b'::character varying)::text, ('3c'::character varying)::text, ('4a'::character varying)::text, ('4b'::character varying)::text, ('5b'::character varying)::text]))
          GROUP BY vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            vw_btwbedragen0.ccode,
            0 AS omzet,
            vw_btwbedragen0.btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = '5d'::text)
        UNION ALL
         SELECT vw_btwbedragen0.boekjaar,
            vw_btwbedragen0.periode,
            '5e'::character varying AS ccode,
            0 AS omzet,
            sum(
                CASE
                    WHEN (((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('5b'::character varying)::text, ('5d'::character varying)::text])) AND (vw_btwbedragen0.btwbedrag > 0.0)) THEN (vw_btwbedragen0.btwbedrag * ((-1))::numeric)
                    ELSE vw_btwbedragen0.btwbedrag
                END) AS btwbedrag
           FROM vw_btwbedragen0
          WHERE ((vw_btwbedragen0.ccode)::text = ANY (ARRAY[('1a'::character varying)::text, ('1b'::character varying)::text, ('1c'::character varying)::text, ('1d'::character varying)::text, ('1e'::character varying)::text, ('2a'::character varying)::text, ('3a'::character varying)::text, ('3b'::character varying)::text, ('3c'::character varying)::text, ('4a'::character varying)::text, ('4b'::character varying)::text, ('5b'::character varying)::text, ('5d'::character varying)::text]))
          GROUP BY vw_btwbedragen0.boekjaar, vw_btwbedragen0.periode) xx
  ORDER BY xx.boekjaar, xx.periode, xx.ccode;


ALTER TABLE public.vw_btwbedragen1 OWNER TO www;

--
-- Name: vw_btw; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btw AS
 SELECT v.boekjaar,
    v.periode,
    v.ccode,
    (((v.ccode)::text || '. '::text) || (k.label)::text) AS label,
        CASE v.omzet
            WHEN 0 THEN NULL::numeric
            ELSE
            CASE
                WHEN (v.omzet < (0)::numeric) THEN (v.omzet * ((-1))::numeric)
                ELSE v.omzet
            END
        END AS omzet,
        CASE v.btwbedrag
            WHEN 0 THEN NULL::numeric
            ELSE v.btwbedrag
        END AS btwbedrag
   FROM (vw_btwbedragen1 v
     JOIN btwkeys k ON (((v.ccode)::text = (k.acode)::text)))
  ORDER BY v.boekjaar, v.periode, v.ccode;


ALTER TABLE public.vw_btw OWNER TO www;

--
-- Name: vw_btwtarieven; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwtarieven AS
 SELECT s.naam AS key,
    (s.value)::numeric AS value
   FROM stamgegevens s
  WHERE (((s.naam)::text = ANY (ARRAY[('btwverkoophoog'::character varying)::text, ('btwverkooplaag'::character varying)::text, ('rkg_divopbrengsten'::character varying)::text, ('lopendjaar'::character varying)::text, ('periodeextra'::character varying)::text])) AND (s.id IN ( SELECT max(stamgegevens.id) AS max
           FROM stamgegevens
          WHERE (stamgegevens.boekjaar <= (( SELECT vw_boekjaar.boekjaar
                   FROM vw_boekjaar))::integer)
          GROUP BY stamgegevens.naam)))
UNION ALL
 SELECT b.key,
    g.nummer AS value
   FROM (btwkeys b
     JOIN vw_grootboekstam g ON (((b.key)::text = (g.btwkey)::text)));


ALTER TABLE public.vw_btwtarieven OWNER TO www;

--
-- Name: vw_btw5dbedragen; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btw5dbedragen AS
 SELECT b.boekjaar,
    b.periode,
    '1e'::character(2) AS ccode,
    round(sum(b.bedrag)) AS verlegdeomzet,
        CASE
            WHEN (COALESCE(sum(b.bedrag), (0)::numeric) = (0)::numeric) THEN (0)::numeric
            ELSE round((sum(b.bedrag) * (max(t.value) / (100)::numeric)))
        END AS btwbedrag
   FROM (vw_boekregels b
     LEFT JOIN vw_btwtarieven t ON (((t.key)::text = 'btwverkoophoog'::text)))
  WHERE ((b.btwkey)::text = 'verkopen_verlegdebtw'::text)
  GROUP BY b.boekjaar, b.periode
UNION ALL
 SELECT b.boekjaar,
    b.periode,
    '5d'::character(2) AS ccode,
    0 AS verlegdeomzet,
        CASE
            WHEN (sum(b.bedrag) < (0)::numeric) THEN (0)::numeric
            ELSE sum(round(b.bedrag))
        END AS btwbedrag
   FROM vw_boekregels b
  WHERE (((b.btwkey)::text = 'rkg_betaaldebtw'::text) AND ((b.joorsprong)::text = '5dregeling'::text))
  GROUP BY b.boekjaar, b.periode
UNION ALL
 SELECT vw_btw.boekjaar,
    vw_btw.periode,
    '5c'::character(2) AS ccode,
    0 AS verlegdeomzet,
    sum(
        CASE
            WHEN (vw_btw.btwbedrag < (0)::numeric) THEN (0)::numeric
            ELSE vw_btw.btwbedrag
        END) AS btwbedrag
   FROM vw_btw
  WHERE ((vw_btw.ccode)::text = '5c'::text)
  GROUP BY vw_btw.boekjaar, vw_btw.periode;


ALTER TABLE public.vw_btw5dbedragen OWNER TO www;

--
-- Name: vw_btw5d; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btw5d AS
 SELECT vw_btw5dbedragen.boekjaar,
    vw_btw5dbedragen.ccode,
    round(sum(vw_btw5dbedragen.verlegdeomzet)) AS verlegdeomzet,
    round(sum(vw_btw5dbedragen.btwbedrag)) AS btwbedrag
   FROM vw_btw5dbedragen
  GROUP BY vw_btw5dbedragen.boekjaar, vw_btw5dbedragen.ccode
  ORDER BY vw_btw5dbedragen.boekjaar, vw_btw5dbedragen.ccode;


ALTER TABLE public.vw_btw5d OWNER TO www;

--
-- Name: vw_dagboeken; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_dagboeken AS
 SELECT sub1.id,
    sub1.historie,
    sub1.active,
    sub1.type,
    sub1.code,
    sub1.naam,
    sub1.grootboekrekening,
    sub1.boeknummer,
    sub1.saldo,
    sub1.slot
   FROM ( SELECT dagboeken.id,
            dagboeken.boekjaar AS historie,
            dagboeken.active,
            dagboeken.type,
            dagboeken.code,
            dagboeken.naam,
            dagboeken.grootboekrekening,
            dagboeken.boeknummer,
            dagboeken.saldo,
            dagboeken.slot
           FROM dagboeken
          WHERE (dagboeken.id IN ( SELECT max(dagboeken_1.id) AS id
                   FROM dagboeken dagboeken_1
                  WHERE (dagboeken_1.boekjaar <= ((( SELECT stamgegevens.value
                           FROM stamgegevens
                          WHERE ((stamgegevens.naam)::text = 'lopendjaar'::text)))::signed)::integer)
                  GROUP BY dagboeken_1.code))) sub1
  WHERE (sub1.active = 1)
  ORDER BY sub1.code, sub1.historie;


ALTER TABLE public.vw_dagboeken OWNER TO www;

--
-- Name: vw_stamgegevens; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_stamgegevens AS
 SELECT s.id,
    s.code,
    s.subcode,
    s.label,
    s.naam,
    s.value,
    s.boekjaar,
    g.nummer AS grootboekrekening,
    d.code AS dagboek
   FROM ((stamgegevens s
     LEFT JOIN vw_grootboekstam g ON (((s.value)::text = ((g.nummer)::character varying(8))::text)))
     LEFT JOIN vw_dagboeken d ON ((g.nummer = d.grootboekrekening)))
  WHERE (s.id IN ( SELECT max(stamgegevens.id) AS max
           FROM stamgegevens
          WHERE (stamgegevens.boekjaar <= ((( SELECT stamgegevens_1.value
                   FROM stamgegevens stamgegevens_1
                  WHERE ((stamgegevens_1.naam)::text = 'lopendjaar'::text)))::signed)::integer)
          GROUP BY stamgegevens.naam))
  ORDER BY s.code, s.subcode;


ALTER TABLE public.vw_stamgegevens OWNER TO www;

--
-- Name: vw_btw5d_calculus; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btw5d_calculus AS
 SELECT sum(x.btwbedrag) AS btwbedrag,
    sum(x.verlegdebtw) AS verlegdebtw
   FROM ( SELECT xx.btwbedrag,
            0 AS verlegdebtw
           FROM ( SELECT sum(vw_btw.btwbedrag) AS btwbedrag
                   FROM vw_btw
                  WHERE (((vw_btw.ccode)::text = '5c'::text) AND (vw_btw.periode >= (( SELECT vw_stamgegevens.value
                           FROM vw_stamgegevens
                          WHERE ((vw_stamgegevens.naam)::text = 'periodetot'::text)))::integer))) xx
          WHERE (xx.btwbedrag > (0)::numeric)
        UNION ALL
         SELECT sum(btwaangiftes.btw) AS btwbedrag,
            0 AS verlegdebtw
           FROM btwaangiftes
          WHERE ((((btwaangiftes.boekjaar = (( SELECT vw_boekjaar.boekjaar
                   FROM vw_boekjaar))::integer) AND (btwaangiftes.periode < (( SELECT vw_stamgegevens.value
                   FROM vw_stamgegevens
                  WHERE ((vw_stamgegevens.naam)::text = 'periodetot'::text)))::integer)) AND ((btwaangiftes.acode)::text = '5c'::text)) AND (btwaangiftes.btw > (0)::numeric))
        UNION ALL (
                 SELECT 0 AS btwbedrag,
                    xy.verlegdebtw
                   FROM ( SELECT 0 AS btwbedrag,
                            sum(vw_btw.btwbedrag) AS verlegdebtw
                           FROM vw_btw
                          WHERE (((vw_btw.ccode)::text = '2a'::text) AND (vw_btw.periode >= (( SELECT vw_stamgegevens.value
                                   FROM vw_stamgegevens
                                  WHERE ((vw_stamgegevens.naam)::text = 'periodetot'::text)))::integer))) xy
                  WHERE (xy.btwbedrag > 0)
                UNION ALL
                 SELECT 0 AS btwbedrag,
                    COALESCE(sum(btwaangiftes.btw), (0)::numeric) AS verlegdebtw
                   FROM btwaangiftes
                  WHERE ((((btwaangiftes.boekjaar = (( SELECT vw_boekjaar.boekjaar
                           FROM vw_boekjaar))::integer) AND (btwaangiftes.periode < (( SELECT vw_stamgegevens.value
                           FROM vw_stamgegevens
                          WHERE ((vw_stamgegevens.naam)::text = 'periodetot'::text)))::integer)) AND ((btwaangiftes.acode)::text = '2a'::text)) AND (btwaangiftes.btw > (0)::numeric))
        )) x;


ALTER TABLE public.vw_btw5d_calculus OWNER TO www;

--
-- Name: vw_btwjournaal; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwjournaal AS
 SELECT vw_btwbase.boekjaar,
    vw_btwbase.periode,
    vw_btwbase.ccode,
    vw_btwbase.nummer AS rekening,
    ((('BTW EGALISATIE periode '::text || ((vw_btwbase.periode)::character(2))::text) || ' naar '::text) || t.value) AS omschrijving,
    (vw_btwbase.bedrag * ((-1))::numeric) AS bedrag
   FROM (vw_btwbase
     LEFT JOIN vw_btwtarieven t ON (((t.key)::text = 'rkg_betaaldebtw'::text)))
  WHERE ((vw_btwbase.type = 'btw'::text) AND ((vw_btwbase.ccode)::text !~~ '5d'::text))
UNION ALL
 SELECT vw_btwbase.boekjaar,
    vw_btwbase.periode,
    vw_btwbase.ccode,
    t.value AS rekening,
    ((('BTW EGALISATIE periode '::text || ((vw_btwbase.periode)::character(2))::text) || ' van '::text) || ((vw_btwbase.nummer)::character(4))::text) AS omschrijving,
    vw_btwbase.bedrag
   FROM (vw_btwbase
     LEFT JOIN vw_btwtarieven t ON (((t.key)::text = 'rkg_betaaldebtw'::text)))
  WHERE ((vw_btwbase.type = 'btw'::text) AND ((vw_btwbase.ccode)::text !~~ '5d'::text))
UNION ALL
 SELECT vw_btwbase.boekjaar,
    vw_btwbase.periode,
    vw_btwbase.ccode,
    max(t.value) AS rekening,
    ('Afronding: '::text || ((vw_btwbase.ccode)::character(2))::text) AS omschrijving,
    (round(sum(vw_btwbase.bedrag)) - sum(vw_btwbase.bedrag)) AS bedrag
   FROM (vw_btwbase
     LEFT JOIN vw_btwtarieven t ON (((t.key)::text = 'rkg_betaaldebtw'::text)))
  WHERE ((vw_btwbase.type = 'btw'::text) AND ((vw_btwbase.ccode)::text !~~ '5d'::text))
  GROUP BY vw_btwbase.boekjaar, vw_btwbase.periode, vw_btwbase.ccode
UNION ALL
 SELECT vw_btwbase.boekjaar,
    vw_btwbase.periode,
    vw_btwbase.ccode,
    max(t.value) AS rekening,
    ('Afronding BTW groep: '::text || ((vw_btwbase.ccode)::character(2))::text) AS omschrijving,
    ((round(sum(vw_btwbase.bedrag)) - sum(vw_btwbase.bedrag)) * ((-1))::numeric) AS bedrag
   FROM (vw_btwbase
     LEFT JOIN vw_btwtarieven t ON (((t.key)::text = 'rkg_divopbrengsten'::text)))
  WHERE ((vw_btwbase.type = 'btw'::text) AND ((vw_btwbase.ccode)::text !~~ '5d'::text))
  GROUP BY vw_btwbase.boekjaar, vw_btwbase.periode, vw_btwbase.ccode;


ALTER TABLE public.vw_btwjournaal OWNER TO www;

--
-- Name: vw_btwrubrieken; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_btwrubrieken AS
 SELECT btwkeys.id,
    btwkeys.key,
    btwkeys.type,
    btwkeys.actief,
    btwkeys.ccode,
    btwkeys.acode,
    btwkeys.label,
    btwkeys.labelstam,
    btwkeys.labeldefaults,
    btwkeys.boekjaar,
    btwkeys.active
   FROM btwkeys
  WHERE (((btwkeys.id IN ( SELECT max(btwkeys_1.id) AS id
           FROM btwkeys btwkeys_1
          WHERE (btwkeys_1.boekjaar <= ((( SELECT stamgegevens.value
                   FROM stamgegevens
                  WHERE ((stamgegevens.naam)::text = 'lopendjaar'::text)))::signed)::integer)
          GROUP BY btwkeys_1.key)) AND (((btwkeys.ccode)::text !~~ ''::text) AND ((btwkeys.type)::text <> ALL (ARRAY[('sub'::character varying)::text, ('tot'::character varying)::text])))) OR (((btwkeys.key)::text ~~ '%vrijgesteld%'::text) OR ((btwkeys.key)::text ~~ 'verkopen%'::text)))
  ORDER BY btwkeys.ccode, btwkeys.acode DESC, btwkeys.key, btwkeys.boekjaar DESC;


ALTER TABLE public.vw_btwrubrieken OWNER TO www;

--
-- Name: vw_grootboekkaart; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_grootboekkaart AS
 SELECT vw_boekstuk.journaalid,
    vw_boekstuk.journaalpost,
    vw_boekstuk.grootboekrekening,
    vw_boekstuk.kostenplaats,
    max(vw_boekstuk.boekdatum) AS boekdatum,
    vw_boekstuk.periode,
    vw_boekstuk.dagboekcode,
    ((vw_boekstuk.jomschrijving)::text ||
        CASE
            WHEN ((vw_boekstuk.relatie)::text <> ''::text) THEN ((' ('::text || (vw_boekstuk.relatie)::text) || ')'::text)
            ELSE ''::text
        END) AS jomschrijving,
    sum(vw_boekstuk.bedrag) AS bedrag
   FROM vw_boekstuk
  GROUP BY vw_boekstuk.journaalid, vw_boekstuk.journaalpost, vw_boekstuk.grootboekrekening, vw_boekstuk.kostenplaats, vw_boekstuk.periode, vw_boekstuk.dagboekcode, vw_boekstuk.jomschrijving, vw_boekstuk.relatie
  ORDER BY vw_boekstuk.grootboekrekening, vw_boekstuk.periode, vw_boekstuk.journaalid;


ALTER TABLE public.vw_grootboekkaart OWNER TO www;

--
-- Name: vw_grootboekkaartExp; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW "vw_grootboekkaartExp" AS
 SELECT vw_boekstuk.journaalid,
    vw_boekstuk.journaalpost,
    vw_boekstuk.grootboekrekening,
    vw_boekstuk.kostenplaats,
    vw_boekstuk.boekdatum,
    vw_boekstuk.periode,
    vw_boekstuk.dagboekcode,
    ((vw_boekstuk.bomschrijving)::text ||
        CASE
            WHEN ((vw_boekstuk.relatie)::text <> ''::text) THEN ((' ('::text || (vw_boekstuk.relatie)::text) || ')'::text)
            ELSE ''::text
        END) AS jomschrijving,
    vw_boekstuk.bedrag
   FROM vw_boekstuk
  ORDER BY vw_boekstuk.grootboekrekening, vw_boekstuk.periode, vw_boekstuk.journaalid;


ALTER TABLE public."vw_grootboekkaartExp" OWNER TO www;

--
-- Name: vw_grootboekstamsaldo; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_grootboekstamsaldo AS
 SELECT st.id,
    st.historie,
    st.nummer,
    st.kostenplaats,
    st.active,
    st.populariteit,
    st.type,
    st.nivo,
    st.verdichting,
    st.naam,
    st.btwkey,
    st.btwdefault,
    sa.saldo,
    sa.boekjaar
   FROM (vw_grootboekstam st
     LEFT JOIN grootboeksaldi sa ON (((st.nummer = sa.nummer) AND (sa.boekjaar = (( SELECT vw_boekjaar.boekjaar
           FROM vw_boekjaar))::integer))));


ALTER TABLE public.vw_grootboekstamsaldo OWNER TO www;

--
-- Name: vw_journaalposten; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_journaalposten AS
 SELECT j.journaalid,
    j.journaalpost,
    j.boekjaar,
    j.datum,
    j.periode,
    j.dagboekcode,
    d.type AS dagboektype,
    d.grootboekrekening AS dagboekgrootboekrekening,
    j.jomschrijving,
    j.saldo,
    s.saldo AS boekregelsaldo,
    j.jrelatie,
    j.jnummer,
    j.joorsprong,
    j.tekst
   FROM ((journaal j
     LEFT JOIN vw_dagboeken d ON (((j.dagboekcode)::text = (d.code)::text)))
     LEFT JOIN ( SELECT sum(boekregels.bedrag) AS saldo,
            boekregels.journaalid
           FROM boekregels
          GROUP BY boekregels.journaalid) s ON ((j.journaalid = s.journaalid)))
  WHERE (j.boekjaar = (( SELECT vw_boekjaar.boekjaar
           FROM vw_boekjaar))::integer);


ALTER TABLE public.vw_journaalposten OWNER TO www;

--
-- Name: vw_kostenmatrix; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_kostenmatrix AS
 SELECT a."ID" AS "IDa",
    a.naam AS naama,
    b."ID" AS "IDb",
    b.naam AS naamb,
    c."ID" AS "IDc",
    c.naam AS naamc,
    d."ID" AS "IDd",
    d.naam AS naamd,
    e."ID" AS "IDe",
    e.naam AS naame,
    f."ID" AS "IDf",
    f.naam AS naamf,
    g."ID" AS "IDg",
    g.naam AS naamg
   FROM ((((((kostenplaatsen a
     LEFT JOIN kostenplaatsen b ON ((a."ID" = b."parentID")))
     LEFT JOIN kostenplaatsen c ON ((b."ID" = c."parentID")))
     LEFT JOIN kostenplaatsen d ON ((c."ID" = d."parentID")))
     LEFT JOIN kostenplaatsen e ON ((d."ID" = e."parentID")))
     LEFT JOIN kostenplaatsen f ON ((e."ID" = f."parentID")))
     LEFT JOIN kostenplaatsen g ON ((f."ID" = g."parentID")))
  ORDER BY a."ID", b."ID", c."ID", d."ID", e."ID", f."ID", g."ID";


ALTER TABLE public.vw_kostenmatrix OWNER TO www;

--
-- Name: vw_notinpopular; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_notinpopular AS
 SELECT b.key,
    g.nummer AS value
   FROM (btwkeys b
     JOIN vw_grootboekstam g ON (((b.key)::text = (g.btwkey)::text)))
  WHERE ((b.key)::text ~~ 'rkg%btw%'::text)
UNION
 SELECT dagboeken.naam AS key,
    dagboeken.grootboekrekening AS value
   FROM dagboeken
  WHERE ((dagboeken.type)::text <> ALL (ARRAY[('begin'::character varying)::text, ('memo'::character varying)::text]));


ALTER TABLE public.vw_notinpopular OWNER TO www;

--
-- Name: vw_partbtw_year; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_partbtw_year AS
 SELECT vw_partbtwbedragen.boekjaar,
    sum(vw_partbtwbedragen.bedrag) AS bedrag,
    vw_partbtwbedragen.btwkey
   FROM vw_partbtwbedragen
  GROUP BY vw_partbtwbedragen.boekjaar, vw_partbtwbedragen.btwkey
  ORDER BY vw_partbtwbedragen.boekjaar;


ALTER TABLE public.vw_partbtw_year OWNER TO www;

--
-- Name: vw_partbtw_year_jbedragen; Type: VIEW; Schema: public; Owner: www
--

CREATE VIEW vw_partbtw_year_jbedragen AS
 SELECT b.boekjaar,
    COALESCE(f1.bedrag, (0)::numeric) AS verkopen_partbtwmateriaal,
    COALESCE(f2.bedrag, (0)::numeric) AS verkopen_vrijgesteldebtw,
    COALESCE(f3.bedrag, (0)::numeric) AS inkopen_partbtwmateriaal,
    COALESCE(f4.bedrag, (0)::numeric) AS rkg_btwpartmateriaal,
    COALESCE(f5.bedrag, (0)::numeric) AS dervingbtw_partbtwmateriaal,
    (
        CASE
            WHEN (f1.bedrag IS NULL) THEN f3.bedrag
            WHEN (f2.bedrag IS NULL) THEN (0)::numeric
            ELSE (((f2.bedrag / (f1.bedrag + f2.bedrag)) * COALESCE(f4.bedrag, (0)::numeric)) - COALESCE(f5.bedrag, (0)::numeric))
        END)::numeric(8,2) AS derving_correctie
   FROM (((((vw_boekjaar b
     LEFT JOIN vw_partbtw_year f1 ON ((((b.boekjaar)::integer = f1.boekjaar) AND ((f1.btwkey)::text = 'verkopen_partbtwmateriaal'::text))))
     LEFT JOIN vw_partbtw_year f2 ON ((((b.boekjaar)::integer = f2.boekjaar) AND ((f2.btwkey)::text = 'verkopen_vrijgesteldebtw'::text))))
     LEFT JOIN vw_partbtw_year f3 ON ((((b.boekjaar)::integer = f3.boekjaar) AND ((f3.btwkey)::text = 'inkopen_partbtwmateriaal'::text))))
     LEFT JOIN vw_partbtw_year f4 ON ((((b.boekjaar)::integer = f4.boekjaar) AND ((f4.btwkey)::text = 'rkg_btwpartmateriaal'::text))))
     LEFT JOIN vw_partbtw_year f5 ON ((((b.boekjaar)::integer = f4.boekjaar) AND ((f5.btwkey)::text = 'dervingbtw_partbtwmateriaal'::text))));


ALTER TABLE public.vw_partbtw_year_jbedragen OWNER TO www;

--
-- Name: vwbtw; Type: TABLE; Schema: public; Owner: www; Tablespace: 
--

CREATE TABLE vwbtw (
    boekjaar integer,
    periode integer,
    ccode character varying,
    label text,
    omzet numeric,
    btwbedrag numeric
);


ALTER TABLE public.vwbtw OWNER TO www;

--
-- Name: identifier; Type: DEFAULT; Schema: public; Owner: www
--

ALTER TABLE ONLY kostenplaatsen ALTER COLUMN identifier SET DEFAULT nextval('kostenplaatsen_identifier_seq'::regclass);


--
-- Data for Name: boekregels; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO boekregels VALUES (1, 1, 2010, '2010-12-06', 1200, NULL, 0, 0, 'elgusto', '29134', '', 'Schildering logo in restaurant', 196.35);
INSERT INTO boekregels VALUES (2, 1, 2010, '2010-12-06', 8010, NULL, 3, 0, 'elgusto', '29134', '', 'Schildering logo in restaurant', -165.00);
INSERT INTO boekregels VALUES (3, 1, 2010, '2010-12-06', 2110, NULL, 0, 0, 'elgusto', '29134', '', 'Schildering logo in restaurant', -31.35);
INSERT INTO boekregels VALUES (4, 2, 2010, '2010-12-10', 1200, NULL, 0, 0, 'midholl', '29135', '', 'Griffiti Workshop Nederlek', 1000.00);
INSERT INTO boekregels VALUES (5, 2, 2010, '2010-12-10', 8120, NULL, 0, 0, 'midholl', '29135', '', 'Griffiti Workshop Nederlek', -1000.00);
INSERT INTO boekregels VALUES (6, 3, 2011, '2011-01-09', 1200, NULL, 0, 0, 'woonp', '2011001', '', 'Aanbetaling 18 kunstobjecten op glas', 7518.42);
INSERT INTO boekregels VALUES (7, 3, 2011, '2011-01-09', 8010, NULL, 8, 0, 'woonp', '2011001', '', 'Aanbetaling 18 kunstobjecten op glas', -6318.00);
INSERT INTO boekregels VALUES (8, 3, 2011, '2011-01-09', 2110, NULL, 0, 0, 'woonp', '2011001', '', 'Aanbetaling 18 kunstobjecten op glas', -1200.42);
INSERT INTO boekregels VALUES (9, 4, 2011, '2011-01-18', 1200, NULL, 0, 0, 'particulier', '2011002', '', 'Schilderij', 130.01);
INSERT INTO boekregels VALUES (10, 4, 2011, '2011-01-18', 8020, NULL, 11, 0, 'particulier', '2011002', '', 'Schilderij', -122.65);
INSERT INTO boekregels VALUES (11, 4, 2011, '2011-01-18', 2120, NULL, 0, 0, 'particulier', '2011002', '', 'Schilderij', -7.36);
INSERT INTO boekregels VALUES (12, 5, 2011, '2011-01-19', 1200, NULL, 0, 0, 'midholl', '2011003', '', 'Jongeren workshops', 360.00);
INSERT INTO boekregels VALUES (13, 5, 2011, '2011-01-19', 8120, NULL, 0, 0, 'midholl', '2011003', '', 'Jongeren workshops', -360.00);
INSERT INTO boekregels VALUES (14, 6, 2011, '2011-01-27', 1200, NULL, 0, 0, 'cenf', '2011004', '', 'Materiaalkosten workshop 13 mei', 303.45);
INSERT INTO boekregels VALUES (15, 6, 2011, '2011-01-27', 8140, NULL, 16, 0, 'cenf', '2011004', '', 'Materiaalkosten workshop 13 mei', -255.00);
INSERT INTO boekregels VALUES (16, 6, 2011, '2011-01-27', 2110, NULL, 0, 0, 'cenf', '2011004', '', 'Materiaalkosten workshop 13 mei', -48.45);
INSERT INTO boekregels VALUES (17, 7, 2010, '2010-11-26', 1600, NULL, 0, 0, 'kramer', '52229', '', 'Spuitmateriaal', -145.55);
INSERT INTO boekregels VALUES (18, 7, 2010, '2010-11-26', 4600, NULL, 19, 0, 'kramer', '52229', '', 'Spuitmateriaal', 122.31);
INSERT INTO boekregels VALUES (19, 7, 2010, '2010-11-26', 2200, NULL, 0, 0, 'kramer', '52229', '', 'Spuitmateriaal', 23.24);
INSERT INTO boekregels VALUES (20, 8, 2010, '2010-12-07', 1600, NULL, 0, 0, 'marktplaats', '101100531', '', 'Advertenties', -206.00);
INSERT INTO boekregels VALUES (21, 8, 2010, '2010-12-07', 4500, NULL, 22, 0, 'marktplaats', '101100531', '', 'Advertenties', 173.11);
INSERT INTO boekregels VALUES (22, 8, 2010, '2010-12-07', 2200, NULL, 0, 0, 'marktplaats', '101100531', '', 'Advertenties', 32.89);
INSERT INTO boekregels VALUES (23, 9, 2010, '2010-12-09', 1600, NULL, 0, 0, 'kramer', '52316', '', 'Spuitmateriaal', -166.30);
INSERT INTO boekregels VALUES (24, 9, 2010, '2010-12-09', 4600, NULL, 25, 0, 'kramer', '52316', '', 'Spuitmateriaal', 139.75);
INSERT INTO boekregels VALUES (25, 9, 2010, '2010-12-09', 2200, NULL, 0, 0, 'kramer', '52316', '', 'Spuitmateriaal', 26.55);
INSERT INTO boekregels VALUES (26, 10, 2010, '2010-12-20', 1600, NULL, 0, 0, 'kvk', '241242644', '', 'Kosten inschrijving', -34.04);
INSERT INTO boekregels VALUES (27, 10, 2010, '2010-12-20', 4490, NULL, 0, 0, 'kvk', '241242644', '', 'Kosten inschrijving', 34.04);
INSERT INTO boekregels VALUES (28, 11, 2011, '2011-01-11', 1600, NULL, 0, 0, 'kleyn', '10212291', '', 'Aanschaf Opel Combo 88-BH-JP', -4165.00);
INSERT INTO boekregels VALUES (29, 11, 2011, '2011-01-11', 200, NULL, 0, 0, 'kleyn', '10212291', '', 'Aanschaf Opel Combo 88-BH-JP', 3500.00);
INSERT INTO boekregels VALUES (30, 11, 2011, '2011-01-11', 2210, NULL, 0, 0, 'kleyn', '10212291', '', 'Aanschaf Opel Combo 88-BH-JP', 665.00);
INSERT INTO boekregels VALUES (31, 12, 2011, '2011-01-14', 1600, NULL, 0, 0, 'ifactors', '103036674', '', 'Software upgrade', -49.00);
INSERT INTO boekregels VALUES (32, 12, 2011, '2011-01-14', 4230, NULL, 33, 0, 'ifactors', '103036674', '', 'Software upgrade', 41.18);
INSERT INTO boekregels VALUES (33, 12, 2011, '2011-01-14', 2200, NULL, 0, 0, 'ifactors', '103036674', '', 'Software upgrade', 7.82);
INSERT INTO boekregels VALUES (34, 13, 2011, '2011-01-12', 1600, NULL, 0, 0, 'wehkamp', '12jan', '', 'Autoradio', -122.00);
INSERT INTO boekregels VALUES (35, 13, 2011, '2011-01-12', 4740, NULL, 0, 0, 'wehkamp', '12jan', '', 'Autoradio', 102.52);
INSERT INTO boekregels VALUES (36, 13, 2011, '2011-01-12', 2210, NULL, 0, 0, 'wehkamp', '12jan', '', 'Autoradio', 19.48);
INSERT INTO boekregels VALUES (37, 14, 2011, '2011-01-19', 1600, NULL, 0, 0, 'kramer', '52502', '', 'Spuitmateriaal', -213.75);
INSERT INTO boekregels VALUES (38, 14, 2011, '2011-01-19', 4600, NULL, 39, 0, 'kramer', '52502', '', 'Spuitmateriaal', 179.62);
INSERT INTO boekregels VALUES (39, 14, 2011, '2011-01-19', 2200, NULL, 0, 0, 'kramer', '52502', '', 'Spuitmateriaal', 34.13);
INSERT INTO boekregels VALUES (40, 15, 2011, '2011-01-19', 1600, NULL, 0, 0, 'tmobile', '901128749052', '', 'Telefoon 16-1/15-2', -79.83);
INSERT INTO boekregels VALUES (41, 15, 2011, '2011-01-19', 4240, NULL, 42, 0, 'tmobile', '901128749052', '', 'Telefoon 16-1/15-2', 67.08);
INSERT INTO boekregels VALUES (42, 15, 2011, '2011-01-19', 2200, NULL, 0, 0, 'tmobile', '901128749052', '', 'Telefoon 16-1/15-2', 12.75);
INSERT INTO boekregels VALUES (43, 16, 2011, '2011-01-24', 1600, NULL, 0, 0, 'belasting', '69414993M1', '', 'Wegenbelasting 11-1/7-3', -42.00);
INSERT INTO boekregels VALUES (44, 16, 2011, '2011-01-24', 4730, NULL, 0, 0, 'belasting', '69414993M1', '', 'Wegenbelasting 11-1/7-3', 42.00);
INSERT INTO boekregels VALUES (45, 17, 2011, '2011-01-26', 1600, NULL, 0, 0, 'hofman', '2011031', '', 'Banden', -97.58);
INSERT INTO boekregels VALUES (46, 17, 2011, '2011-01-26', 4740, NULL, 0, 0, 'hofman', '2011031', '', 'Banden', 82.00);
INSERT INTO boekregels VALUES (47, 17, 2011, '2011-01-26', 2210, NULL, 0, 0, 'hofman', '2011031', '', 'Banden', 15.58);
INSERT INTO boekregels VALUES (48, 18, 2011, '2011-01-27', 1600, NULL, 0, 0, 'mediamarkt', '40358967', '', 'Multimedia materiaal', -239.55);
INSERT INTO boekregels VALUES (49, 18, 2011, '2011-01-27', 4210, NULL, 50, 0, 'mediamarkt', '40358967', '', 'Multimedia materiaal', 201.30);
INSERT INTO boekregels VALUES (50, 18, 2011, '2011-01-27', 2200, NULL, 0, 0, 'mediamarkt', '40358967', '', 'Multimedia materiaal', 38.25);
INSERT INTO boekregels VALUES (51, 20, 2010, '2010-11-05', 4600, NULL, 52, 0, '', '', '', 'Spuitmateriaal', 86.92);
INSERT INTO boekregels VALUES (52, 20, 2010, '2010-11-05', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 16.51);
INSERT INTO boekregels VALUES (53, 20, 2010, '2010-11-06', 4220, NULL, 54, 0, '', '', '', 'Schoonmaakmateriaal', 12.32);
INSERT INTO boekregels VALUES (54, 20, 2010, '2010-11-06', 2200, NULL, 0, 0, '', '', '', 'Schoonmaakmateriaal', 2.34);
INSERT INTO boekregels VALUES (55, 20, 2010, '2010-11-06', 4220, NULL, 56, 0, '', '', '', 'Gereedschap', 50.38);
INSERT INTO boekregels VALUES (56, 20, 2010, '2010-11-06', 2200, NULL, 0, 0, '', '', '', 'Gereedschap', 9.57);
INSERT INTO boekregels VALUES (57, 20, 2010, '2010-11-20', 4600, NULL, 58, 0, '', '', '', 'Lijst en doek', 90.76);
INSERT INTO boekregels VALUES (58, 20, 2010, '2010-11-20', 2200, NULL, 0, 0, '', '', '', 'Lijst en doek', 17.24);
INSERT INTO boekregels VALUES (59, 20, 2010, '2010-11-27', 4230, NULL, 60, 0, '', '', '', 'Bureaulamp', 29.40);
INSERT INTO boekregels VALUES (60, 20, 2010, '2010-11-27', 2200, NULL, 0, 0, '', '', '', 'Bureaulamp', 5.59);
INSERT INTO boekregels VALUES (61, 20, 2010, '2010-11-30', 4240, NULL, 62, 0, '', '', '', 'Mobiele telefoon', 46.22);
INSERT INTO boekregels VALUES (62, 20, 2010, '2010-11-30', 2200, NULL, 0, 0, '', '', '', 'Mobiele telefoon', 8.78);
INSERT INTO boekregels VALUES (63, 19, 2011, '2011-01-16', 4400, NULL, 0, 0, '', '', '', 'OV Rotterdam', 14.80);
INSERT INTO boekregels VALUES (64, 19, 2011, '2011-01-16', 4710, NULL, 0, 0, '', '', '', 'Brandstof Opel', 40.49);
INSERT INTO boekregels VALUES (65, 19, 2011, '2011-01-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.69);
INSERT INTO boekregels VALUES (66, 19, 2011, '2011-01-18', 4600, NULL, 67, 0, '', '', '', 'Materiaal', 77.41);
INSERT INTO boekregels VALUES (67, 19, 2011, '2011-01-18', 2200, NULL, 0, 0, '', '', '', 'Materiaal', 14.71);
INSERT INTO boekregels VALUES (68, 19, 2011, '2011-01-18', 4250, NULL, 69, 0, '', '', '', 'Schilderij Borculo', 21.92);
INSERT INTO boekregels VALUES (69, 19, 2011, '2011-01-18', 2200, NULL, 0, 0, '', '', '', 'Schilderij Borculo', 4.16);
INSERT INTO boekregels VALUES (70, 19, 2011, '2011-01-26', 4600, NULL, 71, 0, '', '', '', 'Schildersmateriaal', 51.20);
INSERT INTO boekregels VALUES (71, 19, 2011, '2011-01-26', 2200, NULL, 0, 0, '', '', '', 'Schildersmateriaal', 9.73);
INSERT INTO boekregels VALUES (72, 19, 2011, '2011-01-27', 4710, NULL, 0, 0, '', '', '', 'Brandstof Opel', 41.09);
INSERT INTO boekregels VALUES (73, 19, 2011, '2011-01-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.81);
INSERT INTO boekregels VALUES (74, 19, 2011, '2011-01-27', 4230, NULL, 75, 0, '', '', '', 'USB Stick', 12.61);
INSERT INTO boekregels VALUES (75, 19, 2011, '2011-01-27', 2200, NULL, 0, 0, '', '', '', 'USB Stick', 2.39);
INSERT INTO boekregels VALUES (76, 19, 2011, '2011-01-27', 4230, NULL, 77, 0, '', '', '', 'Verwarming', 35.30);
INSERT INTO boekregels VALUES (77, 19, 2011, '2011-01-27', 2200, NULL, 0, 0, '', '', '', 'Verwarming', 6.71);
INSERT INTO boekregels VALUES (78, 19, 2011, '2011-01-28', 4220, NULL, 79, 0, '', '', '', 'Plakbandroller', 4.19);
INSERT INTO boekregels VALUES (79, 19, 2011, '2011-01-28', 2200, NULL, 0, 0, '', '', '', 'Plakbandroller', 0.80);
INSERT INTO boekregels VALUES (80, 19, 2011, '2011-01-29', 4220, NULL, 81, 0, '', '', '', 'Plakbandroller', 5.87);
INSERT INTO boekregels VALUES (81, 19, 2011, '2011-01-29', 2200, NULL, 0, 0, '', '', '', 'Plakbandroller', 1.11);
INSERT INTO boekregels VALUES (82, 19, 2011, '2011-01-29', 4235, NULL, 83, 0, '', '', '', 'Koffie', 16.51);
INSERT INTO boekregels VALUES (83, 19, 2011, '2011-01-29', 2200, NULL, 0, 0, '', '', '', 'Koffie', 0.99);
INSERT INTO boekregels VALUES (84, 19, 2011, '2011-01-31', 4230, NULL, 85, 0, '', '', '', 'Papier en schoonmaak', 8.76);
INSERT INTO boekregels VALUES (85, 19, 2011, '2011-01-31', 2200, NULL, 0, 0, '', '', '', 'Papier en schoonmaak', 1.67);
INSERT INTO boekregels VALUES (86, 20, 2010, '2010-12-20', 1600, NULL, 0, 4, 'kvk', '241242644', '', 'Factuurbetaling', 34.04);
INSERT INTO boekregels VALUES (87, 22, 2010, '2010-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 31.35);
INSERT INTO boekregels VALUES (88, 22, 2010, '2010-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -31.35);
INSERT INTO boekregels VALUES (89, 22, 2010, '2010-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -142.71);
INSERT INTO boekregels VALUES (90, 22, 2010, '2010-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 142.71);
INSERT INTO boekregels VALUES (91, 22, 2010, '2010-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 4 naar 8900', 0.35);
INSERT INTO boekregels VALUES (92, 22, 2010, '2010-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 4 van 2300', -0.35);
INSERT INTO boekregels VALUES (93, 22, 2010, '2010-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 4 naar 8900', 0.29);
INSERT INTO boekregels VALUES (94, 22, 2010, '2010-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 4 van 2300', -0.29);
INSERT INTO boekregels VALUES (95, 23, 2011, '2011-02-10', 1200, NULL, 0, 0, 'taxione', '2011005', '', 'Schildering paneel', 226.10);
INSERT INTO boekregels VALUES (96, 23, 2011, '2011-02-10', 8140, NULL, 97, 0, 'taxione', '2011005', '', 'Schildering paneel', -190.00);
INSERT INTO boekregels VALUES (97, 23, 2011, '2011-02-10', 2110, NULL, 0, 0, 'taxione', '2011005', '', 'Schildering paneel', -36.10);
INSERT INTO boekregels VALUES (98, 24, 2011, '2011-02-12', 1200, NULL, 0, 0, 'midholl', '2011006', '', 'Workshop Schoonhoven', 855.00);
INSERT INTO boekregels VALUES (99, 24, 2011, '2011-02-12', 8120, NULL, 0, 0, 'midholl', '2011006', '', 'Workshop Schoonhoven', -855.00);
INSERT INTO boekregels VALUES (100, 25, 2011, '2011-02-16', 1200, NULL, 0, 0, 'midholl', '2011007', '', 'Workshop opening JOP Zuidplas', 300.00);
INSERT INTO boekregels VALUES (101, 25, 2011, '2011-02-16', 8120, NULL, 0, 0, 'midholl', '2011007', '', 'Workshop opening JOP Zuidplas', -300.00);
INSERT INTO boekregels VALUES (102, 26, 2011, '2011-02-24', 1200, NULL, 0, 0, 'woonp', '2011008', '', 'Restant 18 kunstobjecten in glas', 4048.38);
INSERT INTO boekregels VALUES (103, 26, 2011, '2011-02-24', 8010, NULL, 104, 0, 'woonp', '2011008', '', 'Restant 18 kunstobjecten in glas', -3402.00);
INSERT INTO boekregels VALUES (104, 26, 2011, '2011-02-24', 2110, NULL, 0, 0, 'woonp', '2011008', '', 'Restant 18 kunstobjecten in glas', -646.38);
INSERT INTO boekregels VALUES (105, 27, 2010, '2010-12-31', 1600, NULL, 0, 1, 'kramer', '52229', '', 'Factuurbetaling', 145.55);
INSERT INTO boekregels VALUES (106, 27, 2010, '2010-12-31', 1600, NULL, 0, 3, 'kramer', '52316', '', 'Factuurbetaling', 166.30);
INSERT INTO boekregels VALUES (107, 27, 2010, '2010-12-31', 1600, NULL, 0, 2, 'marktplaats', '101100531', '', 'Factuurbetaling', 206.00);
INSERT INTO boekregels VALUES (108, 27, 2010, '2010-12-31', 1060, NULL, 0, 0, '', '', '', 'Betaling Kramer', -517.85);
INSERT INTO boekregels VALUES (109, 28, 2010, '2010-12-31', 1200, NULL, 0, 1, 'elgusto', '29134', '', 'Factuurontvangst', -196.35);
INSERT INTO boekregels VALUES (110, 28, 2010, '2010-12-31', 1200, NULL, 0, 2, 'midholl', '29135', '', 'Factuurontvangst', -1000.00);
INSERT INTO boekregels VALUES (111, 28, 2010, '2010-12-31', 1060, NULL, 0, 0, '', '', '', 'Ontvangen debiteuren dec 2010', 1196.35);
INSERT INTO boekregels VALUES (112, 20, 2010, '2010-12-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 3112', -410.07);
INSERT INTO boekregels VALUES (113, 29, 2010, '2010-12-01', 4400, NULL, 0, 0, '', '', '', 'Kilometerkosten El Gusto Veldhoven', 47.50);
INSERT INTO boekregels VALUES (114, 29, 2010, '2010-12-05', 4400, NULL, 0, 0, '', '', '', 'Kilometerkosten El Gusto Veldhoven', 47.50);
INSERT INTO boekregels VALUES (115, 29, 2010, '2010-12-03', 4400, NULL, 0, 0, '', '', '', 'Kilometerkosten Nederlek', 10.26);
INSERT INTO boekregels VALUES (116, 29, 2010, '2010-12-03', 4400, NULL, 0, 0, '', '', '', 'Kilometerkosten Kramer Asd', 27.74);
INSERT INTO boekregels VALUES (117, 29, 2010, '2010-12-15', 4400, NULL, 0, 0, '', '', '', 'Kilometerkosten Streefkerk', 9.88);
INSERT INTO boekregels VALUES (118, 29, 2010, '2010-12-31', 1060, NULL, 0, 0, '', '', '', 'Kilometerkosten dec 2010', -142.88);
INSERT INTO boekregels VALUES (119, 30, 2011, '2011-01-31', 1600, NULL, 0, 0, 'vandien', '13678135', '', 'Verzekering Opel Combi - kwartaal 1', -240.94);
INSERT INTO boekregels VALUES (120, 30, 2011, '2011-01-31', 4720, NULL, 0, 0, 'vandien', '13678135', '', 'Verzekering Opel Combi - kwartaal 1', 240.94);
INSERT INTO boekregels VALUES (121, 31, 2011, '2011-03-01', 1600, NULL, 0, 0, 'vandien', '13767248', '', 'Retour premie kwartaal 1', 68.75);
INSERT INTO boekregels VALUES (122, 31, 2011, '2011-03-01', 4720, NULL, 0, 0, 'vandien', '13767248', '', 'Retour premie kwartaal 1', -68.75);
INSERT INTO boekregels VALUES (123, 32, 2011, '2011-01-31', 1600, NULL, 0, 0, 'vandien', '13678135', '', 'Kwartaal 1 dubbel gefactureerd', -172.19);
INSERT INTO boekregels VALUES (124, 32, 2011, '2011-01-31', 4720, NULL, 0, 0, 'vandien', '13678135', '', 'Kwartaal 1 dubbel gefactureerd', 172.19);
INSERT INTO boekregels VALUES (125, 33, 2011, '2011-02-21', 1600, NULL, 0, 0, 'tmobile', '901130920143', '', 'Telefoon 16-2/15-3', -34.90);
INSERT INTO boekregels VALUES (126, 33, 2011, '2011-02-21', 4240, NULL, 127, 0, 'tmobile', '901130920143', '', 'Telefoon 16-2/15-3', 29.33);
INSERT INTO boekregels VALUES (127, 33, 2011, '2011-02-21', 2200, NULL, 0, 0, 'tmobile', '901130920143', '', 'Telefoon 16-2/15-3', 5.57);
INSERT INTO boekregels VALUES (128, 34, 2011, '2011-02-22', 1600, NULL, 0, 0, 'vendrig', '18320', '', 'Noppenfolie', -54.15);
INSERT INTO boekregels VALUES (129, 34, 2011, '2011-02-22', 4220, NULL, 130, 0, 'vendrig', '18320', '', 'Noppenfolie', 45.50);
INSERT INTO boekregels VALUES (130, 34, 2011, '2011-02-22', 2200, NULL, 0, 0, 'vendrig', '18320', '', 'Noppenfolie', 8.65);
INSERT INTO boekregels VALUES (131, 35, 2011, '2011-02-28', 1600, NULL, 0, 0, 'polijst', '100000079', '', 'Poetsmateriaal', -21.94);
INSERT INTO boekregels VALUES (132, 35, 2011, '2011-02-28', 4220, NULL, 133, 0, 'polijst', '100000079', '', 'Poetsmateriaal', 18.44);
INSERT INTO boekregels VALUES (133, 35, 2011, '2011-02-28', 2200, NULL, 0, 0, 'polijst', '100000079', '', 'Poetsmateriaal', 3.50);
INSERT INTO boekregels VALUES (134, 36, 2011, '2011-02-28', 1600, NULL, 0, 0, 'vandijken', '51144', '', '18 Glazen objecten Woonpartners', -7810.84);
INSERT INTO boekregels VALUES (135, 36, 2011, '2011-02-28', 4600, NULL, 136, 0, 'vandijken', '51144', '', '18 Glazen objecten Woonpartners', 6563.73);
INSERT INTO boekregels VALUES (136, 36, 2011, '2011-02-28', 2200, NULL, 0, 0, 'vandijken', '51144', '', '18 Glazen objecten Woonpartners', 1247.11);
INSERT INTO boekregels VALUES (137, 37, 2011, '2011-03-01', 1600, NULL, 0, 0, '123inkt', '1816393', '', 'Printerinkt', -85.45);
INSERT INTO boekregels VALUES (138, 37, 2011, '2011-03-01', 4230, NULL, 139, 0, '123inkt', '1816393', '', 'Printerinkt', 71.81);
INSERT INTO boekregels VALUES (139, 37, 2011, '2011-03-01', 2200, NULL, 0, 0, '123inkt', '1816393', '', 'Printerinkt', 13.64);
INSERT INTO boekregels VALUES (140, 38, 2011, '2011-03-01', 1600, NULL, 0, 0, 'inmac', '1099635-0100', '', 'Epson printer Stylus PX820FWD', -242.76);
INSERT INTO boekregels VALUES (141, 38, 2011, '2011-03-01', 4210, NULL, 142, 0, 'inmac', '1099635-0100', '', 'Epson printer Stylus PX820FWD', 204.00);
INSERT INTO boekregels VALUES (142, 38, 2011, '2011-03-01', 2200, NULL, 0, 0, 'inmac', '1099635-0100', '', 'Epson printer Stylus PX820FWD', 38.76);
INSERT INTO boekregels VALUES (143, 39, 2011, '2011-04-11', 1600, NULL, 0, 0, 'vandien', '13773165', '', '2e kwartaal verzekering', -167.13);
INSERT INTO boekregels VALUES (144, 39, 2011, '2011-04-11', 4720, NULL, 0, 0, 'vandien', '13773165', '', '2e kwartaal verzekering', 167.13);
INSERT INTO boekregels VALUES (145, 40, 2011, '2011-03-07', 1600, NULL, 0, 0, 'belasting', '69414993M12', '', 'Wegenbelasting 8-3/7-6', -70.00);
INSERT INTO boekregels VALUES (146, 40, 2011, '2011-03-07', 4730, NULL, 0, 0, 'belasting', '69414993M12', '', 'Wegenbelasting 8-3/7-6', 70.00);
INSERT INTO boekregels VALUES (147, 41, 2011, '2011-03-09', 1600, NULL, 0, 0, 'nicolaas', '748927', '', 'Verf', -57.87);
INSERT INTO boekregels VALUES (148, 41, 2011, '2011-03-09', 4600, NULL, 149, 0, 'nicolaas', '748927', '', 'Verf', 48.63);
INSERT INTO boekregels VALUES (149, 41, 2011, '2011-03-09', 2200, NULL, 0, 0, 'nicolaas', '748927', '', 'Verf', 9.24);
INSERT INTO boekregels VALUES (150, 42, 2011, '2011-03-09', 1600, NULL, 0, 0, 'nicolaas', '748929', '', 'Verf', -16.79);
INSERT INTO boekregels VALUES (151, 42, 2011, '2011-03-09', 4600, NULL, 152, 0, 'nicolaas', '748929', '', 'Verf', 14.11);
INSERT INTO boekregels VALUES (152, 42, 2011, '2011-03-09', 2200, NULL, 0, 0, 'nicolaas', '748929', '', 'Verf', 2.68);
INSERT INTO boekregels VALUES (153, 43, 2011, '2011-03-11', 1600, NULL, 0, 0, 'moonen', '2110520', '', 'Materiaal workshops', -85.25);
INSERT INTO boekregels VALUES (154, 43, 2011, '2011-03-11', 4610, NULL, 155, 0, 'moonen', '2110520', '', 'Materiaal workshops', 71.64);
INSERT INTO boekregels VALUES (155, 43, 2011, '2011-03-11', 2220, NULL, 0, 0, 'moonen', '2110520', '', 'Materiaal workshops', 13.61);
INSERT INTO boekregels VALUES (156, 44, 2011, '2011-03-21', 1600, NULL, 0, 0, 'tmobile', '901133104685', '', 'Telefoon 16-3/15-4', -34.90);
INSERT INTO boekregels VALUES (157, 44, 2011, '2011-03-21', 4240, NULL, 158, 0, 'tmobile', '901133104685', '', 'Telefoon 16-3/15-4', 29.33);
INSERT INTO boekregels VALUES (577, 119, 2011, '2011-09-06', 2200, NULL, 0, 0, '', '', '', 'Canvasdoek', 3.83);
INSERT INTO boekregels VALUES (158, 44, 2011, '2011-03-21', 2200, NULL, 0, 0, 'tmobile', '901133104685', '', 'Telefoon 16-3/15-4', 5.57);
INSERT INTO boekregels VALUES (159, 45, 2011, '2011-03-28', 1600, NULL, 0, 0, 'kramer', '52876', '', 'Materialen', -461.95);
INSERT INTO boekregels VALUES (160, 45, 2011, '2011-03-28', 4610, NULL, 161, 0, 'kramer', '52876', '', 'Materialen', 388.19);
INSERT INTO boekregels VALUES (161, 45, 2011, '2011-03-28', 2220, NULL, 0, 0, 'kramer', '52876', '', 'Materialen', 73.76);
INSERT INTO boekregels VALUES (162, 46, 2011, '2011-03-29', 1600, NULL, 0, 0, 'hofman', '2011105', '', 'Reparatie Opel', -61.00);
INSERT INTO boekregels VALUES (163, 46, 2011, '2011-03-29', 4740, NULL, 164, 0, 'hofman', '2011105', '', 'Reparatie Opel', 61.00);
INSERT INTO boekregels VALUES (164, 46, 2011, '2011-03-29', 2210, NULL, 0, 0, 'hofman', '2011105', '', 'Reparatie Opel', 11.59);
INSERT INTO boekregels VALUES (165, 47, 2011, '2011-03-29', 1600, NULL, 0, 0, 'hofman', '2011108', '', 'Reparatie Opel', -144.53);
INSERT INTO boekregels VALUES (166, 47, 2011, '2011-03-29', 4740, NULL, 167, 0, 'hofman', '2011108', '', 'Reparatie Opel', 121.45);
INSERT INTO boekregels VALUES (167, 47, 2011, '2011-03-29', 2210, NULL, 0, 0, 'hofman', '2011108', '', 'Reparatie Opel', 23.08);
INSERT INTO boekregels VALUES (168, 48, 2011, '2011-03-31', 1600, NULL, 0, 0, 'rip', '1100107', '', 'Boeket relatie', -35.50);
INSERT INTO boekregels VALUES (169, 48, 2011, '2011-03-31', 4500, NULL, 170, 0, 'rip', '1100107', '', 'Boeket relatie', 33.49);
INSERT INTO boekregels VALUES (170, 48, 2011, '2011-03-31', 2200, NULL, 0, 0, 'rip', '1100107', '', 'Boeket relatie', 2.01);
INSERT INTO boekregels VALUES (171, 19, 2011, '2011-01-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 01', -387.92);
INSERT INTO boekregels VALUES (172, 49, 2011, '2011-02-19', 4490, NULL, 173, 0, '', '', '', 'Vakliteratuur', 5.65);
INSERT INTO boekregels VALUES (173, 49, 2011, '2011-02-19', 2200, NULL, 0, 0, '', '', '', 'Vakliteratuur', 0.34);
INSERT INTO boekregels VALUES (174, 49, 2011, '2011-02-26', 4230, NULL, 175, 0, '', '', '', 'Enveloppen en briefpapier', 6.67);
INSERT INTO boekregels VALUES (175, 49, 2011, '2011-02-26', 2200, NULL, 0, 0, '', '', '', 'Enveloppen en briefpapier', 1.27);
INSERT INTO boekregels VALUES (176, 49, 2011, '2011-02-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 2', -13.93);
INSERT INTO boekregels VALUES (177, 50, 2011, '2011-03-01', 4740, NULL, 178, 0, '', '', '', 'Olie etc auto', 19.70);
INSERT INTO boekregels VALUES (178, 50, 2011, '2011-03-01', 2210, NULL, 0, 0, '', '', '', 'Olie etc auto', 3.75);
INSERT INTO boekregels VALUES (179, 50, 2011, '2011-03-03', 4710, NULL, 180, 0, '', '', '', 'Brandstof', 44.08);
INSERT INTO boekregels VALUES (180, 50, 2011, '2011-03-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 8.37);
INSERT INTO boekregels VALUES (181, 50, 2011, '2011-03-05', 4600, NULL, 182, 0, '', '', '', 'Spuitverf', 60.67);
INSERT INTO boekregels VALUES (182, 50, 2011, '2011-03-05', 2200, NULL, 0, 0, '', '', '', 'Spuitverf', 11.53);
INSERT INTO boekregels VALUES (183, 50, 2011, '2011-03-09', 4710, NULL, 184, 0, '', '', '', 'Brandstof', 35.78);
INSERT INTO boekregels VALUES (184, 50, 2011, '2011-03-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 6.80);
INSERT INTO boekregels VALUES (185, 50, 2011, '2011-03-12', 4600, NULL, 186, 0, '', '', '', 'Verf en spuitmateriaal', 47.59);
INSERT INTO boekregels VALUES (186, 50, 2011, '2011-03-12', 2200, NULL, 0, 0, '', '', '', 'Verf en spuitmateriaal', 9.04);
INSERT INTO boekregels VALUES (187, 50, 2011, '2011-03-18', 4610, NULL, 188, 0, '', '', '', 'Verf en spuitmateriaal', 35.58);
INSERT INTO boekregels VALUES (188, 50, 2011, '2011-03-18', 2220, NULL, 0, 0, '', '', '', 'Verf en spuitmateriaal', 6.76);
INSERT INTO boekregels VALUES (189, 50, 2011, '2011-03-23', 4600, NULL, 190, 0, '', '', '', 'Schildersdoek', 35.25);
INSERT INTO boekregels VALUES (190, 50, 2011, '2011-03-23', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 6.70);
INSERT INTO boekregels VALUES (191, 50, 2011, '2011-03-26', 4600, NULL, 192, 0, '', '', '', 'Verf', 26.39);
INSERT INTO boekregels VALUES (192, 50, 2011, '2011-03-26', 2200, NULL, 0, 0, '', '', '', 'Verf', 5.01);
INSERT INTO boekregels VALUES (193, 50, 2011, '2011-03-31', 4710, NULL, 194, 0, '', '', '', 'Brandstof', 39.24);
INSERT INTO boekregels VALUES (194, 50, 2011, '2011-03-31', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 7.46);
INSERT INTO boekregels VALUES (195, 50, 2011, '2011-03-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 03', -409.70);
INSERT INTO boekregels VALUES (196, 51, 2011, '2011-03-20', 1200, NULL, 0, 0, 'particulier', '2011009', '', 'Muurschildering Dico en Bo', 571.20);
INSERT INTO boekregels VALUES (197, 51, 2011, '2011-03-20', 8140, NULL, 198, 0, 'particulier', '2011009', '', 'Muurschildering Dico en Bo', -480.00);
INSERT INTO boekregels VALUES (198, 51, 2011, '2011-03-20', 2110, NULL, 0, 0, 'particulier', '2011009', '', 'Muurschildering Dico en Bo', -91.20);
INSERT INTO boekregels VALUES (199, 52, 2011, '2011-03-31', 1200, NULL, 0, 0, 'mwh', '2011010', '', 'Schilderij Stones afscheidscadeau', 150.00);
INSERT INTO boekregels VALUES (200, 52, 2011, '2011-03-31', 8140, NULL, 201, 0, 'mwh', '2011010', '', 'Schilderij Stones afscheidscadeau', -126.05);
INSERT INTO boekregels VALUES (201, 52, 2011, '2011-03-31', 2110, NULL, 0, 0, 'mwh', '2011010', '', 'Schilderij Stones afscheidscadeau', -23.95);
INSERT INTO boekregels VALUES (202, 53, 2011, '2011-02-01', 1600, NULL, 0, 0, 'claasen', '698769', '', 'Latex verf', -47.01);
INSERT INTO boekregels VALUES (203, 53, 2011, '2011-02-01', 4610, NULL, 204, 0, 'claasen', '698769', '', 'Latex verf', 39.50);
INSERT INTO boekregels VALUES (204, 53, 2011, '2011-02-01', 2220, NULL, 0, 0, 'claasen', '698769', '', 'Latex verf', 7.51);
INSERT INTO boekregels VALUES (205, 54, 2011, '2011-02-04', 1600, NULL, 0, 0, 'kvk', '151488299', '', 'Bijdrage KvK 2011', -46.52);
INSERT INTO boekregels VALUES (206, 54, 2011, '2011-02-04', 4490, NULL, 0, 0, 'kvk', '151488299', '', 'Bijdrage KvK 2011', 46.52);
INSERT INTO boekregels VALUES (207, 55, 2011, '2011-02-18', 1600, NULL, 0, 0, 'dorpstraat', '18-02-11', '', 'Kraamhuur Braderie Dorpstraat 14 mei', -192.00);
INSERT INTO boekregels VALUES (208, 55, 2011, '2011-02-18', 4500, NULL, 0, 0, 'dorpstraat', '18-02-11', '', 'Kraamhuur Braderie Dorpstraat 14 mei', 192.00);
INSERT INTO boekregels VALUES (209, 56, 2011, '2011-02-21', 1600, NULL, 0, 0, 'hofman', '2011062', '', 'Reparatie auto', -288.28);
INSERT INTO boekregels VALUES (210, 56, 2011, '2011-02-21', 4740, NULL, 211, 0, 'hofman', '2011062', '', 'Reparatie auto', 242.25);
INSERT INTO boekregels VALUES (211, 56, 2011, '2011-02-21', 2210, NULL, 0, 0, 'hofman', '2011062', '', 'Reparatie auto', 46.03);
INSERT INTO boekregels VALUES (212, 57, 2011, '2011-02-09', 4610, NULL, 213, 0, '', '', '', 'Stofmasker', 1.47);
INSERT INTO boekregels VALUES (213, 57, 2011, '2011-02-09', 2220, NULL, 0, 0, '', '', '', 'Stofmasker', 0.28);
INSERT INTO boekregels VALUES (214, 57, 2011, '2011-02-09', 4610, NULL, 215, 0, '', '', '', 'Panelen', 60.24);
INSERT INTO boekregels VALUES (215, 57, 2011, '2011-02-09', 2220, NULL, 0, 0, '', '', '', 'Panelen', 11.44);
INSERT INTO boekregels VALUES (216, 57, 2011, '2011-02-11', 4710, NULL, 217, 0, '', '', '', 'Brandstof Opel', 39.52);
INSERT INTO boekregels VALUES (217, 57, 2011, '2011-02-11', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.51);
INSERT INTO boekregels VALUES (218, 57, 2011, '2011-02-20', 4710, NULL, 219, 0, '', '', '', 'Brandstof Opel', 33.89);
INSERT INTO boekregels VALUES (219, 57, 2011, '2011-02-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.44);
INSERT INTO boekregels VALUES (220, 57, 2011, '2011-02-22', 4610, NULL, 221, 0, '', '', '', 'Plaatwerk', 8.39);
INSERT INTO boekregels VALUES (221, 57, 2011, '2011-02-22', 2220, NULL, 0, 0, '', '', '', 'Plaatwerk', 1.60);
INSERT INTO boekregels VALUES (222, 57, 2011, '2011-02-22', 4610, NULL, 223, 0, '', '', '', 'Latex en plaatwerk', 39.45);
INSERT INTO boekregels VALUES (223, 57, 2011, '2011-02-22', 2220, NULL, 0, 0, '', '', '', 'Latex en plaatwerk', 7.50);
INSERT INTO boekregels VALUES (224, 57, 2011, '2011-02-25', 4710, NULL, 225, 0, '', '', '', 'Brandstof Opel', 36.77);
INSERT INTO boekregels VALUES (225, 57, 2011, '2011-02-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.99);
INSERT INTO boekregels VALUES (226, 57, 2011, '2011-03-01', 4740, NULL, 227, 0, '', '', '', 'Koelvloeistof', 11.72);
INSERT INTO boekregels VALUES (227, 57, 2011, '2011-03-01', 2210, NULL, 0, 0, '', '', '', 'Koelvloeistof', 2.23);
INSERT INTO boekregels VALUES (228, 57, 2011, '2011-03-03', 4610, NULL, 229, 0, '', '', '', 'Latex handschoenen', 4.19);
INSERT INTO boekregels VALUES (229, 57, 2011, '2011-03-03', 2220, NULL, 0, 0, '', '', '', 'Latex handschoenen', 0.80);
INSERT INTO boekregels VALUES (230, 58, 2011, '2011-03-31', 2220, NULL, 0, 0, '', '', 'btwcorrectie', 'Derving BTW op inkoop partiele materialen 1e kw', -73.80);
INSERT INTO boekregels VALUES (231, 58, 2011, '2011-03-31', 4620, NULL, 0, 0, '', '', '', 'Derving BTW op inkoop partiele materialen 1e kw', 73.80);
INSERT INTO boekregels VALUES (410, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2220', 49.46);
INSERT INTO boekregels VALUES (409, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1b', 0.36);
INSERT INTO boekregels VALUES (408, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2120', -7.36);
INSERT INTO boekregels VALUES (407, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.50);
INSERT INTO boekregels VALUES (406, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -2046.50);
INSERT INTO boekregels VALUES (405, 87, 2011, '2011-03-31', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -49.46);
INSERT INTO boekregels VALUES (404, 87, 2011, '2011-03-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -845.81);
INSERT INTO boekregels VALUES (403, 87, 2011, '2011-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -1505.84);
INSERT INTO boekregels VALUES (402, 87, 2011, '2011-03-31', 2120, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 7.36);
INSERT INTO boekregels VALUES (401, 87, 2011, '2011-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 2046.50);
INSERT INTO boekregels VALUES (244, 57, 2011, '2011-03-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 03a', -280.43);
INSERT INTO boekregels VALUES (245, 60, 2011, '2011-04-27', 1200, NULL, 0, 0, 'ipse', '2011011', '', 'Schildering Willie File Voorstraat 26', 267.75);
INSERT INTO boekregels VALUES (246, 60, 2011, '2011-04-27', 8140, NULL, 247, 0, 'ipse', '2011011', '', 'Schildering Willie File Voorstraat 26', -225.00);
INSERT INTO boekregels VALUES (247, 60, 2011, '2011-04-27', 2110, NULL, 0, 0, 'ipse', '2011011', '', 'Schildering Willie File Voorstraat 26', -42.75);
INSERT INTO boekregels VALUES (248, 61, 2011, '2011-05-05', 1200, NULL, 0, 0, 'woonp', '2011012', '', 'Muurschildering Zuidplas', 285.60);
INSERT INTO boekregels VALUES (249, 61, 2011, '2011-05-05', 8140, NULL, 250, 0, 'woonp', '2011012', '', 'Muurschildering Zuidplas', -240.00);
INSERT INTO boekregels VALUES (250, 61, 2011, '2011-05-05', 2110, NULL, 0, 0, 'woonp', '2011012', '', 'Muurschildering Zuidplas', -45.60);
INSERT INTO boekregels VALUES (251, 62, 2011, '2011-05-05', 1200, NULL, 0, 0, 'woonp', '2011013', '', 'Muurschildering Zuidplas ingang2', 242.76);
INSERT INTO boekregels VALUES (252, 62, 2011, '2011-05-05', 8140, NULL, 253, 0, 'woonp', '2011013', '', 'Muurschildering Zuidplas ingang2', -204.00);
INSERT INTO boekregels VALUES (253, 62, 2011, '2011-05-05', 2110, NULL, 0, 0, 'woonp', '2011013', '', 'Muurschildering Zuidplas ingang2', -38.76);
INSERT INTO boekregels VALUES (254, 63, 2011, '2011-05-16', 1200, NULL, 0, 0, 'cenf', '2011014', '', 'Materialen tbv workshops', 367.71);
INSERT INTO boekregels VALUES (255, 63, 2011, '2011-05-16', 8140, NULL, 256, 0, 'cenf', '2011014', '', 'Materialen tbv workshops', -309.00);
INSERT INTO boekregels VALUES (256, 63, 2011, '2011-05-16', 2110, NULL, 0, 0, 'cenf', '2011014', '', 'Materialen tbv workshops', -58.71);
INSERT INTO boekregels VALUES (257, 64, 2011, '2011-05-31', 1200, NULL, 0, 0, 'midholl', '2011015', '', 'Schildering op paneel', 238.00);
INSERT INTO boekregels VALUES (258, 64, 2011, '2011-05-31', 8140, NULL, 259, 0, 'midholl', '2011015', '', 'Schildering op paneel', -200.00);
INSERT INTO boekregels VALUES (259, 64, 2011, '2011-05-31', 2110, NULL, 0, 0, 'midholl', '2011015', '', 'Schildering op paneel', -38.00);
INSERT INTO boekregels VALUES (260, 65, 2011, '2011-06-01', 1200, NULL, 0, 0, 'gopdelft', '2011016', '', 'Muurschildering goPasta', 595.00);
INSERT INTO boekregels VALUES (261, 65, 2011, '2011-06-01', 8140, NULL, 262, 0, 'gopdelft', '2011016', '', 'Muurschildering goPasta', -500.00);
INSERT INTO boekregels VALUES (262, 65, 2011, '2011-06-01', 2110, NULL, 0, 0, 'gopdelft', '2011016', '', 'Muurschildering goPasta', -95.00);
INSERT INTO boekregels VALUES (263, 66, 2011, '2011-06-02', 1200, NULL, 0, 0, 'dread', '2011017', '', 'Ontwerp character dready dreadzz', 199.99);
INSERT INTO boekregels VALUES (264, 66, 2011, '2011-06-02', 8010, NULL, 265, 0, 'dread', '2011017', '', 'Ontwerp character dready dreadzz', -168.06);
INSERT INTO boekregels VALUES (265, 66, 2011, '2011-06-02', 2110, NULL, 0, 0, 'dread', '2011017', '', 'Ontwerp character dready dreadzz', -31.93);
INSERT INTO boekregels VALUES (266, 67, 2011, '2011-06-23', 1200, NULL, 0, 0, 'rood', '2011017', '', 'Muurschildering goPasta veenendaal', 595.00);
INSERT INTO boekregels VALUES (267, 67, 2011, '2011-06-23', 8140, NULL, 268, 0, 'rood', '2011017', '', 'Muurschildering goPasta veenendaal', -500.00);
INSERT INTO boekregels VALUES (268, 67, 2011, '2011-06-23', 2110, NULL, 0, 0, 'rood', '2011017', '', 'Muurschildering goPasta veenendaal', -95.00);
INSERT INTO boekregels VALUES (269, 68, 2011, '2011-04-06', 1600, NULL, 0, 0, 'hofman', '2011116', '', 'Reparatie auto motorsteun', -200.81);
INSERT INTO boekregels VALUES (270, 68, 2011, '2011-04-06', 4740, NULL, 271, 0, 'hofman', '2011116', '', 'Reparatie auto motorsteun', 168.75);
INSERT INTO boekregels VALUES (271, 68, 2011, '2011-04-06', 2210, NULL, 0, 0, 'hofman', '2011116', '', 'Reparatie auto motorsteun', 32.06);
INSERT INTO boekregels VALUES (272, 69, 2011, '2011-04-13', 1600, NULL, 0, 0, 'kramer', '52992', '', 'Spuitmateriaal', -189.25);
INSERT INTO boekregels VALUES (273, 69, 2011, '2011-04-13', 4610, NULL, 274, 0, 'kramer', '52992', '', 'Spuitmateriaal', 159.03);
INSERT INTO boekregels VALUES (274, 69, 2011, '2011-04-13', 2200, NULL, 0, 0, 'kramer', '52992', '', 'Spuitmateriaal', 30.22);
INSERT INTO boekregels VALUES (275, 70, 2011, '2011-04-21', 1600, NULL, 0, 0, 'tmobile', '901135287534', '', 'Telefoon 16-4/15-5', -34.90);
INSERT INTO boekregels VALUES (276, 70, 2011, '2011-04-21', 4240, NULL, 277, 0, 'tmobile', '901135287534', '', 'Telefoon 16-4/15-5', 29.33);
INSERT INTO boekregels VALUES (277, 70, 2011, '2011-04-21', 2200, NULL, 0, 0, 'tmobile', '901135287534', '', 'Telefoon 16-4/15-5', 5.57);
INSERT INTO boekregels VALUES (278, 71, 2011, '2011-05-03', 1600, NULL, 0, 0, 'verweij', 'VF100182', '', 'Huur atelier 05', -297.50);
INSERT INTO boekregels VALUES (279, 71, 2011, '2011-05-03', 4100, NULL, 280, 0, 'verweij', 'VF100182', '', 'Huur atelier 05', 250.00);
INSERT INTO boekregels VALUES (280, 71, 2011, '2011-05-03', 2200, NULL, 0, 0, 'verweij', 'VF100182', '', 'Huur atelier 05', 47.50);
INSERT INTO boekregels VALUES (281, 72, 2011, '2011-05-11', 1600, NULL, 0, 0, 'hartvh', '15450', '', 'Advertentie braderie', -59.50);
INSERT INTO boekregels VALUES (282, 72, 2011, '2011-05-11', 4500, NULL, 283, 0, 'hartvh', '15450', '', 'Advertentie braderie', 50.00);
INSERT INTO boekregels VALUES (283, 72, 2011, '2011-05-11', 2200, NULL, 0, 0, 'hartvh', '15450', '', 'Advertentie braderie', 9.50);
INSERT INTO boekregels VALUES (284, 73, 2011, '2011-05-15', 1600, NULL, 0, 0, 'tubecl', '82628', '', 'Buizenpoten tbv tafel atelier', -208.04);
INSERT INTO boekregels VALUES (285, 73, 2011, '2011-05-15', 4220, NULL, 286, 0, 'tubecl', '82628', '', 'Buizenpoten tbv tafel atelier', 174.82);
INSERT INTO boekregels VALUES (286, 73, 2011, '2011-05-15', 2200, NULL, 0, 0, 'tubecl', '82628', '', 'Buizenpoten tbv tafel atelier', 33.22);
INSERT INTO boekregels VALUES (287, 74, 2011, '2011-05-26', 1600, NULL, 0, 0, 'kramer', '53237', '', 'Spuitmateriaal', -367.65);
INSERT INTO boekregels VALUES (288, 74, 2011, '2011-05-26', 4610, NULL, 289, 0, 'kramer', '53237', '', 'Spuitmateriaal', 308.95);
INSERT INTO boekregels VALUES (289, 74, 2011, '2011-05-26', 2200, NULL, 0, 0, 'kramer', '53237', '', 'Spuitmateriaal', 58.70);
INSERT INTO boekregels VALUES (290, 75, 2011, '2011-06-08', 1600, NULL, 0, 0, 'kramer', '53327', '', 'Spuitmateriaal', -386.35);
INSERT INTO boekregels VALUES (291, 75, 2011, '2011-06-08', 4610, NULL, 292, 0, 'kramer', '53327', '', 'Spuitmateriaal', 324.66);
INSERT INTO boekregels VALUES (292, 75, 2011, '2011-06-08', 2200, NULL, 0, 0, 'kramer', '53327', '', 'Spuitmateriaal', 61.69);
INSERT INTO boekregels VALUES (293, 76, 2011, '2011-05-24', 1600, NULL, 0, 0, 'delft', '4178454', '', 'Naheffing parkeerbelasting', -72.00);
INSERT INTO boekregels VALUES (294, 76, 2011, '2011-05-24', 4490, NULL, 0, 0, 'delft', '4178454', '', 'Naheffing parkeerbelasting', 72.00);
INSERT INTO boekregels VALUES (295, 77, 2011, '2011-06-06', 1600, NULL, 0, 0, 'verweij', 'VF100198', '', 'Huur atelier 06', -297.50);
INSERT INTO boekregels VALUES (296, 77, 2011, '2011-06-06', 4100, NULL, 297, 0, 'verweij', 'VF100198', '', 'Huur atelier 06', 250.00);
INSERT INTO boekregels VALUES (297, 77, 2011, '2011-06-06', 2200, NULL, 0, 0, 'verweij', 'VF100198', '', 'Huur atelier 06', 47.50);
INSERT INTO boekregels VALUES (298, 78, 2011, '2011-06-06', 1600, NULL, 0, 0, 'vandien', '14053194', '', 'WA Opel 11-7/11-10', -167.13);
INSERT INTO boekregels VALUES (299, 78, 2011, '2011-06-06', 4720, NULL, 0, 0, 'vandien', '14053194', '', 'WA Opel 11-7/11-10', 167.13);
INSERT INTO boekregels VALUES (300, 79, 2011, '2011-06-07', 1600, NULL, 0, 0, 'belasting', '69414993M13', '', 'Wegenbelasting 8-6/7-11', -70.00);
INSERT INTO boekregels VALUES (301, 79, 2011, '2011-06-07', 4730, NULL, 0, 0, 'belasting', '69414993M13', '', 'Wegenbelasting 8-6/7-11', 70.00);
INSERT INTO boekregels VALUES (302, 80, 2011, '2011-06-11', 1600, NULL, 0, 0, 'wehkamp', '20110611', '', 'PB Easynote laptop', -458.95);
INSERT INTO boekregels VALUES (303, 80, 2011, '2011-06-11', 4210, NULL, 304, 0, 'wehkamp', '20110611', '', 'PB Easynote laptop', 385.67);
INSERT INTO boekregels VALUES (304, 80, 2011, '2011-06-11', 2200, NULL, 0, 0, 'wehkamp', '20110611', '', 'PB Easynote laptop', 73.28);
INSERT INTO boekregels VALUES (305, 81, 2011, '2011-06-17', 1600, NULL, 0, 0, 'hofman', '2011195', '', 'Opel grote beurt', -335.70);
INSERT INTO boekregels VALUES (306, 81, 2011, '2011-06-17', 4740, NULL, 307, 0, 'hofman', '2011195', '', 'Opel grote beurt', 282.10);
INSERT INTO boekregels VALUES (307, 81, 2011, '2011-06-17', 2210, NULL, 0, 0, 'hofman', '2011195', '', 'Opel grote beurt', 53.60);
INSERT INTO boekregels VALUES (308, 82, 2011, '2011-06-25', 1600, NULL, 0, 0, 'wehkamp', '20110625', '', 'Senseo en toiletborstel vr atelier', -99.85);
INSERT INTO boekregels VALUES (309, 82, 2011, '2011-06-25', 4220, NULL, 310, 0, 'wehkamp', '20110625', '', 'Senseo en toiletborstel vr atelier', 83.91);
INSERT INTO boekregels VALUES (310, 82, 2011, '2011-06-25', 2200, NULL, 0, 0, 'wehkamp', '20110625', '', 'Senseo en toiletborstel vr atelier', 15.94);
INSERT INTO boekregels VALUES (311, 83, 2011, '2011-06-25', 1600, NULL, 0, 0, 'wehkamp', '20110625', '', 'Ventilatoren atelier', -45.90);
INSERT INTO boekregels VALUES (312, 83, 2011, '2011-06-25', 4220, NULL, 313, 0, 'wehkamp', '20110625', '', 'Ventilatoren atelier', 38.57);
INSERT INTO boekregels VALUES (313, 83, 2011, '2011-06-25', 2200, NULL, 0, 0, 'wehkamp', '20110625', '', 'Ventilatoren atelier', 7.33);
INSERT INTO boekregels VALUES (314, 84, 2011, '2011-06-27', 1600, NULL, 0, 0, 'staples', 'VS63059691', '', 'Olympus cam, Brother printer', -215.96);
INSERT INTO boekregels VALUES (315, 84, 2011, '2011-06-27', 4210, NULL, 0, 0, 'staples', 'VS63059691', '', 'Olympus VR310 camera', 99.00);
INSERT INTO boekregels VALUES (316, 84, 2011, '2011-06-27', 4230, NULL, 0, 0, 'staples', 'VS63059691', '', 'Brother DCP-J715W printer', 69.00);
INSERT INTO boekregels VALUES (317, 84, 2011, '2011-06-27', 4230, NULL, 0, 0, 'staples', 'VS63059691', '', 'USB Stick, markers', 13.48);
INSERT INTO boekregels VALUES (318, 84, 2011, '2011-06-27', 2200, NULL, 0, 0, 'staples', 'VS63059691', '', 'Olympus cam, Brother printer', 34.48);
INSERT INTO boekregels VALUES (319, 85, 2011, '2011-06-30', 1600, NULL, 0, 0, 'vandijken', '52390', '', 'Glazen tafelblad atelier', -431.38);
INSERT INTO boekregels VALUES (320, 85, 2011, '2011-06-30', 4220, NULL, 321, 0, 'vandijken', '52390', '', 'Glazen tafelblad atelier', 362.50);
INSERT INTO boekregels VALUES (321, 85, 2011, '2011-06-30', 2200, NULL, 0, 0, 'vandijken', '52390', '', 'Glazen tafelblad atelier', 68.88);
INSERT INTO boekregels VALUES (322, 86, 2011, '2011-04-03', 4710, NULL, 323, 0, '', '', '', 'Brandstof Opel', 33.62);
INSERT INTO boekregels VALUES (323, 86, 2011, '2011-04-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.39);
INSERT INTO boekregels VALUES (324, 86, 2011, '2011-04-07', 4220, NULL, 325, 0, '', '', '', 'Div bouwmaterialen', 33.71);
INSERT INTO boekregels VALUES (325, 86, 2011, '2011-04-07', 2200, NULL, 0, 0, '', '', '', 'Div bouwmaterialen', 6.40);
INSERT INTO boekregels VALUES (326, 86, 2011, '2011-04-08', 4230, NULL, 327, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO boekregels VALUES (327, 86, 2011, '2011-04-08', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO boekregels VALUES (328, 86, 2011, '2011-04-11', 4710, NULL, 329, 0, '', '', '', 'Brandstof Opel', 49.66);
INSERT INTO boekregels VALUES (329, 86, 2011, '2011-04-11', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.43);
INSERT INTO boekregels VALUES (330, 86, 2011, '2011-04-13', 4600, NULL, 331, 0, '', '', '', 'Schildersdoek', 23.50);
INSERT INTO boekregels VALUES (331, 86, 2011, '2011-04-13', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 4.47);
INSERT INTO boekregels VALUES (332, 86, 2011, '2011-04-16', 4610, NULL, 333, 0, '', '', '', 'Plaatwerk', 17.61);
INSERT INTO boekregels VALUES (333, 86, 2011, '2011-04-16', 2220, NULL, 0, 0, '', '', '', 'Plaatwerk', 3.34);
INSERT INTO boekregels VALUES (334, 86, 2011, '2011-04-23', 4220, NULL, 335, 0, '', '', '', 'Schoonmaakmateriaal', 12.58);
INSERT INTO boekregels VALUES (335, 86, 2011, '2011-04-23', 2200, NULL, 0, 0, '', '', '', 'Schoonmaakmateriaal', 2.39);
INSERT INTO boekregels VALUES (336, 86, 2011, '2011-04-23', 4710, NULL, 337, 0, '', '', '', 'Brandstof Opel', 44.13);
INSERT INTO boekregels VALUES (337, 86, 2011, '2011-04-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.39);
INSERT INTO boekregels VALUES (338, 86, 2011, '2011-04-23', 4740, NULL, 339, 0, '', '', '', 'Wax en koelvloeistof', 22.61);
INSERT INTO boekregels VALUES (339, 86, 2011, '2011-04-23', 2210, NULL, 0, 0, '', '', '', 'Wax en koelvloeistof', 4.29);
INSERT INTO boekregels VALUES (340, 86, 2011, '2011-04-26', 4210, NULL, 341, 0, '', '', '', 'Muziekdevice atelier', 133.61);
INSERT INTO boekregels VALUES (341, 86, 2011, '2011-04-26', 2200, NULL, 0, 0, '', '', '', 'Muziekdevice atelier', 25.39);
INSERT INTO boekregels VALUES (342, 86, 2011, '2011-04-28', 4610, NULL, 343, 0, '', '', '', 'Latex', 10.08);
INSERT INTO boekregels VALUES (343, 86, 2011, '2011-04-28', 2220, NULL, 0, 0, '', '', '', 'Latex', 1.91);
INSERT INTO boekregels VALUES (344, 86, 2011, '2011-04-28', 4610, NULL, 345, 0, '', '', '', 'Latex', 10.08);
INSERT INTO boekregels VALUES (345, 86, 2011, '2011-04-28', 2220, NULL, 0, 0, '', '', '', 'Latex', 1.91);
INSERT INTO boekregels VALUES (346, 86, 2011, '2011-04-30', 4220, NULL, 347, 0, '', '', '', 'Gereedschap', 10.07);
INSERT INTO boekregels VALUES (347, 86, 2011, '2011-04-30', 2200, NULL, 0, 0, '', '', '', 'Gereedschap', 1.91);
INSERT INTO boekregels VALUES (348, 86, 2011, '2011-05-03', 4220, NULL, 349, 0, '', '', '', 'Deurmat atelier', 4.19);
INSERT INTO boekregels VALUES (349, 86, 2011, '2011-05-03', 2200, NULL, 0, 0, '', '', '', 'Deurmat atelier', 0.80);
INSERT INTO boekregels VALUES (350, 86, 2011, '2011-05-05', 4710, NULL, 351, 0, '', '', '', 'Brandstof Opel', 39.10);
INSERT INTO boekregels VALUES (351, 86, 2011, '2011-05-05', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.43);
INSERT INTO boekregels VALUES (352, 86, 2011, '2011-05-06', 4610, NULL, 353, 0, '', '', '', 'Latex', 10.08);
INSERT INTO boekregels VALUES (353, 86, 2011, '2011-05-06', 2220, NULL, 0, 0, '', '', '', 'Latex', 1.91);
INSERT INTO boekregels VALUES (354, 86, 2011, '2011-05-07', 4220, NULL, 355, 0, '', '', '', 'Gereedschap en tuinmat. atelier', 7.13);
INSERT INTO boekregels VALUES (355, 86, 2011, '2011-05-07', 2200, NULL, 0, 0, '', '', '', 'Gereedschap en tuinmat. atelier', 1.35);
INSERT INTO boekregels VALUES (356, 86, 2011, '2011-05-13', 4230, NULL, 357, 0, '', '', '', 'Businesscards en plastic hoezen', 9.16);
INSERT INTO boekregels VALUES (357, 86, 2011, '2011-05-13', 2200, NULL, 0, 0, '', '', '', 'Businesscards en plastic hoezen', 1.74);
INSERT INTO boekregels VALUES (358, 86, 2011, '2011-05-16', 4220, NULL, 359, 0, '', '', '', 'Elektra materiaal atelier', 98.82);
INSERT INTO boekregels VALUES (359, 86, 2011, '2011-05-16', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 18.77);
INSERT INTO boekregels VALUES (360, 86, 2011, '2011-05-17', 4220, NULL, 361, 0, '', '', '', 'Elektra materiaal atelier', 92.08);
INSERT INTO boekregels VALUES (361, 86, 2011, '2011-05-17', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 17.49);
INSERT INTO boekregels VALUES (362, 86, 2011, '2011-05-17', 4220, NULL, 363, 0, '', '', '', 'Mini bakoven in atelier', 16.81);
INSERT INTO boekregels VALUES (363, 86, 2011, '2011-05-17', 2200, NULL, 0, 0, '', '', '', 'Mini bakoven in atelier', 3.19);
INSERT INTO boekregels VALUES (364, 86, 2011, '2011-05-18', 4710, NULL, 365, 0, '', '', '', 'Brandstof Opel', 42.21);
INSERT INTO boekregels VALUES (365, 86, 2011, '2011-05-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.02);
INSERT INTO boekregels VALUES (366, 86, 2011, '2011-05-27', 4230, NULL, 367, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO boekregels VALUES (367, 86, 2011, '2011-05-27', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO boekregels VALUES (368, 86, 2011, '2011-05-27', 4600, NULL, 369, 0, '', '', '', 'Schildersdoek', 80.61);
INSERT INTO boekregels VALUES (369, 86, 2011, '2011-05-27', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 15.31);
INSERT INTO boekregels VALUES (370, 86, 2011, '2011-05-28', 4230, NULL, 371, 0, '', '', '', 'Elektra materiaal kantoor', 8.39);
INSERT INTO boekregels VALUES (371, 86, 2011, '2011-05-28', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal kantoor', 1.60);
INSERT INTO boekregels VALUES (372, 86, 2011, '2011-06-01', 4710, NULL, 373, 0, '', '', '', 'Brandstof Opel', 20.99);
INSERT INTO boekregels VALUES (373, 86, 2011, '2011-06-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 3.99);
INSERT INTO boekregels VALUES (374, 86, 2011, '2011-06-04', 4710, NULL, 375, 0, '', '', '', 'Brandstof Opel', 32.74);
INSERT INTO boekregels VALUES (375, 86, 2011, '2011-06-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.22);
INSERT INTO boekregels VALUES (376, 86, 2011, '2011-06-09', 4710, NULL, 377, 0, '', '', '', 'Brandstof Opel', 41.82);
INSERT INTO boekregels VALUES (377, 86, 2011, '2011-06-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.94);
INSERT INTO boekregels VALUES (378, 86, 2011, '2011-06-10', 4490, NULL, 0, 0, '', '', '', 'Lunch', 26.15);
INSERT INTO boekregels VALUES (379, 86, 2011, '2011-06-10', 2200, NULL, 0, 0, '', '', '', 'Lunch', 1.95);
INSERT INTO boekregels VALUES (380, 86, 2011, '2011-06-15', 4600, NULL, 381, 0, '', '', '', 'Schildersdoek', 37.79);
INSERT INTO boekregels VALUES (381, 86, 2011, '2011-06-15', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 7.18);
INSERT INTO boekregels VALUES (382, 86, 2011, '2011-06-15', 4600, NULL, 383, 0, '', '', '', 'Schildersdoek', 16.16);
INSERT INTO boekregels VALUES (383, 86, 2011, '2011-06-15', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 3.07);
INSERT INTO boekregels VALUES (384, 86, 2011, '2011-06-17', 4600, NULL, 385, 0, '', '', '', 'Vernis', 43.11);
INSERT INTO boekregels VALUES (385, 86, 2011, '2011-06-17', 2200, NULL, 0, 0, '', '', '', 'Vernis', 8.19);
INSERT INTO boekregels VALUES (386, 86, 2011, '2011-06-21', 4490, NULL, 387, 0, '', '', '', 'Diner', 8.49);
INSERT INTO boekregels VALUES (387, 86, 2011, '2011-06-21', 2200, NULL, 0, 0, '', '', '', 'Diner', 0.51);
INSERT INTO boekregels VALUES (388, 86, 2011, '2011-06-23', 4220, NULL, 389, 0, '', '', '', 'Tijdschrift', 6.37);
INSERT INTO boekregels VALUES (389, 86, 2011, '2011-06-23', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.38);
INSERT INTO boekregels VALUES (390, 86, 2011, '2011-06-24', 4710, NULL, 391, 0, '', '', '', 'Brandstof Opel', 46.96);
INSERT INTO boekregels VALUES (391, 86, 2011, '2011-06-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.92);
INSERT INTO boekregels VALUES (392, 86, 2011, '2011-06-24', 4490, NULL, 393, 0, '', '', '', 'Diner', 7.97);
INSERT INTO boekregels VALUES (393, 86, 2011, '2011-06-24', 2200, NULL, 0, 0, '', '', '', 'Diner', 0.48);
INSERT INTO boekregels VALUES (394, 86, 2011, '2011-06-24', 4710, NULL, 395, 0, '', '', '', 'Brandstof Kawasaki promotierit', 18.15);
INSERT INTO boekregels VALUES (395, 86, 2011, '2011-06-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Kawasaki promotierit', 3.45);
INSERT INTO boekregels VALUES (396, 86, 2011, '2011-06-26', 4220, NULL, 397, 0, '', '', '', 'Zaag', 11.39);
INSERT INTO boekregels VALUES (397, 86, 2011, '2011-06-26', 2200, NULL, 0, 0, '', '', '', 'Zaag', 2.16);
INSERT INTO boekregels VALUES (398, 86, 2011, '2011-06-29', 4235, NULL, 399, 0, '', '', '', 'Div dranken atelier', 28.28);
INSERT INTO boekregels VALUES (399, 86, 2011, '2011-06-29', 2200, NULL, 0, 0, '', '', '', 'Div dranken atelier', 3.56);
INSERT INTO boekregels VALUES (400, 86, 2011, '2011-06-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 04', -1380.02);
INSERT INTO boekregels VALUES (411, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2210', 845.81);
INSERT INTO boekregels VALUES (412, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 1505.84);
INSERT INTO boekregels VALUES (413, 87, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.11);
INSERT INTO boekregels VALUES (414, 87, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.50);
INSERT INTO boekregels VALUES (415, 87, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1b', -0.36);
INSERT INTO boekregels VALUES (416, 87, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.11);
INSERT INTO boekregels VALUES (417, 88, 2011, '2011-06-25', 1200, NULL, 0, 0, 'particulier', '2011018', '', 'Muurschildering Daen, i.o. Jeroen Verboom', 743.75);
INSERT INTO boekregels VALUES (418, 88, 2011, '2011-06-25', 8140, NULL, 419, 0, 'particulier', '2011018', '', 'Muurschildering Daen, i.o. Jeroen Verboom', -625.00);
INSERT INTO boekregels VALUES (419, 88, 2011, '2011-06-25', 2110, NULL, 0, 0, 'particulier', '2011018', '', 'Muurschildering Daen, i.o. Jeroen Verboom', -118.75);
INSERT INTO boekregels VALUES (420, 89, 2011, '2011-06-29', 1200, NULL, 0, 0, 'particulier', '2011019', '', 'Muurschildering Rafiq iov Erik van Dam', 357.00);
INSERT INTO boekregels VALUES (421, 89, 2011, '2011-06-29', 8140, NULL, 422, 0, 'particulier', '2011019', '', 'Muurschildering Rafiq iov Erik van Dam', -300.00);
INSERT INTO boekregels VALUES (422, 89, 2011, '2011-06-29', 2110, NULL, 0, 0, 'particulier', '2011019', '', 'Muurschildering Rafiq iov Erik van Dam', -57.00);
INSERT INTO boekregels VALUES (423, 90, 2011, '2011-06-29', 1200, NULL, 0, 0, 'particulier', '2011020', '', 'Schilderij en muursch Janet Flierman', 535.50);
INSERT INTO boekregels VALUES (424, 90, 2011, '2011-06-29', 8140, NULL, 425, 0, 'particulier', '2011020', '', 'Schilderij en muursch Janet Flierman', -450.00);
INSERT INTO boekregels VALUES (425, 90, 2011, '2011-06-29', 2110, NULL, 0, 0, 'particulier', '2011020', '', 'Schilderij en muursch Janet Flierman', -85.50);
INSERT INTO boekregels VALUES (426, 91, 2011, '2011-06-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 707.00);
INSERT INTO boekregels VALUES (427, 91, 2011, '2011-06-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -622.78);
INSERT INTO boekregels VALUES (428, 91, 2011, '2011-06-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -160.13);
INSERT INTO boekregels VALUES (429, 91, 2011, '2011-06-30', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -9.07);
INSERT INTO boekregels VALUES (430, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -707.00);
INSERT INTO boekregels VALUES (431, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.00);
INSERT INTO boekregels VALUES (432, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2220', 9.07);
INSERT INTO boekregels VALUES (433, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2210', 160.13);
INSERT INTO boekregels VALUES (434, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 622.78);
INSERT INTO boekregels VALUES (435, 91, 2011, '2011-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', 0.02);
INSERT INTO boekregels VALUES (436, 91, 2011, '2011-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.00);
INSERT INTO boekregels VALUES (437, 91, 2011, '2011-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', -0.02);
INSERT INTO boekregels VALUES (438, 92, 2011, '2011-07-24', 1200, NULL, 0, 0, 'ipse', '2011021', '', 'Schildering Wiebine', 377.83);
INSERT INTO boekregels VALUES (439, 92, 2011, '2011-07-24', 8140, NULL, 440, 0, 'ipse', '2011021', '', 'Schildering Wiebine', -317.50);
INSERT INTO boekregels VALUES (440, 92, 2011, '2011-07-24', 2110, NULL, 0, 0, 'ipse', '2011021', '', 'Schildering Wiebine', -60.33);
INSERT INTO boekregels VALUES (441, 93, 2011, '2011-08-18', 1200, NULL, 0, 0, 'stek', '2011022', '', 'Muurschildering', 327.25);
INSERT INTO boekregels VALUES (442, 93, 2011, '2011-08-18', 8140, NULL, 443, 0, 'stek', '2011022', '', 'Muurschildering', -275.00);
INSERT INTO boekregels VALUES (443, 93, 2011, '2011-08-18', 2110, NULL, 0, 0, 'stek', '2011022', '', 'Muurschildering', -52.25);
INSERT INTO boekregels VALUES (444, 94, 2011, '2011-08-19', 1200, NULL, 0, 0, 'ipse', '2011024', '', 'Schildering Benjamin', 238.00);
INSERT INTO boekregels VALUES (445, 94, 2011, '2011-08-19', 8140, NULL, 446, 0, 'ipse', '2011024', '', 'Schildering Benjamin', -200.00);
INSERT INTO boekregels VALUES (446, 94, 2011, '2011-08-19', 2110, NULL, 0, 0, 'ipse', '2011024', '', 'Schildering Benjamin', -38.00);
INSERT INTO boekregels VALUES (447, 95, 2011, '2011-08-18', 1200, NULL, 0, 0, 'vdEnde', '2011023', '', 'Schilderij We Will Rock You', 499.80);
INSERT INTO boekregels VALUES (448, 95, 2011, '2011-08-18', 8010, NULL, 449, 0, 'vdEnde', '2011023', '', 'Schilderij We Will Rock You', -420.00);
INSERT INTO boekregels VALUES (449, 95, 2011, '2011-08-18', 2110, NULL, 0, 0, 'vdEnde', '2011023', '', 'Schilderij We Will Rock You', -79.80);
INSERT INTO boekregels VALUES (450, 96, 2011, '2011-08-26', 1200, NULL, 0, 0, 'kruimels', '2011025', '', 'Muurschildering binnenmuur', 333.20);
INSERT INTO boekregels VALUES (451, 96, 2011, '2011-08-26', 8140, NULL, 452, 0, 'kruimels', '2011025', '', 'Muurschildering binnenmuur', -280.00);
INSERT INTO boekregels VALUES (452, 96, 2011, '2011-08-26', 2110, NULL, 0, 0, 'kruimels', '2011025', '', 'Muurschildering binnenmuur', -53.20);
INSERT INTO boekregels VALUES (453, 97, 2011, '2011-09-01', 1200, NULL, 0, 0, 'kruimels', '2011026', '', 'Menukaart', 422.45);
INSERT INTO boekregels VALUES (454, 97, 2011, '2011-09-01', 8010, NULL, 455, 0, 'kruimels', '2011026', '', 'Menukaart', -355.00);
INSERT INTO boekregels VALUES (455, 97, 2011, '2011-09-01', 2110, NULL, 0, 0, 'kruimels', '2011026', '', 'Menukaart', -67.45);
INSERT INTO boekregels VALUES (456, 98, 2011, '2011-09-19', 1200, NULL, 0, 0, 'gopbremen', '2011027', '', 'Muurschildering goPasta Bremen', 625.00);
INSERT INTO boekregels VALUES (457, 98, 2011, '2011-09-19', 8030, NULL, 0, 0, 'gopbremen', '2011027', '', 'Muurschildering goPasta Bremen', -625.00);
INSERT INTO boekregels VALUES (458, 99, 2011, '2011-09-19', 1200, NULL, 0, 0, 'particulier', '2011028', '', 'Schilderij Anne-Fleur Derks', 150.00);
INSERT INTO boekregels VALUES (459, 99, 2011, '2011-09-19', 8010, NULL, 460, 0, 'particulier', '2011028', '', 'Schilderij Anne-Fleur Derks', -126.05);
INSERT INTO boekregels VALUES (460, 99, 2011, '2011-09-19', 2110, NULL, 0, 0, 'particulier', '2011028', '', 'Schilderij Anne-Fleur Derks', -23.95);
INSERT INTO boekregels VALUES (461, 100, 2011, '2011-07-01', 1600, NULL, 0, 0, 'verweij', 'VF100215', '', 'Huur atelier 07', -297.50);
INSERT INTO boekregels VALUES (462, 100, 2011, '2011-07-01', 4100, NULL, 463, 0, 'verweij', 'VF100215', '', 'Huur atelier 07', 250.00);
INSERT INTO boekregels VALUES (463, 100, 2011, '2011-07-01', 2200, NULL, 0, 0, 'verweij', 'VF100215', '', 'Huur atelier 07', 47.50);
INSERT INTO boekregels VALUES (464, 101, 2011, '2011-07-06', 1600, NULL, 0, 0, 'vodafone', '175890026', '', 'Internet dongle juli', -25.00);
INSERT INTO boekregels VALUES (465, 101, 2011, '2011-07-06', 4245, NULL, 466, 0, 'vodafone', '175890026', '', 'Internet dongle juli', 21.01);
INSERT INTO boekregels VALUES (466, 101, 2011, '2011-07-06', 2200, NULL, 0, 0, 'vodafone', '175890026', '', 'Internet dongle juli', 3.99);
INSERT INTO boekregels VALUES (467, 102, 2011, '2011-07-07', 1600, NULL, 0, 0, 'kramer', '53533', '', 'Spuitmateriaal', -434.00);
INSERT INTO boekregels VALUES (468, 102, 2011, '2011-07-07', 4610, NULL, 469, 0, 'kramer', '53533', '', 'Spuitmateriaal', 364.71);
INSERT INTO boekregels VALUES (469, 102, 2011, '2011-07-07', 2220, NULL, 0, 0, 'kramer', '53533', '', 'Spuitmateriaal', 69.29);
INSERT INTO boekregels VALUES (470, 103, 2011, '2011-08-01', 1600, NULL, 0, 0, 'verweij', '100229', '', 'Huur atelier 08', -297.50);
INSERT INTO boekregels VALUES (471, 103, 2011, '2011-08-01', 4100, NULL, 472, 0, 'verweij', '100229', '', 'Huur atelier 08', 250.00);
INSERT INTO boekregels VALUES (472, 103, 2011, '2011-08-01', 2200, NULL, 0, 0, 'verweij', '100229', '', 'Huur atelier 08', 47.50);
INSERT INTO boekregels VALUES (473, 104, 2011, '2011-08-09', 1600, NULL, 0, 0, 'kramer', '53683', '', 'Spuitmateriaal', -165.00);
INSERT INTO boekregels VALUES (474, 104, 2011, '2011-08-09', 4610, NULL, 475, 0, 'kramer', '53683', '', 'Spuitmateriaal', 138.66);
INSERT INTO boekregels VALUES (475, 104, 2011, '2011-08-09', 2220, NULL, 0, 0, 'kramer', '53683', '', 'Spuitmateriaal', 26.34);
INSERT INTO boekregels VALUES (476, 105, 2011, '2011-08-11', 1600, NULL, 0, 0, 'sligro', '5457062', '', 'Versnaperingen feest atelier', -121.96);
INSERT INTO boekregels VALUES (477, 105, 2011, '2011-08-11', 4235, NULL, 478, 0, 'sligro', '5457062', '', 'Versnaperingen feest atelier', 86.50);
INSERT INTO boekregels VALUES (478, 105, 2011, '2011-08-11', 2200, NULL, 0, 0, 'sligro', '5457062', '', 'Versnaperingen feest atelier', 35.46);
INSERT INTO boekregels VALUES (479, 106, 2011, '2011-08-06', 1600, NULL, 0, 0, 'vodafone', '178515545', '', 'Internet dongle aug', -25.00);
INSERT INTO boekregels VALUES (480, 106, 2011, '2011-08-06', 4245, NULL, 481, 0, 'vodafone', '178515545', '', 'Internet dongle aug', 21.01);
INSERT INTO boekregels VALUES (481, 106, 2011, '2011-08-06', 2200, NULL, 0, 0, 'vodafone', '178515545', '', 'Internet dongle aug', 3.99);
INSERT INTO boekregels VALUES (482, 107, 2011, '2011-08-30', 1600, NULL, 0, 0, 'mediamarkt', '40430000', '', 'Harde schijven voor NAS', -179.98);
INSERT INTO boekregels VALUES (483, 107, 2011, '2011-08-30', 4210, NULL, 484, 0, 'mediamarkt', '40430000', '', 'Harde schijven voor NAS', 151.24);
INSERT INTO boekregels VALUES (484, 107, 2011, '2011-08-30', 2200, NULL, 0, 0, 'mediamarkt', '40430000', '', 'Harde schijven voor NAS', 28.74);
INSERT INTO boekregels VALUES (485, 108, 2011, '2011-08-30', 1600, NULL, 0, 0, 'mediamarkt', '40429997', '', 'NAS', -283.00);
INSERT INTO boekregels VALUES (486, 108, 2011, '2011-08-30', 4210, NULL, 487, 0, 'mediamarkt', '40429997', '', 'NAS', 237.82);
INSERT INTO boekregels VALUES (487, 108, 2011, '2011-08-30', 2200, NULL, 0, 0, 'mediamarkt', '40429997', '', 'NAS', 45.18);
INSERT INTO boekregels VALUES (488, 109, 2011, '2011-07-23', 1600, NULL, 0, 0, 'hofman', '2011237', '', 'Onderhoud en reparatie', -771.57);
INSERT INTO boekregels VALUES (489, 109, 2011, '2011-07-23', 4740, NULL, 490, 0, 'hofman', '2011237', '', 'Onderhoud en reparatie', 648.38);
INSERT INTO boekregels VALUES (490, 109, 2011, '2011-07-23', 2210, NULL, 0, 0, 'hofman', '2011237', '', 'Onderhoud en reparatie', 123.19);
INSERT INTO boekregels VALUES (491, 110, 2011, '2011-09-01', 1600, NULL, 0, 0, 'verweij', '100245', '', 'Huur atelier 09', -297.50);
INSERT INTO boekregels VALUES (492, 110, 2011, '2011-09-01', 4100, NULL, 493, 0, 'verweij', '100245', '', 'Huur atelier 09', 250.00);
INSERT INTO boekregels VALUES (493, 110, 2011, '2011-09-01', 2200, NULL, 0, 0, 'verweij', '100245', '', 'Huur atelier 09', 47.50);
INSERT INTO boekregels VALUES (494, 111, 2011, '2011-09-07', 1600, NULL, 0, 0, 'vodafone', '181195660', '', 'Internet dongle sep', -25.83);
INSERT INTO boekregels VALUES (495, 111, 2011, '2011-09-07', 4245, NULL, 496, 0, 'vodafone', '181195660', '', 'Internet dongle sep', 21.71);
INSERT INTO boekregels VALUES (496, 111, 2011, '2011-09-07', 2200, NULL, 0, 0, 'vodafone', '181195660', '', 'Internet dongle sep', 4.12);
INSERT INTO boekregels VALUES (497, 112, 2011, '2011-09-05', 1600, NULL, 0, 0, 'vandien', '14356999', '', 'Verzekering auto 11-10/11-01', -167.13);
INSERT INTO boekregels VALUES (498, 112, 2011, '2011-09-05', 4720, NULL, 0, 0, 'vandien', '14356999', '', 'Verzekering auto 11-10/11-01', 167.13);
INSERT INTO boekregels VALUES (616, 121, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.18);
INSERT INTO boekregels VALUES (615, 121, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.07);
INSERT INTO boekregels VALUES (614, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.18);
INSERT INTO boekregels VALUES (502, 114, 2011, '2011-09-09', 1600, NULL, 0, 0, 'belasting', '69414993M15', '', 'Wegenbelasting 8-9/7-12', -70.00);
INSERT INTO boekregels VALUES (503, 114, 2011, '2011-09-09', 4730, NULL, 0, 0, 'belasting', '69414993M15', '', 'Wegenbelasting 8-9/7-12', 70.00);
INSERT INTO boekregels VALUES (504, 115, 2011, '2011-09-19', 1600, NULL, 0, 0, 'dms', '11037', '', 'Verduisteringsdoek atelier', -58.00);
INSERT INTO boekregels VALUES (505, 115, 2011, '2011-09-19', 4220, NULL, 506, 0, 'dms', '11037', '', 'Verduisteringsdoek atelier', 48.74);
INSERT INTO boekregels VALUES (506, 115, 2011, '2011-09-19', 2200, NULL, 0, 0, 'dms', '11037', '', 'Verduisteringsdoek atelier', 9.26);
INSERT INTO boekregels VALUES (507, 116, 2011, '2011-09-27', 1600, NULL, 0, 0, 'hofman', '2011287', '', 'Distributieriem defect', -694.86);
INSERT INTO boekregels VALUES (508, 116, 2011, '2011-09-27', 4740, NULL, 509, 0, 'hofman', '2011287', '', 'Distributieriem defect', 583.92);
INSERT INTO boekregels VALUES (509, 116, 2011, '2011-09-27', 2210, NULL, 0, 0, 'hofman', '2011287', '', 'Distributieriem defect', 110.94);
INSERT INTO boekregels VALUES (510, 117, 2011, '2011-07-01', 4230, NULL, 511, 0, '', '', '', 'Printerpapier', 5.02);
INSERT INTO boekregels VALUES (511, 117, 2011, '2011-07-01', 2200, NULL, 0, 0, '', '', '', 'Printerpapier', 0.95);
INSERT INTO boekregels VALUES (512, 117, 2011, '2011-07-01', 4230, NULL, 513, 0, '', '', '', 'Tijdschriften', 10.84);
INSERT INTO boekregels VALUES (513, 117, 2011, '2011-07-01', 2200, NULL, 0, 0, '', '', '', 'Tijdschriften', 0.65);
INSERT INTO boekregels VALUES (514, 117, 2011, '2011-07-01', 4490, NULL, 0, 0, '', '', '', 'Parkeren Utrecht', 13.46);
INSERT INTO boekregels VALUES (515, 117, 2011, '2011-07-03', 4710, NULL, 516, 0, '', '', '', 'Brandstof Opel', 47.05);
INSERT INTO boekregels VALUES (516, 117, 2011, '2011-07-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.94);
INSERT INTO boekregels VALUES (517, 117, 2011, '2011-07-05', 4220, NULL, 518, 0, '', '', '', 'Elektra materiaal atelier', 23.11);
INSERT INTO boekregels VALUES (518, 117, 2011, '2011-07-05', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 4.39);
INSERT INTO boekregels VALUES (519, 117, 2011, '2011-07-05', 4710, NULL, 520, 0, '', '', '', 'Brandstof Opel', 35.31);
INSERT INTO boekregels VALUES (520, 117, 2011, '2011-07-05', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.71);
INSERT INTO boekregels VALUES (521, 117, 2011, '2011-07-07', 4220, NULL, 522, 0, '', '', '', 'Kettingslot atelier', 15.08);
INSERT INTO boekregels VALUES (522, 117, 2011, '2011-07-07', 2200, NULL, 0, 0, '', '', '', 'Kettingslot atelier', 2.87);
INSERT INTO boekregels VALUES (523, 117, 2011, '2011-07-08', 4490, NULL, 524, 0, '', '', '', 'Eten onderweg', 5.00);
INSERT INTO boekregels VALUES (524, 117, 2011, '2011-07-08', 2200, NULL, 0, 0, '', '', '', 'Eten onderweg', 0.30);
INSERT INTO boekregels VALUES (525, 117, 2011, '2011-07-09', 4220, NULL, 526, 0, '', '', '', 'Bouwmateriaal atelier', 35.18);
INSERT INTO boekregels VALUES (526, 117, 2011, '2011-07-09', 2200, NULL, 0, 0, '', '', '', 'Bouwmateriaal atelier', 6.68);
INSERT INTO boekregels VALUES (527, 117, 2011, '2011-07-13', 4710, NULL, 528, 0, '', '', '', 'Brandstof Opel', 42.84);
INSERT INTO boekregels VALUES (528, 117, 2011, '2011-07-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.14);
INSERT INTO boekregels VALUES (529, 117, 2011, '2011-07-14', 4610, NULL, 530, 0, '', '', '', 'Div materialen', 7.13);
INSERT INTO boekregels VALUES (530, 117, 2011, '2011-07-14', 2220, NULL, 0, 0, '', '', '', 'Div materialen', 1.35);
INSERT INTO boekregels VALUES (531, 117, 2011, '2011-07-14', 4220, NULL, 532, 0, '', '', '', 'Kussens atelier', 31.68);
INSERT INTO boekregels VALUES (532, 117, 2011, '2011-07-14', 2200, NULL, 0, 0, '', '', '', 'Kussens atelier', 6.02);
INSERT INTO boekregels VALUES (533, 117, 2011, '2011-07-15', 4220, NULL, 0, 0, '', '', '', 'Keukendoeken atelier', 2.99);
INSERT INTO boekregels VALUES (534, 117, 2011, '2011-07-23', 4220, NULL, 535, 0, '', '', '', 'Pedaalemmer', 7.55);
INSERT INTO boekregels VALUES (535, 117, 2011, '2011-07-23', 2200, NULL, 0, 0, '', '', '', 'Pedaalemmer', 1.44);
INSERT INTO boekregels VALUES (536, 117, 2011, '2011-07-23', 4600, NULL, 537, 0, '', '', '', 'Canvasdoeken', 20.55);
INSERT INTO boekregels VALUES (537, 117, 2011, '2011-07-23', 2200, NULL, 0, 0, '', '', '', 'Canvasdoeken', 3.90);
INSERT INTO boekregels VALUES (538, 117, 2011, '2011-07-23', 4220, NULL, 539, 0, '', '', '', 'Aankleding atelier', 58.82);
INSERT INTO boekregels VALUES (539, 117, 2011, '2011-07-23', 2200, NULL, 0, 0, '', '', '', 'Aankleding atelier', 11.17);
INSERT INTO boekregels VALUES (540, 117, 2011, '2011-07-25', 4490, NULL, 541, 0, '', '', '', 'Div lunch', 17.63);
INSERT INTO boekregels VALUES (541, 117, 2011, '2011-07-25', 2200, NULL, 0, 0, '', '', '', 'Div lunch', 1.35);
INSERT INTO boekregels VALUES (542, 117, 2011, '2011-07-26', 4230, NULL, 543, 0, '', '', '', 'Tijdschrift', 6.56);
INSERT INTO boekregels VALUES (543, 117, 2011, '2011-07-26', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.39);
INSERT INTO boekregels VALUES (544, 117, 2011, '2011-07-26', 4710, NULL, 545, 0, '', '', '', 'Brandstof Opel', 37.84);
INSERT INTO boekregels VALUES (545, 117, 2011, '2011-07-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.19);
INSERT INTO boekregels VALUES (546, 117, 2011, '2011-07-31', 4710, NULL, 547, 0, '', '', '', 'Brandstof Opel', 42.03);
INSERT INTO boekregels VALUES (547, 117, 2011, '2011-07-31', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.98);
INSERT INTO boekregels VALUES (548, 117, 2011, '2011-07-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 07', -546.09);
INSERT INTO boekregels VALUES (549, 118, 2011, '2011-08-06', 4230, NULL, 550, 0, '', '', '', 'Tabbladen', 3.25);
INSERT INTO boekregels VALUES (550, 118, 2011, '2011-08-06', 2200, NULL, 0, 0, '', '', '', 'Tabbladen', 0.62);
INSERT INTO boekregels VALUES (551, 118, 2011, '2011-08-09', 4490, NULL, 552, 0, '', '', '', 'Div Lunch', 10.09);
INSERT INTO boekregels VALUES (552, 118, 2011, '2011-08-09', 2200, NULL, 0, 0, '', '', '', 'Div Lunch', 0.61);
INSERT INTO boekregels VALUES (553, 118, 2011, '2011-08-12', 4490, NULL, 554, 0, '', '', '', 'Div dranken atelier', 39.95);
INSERT INTO boekregels VALUES (554, 118, 2011, '2011-08-12', 2200, NULL, 0, 0, '', '', '', 'Div dranken atelier', 6.11);
INSERT INTO boekregels VALUES (555, 118, 2011, '2011-08-13', 4710, NULL, 556, 0, '', '', '', 'Brandstof Opel', 43.82);
INSERT INTO boekregels VALUES (556, 118, 2011, '2011-08-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.32);
INSERT INTO boekregels VALUES (557, 118, 2011, '2011-08-19', 4230, NULL, 558, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO boekregels VALUES (558, 118, 2011, '2011-08-19', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO boekregels VALUES (559, 118, 2011, '2011-08-20', 4490, NULL, 0, 0, '', '', '', 'Div Lunch', 8.35);
INSERT INTO boekregels VALUES (560, 118, 2011, '2011-08-20', 4710, NULL, 561, 0, '', '', '', 'Brandstof Opel', 20.88);
INSERT INTO boekregels VALUES (561, 118, 2011, '2011-08-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 3.97);
INSERT INTO boekregels VALUES (562, 118, 2011, '2011-08-20', 4220, NULL, 563, 0, '', '', '', 'Plakband', 5.60);
INSERT INTO boekregels VALUES (563, 118, 2011, '2011-08-20', 2200, NULL, 0, 0, '', '', '', 'Plakband', 1.06);
INSERT INTO boekregels VALUES (564, 118, 2011, '2011-08-22', 4710, NULL, 565, 0, '', '', '', 'Brandstof Opel', 34.95);
INSERT INTO boekregels VALUES (565, 118, 2011, '2011-08-22', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.64);
INSERT INTO boekregels VALUES (566, 118, 2011, '2011-08-24', 4600, NULL, 567, 0, '', '', '', 'Lak en spuitmateriaal', 30.25);
INSERT INTO boekregels VALUES (567, 118, 2011, '2011-08-24', 2200, NULL, 0, 0, '', '', '', 'Lak en spuitmateriaal', 5.75);
INSERT INTO boekregels VALUES (568, 118, 2011, '2011-08-26', 4490, NULL, 0, 0, '', '', '', 'Versnaperingen', 7.40);
INSERT INTO boekregels VALUES (569, 118, 2011, '2011-08-30', 4600, NULL, 570, 0, '', '', '', 'Schildersdoek', 32.71);
INSERT INTO boekregels VALUES (570, 118, 2011, '2011-08-30', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 6.21);
INSERT INTO boekregels VALUES (571, 118, 2011, '2011-08-31', 4710, NULL, 572, 0, '', '', '', 'Brandstof Opel', 25.70);
INSERT INTO boekregels VALUES (572, 118, 2011, '2011-08-31', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.88);
INSERT INTO boekregels VALUES (573, 118, 2011, '2011-08-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 08', -313.11);
INSERT INTO boekregels VALUES (574, 119, 2011, '2011-09-03', 4220, NULL, 575, 0, '', '', '', 'Latex en plank', 61.51);
INSERT INTO boekregels VALUES (575, 119, 2011, '2011-09-03', 2200, NULL, 0, 0, '', '', '', 'Latex en plank', 11.69);
INSERT INTO boekregels VALUES (576, 119, 2011, '2011-09-06', 4600, NULL, 577, 0, '', '', '', 'Canvasdoek', 20.13);
INSERT INTO boekregels VALUES (578, 119, 2011, '2011-09-07', 4220, NULL, 579, 0, '', '', '', 'Elektra materiaal atelier', 32.95);
INSERT INTO boekregels VALUES (579, 119, 2011, '2011-09-07', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 6.26);
INSERT INTO boekregels VALUES (580, 119, 2011, '2011-09-07', 4220, NULL, 581, 0, '', '', '', 'Elektra materiaal atelier', 29.57);
INSERT INTO boekregels VALUES (581, 119, 2011, '2011-09-07', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 5.62);
INSERT INTO boekregels VALUES (582, 119, 2011, '2011-09-08', 4220, NULL, 583, 0, '', '', '', 'Elektra materiaal atelier', 36.18);
INSERT INTO boekregels VALUES (583, 119, 2011, '2011-09-08', 2200, NULL, 0, 0, '', '', '', 'Elektra materiaal atelier', 6.87);
INSERT INTO boekregels VALUES (584, 119, 2011, '2011-09-09', 4600, NULL, 585, 0, '', '', '', 'Blanke lak', 28.74);
INSERT INTO boekregels VALUES (585, 119, 2011, '2011-09-09', 2200, NULL, 0, 0, '', '', '', 'Blanke lak', 5.46);
INSERT INTO boekregels VALUES (586, 119, 2011, '2011-09-09', 4710, NULL, 587, 0, '', '', '', 'Brandstof Opel', 48.64);
INSERT INTO boekregels VALUES (587, 119, 2011, '2011-09-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.77);
INSERT INTO boekregels VALUES (588, 119, 2011, '2011-09-10', 4710, NULL, 589, 0, '', '', '', 'Brandstof Opel', 31.86);
INSERT INTO boekregels VALUES (589, 119, 2011, '2011-09-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.05);
INSERT INTO boekregels VALUES (590, 119, 2011, '2011-09-10', 4710, NULL, 0, 0, '', '', '', 'Brandstof Opel Duitsland', 24.34);
INSERT INTO boekregels VALUES (591, 119, 2011, '2011-09-16', 4230, NULL, 592, 0, '', '', '', 'DVD''s leeg', 11.76);
INSERT INTO boekregels VALUES (592, 119, 2011, '2011-09-16', 2200, NULL, 0, 0, '', '', '', 'DVD''s leeg', 2.23);
INSERT INTO boekregels VALUES (593, 119, 2011, '2011-09-18', 4710, NULL, 594, 0, '', '', '', 'Brandstof Opel', 38.64);
INSERT INTO boekregels VALUES (594, 119, 2011, '2011-09-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.34);
INSERT INTO boekregels VALUES (595, 119, 2011, '2011-09-08', 4220, NULL, 596, 0, '', '', '', 'Palm atelier', 12.22);
INSERT INTO boekregels VALUES (596, 119, 2011, '2011-09-08', 2200, NULL, 0, 0, '', '', '', 'Palm atelier', 0.73);
INSERT INTO boekregels VALUES (597, 119, 2011, '2011-09-21', 4250, NULL, 0, 0, '', '', '', 'Anne Fleur Derks Den Bosch', 26.50);
INSERT INTO boekregels VALUES (598, 119, 2011, '2011-09-29', 4710, NULL, 599, 0, '', '', '', 'Brandstof Opel', 23.18);
INSERT INTO boekregels VALUES (599, 119, 2011, '2011-09-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.40);
INSERT INTO boekregels VALUES (600, 119, 2011, '2011-09-25', 8010, NULL, 601, 0, '', '', '', 'Portret Timo de Waardt', -126.05);
INSERT INTO boekregels VALUES (601, 119, 2011, '2011-09-25', 2110, NULL, 0, 0, '', '', '', 'Portret Timo de Waardt', -23.95);
INSERT INTO boekregels VALUES (602, 119, 2011, '2011-09-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 09', -344.47);
INSERT INTO boekregels VALUES (613, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 376.74);
INSERT INTO boekregels VALUES (612, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 322.46);
INSERT INTO boekregels VALUES (611, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2220', 96.98);
INSERT INTO boekregels VALUES (610, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.07);
INSERT INTO boekregels VALUES (608, 121, 2011, '2011-09-30', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -96.98);
INSERT INTO boekregels VALUES (609, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -398.93);
INSERT INTO boekregels VALUES (603, 120, 2011, '2011-09-30', 2220, NULL, 0, 0, '', '', 'btwcorrectie', 'BTW partbtw correctie naar: 4620', 0.00);
INSERT INTO boekregels VALUES (604, 120, 2011, '2011-09-30', 4620, NULL, 0, 0, '', '', '', 'BTW partbtw correctie van: 2220', 0.00);
INSERT INTO boekregels VALUES (605, 121, 2011, '2011-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 398.93);
INSERT INTO boekregels VALUES (606, 121, 2011, '2011-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -376.74);
INSERT INTO boekregels VALUES (607, 121, 2011, '2011-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -322.46);
INSERT INTO boekregels VALUES (617, 122, 2011, '2011-10-03', 1600, NULL, 0, 0, 'verweij', '100260', '', 'Huur atelier oktober', -297.50);
INSERT INTO boekregels VALUES (618, 122, 2011, '2011-10-03', 4100, NULL, 619, 0, 'verweij', '100260', '', 'Huur atelier oktober', 250.00);
INSERT INTO boekregels VALUES (619, 122, 2011, '2011-10-03', 2200, NULL, 0, 0, 'verweij', '100260', '', 'Huur atelier oktober', 47.50);
INSERT INTO boekregels VALUES (620, 123, 2011, '2011-09-29', 1600, NULL, 0, 0, 'hofman', '2011287', '', 'Distributieriem Opel', -694.86);
INSERT INTO boekregels VALUES (621, 123, 2011, '2011-09-29', 4740, NULL, 622, 0, 'hofman', '2011287', '', 'Distributieriem Opel', 583.92);
INSERT INTO boekregels VALUES (622, 123, 2011, '2011-09-29', 2210, NULL, 0, 0, 'hofman', '2011287', '', 'Distributieriem Opel', 110.94);
INSERT INTO boekregels VALUES (623, 124, 2011, '2011-10-13', 1600, NULL, 0, 0, 'hofman', '70046770', '', 'Reparatie remmen Opel', -209.57);
INSERT INTO boekregels VALUES (624, 124, 2011, '2011-10-13', 4740, NULL, 625, 0, 'hofman', '70046770', '', 'Reparatie remmen Opel', 176.11);
INSERT INTO boekregels VALUES (625, 124, 2011, '2011-10-13', 2210, NULL, 0, 0, 'hofman', '70046770', '', 'Reparatie remmen Opel', 33.46);
INSERT INTO boekregels VALUES (626, 125, 2011, '2011-10-22', 1600, NULL, 0, 0, 'mediamarkt', '40445545', '', 'Harde schijven', -139.98);
INSERT INTO boekregels VALUES (627, 125, 2011, '2011-10-22', 4210, NULL, 628, 0, 'mediamarkt', '40445545', '', 'Harde schijven', 117.63);
INSERT INTO boekregels VALUES (628, 125, 2011, '2011-10-22', 2200, NULL, 0, 0, 'mediamarkt', '40445545', '', 'Harde schijven', 22.35);
INSERT INTO boekregels VALUES (629, 126, 2011, '2011-10-23', 1600, NULL, 0, 0, 'kramer', '54140', '', 'Spuitmateriaal', -305.95);
INSERT INTO boekregels VALUES (630, 126, 2011, '2011-10-23', 4610, NULL, 631, 0, 'kramer', '54140', '', 'Spuitmateriaal', 257.10);
INSERT INTO boekregels VALUES (631, 126, 2011, '2011-10-23', 2220, NULL, 0, 0, 'kramer', '54140', '', 'Spuitmateriaal', 48.85);
INSERT INTO boekregels VALUES (632, 127, 2011, '2011-11-01', 1600, NULL, 0, 0, 'verweij', '100275', '', 'Huur atelier november', -297.50);
INSERT INTO boekregels VALUES (633, 127, 2011, '2011-11-01', 4100, NULL, 634, 0, 'verweij', '100275', '', 'Huur atelier november', 250.00);
INSERT INTO boekregels VALUES (634, 127, 2011, '2011-11-01', 2200, NULL, 0, 0, 'verweij', '100275', '', 'Huur atelier november', 47.50);
INSERT INTO boekregels VALUES (635, 128, 2011, '2011-11-04', 1600, NULL, 0, 0, 'engelb', '185480', '', 'Maskers en brandblusser', -92.34);
INSERT INTO boekregels VALUES (636, 128, 2011, '2011-11-04', 4220, NULL, 637, 0, 'engelb', '185480', '', 'Maskers en brandblusser', 77.60);
INSERT INTO boekregels VALUES (637, 128, 2011, '2011-11-04', 2200, NULL, 0, 0, 'engelb', '185480', '', 'Maskers en brandblusser', 14.74);
INSERT INTO boekregels VALUES (638, 129, 2011, '2011-11-07', 1600, NULL, 0, 0, 'vodafone', '186575876', '', 'Mobiel Internet november', -50.00);
INSERT INTO boekregels VALUES (639, 129, 2011, '2011-11-07', 4245, NULL, 640, 0, 'vodafone', '186575876', '', 'Mobiel Internet november', 42.02);
INSERT INTO boekregels VALUES (640, 129, 2011, '2011-11-07', 2200, NULL, 0, 0, 'vodafone', '186575876', '', 'Mobiel Internet november', 7.98);
INSERT INTO boekregels VALUES (641, 130, 2011, '2011-11-09', 1600, NULL, 0, 0, 'marktplaats', '111100374', '', 'Advertenties', -300.00);
INSERT INTO boekregels VALUES (642, 130, 2011, '2011-11-09', 4500, NULL, 643, 0, 'marktplaats', '111100374', '', 'Advertenties Succes pakket', 252.10);
INSERT INTO boekregels VALUES (643, 130, 2011, '2011-11-09', 2200, NULL, 0, 0, 'marktplaats', '111100374', '', 'Advertenties Succes pakket', 47.90);
INSERT INTO boekregels VALUES (644, 131, 2011, '2011-11-22', 1600, NULL, 0, 0, 'hofman', '2011365', '', 'Winterbanden en velgen Opel', -1157.26);
INSERT INTO boekregels VALUES (645, 131, 2011, '2011-11-22', 4740, NULL, 646, 0, 'hofman', '2011365', '', 'Winterbanden en velgen Opel', 972.49);
INSERT INTO boekregels VALUES (646, 131, 2011, '2011-11-22', 2210, NULL, 0, 0, 'hofman', '2011365', '', 'Winterbanden en velgen Opel', 184.77);
INSERT INTO boekregels VALUES (647, 132, 2011, '2011-12-01', 1600, NULL, 0, 0, 'verweij', '100290', '', 'Huur atelier december', -297.50);
INSERT INTO boekregels VALUES (648, 132, 2011, '2011-12-01', 4100, NULL, 649, 0, 'verweij', '100290', '', 'Huur atelier december', 250.00);
INSERT INTO boekregels VALUES (649, 132, 2011, '2011-12-01', 2200, NULL, 0, 0, 'verweij', '100290', '', 'Huur atelier december', 47.50);
INSERT INTO boekregels VALUES (650, 133, 2011, '2011-12-01', 1600, NULL, 0, 0, 'diverse', '4227593', '', 'Gem.Delft Parkeernaheffingsaanslag', -54.20);
INSERT INTO boekregels VALUES (651, 133, 2011, '2011-12-01', 4490, NULL, 0, 0, 'diverse', '4227593', '', 'Gem.Delft Parkeernaheffingsaanslag', 54.20);
INSERT INTO boekregels VALUES (652, 134, 2011, '2011-12-05', 1600, NULL, 0, 0, 'vandien', '14656262', '', 'Verzekering Opel 1e kw 2012', -140.49);
INSERT INTO boekregels VALUES (653, 134, 2011, '2011-12-05', 4720, NULL, 0, 0, 'vandien', '14656262', '', 'Verzekering Opel 1e kw 2012', 140.49);
INSERT INTO boekregels VALUES (654, 135, 2011, '2011-12-07', 1600, NULL, 0, 0, 'vodafone', '189289585', '', 'Mobiel Internet december', -52.75);
INSERT INTO boekregels VALUES (655, 135, 2011, '2011-12-07', 4245, NULL, 656, 0, 'vodafone', '189289585', '', 'Mobiel Internet december', 44.33);
INSERT INTO boekregels VALUES (656, 135, 2011, '2011-12-07', 2200, NULL, 0, 0, 'vodafone', '189289585', '', 'Mobiel Internet december', 8.42);
INSERT INTO boekregels VALUES (657, 136, 2011, '2011-12-09', 1600, NULL, 0, 0, 'belasting', '69414993M17', '', 'Wegenbelasting Opel 8dec/7mrt', -70.00);
INSERT INTO boekregels VALUES (658, 136, 2011, '2011-12-09', 4730, NULL, 0, 0, 'belasting', '69414993M17', '', 'Wegenbelasting Opel 8dec/7mrt', 70.00);
INSERT INTO boekregels VALUES (659, 137, 2011, '2011-12-16', 1600, NULL, 0, 0, 'bosman', '7899', '', 'Lettersjabloon', -228.48);
INSERT INTO boekregels VALUES (660, 137, 2011, '2011-12-16', 4220, NULL, 661, 0, 'bosman', '7899', '', 'Lettersjabloon', 192.00);
INSERT INTO boekregels VALUES (661, 137, 2011, '2011-12-16', 2200, NULL, 0, 0, 'bosman', '7899', '', 'Lettersjabloon', 36.48);
INSERT INTO boekregels VALUES (662, 138, 2011, '2011-12-26', 1600, NULL, 0, 0, 'kramer', '54519', '', 'Spuitmateriaal', -289.85);
INSERT INTO boekregels VALUES (663, 138, 2011, '2011-12-26', 4610, NULL, 664, 0, 'kramer', '54519', '', 'Spuitmateriaal', 243.57);
INSERT INTO boekregels VALUES (664, 138, 2011, '2011-12-26', 2220, NULL, 0, 0, 'kramer', '54519', '', 'Spuitmateriaal', 46.28);
INSERT INTO boekregels VALUES (665, 139, 2011, '2011-12-30', 1600, NULL, 0, 0, 'hofman', '2011404', '', 'Kleine beurt Opel', -154.44);
INSERT INTO boekregels VALUES (666, 139, 2011, '2011-12-30', 4740, NULL, 667, 0, 'hofman', '2011404', '', 'Kleine beurt Opel', 129.78);
INSERT INTO boekregels VALUES (667, 139, 2011, '2011-12-30', 2210, NULL, 0, 0, 'hofman', '2011404', '', 'Kleine beurt Opel', 24.66);
INSERT INTO boekregels VALUES (668, 141, 2011, '2011-10-17', 1200, NULL, 0, 0, 'spruyt', '2011029', '', 'Schutting reclame', 595.71);
INSERT INTO boekregels VALUES (669, 141, 2011, '2011-10-17', 8140, NULL, 670, 0, 'spruyt', '2011029', '', 'Schutting reclame', -500.60);
INSERT INTO boekregels VALUES (670, 141, 2011, '2011-10-17', 2110, NULL, 0, 0, 'spruyt', '2011029', '', 'Schutting reclame', -95.11);
INSERT INTO boekregels VALUES (671, 142, 2011, '2011-11-23', 1200, NULL, 0, 0, 'gopdelft', '2011030', '', 'Reclameschildering Irenetunnel', 178.50);
INSERT INTO boekregels VALUES (672, 142, 2011, '2011-11-23', 8140, NULL, 673, 0, 'gopdelft', '2011030', '', 'Reclameschildering Irenetunnel', -150.00);
INSERT INTO boekregels VALUES (673, 142, 2011, '2011-11-23', 2110, NULL, 0, 0, 'gopdelft', '2011030', '', 'Reclameschildering Irenetunnel', -28.50);
INSERT INTO boekregels VALUES (674, 143, 2011, '2011-12-13', 1200, NULL, 0, 0, 'woonp', '2011031', '', 'Muurschildering Kerkweg Oost en Onthulling', 1190.00);
INSERT INTO boekregels VALUES (675, 143, 2011, '2011-12-13', 8140, NULL, 676, 0, 'woonp', '2011031', '', 'Muurschildering Kerkweg Oost en Onthulling', -1000.00);
INSERT INTO boekregels VALUES (676, 143, 2011, '2011-12-13', 2110, NULL, 0, 0, 'woonp', '2011031', '', 'Muurschildering Kerkweg Oost en Onthulling', -190.00);
INSERT INTO boekregels VALUES (677, 144, 2011, '2011-12-30', 1200, NULL, 0, 0, 'JJB', '2011032', '', 'Schilderij', 119.00);
INSERT INTO boekregels VALUES (678, 144, 2011, '2011-12-30', 8010, NULL, 679, 0, 'JJB', '2011032', '', 'Schilderij', -100.00);
INSERT INTO boekregels VALUES (679, 144, 2011, '2011-12-30', 2110, NULL, 0, 0, 'JJB', '2011032', '', 'Schilderij', -19.00);
INSERT INTO boekregels VALUES (680, 140, 2011, '2011-10-03', 4220, NULL, 681, 0, '', '', '', 'Verfkoffer en toetsenbord', 52.92);
INSERT INTO boekregels VALUES (681, 140, 2011, '2011-10-03', 2200, NULL, 0, 0, '', '', '', 'Verfkoffer en toetsenbord', 10.05);
INSERT INTO boekregels VALUES (682, 140, 2011, '2011-10-06', 4710, NULL, 683, 0, '', '', '', 'Brandstof Opel', 47.93);
INSERT INTO boekregels VALUES (683, 140, 2011, '2011-10-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.11);
INSERT INTO boekregels VALUES (684, 140, 2011, '2011-10-09', 4710, NULL, 685, 0, '', '', '', 'Brandstof Opel', 25.23);
INSERT INTO boekregels VALUES (685, 140, 2011, '2011-10-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.79);
INSERT INTO boekregels VALUES (686, 140, 2011, '2011-10-11', 8140, NULL, 0, 0, '', '', '', 'graffiti Thomas', 0.00);
INSERT INTO boekregels VALUES (687, 140, 2011, '2011-10-11', 4490, NULL, 688, 0, '', '', '', 'Tijdschrift', 4.95);
INSERT INTO boekregels VALUES (688, 140, 2011, '2011-10-11', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.30);
INSERT INTO boekregels VALUES (689, 140, 2011, '2011-10-14', 4610, NULL, 690, 0, '', '', '', 'Verfroller en afzetlint', 5.78);
INSERT INTO boekregels VALUES (690, 140, 2011, '2011-10-14', 2220, NULL, 0, 0, '', '', '', 'Verfroller en afzetlint', 1.10);
INSERT INTO boekregels VALUES (691, 140, 2011, '2011-10-14', 4610, NULL, 692, 0, '', '', '', 'Verfpigment', 17.64);
INSERT INTO boekregels VALUES (692, 140, 2011, '2011-10-14', 2220, NULL, 0, 0, '', '', '', 'Verfpigment', 3.35);
INSERT INTO boekregels VALUES (693, 140, 2011, '2011-10-14', 4610, NULL, 694, 0, '', '', '', 'Kleurlatex', 21.33);
INSERT INTO boekregels VALUES (694, 140, 2011, '2011-10-14', 2220, NULL, 0, 0, '', '', '', 'Kleurlatex', 4.05);
INSERT INTO boekregels VALUES (695, 140, 2011, '2011-10-14', 4710, NULL, 696, 0, '', '', '', 'Brandstof Opel', 25.41);
INSERT INTO boekregels VALUES (696, 140, 2011, '2011-10-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.83);
INSERT INTO boekregels VALUES (697, 140, 2011, '2011-10-15', 4490, NULL, 698, 0, '', '', '', 'Lunch', 2.43);
INSERT INTO boekregels VALUES (698, 140, 2011, '2011-10-15', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.15);
INSERT INTO boekregels VALUES (699, 140, 2011, '2011-10-15', 4490, NULL, 700, 0, '', '', '', 'Tijdschriften', 10.08);
INSERT INTO boekregels VALUES (700, 140, 2011, '2011-10-15', 2200, NULL, 0, 0, '', '', '', 'Tijdschriften', 0.61);
INSERT INTO boekregels VALUES (701, 140, 2011, '2011-10-17', 4710, NULL, 702, 0, '', '', '', 'Brandstof Opel', 24.25);
INSERT INTO boekregels VALUES (702, 140, 2011, '2011-10-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.33);
INSERT INTO boekregels VALUES (703, 140, 2011, '2011-10-19', 8140, NULL, 704, 0, '', '', '', 'Graffiti Robin', -126.05);
INSERT INTO boekregels VALUES (704, 140, 2011, '2011-10-19', 2110, NULL, 0, 0, '', '', '', 'Graffiti Robin', -23.95);
INSERT INTO boekregels VALUES (705, 140, 2011, '2011-10-20', 4710, NULL, 706, 0, '', '', '', 'Brandstof Opel', 39.93);
INSERT INTO boekregels VALUES (706, 140, 2011, '2011-10-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.59);
INSERT INTO boekregels VALUES (707, 140, 2011, '2011-10-22', 8140, NULL, 708, 0, '', '', '', 'Graffiti Spidermand', -168.07);
INSERT INTO boekregels VALUES (708, 140, 2011, '2011-10-22', 2110, NULL, 0, 0, '', '', '', 'Graffiti Spidermand', -31.93);
INSERT INTO boekregels VALUES (709, 140, 2011, '2011-10-25', 4710, NULL, 710, 0, '', '', '', 'Brandstof Opel', 45.45);
INSERT INTO boekregels VALUES (710, 140, 2011, '2011-10-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.64);
INSERT INTO boekregels VALUES (711, 140, 2011, '2011-10-30', 4610, NULL, 712, 0, '', '', '', 'Div materialen', 21.94);
INSERT INTO boekregels VALUES (712, 140, 2011, '2011-10-30', 2220, NULL, 0, 0, '', '', '', 'Div materialen', 4.17);
INSERT INTO boekregels VALUES (713, 140, 2011, '2011-10-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad oktober', -58.34);
INSERT INTO boekregels VALUES (714, 145, 2011, '2011-11-03', 4710, NULL, 715, 0, '', '', '', 'Brandstof Opel', 22.81);
INSERT INTO boekregels VALUES (715, 145, 2011, '2011-11-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.33);
INSERT INTO boekregels VALUES (716, 145, 2011, '2011-11-10', 4710, NULL, 717, 0, '', '', '', 'Brandstof Opel', 11.59);
INSERT INTO boekregels VALUES (717, 145, 2011, '2011-11-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 2.20);
INSERT INTO boekregels VALUES (718, 145, 2011, '2011-11-10', 4710, NULL, 719, 0, '', '', '', 'Brandstof Opel', 43.58);
INSERT INTO boekregels VALUES (719, 145, 2011, '2011-11-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.28);
INSERT INTO boekregels VALUES (720, 145, 2011, '2011-11-12', 4600, NULL, 721, 0, '', '', '', 'Blanke lak', 28.74);
INSERT INTO boekregels VALUES (721, 145, 2011, '2011-11-12', 2200, NULL, 0, 0, '', '', '', 'Blanke lak', 5.46);
INSERT INTO boekregels VALUES (722, 145, 2011, '2011-11-14', 8140, NULL, 723, 0, '', '', '', 'Muurschildering Spiderman', -210.08);
INSERT INTO boekregels VALUES (723, 145, 2011, '2011-11-14', 2110, NULL, 0, 0, '', '', '', 'Muurschildering Spiderman', -39.92);
INSERT INTO boekregels VALUES (724, 145, 2011, '2011-11-19', 8140, NULL, 725, 0, '', '', '', 'graffiti Draak', -168.07);
INSERT INTO boekregels VALUES (725, 145, 2011, '2011-11-19', 2110, NULL, 0, 0, '', '', '', 'graffiti Draak', -31.93);
INSERT INTO boekregels VALUES (726, 145, 2011, '2011-11-19', 4710, NULL, 727, 0, '', '', '', 'Brandstof Opel', 52.90);
INSERT INTO boekregels VALUES (727, 145, 2011, '2011-11-19', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.05);
INSERT INTO boekregels VALUES (728, 145, 2011, '2011-11-19', 4490, NULL, 729, 0, '', '', '', 'Lunch', 4.80);
INSERT INTO boekregels VALUES (729, 145, 2011, '2011-11-19', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.29);
INSERT INTO boekregels VALUES (730, 145, 2011, '2011-11-19', 4490, NULL, 731, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO boekregels VALUES (731, 145, 2011, '2011-11-19', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO boekregels VALUES (732, 145, 2011, '2011-11-19', 4220, NULL, 733, 0, '', '', '', 'Fotomateriaal', 5.04);
INSERT INTO boekregels VALUES (733, 145, 2011, '2011-11-19', 2200, NULL, 0, 0, '', '', '', 'Fotomateriaal', 0.96);
INSERT INTO boekregels VALUES (734, 145, 2011, '2011-11-26', 4710, NULL, 735, 0, '', '', '', 'Brandstof Opel', 37.90);
INSERT INTO boekregels VALUES (735, 145, 2011, '2011-11-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.20);
INSERT INTO boekregels VALUES (736, 145, 2011, '2011-11-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad november', 197.88);
INSERT INTO boekregels VALUES (737, 146, 2011, '2011-12-01', 4710, NULL, 738, 0, '', '', '', 'Brandstof Opel', 40.21);
INSERT INTO boekregels VALUES (738, 146, 2011, '2011-12-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.64);
INSERT INTO boekregels VALUES (739, 146, 2011, '2011-12-03', 4600, NULL, 740, 0, '', '', '', 'Latex vochtige ruimte', 25.98);
INSERT INTO boekregels VALUES (740, 146, 2011, '2011-12-03', 2200, NULL, 0, 0, '', '', '', 'Latex vochtige ruimte', 4.94);
INSERT INTO boekregels VALUES (741, 146, 2011, '2011-12-03', 8140, NULL, 742, 0, '', '', '', 'Graffiti Jeron', -163.87);
INSERT INTO boekregels VALUES (742, 146, 2011, '2011-12-03', 2110, NULL, 0, 0, '', '', '', 'Graffiti Jeron', -31.13);
INSERT INTO boekregels VALUES (743, 146, 2011, '2011-12-04', 8140, NULL, 744, 0, '', '', '', 'Graffiti Bram/Koen', -231.09);
INSERT INTO boekregels VALUES (744, 146, 2011, '2011-12-04', 2110, NULL, 0, 0, '', '', '', 'Graffiti Bram/Koen', -43.91);
INSERT INTO boekregels VALUES (745, 146, 2011, '2011-12-05', 4710, NULL, 746, 0, '', '', '', 'Brandstof Opel', 49.71);
INSERT INTO boekregels VALUES (746, 146, 2011, '2011-12-05', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.44);
INSERT INTO boekregels VALUES (747, 146, 2011, '2011-12-06', 8140, NULL, 748, 0, '', '', '', 'Graffiti Max', -168.07);
INSERT INTO boekregels VALUES (748, 146, 2011, '2011-12-06', 2110, NULL, 0, 0, '', '', '', 'Graffiti Max', -31.93);
INSERT INTO boekregels VALUES (749, 146, 2011, '2011-12-09', 4230, NULL, 750, 0, '', '', '', 'Keyboard', 25.20);
INSERT INTO boekregels VALUES (750, 146, 2011, '2011-12-09', 2200, NULL, 0, 0, '', '', '', 'Keyboard', 4.79);
INSERT INTO boekregels VALUES (751, 146, 2011, '2011-12-10', 4220, NULL, 752, 0, '', '', '', 'Materiaal reverse graffiti', 40.29);
INSERT INTO boekregels VALUES (752, 146, 2011, '2011-12-10', 2200, NULL, 0, 0, '', '', '', 'Materiaal reverse graffiti', 7.65);
INSERT INTO boekregels VALUES (753, 146, 2011, '2011-12-10', 4710, NULL, 754, 0, '', '', '', 'Brandstof Opel', 43.70);
INSERT INTO boekregels VALUES (754, 146, 2011, '2011-12-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.30);
INSERT INTO boekregels VALUES (755, 146, 2011, '2011-12-13', 4710, NULL, 756, 0, '', '', '', 'Brandstof Opel', 23.97);
INSERT INTO boekregels VALUES (756, 146, 2011, '2011-12-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.56);
INSERT INTO boekregels VALUES (757, 146, 2011, '2011-12-14', 4220, NULL, 758, 0, '', '', '', 'Materiaal reverse graffiti', 99.89);
INSERT INTO boekregels VALUES (758, 146, 2011, '2011-12-14', 2200, NULL, 0, 0, '', '', '', 'Materiaal reverse graffiti', 18.98);
INSERT INTO boekregels VALUES (759, 146, 2011, '2011-12-17', 8140, NULL, 760, 0, '', '', '', 'Muurschildering Lion King', -126.05);
INSERT INTO boekregels VALUES (760, 146, 2011, '2011-12-17', 2110, NULL, 0, 0, '', '', '', 'Muurschildering Lion King', -23.95);
INSERT INTO boekregels VALUES (761, 146, 2011, '2011-12-17', 4710, NULL, 762, 0, '', '', '', 'Brandstof Opel', 16.82);
INSERT INTO boekregels VALUES (762, 146, 2011, '2011-12-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 3.19);
INSERT INTO boekregels VALUES (763, 146, 2011, '2011-12-17', 4490, NULL, 764, 0, '', '', '', 'Lunch onderweg', 4.20);
INSERT INTO boekregels VALUES (764, 146, 2011, '2011-12-17', 2200, NULL, 0, 0, '', '', '', 'Lunch onderweg', 0.25);
INSERT INTO boekregels VALUES (765, 146, 2011, '2011-12-17', 4230, NULL, 766, 0, '', '', '', 'Tijdschrift', 5.19);
INSERT INTO boekregels VALUES (766, 146, 2011, '2011-12-17', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.31);
INSERT INTO boekregels VALUES (767, 146, 2011, '2011-12-23', 4230, NULL, 768, 0, '', '', '', 'Keyboard illuminated', 73.93);
INSERT INTO boekregels VALUES (768, 146, 2011, '2011-12-23', 2200, NULL, 0, 0, '', '', '', 'Keyboard illuminated', 14.05);
INSERT INTO boekregels VALUES (769, 146, 2011, '2011-12-24', 4710, NULL, 770, 0, '', '', '', 'Brandstof Opel', 38.87);
INSERT INTO boekregels VALUES (770, 146, 2011, '2011-12-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.39);
INSERT INTO boekregels VALUES (771, 146, 2011, '2011-12-28', 8140, NULL, 772, 0, '', '', '', 'Graffiti Ritchie', -168.07);
INSERT INTO boekregels VALUES (772, 146, 2011, '2011-12-28', 2110, NULL, 0, 0, '', '', '', 'Graffiti Ritchie', -31.93);
INSERT INTO boekregels VALUES (773, 146, 2011, '2011-12-30', 4710, NULL, 774, 0, '', '', '', 'Brandstof Opel', 49.24);
INSERT INTO boekregels VALUES (774, 146, 2011, '2011-12-30', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.36);
INSERT INTO boekregels VALUES (775, 146, 2011, '2011-12-31', 4220, NULL, 776, 0, '', '', '', 'Div gereedschappen', 18.45);
INSERT INTO boekregels VALUES (776, 146, 2011, '2011-12-31', 2200, NULL, 0, 0, '', '', '', 'Div gereedschappen', 3.51);
INSERT INTO boekregels VALUES (777, 146, 2011, '2011-12-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad december', 359.99);
INSERT INTO boekregels VALUES (778, 147, 2011, '2011-12-31', 2150, NULL, 0, 0, '', '', '', 'BTW Privegebruik eigen auto', -374.00);
INSERT INTO boekregels VALUES (779, 147, 2011, '2011-12-31', 1060, NULL, 0, 0, '', '', '', 'BTW Privegebruik eigen auto', 374.00);
INSERT INTO boekregels VALUES (780, 148, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 61.00);
INSERT INTO boekregels VALUES (781, 148, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -61.00);
INSERT INTO boekregels VALUES (782, 149, 2011, '2011-12-31', 2220, NULL, 0, 0, '', '', 'btwcorrectie', 'BTW partbtw correctie naar: 4620', 0.00);
INSERT INTO boekregels VALUES (783, 149, 2011, '2011-12-31', 4620, NULL, 0, 0, '', '', '', 'BTW partbtw correctie van: 2220', 0.00);
INSERT INTO boekregels VALUES (784, 150, 2011, '2011-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 623.19);
INSERT INTO boekregels VALUES (785, 150, 2011, '2011-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 374.00);
INSERT INTO boekregels VALUES (786, 150, 2011, '2011-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -353.01);
INSERT INTO boekregels VALUES (787, 150, 2011, '2011-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -475.06);
INSERT INTO boekregels VALUES (788, 150, 2011, '2011-12-31', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -107.80);
INSERT INTO boekregels VALUES (789, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -623.19);
INSERT INTO boekregels VALUES (790, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.19);
INSERT INTO boekregels VALUES (791, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2150', -374.00);
INSERT INTO boekregels VALUES (792, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.00);
INSERT INTO boekregels VALUES (793, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2220', 107.80);
INSERT INTO boekregels VALUES (794, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 475.06);
INSERT INTO boekregels VALUES (888, 180, 2013, '2012-11-14', 4220, NULL, 889, 0, '', '', '', 'Schoonmaakmiddelen', 33.02);
INSERT INTO boekregels VALUES (795, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 353.01);
INSERT INTO boekregels VALUES (796, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', 0.13);
INSERT INTO boekregels VALUES (803, 151, 2011, '2011-01-01', 2300, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 112.00);
INSERT INTO boekregels VALUES (802, 151, 2011, '2011-01-01', 900, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -112.00);
INSERT INTO boekregels VALUES (799, 150, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.19);
INSERT INTO boekregels VALUES (800, 150, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', 0.00);
INSERT INTO boekregels VALUES (801, 150, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', -0.13);
INSERT INTO boekregels VALUES (804, 152, 2011, '2011-12-31', 1060, NULL, 0, 0, '', '', '', 'Privegebruik Open Combo 25%', 3006.25);
INSERT INTO boekregels VALUES (805, 152, 2011, '2011-12-31', 4780, NULL, 0, 0, '', '', '', 'Privegebruik Open Combo 25%', -3006.25);
INSERT INTO boekregels VALUES (806, 153, 2011, '2011-12-31', 1200, NULL, 0, 0, '', '', '', 'Debiteuren saldo prive ontvangen', -23947.36);
INSERT INTO boekregels VALUES (807, 153, 2011, '2011-12-31', 1600, NULL, 0, 0, '', '', '', 'Crediteuren saldo prive betaald', 27996.73);
INSERT INTO boekregels VALUES (808, 153, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', '', 'BTW saldo prive betaald/ontvangen', -941.00);
INSERT INTO boekregels VALUES (809, 153, 2011, '2011-12-31', 1060, NULL, 0, 0, '', '', '', 'BTW saldo prive betaald/ontvangen', -3108.37);
INSERT INTO boekregels VALUES (810, 154, 2012, '2012-01-01', 200, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 3500.00);
INSERT INTO boekregels VALUES (811, 154, 2012, '2012-01-01', 900, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -3500.00);
INSERT INTO boekregels VALUES (812, 155, 2013, '2013-01-02', 1600, NULL, 0, 0, 'kramer', '21957039', '', 'Spuitmateriaal', -177.40);
INSERT INTO boekregels VALUES (814, 155, 2013, '2013-01-02', 2200, NULL, 0, 0, 'kramer', '21957039', '', 'Spuitmateriaal', 30.79);
INSERT INTO boekregels VALUES (815, 156, 2013, '2013-01-07', 1600, NULL, 0, 0, 'tshirts', '7240', '', 'T-shirts voor bedrukking', -109.08);
INSERT INTO boekregels VALUES (817, 156, 2013, '2013-01-07', 2200, NULL, 0, 0, 'tshirts', '7240', '', 'T-shirts voor bedrukking', 18.93);
INSERT INTO boekregels VALUES (818, 157, 2013, '2013-01-11', 1600, NULL, 0, 0, 'kramer', '57141', '', 'Spuitmateriaal', -248.40);
INSERT INTO boekregels VALUES (820, 157, 2013, '2013-01-11', 2200, NULL, 0, 0, 'kramer', '57141', '', 'Spuitmateriaal', 43.11);
INSERT INTO boekregels VALUES (821, 158, 2013, '2013-01-17', 1600, NULL, 0, 0, 'drukwerk', '2013109457', '', 'Reclameposters', -24.07);
INSERT INTO boekregels VALUES (823, 158, 2013, '2013-01-17', 2200, NULL, 0, 0, 'drukwerk', '2013109457', '', 'Reclameposters', 4.18);
INSERT INTO boekregels VALUES (824, 159, 2013, '2013-01-21', 1600, NULL, 0, 0, 'tmobile', '901181710172', '', 'T-mobile 75% zakelijk', -19.63);
INSERT INTO boekregels VALUES (825, 159, 2013, '2013-01-21', 4240, NULL, 826, 0, 'tmobile', '901181710172', '', 'T-mobile 75% zakelijk', 16.22);
INSERT INTO boekregels VALUES (826, 159, 2013, '2013-01-21', 2200, NULL, 0, 0, 'tmobile', '901181710172', '', 'T-mobile 75% zakelijk', 3.41);
INSERT INTO boekregels VALUES (827, 160, 2013, '2013-01-23', 1600, NULL, 0, 0, 'drukwerk', '2013113939', '', 'Reclameposters', -102.62);
INSERT INTO boekregels VALUES (829, 160, 2013, '2013-01-23', 2200, NULL, 0, 0, 'drukwerk', '2013113939', '', 'Reclameposters', 17.81);
INSERT INTO boekregels VALUES (830, 161, 2013, '2013-01-29', 1600, NULL, 0, 0, 'kramer', '57222', '', 'Spuitmateriaal', -237.50);
INSERT INTO boekregels VALUES (832, 161, 2013, '2013-01-29', 2200, NULL, 0, 0, 'kramer', '57222', '', 'Spuitmateriaal', 41.22);
INSERT INTO boekregels VALUES (833, 162, 2013, '2013-02-01', 1600, NULL, 0, 0, 'uc', 'RLZ-1063', '', 'Montana spuitmateriaal', -102.90);
INSERT INTO boekregels VALUES (835, 162, 2013, '2013-02-01', 2200, NULL, 0, 0, 'uc', 'RLZ-1063', '', 'Montana spuitmateriaal', 17.86);
INSERT INTO boekregels VALUES (836, 163, 2013, '2013-02-07', 1600, NULL, 0, 0, 'stoffen', '201300326', '', 'Kaasdoek 280cm breed', -48.67);
INSERT INTO boekregels VALUES (838, 163, 2013, '2013-02-07', 2200, NULL, 0, 0, 'stoffen', '201300326', '', 'Kaasdoek 280cm breed', 8.45);
INSERT INTO boekregels VALUES (839, 164, 2013, '2013-02-07', 1600, NULL, 0, 0, 'marktplaats', '130200486', '', 'Advertentiepakket', -137.94);
INSERT INTO boekregels VALUES (841, 164, 2013, '2013-02-07', 2200, NULL, 0, 0, 'marktplaats', '130200486', '', 'Advertentiepakket', 23.94);
INSERT INTO boekregels VALUES (842, 165, 2013, '2013-02-15', 1600, NULL, 0, 0, 'claasen', '762144', '', 'Morsverf latex', -143.39);
INSERT INTO boekregels VALUES (844, 165, 2013, '2013-02-15', 2200, NULL, 0, 0, 'claasen', '762144', '', 'Morsverf latex', 24.89);
INSERT INTO boekregels VALUES (845, 166, 2013, '2013-02-19', 1600, NULL, 0, 0, 'tmobile', '901183959412', '', 'T-mobile 75% zakelijk', -21.38);
INSERT INTO boekregels VALUES (846, 166, 2013, '2013-02-19', 4240, NULL, 847, 0, 'tmobile', '901183959412', '', 'T-mobile 75% zakelijk', 17.67);
INSERT INTO boekregels VALUES (847, 166, 2013, '2013-02-19', 2200, NULL, 0, 0, 'tmobile', '901183959412', '', 'T-mobile 75% zakelijk', 3.71);
INSERT INTO boekregels VALUES (848, 167, 2013, '2013-02-21', 1600, NULL, 0, 0, 'foka', '3350113', '', 'Groothoekcamera TZ25', -196.00);
INSERT INTO boekregels VALUES (849, 167, 2013, '2013-02-21', 4220, NULL, 850, 0, 'foka', '3350113', '', 'Groothoekcamera TZ25', 161.98);
INSERT INTO boekregels VALUES (850, 167, 2013, '2013-02-21', 2200, NULL, 0, 0, 'foka', '3350113', '', 'Groothoekcamera TZ25', 34.02);
INSERT INTO boekregels VALUES (851, 168, 2013, '2013-02-26', 1600, NULL, 0, 0, 'konijn', '27495', '', 'Jinbei flitser SP-200', -213.89);
INSERT INTO boekregels VALUES (852, 168, 2013, '2013-02-26', 4210, NULL, 853, 0, 'konijn', '27495', '', 'Jinbei flitser SP-200', 176.77);
INSERT INTO boekregels VALUES (853, 168, 2013, '2013-02-26', 2200, NULL, 0, 0, 'konijn', '27495', '', 'Jinbei flitser SP-200', 37.12);
INSERT INTO boekregels VALUES (854, 169, 2013, '2013-03-05', 1600, NULL, 0, 0, 'vanbeek', '920615', '', 'Molotow refill', -15.22);
INSERT INTO boekregels VALUES (856, 169, 2013, '2013-03-05', 2200, NULL, 0, 0, 'vanbeek', '920615', '', 'Molotow refill', 2.64);
INSERT INTO boekregels VALUES (857, 170, 2013, '2013-03-05', 1600, NULL, 0, 0, 'claasen', '763690', '', 'Morsverf latex', -47.80);
INSERT INTO boekregels VALUES (859, 170, 2013, '2013-03-05', 2200, NULL, 0, 0, 'claasen', '763690', '', 'Morsverf latex', 8.30);
INSERT INTO boekregels VALUES (860, 171, 2013, '2013-02-25', 1600, NULL, 0, 0, 'belasting', '69414996F012300', '', 'Naheffinsaanslag 4e kw 2012', -50.00);
INSERT INTO boekregels VALUES (861, 171, 2013, '2013-02-25', 4490, NULL, 0, 0, 'belasting', '69414996F012300', '', 'Naheffinsaanslag 4e kw 2012', 50.00);
INSERT INTO boekregels VALUES (862, 172, 2013, '2013-03-06', 1600, NULL, 0, 0, 'drukwerk', '2013140365', '', 'Reclameposters', -52.51);
INSERT INTO boekregels VALUES (864, 172, 2013, '2013-03-06', 2200, NULL, 0, 0, 'drukwerk', '2013140365', '', 'Reclameposters', 9.11);
INSERT INTO boekregels VALUES (865, 173, 2013, '2013-03-08', 1600, NULL, 0, 0, 'kramer', 'HE90214', '', 'Spuitmateriaal', -302.65);
INSERT INTO boekregels VALUES (867, 173, 2013, '2013-03-08', 2200, NULL, 0, 0, 'kramer', 'HE90214', '', 'Spuitmateriaal', 52.53);
INSERT INTO boekregels VALUES (868, 174, 2013, '2013-03-11', 1600, NULL, 0, 0, 'vandien', '16216131', '', 'Verzekering Opel Combo', -129.25);
INSERT INTO boekregels VALUES (870, 175, 2013, '2013-03-11', 1600, NULL, 0, 0, 'belasting', '69414993M32', '', 'Motorrijtuigenbelasting Opel Combo 8/3-7/6 2013', -72.00);
INSERT INTO boekregels VALUES (872, 176, 2013, '2013-03-19', 1600, NULL, 0, 0, 'tmobile', '901186233106', '', 'T-mobile 75% zakelijk 16/3-15/4', -35.15);
INSERT INTO boekregels VALUES (873, 176, 2013, '2013-03-19', 4240, NULL, 874, 0, 'tmobile', '901186233106', '', 'T-mobile 75% zakelijk 16/3-15/4', 29.05);
INSERT INTO boekregels VALUES (874, 176, 2013, '2013-03-19', 2200, NULL, 0, 0, 'tmobile', '901186233106', '', 'T-mobile 75% zakelijk 16/3-15/4', 6.10);
INSERT INTO boekregels VALUES (875, 177, 2013, '2013-03-25', 1600, NULL, 0, 0, 'coating', '1303001', '', 'AGP 500', -140.97);
INSERT INTO boekregels VALUES (877, 177, 2013, '2013-03-25', 2200, NULL, 0, 0, 'coating', '1303001', '', 'AGP 500', 24.47);
INSERT INTO boekregels VALUES (878, 178, 2013, '2013-03-26', 1600, NULL, 0, 0, 'drukwerk', '2013154632', '', 'Foto op canvas', -11.50);
INSERT INTO boekregels VALUES (879, 178, 2013, '2013-03-26', 4220, NULL, 880, 0, 'drukwerk', '2013154632', '', 'Foto op canvas', 9.50);
INSERT INTO boekregels VALUES (880, 178, 2013, '2013-03-26', 2200, NULL, 0, 0, 'drukwerk', '2013154632', '', 'Foto op canvas', 2.00);
INSERT INTO boekregels VALUES (881, 179, 2013, '2012-12-03', 1600, NULL, 0, 0, 'verweij', '2012173', '', 'Huur atelier december 2012', -431.70);
INSERT INTO boekregels VALUES (882, 179, 2013, '2012-12-03', 4100, NULL, 883, 0, 'verweij', '2012173', '', 'Huur atelier december 2012', 356.78);
INSERT INTO boekregels VALUES (883, 179, 2013, '2012-12-03', 2200, NULL, 0, 0, 'verweij', '2012173', '', 'Huur atelier december 2012', 74.92);
INSERT INTO boekregels VALUES (884, 180, 2013, '2012-12-04', 4230, NULL, 885, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (885, 180, 2013, '2012-12-04', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (886, 180, 2013, '2012-11-28', 4220, NULL, 887, 0, '', '', '', 'USB stick en Cameradrone', 224.79);
INSERT INTO boekregels VALUES (887, 180, 2013, '2012-11-28', 2200, NULL, 0, 0, '', '', '', 'USB stick en Cameradrone', 47.20);
INSERT INTO boekregels VALUES (889, 180, 2013, '2012-11-14', 2200, NULL, 0, 0, '', '', '', 'Schoonmaakmiddelen', 6.93);
INSERT INTO boekregels VALUES (890, 180, 2013, '2012-10-04', 4490, NULL, 891, 0, '', '', '', 'Lunch', 8.77);
INSERT INTO boekregels VALUES (891, 180, 2013, '2012-10-04', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.53);
INSERT INTO boekregels VALUES (892, 180, 2013, '2012-11-22', 4220, NULL, 893, 0, '', '', '', 'Statief', 58.65);
INSERT INTO boekregels VALUES (893, 180, 2013, '2012-11-22', 2200, NULL, 0, 0, '', '', '', 'Statief', 12.32);
INSERT INTO boekregels VALUES (894, 180, 2013, '2013-01-01', 1060, NULL, 0, 0, '', '', '', 'Bonnen 2012', -398.20);
INSERT INTO boekregels VALUES (895, 181, 2013, '2013-01-14', 1200, NULL, 0, 0, 'ipse', '2013001', '', 'Muurschildering FC Utrecht, Zwammerdam', 341.83);
INSERT INTO boekregels VALUES (896, 181, 2013, '2013-01-14', 8060, NULL, 897, 0, 'ipse', '2013001', '', 'Muurschildering FC Utrecht, Zwammerdam', -282.50);
INSERT INTO boekregels VALUES (897, 181, 2013, '2013-01-14', 2110, NULL, 0, 0, 'ipse', '2013001', '', 'Muurschildering FC Utrecht, Zwammerdam', -59.33);
INSERT INTO boekregels VALUES (898, 182, 2013, '2013-02-20', 1200, NULL, 0, 0, 'bomenwijk', '2013002', '', 'Muurschilderingen Alexandertunnel, 25%', 1238.19);
INSERT INTO boekregels VALUES (899, 182, 2013, '2013-02-20', 8070, NULL, 900, 0, 'bomenwijk', '2013002', '', 'Muurschilderingen Alexandertunnel, 25%', -1023.30);
INSERT INTO boekregels VALUES (900, 182, 2013, '2013-02-20', 2110, NULL, 0, 0, 'bomenwijk', '2013002', '', 'Muurschilderingen Alexandertunnel, 25%', -214.89);
INSERT INTO boekregels VALUES (901, 183, 2013, '2013-02-27', 1200, NULL, 0, 0, 'bomenwijk', '2013003', '', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', 5926.73);
INSERT INTO boekregels VALUES (902, 183, 2013, '2013-02-27', 8070, NULL, 903, 0, 'bomenwijk', '2013003', '', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', -4898.12);
INSERT INTO boekregels VALUES (903, 183, 2013, '2013-02-27', 2110, NULL, 0, 0, 'bomenwijk', '2013003', '', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', -1028.61);
INSERT INTO boekregels VALUES (904, 184, 2013, '2013-03-06', 1200, NULL, 0, 0, 'gopantw', '2013004', '', 'Muurschildering binnen', 540.00);
INSERT INTO boekregels VALUES (905, 184, 2013, '2013-03-06', 8030, NULL, 0, 0, 'gopantw', '2013004', '', 'Muurschildering binnen', -540.00);
INSERT INTO boekregels VALUES (906, 185, 2013, '2013-03-16', 1200, NULL, 0, 0, 'kernel', '2013005', '', 'Presentatie graffiti 30 minuten', 60.50);
INSERT INTO boekregels VALUES (907, 185, 2013, '2013-03-16', 8110, NULL, 908, 0, 'kernel', '2013005', '', 'Presentatie graffiti 30 minuten', -50.00);
INSERT INTO boekregels VALUES (908, 185, 2013, '2013-03-16', 2110, NULL, 0, 0, 'kernel', '2013005', '', 'Presentatie graffiti 30 minuten', -10.50);
INSERT INTO boekregels VALUES (909, 186, 2013, '2013-01-04', 8060, NULL, 910, 0, '', '', '', 'Jungle Book Boskoop Sjon en Joke', -82.64);
INSERT INTO boekregels VALUES (910, 186, 2013, '2013-01-04', 2110, NULL, 0, 0, '', '', '', 'Jungle Book Boskoop Sjon en Joke', -17.36);
INSERT INTO boekregels VALUES (911, 186, 2013, '2013-01-08', 8060, NULL, 912, 0, '', '', '', 'Graffiti Nova', -111.57);
INSERT INTO boekregels VALUES (912, 186, 2013, '2013-01-08', 2110, NULL, 0, 0, '', '', '', 'Graffiti Nova', -23.43);
INSERT INTO boekregels VALUES (913, 186, 2013, '2013-01-16', 8060, NULL, 914, 0, '', '', '', 'Niek Hoofddorp', -111.57);
INSERT INTO boekregels VALUES (914, 186, 2013, '2013-01-16', 2110, NULL, 0, 0, '', '', '', 'Niek Hoofddorp', -23.43);
INSERT INTO boekregels VALUES (915, 186, 2013, '2013-01-26', 8060, NULL, 916, 0, '', '', '', 'Ruben Zeist', -111.57);
INSERT INTO boekregels VALUES (916, 186, 2013, '2013-01-26', 2110, NULL, 0, 0, '', '', '', 'Ruben Zeist', -23.43);
INSERT INTO boekregels VALUES (917, 186, 2013, '2013-02-02', 8060, NULL, 918, 0, '', '', '', 'Graffiti Frank Gouda', -276.86);
INSERT INTO boekregels VALUES (918, 186, 2013, '2013-02-02', 2110, NULL, 0, 0, '', '', '', 'Graffiti Frank Gouda', -58.14);
INSERT INTO boekregels VALUES (919, 186, 2013, '2013-03-16', 8060, NULL, 920, 0, '', '', '', 'Graffiti Amy Rozenburg', -82.64);
INSERT INTO boekregels VALUES (920, 186, 2013, '2013-03-16', 2110, NULL, 0, 0, '', '', '', 'Graffiti Amy Rozenburg', -17.36);
INSERT INTO boekregels VALUES (921, 186, 2013, '2013-03-29', 8060, NULL, 922, 0, '', '', '', 'Graffiti Wessel Woerden', -111.57);
INSERT INTO boekregels VALUES (922, 186, 2013, '2013-03-29', 2110, NULL, 0, 0, '', '', '', 'Graffiti Wessel Woerden', -23.43);
INSERT INTO boekregels VALUES (923, 186, 2013, '2013-03-31', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 1e kwartaal', 1075.00);
INSERT INTO boekregels VALUES (925, 187, 2013, '2013-01-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 9.85);
INSERT INTO boekregels VALUES (926, 187, 2013, '2013-01-09', 4490, NULL, 927, 0, '', '', '', 'Telefooncase', 1.56);
INSERT INTO boekregels VALUES (927, 187, 2013, '2013-01-09', 2200, NULL, 0, 0, '', '', '', 'Telefooncase', 0.33);
INSERT INTO boekregels VALUES (928, 187, 2013, '2013-01-09', 4250, NULL, 0, 0, '', '', '', 'Pakje', 6.75);
INSERT INTO boekregels VALUES (930, 187, 2013, '2013-01-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof en versnapering', 3.67);
INSERT INTO boekregels VALUES (932, 187, 2013, '2013-01-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 12.39);
INSERT INTO boekregels VALUES (933, 187, 2013, '2013-01-17', 4250, NULL, 0, 0, '', '', '', 'Postzegels', 3.78);
INSERT INTO boekregels VALUES (934, 187, 2013, '2013-01-17', 4220, NULL, 935, 0, '', '', '', 'Materiaal', 18.82);
INSERT INTO boekregels VALUES (935, 187, 2013, '2013-01-17', 2200, NULL, 0, 0, '', '', '', 'Materiaal', 3.95);
INSERT INTO boekregels VALUES (937, 187, 2013, '2013-01-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 10.76);
INSERT INTO boekregels VALUES (938, 187, 2013, '2013-01-24', 4230, NULL, 939, 0, '', '', '', 'Enveloppen en postzegels', 12.62);
INSERT INTO boekregels VALUES (939, 187, 2013, '2013-01-24', 2200, NULL, 0, 0, '', '', '', 'Enveloppen en postzegels', 0.38);
INSERT INTO boekregels VALUES (941, 187, 2013, '2013-01-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 10.46);
INSERT INTO boekregels VALUES (943, 187, 2013, '2013-01-31', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 6.54);
INSERT INTO boekregels VALUES (944, 187, 2013, '2013-01-22', 4250, NULL, 0, 0, '', '', '', 'Postzegels', 1.62);
INSERT INTO boekregels VALUES (945, 187, 2013, '2013-01-31', 4220, NULL, 946, 0, '', '', '', 'Schoonmaakmiddelen', 39.05);
INSERT INTO boekregels VALUES (946, 187, 2013, '2013-01-31', 2200, NULL, 0, 0, '', '', '', 'Schoonmaakmiddelen', 7.91);
INSERT INTO boekregels VALUES (947, 187, 2013, '2013-01-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 01 2013', -408.38);
INSERT INTO boekregels VALUES (948, 188, 2013, '2013-02-03', 4220, NULL, 949, 0, '', '', '', 'Lijm en rollers', 16.87);
INSERT INTO boekregels VALUES (949, 188, 2013, '2013-02-03', 2200, NULL, 0, 0, '', '', '', 'Lijm en rollers', 3.54);
INSERT INTO boekregels VALUES (950, 188, 2013, '2013-02-03', 4490, NULL, 951, 0, '', '', '', 'Parkeerkosten gouda', 6.61);
INSERT INTO boekregels VALUES (951, 188, 2013, '2013-02-03', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten gouda', 1.39);
INSERT INTO boekregels VALUES (952, 188, 2013, '2013-02-07', 4230, NULL, 953, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (953, 188, 2013, '2013-02-07', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (954, 188, 2013, '2013-02-08', 4490, NULL, 955, 0, '', '', '', 'Parkeerkosten gouda', 2.48);
INSERT INTO boekregels VALUES (955, 188, 2013, '2013-02-08', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten gouda', 0.52);
INSERT INTO boekregels VALUES (956, 188, 2013, '2013-02-09', 4490, NULL, 957, 0, '', '', '', 'Parkeerkosten gouda', 9.92);
INSERT INTO boekregels VALUES (957, 188, 2013, '2013-02-09', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten gouda', 2.08);
INSERT INTO boekregels VALUES (959, 188, 2013, '2013-02-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 10.66);
INSERT INTO boekregels VALUES (960, 188, 2013, '2013-02-11', 4490, NULL, 961, 0, '', '', '', 'Parkeerkosten scheveningen', 4.96);
INSERT INTO boekregels VALUES (961, 188, 2013, '2013-02-11', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten scheveningen', 1.04);
INSERT INTO boekregels VALUES (962, 188, 2013, '2013-02-17', 4490, NULL, 963, 0, '', '', '', 'Parkeerkosten gouda', 9.92);
INSERT INTO boekregels VALUES (963, 188, 2013, '2013-02-17', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten gouda', 2.08);
INSERT INTO boekregels VALUES (965, 188, 2013, '2013-02-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof', -7.04);
INSERT INTO boekregels VALUES (966, 188, 2013, '2013-02-19', 4490, NULL, 967, 0, '', '', '', 'Parkeerkosten gouda', 6.61);
INSERT INTO boekregels VALUES (967, 188, 2013, '2013-02-19', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten gouda', 1.39);
INSERT INTO boekregels VALUES (968, 188, 2013, '2013-02-23', 4220, NULL, 969, 0, '', '', '', 'Div materiaal atelier', 18.40);
INSERT INTO boekregels VALUES (969, 188, 2013, '2013-02-23', 2200, NULL, 0, 0, '', '', '', 'Div materiaal atelier', 3.87);
INSERT INTO boekregels VALUES (971, 188, 2013, '2013-02-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 10.05);
INSERT INTO boekregels VALUES (972, 188, 2013, '2013-02-23', 1060, NULL, 0, 0, '', '', '', 'Kasblad 02 2013', -244.67);
INSERT INTO boekregels VALUES (974, 189, 2013, '2013-03-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 10.84);
INSERT INTO boekregels VALUES (976, 189, 2013, '2013-03-03', 2210, NULL, 0, 0, '', '', '', 'Olie en spons', 1.89);
INSERT INTO boekregels VALUES (978, 189, 2013, '2013-03-11', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 8.64);
INSERT INTO boekregels VALUES (980, 189, 2013, '2013-03-11', 2200, NULL, 0, 0, '', '', '', 'Schildersdoeken', 8.33);
INSERT INTO boekregels VALUES (982, 189, 2013, '2013-03-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 6.08);
INSERT INTO boekregels VALUES (983, 189, 2013, '2013-03-17', 4490, NULL, 984, 0, '', '', '', 'Lunch', 6.32);
INSERT INTO boekregels VALUES (984, 189, 2013, '2013-03-17', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.38);
INSERT INTO boekregels VALUES (986, 189, 2013, '2013-03-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 9.67);
INSERT INTO boekregels VALUES (988, 189, 2013, '2013-03-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 5.43);
INSERT INTO boekregels VALUES (989, 189, 2013, '2013-03-23', 4490, NULL, 990, 0, '', '', '', 'Versnapering', 1.97);
INSERT INTO boekregels VALUES (990, 189, 2013, '2013-03-23', 2200, NULL, 0, 0, '', '', '', 'Versnapering', 0.12);
INSERT INTO boekregels VALUES (992, 189, 2013, '2013-03-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 6.50);
INSERT INTO boekregels VALUES (994, 189, 2013, '2013-03-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 5.26);
INSERT INTO boekregels VALUES (995, 189, 2013, '2013-03-29', 4220, NULL, 996, 0, '', '', '', 'Folie en tape', 14.83);
INSERT INTO boekregels VALUES (996, 189, 2013, '2013-03-29', 2200, NULL, 0, 0, '', '', '', 'Folie en tape', 3.12);
INSERT INTO boekregels VALUES (997, 189, 2013, '2013-03-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 03 2013', -387.68);
INSERT INTO boekregels VALUES (1000, 191, 2013, '2013-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 1499.91);
INSERT INTO boekregels VALUES (1001, 191, 2013, '2013-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -597.60);
INSERT INTO boekregels VALUES (1002, 191, 2013, '2013-03-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -121.65);
INSERT INTO boekregels VALUES (1003, 191, 2013, '2013-03-31', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 0.00);
INSERT INTO boekregels VALUES (1004, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -1499.91);
INSERT INTO boekregels VALUES (1005, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.09);
INSERT INTO boekregels VALUES (1006, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2220', 0.00);
INSERT INTO boekregels VALUES (1007, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2210', 121.65);
INSERT INTO boekregels VALUES (1008, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 597.60);
INSERT INTO boekregels VALUES (1009, 191, 2013, '2013-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.25);
INSERT INTO boekregels VALUES (1010, 191, 2013, '2013-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.09);
INSERT INTO boekregels VALUES (1011, 191, 2013, '2013-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.25);
INSERT INTO boekregels VALUES (1012, 192, 2013, '2013-04-01', 1600, NULL, 0, 0, 'vend', '114345373', '', 'Schildersdoek 120x160', -240.00);
INSERT INTO boekregels VALUES (1014, 192, 2013, '2013-04-01', 2200, NULL, 0, 0, 'vend', '114345373', '', 'Schildersdoek 120x160', 41.65);
INSERT INTO boekregels VALUES (1015, 193, 2013, '2013-04-10', 1600, NULL, 0, 0, 'bolcom', '8120632180', '', 'Drukspuit', -14.99);
INSERT INTO boekregels VALUES (1016, 193, 2013, '2013-04-10', 4210, NULL, 1017, 0, 'bolcom', '8120632180', '', 'Drukspuit', 12.39);
INSERT INTO boekregels VALUES (1017, 193, 2013, '2013-04-10', 2200, NULL, 0, 0, 'bolcom', '8120632180', '', 'Drukspuit', 2.60);
INSERT INTO boekregels VALUES (1018, 194, 2013, '2013-04-11', 1600, NULL, 0, 0, 'kramer', 'HE90648', '', 'Spuitmateriaal', -473.65);
INSERT INTO boekregels VALUES (1021, 195, 2013, '2013-04-11', 1600, NULL, 0, 0, 'bolcom', '8120632180', '', 'Afdekfolie', -11.99);
INSERT INTO boekregels VALUES (1022, 195, 2013, '2013-04-11', 4220, NULL, 1023, 0, 'bolcom', '8120632180', '', 'Afdekfolie', 9.91);
INSERT INTO boekregels VALUES (1023, 195, 2013, '2013-04-11', 2200, NULL, 0, 0, 'bolcom', '8120632180', '', 'Afdekfolie', 2.08);
INSERT INTO boekregels VALUES (1024, 196, 2013, '2013-04-17', 1600, NULL, 0, 0, 'marktplaats', 'MP130423317', '', 'Advertentiepakket KK', -65.34);
INSERT INTO boekregels VALUES (1026, 196, 2013, '2013-04-17', 2200, NULL, 0, 0, 'marktplaats', 'MP130423317', '', 'Advertentiepakket KK', 11.34);
INSERT INTO boekregels VALUES (1027, 197, 2013, '2013-04-24', 1600, NULL, 0, 0, 'drukwerk', 'F2013175995', '', 'Folders KK', -71.32);
INSERT INTO boekregels VALUES (1029, 197, 2013, '2013-04-24', 2200, NULL, 0, 0, 'drukwerk', 'F2013175995', '', 'Folders KK', 12.38);
INSERT INTO boekregels VALUES (1030, 198, 2013, '2013-04-25', 1600, NULL, 0, 0, 'kramer', 'HE90767', '', 'Spuitmateriaal', -166.20);
INSERT INTO boekregels VALUES (942, 187, 2013, '2013-01-31', 4410, NULL, 943, 0, '', '', '', 'Brandstof', 31.12);
INSERT INTO boekregels VALUES (1033, 199, 2013, '2013-04-29', 1600, NULL, 0, 0, 'kramer', 'HE90780', '', 'Spuitmateriaal', -96.20);
INSERT INTO boekregels VALUES (1036, 200, 2013, '2013-05-04', 1600, NULL, 0, 0, 'vanbeek', '947244', '', 'Doeken en tekenmaterialen', -92.25);
INSERT INTO boekregels VALUES (1038, 200, 2013, '2013-05-04', 2200, NULL, 0, 0, 'vanbeek', '947244', '', 'Doeken en tekenmaterialen', 16.01);
INSERT INTO boekregels VALUES (1039, 201, 2013, '2013-05-17', 1600, NULL, 0, 0, 'vanbeek', '952146', '', 'Stiften', -27.74);
INSERT INTO boekregels VALUES (1040, 201, 2013, '2013-05-17', 4220, NULL, 1041, 0, 'vanbeek', '952146', '', 'Stiften', 22.93);
INSERT INTO boekregels VALUES (1041, 201, 2013, '2013-05-17', 2200, NULL, 0, 0, 'vanbeek', '952146', '', 'Stiften', 4.81);
INSERT INTO boekregels VALUES (1042, 202, 2013, '2013-05-15', 1600, NULL, 0, 0, 'kramer', 'HE90898', '', 'Spuitmateriaal', -540.80);
INSERT INTO boekregels VALUES (1045, 203, 2013, '2013-05-17', 1600, NULL, 0, 0, 'diverse', '4000000034171391', '', 'Amsterdam parkeerheffing', -60.90);
INSERT INTO boekregels VALUES (1046, 203, 2013, '2013-05-17', 4400, NULL, 0, 0, 'diverse', '4000000034171391', '', 'Amsterdam parkeerheffing', 60.90);
INSERT INTO boekregels VALUES (1047, 204, 2013, '2013-05-22', 1600, NULL, 0, 0, 'stoffen', '201301243', '', 'Kaasdoek', -27.66);
INSERT INTO boekregels VALUES (1052, 206, 2013, '2013-07-11', 1600, NULL, 0, 0, 'vandien', '16546675', '', 'Verzekering Opel 11-7/11-10', -129.25);
INSERT INTO boekregels VALUES (1054, 207, 2013, '2013-06-11', 1600, NULL, 0, 0, 'claasen', 'F773925', '', 'Latex en rollers', -50.17);
INSERT INTO boekregels VALUES (1057, 208, 2013, '2013-06-24', 1600, NULL, 0, 0, 'engelb', '254755', '', 'Spuitmaskers', -78.89);
INSERT INTO boekregels VALUES (1058, 208, 2013, '2013-06-24', 4220, NULL, 1059, 0, 'engelb', '254755', '', 'Spuitmaskers', 65.20);
INSERT INTO boekregels VALUES (1059, 208, 2013, '2013-06-24', 2200, NULL, 0, 0, 'engelb', '254755', '', 'Spuitmaskers', 13.69);
INSERT INTO boekregels VALUES (1060, 209, 2013, '2013-06-23', 1600, NULL, 0, 0, 'conrad', '9549690681', '', 'Acculader en laadkabel', -81.87);
INSERT INTO boekregels VALUES (1061, 209, 2013, '2013-06-23', 4220, NULL, 1062, 0, 'conrad', '9549690681', '', 'Acculader en laadkabel', 67.66);
INSERT INTO boekregels VALUES (1062, 209, 2013, '2013-06-23', 2200, NULL, 0, 0, 'conrad', '9549690681', '', 'Acculader en laadkabel', 14.21);
INSERT INTO boekregels VALUES (1063, 210, 2013, '2013-06-25', 1600, NULL, 0, 0, 'kramer', 'HE91317', '', 'Spuitmateriaal', -200.85);
INSERT INTO boekregels VALUES (1066, 211, 2013, '2013-06-26', 1600, NULL, 0, 0, 'kbaudio', '100007363', '', 'Audio in auto', -119.95);
INSERT INTO boekregels VALUES (1068, 211, 2013, '2013-06-26', 2210, NULL, 0, 0, 'kbaudio', '100007363', '', 'Audio in auto', 20.82);
INSERT INTO boekregels VALUES (1069, 212, 2013, '2013-06-26', 1600, NULL, 0, 0, 'kramer', 'HE91195', '', 'Spuitmateriaal', -162.80);
INSERT INTO boekregels VALUES (1072, 213, 2013, '2013-06-28', 1600, NULL, 0, 0, 'profile', 'M10087057', '', 'Banden Nissan', -695.00);
INSERT INTO boekregels VALUES (1020, 194, 2013, '2013-04-11', 2200, NULL, 0, 0, 'kramer', 'HE90648', '', 'Spuitmateriaal', 82.20);
INSERT INTO boekregels VALUES (1031, 198, 2013, '2013-04-25', 5010, NULL, 1032, 0, 'kramer', 'HE90767', '', 'Spuitmateriaal', 137.36);
INSERT INTO boekregels VALUES (1032, 198, 2013, '2013-04-25', 2200, NULL, 0, 0, 'kramer', 'HE90767', '', 'Spuitmateriaal', 28.84);
INSERT INTO boekregels VALUES (1034, 199, 2013, '2013-04-29', 5010, NULL, 1035, 0, 'kramer', 'HE90780', '', 'Spuitmateriaal', 79.50);
INSERT INTO boekregels VALUES (1035, 199, 2013, '2013-04-29', 2200, NULL, 0, 0, 'kramer', 'HE90780', '', 'Spuitmateriaal', 16.70);
INSERT INTO boekregels VALUES (1043, 202, 2013, '2013-05-15', 5010, NULL, 1044, 0, 'kramer', 'HE90898', '', 'Spuitmateriaal', 446.94);
INSERT INTO boekregels VALUES (1044, 202, 2013, '2013-05-15', 2200, NULL, 0, 0, 'kramer', 'HE90898', '', 'Spuitmateriaal', 93.86);
INSERT INTO boekregels VALUES (1048, 204, 2013, '2013-05-22', 5010, NULL, 1049, 0, 'stoffen', '201301243', '', 'Kaasdoek', 22.86);
INSERT INTO boekregels VALUES (1049, 204, 2013, '2013-05-22', 2200, NULL, 0, 0, 'stoffen', '201301243', '', 'Kaasdoek', 4.80);
INSERT INTO boekregels VALUES (1055, 207, 2013, '2013-06-11', 5010, NULL, 1056, 0, 'claasen', 'F773925', '', 'Latex en rollers', 41.46);
INSERT INTO boekregels VALUES (1056, 207, 2013, '2013-06-11', 2200, NULL, 0, 0, 'claasen', 'F773925', '', 'Latex en rollers', 8.71);
INSERT INTO boekregels VALUES (1064, 210, 2013, '2013-06-25', 5010, NULL, 1065, 0, 'kramer', 'HE91317', '', 'Spuitmateriaal', 165.99);
INSERT INTO boekregels VALUES (1065, 210, 2013, '2013-06-25', 2200, NULL, 0, 0, 'kramer', 'HE91317', '', 'Spuitmateriaal', 34.86);
INSERT INTO boekregels VALUES (1070, 212, 2013, '2013-06-26', 5010, NULL, 1071, 0, 'kramer', 'HE91195', '', 'Spuitmateriaal', 134.55);
INSERT INTO boekregels VALUES (1074, 213, 2013, '2013-06-28', 2210, NULL, 0, 0, 'profile', 'M10087057', '', 'Banden Nissan', 120.62);
INSERT INTO boekregels VALUES (1077, 214, 2013, '2013-04-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.39);
INSERT INTO boekregels VALUES (1078, 214, 2013, '2013-04-03', 4490, NULL, 1079, 0, '', '', '', 'Kraan garage', 99.15);
INSERT INTO boekregels VALUES (1079, 214, 2013, '2013-04-03', 2200, NULL, 0, 0, '', '', '', 'Kraan garage', 20.82);
INSERT INTO boekregels VALUES (1080, 214, 2013, '2013-04-05', 4210, NULL, 1081, 0, '', '', '', 'Muis', 20.65);
INSERT INTO boekregels VALUES (1081, 214, 2013, '2013-04-05', 2200, NULL, 0, 0, '', '', '', 'Muis', 4.34);
INSERT INTO boekregels VALUES (1082, 214, 2013, '2013-04-10', 4235, NULL, 1083, 0, '', '', '', 'Koffie voorraad', 67.58);
INSERT INTO boekregels VALUES (1083, 214, 2013, '2013-04-10', 2200, NULL, 0, 0, '', '', '', 'Koffie voorraad', 4.06);
INSERT INTO boekregels VALUES (1085, 214, 2013, '2013-04-11', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 11.42);
INSERT INTO boekregels VALUES (1086, 214, 2013, '2013-04-13', 4220, NULL, 1087, 0, '', '', '', 'Schuurpapier etc', 6.86);
INSERT INTO boekregels VALUES (1087, 214, 2013, '2013-04-13', 2200, NULL, 0, 0, '', '', '', 'Schuurpapier etc', 1.44);
INSERT INTO boekregels VALUES (1089, 214, 2013, '2013-04-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.94);
INSERT INTO boekregels VALUES (1093, 214, 2013, '2013-04-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 1.84);
INSERT INTO boekregels VALUES (1095, 214, 2013, '2013-04-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.85);
INSERT INTO boekregels VALUES (1096, 214, 2013, '2013-04-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 04', -530.89);
INSERT INTO boekregels VALUES (1097, 215, 2013, '2013-05-01', 4490, NULL, 1098, 0, '', '', '', 'Enveloppen postzegels', 25.24);
INSERT INTO boekregels VALUES (1098, 215, 2013, '2013-05-01', 2200, NULL, 0, 0, '', '', '', 'Enveloppen postzegels', 0.76);
INSERT INTO boekregels VALUES (1100, 215, 2013, '2013-05-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.54);
INSERT INTO boekregels VALUES (1101, 215, 2013, '2013-05-02', 4490, NULL, 0, 0, '', '', '', 'Parkeerkosten Asd', 15.00);
INSERT INTO boekregels VALUES (1102, 215, 2013, '2013-05-02', 4490, NULL, 0, 0, '', '', '', 'Parkeerkosten Asd', 5.00);
INSERT INTO boekregels VALUES (1103, 215, 2013, '2013-05-02', 4490, NULL, 0, 0, '', '', '', 'Parkeerkosten Asd naheffing', 60.90);
INSERT INTO boekregels VALUES (1106, 215, 2013, '2013-05-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.73);
INSERT INTO boekregels VALUES (1108, 215, 2013, '2013-05-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.36);
INSERT INTO boekregels VALUES (1110, 215, 2013, '2013-05-19', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.37);
INSERT INTO boekregels VALUES (1111, 215, 2013, '2013-05-19', 4235, NULL, 1112, 0, '', '', '', 'Versnaperingen', 5.79);
INSERT INTO boekregels VALUES (1112, 215, 2013, '2013-05-19', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.34);
INSERT INTO boekregels VALUES (1113, 215, 2013, '2013-05-21', 4220, NULL, 1114, 0, '', '', '', 'Gekleurd karton', 4.12);
INSERT INTO boekregels VALUES (1114, 215, 2013, '2013-05-21', 2200, NULL, 0, 0, '', '', '', 'Gekleurd karton', 0.86);
INSERT INTO boekregels VALUES (1115, 215, 2013, '2013-05-24', 4210, NULL, 1116, 0, '', '', '', 'Toetsenbord bluetooth', 33.05);
INSERT INTO boekregels VALUES (1116, 215, 2013, '2013-05-24', 2200, NULL, 0, 0, '', '', '', 'Toetsenbord bluetooth', 6.94);
INSERT INTO boekregels VALUES (1117, 215, 2013, '2013-05-24', 4220, NULL, 1118, 0, '', '', '', 'Memorystick', 12.39);
INSERT INTO boekregels VALUES (1118, 215, 2013, '2013-05-24', 2200, NULL, 0, 0, '', '', '', 'Memorystick', 2.60);
INSERT INTO boekregels VALUES (1120, 215, 2013, '2013-05-25', 4490, NULL, 0, 0, '', '', '', 'Parkeerkosten', 2.00);
INSERT INTO boekregels VALUES (1121, 215, 2013, '2013-05-26', 4490, NULL, 1122, 0, '', '', '', 'Parkeerkosten', 5.45);
INSERT INTO boekregels VALUES (1122, 215, 2013, '2013-05-26', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten', 1.15);
INSERT INTO boekregels VALUES (1123, 215, 2013, '2013-05-27', 4220, NULL, 1124, 0, '', '', '', 'Led verlichting', 14.04);
INSERT INTO boekregels VALUES (1124, 215, 2013, '2013-05-27', 2200, NULL, 0, 0, '', '', '', 'Led verlichting', 2.95);
INSERT INTO boekregels VALUES (1127, 215, 2013, '2013-05-28', 4235, NULL, 1128, 0, '', '', '', 'Versnaperingen', 1.84);
INSERT INTO boekregels VALUES (1128, 215, 2013, '2013-05-28', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.11);
INSERT INTO boekregels VALUES (1129, 215, 2013, '2013-05-29', 4220, NULL, 1130, 0, '', '', '', 'Verf en schoonmaak', 36.59);
INSERT INTO boekregels VALUES (1130, 215, 2013, '2013-05-29', 2200, NULL, 0, 0, '', '', '', 'Verf en schoonmaak', 7.42);
INSERT INTO boekregels VALUES (1132, 215, 2013, '2013-05-29', 2200, NULL, 0, 0, '', '', '', 'Latex en kwasten', 11.22);
INSERT INTO boekregels VALUES (1134, 215, 2013, '2013-05-29', 2200, NULL, 0, 0, '', '', '', 'Voorstrijk en roller', 18.94);
INSERT INTO boekregels VALUES (1136, 215, 2013, '2013-05-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.13);
INSERT INTO boekregels VALUES (1137, 215, 2013, '2013-05-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 05', -817.92);
INSERT INTO boekregels VALUES (1138, 216, 2013, '2013-06-02', 4490, NULL, 1139, 0, '', '', '', 'Handsfree bluetooth', 11.52);
INSERT INTO boekregels VALUES (1139, 216, 2013, '2013-06-02', 2200, NULL, 0, 0, '', '', '', 'Handsfree bluetooth', 2.42);
INSERT INTO boekregels VALUES (1141, 216, 2013, '2013-06-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.68);
INSERT INTO boekregels VALUES (1142, 216, 2013, '2013-06-08', 4220, NULL, 1143, 0, '', '', '', 'Kwasten en rollers', 11.74);
INSERT INTO boekregels VALUES (1143, 216, 2013, '2013-06-08', 2200, NULL, 0, 0, '', '', '', 'Kwasten en rollers', 2.46);
INSERT INTO boekregels VALUES (1145, 216, 2013, '2013-06-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 3.54);
INSERT INTO boekregels VALUES (1147, 216, 2013, '2013-06-19', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.82);
INSERT INTO boekregels VALUES (1148, 216, 2013, '2013-06-25', 4250, NULL, 0, 0, '', '', '', 'Aangetekend Nissan garage', 7.70);
INSERT INTO boekregels VALUES (1152, 216, 2013, '2013-06-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.78);
INSERT INTO boekregels VALUES (1153, 216, 2013, '2013-05-17', 4210, NULL, 1154, 0, '', '', '', 'Smartphone Aldi', 230.58);
INSERT INTO boekregels VALUES (1154, 216, 2013, '2013-05-17', 2200, NULL, 0, 0, '', '', '', 'Smartphone Aldi', 48.42);
INSERT INTO boekregels VALUES (1155, 216, 2013, '2013-05-17', 1060, NULL, 0, 0, '', '', '', 'Kasblad 06', -511.00);
INSERT INTO boekregels VALUES (1156, 217, 2013, '2013-06-10', 1600, NULL, 0, 0, 'koops', '63700647', '', 'Aanschaf Nissan Nv200 5-VKH-50', -9842.95);
INSERT INTO boekregels VALUES (1157, 217, 2013, '2013-06-10', 210, NULL, 1158, 0, 'koops', '63700647', '', 'Aanschaf Nissan Nv200 5-VKH-50', 7495.00);
INSERT INTO boekregels VALUES (1158, 217, 2013, '2013-06-10', 2210, NULL, 0, 0, 'koops', '63700647', '', 'Aanschaf Nissan Nv200 5-VKH-50', 1573.95);
INSERT INTO boekregels VALUES (1159, 218, 2013, '2013-04-06', 1200, NULL, 0, 0, 'vdEnde', '2013006', '', 'Schilderij Wicked', 508.20);
INSERT INTO boekregels VALUES (1160, 218, 2013, '2013-04-06', 8075, NULL, 1161, 0, 'vdEnde', '2013006', '', 'Schilderij Wicked', -420.00);
INSERT INTO boekregels VALUES (1161, 218, 2013, '2013-04-06', 2110, NULL, 0, 0, 'vdEnde', '2013006', '', 'Schilderij Wicked', -88.20);
INSERT INTO boekregels VALUES (1162, 219, 2013, '2013-04-13', 1200, NULL, 0, 0, 'rooiehoek', '2013007', '', 'Schildering Rolluik', 290.40);
INSERT INTO boekregels VALUES (1163, 219, 2013, '2013-04-13', 8070, NULL, 1164, 0, 'rooiehoek', '2013007', '', 'Schildering Rolluik', -240.00);
INSERT INTO boekregels VALUES (1164, 219, 2013, '2013-04-13', 2110, NULL, 0, 0, 'rooiehoek', '2013007', '', 'Schildering Rolluik', -50.40);
INSERT INTO boekregels VALUES (1165, 220, 2013, '2013-04-23', 1200, NULL, 0, 0, 'bomenwijk', '2013008', '', 'Graffitiworkshop opening Skatepark', 302.50);
INSERT INTO boekregels VALUES (1166, 220, 2013, '2013-04-23', 8110, NULL, 1167, 0, 'bomenwijk', '2013008', '', 'Graffitiworkshop opening Skatepark', -250.00);
INSERT INTO boekregels VALUES (1167, 220, 2013, '2013-04-23', 2110, NULL, 0, 0, 'bomenwijk', '2013008', '', 'Graffitiworkshop opening Skatepark', -52.50);
INSERT INTO boekregels VALUES (1168, 221, 2013, '2013-05-05', 1200, NULL, 0, 0, 'eataly', '2013009', '', 'Wandschilderingen', 867.87);
INSERT INTO boekregels VALUES (1169, 221, 2013, '2013-05-05', 8070, NULL, 1170, 0, 'eataly', '2013009', '', 'Wandschilderingen', -717.25);
INSERT INTO boekregels VALUES (1170, 221, 2013, '2013-05-05', 2110, NULL, 0, 0, 'eataly', '2013009', '', 'Wandschilderingen', -150.62);
INSERT INTO boekregels VALUES (1171, 222, 2013, '2013-05-05', 1200, NULL, 0, 0, 'freedom', '201310', '', 'Logo Freenorm', 423.50);
INSERT INTO boekregels VALUES (1172, 222, 2013, '2013-05-05', 8080, NULL, 1173, 0, 'freedom', '201310', '', 'Logo Freenorm', -350.00);
INSERT INTO boekregels VALUES (1173, 222, 2013, '2013-05-05', 2110, NULL, 0, 0, 'freedom', '201310', '', 'Logo Freenorm', -73.50);
INSERT INTO boekregels VALUES (1174, 223, 2013, '2013-05-09', 1200, NULL, 0, 0, 'annders', '201311', '', 'Schilderij Vermeer', 284.35);
INSERT INTO boekregels VALUES (1585, 344, 2012, '2012-01-23', 4235, NULL, 1586, 0, '', '', '', 'Koffie', 9.77);
INSERT INTO boekregels VALUES (1091, 214, 2013, '2013-04-23', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 5.10);
INSERT INTO boekregels VALUES (1125, 215, 2013, '2013-05-28', 5010, NULL, 1126, 0, '', '', '', 'Plaatmateriaal', 47.06);
INSERT INTO boekregels VALUES (1126, 215, 2013, '2013-05-28', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 9.88);
INSERT INTO boekregels VALUES (1149, 216, 2013, '2013-06-25', 5010, NULL, 1150, 0, '', '', '', 'Spuitmateriaal', 15.35);
INSERT INTO boekregels VALUES (1150, 216, 2013, '2013-06-25', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 3.22);
INSERT INTO boekregels VALUES (1175, 223, 2013, '2013-05-09', 8075, NULL, 1176, 0, 'annders', '201311', '', 'Schilderij Vermeer', -235.00);
INSERT INTO boekregels VALUES (1176, 223, 2013, '2013-05-09', 2110, NULL, 0, 0, 'annders', '201311', '', 'Schilderij Vermeer', -49.35);
INSERT INTO boekregels VALUES (1177, 224, 2013, '2013-05-14', 1200, NULL, 0, 0, 'ipse', '201312', '', 'Wandschildering bloemen', 330.94);
INSERT INTO boekregels VALUES (1178, 224, 2013, '2013-05-14', 8060, NULL, 1179, 0, 'ipse', '201312', '', 'Wandschildering bloemen', -273.50);
INSERT INTO boekregels VALUES (1179, 224, 2013, '2013-05-14', 2110, NULL, 0, 0, 'ipse', '201312', '', 'Wandschildering bloemen', -57.44);
INSERT INTO boekregels VALUES (1180, 225, 2013, '2013-05-20', 1200, NULL, 0, 0, 'annders', '201313', '', 'Schilderij Vermeer bijwerken', 50.00);
INSERT INTO boekregels VALUES (1181, 225, 2013, '2013-05-20', 8075, NULL, 1182, 0, 'annders', '201313', '', 'Schilderij Vermeer bijwerken', -41.32);
INSERT INTO boekregels VALUES (1182, 225, 2013, '2013-05-20', 2110, NULL, 0, 0, 'annders', '201313', '', 'Schilderij Vermeer bijwerken', -8.68);
INSERT INTO boekregels VALUES (1183, 226, 2013, '2013-05-20', 1200, NULL, 0, 0, 'coppoolse', '201314', '', 'Wandschildering fotostudio', 225.00);
INSERT INTO boekregels VALUES (1184, 226, 2013, '2013-05-20', 8070, NULL, 1185, 0, 'coppoolse', '201314', '', 'Wandschildering fotostudio', -185.95);
INSERT INTO boekregels VALUES (1185, 226, 2013, '2013-05-20', 2110, NULL, 0, 0, 'coppoolse', '201314', '', 'Wandschildering fotostudio', -39.05);
INSERT INTO boekregels VALUES (1186, 227, 2013, '2013-05-30', 1200, NULL, 0, 0, 'horizon', '201315', '', 'Graffitiworkshop', 550.55);
INSERT INTO boekregels VALUES (1187, 227, 2013, '2013-05-30', 8110, NULL, 1188, 0, 'horizon', '201315', '', 'Graffitiworkshop', -455.00);
INSERT INTO boekregels VALUES (1188, 227, 2013, '2013-05-30', 2110, NULL, 0, 0, 'horizon', '201315', '', 'Graffitiworkshop', -95.55);
INSERT INTO boekregels VALUES (1189, 228, 2013, '2013-06-06', 1200, NULL, 0, 0, 'coppoolse', '201316', '', 'Schildering op kaasdoek', 133.27);
INSERT INTO boekregels VALUES (1190, 228, 2013, '2013-06-06', 8070, NULL, 1191, 0, 'coppoolse', '201316', '', 'Schildering op kaasdoek', -110.14);
INSERT INTO boekregels VALUES (1191, 228, 2013, '2013-06-06', 2110, NULL, 0, 0, 'coppoolse', '201316', '', 'Schildering op kaasdoek', -23.13);
INSERT INTO boekregels VALUES (1192, 229, 2013, '2013-06-10', 1200, NULL, 0, 0, 'markies', '201317', '', 'Wandschildering Las Vegas', 726.00);
INSERT INTO boekregels VALUES (1193, 229, 2013, '2013-06-10', 8070, NULL, 1194, 0, 'markies', '201317', '', 'Wandschildering Las Vegas', -600.00);
INSERT INTO boekregels VALUES (1194, 229, 2013, '2013-06-10', 2110, NULL, 0, 0, 'markies', '201317', '', 'Wandschildering Las Vegas', -126.00);
INSERT INTO boekregels VALUES (1195, 230, 2013, '2013-06-18', 1200, NULL, 0, 0, 'butterfly', '201318', '', 'Wandschildering buitenmuur', 704.46);
INSERT INTO boekregels VALUES (1196, 230, 2013, '2013-06-18', 8070, NULL, 1197, 0, 'butterfly', '201318', '', 'Wandschildering buitenmuur', -582.20);
INSERT INTO boekregels VALUES (1197, 230, 2013, '2013-06-18', 2110, NULL, 0, 0, 'butterfly', '201318', '', 'Wandschildering buitenmuur', -122.26);
INSERT INTO boekregels VALUES (1198, 231, 2013, '2013-06-19', 1200, NULL, 0, 0, 'koops', '201319', '', 'Verkoop Opel Combi', 1512.50);
INSERT INTO boekregels VALUES (1199, 231, 2013, '2013-06-19', 8190, NULL, 1200, 0, 'koops', '201319', '', 'Verkoop Opel Combi', -1250.00);
INSERT INTO boekregels VALUES (1200, 231, 2013, '2013-06-19', 2110, NULL, 0, 0, 'koops', '201319', '', 'Verkoop Opel Combi', -262.50);
INSERT INTO boekregels VALUES (1201, 232, 2013, '2013-04-11', 8060, NULL, 1202, 0, '', '', '', 'Pepita Nijkerkerveen', -123.97);
INSERT INTO boekregels VALUES (1202, 232, 2013, '2013-04-11', 2110, NULL, 0, 0, '', '', '', 'Pepita Nijkerkerveen', -26.03);
INSERT INTO boekregels VALUES (1203, 232, 2013, '2013-04-24', 8110, NULL, 1204, 0, '', '', '', 'Karin workshop', -49.59);
INSERT INTO boekregels VALUES (1204, 232, 2013, '2013-04-24', 2110, NULL, 0, 0, '', '', '', 'Karin workshop', -10.41);
INSERT INTO boekregels VALUES (1205, 232, 2013, '2013-05-07', 8060, NULL, 1206, 0, '', '', '', 'Gijs paneel', -123.97);
INSERT INTO boekregels VALUES (1206, 232, 2013, '2013-05-07', 2110, NULL, 0, 0, '', '', '', 'Gijs paneel', -26.03);
INSERT INTO boekregels VALUES (1207, 232, 2013, '2013-05-11', 8060, NULL, 1208, 0, '', '', '', 'Dennis & Yvette Andy Warhol', -123.97);
INSERT INTO boekregels VALUES (1208, 232, 2013, '2013-05-11', 2110, NULL, 0, 0, '', '', '', 'Dennis & Yvette Andy Warhol', -26.03);
INSERT INTO boekregels VALUES (1209, 232, 2013, '2013-05-26', 8065, NULL, 1210, 0, '', '', '', 'Pim schilderij Brood', -123.97);
INSERT INTO boekregels VALUES (1210, 232, 2013, '2013-05-26', 2110, NULL, 0, 0, '', '', '', 'Pim schilderij Brood', -26.03);
INSERT INTO boekregels VALUES (1211, 232, 2013, '2013-06-12', 8060, NULL, 1212, 0, '', '', '', 'Paard+Love Den Haag', -111.57);
INSERT INTO boekregels VALUES (1212, 232, 2013, '2013-06-12', 2110, NULL, 0, 0, '', '', '', 'Paard+Love Den Haag', -23.43);
INSERT INTO boekregels VALUES (1213, 232, 2013, '2013-06-15', 8060, NULL, 1214, 0, '', '', '', 'Skye+Takel graffiti', -157.02);
INSERT INTO boekregels VALUES (1214, 232, 2013, '2013-06-15', 2110, NULL, 0, 0, '', '', '', 'Skye+Takel graffiti', -32.98);
INSERT INTO boekregels VALUES (1215, 232, 2013, '2013-06-19', 8060, NULL, 1216, 0, '', '', '', 'Arman+Sam Barendrecht', -219.01);
INSERT INTO boekregels VALUES (1216, 232, 2013, '2013-06-19', 2110, NULL, 0, 0, '', '', '', 'Arman+Sam Barendrecht', -45.99);
INSERT INTO boekregels VALUES (1217, 232, 2013, '2013-06-23', 8060, NULL, 1218, 0, '', '', '', 'Mees Alphen ad Rijn', -103.31);
INSERT INTO boekregels VALUES (1218, 232, 2013, '2013-06-23', 2110, NULL, 0, 0, '', '', '', 'Mees Alphen ad Rijn', -21.69);
INSERT INTO boekregels VALUES (1219, 232, 2013, '2013-06-30', 8060, NULL, 1220, 0, '', '', '', 'Dylano Maastricht', -148.76);
INSERT INTO boekregels VALUES (1220, 232, 2013, '2013-06-30', 2110, NULL, 0, 0, '', '', '', 'Dylano Maastricht', -31.24);
INSERT INTO boekregels VALUES (1221, 232, 2013, '2013-06-30', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 2e kwartaal', 1555.00);
INSERT INTO boekregels VALUES (1224, 233, 2013, '2013-06-30', 2210, NULL, 0, 0, '', '', '', 'Correctie BTW 1e per. jrnl.188', 7.04);
INSERT INTO boekregels VALUES (1225, 233, 2013, '2013-06-30', 2210, NULL, 0, 0, '', '', '', 'Correctie BTW 1e per. jrnl.188', 7.04);
INSERT INTO boekregels VALUES (1226, 233, 2013, '2013-06-30', 1060, NULL, 0, 0, '', '', '', 'Correctie BTW 1e per. jrnl.188', -14.08);
INSERT INTO boekregels VALUES (1228, 217, 2013, '2013-06-10', 2210, NULL, 0, 0, 'koops', '63700647', '', 'Aanschafkosten Nissan Nv200 5-VKH-50', 134.33);
INSERT INTO boekregels VALUES (1229, 234, 2013, '2013-04-18', 1600, NULL, 0, 0, 'tmobile', '901188503627', '', 'Telefoon apr 75% zakelijk', -22.16);
INSERT INTO boekregels VALUES (1230, 234, 2013, '2013-04-18', 4240, NULL, 1231, 0, 'tmobile', '901188503627', '', 'Telefoon apr 75% zakelijk', 18.31);
INSERT INTO boekregels VALUES (1231, 234, 2013, '2013-04-18', 2200, NULL, 0, 0, 'tmobile', '901188503627', '', 'Telefoon apr 75% zakelijk', 3.85);
INSERT INTO boekregels VALUES (1232, 235, 2013, '2013-05-21', 1600, NULL, 0, 0, 'tmobile', '901190736769', '', 'Telefoon mei 75% zakelijk', -24.77);
INSERT INTO boekregels VALUES (1233, 235, 2013, '2013-05-21', 4240, NULL, 1234, 0, 'tmobile', '901190736769', '', 'Telefoon mei 75% zakelijk', 20.47);
INSERT INTO boekregels VALUES (1234, 235, 2013, '2013-05-21', 2200, NULL, 0, 0, 'tmobile', '901190736769', '', 'Telefoon mei 75% zakelijk', 4.30);
INSERT INTO boekregels VALUES (1235, 236, 2013, '2013-06-19', 1600, NULL, 0, 0, 'tmobile', '901193006754', '', 'Telefoon jun 75% zakelijk', -24.77);
INSERT INTO boekregels VALUES (1236, 236, 2013, '2013-06-19', 4240, NULL, 1237, 0, 'tmobile', '901193006754', '', 'Telefoon jun 75% zakelijk', 20.47);
INSERT INTO boekregels VALUES (1237, 236, 2013, '2013-06-19', 2200, NULL, 0, 0, 'tmobile', '901193006754', '', 'Telefoon jun 75% zakelijk', 4.30);
INSERT INTO boekregels VALUES (1238, 237, 2013, '2013-06-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 1469.04);
INSERT INTO boekregels VALUES (1239, 237, 2013, '2013-06-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -584.89);
INSERT INTO boekregels VALUES (1240, 237, 2013, '2013-06-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -1980.19);
INSERT INTO boekregels VALUES (1241, 237, 2013, '2013-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -1469.04);
INSERT INTO boekregels VALUES (1242, 237, 2013, '2013-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.04);
INSERT INTO boekregels VALUES (1243, 237, 2013, '2013-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2210', 1980.19);
INSERT INTO boekregels VALUES (1244, 237, 2013, '2013-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 584.89);
INSERT INTO boekregels VALUES (1245, 237, 2013, '2013-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.08);
INSERT INTO boekregels VALUES (1246, 237, 2013, '2013-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.04);
INSERT INTO boekregels VALUES (1247, 237, 2013, '2013-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.08);
INSERT INTO boekregels VALUES (1248, 238, 2012, '2012-01-22', 1200, NULL, 0, 0, 'skihutu', '2012001', '', 'Muurschildering deel 1', 282.63);
INSERT INTO boekregels VALUES (1249, 238, 2012, '2012-01-22', 8070, NULL, 0, 0, 'skihutu', '2012001', '', 'Muurschildering deel 1', -237.50);
INSERT INTO boekregels VALUES (1250, 238, 2012, '2012-01-22', 2110, NULL, 0, 0, 'skihutu', '2012001', '', 'Muurschildering deel 1', -45.13);
INSERT INTO boekregels VALUES (1251, 239, 2012, '2012-02-29', 1200, NULL, 0, 0, 'ipse', '2012002', '', 'Schilderij Indonesie', 238.00);
INSERT INTO boekregels VALUES (1252, 239, 2012, '2012-02-29', 8065, NULL, 0, 0, 'ipse', '2012002', '', 'Schilderij Indonesie', -200.00);
INSERT INTO boekregels VALUES (1253, 239, 2012, '2012-02-29', 2110, NULL, 0, 0, 'ipse', '2012002', '', 'Schilderij Indonesie', -38.00);
INSERT INTO boekregels VALUES (1254, 240, 2012, '2012-02-28', 1200, NULL, 0, 0, 'skihutu', '2012003', '', 'Muurschildering deel 2 en 3', 719.95);
INSERT INTO boekregels VALUES (1255, 240, 2012, '2012-02-28', 8070, NULL, 0, 0, 'skihutu', '2012003', '', 'Muurschildering deel 2 en 3', -605.00);
INSERT INTO boekregels VALUES (1256, 240, 2012, '2012-02-28', 2110, NULL, 0, 0, 'skihutu', '2012003', '', 'Muurschildering deel 2 en 3', -114.95);
INSERT INTO boekregels VALUES (1275, 245, 2012, '2012-01-02', 1600, NULL, 0, 0, 'verweij', '2012014', '', 'Huur atelier Boskoop jan', -305.57);
INSERT INTO boekregels VALUES (1277, 245, 2012, '2012-01-02', 2200, NULL, 0, 0, 'verweij', '2012014', '', 'Huur atelier Boskoop jan', 48.79);
INSERT INTO boekregels VALUES (1276, 245, 2012, '2012-01-02', 4100, NULL, 1277, 0, 'verweij', '2012014', '', 'Huur atelier Boskoop jan', 256.78);
INSERT INTO boekregels VALUES (1278, 246, 2012, '2012-01-07', 1600, NULL, 0, 0, 'vodafone', '192034269', '', 'Mobiel internet jan', -47.25);
INSERT INTO boekregels VALUES (1280, 246, 2012, '2012-01-07', 2200, NULL, 0, 0, 'vodafone', '192034269', '', 'Mobiel internet jan', 7.54);
INSERT INTO boekregels VALUES (1279, 246, 2012, '2012-01-07', 4245, NULL, 1280, 0, 'vodafone', '192034269', '', 'Mobiel internet jan', 39.71);
INSERT INTO boekregels VALUES (1281, 247, 2012, '2012-01-18', 1600, NULL, 0, 0, 'tmobile', '901154931629', '', 'Telefoon jan', -35.47);
INSERT INTO boekregels VALUES (1283, 247, 2012, '2012-01-18', 2200, NULL, 0, 0, 'tmobile', '901154931629', '', 'Telefoon jan', 5.66);
INSERT INTO boekregels VALUES (1257, 241, 2012, '2012-06-30', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 2e kw.', 3274.50);
INSERT INTO boekregels VALUES (1261, 242, 2012, '2012-09-30', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 3e kw.', 1235.00);
INSERT INTO boekregels VALUES (1263, 242, 2012, '2012-09-30', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 3e kw.', -165.25);
INSERT INTO boekregels VALUES (1262, 242, 2012, '2012-09-30', 8060, NULL, 1263, 0, '', '', '', 'Cont. verkopen muursch. 3e kw.', -869.75);
INSERT INTO boekregels VALUES (1266, 243, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 4e kw.', 1750.00);
INSERT INTO boekregels VALUES (1272, 244, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Cont. verkopen 4e kwartaal aanvulling', 975.00);
INSERT INTO boekregels VALUES (1268, 243, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 4e kw.', -286.36);
INSERT INTO boekregels VALUES (1270, 243, 2012, '2012-12-31', 8065, NULL, 0, 0, '', '', '', 'Cont. verkopen schilderijen 4e kw.', -82.64);
INSERT INTO boekregels VALUES (1271, 243, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen schilderijen 4e kw.', -17.36);
INSERT INTO boekregels VALUES (1274, 244, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 4e kw. aanvulling', -143.18);
INSERT INTO boekregels VALUES (1273, 244, 2012, '2012-12-31', 8060, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 4e kw. aanvulling', -681.82);
INSERT INTO boekregels VALUES (1267, 243, 2012, '2012-12-31', 8060, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 4e kw.', -1363.64);
INSERT INTO boekregels VALUES (1282, 247, 2012, '2012-01-18', 4240, NULL, 1283, 0, 'tmobile', '901154931629', '', 'Telefoon jan', 29.81);
INSERT INTO boekregels VALUES (1284, 248, 2012, '2012-01-25', 1600, NULL, 0, 0, 'engelb', '194755', '', 'Spuitmaskers', -213.01);
INSERT INTO boekregels VALUES (1286, 248, 2012, '2012-01-25', 2200, NULL, 0, 0, 'engelb', '194755', '', 'Spuitmaskers', 34.01);
INSERT INTO boekregels VALUES (1287, 249, 2012, '2012-01-26', 1600, NULL, 0, 0, 'vanbeek', '747147', '', 'Verf en linnen', -94.45);
INSERT INTO boekregels VALUES (1289, 249, 2012, '2012-01-26', 2200, NULL, 0, 0, 'vanbeek', '747147', '', 'Verf en linnen', 15.08);
INSERT INTO boekregels VALUES (1290, 250, 2012, '2012-01-30', 1600, NULL, 0, 0, '123inkt', '2559604', '', 'Printerinkt', -53.95);
INSERT INTO boekregels VALUES (1292, 250, 2012, '2012-01-30', 2200, NULL, 0, 0, '123inkt', '2559604', '', 'Printerinkt', 8.61);
INSERT INTO boekregels VALUES (1291, 250, 2012, '2012-01-30', 4220, NULL, 1292, 0, '123inkt', '2559604', '', 'Printerinkt', 45.34);
INSERT INTO boekregels VALUES (1293, 251, 2012, '2012-01-15', 1600, NULL, 0, 0, 'kramer', '54622', '', 'Spuitmateriaal', -254.70);
INSERT INTO boekregels VALUES (1295, 251, 2012, '2012-01-15', 2200, NULL, 0, 0, 'kramer', '54622', '', 'Spuitmateriaal', 40.67);
INSERT INTO boekregels VALUES (1296, 252, 2012, '2012-02-02', 1600, NULL, 0, 0, 'verweij', '201229', '', 'Huur atelier Boskoop feb', -305.57);
INSERT INTO boekregels VALUES (1298, 252, 2012, '2012-02-02', 2200, NULL, 0, 0, 'verweij', '201229', '', 'Huur atelier Boskoop feb', 48.79);
INSERT INTO boekregels VALUES (1297, 252, 2012, '2012-02-02', 4100, NULL, 1298, 0, 'verweij', '201229', '', 'Huur atelier Boskoop feb', 256.78);
INSERT INTO boekregels VALUES (1299, 253, 2012, '2012-02-02', 1600, NULL, 0, 0, 'kvk', '251488299', '', 'Bijdrage KvK 2012', -41.03);
INSERT INTO boekregels VALUES (1300, 253, 2012, '2012-02-02', 4290, NULL, 0, 0, 'kvk', '251488299', '', 'Bijdrage KvK 2012', 41.03);
INSERT INTO boekregels VALUES (1301, 254, 2012, '2012-02-07', 1600, NULL, 0, 0, 'vodafone', '195064547', '', 'Mobiel internet feb', -50.00);
INSERT INTO boekregels VALUES (1303, 254, 2012, '2012-02-07', 2200, NULL, 0, 0, 'vodafone', '195064547', '', 'Mobiel internet feb', 7.98);
INSERT INTO boekregels VALUES (1222, 231, 2013, '2013-06-19', 4620, NULL, 0, 0, 'koops', '201319', '', 'Verkoop Opel Combi', 1250.00);
INSERT INTO boekregels VALUES (1302, 254, 2012, '2012-02-07', 4245, NULL, 1303, 0, 'vodafone', '195064547', '', 'Mobiel internet feb', 42.02);
INSERT INTO boekregels VALUES (1304, 255, 2012, '2012-02-11', 1600, NULL, 0, 0, 'kramer', '54794', '', 'Spuitmateriaal', -175.25);
INSERT INTO boekregels VALUES (1306, 255, 2012, '2012-02-11', 2200, NULL, 0, 0, 'kramer', '54794', '', 'Spuitmateriaal', 27.98);
INSERT INTO boekregels VALUES (1307, 256, 2012, '2012-02-13', 1600, NULL, 0, 0, 'marktplaats', '120200554', '', 'Marktplaats advertentie', -29.00);
INSERT INTO boekregels VALUES (1309, 256, 2012, '2012-02-13', 2200, NULL, 0, 0, 'marktplaats', '120200554', '', 'Marktplaats advertentie', 4.63);
INSERT INTO boekregels VALUES (1310, 257, 2012, '2012-02-20', 1600, NULL, 0, 0, 'tmobile', '901157136105', '', 'Telefoon feb', -37.62);
INSERT INTO boekregels VALUES (1312, 257, 2012, '2012-02-20', 2200, NULL, 0, 0, 'tmobile', '901157136105', '', 'Telefoon feb', 6.01);
INSERT INTO boekregels VALUES (1311, 257, 2012, '2012-02-20', 4240, NULL, 1312, 0, 'tmobile', '901157136105', '', 'Telefoon feb', 31.61);
INSERT INTO boekregels VALUES (1313, 258, 2012, '2012-02-23', 1600, NULL, 0, 0, 'vanbeek', '759771', '', 'Verf en linnen', -161.32);
INSERT INTO boekregels VALUES (1315, 258, 2012, '2012-02-23', 2200, NULL, 0, 0, 'vanbeek', '759771', '', 'Verf en linnen', 25.76);
INSERT INTO boekregels VALUES (1316, 259, 2012, '2012-02-23', 1600, NULL, 0, 0, 'vanbeek', '759773', '', 'Markers', -11.82);
INSERT INTO boekregels VALUES (1318, 259, 2012, '2012-02-23', 2200, NULL, 0, 0, 'vanbeek', '759773', '', 'Markers', 1.89);
INSERT INTO boekregels VALUES (1319, 260, 2012, '2012-02-28', 1600, NULL, 0, 0, 'mediamarkt', '40956138', '', 'TomTom', -119.99);
INSERT INTO boekregels VALUES (1321, 260, 2012, '2012-02-28', 2200, NULL, 0, 0, 'mediamarkt', '40956138', '', 'TomTom', 19.16);
INSERT INTO boekregels VALUES (1320, 260, 2012, '2012-02-28', 4210, NULL, 1321, 0, 'mediamarkt', '40956138', '', 'TomTom', 100.83);
INSERT INTO boekregels VALUES (1322, 261, 2012, '2012-03-05', 1600, NULL, 0, 0, 'verweij', '2012044', '', 'Huur atelier Boskoop mrt', -424.57);
INSERT INTO boekregels VALUES (1324, 261, 2012, '2012-03-05', 2200, NULL, 0, 0, 'verweij', '2012044', '', 'Huur atelier Boskoop mrt', 67.79);
INSERT INTO boekregels VALUES (1323, 261, 2012, '2012-03-05', 4100, NULL, 1324, 0, 'verweij', '2012044', '', 'Huur atelier Boskoop mrt', 356.78);
INSERT INTO boekregels VALUES (1325, 262, 2012, '2012-04-11', 1600, NULL, 0, 0, 'vandien', '14965804', '', 'Verzekering Opel 11-4/11-7', -140.49);
INSERT INTO boekregels VALUES (1327, 263, 2012, '2012-03-08', 1600, NULL, 0, 0, 'vodafone', '198321528', '', 'Mobiel internet mrt', -50.00);
INSERT INTO boekregels VALUES (1329, 263, 2012, '2012-03-08', 2200, NULL, 0, 0, 'vodafone', '198321528', '', 'Mobiel internet mrt', 7.98);
INSERT INTO boekregels VALUES (1328, 263, 2012, '2012-03-08', 4245, NULL, 1329, 0, 'vodafone', '198321528', '', 'Mobiel internet mrt', 42.02);
INSERT INTO boekregels VALUES (1330, 264, 2012, '2012-03-09', 1600, NULL, 0, 0, 'belasting', '69474993M2', '', 'Motorrijtuigenbelasting Opel 8-03/7-06', -71.00);
INSERT INTO boekregels VALUES (1332, 265, 2012, '2012-03-12', 1600, NULL, 0, 0, 'kramer', '54972', '', 'Spuitmateriaal', -292.65);
INSERT INTO boekregels VALUES (1334, 265, 2012, '2012-03-12', 2200, NULL, 0, 0, 'kramer', '54972', '', 'Spuitmateriaal', 46.73);
INSERT INTO boekregels VALUES (1338, 267, 2012, '2012-03-30', 1600, NULL, 0, 0, 'hofman', '2012098', '', 'Kleine beurt Opel', -171.51);
INSERT INTO boekregels VALUES (1340, 267, 2012, '2012-03-30', 2210, NULL, 0, 0, 'hofman', '2012098', '', 'Kleine beurt Opel', 27.38);
INSERT INTO boekregels VALUES (1341, 268, 2012, '2012-04-02', 1600, NULL, 0, 0, 'verweij', '2012059', '', 'Huur atelier Boskoop apr', -424.57);
INSERT INTO boekregels VALUES (1343, 268, 2012, '2012-04-02', 2200, NULL, 0, 0, 'verweij', '2012059', '', 'Huur atelier Boskoop apr', 67.79);
INSERT INTO boekregels VALUES (1342, 268, 2012, '2012-04-02', 4100, NULL, 1343, 0, 'verweij', '2012059', '', 'Huur atelier Boskoop apr', 356.78);
INSERT INTO boekregels VALUES (1344, 269, 2012, '2012-04-09', 1600, NULL, 0, 0, 'vodafone', '203060518', '', 'Mobiel internet apr', -50.00);
INSERT INTO boekregels VALUES (1346, 269, 2012, '2012-04-09', 2200, NULL, 0, 0, 'vodafone', '203060518', '', 'Mobiel internet apr', 7.98);
INSERT INTO boekregels VALUES (1345, 269, 2012, '2012-04-09', 4245, NULL, 1346, 0, 'vodafone', '203060518', '', 'Mobiel internet apr', 42.02);
INSERT INTO boekregels VALUES (1347, 270, 2012, '2012-04-13', 1600, NULL, 0, 0, 'belasting', '69414993F011641', '', 'Boete onjuiste opgaaf ICP 4e kw 2011', -123.00);
INSERT INTO boekregels VALUES (1348, 270, 2012, '2012-04-13', 4290, NULL, 0, 0, 'belasting', '69414993F011641', '', 'Boete onjuiste opgaaf ICP 4e kw 2011', 123.00);
INSERT INTO boekregels VALUES (1349, 271, 2012, '2012-05-01', 1600, NULL, 0, 0, 'verweij', '2012075', '', 'Huur atelier Boskoop mei', -424.57);
INSERT INTO boekregels VALUES (1351, 271, 2012, '2012-05-01', 2200, NULL, 0, 0, 'verweij', '2012075', '', 'Huur atelier Boskoop mei', 67.79);
INSERT INTO boekregels VALUES (1350, 271, 2012, '2012-05-01', 4100, NULL, 1351, 0, 'verweij', '2012075', '', 'Huur atelier Boskoop mei', 356.78);
INSERT INTO boekregels VALUES (1352, 272, 2012, '2012-05-02', 1600, NULL, 0, 0, 'a1', '201205139', '', 'Dopsleutel speciaal', -22.29);
INSERT INTO boekregels VALUES (1354, 272, 2012, '2012-05-02', 2200, NULL, 0, 0, 'a1', '201205139', '', 'Dopsleutel speciaal', 2.16);
INSERT INTO boekregels VALUES (1353, 272, 2012, '2012-05-02', 4220, NULL, 1354, 0, 'a1', '201205139', '', 'Dopsleutel speciaal', 20.13);
INSERT INTO boekregels VALUES (1355, 273, 2012, '2012-05-09', 1600, NULL, 0, 0, 'vodafone', '207277187', '', 'Mobiel internet mei', -50.00);
INSERT INTO boekregels VALUES (1357, 273, 2012, '2012-05-09', 2200, NULL, 0, 0, 'vodafone', '207277187', '', 'Mobiel internet mei', 7.98);
INSERT INTO boekregels VALUES (1356, 273, 2012, '2012-05-09', 4245, NULL, 1357, 0, 'vodafone', '207277187', '', 'Mobiel internet mei', 42.02);
INSERT INTO boekregels VALUES (1358, 274, 2012, '2012-05-12', 1600, NULL, 0, 0, 'vanbeek', '794001', '', 'Tekenmateriaal', -42.03);
INSERT INTO boekregels VALUES (1360, 274, 2012, '2012-05-12', 2200, NULL, 0, 0, 'vanbeek', '794001', '', 'Tekenmateriaal', 6.71);
INSERT INTO boekregels VALUES (1361, 275, 2012, '2012-05-25', 1600, NULL, 0, 0, 'mediamarkt', '4070672', '', 'Medion portable PC', -349.00);
INSERT INTO boekregels VALUES (1285, 248, 2012, '2012-01-25', 5010, NULL, 1286, 0, 'engelb', '194755', '', 'Spuitmaskers', 179.00);
INSERT INTO boekregels VALUES (1337, 266, 2012, '2012-03-31', 2110, NULL, 0, 0, '', '', '', 'Contante verkopen muursch. 1e kw.', -356.85);
INSERT INTO boekregels VALUES (1336, 266, 2012, '2012-03-31', 8060, NULL, 1337, 0, '', '', '', 'Contante verkopen muursch. 1e kw.', -1878.15);
INSERT INTO boekregels VALUES (1308, 256, 2012, '2012-02-13', 4310, NULL, 1309, 0, 'marktplaats', '120200554', '', 'Marktplaats advertentie', 24.37);
INSERT INTO boekregels VALUES (1326, 262, 2012, '2012-04-11', 4420, NULL, 0, 0, 'vandien', '14965804', '', 'Verzekering Opel 11-4/11-7', 140.49);
INSERT INTO boekregels VALUES (1331, 264, 2012, '2012-03-09', 4430, NULL, 0, 0, 'belasting', '69474993M2', '', 'Motorrijtuigenbelasting Opel 8-03/7-06', 71.00);
INSERT INTO boekregels VALUES (1339, 267, 2012, '2012-03-30', 4450, NULL, 1340, 0, 'hofman', '2012098', '', 'Kleine beurt Opel', 144.13);
INSERT INTO boekregels VALUES (1363, 275, 2012, '2012-05-25', 2200, NULL, 0, 0, 'mediamarkt', '4070672', '', 'Medion portable PC', 55.72);
INSERT INTO boekregels VALUES (1362, 275, 2012, '2012-05-25', 4210, NULL, 1363, 0, 'mediamarkt', '4070672', '', 'Medion portable PC', 293.28);
INSERT INTO boekregels VALUES (1364, 276, 2012, '2012-05-17', 1600, NULL, 0, 0, 'vodafone', '209655714', '', 'Creditnota gederfde schade', 5.00);
INSERT INTO boekregels VALUES (1366, 276, 2012, '2012-05-17', 2200, NULL, 0, 0, 'vodafone', '209655714', '', 'Creditnota gederfde schade', -0.80);
INSERT INTO boekregels VALUES (1365, 276, 2012, '2012-05-17', 4245, NULL, 1366, 0, 'vodafone', '209655714', '', 'Creditnota gederfde schade', -4.20);
INSERT INTO boekregels VALUES (1367, 277, 2012, '2012-04-20', 1600, NULL, 0, 0, 'kramer', '55182', '', 'Spuitmateriaal', -467.40);
INSERT INTO boekregels VALUES (1369, 277, 2012, '2012-04-20', 2200, NULL, 0, 0, 'kramer', '55182', '', 'Spuitmateriaal', 74.63);
INSERT INTO boekregels VALUES (1370, 278, 2012, '2012-05-14', 1600, NULL, 0, 0, 'kramer', '55395', '', 'Spuitmateriaal', -296.45);
INSERT INTO boekregels VALUES (1372, 278, 2012, '2012-05-14', 2200, NULL, 0, 0, 'kramer', '55395', '', 'Spuitmateriaal', 47.33);
INSERT INTO boekregels VALUES (1373, 279, 2012, '2012-05-18', 1600, NULL, 0, 0, 'vanbeek', '795985', '', 'Linnen', -23.76);
INSERT INTO boekregels VALUES (1375, 279, 2012, '2012-05-18', 2200, NULL, 0, 0, 'vanbeek', '795985', '', 'Linnen', 3.79);
INSERT INTO boekregels VALUES (1376, 280, 2012, '2012-05-25', 1600, NULL, 0, 0, 'kramer', '55469', '', 'Spuitmateriaal', -133.65);
INSERT INTO boekregels VALUES (1378, 280, 2012, '2012-05-25', 2200, NULL, 0, 0, 'kramer', '55469', '', 'Spuitmateriaal', 21.34);
INSERT INTO boekregels VALUES (1664, 347, 2012, '2012-04-06', 4220, NULL, 1665, 0, '', '', '', 'Elektrische niettang', 20.99);
INSERT INTO boekregels VALUES (1379, 281, 2012, '2012-06-01', 1600, NULL, 0, 0, 'verweij', '2012092', '', 'Huur atelier Boskoop jun', -424.57);
INSERT INTO boekregels VALUES (1381, 281, 2012, '2012-06-01', 2200, NULL, 0, 0, 'verweij', '2012092', '', 'Huur atelier Boskoop jun', 67.79);
INSERT INTO boekregels VALUES (1380, 281, 2012, '2012-06-01', 4100, NULL, 1381, 0, 'verweij', '2012092', '', 'Huur atelier Boskoop jun', 356.78);
INSERT INTO boekregels VALUES (1382, 282, 2012, '2012-06-04', 1600, NULL, 0, 0, 'vandien', '15265917', '', 'Verzekering Opel 11-7/11-10', -140.49);
INSERT INTO boekregels VALUES (1384, 283, 2012, '2012-06-11', 1600, NULL, 0, 0, 'belasting', '69414993m22', '', 'Wegenbelasting Opel 8-06/7-09', -71.00);
INSERT INTO boekregels VALUES (1386, 284, 2012, '2012-06-12', 1600, NULL, 0, 0, 'kramer', '55648', '', 'Spuitmateriaal', -193.90);
INSERT INTO boekregels VALUES (1388, 284, 2012, '2012-06-12', 2200, NULL, 0, 0, 'kramer', '55648', '', 'Spuitmateriaal', 30.96);
INSERT INTO boekregels VALUES (1389, 285, 2012, '2012-06-23', 1600, NULL, 0, 0, 'paradigit', '132032426', '', 'Memory stick 16G', -12.99);
INSERT INTO boekregels VALUES (1391, 285, 2012, '2012-06-23', 2200, NULL, 0, 0, 'paradigit', '132032426', '', 'Memory stick 16G', 2.07);
INSERT INTO boekregels VALUES (1390, 285, 2012, '2012-06-23', 4220, NULL, 1391, 0, 'paradigit', '132032426', '', 'Memory stick 16G', 10.92);
INSERT INTO boekregels VALUES (1392, 286, 2012, '2012-06-25', 1600, NULL, 0, 0, 'kramer', '55793', '', 'Spuitmateriaal', -165.55);
INSERT INTO boekregels VALUES (1394, 286, 2012, '2012-06-25', 2200, NULL, 0, 0, 'kramer', '55793', '', 'Spuitmateriaal', 26.43);
INSERT INTO boekregels VALUES (1395, 287, 2012, '2012-07-02', 1600, NULL, 0, 0, 'kramer', '55837', '', 'Spuitmateriaal', -161.75);
INSERT INTO boekregels VALUES (1397, 287, 2012, '2012-07-02', 2200, NULL, 0, 0, 'kramer', '55837', '', 'Spuitmateriaal', 25.83);
INSERT INTO boekregels VALUES (1398, 288, 2012, '2012-07-10', 1600, NULL, 0, 0, 'vodafone', '216408394', '', 'Mobiel internet jul', -32.26);
INSERT INTO boekregels VALUES (1400, 288, 2012, '2012-07-10', 2200, NULL, 0, 0, 'vodafone', '216408394', '', 'Mobiel internet jul', 5.15);
INSERT INTO boekregels VALUES (1399, 288, 2012, '2012-07-10', 4245, NULL, 1400, 0, 'vodafone', '216408394', '', 'Mobiel internet jul', 27.11);
INSERT INTO boekregels VALUES (1401, 289, 2012, '2012-07-11', 1600, NULL, 0, 0, 'vodafone', '212045361', '', 'Mobiel internet mei', -50.00);
INSERT INTO boekregels VALUES (1403, 289, 2012, '2012-07-11', 2200, NULL, 0, 0, 'vodafone', '212045361', '', 'Mobiel internet mei', 7.98);
INSERT INTO boekregels VALUES (1402, 289, 2012, '2012-07-11', 4245, NULL, 1403, 0, 'vodafone', '212045361', '', 'Mobiel internet mei', 42.02);
INSERT INTO boekregels VALUES (1404, 290, 2012, '2012-07-11', 1600, NULL, 0, 0, 'kramer', '55936', '', 'Spuitmateriaal', -243.90);
INSERT INTO boekregels VALUES (1406, 290, 2012, '2012-07-11', 2200, NULL, 0, 0, 'kramer', '55936', '', 'Spuitmateriaal', 38.94);
INSERT INTO boekregels VALUES (1407, 291, 2012, '2012-07-14', 1600, NULL, 0, 0, 'kramer', '55948', '', 'Spuitmateriaal', -510.45);
INSERT INTO boekregels VALUES (1409, 291, 2012, '2012-07-14', 2200, NULL, 0, 0, 'kramer', '55948', '', 'Spuitmateriaal', 81.50);
INSERT INTO boekregels VALUES (1410, 292, 2012, '2012-07-16', 1600, NULL, 0, 0, 'drukwerk', '2012381133', '', 'Brochures Koogerkunst', -23.95);
INSERT INTO boekregels VALUES (1412, 292, 2012, '2012-07-16', 2200, NULL, 0, 0, 'drukwerk', '2012381133', '', 'Brochures Koogerkunst', 3.82);
INSERT INTO boekregels VALUES (1413, 293, 2012, '2012-07-16', 1600, NULL, 0, 0, 'drukwerk', '2012380765', '', 'Vinylstickers Koogerkunst', -26.78);
INSERT INTO boekregels VALUES (1415, 293, 2012, '2012-07-16', 2200, NULL, 0, 0, 'drukwerk', '2012380765', '', 'Vinylstickers Koogerkunst', 4.28);
INSERT INTO boekregels VALUES (1416, 294, 2012, '2012-07-24', 1600, NULL, 0, 0, 'tmobile', '901168240121', '', 'Telefoon jul', -35.47);
INSERT INTO boekregels VALUES (1418, 294, 2012, '2012-07-24', 2200, NULL, 0, 0, 'tmobile', '901168240121', '', 'Telefoon jul', 5.66);
INSERT INTO boekregels VALUES (1417, 294, 2012, '2012-07-24', 4240, NULL, 1418, 0, 'tmobile', '901168240121', '', 'Telefoon jul', 29.81);
INSERT INTO boekregels VALUES (1419, 295, 2012, '2012-07-24', 1600, NULL, 0, 0, '123inkt', '2995179', '', 'Printerinkt', -24.45);
INSERT INTO boekregels VALUES (1421, 295, 2012, '2012-07-24', 2200, NULL, 0, 0, '123inkt', '2995179', '', 'Printerinkt', 3.90);
INSERT INTO boekregels VALUES (1420, 295, 2012, '2012-07-24', 4230, NULL, 1421, 0, '123inkt', '2995179', '', 'Printerinkt', 20.55);
INSERT INTO boekregels VALUES (1422, 296, 2012, '2012-07-27', 1600, NULL, 0, 0, 'acronis', '73619285233', '', 'Backup software', -49.95);
INSERT INTO boekregels VALUES (1424, 296, 2012, '2012-07-27', 2200, NULL, 0, 0, 'acronis', '73619285233', '', 'Backup software', 7.98);
INSERT INTO boekregels VALUES (1423, 296, 2012, '2012-07-27', 4230, NULL, 1424, 0, 'acronis', '73619285233', '', 'Backup software', 41.97);
INSERT INTO boekregels VALUES (1425, 297, 2012, '2012-07-28', 1600, NULL, 0, 0, 'acronis', '73619315387', '', 'Backup software update', -35.69);
INSERT INTO boekregels VALUES (1427, 297, 2012, '2012-07-28', 2200, NULL, 0, 0, 'acronis', '73619315387', '', 'Backup software update', 5.70);
INSERT INTO boekregels VALUES (1426, 297, 2012, '2012-07-28', 4230, NULL, 1427, 0, 'acronis', '73619315387', '', 'Backup software update', 29.99);
INSERT INTO boekregels VALUES (1428, 298, 2012, '2012-07-27', 1600, NULL, 0, 0, 'kroon', '9016364', '', 'Telmachinemateriaal en stempel', -47.70);
INSERT INTO boekregels VALUES (1430, 298, 2012, '2012-07-27', 2200, NULL, 0, 0, 'kroon', '9016364', '', 'Telmachinemateriaal en stempel', 7.62);
INSERT INTO boekregels VALUES (1429, 298, 2012, '2012-07-27', 4230, NULL, 1430, 0, 'kroon', '9016364', '', 'Telmachinemateriaal en stempel', 40.08);
INSERT INTO boekregels VALUES (1431, 299, 2012, '2012-08-01', 1600, NULL, 0, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop aug', -424.57);
INSERT INTO boekregels VALUES (1433, 299, 2012, '2012-08-01', 2200, NULL, 0, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop aug', 67.79);
INSERT INTO boekregels VALUES (1432, 299, 2012, '2012-08-01', 4100, NULL, 1433, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop aug', 356.78);
INSERT INTO boekregels VALUES (1434, 300, 2012, '2012-08-02', 1600, NULL, 0, 0, 'kramer', '56110', '', 'Spuitmateriaal', -428.95);
INSERT INTO boekregels VALUES (1436, 300, 2012, '2012-08-02', 2200, NULL, 0, 0, 'kramer', '56110', '', 'Spuitmateriaal', 68.49);
INSERT INTO boekregels VALUES (1437, 301, 2012, '2012-08-03', 1600, NULL, 0, 0, 'drukwerk', '2012389598', '', 'Boekjes glazen kunstwerken Vondelflats', -1127.85);
INSERT INTO boekregels VALUES (1439, 301, 2012, '2012-08-03', 2200, NULL, 0, 0, 'drukwerk', '2012389598', '', 'Boekjes glazen kunstwerken Vondelflats', 180.08);
INSERT INTO boekregels VALUES (1374, 279, 2012, '2012-05-18', 5010, NULL, 1375, 0, 'vanbeek', '795985', '', 'Linnen', 19.97);
INSERT INTO boekregels VALUES (1411, 292, 2012, '2012-07-16', 4310, NULL, 1412, 0, 'drukwerk', '2012381133', '', 'Brochures Koogerkunst', 20.13);
INSERT INTO boekregels VALUES (1414, 293, 2012, '2012-07-16', 4310, NULL, 1415, 0, 'drukwerk', '2012380765', '', 'Vinylstickers Koogerkunst', 22.50);
INSERT INTO boekregels VALUES (1383, 282, 2012, '2012-06-04', 4420, NULL, 0, 0, 'vandien', '15265917', '', 'Verzekering Opel 11-7/11-10', 140.49);
INSERT INTO boekregels VALUES (1385, 283, 2012, '2012-06-11', 4430, NULL, 0, 0, 'belasting', '69414993m22', '', 'Wegenbelasting Opel 8-06/7-09', 71.00);
INSERT INTO boekregels VALUES (1440, 302, 2012, '2012-08-07', 1600, NULL, 0, 0, 'hofman', '2012191', '', 'Onderhoud en banden Opel', -818.64);
INSERT INTO boekregels VALUES (1442, 302, 2012, '2012-08-07', 2210, NULL, 0, 0, 'hofman', '2012191', '', 'Onderhoud en banden Opel', 130.71);
INSERT INTO boekregels VALUES (1443, 303, 2012, '2012-08-07', 1600, NULL, 0, 0, 'surprise', '598716-372169', '', 'Werkschort', -24.40);
INSERT INTO boekregels VALUES (1445, 303, 2012, '2012-08-07', 2200, NULL, 0, 0, 'surprise', '598716-372169', '', 'Werkschort', 3.90);
INSERT INTO boekregels VALUES (1444, 303, 2012, '2012-08-07', 4220, NULL, 1445, 0, 'surprise', '598716-372169', '', 'Werkschort', 20.50);
INSERT INTO boekregels VALUES (1446, 304, 2012, '2012-08-08', 1600, NULL, 0, 0, 'vanbeek', '826289', '', 'Materiaal', -35.85);
INSERT INTO boekregels VALUES (1448, 304, 2012, '2012-08-08', 2200, NULL, 0, 0, 'vanbeek', '826289', '', 'Materiaal', 5.72);
INSERT INTO boekregels VALUES (1449, 305, 2012, '2012-08-08', 1600, NULL, 0, 0, 'canvas', '2012221925', '', 'Foto op canvas', -27.00);
INSERT INTO boekregels VALUES (1451, 305, 2012, '2012-08-08', 2200, NULL, 0, 0, 'canvas', '2012221925', '', 'Foto op canvas', 4.31);
INSERT INTO boekregels VALUES (1450, 305, 2012, '2012-08-08', 4220, NULL, 1451, 0, 'canvas', '2012221925', '', 'Foto op canvas', 22.69);
INSERT INTO boekregels VALUES (1452, 306, 2012, '2012-08-11', 1600, NULL, 0, 0, 'buitelaar', 'contant', '', 'Gereedschap', -29.90);
INSERT INTO boekregels VALUES (1454, 306, 2012, '2012-08-11', 2200, NULL, 0, 0, 'buitelaar', 'contant', '', 'Gereedschap', 4.77);
INSERT INTO boekregels VALUES (1453, 306, 2012, '2012-08-11', 4220, NULL, 1454, 0, 'buitelaar', 'contant', '', 'Gereedschap', 25.13);
INSERT INTO boekregels VALUES (1455, 307, 2012, '2012-08-20', 1600, NULL, 0, 0, 'tmobile', '901170478394', '', 'Telefoon aug', -35.47);
INSERT INTO boekregels VALUES (1457, 307, 2012, '2012-08-20', 2200, NULL, 0, 0, 'tmobile', '901170478394', '', 'Telefoon aug', 5.66);
INSERT INTO boekregels VALUES (1456, 307, 2012, '2012-08-20', 4240, NULL, 1457, 0, 'tmobile', '901170478394', '', 'Telefoon aug', 29.81);
INSERT INTO boekregels VALUES (1458, 308, 2012, '2012-08-22', 1600, NULL, 0, 0, 'kramer', '56235', '', 'Spuitmateriaal', -252.00);
INSERT INTO boekregels VALUES (1460, 308, 2012, '2012-08-22', 2200, NULL, 0, 0, 'kramer', '56235', '', 'Spuitmateriaal', 40.24);
INSERT INTO boekregels VALUES (1461, 309, 2012, '2012-09-02', 1600, NULL, 0, 0, 'verweij', '2012134', '', 'Huur atelier Boskoop sep', -424.57);
INSERT INTO boekregels VALUES (1463, 309, 2012, '2012-09-02', 2200, NULL, 0, 0, 'verweij', '2012134', '', 'Huur atelier Boskoop sep', 67.79);
INSERT INTO boekregels VALUES (1462, 309, 2012, '2012-09-02', 4100, NULL, 1463, 0, 'verweij', '2012134', '', 'Huur atelier Boskoop sep', 356.78);
INSERT INTO boekregels VALUES (1464, 310, 2012, '2012-09-04', 1600, NULL, 0, 0, 'kramer', '56333', '', 'Spuitmateriaal', -493.85);
INSERT INTO boekregels VALUES (1466, 310, 2012, '2012-09-04', 2200, NULL, 0, 0, 'kramer', '56333', '', 'Spuitmateriaal', 78.85);
INSERT INTO boekregels VALUES (1467, 311, 2012, '2012-08-26', 1600, NULL, 0, 0, 'denhaag', '100014', '', 'Parkeerbelasting Ged.Burgwal', -56.60);
INSERT INTO boekregels VALUES (1468, 311, 2012, '2012-08-26', 4270, NULL, 0, 0, 'denhaag', '100014', '', 'Parkeerbelasting Ged.Burgwal', 56.60);
INSERT INTO boekregels VALUES (1469, 312, 2012, '2012-09-07', 1600, NULL, 0, 0, '123inkt', '3094297', '', 'Printerinkt', -43.45);
INSERT INTO boekregels VALUES (1471, 312, 2012, '2012-09-07', 2200, NULL, 0, 0, '123inkt', '3094297', '', 'Printerinkt', 6.94);
INSERT INTO boekregels VALUES (1470, 312, 2012, '2012-09-07', 4220, NULL, 1471, 0, '123inkt', '3094297', '', 'Printerinkt', 36.51);
INSERT INTO boekregels VALUES (1472, 313, 2012, '2012-09-10', 1600, NULL, 0, 0, 'vandien', '15569339', '', 'Verzekering Opel 11-10/11-01-13', -140.49);
INSERT INTO boekregels VALUES (1474, 314, 2012, '2012-09-10', 1600, NULL, 0, 0, 'belasting', '69414993M25', '', 'Motorrijtuigenbelasting Opel 8-09/7-12', -71.00);
INSERT INTO boekregels VALUES (1476, 315, 2012, '2012-09-24', 1600, NULL, 0, 0, 'tmobile', '901172713938', '', 'Telefoon sep', -38.47);
INSERT INTO boekregels VALUES (1478, 315, 2012, '2012-09-24', 2200, NULL, 0, 0, 'tmobile', '901172713938', '', 'Telefoon sep', 6.14);
INSERT INTO boekregels VALUES (1477, 315, 2012, '2012-09-24', 4240, NULL, 1478, 0, 'tmobile', '901172713938', '', 'Telefoon sep', 32.33);
INSERT INTO boekregels VALUES (1479, 316, 2012, '2012-09-27', 1600, NULL, 0, 0, 'hofman', '2012271', '', 'Lampen', -44.01);
INSERT INTO boekregels VALUES (1481, 316, 2012, '2012-09-27', 2210, NULL, 0, 0, 'hofman', '2012271', '', 'Lampen', 3.46);
INSERT INTO boekregels VALUES (1482, 317, 2012, '2012-09-28', 1600, NULL, 0, 0, 'vanbeek', '847746', '', 'Linnen', -68.81);
INSERT INTO boekregels VALUES (1484, 317, 2012, '2012-09-28', 2200, NULL, 0, 0, 'vanbeek', '847746', '', 'Linnen', 10.99);
INSERT INTO boekregels VALUES (1485, 318, 2012, '2012-10-01', 1600, NULL, 0, 0, 'verweij', '2012147', '', 'Huur atelier Boskoop okt', -431.70);
INSERT INTO boekregels VALUES (1487, 318, 2012, '2012-10-01', 2200, NULL, 0, 0, 'verweij', '2012147', '', 'Huur atelier Boskoop okt', 74.92);
INSERT INTO boekregels VALUES (1486, 318, 2012, '2012-10-01', 4100, NULL, 1487, 0, 'verweij', '2012147', '', 'Huur atelier Boskoop okt', 356.78);
INSERT INTO boekregels VALUES (1488, 319, 2012, '2012-11-10', 1600, NULL, 0, 0, 'accu', '3424427', '', 'Accu startblok', -84.80);
INSERT INTO boekregels VALUES (1490, 319, 2012, '2012-11-10', 2200, NULL, 0, 0, 'accu', '3424427', '', 'Accu startblok', 14.72);
INSERT INTO boekregels VALUES (1489, 319, 2012, '2012-11-10', 4220, NULL, 1490, 0, 'accu', '3424427', '', 'Accu startblok', 70.08);
INSERT INTO boekregels VALUES (1491, 320, 2012, '2012-10-10', 1600, NULL, 0, 0, 'engelb', '222121', '', 'Veiligheidsmateriaal', -184.28);
INSERT INTO boekregels VALUES (1503, 324, 2012, '2012-10-26', 1600, NULL, 0, 0, 'drukwerk', '2012439962', '', 'Stickers auto', -64.06);
INSERT INTO boekregels VALUES (1492, 320, 2012, '2012-10-10', 4220, NULL, 1493, 0, 'engelb', '222121', '', 'Veiligheidsmateriaal', 152.30);
INSERT INTO boekregels VALUES (1493, 320, 2012, '2012-10-10', 2200, NULL, 0, 0, 'engelb', '222121', '', 'Veiligheidsmateriaal', 31.98);
INSERT INTO boekregels VALUES (1494, 321, 2012, '2012-10-15', 1600, NULL, 0, 0, 'kramer', '56610', '', 'Spuitmateriaal', -284.10);
INSERT INTO boekregels VALUES (1496, 321, 2012, '2012-10-15', 2200, NULL, 0, 0, 'kramer', '56610', '', 'Spuitmateriaal', 49.31);
INSERT INTO boekregels VALUES (1497, 322, 2012, '2012-10-25', 1600, NULL, 0, 0, 'conrad', '9549073130', '', 'Batterijen', -45.98);
INSERT INTO boekregels VALUES (1499, 322, 2012, '2012-10-25', 2200, NULL, 0, 0, 'conrad', '9549073130', '', 'Batterijen', 7.98);
INSERT INTO boekregels VALUES (1498, 322, 2012, '2012-10-25', 4230, NULL, 1499, 0, 'conrad', '9549073130', '', 'Batterijen', 38.00);
INSERT INTO boekregels VALUES (1500, 323, 2012, '2012-10-25', 1600, NULL, 0, 0, 'drukwerk', '2012438511', '', 'Flyers ', -47.93);
INSERT INTO boekregels VALUES (1502, 323, 2012, '2012-10-25', 2200, NULL, 0, 0, 'drukwerk', '2012438511', '', 'Flyers ', 8.32);
INSERT INTO boekregels VALUES (1505, 324, 2012, '2012-10-26', 2200, NULL, 0, 0, 'drukwerk', '2012439962', '', 'Stickers auto', 11.12);
INSERT INTO boekregels VALUES (1509, 326, 2012, '2012-11-01', 1600, NULL, 0, 0, 'kramer', '56680', '', 'Spuitmateriaal', -144.10);
INSERT INTO boekregels VALUES (1511, 326, 2012, '2012-11-01', 2200, NULL, 0, 0, 'kramer', '56680', '', 'Spuitmateriaal', 25.01);
INSERT INTO boekregels VALUES (1512, 327, 2012, '2012-11-05', 1600, NULL, 0, 0, 'vanbeek', '865253', '', 'Linnen en stiften', -157.93);
INSERT INTO boekregels VALUES (1514, 327, 2012, '2012-11-05', 2200, NULL, 0, 0, 'vanbeek', '865253', '', 'Linnen en stiften', 27.41);
INSERT INTO boekregels VALUES (1515, 328, 2012, '2012-11-06', 1600, NULL, 0, 0, 'kramer', '56751', '', 'Spuitmateriaal', -209.40);
INSERT INTO boekregels VALUES (1517, 328, 2012, '2012-11-06', 2200, NULL, 0, 0, 'kramer', '56751', '', 'Spuitmateriaal', 36.34);
INSERT INTO boekregels VALUES (1518, 329, 2012, '2012-11-21', 1600, NULL, 0, 0, 'marktplaats', '121126169', '', 'Marktplaats advertentiepakket', -139.95);
INSERT INTO boekregels VALUES (1520, 329, 2012, '2012-11-21', 2210, NULL, 0, 0, 'marktplaats', '121126169', '', 'Marktplaats advertentiepakket', 24.29);
INSERT INTO boekregels VALUES (1521, 330, 2012, '2012-11-22', 1600, NULL, 0, 0, 'kramer', '56854', '', 'Spuitmateriaal', -223.95);
INSERT INTO boekregels VALUES (1523, 330, 2012, '2012-11-22', 2200, NULL, 0, 0, 'kramer', '56854', '', 'Spuitmateriaal', 38.87);
INSERT INTO boekregels VALUES (1501, 323, 2012, '2012-10-25', 4310, NULL, 1502, 0, 'drukwerk', '2012438511', '', 'Flyers ', 39.61);
INSERT INTO boekregels VALUES (1504, 324, 2012, '2012-10-26', 4310, NULL, 1505, 0, 'drukwerk', '2012439962', '', 'Stickers auto', 52.94);
INSERT INTO boekregels VALUES (1473, 313, 2012, '2012-09-10', 4420, NULL, 0, 0, 'vandien', '15569339', '', 'Verzekering Opel 11-10/11-01-13', 140.49);
INSERT INTO boekregels VALUES (1475, 314, 2012, '2012-09-10', 4430, NULL, 0, 0, 'belasting', '69414993M25', '', 'Motorrijtuigenbelasting Opel 8-09/7-12', 71.00);
INSERT INTO boekregels VALUES (1519, 329, 2012, '2012-11-21', 4440, NULL, 1520, 0, 'marktplaats', '121126169', '', 'Marktplaats advertentiepakket', 115.66);
INSERT INTO boekregels VALUES (1441, 302, 2012, '2012-08-07', 4450, NULL, 1442, 0, 'hofman', '2012191', '', 'Onderhoud en banden Opel', 687.93);
INSERT INTO boekregels VALUES (1480, 316, 2012, '2012-09-27', 4450, NULL, 1481, 0, 'hofman', '2012271', '', 'Lampen', 40.55);
INSERT INTO boekregels VALUES (1526, 331, 2012, '2012-12-03', 2210, NULL, 0, 0, 'hofman', '2012325', '', 'APK, winterbanden, onderhoud Opel', 139.31);
INSERT INTO boekregels VALUES (1524, 331, 2012, '2012-12-03', 1600, NULL, 0, 0, 'hofman', '2012325', '', 'APK, winterbanden, onderhoud Opel', -802.68);
INSERT INTO boekregels VALUES (1527, 332, 2012, '2012-12-04', 1600, NULL, 0, 0, 'belasting', '69414993F012270', '', 'Naheffing 3ekw', -61.56);
INSERT INTO boekregels VALUES (1528, 332, 2012, '2012-12-04', 4290, NULL, 0, 0, 'belasting', '69414993F012270', '', 'Naheffing 3ekw', 61.56);
INSERT INTO boekregels VALUES (1529, 333, 2012, '2012-12-10', 1600, NULL, 0, 0, 'belasting', '69414993M27', '', 'Motorrijtuigenbelasting Opel 8-12/7-03-13', -71.00);
INSERT INTO boekregels VALUES (1531, 334, 2012, '2012-12-07', 1600, NULL, 0, 0, 'vanbeek', '882801', '', 'Markers', -44.25);
INSERT INTO boekregels VALUES (1533, 334, 2012, '2012-12-07', 2200, NULL, 0, 0, 'vanbeek', '882801', '', 'Markers', 7.68);
INSERT INTO boekregels VALUES (1532, 334, 2012, '2012-12-07', 4220, NULL, 1533, 0, 'vanbeek', '882801', '', 'Markers', 36.57);
INSERT INTO boekregels VALUES (1534, 335, 2012, '2012-12-11', 1600, NULL, 0, 0, 'kleding', '7181', '', 'T-shirts voor promotie', -105.03);
INSERT INTO boekregels VALUES (1536, 335, 2012, '2012-12-11', 2200, NULL, 0, 0, 'kleding', '7181', '', 'T-shirts voor promotie', 18.23);
INSERT INTO boekregels VALUES (1537, 336, 2012, '2012-12-12', 1600, NULL, 0, 0, 'vanbeek', '884982', '', 'Stiften retour', 12.93);
INSERT INTO boekregels VALUES (1539, 336, 2012, '2012-12-12', 2200, NULL, 0, 0, 'vanbeek', '884982', '', 'Stiften retour', -2.24);
INSERT INTO boekregels VALUES (1538, 336, 2012, '2012-12-12', 4220, NULL, 1539, 0, 'vanbeek', '884982', '', 'Stiften retour', -10.69);
INSERT INTO boekregels VALUES (1540, 337, 2012, '2012-12-14', 1600, NULL, 0, 0, 'vanbeek', '886388', '', 'Markers', -65.15);
INSERT INTO boekregels VALUES (1542, 337, 2012, '2012-12-14', 2200, NULL, 0, 0, 'vanbeek', '886388', '', 'Markers', 11.31);
INSERT INTO boekregels VALUES (1541, 337, 2012, '2012-12-14', 4220, NULL, 1542, 0, 'vanbeek', '886388', '', 'Markers', 53.84);
INSERT INTO boekregels VALUES (1543, 338, 2012, '2012-12-21', 1600, NULL, 0, 0, 'uc', '979', '', 'Spuitmateriaal', -101.76);
INSERT INTO boekregels VALUES (1545, 338, 2012, '2012-12-21', 2200, NULL, 0, 0, 'uc', '979', '', 'Spuitmateriaal', 17.66);
INSERT INTO boekregels VALUES (1546, 339, 2012, '2012-12-24', 1600, NULL, 0, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop jan 13', -441.64);
INSERT INTO boekregels VALUES (1548, 339, 2012, '2012-12-24', 2200, NULL, 0, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop jan 13', 76.65);
INSERT INTO boekregels VALUES (1547, 339, 2012, '2012-12-24', 4100, NULL, 1548, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop jan 13', 364.99);
INSERT INTO boekregels VALUES (1549, 340, 2012, '2012-10-18', 1600, NULL, 0, 0, 'tmobile', '901174959033', '', 'Telefoon okt', -49.97);
INSERT INTO boekregels VALUES (1551, 340, 2012, '2012-10-18', 2200, NULL, 0, 0, 'tmobile', '901174959033', '', 'Telefoon okt', 8.67);
INSERT INTO boekregels VALUES (1550, 340, 2012, '2012-10-18', 4240, NULL, 1551, 0, 'tmobile', '901174959033', '', 'Telefoon okt', 41.30);
INSERT INTO boekregels VALUES (1552, 341, 2012, '2012-11-21', 1600, NULL, 0, 0, 'tmobile', '901177212893', '', 'Telefoon nov', -39.42);
INSERT INTO boekregels VALUES (1554, 341, 2012, '2012-11-21', 2200, NULL, 0, 0, 'tmobile', '901177212893', '', 'Telefoon nov', 6.84);
INSERT INTO boekregels VALUES (1553, 341, 2012, '2012-11-21', 4240, NULL, 1554, 0, 'tmobile', '901177212893', '', 'Telefoon nov', 32.58);
INSERT INTO boekregels VALUES (1555, 342, 2012, '2012-12-19', 1600, NULL, 0, 0, 'tmobile', '901179454378', '', 'Telefoon dec', -36.07);
INSERT INTO boekregels VALUES (1557, 342, 2012, '2012-12-19', 2200, NULL, 0, 0, 'tmobile', '901179454378', '', 'Telefoon dec', 6.26);
INSERT INTO boekregels VALUES (1556, 342, 2012, '2012-12-19', 4240, NULL, 1557, 0, 'tmobile', '901179454378', '', 'Telefoon dec', 29.81);
INSERT INTO boekregels VALUES (1558, 343, 2012, '2012-11-01', 1600, NULL, 0, 0, 'verweij', '2012160', '', 'Huur atelier Boskoop nov', -431.70);
INSERT INTO boekregels VALUES (1560, 343, 2012, '2012-11-01', 2200, NULL, 0, 0, 'verweij', '2012160', '', 'Huur atelier Boskoop nov', 74.92);
INSERT INTO boekregels VALUES (1559, 343, 2012, '2012-11-01', 4100, NULL, 1560, 0, 'verweij', '2012160', '', 'Huur atelier Boskoop nov', 356.78);
INSERT INTO boekregels VALUES (1588, 344, 2012, '2012-01-23', 2200, NULL, 0, 0, '', '', '', 'Olie en gereedschap', 4.93);
INSERT INTO boekregels VALUES (1565, 344, 2012, '2012-01-15', 2200, NULL, 0, 0, '', '', '', 'Decoupeerzaag', 7.02);
INSERT INTO boekregels VALUES (1564, 344, 2012, '2012-01-15', 4220, NULL, 1565, 0, '', '', '', 'Decoupeerzaag', 36.96);
INSERT INTO boekregels VALUES (1561, 344, 2012, '2011-12-16', 4220, NULL, 1562, 0, '', '', '', 'Gereedschap', 33.60);
INSERT INTO boekregels VALUES (1562, 344, 2012, '2011-12-16', 2200, NULL, 0, 0, '', '', '', 'Gereedschap', 6.38);
INSERT INTO boekregels VALUES (1587, 344, 2012, '2012-01-23', 4220, NULL, 1588, 0, '', '', '', 'Olie en gereedschap', 25.92);
INSERT INTO boekregels VALUES (1566, 344, 2012, '2012-01-02', 2200, NULL, 0, 0, '', '', '', 'MDF en verfrol', 2.05);
INSERT INTO boekregels VALUES (1535, 335, 2012, '2012-12-11', 4310, NULL, 1536, 0, 'kleding', '7181', '', 'T-shirts voor promotie', 86.80);
INSERT INTO boekregels VALUES (1568, 344, 2012, '2012-01-08', 2200, NULL, 0, 0, '', '', '', 'Boormachine', 8.78);
INSERT INTO boekregels VALUES (1567, 344, 2012, '2012-01-08', 4220, NULL, 1568, 0, '', '', '', 'Boormachine', 46.22);
INSERT INTO boekregels VALUES (1570, 344, 2012, '2012-01-07', 2200, NULL, 0, 0, '', '', '', 'Gereedschap', 8.93);
INSERT INTO boekregels VALUES (1569, 344, 2012, '2012-01-07', 4220, NULL, 1570, 0, '', '', '', 'Gereedschap', 47.03);
INSERT INTO boekregels VALUES (1572, 344, 2012, '2012-01-07', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 12.15);
INSERT INTO boekregels VALUES (1571, 344, 2012, '2012-01-07', 4220, NULL, 1572, 0, '', '', '', 'Plaatmateriaal', 63.94);
INSERT INTO boekregels VALUES (1574, 344, 2012, '2012-01-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.04);
INSERT INTO boekregels VALUES (1530, 333, 2012, '2012-12-10', 4430, NULL, 0, 0, 'belasting', '69414993M27', '', 'Motorrijtuigenbelasting Opel 8-12/7-03-13', 71.00);
INSERT INTO boekregels VALUES (1576, 344, 2012, '2012-01-10', 2200, NULL, 0, 0, '', '', '', 'Latex', 5.66);
INSERT INTO boekregels VALUES (1573, 344, 2012, '2012-01-07', 4410, NULL, 1574, 0, '', '', '', 'Brandstof Opel', 47.57);
INSERT INTO boekregels VALUES (1578, 344, 2012, '2012-01-10', 2200, NULL, 0, 0, '', '', '', 'Hout atelierverbouwing', 5.02);
INSERT INTO boekregels VALUES (1577, 344, 2012, '2012-01-10', 4220, NULL, 1578, 0, '', '', '', 'Hout atelierverbouwing', 26.39);
INSERT INTO boekregels VALUES (1580, 344, 2012, '2012-01-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.78);
INSERT INTO boekregels VALUES (1525, 331, 2012, '2012-12-03', 4450, NULL, 1526, 0, 'hofman', '2012325', '', 'APK, winterbanden, onderhoud Opel', 663.37);
INSERT INTO boekregels VALUES (1582, 344, 2012, '2012-01-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.95);
INSERT INTO boekregels VALUES (1584, 344, 2012, '2012-01-21', 2200, NULL, 0, 0, '', '', '', 'Accu schroefmachine', 6.38);
INSERT INTO boekregels VALUES (1583, 344, 2012, '2012-01-21', 4220, NULL, 1584, 0, '', '', '', 'Accu schroefmachine', 33.61);
INSERT INTO boekregels VALUES (1586, 344, 2012, '2012-01-23', 2200, NULL, 0, 0, '', '', '', 'Koffie', 0.59);
INSERT INTO boekregels VALUES (1589, 344, 2012, '2012-01-24', 4290, NULL, 0, 0, '', '', '', 'Lunch', 16.00);
INSERT INTO boekregels VALUES (1591, 344, 2012, '2012-01-26', 2200, NULL, 0, 0, '', '', '', 'Envelopmappen', 0.40);
INSERT INTO boekregels VALUES (1590, 344, 2012, '2012-01-26', 4230, NULL, 1591, 0, '', '', '', 'Envelopmappen', 2.10);
INSERT INTO boekregels VALUES (1593, 344, 2012, '2012-01-27', 2200, NULL, 0, 0, '', '', '', 'Schildersmateriaal', 2.23);
INSERT INTO boekregels VALUES (1592, 344, 2012, '2012-01-27', 4220, NULL, 1593, 0, '', '', '', 'Schildersmateriaal', 11.74);
INSERT INTO boekregels VALUES (1595, 344, 2012, '2012-01-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.55);
INSERT INTO boekregels VALUES (1596, 344, 2012, '2012-01-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 01 2012', -660.53);
INSERT INTO boekregels VALUES (1598, 345, 2012, '2012-02-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.69);
INSERT INTO boekregels VALUES (1600, 345, 2012, '2012-02-01', 2200, NULL, 0, 0, '', '', '', 'Linnen', 5.20);
INSERT INTO boekregels VALUES (1579, 344, 2012, '2012-01-18', 4410, NULL, 1580, 0, '', '', '', 'Brandstof Opel', 35.71);
INSERT INTO boekregels VALUES (1602, 345, 2012, '2012-02-02', 2200, NULL, 0, 0, '', '', '', 'Linnen', 5.73);
INSERT INTO boekregels VALUES (1581, 344, 2012, '2012-01-21', 4410, NULL, 1582, 0, '', '', '', 'Brandstof Opel', 41.82);
INSERT INTO boekregels VALUES (1604, 345, 2012, '2012-02-04', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (1603, 345, 2012, '2012-02-04', 4230, NULL, 1604, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (1606, 345, 2012, '2012-02-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 2.38);
INSERT INTO boekregels VALUES (1608, 345, 2012, '2012-02-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.83);
INSERT INTO boekregels VALUES (1610, 345, 2012, '2012-02-09', 2200, NULL, 0, 0, '', '', '', 'Parkeren Utrecht', 1.60);
INSERT INTO boekregels VALUES (1609, 345, 2012, '2012-02-09', 4270, NULL, 1610, 0, '', '', '', 'Parkeren Utrecht', 8.40);
INSERT INTO boekregels VALUES (1544, 338, 2012, '2012-12-21', 5010, NULL, 1545, 0, 'uc', '979', '', 'Spuitmateriaal', 84.10);
INSERT INTO boekregels VALUES (1594, 344, 2012, '2012-01-28', 4410, NULL, 1595, 0, '', '', '', 'Brandstof Opel', 39.72);
INSERT INTO boekregels VALUES (1597, 345, 2012, '2012-02-01', 4410, NULL, 1598, 0, '', '', '', 'Brandstof Opel', 45.76);
INSERT INTO boekregels VALUES (1612, 345, 2012, '2012-02-11', 2200, NULL, 0, 0, '', '', '', 'Handschuurblok', 3.59);
INSERT INTO boekregels VALUES (1611, 345, 2012, '2012-02-11', 4220, NULL, 1612, 0, '', '', '', 'Handschuurblok', 18.87);
INSERT INTO boekregels VALUES (1614, 345, 2012, '2012-02-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.98);
INSERT INTO boekregels VALUES (1616, 345, 2012, '2012-02-13', 2200, NULL, 0, 0, '', '', '', 'Zweihaak', 3.66);
INSERT INTO boekregels VALUES (1615, 345, 2012, '2012-02-13', 4220, NULL, 1616, 0, '', '', '', 'Zweihaak', 19.28);
INSERT INTO boekregels VALUES (1618, 345, 2012, '2012-02-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.47);
INSERT INTO boekregels VALUES (1620, 345, 2012, '2012-02-16', 2200, NULL, 0, 0, '', '', '', 'Nat-droogzuiger', 7.98);
INSERT INTO boekregels VALUES (1619, 345, 2012, '2012-02-16', 4220, NULL, 1620, 0, '', '', '', 'Nat-droogzuiger', 42.01);
INSERT INTO boekregels VALUES (1622, 345, 2012, '2012-02-18', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (1621, 345, 2012, '2012-02-18', 4230, NULL, 1622, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (1624, 345, 2012, '2012-02-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.88);
INSERT INTO boekregels VALUES (1626, 345, 2012, '2012-02-28', 2200, NULL, 0, 0, '', '', '', 'Parkeren Rotterdam', 0.80);
INSERT INTO boekregels VALUES (1625, 345, 2012, '2012-02-28', 4270, NULL, 1626, 0, '', '', '', 'Parkeren Rotterdam', 4.20);
INSERT INTO boekregels VALUES (1628, 345, 2012, '2012-02-29', 2200, NULL, 0, 0, '', '', '', 'Parkeren Utrecht', 2.79);
INSERT INTO boekregels VALUES (1627, 345, 2012, '2012-02-29', 4270, NULL, 1628, 0, '', '', '', 'Parkeren Utrecht', 14.71);
INSERT INTO boekregels VALUES (1629, 345, 2012, '2012-02-29', 1060, NULL, 0, 0, '', '', '', 'Kasblad 02 2012', -479.08);
INSERT INTO boekregels VALUES (1631, 346, 2012, '2012-03-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.59);
INSERT INTO boekregels VALUES (1633, 346, 2012, '2012-03-02', 2200, NULL, 0, 0, '', '', '', 'Parkeren Utrecht', 0.80);
INSERT INTO boekregels VALUES (1632, 346, 2012, '2012-03-02', 4270, NULL, 1633, 0, '', '', '', 'Parkeren Utrecht', 4.20);
INSERT INTO boekregels VALUES (1634, 346, 2012, '2012-03-03', 4220, NULL, 0, 0, '', '', '', 'Plant atelier', 9.97);
INSERT INTO boekregels VALUES (1636, 346, 2012, '2012-03-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.10);
INSERT INTO boekregels VALUES (1638, 346, 2012, '2012-03-13', 2200, NULL, 0, 0, '', '', '', 'Brandstof hogedrukspuit', 2.71);
INSERT INTO boekregels VALUES (1637, 346, 2012, '2012-03-13', 4220, NULL, 1638, 0, '', '', '', 'Brandstof hogedrukspuit', 14.27);
INSERT INTO boekregels VALUES (1640, 346, 2012, '2012-03-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 3.29);
INSERT INTO boekregels VALUES (1642, 346, 2012, '2012-03-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.76);
INSERT INTO boekregels VALUES (1644, 346, 2012, '2012-03-16', 2200, NULL, 0, 0, '', '', '', 'Hoogwaardig papier', 1.21);
INSERT INTO boekregels VALUES (1643, 346, 2012, '2012-03-16', 4230, NULL, 1644, 0, '', '', '', 'Hoogwaardig papier', 6.36);
INSERT INTO boekregels VALUES (1646, 346, 2012, '2012-03-19', 2200, NULL, 0, 0, '', '', '', 'Tape en schroevendraaiers', 2.55);
INSERT INTO boekregels VALUES (1645, 346, 2012, '2012-03-19', 4220, NULL, 1646, 0, '', '', '', 'Tape en schroevendraaiers', 13.41);
INSERT INTO boekregels VALUES (1648, 346, 2012, '2012-03-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.00);
INSERT INTO boekregels VALUES (1649, 346, 2012, '2012-03-22', 4270, NULL, 0, 0, '', '', '', 'Lunch onderweg', 4.90);
INSERT INTO boekregels VALUES (1651, 346, 2012, '2012-03-22', 2200, NULL, 0, 0, '', '', '', 'Toltunnel Liefkenshoek', 0.96);
INSERT INTO boekregels VALUES (1650, 346, 2012, '2012-03-22', 4270, NULL, 1651, 0, '', '', '', 'Toltunnel Liefkenshoek', 5.04);
INSERT INTO boekregels VALUES (1652, 346, 2012, '2012-03-22', 4270, NULL, 0, 0, '', '', '', 'Parkeren Knokke', 2.00);
INSERT INTO boekregels VALUES (1654, 346, 2012, '2012-03-23', 2200, NULL, 0, 0, '', '', '', 'Verstekzaag', 12.77);
INSERT INTO boekregels VALUES (1653, 346, 2012, '2012-03-23', 4220, NULL, 1654, 0, '', '', '', 'Verstekzaag', 67.22);
INSERT INTO boekregels VALUES (1656, 346, 2012, '2012-03-24', 2200, NULL, 0, 0, '', '', '', 'Draaimomentsleutel', 4.07);
INSERT INTO boekregels VALUES (1655, 346, 2012, '2012-03-24', 4220, NULL, 1656, 0, '', '', '', 'Draaimomentsleutel', 21.40);
INSERT INTO boekregels VALUES (1658, 346, 2012, '2012-03-24', 2200, NULL, 0, 0, '', '', '', 'Hout atelierverbouwing', 13.81);
INSERT INTO boekregels VALUES (1657, 346, 2012, '2012-03-24', 4220, NULL, 1658, 0, '', '', '', 'Hout atelierverbouwing', 72.70);
INSERT INTO boekregels VALUES (1660, 346, 2012, '2012-03-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.42);
INSERT INTO boekregels VALUES (1662, 346, 2012, '2012-03-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.68);
INSERT INTO boekregels VALUES (1663, 346, 2012, '2012-03-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 03 2012', -597.62);
INSERT INTO boekregels VALUES (1665, 347, 2012, '2012-04-06', 2200, NULL, 0, 0, '', '', '', 'Elektrische niettang', 3.99);
INSERT INTO boekregels VALUES (1667, 347, 2012, '2012-04-26', 2200, NULL, 0, 0, '', '', '', 'Slot en sleutels', 2.54);
INSERT INTO boekregels VALUES (1666, 347, 2012, '2012-04-26', 4100, NULL, 1667, 0, '', '', '', 'Slot en sleutels', 13.36);
INSERT INTO boekregels VALUES (1669, 347, 2012, '2012-04-24', 2200, NULL, 0, 0, '', '', '', 'Schaaf en schuurpapier', 5.10);
INSERT INTO boekregels VALUES (1668, 347, 2012, '2012-04-24', 4220, NULL, 1669, 0, '', '', '', 'Schaaf en schuurpapier', 26.85);
INSERT INTO boekregels VALUES (1671, 347, 2012, '2012-04-26', 2200, NULL, 0, 0, '', '', '', 'Dect telefoon', 9.57);
INSERT INTO boekregels VALUES (1670, 347, 2012, '2012-04-26', 4230, NULL, 1671, 0, '', '', '', 'Dect telefoon', 50.38);
INSERT INTO boekregels VALUES (1673, 347, 2012, '2012-04-27', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.71);
INSERT INTO boekregels VALUES (1672, 347, 2012, '2012-04-27', 4290, NULL, 1673, 0, '', '', '', 'Lunch', 11.79);
INSERT INTO boekregels VALUES (1674, 347, 2012, '2012-04-29', 4270, NULL, 0, 0, '', '', '', 'Lunch onderweg', 14.59);
INSERT INTO boekregels VALUES (1676, 347, 2012, '2012-04-14', 2200, NULL, 0, 0, '', '', '', 'Nieten vr niettang', 1.40);
INSERT INTO boekregels VALUES (1675, 347, 2012, '2012-04-14', 4220, NULL, 1676, 0, '', '', '', 'Nieten vr niettang', 7.39);
INSERT INTO boekregels VALUES (1678, 347, 2012, '2012-04-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 6.66);
INSERT INTO boekregels VALUES (1680, 347, 2012, '2012-04-18', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (1679, 347, 2012, '2012-04-18', 4230, NULL, 1680, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (1682, 347, 2012, '2012-04-22', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.96);
INSERT INTO boekregels VALUES (1684, 347, 2012, '2012-04-23', 2200, NULL, 0, 0, '', '', '', 'Schuurpapier en zaagbladen', 4.78);
INSERT INTO boekregels VALUES (1683, 347, 2012, '2012-04-23', 4220, NULL, 1684, 0, '', '', '', 'Schuurpapier en zaagbladen', 25.15);
INSERT INTO boekregels VALUES (1686, 347, 2012, '2012-04-23', 2200, NULL, 0, 0, '', '', '', 'Borgveertang', 2.32);
INSERT INTO boekregels VALUES (1685, 347, 2012, '2012-04-23', 4220, NULL, 1686, 0, '', '', '', 'Borgveertang', 12.18);
INSERT INTO boekregels VALUES (1688, 347, 2012, '2012-04-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.92);
INSERT INTO boekregels VALUES (1691, 347, 2012, '2012-04-27', 2200, NULL, 0, 0, '', '', '', 'Verfroller en verlengstok', 4.46);
INSERT INTO boekregels VALUES (1690, 347, 2012, '2012-04-27', 4220, NULL, 1691, 0, '', '', '', 'Verfroller en verlengstok', 23.48);
INSERT INTO boekregels VALUES (1693, 347, 2012, '2012-04-27', 2200, NULL, 0, 0, '', '', '', 'Latex', 6.28);
INSERT INTO boekregels VALUES (1692, 347, 2012, '2012-04-27', 4220, NULL, 1693, 0, '', '', '', 'Latex', 33.07);
INSERT INTO boekregels VALUES (1695, 347, 2012, '2012-04-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel DE', 8.73);
INSERT INTO boekregels VALUES (1696, 347, 2012, '2012-04-29', 1060, NULL, 0, 0, '', '', '', 'Kasblad 04 2012', -543.50);
INSERT INTO boekregels VALUES (1698, 348, 2012, '2012-04-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.71);
INSERT INTO boekregels VALUES (1700, 348, 2012, '2012-05-03', 2200, NULL, 0, 0, '', '', '', 'Parkeren Rotterdam', 4.39);
INSERT INTO boekregels VALUES (1699, 348, 2012, '2012-05-03', 4270, NULL, 1700, 0, '', '', '', 'Parkeren Rotterdam', 23.11);
INSERT INTO boekregels VALUES (1702, 348, 2012, '2012-05-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.59);
INSERT INTO boekregels VALUES (1613, 345, 2012, '2012-02-12', 4410, NULL, 1614, 0, '', '', '', 'Brandstof Opel', 42.02);
INSERT INTO boekregels VALUES (1704, 348, 2012, '2012-05-09', 2200, NULL, 0, 0, '', '', '', 'Parkeren Rotterdam', 2.79);
INSERT INTO boekregels VALUES (1703, 348, 2012, '2012-05-09', 4270, NULL, 1704, 0, '', '', '', 'Parkeren Rotterdam', 14.71);
INSERT INTO boekregels VALUES (1706, 348, 2012, '2012-05-05', 2200, NULL, 0, 0, '', '', '', 'Verf e.d.', 5.29);
INSERT INTO boekregels VALUES (1709, 348, 2012, '2012-05-09', 4410, NULL, 1710, 0, '', '', '', 'Brandstof Opel', 50.77);
INSERT INTO boekregels VALUES (1708, 348, 2012, '2012-05-07', 2200, NULL, 0, 0, '', '', '', 'Verfrollers', 13.70);
INSERT INTO boekregels VALUES (1719, 348, 2012, '2012-05-19', 4410, NULL, 1720, 0, '', '', '', 'Brandstof Opel', 37.47);
INSERT INTO boekregels VALUES (1759, 349, 2012, '2012-06-06', 1060, NULL, 0, 0, '', '', '', 'Kasblad 06 2012', -416.36);
INSERT INTO boekregels VALUES (1710, 348, 2012, '2012-05-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.65);
INSERT INTO boekregels VALUES (1764, 350, 2012, '2012-07-06', 4440, NULL, 1765, 0, '', '', '', 'Poetsmachine auto', 37.38);
INSERT INTO boekregels VALUES (1711, 348, 2012, '2012-05-10', 4250, NULL, 0, 0, '', '', '', 'Aangetekend', 9.50);
INSERT INTO boekregels VALUES (1713, 348, 2012, '2012-05-12', 2200, NULL, 0, 0, '', '', '', 'Mandje', 2.07);
INSERT INTO boekregels VALUES (1712, 348, 2012, '2012-05-12', 4220, NULL, 1713, 0, '', '', '', 'Mandje', 10.92);
INSERT INTO boekregels VALUES (1714, 348, 2012, '2012-05-16', 4250, NULL, 0, 0, '', '', '', 'Pakje', 25.00);
INSERT INTO boekregels VALUES (1716, 348, 2012, '2012-05-15', 2200, NULL, 0, 0, '', '', '', 'Materiaal atelier', 21.65);
INSERT INTO boekregels VALUES (1715, 348, 2012, '2012-05-15', 4220, NULL, 1716, 0, '', '', '', 'Materiaal atelier', 113.92);
INSERT INTO boekregels VALUES (1718, 348, 2012, '2012-05-17', 2200, NULL, 0, 0, '', '', '', 'Materiaal atelier', 2.28);
INSERT INTO boekregels VALUES (1717, 348, 2012, '2012-05-17', 4220, NULL, 1718, 0, '', '', '', 'Materiaal atelier', 11.99);
INSERT INTO boekregels VALUES (1720, 348, 2012, '2012-05-19', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.12);
INSERT INTO boekregels VALUES (1722, 348, 2012, '2012-05-21', 2200, NULL, 0, 0, '', '', '', 'Materiaal atelier', 4.45);
INSERT INTO boekregels VALUES (1721, 348, 2012, '2012-05-21', 4220, NULL, 1722, 0, '', '', '', 'Materiaal atelier', 23.43);
INSERT INTO boekregels VALUES (1723, 348, 2012, '2012-05-21', 4250, NULL, 0, 0, '', '', '', 'Pakket', 8.05);
INSERT INTO boekregels VALUES (1724, 348, 2012, '2012-05-24', 4250, NULL, 0, 0, '', '', '', 'Aangetekend', 9.50);
INSERT INTO boekregels VALUES (1726, 348, 2012, '2012-05-25', 2200, NULL, 0, 0, '', '', '', 'Telefoon reserve', 5.11);
INSERT INTO boekregels VALUES (1725, 348, 2012, '2012-05-25', 4230, NULL, 1726, 0, '', '', '', 'Telefoon reserve', 26.87);
INSERT INTO boekregels VALUES (1728, 348, 2012, '2012-05-26', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (1727, 348, 2012, '2012-05-26', 4240, NULL, 1728, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (1730, 348, 2012, '2012-05-28', 2200, NULL, 0, 0, '', '', '', 'Afdektape en folie', 0.91);
INSERT INTO boekregels VALUES (1731, 348, 2012, '2012-05-28', 4410, NULL, 1732, 0, '', '', '', 'Brandstof Opel', 44.03);
INSERT INTO boekregels VALUES (1732, 348, 2012, '2012-05-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.37);
INSERT INTO boekregels VALUES (1734, 348, 2012, '2012-05-31', 2200, NULL, 0, 0, '', '', '', 'Soldeerbout', 1.28);
INSERT INTO boekregels VALUES (1733, 348, 2012, '2012-05-31', 4220, NULL, 1734, 0, '', '', '', 'Soldeerbout', 6.71);
INSERT INTO boekregels VALUES (1736, 348, 2012, '2012-05-31', 2200, NULL, 0, 0, '', '', '', 'Cirkelzaag', 17.56);
INSERT INTO boekregels VALUES (1735, 348, 2012, '2012-05-31', 4220, NULL, 1736, 0, '', '', '', 'Cirkelzaag', 92.43);
INSERT INTO boekregels VALUES (1737, 348, 2012, '2012-05-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 05 2012', -840.37);
INSERT INTO boekregels VALUES (1739, 349, 2012, '2012-06-02', 2200, NULL, 0, 0, '', '', '', 'Folie', 0.95);
INSERT INTO boekregels VALUES (1738, 349, 2012, '2012-06-02', 4220, NULL, 1739, 0, '', '', '', 'Folie', 5.00);
INSERT INTO boekregels VALUES (1741, 349, 2012, '2012-06-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 5.62);
INSERT INTO boekregels VALUES (1743, 349, 2012, '2012-06-03', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.11);
INSERT INTO boekregels VALUES (1742, 349, 2012, '2012-06-03', 4290, NULL, 1743, 0, '', '', '', 'Versnaperingen', 1.89);
INSERT INTO boekregels VALUES (1745, 349, 2012, '2012-06-08', 2200, NULL, 0, 0, '', '', '', 'Schuurmateriaal', 6.54);
INSERT INTO boekregels VALUES (1744, 349, 2012, '2012-06-08', 4220, NULL, 1745, 0, '', '', '', 'Schuurmateriaal', 34.45);
INSERT INTO boekregels VALUES (1747, 349, 2012, '2012-06-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.29);
INSERT INTO boekregels VALUES (1761, 350, 2012, '2012-07-02', 2200, NULL, 0, 0, '', '', '', 'Schuifmaat', 5.74);
INSERT INTO boekregels VALUES (1749, 349, 2012, '2012-06-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 5.47);
INSERT INTO boekregels VALUES (1760, 350, 2012, '2012-07-02', 4220, NULL, 1761, 0, '', '', '', 'Schuifmaat', 30.20);
INSERT INTO boekregels VALUES (1740, 349, 2012, '2012-06-03', 4410, NULL, 1741, 0, '', '', '', 'Brandstof Opel', 29.61);
INSERT INTO boekregels VALUES (1752, 349, 2012, '2012-06-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.03);
INSERT INTO boekregels VALUES (1754, 349, 2012, '2012-06-23', 2200, NULL, 0, 0, '', '', '', 'Gereedschap en matten', 4.30);
INSERT INTO boekregels VALUES (1753, 349, 2012, '2012-06-23', 4220, NULL, 1754, 0, '', '', '', 'Gereedschap en matten', 22.62);
INSERT INTO boekregels VALUES (1756, 349, 2012, '2012-06-30', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.50);
INSERT INTO boekregels VALUES (1758, 349, 2012, '2012-06-06', 2200, NULL, 0, 0, '', '', '', 'Verf en materiaal verb. atelier', 12.23);
INSERT INTO boekregels VALUES (1757, 349, 2012, '2012-06-06', 4220, NULL, 1758, 0, '', '', '', 'Verf en materiaal verb. atelier', 64.37);
INSERT INTO boekregels VALUES (1763, 350, 2012, '2012-07-02', 2200, NULL, 0, 0, '', '', '', 'Schroeven etc', 2.66);
INSERT INTO boekregels VALUES (1762, 350, 2012, '2012-07-02', 4220, NULL, 1763, 0, '', '', '', 'Schroeven etc', 14.03);
INSERT INTO boekregels VALUES (1765, 350, 2012, '2012-07-06', 2210, NULL, 0, 0, '', '', '', 'Poetsmachine auto', 7.10);
INSERT INTO boekregels VALUES (1767, 350, 2012, '2012-07-07', 2200, NULL, 0, 0, '', '', '', 'Standaard slijper', 3.19);
INSERT INTO boekregels VALUES (1766, 350, 2012, '2012-07-07', 4220, NULL, 1767, 0, '', '', '', 'Standaard slijper', 16.80);
INSERT INTO boekregels VALUES (1769, 350, 2012, '2012-07-11', 2200, NULL, 0, 0, '', '', '', 'Klem lijsten', 18.04);
INSERT INTO boekregels VALUES (1768, 350, 2012, '2012-07-11', 4220, NULL, 1769, 0, '', '', '', 'Klem lijsten', 94.94);
INSERT INTO boekregels VALUES (1771, 350, 2012, '2012-07-13', 2200, NULL, 0, 0, '', '', '', 'Museumbezoek', 1.08);
INSERT INTO boekregels VALUES (1770, 350, 2012, '2012-07-13', 4290, NULL, 1771, 0, '', '', '', 'Museumbezoek', 17.92);
INSERT INTO boekregels VALUES (1772, 350, 2012, '2012-07-13', 4290, NULL, 0, 0, '', '', '', 'Museumbezoek versn.', 7.25);
INSERT INTO boekregels VALUES (1774, 350, 2012, '2012-07-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.65);
INSERT INTO boekregels VALUES (1776, 350, 2012, '2012-07-14', 2200, NULL, 0, 0, '', '', '', 'Afdektape en folie', 4.00);
INSERT INTO boekregels VALUES (1775, 350, 2012, '2012-07-14', 4220, NULL, 1776, 0, '', '', '', 'Afdektape en folie', 21.06);
INSERT INTO boekregels VALUES (1778, 350, 2012, '2012-07-25', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 16.75);
INSERT INTO boekregels VALUES (1746, 349, 2012, '2012-06-07', 4410, NULL, 1747, 0, '', '', '', 'Brandstof Opel', 43.66);
INSERT INTO boekregels VALUES (1780, 350, 2012, '2012-07-25', 2200, NULL, 0, 0, '', '', '', 'Diner relaties', 9.25);
INSERT INTO boekregels VALUES (1779, 350, 2012, '2012-07-25', 4290, NULL, 1780, 0, '', '', '', 'Diner relaties', 116.65);
INSERT INTO boekregels VALUES (1782, 350, 2012, '2012-07-26', 2200, NULL, 0, 0, '', '', '', 'Panelen', 2.57);
INSERT INTO boekregels VALUES (1748, 349, 2012, '2012-06-12', 4410, NULL, 1749, 0, '', '', '', 'Brandstof Opel', 28.80);
INSERT INTO boekregels VALUES (1784, 350, 2012, '2012-07-27', 2200, NULL, 0, 0, '', '', '', 'Panelen', 7.98);
INSERT INTO boekregels VALUES (1751, 349, 2012, '2012-06-21', 4410, NULL, 1752, 0, '', '', '', 'Brandstof Opel', 42.24);
INSERT INTO boekregels VALUES (1786, 350, 2012, '2012-07-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 7.95);
INSERT INTO boekregels VALUES (1788, 350, 2012, '2012-07-28', 2200, NULL, 0, 0, '', '', '', 'Kluisje', 2.61);
INSERT INTO boekregels VALUES (1787, 350, 2012, '2012-07-28', 4230, NULL, 1788, 0, '', '', '', 'Kluisje', 13.76);
INSERT INTO boekregels VALUES (1789, 350, 2012, '2012-07-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 07 2012', -704.91);
INSERT INTO boekregels VALUES (1791, 351, 2012, '2012-08-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.75);
INSERT INTO boekregels VALUES (1793, 351, 2012, '2012-08-08', 2200, NULL, 0, 0, '', '', '', 'Transportwieltjes', 1.12);
INSERT INTO boekregels VALUES (1792, 351, 2012, '2012-08-08', 4220, NULL, 1793, 0, '', '', '', 'Transportwieltjes', 5.87);
INSERT INTO boekregels VALUES (1795, 351, 2012, '2012-08-09', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 2.87);
INSERT INTO boekregels VALUES (1755, 349, 2012, '2012-06-30', 4410, NULL, 1756, 0, '', '', '', 'Brandstof Opel', 44.71);
INSERT INTO boekregels VALUES (1797, 351, 2012, '2012-08-09', 2200, NULL, 0, 0, '', '', '', 'Transportwieltjes', 3.35);
INSERT INTO boekregels VALUES (1705, 348, 2012, '2012-05-05', 5010, NULL, 1706, 0, '', '', '', 'Verf e.d.', 27.87);
INSERT INTO boekregels VALUES (1796, 351, 2012, '2012-08-09', 4220, NULL, 1797, 0, '', '', '', 'Transportwieltjes', 17.62);
INSERT INTO boekregels VALUES (1799, 351, 2012, '2012-08-11', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (1798, 351, 2012, '2012-08-11', 4230, NULL, 1799, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (1801, 351, 2012, '2012-08-11', 2200, NULL, 0, 0, '', '', '', 'Bouten en ringen assorti', 2.39);
INSERT INTO boekregels VALUES (1800, 351, 2012, '2012-08-11', 4220, NULL, 1801, 0, '', '', '', 'Bouten en ringen assorti', 12.55);
INSERT INTO boekregels VALUES (1803, 351, 2012, '2012-08-11', 2200, NULL, 0, 0, '', '', '', 'Kolomboor', 15.16);
INSERT INTO boekregels VALUES (1802, 351, 2012, '2012-08-11', 4220, NULL, 1803, 0, '', '', '', 'Kolomboor', 79.82);
INSERT INTO boekregels VALUES (1805, 351, 2012, '2012-08-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.75);
INSERT INTO boekregels VALUES (1827, 352, 2012, '2012-09-15', 4440, NULL, 1828, 0, '', '', '', 'Potkrik', 10.08);
INSERT INTO boekregels VALUES (1807, 351, 2012, '2012-08-13', 2200, NULL, 0, 0, '', '', '', 'Sorteerboxen', 1.60);
INSERT INTO boekregels VALUES (1806, 351, 2012, '2012-08-13', 4220, NULL, 1807, 0, '', '', '', 'Sorteerboxen', 8.39);
INSERT INTO boekregels VALUES (1809, 351, 2012, '2012-08-17', 2200, NULL, 0, 0, '', '', '', 'Boren en kabelbinders', 4.46);
INSERT INTO boekregels VALUES (1808, 351, 2012, '2012-08-17', 4220, NULL, 1809, 0, '', '', '', 'Boren en kabelbinders', 23.50);
INSERT INTO boekregels VALUES (1811, 351, 2012, '2012-08-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.75);
INSERT INTO boekregels VALUES (1813, 351, 2012, '2012-08-24', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 1.05);
INSERT INTO boekregels VALUES (1887, 355, 2012, '2012-12-07', 4310, NULL, 1888, 0, '', '', '', 'Rompers voor bedrukking', 29.75);
INSERT INTO boekregels VALUES (1815, 351, 2012, '2012-08-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.53);
INSERT INTO boekregels VALUES (1817, 351, 2012, '2012-08-31', 2200, NULL, 0, 0, '', '', '', 'Schoonmaak', 2.07);
INSERT INTO boekregels VALUES (1816, 351, 2012, '2012-08-31', 4220, NULL, 1817, 0, '', '', '', 'Schoonmaak', 10.92);
INSERT INTO boekregels VALUES (1818, 351, 2012, '2012-08-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 08 2012', -430.93);
INSERT INTO boekregels VALUES (1804, 351, 2012, '2012-08-12', 4410, NULL, 1805, 0, '', '', '', 'Brandstof Opel', 24.99);
INSERT INTO boekregels VALUES (1820, 352, 2012, '2012-09-04', 2200, NULL, 0, 0, '', '', '', 'Panelen', 5.15);
INSERT INTO boekregels VALUES (1822, 352, 2012, '2012-09-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.67);
INSERT INTO boekregels VALUES (1824, 352, 2012, '2012-09-06', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.14);
INSERT INTO boekregels VALUES (1823, 352, 2012, '2012-09-06', 4270, NULL, 1824, 0, '', '', '', 'Versnaperingen', 2.36);
INSERT INTO boekregels VALUES (1826, 352, 2012, '2012-09-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 8.28);
INSERT INTO boekregels VALUES (1828, 352, 2012, '2012-09-15', 2210, NULL, 0, 0, '', '', '', 'Potkrik', 1.91);
INSERT INTO boekregels VALUES (1830, 352, 2012, '2012-09-18', 2200, NULL, 0, 0, '', '', '', 'Lunch onderweg', 0.89);
INSERT INTO boekregels VALUES (1829, 352, 2012, '2012-09-18', 4270, NULL, 1830, 0, '', '', '', 'Lunch onderweg', 14.83);
INSERT INTO boekregels VALUES (1832, 352, 2012, '2012-09-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.24);
INSERT INTO boekregels VALUES (1834, 352, 2012, '2012-09-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.65);
INSERT INTO boekregels VALUES (1836, 352, 2012, '2012-09-25', 2200, NULL, 0, 0, '', '', '', 'Afdektape en folie', 1.72);
INSERT INTO boekregels VALUES (1835, 352, 2012, '2012-09-25', 4220, NULL, 1836, 0, '', '', '', 'Afdektape en folie', 9.07);
INSERT INTO boekregels VALUES (1837, 352, 2012, '2012-09-25', 1060, NULL, 0, 0, '', '', '', 'Kasblad 09 2012', -316.45);
INSERT INTO boekregels VALUES (1839, 353, 2012, '2012-10-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.63);
INSERT INTO boekregels VALUES (1841, 353, 2012, '2012-10-08', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 2.49);
INSERT INTO boekregels VALUES (1843, 353, 2012, '2012-10-08', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.10);
INSERT INTO boekregels VALUES (1842, 353, 2012, '2012-10-08', 4270, NULL, 1843, 0, '', '', '', 'Versnaperingen', 1.69);
INSERT INTO boekregels VALUES (1845, 353, 2012, '2012-10-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 11.27);
INSERT INTO boekregels VALUES (1847, 353, 2012, '2012-10-16', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 2.99);
INSERT INTO boekregels VALUES (1810, 351, 2012, '2012-08-18', 4410, NULL, 1811, 0, '', '', '', 'Brandstof Opel', 46.05);
INSERT INTO boekregels VALUES (1849, 353, 2012, '2012-10-20', 2200, NULL, 0, 0, '', '', '', 'Latex', 3.50);
INSERT INTO boekregels VALUES (1814, 351, 2012, '2012-08-25', 4410, NULL, 1815, 0, '', '', '', 'Brandstof Opel', 55.40);
INSERT INTO boekregels VALUES (1851, 353, 2012, '2012-10-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.53);
INSERT INTO boekregels VALUES (1853, 353, 2012, '2012-10-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.19);
INSERT INTO boekregels VALUES (1855, 353, 2012, '2012-10-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.19);
INSERT INTO boekregels VALUES (1856, 353, 2012, '2012-10-29', 1060, NULL, 0, 0, '', '', '', 'Kasblad 10 2012', -346.31);
INSERT INTO boekregels VALUES (1858, 354, 2012, '2012-11-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 5.83);
INSERT INTO boekregels VALUES (1860, 354, 2012, '2012-11-08', 2200, NULL, 0, 0, '', '', '', 'Trap en schragen', 13.13);
INSERT INTO boekregels VALUES (1859, 354, 2012, '2012-11-08', 4220, NULL, 1860, 0, '', '', '', 'Trap en schragen', 62.53);
INSERT INTO boekregels VALUES (1862, 354, 2012, '2012-11-08', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 4.34);
INSERT INTO boekregels VALUES (1864, 354, 2012, '2012-11-08', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.12);
INSERT INTO boekregels VALUES (1863, 354, 2012, '2012-11-08', 4270, NULL, 1864, 0, '', '', '', 'Versnaperingen', 2.07);
INSERT INTO boekregels VALUES (1866, 354, 2012, '2012-11-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 5.33);
INSERT INTO boekregels VALUES (1868, 354, 2012, '2012-11-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.14);
INSERT INTO boekregels VALUES (1872, 354, 2012, '2012-11-20', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 4.95);
INSERT INTO boekregels VALUES (1869, 354, 2012, '2012-11-13', 4270, NULL, 1870, 0, '', '', '', 'Versnaperingen onderweg', 3.72);
INSERT INTO boekregels VALUES (1854, 353, 2012, '2012-10-29', 4410, NULL, 1855, 0, '', '', '', 'Brandstof Opel', 43.74);
INSERT INTO boekregels VALUES (1870, 354, 2012, '2012-11-13', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen onderweg', 0.23);
INSERT INTO boekregels VALUES (1874, 354, 2012, '2012-11-20', 2200, NULL, 0, 0, '', '', '', 'Div materiaal', 1.31);
INSERT INTO boekregels VALUES (1873, 354, 2012, '2012-11-20', 4220, NULL, 1874, 0, '', '', '', 'Div materiaal', 6.26);
INSERT INTO boekregels VALUES (1876, 354, 2012, '2012-11-22', 2200, NULL, 0, 0, '', '', '', 'Stofmaskers', 2.84);
INSERT INTO boekregels VALUES (1875, 354, 2012, '2012-11-22', 4220, NULL, 1876, 0, '', '', '', 'Stofmaskers', 13.52);
INSERT INTO boekregels VALUES (1878, 354, 2012, '2012-11-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.73);
INSERT INTO boekregels VALUES (1880, 354, 2012, '2012-11-30', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 1.90);
INSERT INTO boekregels VALUES (1821, 352, 2012, '2012-09-06', 4410, NULL, 1822, 0, '', '', '', 'Brandstof Opel', 56.13);
INSERT INTO boekregels VALUES (1882, 354, 2012, '2012-11-30', 2200, NULL, 0, 0, '', '', '', 'Spuitmateriaal', 2.52);
INSERT INTO boekregels VALUES (1825, 352, 2012, '2012-09-15', 4410, NULL, 1826, 0, '', '', '', 'Brandstof Opel', 43.55);
INSERT INTO boekregels VALUES (1883, 354, 2012, '2012-11-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 11 2012', -363.48);
INSERT INTO boekregels VALUES (1885, 355, 2012, '2012-12-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 9.41);
INSERT INTO boekregels VALUES (1886, 355, 2012, '2012-12-04', 4250, NULL, 0, 0, '', '', '', 'Postzegels', 10.00);
INSERT INTO boekregels VALUES (1888, 355, 2012, '2012-12-07', 2200, NULL, 0, 0, '', '', '', 'Rompers voor bedrukking', 6.25);
INSERT INTO boekregels VALUES (1831, 352, 2012, '2012-09-20', 4410, NULL, 1832, 0, '', '', '', 'Brandstof Opel', 48.61);
INSERT INTO boekregels VALUES (1890, 355, 2012, '2012-12-11', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 11.19);
INSERT INTO boekregels VALUES (1812, 351, 2012, '2012-08-24', 5010, NULL, 1813, 0, '', '', '', 'Spuitmateriaal', 5.55);
INSERT INTO boekregels VALUES (1891, 355, 2012, '2012-12-13', 4230, NULL, 0, 0, '', '', '', 'Postweegschaal', 6.75);
INSERT INTO boekregels VALUES (1893, 355, 2012, '2012-12-14', 2200, NULL, 0, 0, '', '', '', 'Tol Liefkenstunnel', 1.04);
INSERT INTO boekregels VALUES (1892, 355, 2012, '2012-12-14', 4270, NULL, 1893, 0, '', '', '', 'Tol Liefkenstunnel', 4.96);
INSERT INTO boekregels VALUES (1895, 355, 2012, '2012-12-14', 2200, NULL, 0, 0, '', '', '', 'Tol Liefkenstunnel', 1.04);
INSERT INTO boekregels VALUES (1894, 355, 2012, '2012-12-14', 4270, NULL, 1895, 0, '', '', '', 'Tol Liefkenstunnel', 4.96);
INSERT INTO boekregels VALUES (1897, 355, 2012, '2012-12-19', 2200, NULL, 0, 0, '', '', '', 'Telefoonhoesje', 2.60);
INSERT INTO boekregels VALUES (1896, 355, 2012, '2012-12-19', 4230, NULL, 1897, 0, '', '', '', 'Telefoonhoesje', 12.39);
INSERT INTO boekregels VALUES (1899, 355, 2012, '2012-12-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Opel', 10.21);
INSERT INTO boekregels VALUES (1901, 355, 2012, '2012-12-20', 2200, NULL, 0, 0, '', '', '', 'Steeksleutel', 1.54);
INSERT INTO boekregels VALUES (1900, 355, 2012, '2012-12-20', 4220, NULL, 1901, 0, '', '', '', 'Steeksleutel', 7.31);
INSERT INTO boekregels VALUES (1902, 355, 2012, '2012-12-20', 1060, NULL, 0, 0, '', '', '', 'Kasblad 12 2012', -266.11);
INSERT INTO boekregels VALUES (1903, 356, 2012, '2012-04-05', 1200, NULL, 0, 0, 'midholl', '2012005', '', 'Graffitiworkshop Lekkerkerk', 499.80);
INSERT INTO boekregels VALUES (1905, 356, 2012, '2012-04-05', 2110, NULL, 0, 0, 'midholl', '2012005', '', 'Graffitiworkshop Lekkerkerk', -79.80);
INSERT INTO boekregels VALUES (1904, 356, 2012, '2012-04-05', 8110, NULL, 1905, 0, 'midholl', '2012005', '', 'Graffitiworkshop Lekkerkerk', -420.00);
INSERT INTO boekregels VALUES (1906, 357, 2012, '2012-05-05', 1200, NULL, 0, 0, 'gopfreib', '2012006', '', 'Wandschilderingen Freiburg', 1100.00);
INSERT INTO boekregels VALUES (1907, 357, 2012, '2012-05-05', 8030, NULL, 0, 0, 'gopfreib', '2012006', '', 'Wandschilderingen Freiburg', -1100.00);
INSERT INTO boekregels VALUES (1908, 358, 2012, '2012-05-05', 1200, NULL, 0, 0, 'zuleico', '2012008', '', 'Muurschildering binnen', 583.10);
INSERT INTO boekregels VALUES (1910, 358, 2012, '2012-05-05', 2110, NULL, 0, 0, 'zuleico', '2012008', '', 'Muurschildering binnen', -93.10);
INSERT INTO boekregels VALUES (1909, 358, 2012, '2012-05-05', 8070, NULL, 1910, 0, 'zuleico', '2012008', '', 'Muurschildering binnen', -490.00);
INSERT INTO boekregels VALUES (1911, 359, 2012, '2012-05-05', 1200, NULL, 0, 0, 'interior', '2012007', '', 'Muurschildering binnen', 470.05);
INSERT INTO boekregels VALUES (1913, 359, 2012, '2012-05-05', 2110, NULL, 0, 0, 'interior', '2012007', '', 'Muurschildering binnen', -75.05);
INSERT INTO boekregels VALUES (1912, 359, 2012, '2012-05-05', 8070, NULL, 1913, 0, 'interior', '2012007', '', 'Muurschildering binnen', -395.00);
INSERT INTO boekregels VALUES (1914, 360, 2012, '2012-06-05', 1200, NULL, 0, 0, 'midholl', '2012009', '', 'Workshop', 535.50);
INSERT INTO boekregels VALUES (1916, 360, 2012, '2012-06-05', 2110, NULL, 0, 0, 'midholl', '2012009', '', 'Workshop', -85.50);
INSERT INTO boekregels VALUES (1915, 360, 2012, '2012-06-05', 8110, NULL, 1916, 0, 'midholl', '2012009', '', 'Workshop', -450.00);
INSERT INTO boekregels VALUES (1917, 361, 2012, '2012-06-14', 1200, NULL, 0, 0, 'hako', '2012010', '', 'Muurschildering binnen', 333.20);
INSERT INTO boekregels VALUES (1919, 361, 2012, '2012-06-14', 2110, NULL, 0, 0, 'hako', '2012010', '', 'Muurschildering binnen', -53.20);
INSERT INTO boekregels VALUES (1918, 361, 2012, '2012-06-14', 8070, NULL, 1919, 0, 'hako', '2012010', '', 'Muurschildering binnen', -280.00);
INSERT INTO boekregels VALUES (1920, 362, 2012, '2012-06-29', 1200, NULL, 0, 0, 'saffier', '2012011', '', 'Muurschildering binnen', 315.35);
INSERT INTO boekregels VALUES (1922, 362, 2012, '2012-06-29', 2110, NULL, 0, 0, 'saffier', '2012011', '', 'Muurschildering binnen', -50.35);
INSERT INTO boekregels VALUES (1921, 362, 2012, '2012-06-29', 8070, NULL, 1922, 0, 'saffier', '2012011', '', 'Muurschildering binnen', -265.00);
INSERT INTO boekregels VALUES (1925, 241, 2012, '2012-06-30', 2110, NULL, 0, 0, '', '', '', 'Cont.verkopen schilderijen 2e kw.', -49.42);
INSERT INTO boekregels VALUES (1924, 241, 2012, '2012-06-30', 8065, NULL, 1925, 0, '', '', '', 'Cont.verkopen schilderijen 2e kw.', -260.08);
INSERT INTO boekregels VALUES (1939, 366, 2012, '2012-07-30', 2110, NULL, 0, 0, 'russel', '2012015', '', 'Muurschildering bijwerken', -28.50);
INSERT INTO boekregels VALUES (1938, 366, 2012, '2012-07-30', 8070, NULL, 1939, 0, 'russel', '2012015', '', 'Muurschildering bijwerken', -150.00);
INSERT INTO boekregels VALUES (1940, 367, 2012, '2012-07-30', 1200, NULL, 0, 0, 'thurley', '2012016', '', 'Muurschildering binnen', 150.00);
INSERT INTO boekregels VALUES (1926, 241, 2012, '2012-06-30', 8110, NULL, 1927, 0, '', '', '', 'Cont.verkopen workshops 2e kw.', -126.05);
INSERT INTO boekregels VALUES (1927, 241, 2012, '2012-06-30', 2110, NULL, 0, 0, '', '', '', 'Cont.verkopen workshops 2e kw.', -23.95);
INSERT INTO boekregels VALUES (1942, 367, 2012, '2012-07-30', 2110, NULL, 0, 0, 'thurley', '2012016', '', 'Muurschildering binnen', -23.95);
INSERT INTO boekregels VALUES (1258, 241, 2012, '2012-06-30', 8060, NULL, 1923, 0, '', '', '', 'Cont.verkopen muursch. 2e kw.', -2365.55);
INSERT INTO boekregels VALUES (1923, 241, 2012, '2012-06-30', 2110, NULL, 0, 0, '', '', '', 'Cont.verkopen muursch. 2e kw.', -449.45);
INSERT INTO boekregels VALUES (1928, 363, 2012, '2012-07-17', 1200, NULL, 0, 0, 'oudenes', '2012012', '', 'Muurschildering skyline Rotterdam', 1671.95);
INSERT INTO boekregels VALUES (1930, 363, 2012, '2012-07-17', 2110, NULL, 0, 0, 'oudenes', '2012012', '', 'Muurschildering skyline Rotterdam', -266.95);
INSERT INTO boekregels VALUES (1929, 363, 2012, '2012-07-17', 8070, NULL, 1930, 0, 'oudenes', '2012012', '', 'Muurschildering skyline Rotterdam', -1405.00);
INSERT INTO boekregels VALUES (1931, 364, 2012, '2012-07-27', 1200, NULL, 0, 0, 'woonp', '2012013', '', 'Muurschildering Cirkelflat', 4317.32);
INSERT INTO boekregels VALUES (1933, 364, 2012, '2012-07-27', 2110, NULL, 0, 0, 'woonp', '2012013', '', 'Muurschildering Cirkelflat', -689.32);
INSERT INTO boekregels VALUES (1932, 364, 2012, '2012-07-27', 8070, NULL, 1933, 0, 'woonp', '2012013', '', 'Muurschildering Cirkelflat', -3628.00);
INSERT INTO boekregels VALUES (1934, 365, 2012, '2012-07-27', 1200, NULL, 0, 0, 'woonp', '2012014', '', 'Herstellen muursch. Kerkweg Oost', 59.50);
INSERT INTO boekregels VALUES (1936, 365, 2012, '2012-07-27', 2110, NULL, 0, 0, 'woonp', '2012014', '', 'Herstellen muursch. Kerkweg Oost', -9.50);
INSERT INTO boekregels VALUES (1935, 365, 2012, '2012-07-27', 8070, NULL, 1936, 0, 'woonp', '2012014', '', 'Herstellen muursch. Kerkweg Oost', -50.00);
INSERT INTO boekregels VALUES (1937, 366, 2012, '2012-07-30', 1200, NULL, 0, 0, 'russel', '2012015', '', 'Muurschildering bijwerken', 178.50);
INSERT INTO boekregels VALUES (1941, 367, 2012, '2012-07-30', 8060, NULL, 1942, 0, 'thurley', '2012016', '', 'Muurschildering binnen', -126.05);
INSERT INTO boekregels VALUES (1945, 368, 2012, '2012-08-07', 2110, NULL, 0, 0, 'woonp', '2012017', '', 'Ontwerp en realisatie boekje', -416.29);
INSERT INTO boekregels VALUES (1944, 368, 2012, '2012-08-07', 8080, NULL, 1945, 0, 'woonp', '2012017', '', 'Ontwerp en realisatie boekje', -2191.00);
INSERT INTO boekregels VALUES (1943, 368, 2012, '2012-08-07', 1200, NULL, 0, 0, 'woonp', '2012017', '', 'Ontwerp en realisatie boekje', 2607.29);
INSERT INTO boekregels VALUES (1946, 369, 2012, '2012-08-07', 1200, NULL, 0, 0, 'russel', '2012018', '', 'Muurschildering Broadbents', 392.50);
INSERT INTO boekregels VALUES (1948, 369, 2012, '2012-08-07', 2110, NULL, 0, 0, 'russel', '2012018', '', 'Muurschildering Broadbents', -62.67);
INSERT INTO boekregels VALUES (1947, 369, 2012, '2012-08-07', 8070, NULL, 1948, 0, 'russel', '2012018', '', 'Muurschildering Broadbents', -329.83);
INSERT INTO boekregels VALUES (1949, 370, 2012, '2012-08-21', 1200, NULL, 0, 0, 'femtastic', '2012019', '', 'Muurschildering Femtastic', 476.00);
INSERT INTO boekregels VALUES (1951, 370, 2012, '2012-08-21', 2110, NULL, 0, 0, 'femtastic', '2012019', '', 'Muurschildering Femtastic', -76.00);
INSERT INTO boekregels VALUES (1950, 370, 2012, '2012-08-21', 8070, NULL, 1951, 0, 'femtastic', '2012019', '', 'Muurschildering Femtastic', -400.00);
INSERT INTO boekregels VALUES (1952, 371, 2012, '2012-09-12', 1200, NULL, 0, 0, 'grvenen', '2012020', '', 'Workshop streetart', 119.00);
INSERT INTO boekregels VALUES (1954, 371, 2012, '2012-09-12', 2110, NULL, 0, 0, 'grvenen', '2012020', '', 'Workshop streetart', -19.00);
INSERT INTO boekregels VALUES (1953, 371, 2012, '2012-09-12', 8110, NULL, 1954, 0, 'grvenen', '2012020', '', 'Workshop streetart', -100.00);
INSERT INTO boekregels VALUES (1955, 372, 2012, '2012-09-18', 1200, NULL, 0, 0, 'quarijn', '2012021', '', 'Muurschildering binnen', 571.20);
INSERT INTO boekregels VALUES (1957, 372, 2012, '2012-09-18', 2110, NULL, 0, 0, 'quarijn', '2012021', '', 'Muurschildering binnen', -91.20);
INSERT INTO boekregels VALUES (1956, 372, 2012, '2012-09-18', 8070, NULL, 1957, 0, 'quarijn', '2012021', '', 'Muurschildering binnen', -480.00);
INSERT INTO boekregels VALUES (1958, 373, 2012, '2012-10-11', 1200, NULL, 0, 0, 'quarijn', '2012022', '', 'Muurschildering ronde muur', 1052.70);
INSERT INTO boekregels VALUES (1961, 374, 2012, '2012-10-11', 1200, NULL, 0, 0, 'leeuwen', '2012023', '', 'Muurschildering bruin cafe', 266.81);
INSERT INTO boekregels VALUES (1265, 242, 2012, '2012-09-30', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen schilderijen 3e kw.', -31.93);
INSERT INTO boekregels VALUES (1960, 373, 2012, '2012-10-11', 2110, NULL, 0, 0, 'quarijn', '2012022', '', 'Muurschildering ronde muur', -182.70);
INSERT INTO boekregels VALUES (1959, 373, 2012, '2012-10-11', 8070, NULL, 1960, 0, 'quarijn', '2012022', '', 'Muurschildering ronde muur', -870.00);
INSERT INTO boekregels VALUES (1264, 242, 2012, '2012-09-30', 8065, NULL, 1265, 0, '', '', '', 'Cont. verkopen schilderijen 3e kw.', -168.07);
INSERT INTO boekregels VALUES (1963, 374, 2012, '2012-10-11', 2110, NULL, 0, 0, 'leeuwen', '2012023', '', 'Muurschildering bruin cafe', -46.31);
INSERT INTO boekregels VALUES (1750, 349, 2012, '2012-06-14', 5010, NULL, 0, 0, '', '', '', 'Schildersdoek', 38.97);
INSERT INTO boekregels VALUES (1777, 350, 2012, '2012-07-25', 5010, NULL, 1778, 0, '', '', '', 'Schildersdoek', 88.18);
INSERT INTO boekregels VALUES (1962, 374, 2012, '2012-10-11', 8070, NULL, 1963, 0, 'leeuwen', '2012023', '', 'Muurschildering bruin cafe', -220.50);
INSERT INTO boekregels VALUES (1964, 375, 2012, '2012-10-14', 1200, NULL, 0, 0, 'smit', '2012024', '', 'Muurschildering bruin cafe', 484.00);
INSERT INTO boekregels VALUES (1966, 375, 2012, '2012-10-14', 2110, NULL, 0, 0, 'smit', '2012024', '', 'Muurschildering bruin cafe', -84.00);
INSERT INTO boekregels VALUES (1965, 375, 2012, '2012-10-14', 8070, NULL, 1966, 0, 'smit', '2012024', '', 'Muurschildering bruin cafe', -400.00);
INSERT INTO boekregels VALUES (1967, 376, 2012, '2012-11-10', 1200, NULL, 0, 0, 'ipse', '2012025', '', 'Muurschildering binnen', 296.45);
INSERT INTO boekregels VALUES (1969, 376, 2012, '2012-11-10', 2110, NULL, 0, 0, 'ipse', '2012025', '', 'Muurschildering client', -51.45);
INSERT INTO boekregels VALUES (1968, 376, 2012, '2012-11-10', 8060, NULL, 1969, 0, 'ipse', '2012025', '', 'Muurschildering client', -245.00);
INSERT INTO boekregels VALUES (1970, 377, 2012, '2012-11-11', 1200, NULL, 0, 0, 'ordemed', '2012026', '', 'Live painting thema', 738.10);
INSERT INTO boekregels VALUES (2004, 386, 2012, '2012-12-31', 250, NULL, 0, 0, '', '', '', 'Afschrijving Opel Combo 2011 en 2012', -1378.90);
INSERT INTO boekregels VALUES (1973, 377, 2012, '2012-11-11', 8075, NULL, 1974, 0, 'ordemed', '2012026', '', 'Canvasdoek opgespannen 1x2m', -135.00);
INSERT INTO boekregels VALUES (1974, 377, 2012, '2012-11-11', 2110, NULL, 0, 0, 'ordemed', '2012026', '', 'Canvasdoek opgespannen 1x2m', -28.35);
INSERT INTO boekregels VALUES (1975, 377, 2012, '2012-11-11', 8075, NULL, 1976, 0, 'ordemed', '2012026', '', '2 schilderijen incl doek', -200.00);
INSERT INTO boekregels VALUES (1976, 377, 2012, '2012-11-11', 2110, NULL, 0, 0, 'ordemed', '2012026', '', '2 schilderijen incl doek', -42.00);
INSERT INTO boekregels VALUES (1971, 377, 2012, '2012-11-11', 8075, NULL, 1972, 0, 'ordemed', '2012026', '', 'Live painting thema', -275.00);
INSERT INTO boekregels VALUES (1972, 377, 2012, '2012-11-11', 2110, NULL, 0, 0, 'ordemed', '2012026', '', 'Live painting thema', -57.75);
INSERT INTO boekregels VALUES (1977, 378, 2012, '2012-11-26', 1200, NULL, 0, 0, 'rabozhm', '2012027', '', 'Workshop personeel', 354.15);
INSERT INTO boekregels VALUES (1979, 378, 2012, '2012-11-26', 2110, NULL, 0, 0, 'rabozhm', '2012027', '', 'Workshop personeel', -61.46);
INSERT INTO boekregels VALUES (1978, 378, 2012, '2012-11-26', 8110, NULL, 1979, 0, 'rabozhm', '2012027', '', 'Workshop personeel', -292.69);
INSERT INTO boekregels VALUES (1980, 379, 2012, '2012-11-28', 1200, NULL, 0, 0, 'rooiehoek', '2012028', '', 'Muurschilderingen binnen', 1089.00);
INSERT INTO boekregels VALUES (1982, 379, 2012, '2012-11-28', 2110, NULL, 0, 0, 'rooiehoek', '2012028', '', 'Muurschilderingen binnen', -189.00);
INSERT INTO boekregels VALUES (1981, 379, 2012, '2012-11-28', 8070, NULL, 1982, 0, 'rooiehoek', '2012028', '', 'Muurschilderingen binnen', -900.00);
INSERT INTO boekregels VALUES (1983, 380, 2012, '2012-12-11', 1200, NULL, 0, 0, 'intwell', '2012028', '', 'Muurschildering marktkraam', 786.50);
INSERT INTO boekregels VALUES (1985, 380, 2012, '2012-12-11', 2110, NULL, 0, 0, 'intwell', '2012028', '', 'Muurschildering marktkraam', -136.50);
INSERT INTO boekregels VALUES (1984, 380, 2012, '2012-12-11', 8070, NULL, 1985, 0, 'intwell', '2012028', '', 'Muurschildering marktkraam', -650.00);
INSERT INTO boekregels VALUES (1987, 244, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen schilderijen 4e kw. aanvulling', -26.03);
INSERT INTO boekregels VALUES (1986, 244, 2012, '2012-12-31', 8065, NULL, 1987, 0, '', '', '', 'Cont. verkopen schilderijen 4e kw. aanvulling', -123.97);
INSERT INTO boekregels VALUES (1335, 266, 2012, '2012-03-31', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 1e kw.', 2360.00);
INSERT INTO boekregels VALUES (1989, 266, 2012, '2012-03-31', 2110, NULL, 0, 0, '', '', '', 'Contante verkopen logo 1e kw.', -19.96);
INSERT INTO boekregels VALUES (1988, 266, 2012, '2012-03-31', 8080, NULL, 1989, 0, '', '', '', 'Contante verkopen logo 1e kw.', -105.04);
INSERT INTO boekregels VALUES (1990, 381, 2012, '2012-03-28', 1200, NULL, 0, 0, 'particulier', '2012004', '', 'Nog nakijken', 185.00);
INSERT INTO boekregels VALUES (1992, 381, 2012, '2012-03-28', 2110, NULL, 0, 0, 'particulier', '2012004', '', 'Nog nakijken', -29.54);
INSERT INTO boekregels VALUES (1991, 381, 2012, '2012-03-28', 8070, NULL, 1992, 0, 'particulier', '2012004', '', 'Nog nakijken', -155.46);
INSERT INTO boekregels VALUES (1993, 382, 2012, '2012-07-01', 1600, NULL, 0, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop jul', -424.57);
INSERT INTO boekregels VALUES (1995, 382, 2012, '2012-07-01', 2200, NULL, 0, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop jul', 67.79);
INSERT INTO boekregels VALUES (1994, 382, 2012, '2012-07-01', 4100, NULL, 1995, 0, 'verweij', '2012121', '', 'Huur atelier Boskoop jul', 356.78);
INSERT INTO boekregels VALUES (1288, 249, 2012, '2012-01-26', 5010, NULL, 1289, 0, 'vanbeek', '747147', '', 'Verf en linnen', 79.37);
INSERT INTO boekregels VALUES (1294, 251, 2012, '2012-01-15', 5010, NULL, 1295, 0, 'kramer', '54622', '', 'Spuitmateriaal', 214.03);
INSERT INTO boekregels VALUES (1305, 255, 2012, '2012-02-11', 5010, NULL, 1306, 0, 'kramer', '54794', '', 'Spuitmateriaal', 147.27);
INSERT INTO boekregels VALUES (1999, 384, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive bijtelling Opel Combo', 4472.50);
INSERT INTO boekregels VALUES (1314, 258, 2012, '2012-02-23', 5010, NULL, 1315, 0, 'vanbeek', '759771', '', 'Verf en linnen', 135.56);
INSERT INTO boekregels VALUES (1317, 259, 2012, '2012-02-23', 5010, NULL, 1318, 0, 'vanbeek', '759773', '', 'Markers', 9.93);
INSERT INTO boekregels VALUES (1333, 265, 2012, '2012-03-12', 5010, NULL, 1334, 0, 'kramer', '54972', '', 'Spuitmateriaal', 245.92);
INSERT INTO boekregels VALUES (1359, 274, 2012, '2012-05-12', 5010, NULL, 1360, 0, 'vanbeek', '794001', '', 'Tekenmateriaal', 35.32);
INSERT INTO boekregels VALUES (1368, 277, 2012, '2012-04-20', 5010, NULL, 1369, 0, 'kramer', '55182', '', 'Spuitmateriaal', 392.77);
INSERT INTO boekregels VALUES (1371, 278, 2012, '2012-05-14', 5010, NULL, 1372, 0, 'kramer', '55395', '', 'Spuitmateriaal', 249.12);
INSERT INTO boekregels VALUES (1377, 280, 2012, '2012-05-25', 5010, NULL, 1378, 0, 'kramer', '55469', '', 'Spuitmateriaal', 112.31);
INSERT INTO boekregels VALUES (1387, 284, 2012, '2012-06-12', 5010, NULL, 1388, 0, 'kramer', '55648', '', 'Spuitmateriaal', 162.94);
INSERT INTO boekregels VALUES (1393, 286, 2012, '2012-06-25', 5010, NULL, 1394, 0, 'kramer', '55793', '', 'Spuitmateriaal', 139.12);
INSERT INTO boekregels VALUES (1396, 287, 2012, '2012-07-02', 5010, NULL, 1397, 0, 'kramer', '55837', '', 'Spuitmateriaal', 135.92);
INSERT INTO boekregels VALUES (1405, 290, 2012, '2012-07-11', 5010, NULL, 1406, 0, 'kramer', '55936', '', 'Spuitmateriaal', 204.96);
INSERT INTO boekregels VALUES (1408, 291, 2012, '2012-07-14', 5010, NULL, 1409, 0, 'kramer', '55948', '', 'Spuitmateriaal', 428.95);
INSERT INTO boekregels VALUES (1435, 300, 2012, '2012-08-02', 5010, NULL, 1436, 0, 'kramer', '56110', '', 'Spuitmateriaal', 360.46);
INSERT INTO boekregels VALUES (1438, 301, 2012, '2012-08-03', 5010, NULL, 1439, 0, 'drukwerk', '2012389598', '', 'Boekjes glazen kunstwerken Vondelflats', 947.77);
INSERT INTO boekregels VALUES (1447, 304, 2012, '2012-08-08', 5010, NULL, 1448, 0, 'vanbeek', '826289', '', 'Materiaal', 30.13);
INSERT INTO boekregels VALUES (1459, 308, 2012, '2012-08-22', 5010, NULL, 1460, 0, 'kramer', '56235', '', 'Spuitmateriaal', 211.76);
INSERT INTO boekregels VALUES (1465, 310, 2012, '2012-09-04', 5010, NULL, 1466, 0, 'kramer', '56333', '', 'Spuitmateriaal', 415.00);
INSERT INTO boekregels VALUES (1483, 317, 2012, '2012-09-28', 5010, NULL, 1484, 0, 'vanbeek', '847746', '', 'Linnen', 57.82);
INSERT INTO boekregels VALUES (1495, 321, 2012, '2012-10-15', 5010, NULL, 1496, 0, 'kramer', '56610', '', 'Spuitmateriaal', 234.79);
INSERT INTO boekregels VALUES (1510, 326, 2012, '2012-11-01', 5010, NULL, 1511, 0, 'kramer', '56680', '', 'Spuitmateriaal', 119.09);
INSERT INTO boekregels VALUES (1513, 327, 2012, '2012-11-05', 5010, NULL, 1514, 0, 'vanbeek', '865253', '', 'Linnen en stiften', 130.52);
INSERT INTO boekregels VALUES (1516, 328, 2012, '2012-11-06', 5010, NULL, 1517, 0, 'kramer', '56751', '', 'Spuitmateriaal', 173.06);
INSERT INTO boekregels VALUES (1522, 330, 2012, '2012-11-22', 5010, NULL, 1523, 0, 'kramer', '56854', '', 'Spuitmateriaal', 185.08);
INSERT INTO boekregels VALUES (1563, 344, 2012, '2012-01-02', 5010, NULL, 1566, 0, '', '', '', 'MDF en verfrol', 10.80);
INSERT INTO boekregels VALUES (1575, 344, 2012, '2012-01-10', 5010, NULL, 1576, 0, '', '', '', 'Latex', 29.79);
INSERT INTO boekregels VALUES (1599, 345, 2012, '2012-02-01', 5010, NULL, 1600, 0, '', '', '', 'Linnen', 27.36);
INSERT INTO boekregels VALUES (1601, 345, 2012, '2012-02-02', 5010, NULL, 1602, 0, '', '', '', 'Linnen', 30.16);
INSERT INTO boekregels VALUES (1707, 348, 2012, '2012-05-07', 5010, NULL, 1708, 0, '', '', '', 'Verfrollers', 72.10);
INSERT INTO boekregels VALUES (1729, 348, 2012, '2012-05-28', 5010, NULL, 1730, 0, '', '', '', 'Afdektape en folie', 4.76);
INSERT INTO boekregels VALUES (2003, 386, 2012, '2012-12-31', 4620, NULL, 0, 0, '', '', '', 'Afschrijving Opel Combo 2011 en 2012', 1378.90);
INSERT INTO boekregels VALUES (2000, 384, 2012, '2012-12-31', 4520, NULL, 0, 0, '', '', '', 'Prive bijtelling Opel Combo', -4472.50);
INSERT INTO boekregels VALUES (2001, 385, 2012, '2012-12-31', 4510, NULL, 0, 0, '', '', '', 'BTW Correctie prive gebruik Opel Combo', 268.35);
INSERT INTO boekregels VALUES (2002, 385, 2012, '2012-12-31', 2150, NULL, 0, 0, '', '', '', 'BTW Correctie prive gebruik Opel Combo', -268.35);
INSERT INTO boekregels VALUES (1781, 350, 2012, '2012-07-26', 5010, NULL, 1782, 0, '', '', '', 'Panelen', 13.53);
INSERT INTO boekregels VALUES (1783, 350, 2012, '2012-07-27', 5010, NULL, 1784, 0, '', '', '', 'Panelen', 41.98);
INSERT INTO boekregels VALUES (1794, 351, 2012, '2012-08-09', 5010, NULL, 1795, 0, '', '', '', 'Spuitmateriaal', 15.11);
INSERT INTO boekregels VALUES (1819, 352, 2012, '2012-09-04', 5010, NULL, 1820, 0, '', '', '', 'Panelen', 27.10);
INSERT INTO boekregels VALUES (1846, 353, 2012, '2012-10-16', 5010, NULL, 1847, 0, '', '', '', 'Plaatmateriaal', 14.26);
INSERT INTO boekregels VALUES (1848, 353, 2012, '2012-10-20', 5010, NULL, 1849, 0, '', '', '', 'Latex', 16.67);
INSERT INTO boekregels VALUES (1871, 354, 2012, '2012-11-20', 5010, NULL, 1872, 0, '', '', '', 'Plaatmateriaal', 23.55);
INSERT INTO boekregels VALUES (1879, 354, 2012, '2012-11-30', 5010, NULL, 1880, 0, '', '', '', 'Spuitmateriaal', 9.05);
INSERT INTO boekregels VALUES (1881, 354, 2012, '2012-11-30', 5010, NULL, 1882, 0, '', '', '', 'Spuitmateriaal', 11.98);
INSERT INTO boekregels VALUES (1605, 345, 2012, '2012-02-04', 4410, NULL, 1606, 0, '', '', '', 'Brandstof Opel', 12.51);
INSERT INTO boekregels VALUES (1607, 345, 2012, '2012-02-09', 4410, NULL, 1608, 0, '', '', '', 'Brandstof Opel', 35.95);
INSERT INTO boekregels VALUES (1617, 345, 2012, '2012-02-15', 4410, NULL, 1618, 0, '', '', '', 'Brandstof Opel', 44.56);
INSERT INTO boekregels VALUES (1623, 345, 2012, '2012-02-23', 4410, NULL, 1624, 0, '', '', '', 'Brandstof Opel', 46.73);
INSERT INTO boekregels VALUES (1630, 346, 2012, '2012-03-01', 4410, NULL, 1631, 0, '', '', '', 'Brandstof Opel', 39.96);
INSERT INTO boekregels VALUES (1997, 383, 2012, '2012-12-01', 4100, NULL, 1998, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop dec', 364.99);
INSERT INTO boekregels VALUES (1998, 383, 2012, '2012-12-01', 2200, NULL, 0, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop dec', 76.65);
INSERT INTO boekregels VALUES (1635, 346, 2012, '2012-03-06', 4410, NULL, 1636, 0, '', '', '', 'Brandstof Opel', 47.92);
INSERT INTO boekregels VALUES (1639, 346, 2012, '2012-03-13', 4410, NULL, 1640, 0, '', '', '', 'Brandstof Opel', 17.33);
INSERT INTO boekregels VALUES (1641, 346, 2012, '2012-03-15', 4410, NULL, 1642, 0, '', '', '', 'Brandstof Opel', 46.08);
INSERT INTO boekregels VALUES (1647, 346, 2012, '2012-03-20', 4410, NULL, 1648, 0, '', '', '', 'Brandstof Opel', 42.11);
INSERT INTO boekregels VALUES (1659, 346, 2012, '2012-03-24', 4410, NULL, 1660, 0, '', '', '', 'Brandstof Opel', 49.60);
INSERT INTO boekregels VALUES (1661, 346, 2012, '2012-03-28', 4410, NULL, 1662, 0, '', '', '', 'Brandstof Opel', 40.43);
INSERT INTO boekregels VALUES (1677, 347, 2012, '2012-04-14', 4410, NULL, 1678, 0, '', '', '', 'Brandstof Opel', 35.08);
INSERT INTO boekregels VALUES (1681, 347, 2012, '2012-04-22', 4410, NULL, 1682, 0, '', '', '', 'Brandstof Opel', 47.13);
INSERT INTO boekregels VALUES (1687, 347, 2012, '2012-04-26', 4410, NULL, 1688, 0, '', '', '', 'Brandstof Opel', 41.71);
INSERT INTO boekregels VALUES (1694, 347, 2012, '2012-04-29', 4410, NULL, 1695, 0, '', '', '', 'Brandstof Opel DE', 45.94);
INSERT INTO boekregels VALUES (1689, 347, 2012, '2012-04-27', 4410, NULL, 0, 0, '', '', '', 'Brandstof Opel DE', 55.00);
INSERT INTO boekregels VALUES (1697, 348, 2012, '2012-04-04', 4410, NULL, 1698, 0, '', '', '', 'Brandstof Opel', 45.87);
INSERT INTO boekregels VALUES (1701, 348, 2012, '2012-05-03', 4410, NULL, 1702, 0, '', '', '', 'Brandstof Opel', 50.45);
INSERT INTO boekregels VALUES (1773, 350, 2012, '2012-07-13', 4410, NULL, 1774, 0, '', '', '', 'Brandstof Opel', 50.81);
INSERT INTO boekregels VALUES (1785, 350, 2012, '2012-07-28', 4410, NULL, 1786, 0, '', '', '', 'Brandstof Opel', 41.85);
INSERT INTO boekregels VALUES (1790, 351, 2012, '2012-08-02', 4410, NULL, 1791, 0, '', '', '', 'Brandstof Opel', 51.32);
INSERT INTO boekregels VALUES (1833, 352, 2012, '2012-09-25', 4410, NULL, 1834, 0, '', '', '', 'Brandstof Opel', 56.07);
INSERT INTO boekregels VALUES (1838, 353, 2012, '2012-10-03', 4410, NULL, 1839, 0, '', '', '', 'Brandstof Opel', 50.62);
INSERT INTO boekregels VALUES (1840, 353, 2012, '2012-10-08', 4410, NULL, 1841, 0, '', '', '', 'Brandstof Opel', 11.87);
INSERT INTO boekregels VALUES (1844, 353, 2012, '2012-10-12', 4410, NULL, 1845, 0, '', '', '', 'Brandstof Opel', 53.69);
INSERT INTO boekregels VALUES (1850, 353, 2012, '2012-10-17', 4410, NULL, 1851, 0, '', '', '', 'Brandstof Opel', 45.37);
INSERT INTO boekregels VALUES (1852, 353, 2012, '2012-10-25', 4410, NULL, 1853, 0, '', '', '', 'Brandstof Opel', 48.51);
INSERT INTO boekregels VALUES (1857, 354, 2012, '2012-11-01', 4410, NULL, 1858, 0, '', '', '', 'Brandstof Opel', 27.74);
INSERT INTO boekregels VALUES (1861, 354, 2012, '2012-11-08', 4410, NULL, 1862, 0, '', '', '', 'Brandstof Opel', 20.67);
INSERT INTO boekregels VALUES (1865, 354, 2012, '2012-11-10', 4410, NULL, 1866, 0, '', '', '', 'Brandstof Opel', 25.37);
INSERT INTO boekregels VALUES (1867, 354, 2012, '2012-11-13', 4410, NULL, 1868, 0, '', '', '', 'Brandstof Opel', 48.29);
INSERT INTO boekregels VALUES (1877, 354, 2012, '2012-11-23', 4410, NULL, 1878, 0, '', '', '', 'Brandstof Opel', 46.36);
INSERT INTO boekregels VALUES (1884, 355, 2012, '2012-12-01', 4410, NULL, 1885, 0, '', '', '', 'Brandstof Opel', 44.79);
INSERT INTO boekregels VALUES (1889, 355, 2012, '2012-12-11', 4410, NULL, 1890, 0, '', '', '', 'Brandstof Opel', 53.29);
INSERT INTO boekregels VALUES (1898, 355, 2012, '2012-12-17', 4410, NULL, 1899, 0, '', '', '', 'Brandstof Opel', 48.63);
INSERT INTO boekregels VALUES (2017, 389, 2012, '2012-06-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 959.82);
INSERT INTO boekregels VALUES (2018, 389, 2012, '2012-06-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -637.11);
INSERT INTO boekregels VALUES (2019, 389, 2012, '2012-06-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -139.00);
INSERT INTO boekregels VALUES (2020, 389, 2012, '2012-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -959.82);
INSERT INTO boekregels VALUES (2021, 389, 2012, '2012-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.18);
INSERT INTO boekregels VALUES (2022, 389, 2012, '2012-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2210', 139.00);
INSERT INTO boekregels VALUES (2023, 389, 2012, '2012-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 637.11);
INSERT INTO boekregels VALUES (2024, 389, 2012, '2012-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.11);
INSERT INTO boekregels VALUES (2025, 389, 2012, '2012-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.18);
INSERT INTO boekregels VALUES (2026, 389, 2012, '2012-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.11);
INSERT INTO boekregels VALUES (2027, 390, 2012, '2012-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 1880.56);
INSERT INTO boekregels VALUES (2028, 390, 2012, '2012-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -934.00);
INSERT INTO boekregels VALUES (2029, 390, 2012, '2012-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -233.40);
INSERT INTO boekregels VALUES (2030, 390, 2012, '2012-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -1880.56);
INSERT INTO boekregels VALUES (2031, 390, 2012, '2012-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.44);
INSERT INTO boekregels VALUES (2032, 390, 2012, '2012-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 233.40);
INSERT INTO boekregels VALUES (2033, 390, 2012, '2012-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 934.00);
INSERT INTO boekregels VALUES (2034, 390, 2012, '2012-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.40);
INSERT INTO boekregels VALUES (2035, 390, 2012, '2012-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.44);
INSERT INTO boekregels VALUES (2036, 390, 2012, '2012-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.40);
INSERT INTO boekregels VALUES (2053, 393, 2012, '2012-02-28', 1200, NULL, 0, 0, 'particulier', '2012004', '', 'Dummy factuur', 185.00);
INSERT INTO boekregels VALUES (2055, 393, 2012, '2012-02-28', 2110, NULL, 0, 0, 'particulier', '2012004', '', 'Dummy factuur', -29.54);
INSERT INTO boekregels VALUES (2054, 393, 2012, '2012-02-28', 8070, NULL, 2055, 0, 'particulier', '2012004', '', 'Dummy factuur', -155.46);
INSERT INTO boekregels VALUES (2056, 394, 2012, '2012-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 633.97);
INSERT INTO boekregels VALUES (2057, 394, 2012, '2012-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -566.49);
INSERT INTO boekregels VALUES (2058, 394, 2012, '2012-03-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -128.39);
INSERT INTO boekregels VALUES (2059, 394, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -633.97);
INSERT INTO boekregels VALUES (2060, 394, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.03);
INSERT INTO boekregels VALUES (2061, 394, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2210', 128.39);
INSERT INTO boekregels VALUES (2062, 394, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 566.49);
INSERT INTO boekregels VALUES (2063, 394, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', 0.12);
INSERT INTO boekregels VALUES (2064, 394, 2012, '2012-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.03);
INSERT INTO boekregels VALUES (2065, 394, 2012, '2012-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', -0.12);
INSERT INTO boekregels VALUES (2066, 395, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 803.00);
INSERT INTO boekregels VALUES (2067, 395, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -803.00);
INSERT INTO boekregels VALUES (2068, 396, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 1352.45);
INSERT INTO boekregels VALUES (2069, 396, 2012, '2012-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -672.94);
INSERT INTO boekregels VALUES (2070, 396, 2012, '2012-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -283.08);
INSERT INTO boekregels VALUES (2071, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -1352.45);
INSERT INTO boekregels VALUES (2072, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.45);
INSERT INTO boekregels VALUES (2073, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 283.08);
INSERT INTO boekregels VALUES (2074, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 672.94);
INSERT INTO boekregels VALUES (2075, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.02);
INSERT INTO boekregels VALUES (2076, 396, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.45);
INSERT INTO boekregels VALUES (2077, 396, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.02);
INSERT INTO boekregels VALUES (2078, 396, 2012, '2012-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 268.35);
INSERT INTO boekregels VALUES (2079, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -268.35);
INSERT INTO boekregels VALUES (2080, 396, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.35);
INSERT INTO boekregels VALUES (2081, 396, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', -0.35);
INSERT INTO boekregels VALUES (2082, 397, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '', 'Werkelijk betaalde BTW 1e periode', -98.00);
INSERT INTO boekregels VALUES (2083, 397, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '', 'Werkelijk betaalde BTW 2e periode', 202.00);
INSERT INTO boekregels VALUES (2084, 397, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '', 'Werkelijk betaalde BTW 3e periode', 819.00);
INSERT INTO boekregels VALUES (2085, 397, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Werkelijk betaalde BTW bedragen', -923.00);
INSERT INTO boekregels VALUES (2086, 398, 2012, '2012-12-31', 1200, NULL, 0, 0, '', '', '', 'Debiteurensaldo prive ontvangen 2012', -20638.57);
INSERT INTO boekregels VALUES (2087, 398, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Debiteurensaldo prive ontvangen 2012', 20638.57);
INSERT INTO boekregels VALUES (1996, 383, 2012, '2012-12-01', 1600, NULL, 0, 0, 'verweij', '2012182', '', 'Huur atelier Boskoop dec', -441.64);
INSERT INTO boekregels VALUES (2088, 399, 2012, '2012-12-31', 1600, NULL, 0, 0, '', '', '', 'Crediteurensaldo prive betaald 2012', 17446.36);
INSERT INTO boekregels VALUES (2089, 399, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Crediteurensaldo prive betaald 2012', -17446.36);
INSERT INTO boekregels VALUES (2091, 400, 2012, '2012-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'Correctiebedrag BTW naar verrekening', -1.73);
INSERT INTO boekregels VALUES (2093, 400, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding Correctiebedrag BTW naar verrekening', -0.27);
INSERT INTO boekregels VALUES (2099, 402, 2013, '2013-07-10', 1600, NULL, 0, 0, 'kramer', 'HE91472', '', 'Spuitmateriaal', -392.00);
INSERT INTO boekregels VALUES (2094, 401, 2013, '2013-01-01', 200, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 3500.00);
INSERT INTO boekregels VALUES (2095, 401, 2013, '2013-01-01', 250, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -1378.90);
INSERT INTO boekregels VALUES (2096, 401, 2013, '2013-01-01', 900, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -2768.08);
INSERT INTO boekregels VALUES (2097, 401, 2013, '2013-01-01', 1200, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 419.98);
INSERT INTO boekregels VALUES (2098, 401, 2013, '2013-01-01', 2300, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 227.00);
INSERT INTO boekregels VALUES (822, 158, 2013, '2013-01-17', 4310, NULL, 823, 0, 'drukwerk', '2013109457', '', 'Reclameposters', 19.89);
INSERT INTO boekregels VALUES (828, 160, 2013, '2013-01-23', 4310, NULL, 829, 0, 'drukwerk', '2013113939', '', 'Reclameposters', 84.81);
INSERT INTO boekregels VALUES (840, 164, 2013, '2013-02-07', 4310, NULL, 841, 0, 'marktplaats', '130200486', '', 'Advertentiepakket', 114.00);
INSERT INTO boekregels VALUES (863, 172, 2013, '2013-03-06', 4310, NULL, 864, 0, 'drukwerk', '2013140365', '', 'Reclameposters', 43.40);
INSERT INTO boekregels VALUES (1025, 196, 2013, '2013-04-17', 4310, NULL, 1026, 0, 'marktplaats', 'MP130423317', '', 'Advertentiepakket KK', 54.00);
INSERT INTO boekregels VALUES (1028, 197, 2013, '2013-04-24', 4310, NULL, 1029, 0, 'drukwerk', 'F2013175995', '', 'Folders KK', 58.94);
INSERT INTO boekregels VALUES (924, 187, 2013, '2013-01-03', 4410, NULL, 925, 0, '', '', '', 'Brandstof', 46.93);
INSERT INTO boekregels VALUES (929, 187, 2013, '2013-01-14', 4410, NULL, 930, 0, '', '', '', 'Brandstof en versnapering', 19.83);
INSERT INTO boekregels VALUES (931, 187, 2013, '2013-01-16', 4410, NULL, 932, 0, '', '', '', 'Brandstof', 59.00);
INSERT INTO boekregels VALUES (936, 187, 2013, '2013-01-21', 4410, NULL, 937, 0, '', '', '', 'Brandstof', 51.26);
INSERT INTO boekregels VALUES (940, 187, 2013, '2013-01-28', 4410, NULL, 941, 0, '', '', '', 'Brandstof', 49.80);
INSERT INTO boekregels VALUES (958, 188, 2013, '2013-02-10', 4410, NULL, 959, 0, '', '', '', 'Brandstof', 50.74);
INSERT INTO boekregels VALUES (964, 188, 2013, '2013-02-18', 4410, NULL, 965, 0, '', '', '', 'Brandstof', 34.76);
INSERT INTO boekregels VALUES (970, 188, 2013, '2013-02-23', 4410, NULL, 971, 0, '', '', '', 'Brandstof', 47.83);
INSERT INTO boekregels VALUES (973, 189, 2013, '2013-03-02', 4410, NULL, 974, 0, '', '', '', 'Brandstof', 51.60);
INSERT INTO boekregels VALUES (977, 189, 2013, '2013-03-11', 4410, NULL, 978, 0, '', '', '', 'Brandstof', 41.17);
INSERT INTO boekregels VALUES (981, 189, 2013, '2013-03-17', 4410, NULL, 982, 0, '', '', '', 'Brandstof', 28.97);
INSERT INTO boekregels VALUES (985, 189, 2013, '2013-03-18', 4410, NULL, 986, 0, '', '', '', 'Brandstof', 46.07);
INSERT INTO boekregels VALUES (987, 189, 2013, '2013-03-23', 4410, NULL, 988, 0, '', '', '', 'Brandstof', 25.87);
INSERT INTO boekregels VALUES (991, 189, 2013, '2013-03-24', 4410, NULL, 992, 0, '', '', '', 'Brandstof', 30.94);
INSERT INTO boekregels VALUES (993, 189, 2013, '2013-03-28', 4410, NULL, 994, 0, '', '', '', 'Brandstof', 25.03);
INSERT INTO boekregels VALUES (1076, 214, 2013, '2013-04-02', 4410, NULL, 1077, 0, '', '', '', 'Brandstof Opel', 44.69);
INSERT INTO boekregels VALUES (1084, 214, 2013, '2013-04-11', 4410, NULL, 1085, 0, '', '', '', 'Brandstof Opel', 55.44);
INSERT INTO boekregels VALUES (1088, 214, 2013, '2013-04-18', 4410, NULL, 1089, 0, '', '', '', 'Brandstof Opel', 37.79);
INSERT INTO boekregels VALUES (1092, 214, 2013, '2013-04-25', 4410, NULL, 1093, 0, '', '', '', 'Brandstof Opel', 10.01);
INSERT INTO boekregels VALUES (1094, 214, 2013, '2013-04-26', 4410, NULL, 1095, 0, '', '', '', 'Brandstof Opel', 46.90);
INSERT INTO boekregels VALUES (1099, 215, 2013, '2013-05-02', 4410, NULL, 1100, 0, '', '', '', 'Brandstof Opel', 45.43);
INSERT INTO boekregels VALUES (1105, 215, 2013, '2013-05-06', 4410, NULL, 1106, 0, '', '', '', 'Brandstof Opel', 36.83);
INSERT INTO boekregels VALUES (1107, 215, 2013, '2013-05-13', 4410, NULL, 1108, 0, '', '', '', 'Brandstof Opel', 49.33);
INSERT INTO boekregels VALUES (1109, 215, 2013, '2013-05-19', 4410, NULL, 1110, 0, '', '', '', 'Brandstof Opel', 39.85);
INSERT INTO boekregels VALUES (1135, 215, 2013, '2013-05-29', 4410, NULL, 1136, 0, '', '', '', 'Brandstof Opel', 43.49);
INSERT INTO boekregels VALUES (1140, 216, 2013, '2013-06-02', 4410, NULL, 1141, 0, '', '', '', 'Brandstof Opel', 41.35);
INSERT INTO boekregels VALUES (1144, 216, 2013, '2013-06-10', 4410, NULL, 1145, 0, '', '', '', 'Brandstof Opel', 16.86);
INSERT INTO boekregels VALUES (1146, 216, 2013, '2013-06-19', 4410, NULL, 1147, 0, '', '', '', 'Brandstof Opel', 37.22);
INSERT INTO boekregels VALUES (1151, 216, 2013, '2013-06-29', 4410, NULL, 1152, 0, '', '', '', 'Brandstof Opel', 51.34);
INSERT INTO boekregels VALUES (869, 174, 2013, '2013-03-11', 4420, NULL, 0, 0, 'vandien', '16216131', '', 'Verzekering Opel Combo', 129.25);
INSERT INTO boekregels VALUES (1053, 206, 2013, '2013-07-11', 4420, NULL, 0, 0, 'vandien', '16546675', '', 'Verzekering Opel 11-7/11-10', 129.25);
INSERT INTO boekregels VALUES (975, 189, 2013, '2013-03-03', 4440, NULL, 976, 0, '', '', '', 'Olie en spons', 9.01);
INSERT INTO boekregels VALUES (1067, 211, 2013, '2013-06-26', 4440, NULL, 1068, 0, 'kbaudio', '100007363', '', 'Audio in auto', 99.13);
INSERT INTO boekregels VALUES (1073, 213, 2013, '2013-06-28', 4440, NULL, 1074, 0, 'profile', 'M10087057', '', 'Banden Nissan', 574.38);
INSERT INTO boekregels VALUES (1075, 214, 2013, '2013-04-01', 4440, NULL, 0, 0, '', '', '', 'stuurbekleding', 40.00);
INSERT INTO boekregels VALUES (1227, 217, 2013, '2013-06-10', 4440, NULL, 1228, 0, 'koops', '63700647', '', 'Aanschafkosten Nissan Nv200 5-VKH-50', 639.67);
INSERT INTO boekregels VALUES (813, 155, 2013, '2013-01-02', 5010, NULL, 814, 0, 'kramer', '21957039', '', 'Spuitmateriaal', 146.61);
INSERT INTO boekregels VALUES (816, 156, 2013, '2013-01-07', 5010, NULL, 817, 0, 'tshirts', '7240', '', 'T-shirts voor bedrukking', 90.15);
INSERT INTO boekregels VALUES (819, 157, 2013, '2013-01-11', 5010, NULL, 820, 0, 'kramer', '57141', '', 'Spuitmateriaal', 205.29);
INSERT INTO boekregels VALUES (831, 161, 2013, '2013-01-29', 5010, NULL, 832, 0, 'kramer', '57222', '', 'Spuitmateriaal', 196.28);
INSERT INTO boekregels VALUES (834, 162, 2013, '2013-02-01', 5010, NULL, 835, 0, 'uc', 'RLZ-1063', '', 'Montana spuitmateriaal', 85.04);
INSERT INTO boekregels VALUES (837, 163, 2013, '2013-02-07', 5010, NULL, 838, 0, 'stoffen', '201300326', '', 'Kaasdoek 280cm breed', 40.22);
INSERT INTO boekregels VALUES (843, 165, 2013, '2013-02-15', 5010, NULL, 844, 0, 'claasen', '762144', '', 'Morsverf latex', 118.50);
INSERT INTO boekregels VALUES (855, 169, 2013, '2013-03-05', 5010, NULL, 856, 0, 'vanbeek', '920615', '', 'Molotow refill', 12.58);
INSERT INTO boekregels VALUES (858, 170, 2013, '2013-03-05', 5010, NULL, 859, 0, 'claasen', '763690', '', 'Morsverf latex', 39.50);
INSERT INTO boekregels VALUES (866, 173, 2013, '2013-03-08', 5010, NULL, 867, 0, 'kramer', 'HE90214', '', 'Spuitmateriaal', 250.12);
INSERT INTO boekregels VALUES (876, 177, 2013, '2013-03-25', 5010, NULL, 877, 0, 'coating', '1303001', '', 'AGP 500', 116.50);
INSERT INTO boekregels VALUES (979, 189, 2013, '2013-03-11', 5010, NULL, 980, 0, '', '', '', 'Schildersdoeken', 39.64);
INSERT INTO boekregels VALUES (1013, 192, 2013, '2013-04-01', 5010, NULL, 1014, 0, 'vend', '114345373', '', 'Schildersdoek 120x160', 198.35);
INSERT INTO boekregels VALUES (1037, 200, 2013, '2013-05-04', 5010, NULL, 1038, 0, 'vanbeek', '947244', '', 'Doeken en tekenmaterialen', 76.24);
INSERT INTO boekregels VALUES (1104, 215, 2013, '2013-05-04', 5010, NULL, 0, 0, '', '', '', 'Schildersdoek', 47.97);
INSERT INTO boekregels VALUES (1119, 215, 2013, '2013-05-25', 5010, NULL, 0, 0, '', '', '', 'Schildersdoek', 31.98);
INSERT INTO boekregels VALUES (1131, 215, 2013, '2013-05-29', 5010, NULL, 1132, 0, '', '', '', 'Latex en kwasten', 54.77);
INSERT INTO boekregels VALUES (1133, 215, 2013, '2013-05-29', 5010, NULL, 1134, 0, '', '', '', 'Voorstrijk en roller', 91.50);
INSERT INTO boekregels VALUES (2090, 400, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Correctiebedrag BTW naar verrekening', 1.73);
INSERT INTO boekregels VALUES (2092, 400, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding Correctiebedrag BTW naar verrekening', 0.27);
INSERT INTO boekregels VALUES (2101, 402, 2013, '2013-07-10', 2200, NULL, 0, 0, 'kramer', 'HE91472', '', 'Spuitmateriaal', 68.03);
INSERT INTO boekregels VALUES (2100, 402, 2013, '2013-07-10', 5010, NULL, 2101, 0, 'kramer', 'HE91472', '', 'Spuitmateriaal', 323.97);
INSERT INTO boekregels VALUES (2102, 403, 2013, '2013-07-31', 1600, NULL, 0, 0, 'betaalbaar', '201314642', '', 'Ladder', -87.90);
INSERT INTO boekregels VALUES (2104, 403, 2013, '2013-07-31', 2200, NULL, 0, 0, 'betaalbaar', '201314642', '', 'Ladder', 15.26);
INSERT INTO boekregels VALUES (2103, 403, 2013, '2013-07-31', 4220, NULL, 2104, 0, 'betaalbaar', '201314642', '', 'Ladder', 72.64);
INSERT INTO boekregels VALUES (2106, 404, 2013, '2013-07-03', 2200, NULL, 0, 0, '', '', '', 'Lijm en klemmen', 1.92);
INSERT INTO boekregels VALUES (2105, 404, 2013, '2013-07-03', 4220, NULL, 2106, 0, '', '', '', 'Lijm en klemmen', 9.17);
INSERT INTO boekregels VALUES (2108, 404, 2013, '2013-07-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.93);
INSERT INTO boekregels VALUES (2107, 404, 2013, '2013-07-04', 4410, NULL, 2108, 0, '', '', '', 'Brandstof Nissan', 47.27);
INSERT INTO boekregels VALUES (2110, 404, 2013, '2013-07-08', 2200, NULL, 0, 0, '', '', '', 'Parkeren fotosessie', 0.73);
INSERT INTO boekregels VALUES (2109, 404, 2013, '2013-07-08', 4290, NULL, 2110, 0, '', '', '', 'Parkeren fotosessie', 3.47);
INSERT INTO boekregels VALUES (2112, 404, 2013, '2013-07-09', 2200, NULL, 0, 0, '', '', '', 'Snijfolier', 1.96);
INSERT INTO boekregels VALUES (2111, 404, 2013, '2013-07-09', 4220, NULL, 2112, 0, '', '', '', 'Snijfolier', 9.33);
INSERT INTO boekregels VALUES (2114, 404, 2013, '2013-07-11', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschriften', 0.73);
INSERT INTO boekregels VALUES (2113, 404, 2013, '2013-07-11', 4230, NULL, 2114, 0, '', '', '', 'Vaktijdschriften', 12.21);
INSERT INTO boekregels VALUES (2116, 404, 2013, '2013-07-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.81);
INSERT INTO boekregels VALUES (2115, 404, 2013, '2013-07-15', 4410, NULL, 2116, 0, '', '', '', 'Brandstof Nissan', 27.65);
INSERT INTO boekregels VALUES (2118, 404, 2013, '2013-07-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.34);
INSERT INTO boekregels VALUES (2117, 404, 2013, '2013-07-17', 4410, NULL, 2118, 0, '', '', '', 'Brandstof Nissan', 53.99);
INSERT INTO boekregels VALUES (2120, 404, 2013, '2013-07-17', 2200, NULL, 0, 0, '', '', '', 'Werkbespreking', 2.11);
INSERT INTO boekregels VALUES (2119, 404, 2013, '2013-07-17', 4290, NULL, 2120, 0, '', '', '', 'Werkbespreking', 27.84);
INSERT INTO boekregels VALUES (2122, 404, 2013, '2013-07-27', 2200, NULL, 0, 0, '', '', '', 'Schroefogen', 1.59);
INSERT INTO boekregels VALUES (2121, 404, 2013, '2013-07-27', 4220, NULL, 2122, 0, '', '', '', 'Schroefogen', 7.57);
INSERT INTO boekregels VALUES (2124, 404, 2013, '2013-07-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.60);
INSERT INTO boekregels VALUES (2123, 404, 2013, '2013-07-27', 4410, NULL, 2124, 0, '', '', '', 'Brandstof Nissan', 50.45);
INSERT INTO boekregels VALUES (2126, 404, 2013, '2013-07-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.52);
INSERT INTO boekregels VALUES (2125, 404, 2013, '2013-07-29', 4410, NULL, 2126, 0, '', '', '', 'Brandstof Nissan', 50.11);
INSERT INTO boekregels VALUES (2128, 404, 2013, '2013-07-30', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal en rollers', 11.04);
INSERT INTO boekregels VALUES (2127, 404, 2013, '2013-07-30', 5010, NULL, 2128, 0, '', '', '', 'Plaatmateriaal en rollers', 52.57);
INSERT INTO boekregels VALUES (2129, 404, 2013, '2013-07-31', 4250, NULL, 0, 0, '', '', '', 'Pakketkosten', 13.50);
INSERT INTO boekregels VALUES (2130, 404, 2013, '2013-07-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 07 2013', -433.41);
INSERT INTO boekregels VALUES (2132, 405, 2013, '2013-07-22', 2200, NULL, 0, 0, '', '', '', 'Brandstof hogedrukspuit', 1.26);
INSERT INTO boekregels VALUES (2131, 405, 2013, '2013-07-22', 4290, NULL, 2132, 0, '', '', '', 'Brandstof hogedrukspuit', 6.02);
INSERT INTO boekregels VALUES (2134, 405, 2013, '2013-08-02', 2200, NULL, 0, 0, '', '', '', 'Montagemateriaal', 12.04);
INSERT INTO boekregels VALUES (2133, 405, 2013, '2013-08-02', 4220, NULL, 2134, 0, '', '', '', 'Montagemateriaal', 57.33);
INSERT INTO boekregels VALUES (2136, 405, 2013, '2013-08-06', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (2135, 405, 2013, '2013-08-06', 4230, NULL, 2136, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (2138, 405, 2013, '2013-08-08', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.29);
INSERT INTO boekregels VALUES (2137, 405, 2013, '2013-08-08', 4410, NULL, 2138, 0, '', '', '', 'Brandstof Nissan', 29.95);
INSERT INTO boekregels VALUES (2140, 405, 2013, '2013-08-13', 2200, NULL, 0, 0, '', '', '', 'Montagemateriaal', 1.91);
INSERT INTO boekregels VALUES (2139, 405, 2013, '2013-08-13', 4220, NULL, 2140, 0, '', '', '', 'Montagemateriaal', 9.09);
INSERT INTO boekregels VALUES (2142, 405, 2013, '2013-08-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.84);
INSERT INTO boekregels VALUES (2141, 405, 2013, '2013-08-17', 4410, NULL, 2142, 0, '', '', '', 'Brandstof Nissan', 46.88);
INSERT INTO boekregels VALUES (2144, 405, 2013, '2013-08-10', 2200, NULL, 0, 0, '', '', '', 'Afdrukpapier', 6.07);
INSERT INTO boekregels VALUES (2143, 405, 2013, '2013-08-10', 4220, NULL, 2144, 0, '', '', '', 'Afdrukpapier', 28.88);
INSERT INTO boekregels VALUES (2146, 405, 2013, '2013-08-22', 2200, NULL, 0, 0, '', '', '', 'Brandstof hogedrukspuit', 1.50);
INSERT INTO boekregels VALUES (2145, 405, 2013, '2013-08-22', 4290, NULL, 2146, 0, '', '', '', 'Brandstof hogedrukspuit', 7.13);
INSERT INTO boekregels VALUES (2148, 405, 2013, '2013-08-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.21);
INSERT INTO boekregels VALUES (2147, 405, 2013, '2013-08-24', 4410, NULL, 2148, 0, '', '', '', 'Brandstof Nissan', 48.61);
INSERT INTO boekregels VALUES (2150, 405, 2013, '2013-08-26', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO boekregels VALUES (2149, 405, 2013, '2013-08-26', 4230, NULL, 2150, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO boekregels VALUES (2152, 405, 2013, '2013-08-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.48);
INSERT INTO boekregels VALUES (2151, 405, 2013, '2013-08-29', 4410, NULL, 2152, 0, '', '', '', 'Brandstof Nissan', 45.13);
INSERT INTO boekregels VALUES (2153, 405, 2013, '2013-08-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 08 2013', -350.06);
INSERT INTO boekregels VALUES (2155, 406, 2013, '2013-09-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.83);
INSERT INTO boekregels VALUES (2154, 406, 2013, '2013-09-09', 4410, NULL, 2155, 0, '', '', '', 'Brandstof Nissan', 56.31);
INSERT INTO boekregels VALUES (2157, 406, 2013, '2013-09-11', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (2156, 406, 2013, '2013-09-11', 4230, NULL, 2157, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (2159, 406, 2013, '2013-09-14', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 6.95);
INSERT INTO boekregels VALUES (2158, 406, 2013, '2013-09-14', 5010, NULL, 2159, 0, '', '', '', 'Schildersdoek', 33.07);
INSERT INTO boekregels VALUES (2161, 406, 2013, '2013-09-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.99);
INSERT INTO boekregels VALUES (2160, 406, 2013, '2013-09-16', 4410, NULL, 2161, 0, '', '', '', 'Brandstof Nissan', 52.34);
INSERT INTO boekregels VALUES (2163, 406, 2013, '2013-09-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.83);
INSERT INTO boekregels VALUES (2162, 406, 2013, '2013-09-25', 4410, NULL, 2163, 0, '', '', '', 'Brandstof Nissan', 51.59);
INSERT INTO boekregels VALUES (2164, 406, 2013, '2013-09-26', 4250, NULL, 0, 0, '', '', '', 'Portikosten', 2.99);
INSERT INTO boekregels VALUES (2167, 408, 2013, '2013-08-05', 1600, NULL, 0, 0, '123inkt', '4078023', '', 'Inktcartridges', -57.45);
INSERT INTO boekregels VALUES (2169, 408, 2013, '2013-08-05', 2200, NULL, 0, 0, '123inkt', '4078023', '', 'Inktcartridges', 9.97);
INSERT INTO boekregels VALUES (2168, 408, 2013, '2013-08-05', 4230, NULL, 2169, 0, '123inkt', '4078023', '', 'Inktcartridges', 47.48);
INSERT INTO boekregels VALUES (2170, 409, 2013, '2013-08-09', 1600, NULL, 0, 0, 'engelb', '260590', '', 'Spuitmaskers', -216.59);
INSERT INTO boekregels VALUES (2172, 409, 2013, '2013-08-09', 2200, NULL, 0, 0, 'engelb', '260590', '', 'Spuitmaskers', 37.59);
INSERT INTO boekregels VALUES (2171, 409, 2013, '2013-08-09', 4220, NULL, 2172, 0, 'engelb', '260590', '', 'Spuitmaskers', 179.00);
INSERT INTO boekregels VALUES (2173, 410, 2013, '2013-08-13', 1600, NULL, 0, 0, 'kramer', 'HE91752', '', 'Spuitmateriaal', -399.60);
INSERT INTO boekregels VALUES (2175, 410, 2013, '2013-08-13', 2200, NULL, 0, 0, 'kramer', 'HE91752', '', 'Spuitmateriaal', 69.35);
INSERT INTO boekregels VALUES (2165, 407, 2013, '2013-07-08', 1600, NULL, 0, 0, 'belasting', '694.14.993M3.5', '', 'Motorrijtuigenbelasting Nissan 25-06/16-08', -46.00);
INSERT INTO boekregels VALUES (2174, 410, 2013, '2013-08-13', 5010, NULL, 2175, 0, 'kramer', 'HE91752', '', 'Spuitmateriaal', 330.25);
INSERT INTO boekregels VALUES (2176, 411, 2013, '2013-08-14', 1600, NULL, 0, 0, 'kruiz', '4027148', '', 'Stapelkratten', -68.63);
INSERT INTO boekregels VALUES (2178, 411, 2013, '2013-08-14', 2200, NULL, 0, 0, 'kruiz', '4027148', '', 'Stapelkratten', 11.91);
INSERT INTO boekregels VALUES (2177, 411, 2013, '2013-08-14', 4220, NULL, 2178, 0, 'kruiz', '4027148', '', 'Stapelkratten', 56.72);
INSERT INTO boekregels VALUES (2179, 412, 2013, '2013-08-19', 1600, NULL, 0, 0, 'belasting', '694.14.993.M.3.7', '', 'Motorrijtuigenbelasting Nissan 17-8/16-11', -78.00);
INSERT INTO boekregels VALUES (2181, 413, 2013, '2013-08-19', 1600, NULL, 0, 0, 'vanbeek', '986655', '', 'Acrylverf', -36.24);
INSERT INTO boekregels VALUES (2183, 413, 2013, '2013-08-19', 2200, NULL, 0, 0, 'vanbeek', '986655', '', 'Acrylverf', 6.29);
INSERT INTO boekregels VALUES (2182, 413, 2013, '2013-08-19', 5010, NULL, 2183, 0, 'vanbeek', '986655', '', 'Acrylverf', 29.95);
INSERT INTO boekregels VALUES (2184, 414, 2013, '2013-08-28', 1600, NULL, 0, 0, 'wadcult', '28082013', '', 'Kraamhuur 21 sept', -20.00);
INSERT INTO boekregels VALUES (2185, 414, 2013, '2013-08-28', 4310, NULL, 0, 0, 'wadcult', '28082013', '', 'Kraamhuur 21 sept', 20.00);
INSERT INTO boekregels VALUES (2186, 415, 2013, '2013-09-09', 1600, NULL, 0, 0, 'kramer', 'HE91992', '', 'Spuitmateriaal', -295.20);
INSERT INTO boekregels VALUES (2188, 415, 2013, '2013-09-09', 2200, NULL, 0, 0, 'kramer', 'HE91992', '', 'Spuitmateriaal', 51.23);
INSERT INTO boekregels VALUES (2187, 415, 2013, '2013-09-09', 5010, NULL, 2188, 0, 'kramer', 'HE91992', '', 'Spuitmateriaal', 243.97);
INSERT INTO boekregels VALUES (2189, 416, 2013, '2013-09-12', 1600, NULL, 0, 0, 'marktplaats', 'MPDI130905301', '', 'Advertenties', -24.00);
INSERT INTO boekregels VALUES (2191, 416, 2013, '2013-09-12', 2200, NULL, 0, 0, 'marktplaats', 'MPDI130905301', '', 'Advertenties', 4.17);
INSERT INTO boekregels VALUES (2190, 416, 2013, '2013-09-12', 4310, NULL, 2191, 0, 'marktplaats', 'MPDI130905301', '', 'Advertenties', 19.83);
INSERT INTO boekregels VALUES (2192, 417, 2013, '2013-09-20', 1600, NULL, 0, 0, 'altern', '424156643', '', 'Computermaterialen', -172.85);
INSERT INTO boekregels VALUES (2194, 417, 2013, '2013-09-20', 2200, NULL, 0, 0, 'altern', '424156643', '', 'Computermaterialen', 30.00);
INSERT INTO boekregels VALUES (2193, 417, 2013, '2013-09-20', 4230, NULL, 2194, 0, 'altern', '424156643', '', 'Computermaterialen', 142.85);
INSERT INTO boekregels VALUES (2195, 418, 2013, '2013-09-21', 1600, NULL, 0, 0, 'groenec', '82599', '', 'Computermateriaal', -25.00);
INSERT INTO boekregels VALUES (2197, 418, 2013, '2013-09-21', 2200, NULL, 0, 0, 'groenec', '82599', '', 'Computermateriaal', 4.34);
INSERT INTO boekregels VALUES (2196, 418, 2013, '2013-09-21', 4230, NULL, 2197, 0, 'groenec', '82599', '', 'Computermateriaal', 20.66);
INSERT INTO boekregels VALUES (2198, 419, 2013, '2013-09-22', 1600, NULL, 0, 0, 'mycom', '2209', '', 'Computermateriaal geheugen', -149.99);
INSERT INTO boekregels VALUES (2199, 419, 2013, '2013-09-22', 4230, NULL, 2200, 0, 'mycom', '2209', '', 'Computermateriaal geheugen', 123.96);
INSERT INTO boekregels VALUES (2200, 419, 2013, '2013-09-22', 2200, NULL, 0, 0, 'mycom', '2209', '', 'Computermateriaal geheugen', 26.03);
INSERT INTO boekregels VALUES (2201, 420, 2013, '2013-09-30', 1600, NULL, 0, 0, 'altern', '224158711', '', 'Computermateriaal koeling', -19.99);
INSERT INTO boekregels VALUES (2203, 420, 2013, '2013-09-30', 2200, NULL, 0, 0, 'altern', '224158711', '', 'Computermateriaal koeling', 3.47);
INSERT INTO boekregels VALUES (2202, 420, 2013, '2013-09-30', 4230, NULL, 2203, 0, 'altern', '224158711', '', 'Computermateriaal koeling', 16.52);
INSERT INTO boekregels VALUES (2204, 421, 2013, '2013-09-30', 1600, NULL, 0, 0, 'altern', '224158708', '', 'Computermateriaal SSD schijf', -311.01);
INSERT INTO boekregels VALUES (2206, 421, 2013, '2013-09-30', 2200, NULL, 0, 0, 'altern', '224158708', '', 'Computermateriaal SSD schijf', 53.98);
INSERT INTO boekregels VALUES (2205, 421, 2013, '2013-09-30', 4230, NULL, 2206, 0, 'altern', '224158708', '', 'Computermateriaal SSD schijf', 257.03);
INSERT INTO boekregels VALUES (2207, 422, 2013, '2013-07-18', 1600, NULL, 0, 0, 'tmobile', '901195252861', '', 'T-Mobile 16-7/15-8', -24.78);
INSERT INTO boekregels VALUES (2209, 422, 2013, '2013-07-18', 2200, NULL, 0, 0, 'tmobile', '901195252861', '', 'T-Mobile 16-7/15-8', 4.30);
INSERT INTO boekregels VALUES (2208, 422, 2013, '2013-07-18', 4240, NULL, 2209, 0, 'tmobile', '901195252861', '', 'T-Mobile 16-7/15-8', 20.48);
INSERT INTO boekregels VALUES (2210, 423, 2013, '2013-08-20', 1600, NULL, 0, 0, 'tmobile', '901197517004', '', 'T-Mobile 16-8/15-9', -24.78);
INSERT INTO boekregels VALUES (2212, 423, 2013, '2013-08-20', 2200, NULL, 0, 0, 'tmobile', '901197517004', '', 'T-Mobile 16-8/15-9', 4.30);
INSERT INTO boekregels VALUES (2211, 423, 2013, '2013-08-20', 4240, NULL, 2212, 0, 'tmobile', '901197517004', '', 'T-Mobile 16-8/15-9', 20.48);
INSERT INTO boekregels VALUES (2213, 424, 2013, '2013-09-18', 1600, NULL, 0, 0, 'tmobile', '901199780567', '', 'T-Mobile 16-9/15-10', -24.78);
INSERT INTO boekregels VALUES (2215, 424, 2013, '2013-09-18', 2200, NULL, 0, 0, 'tmobile', '901199780567', '', 'T-Mobile 16-9/15-10', 4.30);
INSERT INTO boekregels VALUES (2214, 424, 2013, '2013-09-18', 4240, NULL, 2215, 0, 'tmobile', '901199780567', '', 'T-Mobile 16-9/15-10', 20.48);
INSERT INTO boekregels VALUES (2216, 425, 2013, '2013-09-09', 1600, NULL, 0, 0, 'publikat', 'RE1087838', '', 'Molotow spuitmateriaal', -331.80);
INSERT INTO boekregels VALUES (2218, 425, 2013, '2013-09-09', 2200, NULL, 0, 0, 'publikat', 'RE1087838', '', 'Molotow spuitmateriaal', 57.59);
INSERT INTO boekregels VALUES (2217, 425, 2013, '2013-09-09', 5010, NULL, 2218, 0, 'publikat', 'RE1087838', '', 'Molotow spuitmateriaal', 274.21);
INSERT INTO boekregels VALUES (2219, 426, 2013, '2013-09-24', 1600, NULL, 0, 0, 'molotow', '145800', '', 'Molotow spuitmateriaal Duitsland', -141.02);
INSERT INTO boekregels VALUES (2221, 426, 2013, '2013-09-24', 2240, NULL, 0, 0, 'molotow', '145800', '', 'Molotow spuitmateriaal Duitsland', 29.61);
INSERT INTO boekregels VALUES (2220, 426, 2013, '2013-09-24', 5015, NULL, 2221, 0, 'molotow', '145800', '', 'Molotow spuitmateriaal Duitsland', 141.02);
INSERT INTO boekregels VALUES (2222, 426, 2013, '2013-09-24', 2140, NULL, 0, 0, 'molotow', '145800', '', 'Molotow spuitmateriaal Duitsland', -29.61);
INSERT INTO boekregels VALUES (2223, 427, 2013, '2013-07-02', 1200, NULL, 0, 0, 'ipse', '2013020', '', 'Muurschildering Beatles', 484.30);
INSERT INTO boekregels VALUES (2225, 427, 2013, '2013-07-02', 2110, NULL, 0, 0, 'ipse', '2013020', '', 'Muurschildering Beatles', -84.05);
INSERT INTO boekregels VALUES (2224, 427, 2013, '2013-07-02', 8060, NULL, 2225, 0, 'ipse', '2013020', '', 'Muurschildering Beatles', -400.25);
INSERT INTO boekregels VALUES (2226, 428, 2013, '2013-07-02', 1200, NULL, 0, 0, 'quawonen', '201321', '', 'Muurschildering poorten icm workshop', 677.60);
INSERT INTO boekregels VALUES (2228, 428, 2013, '2013-07-02', 2110, NULL, 0, 0, 'quawonen', '201321', '', 'Muurschildering poorten icm workshop', -117.60);
INSERT INTO boekregels VALUES (2227, 428, 2013, '2013-07-02', 8070, NULL, 2228, 0, 'quawonen', '201321', '', 'Muurschildering poorten icm workshop', -560.00);
INSERT INTO boekregels VALUES (2229, 429, 2013, '2013-07-02', 1200, NULL, 0, 0, 'hockey', '2013022', '', 'Graffitiworkshop container', 393.25);
INSERT INTO boekregels VALUES (2231, 429, 2013, '2013-07-02', 2110, NULL, 0, 0, 'hockey', '2013022', '', 'Graffitiworkshop container', -68.25);
INSERT INTO boekregels VALUES (2230, 429, 2013, '2013-07-02', 8110, NULL, 2231, 0, 'hockey', '2013022', '', 'Graffitiworkshop container', -325.00);
INSERT INTO boekregels VALUES (2232, 430, 2013, '2013-07-05', 1200, NULL, 0, 0, 'dadanza', '2013023', '', 'Schilderij danseres', 242.00);
INSERT INTO boekregels VALUES (2234, 430, 2013, '2013-07-05', 2110, NULL, 0, 0, 'dadanza', '2013023', '', 'Schilderij danseres', -42.00);
INSERT INTO boekregels VALUES (2233, 430, 2013, '2013-07-05', 8075, NULL, 2234, 0, 'dadanza', '2013023', '', 'Schilderij danseres', -200.00);
INSERT INTO boekregels VALUES (2235, 431, 2013, '2013-07-27', 1200, NULL, 0, 0, 'ppannekoek', '2013024', '', 'Muurschilderingen restaurant', 1458.05);
INSERT INTO boekregels VALUES (2237, 431, 2013, '2013-07-27', 2110, NULL, 0, 0, 'ppannekoek', '2013024', '', 'Muurschilderingen restaurant', -253.05);
INSERT INTO boekregels VALUES (2236, 431, 2013, '2013-07-27', 8070, NULL, 2237, 0, 'ppannekoek', '2013024', '', 'Muurschilderingen restaurant', -1205.00);
INSERT INTO boekregels VALUES (2238, 432, 2013, '2013-08-25', 1200, NULL, 0, 0, 'bomenwijk', '2013025', '', 'Restant Alexandertunnel', 3714.58);
INSERT INTO boekregels VALUES (2240, 432, 2013, '2013-08-25', 2110, NULL, 0, 0, 'bomenwijk', '2013025', '', 'Restant Alexandertunnel', -644.68);
INSERT INTO boekregels VALUES (2239, 432, 2013, '2013-08-25', 8070, NULL, 2240, 0, 'bomenwijk', '2013025', '', 'Restant Alexandertunnel', -3069.90);
INSERT INTO boekregels VALUES (2241, 433, 2013, '2013-08-30', 1200, NULL, 0, 0, 'ipse', '2013026', '', 'Muurschildering paarden', 330.94);
INSERT INTO boekregels VALUES (2243, 433, 2013, '2013-08-30', 2110, NULL, 0, 0, 'ipse', '2013026', '', 'Muurschildering paarden', -57.44);
INSERT INTO boekregels VALUES (2242, 433, 2013, '2013-08-30', 8060, NULL, 2243, 0, 'ipse', '2013026', '', 'Muurschildering paarden', -273.50);
INSERT INTO boekregels VALUES (2244, 434, 2013, '2013-09-05', 1200, NULL, 0, 0, 'ppannekoek', '2013027', '', 'Muurschildering BigBen', 199.65);
INSERT INTO boekregels VALUES (2246, 434, 2013, '2013-09-05', 2110, NULL, 0, 0, 'ppannekoek', '2013027', '', 'Muurschildering BigBen', -34.65);
INSERT INTO boekregels VALUES (2245, 434, 2013, '2013-09-05', 8070, NULL, 2246, 0, 'ppannekoek', '2013027', '', 'Muurschildering BigBen', -165.00);
INSERT INTO boekregels VALUES (2247, 435, 2013, '2013-09-23', 1200, NULL, 0, 0, 'nsveiligh', '2013028', '', 'Presentatie graffiti', 60.50);
INSERT INTO boekregels VALUES (2249, 435, 2013, '2013-09-23', 2110, NULL, 0, 0, 'nsveiligh', '2013028', '', 'Presentatie graffiti', -10.50);
INSERT INTO boekregels VALUES (2248, 435, 2013, '2013-09-23', 8190, NULL, 2249, 0, 'nsveiligh', '2013028', '', 'Presentatie graffiti', -50.00);
INSERT INTO boekregels VALUES (2250, 406, 2013, '2013-09-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 09 2013', -243.35);
INSERT INTO boekregels VALUES (2252, 436, 2013, '2013-07-06', 2110, NULL, 0, 0, '', '', '', 'Prinsessen Papendrecht', -13.02);
INSERT INTO boekregels VALUES (2251, 436, 2013, '2013-07-06', 8060, NULL, 2252, 0, '', '', '', 'Prinsessen Papendrecht', -61.98);
INSERT INTO boekregels VALUES (2254, 436, 2013, '2013-07-13', 2110, NULL, 0, 0, '', '', '', 'Workshop Hof Hazerswoude', -18.22);
INSERT INTO boekregels VALUES (2253, 436, 2013, '2013-07-13', 8110, NULL, 2254, 0, '', '', '', 'Workshop Hof Hazerswoude', -86.78);
INSERT INTO boekregels VALUES (2256, 436, 2013, '2013-07-16', 2110, NULL, 0, 0, '', '', '', 'Graffiti Duncan', -23.43);
INSERT INTO boekregels VALUES (2255, 436, 2013, '2013-07-16', 8060, NULL, 2256, 0, '', '', '', 'Graffiti Duncan', -111.57);
INSERT INTO boekregels VALUES (2258, 436, 2013, '2013-08-06', 2110, NULL, 0, 0, '', '', '', 'JungleBook Zoetermeer', -17.36);
INSERT INTO boekregels VALUES (2257, 436, 2013, '2013-08-06', 8060, NULL, 2258, 0, '', '', '', 'JungleBook Zoetermeer', -82.64);
INSERT INTO boekregels VALUES (2260, 436, 2013, '2013-08-17', 2110, NULL, 0, 0, '', '', '', 'Kaene Rotterdam', -23.43);
INSERT INTO boekregels VALUES (2259, 436, 2013, '2013-08-17', 8060, NULL, 2260, 0, '', '', '', 'Kaene Rotterdam', -111.57);
INSERT INTO boekregels VALUES (2262, 436, 2013, '2013-08-27', 2110, NULL, 0, 0, '', '', '', 'Graffiti Jori Nijmegen', -17.36);
INSERT INTO boekregels VALUES (2261, 436, 2013, '2013-08-27', 8060, NULL, 2262, 0, '', '', '', 'Graffiti Jori Nijmegen', -82.64);
INSERT INTO boekregels VALUES (2264, 436, 2013, '2013-09-08', 2110, NULL, 0, 0, '', '', '', 'Workshop Hof Hazerswoude', -13.02);
INSERT INTO boekregels VALUES (2263, 436, 2013, '2013-09-08', 8110, NULL, 2264, 0, '', '', '', 'Workshop Hof Hazerswoude', -61.98);
INSERT INTO boekregels VALUES (2266, 436, 2013, '2013-09-29', 2110, NULL, 0, 0, '', '', '', 'Hello Kitty Rotterdam', -17.36);
INSERT INTO boekregels VALUES (2265, 436, 2013, '2013-09-29', 8060, NULL, 2266, 0, '', '', '', 'Hello Kitty Rotterdam', -82.64);
INSERT INTO boekregels VALUES (2267, 436, 2013, '2013-09-29', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 3e kwartaal', 825.00);
INSERT INTO boekregels VALUES (2268, 437, 2013, '2013-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 1455.42);
INSERT INTO boekregels VALUES (2269, 437, 2013, '2013-09-30', 2140, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 29.61);
INSERT INTO boekregels VALUES (2270, 437, 2013, '2013-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -513.00);
INSERT INTO boekregels VALUES (2271, 437, 2013, '2013-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -117.67);
INSERT INTO boekregels VALUES (2272, 437, 2013, '2013-09-30', 2240, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -29.61);
INSERT INTO boekregels VALUES (2273, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -1455.42);
INSERT INTO boekregels VALUES (2274, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.42);
INSERT INTO boekregels VALUES (2275, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2140', -29.61);
INSERT INTO boekregels VALUES (2276, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 4b', -0.39);
INSERT INTO boekregels VALUES (2277, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2240', 29.61);
INSERT INTO boekregels VALUES (2278, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 117.67);
INSERT INTO boekregels VALUES (2279, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 513.00);
INSERT INTO boekregels VALUES (2280, 437, 2013, '2013-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.28);
INSERT INTO boekregels VALUES (2281, 437, 2013, '2013-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.42);
INSERT INTO boekregels VALUES (2282, 437, 2013, '2013-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 4b', 0.39);
INSERT INTO boekregels VALUES (2283, 437, 2013, '2013-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.28);
INSERT INTO boekregels VALUES (2284, 438, 2013, '2013-11-22', 1200, NULL, 0, 0, 'jaguacy', '2013029', '', 'Muurschildering Logo', 302.50);
INSERT INTO boekregels VALUES (2286, 438, 2013, '2013-11-22', 2110, NULL, 0, 0, 'jaguacy', '2013029', '', 'Muurschildering Logo', -52.50);
INSERT INTO boekregels VALUES (2285, 438, 2013, '2013-11-22', 8070, NULL, 2286, 0, 'jaguacy', '2013029', '', 'Muurschildering Logo', -250.00);
INSERT INTO boekregels VALUES (2287, 439, 2013, '2013-11-29', 1200, NULL, 0, 0, 'stolwijk', '2013030', '', 'Muurschildering graffiti project', 290.40);
INSERT INTO boekregels VALUES (2289, 439, 2013, '2013-11-29', 2110, NULL, 0, 0, 'stolwijk', '2013030', '', 'Muurschildering graffiti project', -50.40);
INSERT INTO boekregels VALUES (2288, 439, 2013, '2013-11-29', 8070, NULL, 2289, 0, 'stolwijk', '2013030', '', 'Muurschildering graffiti project', -240.00);
INSERT INTO boekregels VALUES (2290, 440, 2013, '2013-12-18', 1200, NULL, 0, 0, 'krimpen', '2013031', '', 'Workshops jeugd', 665.50);
INSERT INTO boekregels VALUES (2292, 440, 2013, '2013-12-18', 2110, NULL, 0, 0, 'krimpen', '2013031', '', 'Workshops jeugd', -115.50);
INSERT INTO boekregels VALUES (2291, 440, 2013, '2013-12-18', 8110, NULL, 2292, 0, 'krimpen', '2013031', '', 'Workshops jeugd', -550.00);
INSERT INTO boekregels VALUES (2293, 441, 2013, '2013-10-01', 1600, NULL, 0, 0, 'vanbeek', '1007059', '', 'Stiften en verfmaterialen', -194.09);
INSERT INTO boekregels VALUES (2295, 441, 2013, '2013-10-01', 2200, NULL, 0, 0, 'vanbeek', '1007059', '', 'Stiften en verfmaterialen', 33.69);
INSERT INTO boekregels VALUES (2294, 441, 2013, '2013-10-01', 5010, NULL, 2295, 0, 'vanbeek', '1007059', '', 'Stiften en verfmaterialen', 160.40);
INSERT INTO boekregels VALUES (2298, 442, 2013, '2013-01-09', 2200, NULL, 0, 0, 'xs4all', '40162635', '', 'Internet jan 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2297, 442, 2013, '2013-01-09', 4245, NULL, 2298, 0, 'xs4all', '40162635', '', 'Internet jan 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2296, 442, 2013, '2013-01-09', 1600, NULL, 0, 0, 'xs4all', '40162635', '', 'Internet jan', -70.99);
INSERT INTO boekregels VALUES (2302, 443, 2013, '2013-02-09', 2200, NULL, 0, 0, 'xs4all', '40438518', '', 'Internet feb 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2301, 443, 2013, '2013-02-09', 4245, NULL, 2302, 0, 'xs4all', '40438518', '', 'Internet feb 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2300, 443, 2013, '2013-02-09', 1600, NULL, 0, 0, 'xs4all', '40438518', '', 'Internet feb', -73.10);
INSERT INTO boekregels VALUES (2305, 444, 2013, '2013-03-09', 4245, NULL, 2306, 0, 'xs4all', '40704328', '', 'Internet mrt 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2306, 444, 2013, '2013-03-09', 2200, NULL, 0, 0, 'xs4all', '40704328', '', 'Internet mrt 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2304, 444, 2013, '2013-03-09', 1600, NULL, 0, 0, 'xs4all', '40704328', '', 'Internet mrt', -93.47);
INSERT INTO boekregels VALUES (2310, 445, 2013, '2013-04-09', 2200, NULL, 0, 0, 'xs4all', '40967790', '', 'Internet apr 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2309, 445, 2013, '2013-04-09', 4245, NULL, 2310, 0, 'xs4all', '40967790', '', 'Internet apr 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2308, 445, 2013, '2013-04-09', 1600, NULL, 0, 0, 'xs4all', '40967790', '', 'Internet apr', -69.36);
INSERT INTO boekregels VALUES (2314, 446, 2013, '2013-05-09', 2200, NULL, 0, 0, 'xs4all', '41230664', '', 'Internet mei 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2313, 446, 2013, '2013-05-09', 4245, NULL, 2314, 0, 'xs4all', '41230664', '', 'Internet mei 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2312, 446, 2013, '2013-05-09', 1600, NULL, 0, 0, 'xs4all', '41230664', '', 'Internet mei', -63.24);
INSERT INTO boekregels VALUES (2319, 447, 2013, '2013-06-09', 1060, NULL, 0, 0, 'xs4all', '41491228', '', 'Internet jun prive deel', 46.29);
INSERT INTO boekregels VALUES (2318, 447, 2013, '2013-06-09', 2200, NULL, 0, 0, 'xs4all', '41491228', '', 'Internet jun 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2317, 447, 2013, '2013-06-09', 4245, NULL, 2318, 0, 'xs4all', '41491228', '', 'Internet jun 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2316, 447, 2013, '2013-06-09', 1600, NULL, 0, 0, 'xs4all', '41491228', '', 'Internet jun', -72.98);
INSERT INTO boekregels VALUES (2320, 448, 2013, '2013-07-09', 1600, NULL, 0, 0, 'xs4all', '41750961', '', 'Internet jul', -70.24);
INSERT INTO boekregels VALUES (2299, 442, 2013, '2013-01-09', 1060, NULL, 0, 0, 'xs4all', '40162635', '', 'Internet jan prive deel', 44.30);
INSERT INTO boekregels VALUES (2303, 443, 2013, '2013-02-09', 1060, NULL, 0, 0, 'xs4all', '40438518', '', 'Internet feb prive deel', 46.41);
INSERT INTO boekregels VALUES (2307, 444, 2013, '2013-03-09', 1060, NULL, 0, 0, 'xs4all', '40704328', '', 'Internet mrt prive deel', 66.78);
INSERT INTO boekregels VALUES (2311, 445, 2013, '2013-04-09', 1060, NULL, 0, 0, 'xs4all', '40967790', '', 'Internet apr prive deel', 42.67);
INSERT INTO boekregels VALUES (2315, 446, 2013, '2013-05-09', 1060, NULL, 0, 0, 'xs4all', '41230664', '', 'Internet mei prive deel', 36.55);
INSERT INTO boekregels VALUES (2393, 469, 2013, '2013-10-17', 4410, NULL, 2394, 0, '', '', '', 'Brandstof Nissan', 44.93);
INSERT INTO boekregels VALUES (2322, 448, 2013, '2013-07-09', 2200, NULL, 0, 0, 'xs4all', '41750961', '', 'Internet jul 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2321, 448, 2013, '2013-07-09', 4245, NULL, 2322, 0, 'xs4all', '41750961', '', 'Internet jul 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2327, 449, 2013, '2013-08-09', 1060, NULL, 0, 0, 'xs4all', '42005730', '', 'Internet aug prive deel', 44.57);
INSERT INTO boekregels VALUES (2326, 449, 2013, '2013-08-09', 2200, NULL, 0, 0, 'xs4all', '42005730', '', 'Internet aug 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2325, 449, 2013, '2013-08-09', 4245, NULL, 2326, 0, 'xs4all', '42005730', '', 'Internet aug 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2324, 449, 2013, '2013-08-09', 1600, NULL, 0, 0, 'xs4all', '42005730', '', 'Internet aug', -71.26);
INSERT INTO boekregels VALUES (2331, 450, 2013, '2013-09-09', 1060, NULL, 0, 0, 'xs4all', '72258675', '', 'Internet sep prive deel', 58.99);
INSERT INTO boekregels VALUES (2330, 450, 2013, '2013-09-09', 2200, NULL, 0, 0, 'xs4all', '72258675', '', 'Internet sep 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2329, 450, 2013, '2013-09-09', 4245, NULL, 2330, 0, 'xs4all', '72258675', '', 'Internet sep 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2328, 450, 2013, '2013-09-09', 1600, NULL, 0, 0, 'xs4all', '72258675', '', 'Internet sep', -85.68);
INSERT INTO boekregels VALUES (2335, 451, 2013, '2013-10-09', 1060, NULL, 0, 0, 'xs4all', '42508135', '', 'Internet okt prive deel', 36.67);
INSERT INTO boekregels VALUES (2334, 451, 2013, '2013-10-09', 2200, NULL, 0, 0, 'xs4all', '42508135', '', 'Internet okt 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2333, 451, 2013, '2013-10-09', 4245, NULL, 2334, 0, 'xs4all', '42508135', '', 'Internet okt 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2332, 451, 2013, '2013-10-09', 1600, NULL, 0, 0, 'xs4all', '42508135', '', 'Internet okt', -63.36);
INSERT INTO boekregels VALUES (2356, 458, 2013, '2013-11-09', 1060, NULL, 0, 0, 'xs4all', '42760348', '', 'Internet nov prive deel', 60.69);
INSERT INTO boekregels VALUES (2336, 452, 2013, '2013-10-10', 1600, NULL, 0, 0, 'altern', '224160264', '', 'Computermaterialen', -195.89);
INSERT INTO boekregels VALUES (2338, 452, 2013, '2013-10-10', 2200, NULL, 0, 0, 'altern', '224160264', '', 'Computermaterialen harddisk bay', 34.00);
INSERT INTO boekregels VALUES (2337, 452, 2013, '2013-10-10', 4230, NULL, 2338, 0, 'altern', '224160264', '', 'Computermaterialen harddisk bay', 161.89);
INSERT INTO boekregels VALUES (2339, 453, 2013, '2013-10-17', 1600, NULL, 0, 0, 'hamrick', '5619497397', '', 'Software', -29.77);
INSERT INTO boekregels VALUES (2340, 453, 2013, '2013-10-17', 4230, NULL, 0, 0, 'hamrick', '5619497397', '', 'Software', 29.77);
INSERT INTO boekregels VALUES (2341, 454, 2013, '2013-10-17', 1600, NULL, 0, 0, 'hamrick', '5621554077', '', 'Software', -29.76);
INSERT INTO boekregels VALUES (2342, 454, 2013, '2013-10-17', 4230, NULL, 0, 0, 'hamrick', '5621554077', '', 'Software', 29.76);
INSERT INTO boekregels VALUES (2343, 455, 2013, '2013-10-19', 1600, NULL, 0, 0, 'vanbeek', '1016097', '', 'Stiften', -15.80);
INSERT INTO boekregels VALUES (2345, 455, 2013, '2013-10-19', 2200, NULL, 0, 0, 'vanbeek', '1016097', '', 'Stiften', 2.74);
INSERT INTO boekregels VALUES (2344, 455, 2013, '2013-10-19', 5010, NULL, 2345, 0, 'vanbeek', '1016097', '', 'Stiften', 13.06);
INSERT INTO boekregels VALUES (2346, 456, 2013, '2013-10-21', 1600, NULL, 0, 0, 'tmobile', '901202038781', '', 'Telefoon 16-10/15-11', -33.25);
INSERT INTO boekregels VALUES (2348, 456, 2013, '2013-10-21', 2200, NULL, 0, 0, 'tmobile', '901202038781', '', 'Telefoon 16-10/15-11 75% zak', 4.33);
INSERT INTO boekregels VALUES (2347, 456, 2013, '2013-10-21', 4240, NULL, 2348, 0, 'tmobile', '901202038781', '', 'Telefoon 16-10/15-11 75% zak', 20.61);
INSERT INTO boekregels VALUES (2350, 457, 2013, '2013-11-06', 1600, NULL, 0, 0, 'kramer', 'HE92453', '', 'Spuitmateriaal', -277.85);
INSERT INTO boekregels VALUES (2352, 457, 2013, '2013-11-06', 2200, NULL, 0, 0, 'kramer', 'HE92453', '', 'Spuitmateriaal', 48.22);
INSERT INTO boekregels VALUES (2351, 457, 2013, '2013-11-06', 5010, NULL, 2352, 0, 'kramer', 'HE92453', '', 'Spuitmateriaal', 229.63);
INSERT INTO boekregels VALUES (2355, 458, 2013, '2013-11-09', 2200, NULL, 0, 0, 'xs4all', '42760348', '', 'Internet nov 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2354, 458, 2013, '2013-11-09', 4245, NULL, 2355, 0, 'xs4all', '42760348', '', 'Internet nov 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2353, 458, 2013, '2013-11-09', 1600, NULL, 0, 0, 'xs4all', '42760348', '', 'Internet nov', -87.38);
INSERT INTO boekregels VALUES (2357, 459, 2013, '2013-11-18', 1600, NULL, 0, 0, 'belasting', '69414993M39', '', 'Motorrijtuigenbelasting Nissan 17-11/16-02', -78.00);
INSERT INTO boekregels VALUES (2359, 460, 2013, '2013-11-19', 1600, NULL, 0, 0, 'tmobile', '901204333635', '', 'Telefoon 16-11/15-12', -33.03);
INSERT INTO boekregels VALUES (2361, 460, 2013, '2013-11-19', 2200, NULL, 0, 0, 'tmobile', '901204333635', '', 'Telefoon 16-11/15-12 75% zak', 4.30);
INSERT INTO boekregels VALUES (2360, 460, 2013, '2013-11-19', 4240, NULL, 2361, 0, 'tmobile', '901204333635', '', 'Telefoon 16-11/15-12 75% zak', 20.48);
INSERT INTO boekregels VALUES (2363, 461, 2013, '2013-11-22', 1600, NULL, 0, 0, 'publikat', 'RE1146822', '', 'Spuitmateriaal', -219.00);
INSERT INTO boekregels VALUES (2365, 461, 2013, '2013-11-22', 2200, NULL, 0, 0, 'publikat', 'RE1146822', '', 'Spuitmateriaal', 38.01);
INSERT INTO boekregels VALUES (2364, 461, 2013, '2013-11-22', 5010, NULL, 2365, 0, 'publikat', 'RE1146822', '', 'Spuitmateriaal', 180.99);
INSERT INTO boekregels VALUES (2366, 462, 2013, '2013-11-22', 1600, NULL, 0, 0, 'publikat', 'RE1146755', '', 'Spuitmateriaal', -166.50);
INSERT INTO boekregels VALUES (2368, 462, 2013, '2013-11-22', 2200, NULL, 0, 0, 'publikat', 'RE1146755', '', 'Spuitmateriaal', 28.90);
INSERT INTO boekregels VALUES (2367, 462, 2013, '2013-11-22', 5010, NULL, 2368, 0, 'publikat', 'RE1146755', '', 'Spuitmateriaal', 137.60);
INSERT INTO boekregels VALUES (2369, 463, 2013, '2013-11-22', 1600, NULL, 0, 0, 'publikat', 'RE1146652', '', 'Spuitmateriaal', -101.25);
INSERT INTO boekregels VALUES (2371, 463, 2013, '2013-11-22', 2200, NULL, 0, 0, 'publikat', 'RE1146652', '', 'Spuitmateriaal', 17.57);
INSERT INTO boekregels VALUES (2370, 463, 2013, '2013-11-22', 5010, NULL, 2371, 0, 'publikat', 'RE1146652', '', 'Spuitmateriaal', 83.68);
INSERT INTO boekregels VALUES (2372, 464, 2013, '2013-11-25', 1600, NULL, 0, 0, 'publikat', 'RE1147848', '', 'Spuitmateriaal', -109.10);
INSERT INTO boekregels VALUES (2374, 464, 2013, '2013-11-25', 2200, NULL, 0, 0, 'publikat', 'RE1147848', '', 'Spuitmateriaal', 18.93);
INSERT INTO boekregels VALUES (2373, 464, 2013, '2013-11-25', 5010, NULL, 2374, 0, 'publikat', 'RE1147848', '', 'Spuitmateriaal', 90.17);
INSERT INTO boekregels VALUES (2377, 465, 2013, '2013-12-09', 2200, NULL, 0, 0, 'xs4all', '43009098', '', 'Internet dec 75% zakelijk deel', 4.63);
INSERT INTO boekregels VALUES (2376, 465, 2013, '2013-12-09', 4245, NULL, 2377, 0, 'xs4all', '43009098', '', 'Internet dec 75% zakelijk deel', 22.06);
INSERT INTO boekregels VALUES (2375, 465, 2013, '2013-12-09', 1600, NULL, 0, 0, 'xs4all', '43009098', '', 'Internet dec', -62.13);
INSERT INTO boekregels VALUES (2379, 466, 2013, '2013-12-13', 1600, NULL, 0, 0, 'hofman', '2013318', '', 'Nissan kleine beurt', -223.25);
INSERT INTO boekregels VALUES (2381, 466, 2013, '2013-12-13', 2210, NULL, 0, 0, 'hofman', '2013318', '', 'Nissan kleine beurt', 38.75);
INSERT INTO boekregels VALUES (2380, 466, 2013, '2013-12-13', 4450, NULL, 2381, 0, 'hofman', '2013318', '', 'Nissan kleine beurt', 184.50);
INSERT INTO boekregels VALUES (2382, 467, 2013, '2013-12-23', 1600, NULL, 0, 0, 'tmobile', '901206572439', '', 'Telefoon 16-12/15-01', -35.97);
INSERT INTO boekregels VALUES (2384, 467, 2013, '2013-12-23', 2200, NULL, 0, 0, 'tmobile', '901206572439', '', 'Telefoon 16-12/15-01 75% zak', 4.68);
INSERT INTO boekregels VALUES (2383, 467, 2013, '2013-12-23', 4240, NULL, 2384, 0, 'tmobile', '901206572439', '', 'Telefoon 16-12/15-01 75% zak', 22.30);
INSERT INTO boekregels VALUES (2386, 468, 2013, '2013-12-31', 1600, NULL, 0, 0, 'hofman', '2013335', '', 'Nissan winterbanden', -806.68);
INSERT INTO boekregels VALUES (2388, 468, 2013, '2013-12-31', 2210, NULL, 0, 0, 'hofman', '2013335', '', 'Nissan winterbanden', 140.00);
INSERT INTO boekregels VALUES (2387, 468, 2013, '2013-12-31', 4440, NULL, 2388, 0, 'hofman', '2013335', '', 'Nissan winterbanden', 666.68);
INSERT INTO boekregels VALUES (2390, 469, 2013, '2013-10-03', 2200, NULL, 0, 0, '', '', '', 'Schoonmaakmateriaal', 3.73);
INSERT INTO boekregels VALUES (2389, 469, 2013, '2013-10-03', 4220, NULL, 2390, 0, '', '', '', 'Schoonmaakmateriaal', 17.76);
INSERT INTO boekregels VALUES (2392, 469, 2013, '2013-10-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.78);
INSERT INTO boekregels VALUES (2391, 469, 2013, '2013-10-10', 4410, NULL, 2392, 0, '', '', '', 'Brandstof Nissan', 56.07);
INSERT INTO boekregels VALUES (2323, 448, 2013, '2013-07-09', 1060, NULL, 0, 0, 'xs4all', '41750961', '', 'Internet jul prive deel', 43.55);
INSERT INTO boekregels VALUES (2378, 465, 2013, '2013-12-09', 1060, NULL, 0, 0, 'xs4all', '43009098', '', 'Internet dec prive deel', 35.44);
INSERT INTO boekregels VALUES (2349, 456, 2013, '2013-10-21', 1060, NULL, 0, 0, 'tmobile', '901202038781', '', 'Telefoon 16-10/15-11 prive deel', 8.31);
INSERT INTO boekregels VALUES (2362, 460, 2013, '2013-11-19', 1060, NULL, 0, 0, 'tmobile', '901204333635', '', 'Telefoon 16-11/15-12 prive deel', 8.25);
INSERT INTO boekregels VALUES (2385, 467, 2013, '2013-12-23', 1060, NULL, 0, 0, 'tmobile', '901206572439', '', 'Telefoon 16-12/15-01 prive deel', 8.99);
INSERT INTO boekregels VALUES (2394, 469, 2013, '2013-10-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.43);
INSERT INTO boekregels VALUES (2396, 469, 2013, '2013-10-23', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 27.75);
INSERT INTO boekregels VALUES (2395, 469, 2013, '2013-10-23', 5010, NULL, 2396, 0, '', '', '', 'Schildersdoek', 132.15);
INSERT INTO boekregels VALUES (2398, 469, 2013, '2013-10-28', 2200, NULL, 0, 0, '', '', '', 'Grofvuilzakken', 4.68);
INSERT INTO boekregels VALUES (2397, 469, 2013, '2013-10-28', 4220, NULL, 2398, 0, '', '', '', 'Grofvuilzakken', 22.28);
INSERT INTO boekregels VALUES (2400, 469, 2013, '2013-10-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.40);
INSERT INTO boekregels VALUES (2399, 469, 2013, '2013-10-29', 4410, NULL, 2400, 0, '', '', '', 'Brandstof Nissan', 54.27);
INSERT INTO boekregels VALUES (2401, 469, 2013, '2013-10-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 10 2013', -396.23);
INSERT INTO boekregels VALUES (2403, 470, 2013, '2013-11-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.55);
INSERT INTO boekregels VALUES (2402, 470, 2013, '2013-11-03', 4410, NULL, 2403, 0, '', '', '', 'Brandstof Nissan', 31.17);
INSERT INTO boekregels VALUES (2447, 472, 2013, '2013-10-20', 8060, NULL, 2448, 0, '', '', '', 'Graffiti Crew Rotterdam', -82.64);
INSERT INTO boekregels VALUES (2405, 470, 2013, '2013-11-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.59);
INSERT INTO boekregels VALUES (2404, 470, 2013, '2013-11-06', 4410, NULL, 2405, 0, '', '', '', 'Brandstof Nissan', 50.42);
INSERT INTO boekregels VALUES (2407, 470, 2013, '2013-11-09', 2200, NULL, 0, 0, '', '', '', 'Wegwerphandschoenen', 0.69);
INSERT INTO boekregels VALUES (2406, 470, 2013, '2013-11-09', 4220, NULL, 2407, 0, '', '', '', 'Wegwerphandschoenen', 3.30);
INSERT INTO boekregels VALUES (2409, 470, 2013, '2013-11-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.46);
INSERT INTO boekregels VALUES (2408, 470, 2013, '2013-11-12', 4410, NULL, 2409, 0, '', '', '', 'Brandstof Nissan', 35.53);
INSERT INTO boekregels VALUES (2411, 470, 2013, '2013-11-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 8.40);
INSERT INTO boekregels VALUES (2410, 470, 2013, '2013-11-14', 4410, NULL, 2411, 0, '', '', '', 'Brandstof Nissan', 39.99);
INSERT INTO boekregels VALUES (2413, 470, 2013, '2013-11-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.87);
INSERT INTO boekregels VALUES (2412, 470, 2013, '2013-11-20', 4410, NULL, 2413, 0, '', '', '', 'Brandstof Nissan', 51.78);
INSERT INTO boekregels VALUES (2415, 470, 2013, '2013-11-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.50);
INSERT INTO boekregels VALUES (2414, 470, 2013, '2013-11-24', 4410, NULL, 2415, 0, '', '', '', 'Brandstof Nissan', 35.71);
INSERT INTO boekregels VALUES (2417, 470, 2013, '2013-11-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.20);
INSERT INTO boekregels VALUES (2416, 470, 2013, '2013-11-27', 4410, NULL, 2417, 0, '', '', '', 'Brandstof Nissan', 48.56);
INSERT INTO boekregels VALUES (2418, 470, 2013, '2013-11-28', 4270, NULL, 0, 0, '', '', '', 'Tol tunnel', 2.00);
INSERT INTO boekregels VALUES (2419, 470, 2013, '2013-11-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 11 2013', -360.72);
INSERT INTO boekregels VALUES (2421, 471, 2013, '2013-12-05', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.29);
INSERT INTO boekregels VALUES (2420, 471, 2013, '2013-12-05', 4410, NULL, 2421, 0, '', '', '', 'Brandstof Nissan', 48.99);
INSERT INTO boekregels VALUES (2422, 471, 2013, '2013-12-05', 4270, NULL, 0, 0, '', '', '', 'Parkeerkosten rotterdam', 12.00);
INSERT INTO boekregels VALUES (2424, 471, 2013, '2013-12-06', 2200, NULL, 0, 0, '', '', '', 'Workshopmaterialen', 8.88);
INSERT INTO boekregels VALUES (2423, 471, 2013, '2013-12-06', 5010, NULL, 2424, 0, '', '', '', 'Workshopmaterialen', 42.28);
INSERT INTO boekregels VALUES (2426, 471, 2013, '2013-12-06', 2200, NULL, 0, 0, '', '', '', 'Workshopmaterialen', 15.20);
INSERT INTO boekregels VALUES (2425, 471, 2013, '2013-12-06', 5010, NULL, 2426, 0, '', '', '', 'Workshopmaterialen', 72.38);
INSERT INTO boekregels VALUES (2428, 471, 2013, '2013-12-06', 2200, NULL, 0, 0, '', '', '', 'Stofmaskers', 5.05);
INSERT INTO boekregels VALUES (2427, 471, 2013, '2013-12-06', 4220, NULL, 2428, 0, '', '', '', 'Stofmaskers', 24.07);
INSERT INTO boekregels VALUES (2430, 471, 2013, '2013-12-13', 2200, NULL, 0, 0, '', '', '', 'Diverse materialen', 15.28);
INSERT INTO boekregels VALUES (2429, 471, 2013, '2013-12-13', 4220, NULL, 2430, 0, '', '', '', 'Diverse materialen', 72.77);
INSERT INTO boekregels VALUES (2432, 471, 2013, '2013-12-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.51);
INSERT INTO boekregels VALUES (2431, 471, 2013, '2013-12-18', 4410, NULL, 2432, 0, '', '', '', 'Brandstof Nissan', 50.07);
INSERT INTO boekregels VALUES (2434, 471, 2013, '2013-12-21', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift en blocks', 0.79);
INSERT INTO boekregels VALUES (2433, 471, 2013, '2013-12-21', 4230, NULL, 2434, 0, '', '', '', 'Vaktijdschrift en blocks', 7.82);
INSERT INTO boekregels VALUES (2435, 471, 2013, '2013-12-23', 4270, NULL, 0, 0, '', '', '', 'Parkeerkosten rotterdam', 1.30);
INSERT INTO boekregels VALUES (2437, 471, 2013, '2013-12-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.91);
INSERT INTO boekregels VALUES (2436, 471, 2013, '2013-12-24', 4410, NULL, 2437, 0, '', '', '', 'Brandstof Nissan', 47.19);
INSERT INTO boekregels VALUES (2439, 471, 2013, '2013-12-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.12);
INSERT INTO boekregels VALUES (2438, 471, 2013, '2013-12-28', 4410, NULL, 2439, 0, '', '', '', 'Brandstof Nissan', 55.31);
INSERT INTO boekregels VALUES (2441, 471, 2013, '2013-12-29', 2200, NULL, 0, 0, '', '', '', 'Latex en rollers', 2.97);
INSERT INTO boekregels VALUES (2440, 471, 2013, '2013-12-29', 5010, NULL, 2441, 0, '', '', '', 'Latex en rollers', 14.13);
INSERT INTO boekregels VALUES (2442, 471, 2013, '2013-12-29', 1060, NULL, 0, 0, '', '', '', 'Kasblad 12 2013', -538.31);
INSERT INTO boekregels VALUES (2444, 472, 2013, '2013-10-09', 2110, NULL, 0, 0, '', '', '', 'Graffiti Teun Woerden', -23.43);
INSERT INTO boekregels VALUES (2443, 472, 2013, '2013-10-09', 8060, NULL, 2444, 0, '', '', '', 'Graffiti Teun Woerden', -111.57);
INSERT INTO boekregels VALUES (2446, 472, 2013, '2013-10-10', 2110, NULL, 0, 0, '', '', '', 'Scholderij Lars, Yvonne Schwegler', -23.43);
INSERT INTO boekregels VALUES (2445, 472, 2013, '2013-10-10', 8065, NULL, 2446, 0, '', '', '', 'Scholderij Lars, Yvonne Schwegler', -111.57);
INSERT INTO boekregels VALUES (2448, 472, 2013, '2013-10-20', 2110, NULL, 0, 0, '', '', '', 'Graffiti Crew Rotterdam', -17.36);
INSERT INTO boekregels VALUES (2450, 472, 2013, '2013-10-30', 2110, NULL, 0, 0, '', '', '', 'Graffiti Jordi Rhoon', -23.43);
INSERT INTO boekregels VALUES (2449, 472, 2013, '2013-10-30', 8060, NULL, 2450, 0, '', '', '', 'Graffiti Jordi Rhoon', -111.57);
INSERT INTO boekregels VALUES (2452, 472, 2013, '2013-11-10', 2110, NULL, 0, 0, '', '', '', 'Graffiti Joey De Rijp', -26.03);
INSERT INTO boekregels VALUES (2451, 472, 2013, '2013-11-10', 8060, NULL, 2452, 0, '', '', '', 'Graffiti Joey De Rijp', -123.97);
INSERT INTO boekregels VALUES (2454, 472, 2013, '2013-11-16', 2110, NULL, 0, 0, '', '', '', 'Graffiti Kirsen en Bjorn Anna Paulowna', -34.71);
INSERT INTO boekregels VALUES (2453, 472, 2013, '2013-11-16', 8060, NULL, 2454, 0, '', '', '', 'Graffiti Kirsen en Bjorn Anna Paulowna', -165.29);
INSERT INTO boekregels VALUES (2456, 472, 2013, '2013-11-20', 2110, NULL, 0, 0, '', '', '', 'Schildering Hazes Gouda', -17.36);
INSERT INTO boekregels VALUES (2455, 472, 2013, '2013-11-20', 8060, NULL, 2456, 0, '', '', '', 'Schildering Hazes Gouda', -82.64);
INSERT INTO boekregels VALUES (2458, 472, 2013, '2013-11-27', 2110, NULL, 0, 0, '', '', '', 'Graffiti Tim/Ajax Waddinxveen', -23.43);
INSERT INTO boekregels VALUES (2457, 472, 2013, '2013-11-27', 8060, NULL, 2458, 0, '', '', '', 'Graffiti Tim/Ajax Waddinxveen', -111.57);
INSERT INTO boekregels VALUES (2460, 472, 2013, '2013-11-28', 2110, NULL, 0, 0, '', '', '', 'Schilderij Romee', -23.43);
INSERT INTO boekregels VALUES (2459, 472, 2013, '2013-11-28', 8065, NULL, 2460, 0, '', '', '', 'Schilderij Romee', -111.57);
INSERT INTO boekregels VALUES (2462, 472, 2013, '2013-12-17', 2110, NULL, 0, 0, '', '', '', 'Ontwerp Tattoo Gianni', -3.47);
INSERT INTO boekregels VALUES (2461, 472, 2013, '2013-12-17', 8085, NULL, 2462, 0, '', '', '', 'Ontwerp Tattoo Gianni', -16.53);
INSERT INTO boekregels VALUES (2464, 472, 2013, '2013-12-27', 2110, NULL, 0, 0, '', '', '', 'Schildering koe Mildam', -34.71);
INSERT INTO boekregels VALUES (2463, 472, 2013, '2013-12-27', 8060, NULL, 2464, 0, '', '', '', 'Schildering koe Mildam', -165.29);
INSERT INTO boekregels VALUES (2466, 472, 2013, '2013-12-28', 2110, NULL, 0, 0, '', '', '', 'Graffiti Jelco en Luuk Nijkerkerveen', -43.39);
INSERT INTO boekregels VALUES (2465, 472, 2013, '2013-12-28', 8060, NULL, 2466, 0, '', '', '', 'Graffiti Jelco en Luuk Nijkerkerveen', -206.61);
INSERT INTO boekregels VALUES (2467, 472, 2013, '2013-12-28', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 4e kwartaal', 1695.00);
INSERT INTO boekregels VALUES (1223, 231, 2013, '2013-06-19', 250, NULL, 0, 0, 'koops', '201319', '', 'Verkoop Opel Combi', -1250.00);
INSERT INTO boekregels VALUES (2469, 473, 2013, '2013-09-18', 2200, NULL, 0, 0, '', '', '', 'Ophanghaken auto', 2.56);
INSERT INTO boekregels VALUES (2468, 473, 2013, '2013-09-18', 4220, NULL, 2469, 0, '', '', '', 'Ophanghaken auto', 12.19);
INSERT INTO boekregels VALUES (2471, 473, 2013, '2013-09-18', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 13.00);
INSERT INTO boekregels VALUES (2470, 473, 2013, '2013-09-18', 5010, NULL, 2471, 0, '', '', '', 'Plaatmateriaal', 61.92);
INSERT INTO boekregels VALUES (2472, 473, 2013, '2013-10-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 10 2013 nagekomen', -89.67);
INSERT INTO boekregels VALUES (2476, 475, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive autogebruik 2013 Opel Combo', 2070.83);
INSERT INTO boekregels VALUES (2477, 475, 2013, '2013-12-31', 4520, NULL, 0, 0, '', '', '', 'Prive autogebruik 2013 Opel Combo', -2070.83);
INSERT INTO boekregels VALUES (2475, 474, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Afschrijving van fakt. 2012003', -419.95);
INSERT INTO boekregels VALUES (2478, 475, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive autogebruik 2013 Nissan Nv200', 2537.67);
INSERT INTO boekregels VALUES (2479, 475, 2013, '2013-12-31', 4520, NULL, 0, 0, '', '', '', 'Prive autogebruik 2013 Nissan Nv200', -2537.67);
INSERT INTO boekregels VALUES (2480, 475, 2013, '2013-12-31', 4510, NULL, 0, 0, '', '', '', 'Prive auto BTW correctie 2013 Opel Combo ', 223.65);
INSERT INTO boekregels VALUES (2481, 475, 2013, '2013-12-31', 2150, NULL, 0, 0, '', '', '', 'Prive auto BTW correctie 2013 Opel Combo ', -223.65);
INSERT INTO boekregels VALUES (2482, 475, 2013, '2013-12-31', 4510, NULL, 0, 0, '', '', '', 'Prive auto BTW correctie 2013 Nissan Nv200', 274.07);
INSERT INTO boekregels VALUES (2483, 475, 2013, '2013-12-31', 2150, NULL, 0, 0, '', '', '', 'Prive auto BTW correctie 2013 Nissan Nv200', -274.07);
INSERT INTO boekregels VALUES (2484, 476, 2013, '2013-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 512.58);
INSERT INTO boekregels VALUES (2485, 476, 2013, '2013-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -391.51);
INSERT INTO boekregels VALUES (2486, 476, 2013, '2013-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -314.76);
INSERT INTO boekregels VALUES (2487, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -512.58);
INSERT INTO boekregels VALUES (2488, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.42);
INSERT INTO boekregels VALUES (2489, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 314.76);
INSERT INTO boekregels VALUES (2490, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 391.51);
INSERT INTO boekregels VALUES (2491, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.27);
INSERT INTO boekregels VALUES (2492, 476, 2013, '2013-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.42);
INSERT INTO boekregels VALUES (2493, 476, 2013, '2013-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.27);
INSERT INTO boekregels VALUES (2494, 476, 2013, '2013-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 497.72);
INSERT INTO boekregels VALUES (2495, 476, 2013, '2013-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', -67.05);
INSERT INTO boekregels VALUES (2496, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -497.72);
INSERT INTO boekregels VALUES (2497, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', -0.28);
INSERT INTO boekregels VALUES (2498, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2200', 67.05);
INSERT INTO boekregels VALUES (2499, 476, 2013, '2013-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.05);
INSERT INTO boekregels VALUES (2500, 476, 2013, '2013-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', 0.28);
INSERT INTO boekregels VALUES (2501, 476, 2013, '2013-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.05);
INSERT INTO boekregels VALUES (871, 175, 2013, '2013-03-11', 4430, NULL, 0, 0, 'belasting', '69414993M32', '', 'Motorrijtuigenbelasting Opel Combo 8/3-7/6 2013', 72.00);
INSERT INTO boekregels VALUES (2180, 412, 2013, '2013-08-19', 4430, NULL, 0, 0, 'belasting', '694.14.993.M.3.7', '', 'Motorrijtuigenbelasting Nissan 17-8/16-11', 78.00);
INSERT INTO boekregels VALUES (2358, 459, 2013, '2013-11-18', 4430, NULL, 0, 0, 'belasting', '69414993M39', '', 'Motorrijtuigenbelasting Nissan 17-11/16-02', 78.00);
INSERT INTO boekregels VALUES (2166, 407, 2013, '2013-07-08', 4430, NULL, 0, 0, 'belasting', '694.14.993M3.5', '', 'Motorrijtuigenbelasting Nissan 25-06/16-08', 46.00);
INSERT INTO boekregels VALUES (1050, 205, 2013, '2013-06-08', 1600, NULL, 0, 0, 'belasting', '69414993M34', '', 'Motorrijtuigenbelasting Opel Combo 8-6/7-9', -72.00);
INSERT INTO boekregels VALUES (1051, 205, 2013, '2013-06-08', 4430, NULL, 0, 0, 'belasting', '69414993M34', '', 'Motorrijtuigenbelasting Opel Combo 8-6/7-9', 72.00);
INSERT INTO boekregels VALUES (2502, 477, 2013, '2013-06-10', 250, NULL, 0, 0, '', '', '', 'Afschrijving Opel Combi t.m. 10 juni', -373.97);
INSERT INTO boekregels VALUES (2503, 477, 2013, '2013-06-10', 4620, NULL, 0, 0, '', '', '', 'Afschrijving Opel Combi t.m. 10 juni', 373.97);
INSERT INTO boekregels VALUES (2504, 478, 2013, '2013-06-10', 200, NULL, 0, 0, '', '', '', 'Afvoeren Opel Combo van balans wgs verkoop', -3500.00);
INSERT INTO boekregels VALUES (2505, 478, 2013, '2013-06-10', 250, NULL, 0, 0, '', '', '', 'Afvoeren Opel Combo van balans wgs verkoop', 3500.00);
INSERT INTO boekregels VALUES (2506, 479, 2013, '2013-06-10', 250, NULL, 0, 0, '', '', '', 'Opel Combo restverlies op verkoop', -497.13);
INSERT INTO boekregels VALUES (2507, 479, 2013, '2013-06-10', 4620, NULL, 0, 0, '', '', '', 'Opel Combo restverlies op verkoop', 497.13);
INSERT INTO boekregels VALUES (2508, 480, 2013, '2013-12-31', 260, NULL, 0, 0, '', '', '', 'Afschrijving Nissan vanaf 10 juni', -840.10);
INSERT INTO boekregels VALUES (2509, 480, 2013, '2013-12-31', 4630, NULL, 0, 0, '', '', '', 'Afschrijving Nissan vanaf 10 juni', 840.10);
INSERT INTO boekregels VALUES (2510, 481, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive betaald Crediteuren', -22846.08);
INSERT INTO boekregels VALUES (2511, 481, 2013, '2013-12-31', 1600, NULL, 0, 0, '', '', '', 'Prive betaald Crediteuren', 22846.08);
INSERT INTO boekregels VALUES (2512, 482, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive ontvangen Debiteuren', 24256.04);
INSERT INTO boekregels VALUES (2513, 482, 2013, '2013-12-31', 1200, NULL, 0, 0, '', '', '', 'Prive ontvangen Debiteuren', -24256.04);
INSERT INTO boekregels VALUES (2514, 483, 2013, '2013-12-31', 4420, NULL, 0, 0, '', '', '', 'In 2013 betaalde AllRisk verzekering Nissan', 782.00);
INSERT INTO boekregels VALUES (2515, 483, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'In 2013 betaalde AllRisk verzekering Nissan', -782.00);
INSERT INTO boekregels VALUES (2516, 483, 2013, '2013-12-31', 4440, NULL, 0, 0, '', '', '', 'Kosten lease Nissan', 382.00);
INSERT INTO boekregels VALUES (2517, 483, 2013, '2013-12-31', 1060, NULL, 0, 0, '', '', '', 'Kosten lease Nissan', -382.00);
INSERT INTO boekregels VALUES (1019, 194, 2013, '2013-04-11', 5010, NULL, 1020, 0, 'kramer', 'HE90648', '', 'Spuitmateriaal', 391.45);
INSERT INTO boekregels VALUES (1071, 212, 2013, '2013-06-26', 2200, NULL, 0, 0, 'kramer', 'HE91195', '', 'Spuitmateriaal', 28.25);
INSERT INTO boekregels VALUES (1090, 214, 2013, '2013-04-23', 5010, NULL, 1091, 0, '', '', '', 'Plaatmateriaal', 25.62);
INSERT INTO boekregels VALUES (2518, 484, 2014, '2014-01-03', 1600, NULL, 0, 0, 'akabels', '710276', '', 'S-Video prof kabel', -17.30);
INSERT INTO boekregels VALUES (2520, 484, 2014, '2014-01-03', 2200, NULL, 0, 0, 'akabels', '710276', '', 'S-Video prof kabel', 3.00);
INSERT INTO boekregels VALUES (2519, 484, 2014, '2014-01-03', 4220, NULL, 2520, 0, 'akabels', '710276', '', 'S-Video prof kabel', 14.30);
INSERT INTO boekregels VALUES (2521, 485, 2014, '2014-01-09', 1600, NULL, 0, 0, 'xs4all', '43254092', '', 'Internet jan 25% zakelijk deel', -91.46);
INSERT INTO boekregels VALUES (2523, 485, 2014, '2014-01-09', 2200, NULL, 0, 0, 'xs4all', '43254092', '', 'Internet jan 25% zakelijk deel', 3.97);
INSERT INTO boekregels VALUES (2522, 485, 2014, '2014-01-09', 4245, NULL, 2523, 0, 'xs4all', '43254092', '', 'Internet jan 25% zakelijk deel', 18.90);
INSERT INTO boekregels VALUES (2524, 485, 2014, '2014-01-09', 1060, NULL, 0, 0, 'xs4all', '43254092', '', 'Internet jan 75% prive deel', 68.59);
INSERT INTO boekregels VALUES (2525, 486, 2014, '2014-01-20', 1600, NULL, 0, 0, 'tmobile', '901208815968', '', 'Mobiel jan', -46.36);
INSERT INTO boekregels VALUES (2527, 486, 2014, '2014-01-20', 2200, NULL, 0, 0, 'tmobile', '901208815968', '', 'Mobiel jan', 8.05);
INSERT INTO boekregels VALUES (2526, 486, 2014, '2014-01-20', 4240, NULL, 2527, 0, 'tmobile', '901208815968', '', 'Mobiel jan', 38.31);
INSERT INTO boekregels VALUES (2528, 487, 2014, '2014-01-23', 1600, NULL, 0, 0, 'vanbeek', '1063733', '', 'Spuitmateriaal', -39.50);
INSERT INTO boekregels VALUES (2530, 487, 2014, '2014-01-23', 2200, NULL, 0, 0, 'vanbeek', '1063733', '', 'Spuitmateriaal', 6.86);
INSERT INTO boekregels VALUES (2529, 487, 2014, '2014-01-23', 5010, NULL, 2530, 0, 'vanbeek', '1063733', '', 'Spuitmateriaal', 32.64);
INSERT INTO boekregels VALUES (2531, 488, 2014, '2014-01-28', 1600, NULL, 0, 0, 'publikat', 'RE1208572', '', 'Molotow spuitmateriaal', -264.90);
INSERT INTO boekregels VALUES (2533, 488, 2014, '2014-01-28', 2200, NULL, 0, 0, 'publikat', 'RE1208572', '', 'Molotow spuitmateriaal', 45.97);
INSERT INTO boekregels VALUES (2532, 488, 2014, '2014-01-28', 5010, NULL, 2533, 0, 'publikat', 'RE1208572', '', 'Molotow spuitmateriaal', 218.93);
INSERT INTO boekregels VALUES (2536, 489, 2014, '2014-02-01', 2200, NULL, 0, 0, 'mediamarkt', '40753381', '', 'LG G2 smartphone', 75.74);
INSERT INTO boekregels VALUES (2537, 490, 2014, '2014-02-09', 1600, NULL, 0, 0, 'xs4all', '43499507', '', 'Internet feb 25% zakelijk deel', -85.85);
INSERT INTO boekregels VALUES (2535, 489, 2014, '2014-02-01', 4210, NULL, 2536, 0, 'mediamarkt', '40753381', '', 'LG G2 smartphone', 360.67);
INSERT INTO boekregels VALUES (2473, 474, 2013, '2013-12-31', 4610, NULL, 0, 0, '', '', '', 'Afschrijving van fakt. 2012003', 352.90);
INSERT INTO boekregels VALUES (2539, 490, 2014, '2014-02-09', 2200, NULL, 0, 0, 'xs4all', '43499507', '', 'Internet feb 25% zakelijk deel', 3.73);
INSERT INTO boekregels VALUES (2538, 490, 2014, '2014-02-09', 4245, NULL, 2539, 0, 'xs4all', '43499507', '', 'Internet feb 25% zakelijk deel', 17.74);
INSERT INTO boekregels VALUES (2540, 490, 2014, '2014-02-09', 1060, NULL, 0, 0, 'xs4all', '43499507', '', 'Internet feb 75% prive deel', 64.38);
INSERT INTO boekregels VALUES (2541, 491, 2014, '2014-02-19', 1600, NULL, 0, 0, 'tmobile', '901211073049', '', 'Mobiel feb', -60.67);
INSERT INTO boekregels VALUES (2543, 491, 2014, '2014-02-19', 2200, NULL, 0, 0, 'tmobile', '901211073049', '', 'Mobiel feb', 10.53);
INSERT INTO boekregels VALUES (2542, 491, 2014, '2014-02-19', 4240, NULL, 2543, 0, 'tmobile', '901211073049', '', 'Mobiel feb', 50.14);
INSERT INTO boekregels VALUES (2544, 492, 2014, '2014-02-17', 1600, NULL, 0, 0, 'belasting', '694.14.993.M.4.2', '', 'Motorrijtuigenbelasting Nissan 17-02/16-05', -79.00);
INSERT INTO boekregels VALUES (2545, 492, 2014, '2014-02-17', 4430, NULL, 0, 0, 'belasting', '694.14.993.M.4.2', '', 'Motorrijtuigenbelasting Nissan 17-02/16-05', 79.00);
INSERT INTO boekregels VALUES (2546, 493, 2014, '2014-02-18', 1600, NULL, 0, 0, 'altern', '424179850', '', 'SSD schijf webserver', -79.84);
INSERT INTO boekregels VALUES (2548, 493, 2014, '2014-02-18', 2200, NULL, 0, 0, 'altern', '424179850', '', 'SSD schijf webserver', 13.86);
INSERT INTO boekregels VALUES (2547, 493, 2014, '2014-02-18', 4220, NULL, 2548, 0, 'altern', '424179850', '', 'SSD schijf webserver', 65.98);
INSERT INTO boekregels VALUES (2549, 494, 2014, '2014-03-01', 1600, NULL, 0, 0, 'vanbeek', '1082792', '', 'Spuitmateriaal', -14.85);
INSERT INTO boekregels VALUES (2551, 494, 2014, '2014-03-01', 2200, NULL, 0, 0, 'vanbeek', '1082792', '', 'Spuitmateriaal', 2.58);
INSERT INTO boekregels VALUES (2550, 494, 2014, '2014-03-01', 5010, NULL, 2551, 0, 'vanbeek', '1082792', '', 'Spuitmateriaal', 12.27);
INSERT INTO boekregels VALUES (2552, 495, 2014, '2014-03-09', 1600, NULL, 0, 0, 'xs4all', '43742381', '', 'Internet mrt 25% zakelijk deel', -57.62);
INSERT INTO boekregels VALUES (2554, 495, 2014, '2014-03-09', 2200, NULL, 0, 0, 'xs4all', '43742381', '', 'Internet mrt 25% zakelijk deel', 2.50);
INSERT INTO boekregels VALUES (2553, 495, 2014, '2014-03-09', 4245, NULL, 2554, 0, 'xs4all', '43742381', '', 'Internet mrt 25% zakelijk deel', 11.91);
INSERT INTO boekregels VALUES (2555, 495, 2014, '2014-03-09', 1060, NULL, 0, 0, 'xs4all', '43742381', '', 'Internet mrt 75% prive deel', 43.21);
INSERT INTO boekregels VALUES (2556, 496, 2014, '2014-03-14', 1600, NULL, 0, 0, 'vanbeek', '1089195', '', 'Verf en doek', -191.83);
INSERT INTO boekregels VALUES (2558, 496, 2014, '2014-03-14', 2200, NULL, 0, 0, 'vanbeek', '1089195', '', 'Verf en doek', 33.29);
INSERT INTO boekregels VALUES (2557, 496, 2014, '2014-03-14', 5010, NULL, 2558, 0, 'vanbeek', '1089195', '', 'Verf en doek', 158.54);
INSERT INTO boekregels VALUES (2585, 500, 2014, '2014-02-03', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.32);
INSERT INTO boekregels VALUES (2584, 500, 2014, '2014-02-03', 4290, NULL, 2585, 0, '', '', '', 'Lunch', 5.38);
INSERT INTO boekregels VALUES (2559, 497, 2014, '2014-03-19', 1600, NULL, 0, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', -17.56);
INSERT INTO boekregels VALUES (2561, 497, 2014, '2014-03-19', 2200, NULL, 0, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', 3.05);
INSERT INTO boekregels VALUES (2560, 497, 2014, '2014-03-19', 4240, NULL, 2561, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', 14.51);
INSERT INTO boekregels VALUES (2562, 498, 2014, '2014-03-24', 1600, NULL, 0, 0, 'vandijken', '60593', '', 'Glaswerk tbv display', -689.64);
INSERT INTO boekregels VALUES (2564, 498, 2014, '2014-03-24', 2200, NULL, 0, 0, 'vandijken', '60593', '', 'Glaswerk tbv display', 119.69);
INSERT INTO boekregels VALUES (2563, 498, 2014, '2014-03-24', 4310, NULL, 2564, 0, 'vandijken', '60593', '', 'Glaswerk tbv display', 569.95);
INSERT INTO boekregels VALUES (2566, 499, 2014, '2014-01-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.09);
INSERT INTO boekregels VALUES (2565, 499, 2014, '2014-01-02', 4410, NULL, 2566, 0, '', '', '', 'Brandstof Nissan', 28.99);
INSERT INTO boekregels VALUES (2568, 499, 2014, '2014-01-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.16);
INSERT INTO boekregels VALUES (2567, 499, 2014, '2014-01-09', 4410, NULL, 2568, 0, '', '', '', 'Brandstof Nissan', 43.61);
INSERT INTO boekregels VALUES (2570, 499, 2014, '2014-01-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.36);
INSERT INTO boekregels VALUES (2569, 499, 2014, '2014-01-15', 4410, NULL, 2570, 0, '', '', '', 'Brandstof Nissan', 54.08);
INSERT INTO boekregels VALUES (2572, 499, 2014, '2014-01-18', 2200, NULL, 0, 0, '', '', '', 'Montagehandschoene', 1.39);
INSERT INTO boekregels VALUES (2571, 499, 2014, '2014-01-18', 4220, NULL, 2572, 0, '', '', '', 'Montagehandschoene', 6.60);
INSERT INTO boekregels VALUES (2574, 499, 2014, '2014-01-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.88);
INSERT INTO boekregels VALUES (2573, 499, 2014, '2014-01-21', 4410, NULL, 2574, 0, '', '', '', 'Brandstof Nissan', 37.55);
INSERT INTO boekregels VALUES (2576, 499, 2014, '2014-01-22', 2200, NULL, 0, 0, '', '', '', 'Folie en materiaal', 4.40);
INSERT INTO boekregels VALUES (2575, 499, 2014, '2014-01-22', 4220, NULL, 2576, 0, '', '', '', 'Folie en materiaal', 20.98);
INSERT INTO boekregels VALUES (2578, 499, 2014, '2014-01-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.66);
INSERT INTO boekregels VALUES (2577, 499, 2014, '2014-01-23', 4410, NULL, 2578, 0, '', '', '', 'Brandstof Nissan', 36.49);
INSERT INTO boekregels VALUES (2580, 499, 2014, '2014-01-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.42);
INSERT INTO boekregels VALUES (2579, 499, 2014, '2014-01-28', 4410, NULL, 2580, 0, '', '', '', 'Brandstof Nissan', 54.39);
INSERT INTO boekregels VALUES (2582, 499, 2014, '2014-01-29', 2200, NULL, 0, 0, '', '', '', 'Lunch', 1.43);
INSERT INTO boekregels VALUES (2581, 499, 2014, '2014-01-29', 4290, NULL, 2582, 0, '', '', '', 'Lunch', 23.82);
INSERT INTO boekregels VALUES (2583, 499, 2014, '2014-01-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 01 2014', -367.30);
INSERT INTO boekregels VALUES (2587, 500, 2014, '2014-02-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.48);
INSERT INTO boekregels VALUES (2586, 500, 2014, '2014-02-04', 4410, NULL, 2587, 0, '', '', '', 'Brandstof Nissan', 35.63);
INSERT INTO boekregels VALUES (2589, 500, 2014, '2014-02-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 2.60);
INSERT INTO boekregels VALUES (2588, 500, 2014, '2014-02-07', 4410, NULL, 2589, 0, '', '', '', 'Brandstof Nissan', 12.40);
INSERT INTO boekregels VALUES (2590, 500, 2014, '2014-02-08', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan DE', 49.83);
INSERT INTO boekregels VALUES (2592, 500, 2014, '2014-02-11', 2200, NULL, 0, 0, '', '', '', 'BU Harddisk', 13.02);
INSERT INTO boekregels VALUES (2591, 500, 2014, '2014-02-11', 4210, NULL, 2592, 0, '', '', '', 'BU Harddisk', 61.98);
INSERT INTO boekregels VALUES (2593, 500, 2014, '2014-02-08', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan DE', 55.87);
INSERT INTO boekregels VALUES (2594, 500, 2014, '2014-02-14', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan DE', 48.12);
INSERT INTO boekregels VALUES (2595, 500, 2014, '2014-02-14', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan DE', 56.02);
INSERT INTO boekregels VALUES (2597, 500, 2014, '2014-02-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 3.76);
INSERT INTO boekregels VALUES (2596, 500, 2014, '2014-02-16', 4410, NULL, 2597, 0, '', '', '', 'Brandstof Nissan', 17.90);
INSERT INTO boekregels VALUES (2599, 500, 2014, '2014-02-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.90);
INSERT INTO boekregels VALUES (2598, 500, 2014, '2014-02-17', 4410, NULL, 2599, 0, '', '', '', 'Brandstof Nissan', 28.10);
INSERT INTO boekregels VALUES (2601, 500, 2014, '2014-02-17', 2200, NULL, 0, 0, '', '', '', 'BU Harddisk', 13.02);
INSERT INTO boekregels VALUES (2600, 500, 2014, '2014-02-17', 4210, NULL, 2601, 0, '', '', '', 'BU Harddisk', 61.98);
INSERT INTO boekregels VALUES (2603, 500, 2014, '2014-02-18', 2200, NULL, 0, 0, '', '', '', 'Folie en materiaal', 4.86);
INSERT INTO boekregels VALUES (2602, 500, 2014, '2014-02-18', 4220, NULL, 2603, 0, '', '', '', 'Folie en materiaal', 23.13);
INSERT INTO boekregels VALUES (2605, 500, 2014, '2014-02-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.93);
INSERT INTO boekregels VALUES (2604, 500, 2014, '2014-02-20', 4410, NULL, 2605, 0, '', '', '', 'Brandstof Nissan', 52.04);
INSERT INTO boekregels VALUES (2607, 500, 2014, '2014-02-21', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 3.29);
INSERT INTO boekregels VALUES (2606, 500, 2014, '2014-02-21', 4220, NULL, 2607, 0, '', '', '', 'Plaatmateriaal', 15.69);
INSERT INTO boekregels VALUES (2609, 500, 2014, '2014-02-22', 2200, NULL, 0, 0, '', '', '', 'Folie en materiaal', 1.29);
INSERT INTO boekregels VALUES (2608, 500, 2014, '2014-02-22', 4220, NULL, 2609, 0, '', '', '', 'Folie en materiaal', 6.16);
INSERT INTO boekregels VALUES (2611, 500, 2014, '2014-02-26', 2200, NULL, 0, 0, '', '', '', 'Folie en materiaal', 12.35);
INSERT INTO boekregels VALUES (2610, 500, 2014, '2014-02-26', 4220, NULL, 2611, 0, '', '', '', 'Folie en materiaal', 58.80);
INSERT INTO boekregels VALUES (2613, 500, 2014, '2014-02-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 3.83);
INSERT INTO boekregels VALUES (2612, 500, 2014, '2014-02-27', 4410, NULL, 2613, 0, '', '', '', 'Brandstof Nissan', 18.25);
INSERT INTO boekregels VALUES (2615, 500, 2014, '2014-02-28', 2200, NULL, 0, 0, '', '', '', 'Installatiemateriaal', 1.35);
INSERT INTO boekregels VALUES (2614, 500, 2014, '2014-02-28', 4220, NULL, 2615, 0, '', '', '', 'Installatiemateriaal', 6.43);
INSERT INTO boekregels VALUES (2616, 500, 2014, '2014-02-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 02 2014', -697.71);
INSERT INTO boekregels VALUES (2618, 501, 2014, '2014-03-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.73);
INSERT INTO boekregels VALUES (2617, 501, 2014, '2014-03-01', 4410, NULL, 2618, 0, '', '', '', 'Brandstof Nissan', 51.10);
INSERT INTO boekregels VALUES (2620, 501, 2014, '2014-03-04', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (2619, 501, 2014, '2014-03-04', 4230, NULL, 2620, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (2622, 501, 2014, '2014-03-07', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten Den Haag', 1.15);
INSERT INTO boekregels VALUES (2621, 501, 2014, '2014-03-07', 4290, NULL, 2622, 0, '', '', '', 'Parkeerkosten Den Haag', 5.45);
INSERT INTO boekregels VALUES (2624, 501, 2014, '2014-03-08', 2200, NULL, 0, 0, '', '', '', 'Parkeerkosten Den Haag', 1.39);
INSERT INTO boekregels VALUES (2623, 501, 2014, '2014-03-08', 4290, NULL, 2624, 0, '', '', '', 'Parkeerkosten Den Haag', 6.61);
INSERT INTO boekregels VALUES (2626, 501, 2014, '2014-03-10', 2200, NULL, 0, 0, '', '', '', 'BU Harddisk', 10.41);
INSERT INTO boekregels VALUES (2625, 501, 2014, '2014-03-10', 4210, NULL, 2626, 0, '', '', '', 'BU Harddisk', 49.59);
INSERT INTO boekregels VALUES (2628, 501, 2014, '2014-03-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.67);
INSERT INTO boekregels VALUES (2627, 501, 2014, '2014-03-12', 4410, NULL, 2628, 0, '', '', '', 'Brandstof Nissan', 50.82);
INSERT INTO boekregels VALUES (2630, 501, 2014, '2014-03-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.56);
INSERT INTO boekregels VALUES (2629, 501, 2014, '2014-03-16', 4410, NULL, 2630, 0, '', '', '', 'Brandstof Nissan', 50.30);
INSERT INTO boekregels VALUES (2632, 501, 2014, '2014-03-17', 2200, NULL, 0, 0, '', '', '', 'Diner relatie', 4.04);
INSERT INTO boekregels VALUES (2631, 501, 2014, '2014-03-17', 4290, NULL, 2632, 0, '', '', '', 'Diner relatie', 67.26);
INSERT INTO boekregels VALUES (2634, 501, 2014, '2014-03-22', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (2633, 501, 2014, '2014-03-22', 4230, NULL, 2634, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (2636, 501, 2014, '2014-03-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.55);
INSERT INTO boekregels VALUES (2635, 501, 2014, '2014-03-25', 4410, NULL, 2636, 0, '', '', '', 'Brandstof Nissan', 26.40);
INSERT INTO boekregels VALUES (2638, 501, 2014, '2014-03-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.02);
INSERT INTO boekregels VALUES (2637, 501, 2014, '2014-03-29', 4410, NULL, 2638, 0, '', '', '', 'Brandstof Nissan', 47.71);
INSERT INTO boekregels VALUES (2639, 501, 2014, '2014-03-29', 1060, NULL, 0, 0, '', '', '', 'Kasblad 03 2014', -432.66);
INSERT INTO boekregels VALUES (2534, 489, 2014, '2014-02-01', 1600, NULL, 0, 0, 'mediamarkt', '40753381', '', 'LG G2 smartphone', -436.41);
INSERT INTO boekregels VALUES (2640, 502, 2014, '2014-02-12', 1600, NULL, 0, 0, 'marktplaats', '140205801', '', 'Advertentieplaatsingen jan 2014', -11.50);
INSERT INTO boekregels VALUES (2642, 502, 2014, '2014-02-12', 2200, NULL, 0, 0, 'marktplaats', '140205801', '', 'Advertentieplaatsingen jan 2014', 2.00);
INSERT INTO boekregels VALUES (2641, 502, 2014, '2014-02-12', 4310, NULL, 2642, 0, 'marktplaats', '140205801', '', 'Advertentieplaatsingen jan 2014', 9.50);
INSERT INTO boekregels VALUES (2643, 503, 2014, '2014-03-10', 1600, NULL, 0, 0, 'marktplaats', '140305458', '', 'Advertentieplaatsingen feb 2014', -82.29);
INSERT INTO boekregels VALUES (2645, 503, 2014, '2014-03-10', 2200, NULL, 0, 0, 'marktplaats', '140305458', '', 'Advertentieplaatsingen feb 2014', 14.28);
INSERT INTO boekregels VALUES (2644, 503, 2014, '2014-03-10', 4310, NULL, 2645, 0, 'marktplaats', '140305458', '', 'Advertentieplaatsingen feb 2014', 68.01);
INSERT INTO boekregels VALUES (2646, 504, 2014, '2014-03-21', 1600, NULL, 0, 0, 'objekt', '14700233', '', 'Wrappen Nissan', -1210.00);
INSERT INTO boekregels VALUES (2648, 504, 2014, '2014-03-21', 2200, NULL, 0, 0, 'objekt', '14700233', '', 'Wrappen Nissan in blauw', 210.00);
INSERT INTO boekregels VALUES (2647, 504, 2014, '2014-03-21', 4310, NULL, 2648, 0, 'objekt', '14700233', '', 'Wrappen Nissan in blauw', 1000.00);
INSERT INTO boekregels VALUES (2649, 505, 2014, '2014-01-24', 1200, NULL, 0, 0, 'fitzroy', '2014001', '', 'Beschilderen Surfboards', 544.50);
INSERT INTO boekregels VALUES (2651, 505, 2014, '2014-01-24', 2110, NULL, 0, 0, 'fitzroy', '2014001', '', 'Beschilderen Surfboards', -94.50);
INSERT INTO boekregels VALUES (2650, 505, 2014, '2014-01-24', 8070, NULL, 2651, 0, 'fitzroy', '2014001', '', 'Beschilderen Surfboards', -450.00);
INSERT INTO boekregels VALUES (2652, 506, 2014, '2014-01-25', 1200, NULL, 0, 0, 'tvk', '2014002', '', 'Muurschildering logo', 199.65);
INSERT INTO boekregels VALUES (2654, 506, 2014, '2014-01-25', 2110, NULL, 0, 0, 'tvk', '2014002', '', 'Muurschildering logo', -34.65);
INSERT INTO boekregels VALUES (2653, 506, 2014, '2014-01-25', 8070, NULL, 2654, 0, 'tvk', '2014002', '', 'Muurschildering logo', -165.00);
INSERT INTO boekregels VALUES (2655, 507, 2014, '2014-02-04', 1200, NULL, 0, 0, 'dennis', '2014003', '', 'Muurschildering wereldsteden', 326.70);
INSERT INTO boekregels VALUES (2657, 507, 2014, '2014-02-04', 2110, NULL, 0, 0, 'dennis', '2014003', '', 'Muurschildering wereldsteden', -56.70);
INSERT INTO boekregels VALUES (2656, 507, 2014, '2014-02-04', 8070, NULL, 2657, 0, 'dennis', '2014003', '', 'Muurschildering wereldsteden', -270.00);
INSERT INTO boekregels VALUES (2659, 508, 2014, '2014-01-22', 2110, NULL, 0, 0, '', '', '', 'Onderwaterwereld Lisette', -69.42);
INSERT INTO boekregels VALUES (2658, 508, 2014, '2014-01-22', 8060, NULL, 2659, 0, '', '', '', 'Onderwaterwereld Lisette', -330.58);
INSERT INTO boekregels VALUES (2661, 508, 2014, '2014-02-01', 2110, NULL, 0, 0, '', '', '', 'Graffiti Deniz Leiden', -26.03);
INSERT INTO boekregels VALUES (2660, 508, 2014, '2014-02-01', 8060, NULL, 2661, 0, '', '', '', 'Graffiti Deniz Leiden', -123.97);
INSERT INTO boekregels VALUES (2663, 508, 2014, '2014-02-05', 2110, NULL, 0, 0, '', '', '', 'Graffiti Skip Delfgauw', -26.03);
INSERT INTO boekregels VALUES (2662, 508, 2014, '2014-02-05', 8060, NULL, 2663, 0, '', '', '', 'Graffiti Skip Delfgauw', -123.97);
INSERT INTO boekregels VALUES (2665, 508, 2014, '2014-02-25', 2110, NULL, 0, 0, '', '', '', 'Graffiti Ryan Nootdorp', -28.64);
INSERT INTO boekregels VALUES (2664, 508, 2014, '2014-02-25', 8060, NULL, 2665, 0, '', '', '', 'Graffiti Ryan Nootdorp', -136.36);
INSERT INTO boekregels VALUES (2667, 508, 2014, '2014-03-02', 2110, NULL, 0, 0, '', '', '', 'Graffiti Mandy Delft', -26.03);
INSERT INTO boekregels VALUES (2666, 508, 2014, '2014-03-02', 8060, NULL, 2667, 0, '', '', '', 'Graffiti Mandy Delft', -123.97);
INSERT INTO boekregels VALUES (2669, 508, 2014, '2014-03-05', 2110, NULL, 0, 0, '', '', '', 'Graffiti Jesse Cabauw', -26.03);
INSERT INTO boekregels VALUES (2668, 508, 2014, '2014-03-05', 8060, NULL, 2669, 0, '', '', '', 'Graffiti Jesse Cabauw', -123.97);
INSERT INTO boekregels VALUES (2670, 509, 2014, '2014-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 388.03);
INSERT INTO boekregels VALUES (2671, 509, 2014, '2014-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -633.55);
INSERT INTO boekregels VALUES (2672, 509, 2014, '2014-03-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -135.60);
INSERT INTO boekregels VALUES (2673, 509, 2014, '2014-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -388.03);
INSERT INTO boekregels VALUES (2674, 509, 2014, '2014-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.03);
INSERT INTO boekregels VALUES (2675, 509, 2014, '2014-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2210', 135.60);
INSERT INTO boekregels VALUES (2676, 509, 2014, '2014-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 633.55);
INSERT INTO boekregels VALUES (2677, 509, 2014, '2014-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.15);
INSERT INTO boekregels VALUES (2678, 509, 2014, '2014-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.03);
INSERT INTO boekregels VALUES (2679, 509, 2014, '2014-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.15);
INSERT INTO boekregels VALUES (2680, 510, 2014, '2014-04-01', 1600, NULL, 0, 0, '123inkt', '4912088', '', 'Printerinkt', -57.45);
INSERT INTO boekregels VALUES (2682, 510, 2014, '2014-04-01', 2200, NULL, 0, 0, '123inkt', '4912088', '', 'Printerinkt', 9.97);
INSERT INTO boekregels VALUES (2681, 510, 2014, '2014-04-01', 4230, NULL, 2682, 0, '123inkt', '4912088', '', 'Printerinkt', 47.48);
INSERT INTO boekregels VALUES (2687, 512, 2014, '2014-04-16', 1600, NULL, 0, 0, 'hofman', '2014099', '', 'Keuring en onderhoud', -655.66);
INSERT INTO boekregels VALUES (2689, 512, 2014, '2014-04-16', 2210, NULL, 0, 0, 'hofman', '2014099', '', 'Keuring en onderhoud', 113.79);
INSERT INTO boekregels VALUES (2688, 512, 2014, '2014-04-16', 4450, NULL, 2689, 0, 'hofman', '2014099', '', 'Keuring en onderhoud', 541.87);
INSERT INTO boekregels VALUES (2690, 513, 2014, '2014-04-17', 1600, NULL, 0, 0, 'marktplaats', '140405677', '', 'Advertentieplaatsingen', -5.45);
INSERT INTO boekregels VALUES (2685, 511, 2014, '2014-04-09', 2200, NULL, 0, 0, 'xs4all', '43985891', '', 'Internet apr zakelijk deel 25%', 2.66);
INSERT INTO boekregels VALUES (2686, 511, 2014, '2014-04-09', 1060, NULL, 0, 0, 'xs4all', '43985891', '', 'Internet apr prive deel 75%', 45.95);
INSERT INTO boekregels VALUES (2684, 511, 2014, '2014-04-09', 4245, NULL, 2685, 0, 'xs4all', '43985891', '', 'Internet apr zakelijk deel 25%', 12.66);
INSERT INTO boekregels VALUES (2692, 513, 2014, '2014-04-17', 2200, NULL, 0, 0, 'marktplaats', '140405677', '', 'Advertentieplaatsingen', 0.95);
INSERT INTO boekregels VALUES (2691, 513, 2014, '2014-04-17', 4310, NULL, 2692, 0, 'marktplaats', '140405677', '', 'Advertentieplaatsingen', 4.50);
INSERT INTO boekregels VALUES (2695, 514, 2014, '2014-04-21', 2200, NULL, 0, 0, 'tmobile', '0901215510197', '', 'Mobiel apr', 5.35);
INSERT INTO boekregels VALUES (2694, 514, 2014, '2014-04-21', 4240, NULL, 2695, 0, 'tmobile', '0901215510197', '', 'Mobiel apr', 25.48);
INSERT INTO boekregels VALUES (2693, 514, 2014, '2014-04-21', 1600, NULL, 0, 0, 'tmobile', '0901215510197', '', 'Mobiel apr', -30.83);
INSERT INTO boekregels VALUES (2732, 524, 2014, '2014-04-12', 2200, NULL, 0, 0, '', '', '', 'Tijdschrift', 0.37);
INSERT INTO boekregels VALUES (2700, 516, 2014, '2014-05-14', 1600, NULL, 0, 0, 'engelb', '305931', '', 'Spuitmaskers', -216.59);
INSERT INTO boekregels VALUES (2702, 516, 2014, '2014-05-14', 2200, NULL, 0, 0, 'engelb', '305931', '', 'Spuitmaskers', 37.59);
INSERT INTO boekregels VALUES (2701, 516, 2014, '2014-05-14', 4220, NULL, 2702, 0, 'engelb', '305931', '', 'Spuitmaskers', 179.00);
INSERT INTO boekregels VALUES (2703, 517, 2014, '2014-05-19', 1600, NULL, 0, 0, 'belasting', '69414993M44', '', 'Motorrijtuigenbelasting 17/5-16/8', -79.00);
INSERT INTO boekregels VALUES (2704, 517, 2014, '2014-05-19', 4430, NULL, 0, 0, 'belasting', '69414993M44', '', 'Motorrijtuigenbelasting 17/5-16/8', 79.00);
INSERT INTO boekregels VALUES (2731, 524, 2014, '2014-04-12', 4230, NULL, 2732, 0, '', '', '', 'Tijdschrift', 6.08);
INSERT INTO boekregels VALUES (2708, 519, 2014, '2014-05-26', 1600, NULL, 0, 0, 'claasen', '814979', '', 'Morsverf Latex', -119.49);
INSERT INTO boekregels VALUES (2710, 519, 2014, '2014-05-26', 2200, NULL, 0, 0, 'claasen', '814979', '', 'Morsverf Latex', 20.74);
INSERT INTO boekregels VALUES (2709, 519, 2014, '2014-05-26', 5010, NULL, 2710, 0, 'claasen', '814979', '', 'Morsverf Latex', 98.75);
INSERT INTO boekregels VALUES (2711, 520, 2014, '2014-05-27', 1600, NULL, 0, 0, 'acronis', '73634548279', '', 'Update backup software', -16.76);
INSERT INTO boekregels VALUES (2712, 520, 2014, '2014-05-27', 4230, NULL, 0, 0, 'acronis', '73634548279', '', 'Update backup software', 16.76);
INSERT INTO boekregels VALUES (2713, 521, 2014, '2014-05-27', 1600, NULL, 0, 0, 'kramer', '94514', '', 'Spuitmateriaal', -150.95);
INSERT INTO boekregels VALUES (2715, 521, 2014, '2014-05-27', 2200, NULL, 0, 0, 'kramer', '94514', '', 'Spuitmateriaal', 26.20);
INSERT INTO boekregels VALUES (2714, 521, 2014, '2014-05-27', 5010, NULL, 2715, 0, 'kramer', '94514', '', 'Spuitmateriaal', 124.75);
INSERT INTO boekregels VALUES (2716, 522, 2014, '2014-06-09', 1600, NULL, 0, 0, 'xs4all', '44470835', '', 'Internet jun', -45.75);
INSERT INTO boekregels VALUES (2733, 524, 2014, '2014-04-14', 5010, NULL, 0, 0, '', '', '', 'Latex', 15.00);
INSERT INTO boekregels VALUES (2720, 523, 2014, '2014-06-18', 1600, NULL, 0, 0, 'tmobile', '901219904199', '', 'Telefoon 16/6-15/7', -46.11);
INSERT INTO boekregels VALUES (2722, 523, 2014, '2014-06-18', 2200, NULL, 0, 0, 'tmobile', '901219904199', '', 'Telefoon 16/6-15/7', 8.00);
INSERT INTO boekregels VALUES (2721, 523, 2014, '2014-06-18', 4240, NULL, 2722, 0, 'tmobile', '901219904199', '', 'Telefoon 16/6-15/7', 38.11);
INSERT INTO boekregels VALUES (2683, 511, 2014, '2014-04-09', 1600, NULL, 0, 0, 'xs4all', '43985891', '', 'Internet apr', -61.27);
INSERT INTO boekregels VALUES (2696, 515, 2014, '2014-05-09', 1600, NULL, 0, 0, 'xs4all', '44229892', '', 'Internet mei', -39.14);
INSERT INTO boekregels VALUES (2697, 515, 2014, '2014-05-09', 4245, NULL, 2698, 0, 'xs4all', '44229892', '', 'Internet mei zakelijk deel 50%', 16.17);
INSERT INTO boekregels VALUES (2698, 515, 2014, '2014-05-09', 2200, NULL, 0, 0, 'xs4all', '44229892', '', 'Internet mei zakelijk deel 50%', 3.40);
INSERT INTO boekregels VALUES (2699, 515, 2014, '2014-05-09', 1060, NULL, 0, 0, 'xs4all', '44229892', '', 'Internet apr prive deel 50%', 19.57);
INSERT INTO boekregels VALUES (2705, 518, 2014, '2014-05-20', 1600, NULL, 0, 0, 'tmobile', '901217664084', '', 'Mobiel mei', -34.69);
INSERT INTO boekregels VALUES (2706, 518, 2014, '2014-05-20', 4240, NULL, 2707, 0, 'tmobile', '901217664084', '', 'Mobiel mei', 28.67);
INSERT INTO boekregels VALUES (2707, 518, 2014, '2014-05-20', 2200, NULL, 0, 0, 'tmobile', '901217664084', '', 'Mobiel mei', 6.02);
INSERT INTO boekregels VALUES (2717, 522, 2014, '2014-06-09', 4245, NULL, 2718, 0, 'xs4all', '44470835', '', 'Internet jun zakelijk deel 50%', 18.91);
INSERT INTO boekregels VALUES (2718, 522, 2014, '2014-06-09', 2200, NULL, 0, 0, 'xs4all', '44470835', '', 'Internet jun zakelijk deel 50%', 3.97);
INSERT INTO boekregels VALUES (2719, 522, 2014, '2014-06-09', 1060, NULL, 0, 0, 'xs4all', '44470835', '', 'Internet jun prive deel 50%', 22.87);
INSERT INTO boekregels VALUES (2723, 524, 2014, '2014-04-01', 4220, NULL, 2724, 0, '', '', '', 'Pokerset als model vr muursch.', 14.04);
INSERT INTO boekregels VALUES (2724, 524, 2014, '2014-04-01', 2200, NULL, 0, 0, '', '', '', 'Pokerset als model vr muursch.', 2.95);
INSERT INTO boekregels VALUES (2726, 524, 2014, '2014-04-01', 2200, NULL, 0, 0, '', '', '', 'Set vr. lijsten', 1.04);
INSERT INTO boekregels VALUES (2725, 524, 2014, '2014-04-01', 4220, NULL, 2726, 0, '', '', '', 'Set vr. lijsten', 4.95);
INSERT INTO boekregels VALUES (2728, 524, 2014, '2014-04-08', 2210, NULL, 0, 0, '', '', '', 'Brandstof', 11.67);
INSERT INTO boekregels VALUES (2727, 524, 2014, '2014-04-08', 4410, NULL, 2728, 0, '', '', '', 'Brandstof', 55.57);
INSERT INTO boekregels VALUES (2730, 524, 2014, '2014-04-08', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.48);
INSERT INTO boekregels VALUES (2729, 524, 2014, '2014-04-08', 4290, NULL, 2730, 0, '', '', '', 'Lunch', 7.97);
INSERT INTO boekregels VALUES (2735, 524, 2014, '2014-04-19', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.79);
INSERT INTO boekregels VALUES (2734, 524, 2014, '2014-04-19', 4410, NULL, 2735, 0, '', '', '', 'Brandstof Nissan', 37.09);
INSERT INTO boekregels VALUES (2737, 524, 2014, '2014-04-19', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.16);
INSERT INTO boekregels VALUES (2736, 524, 2014, '2014-04-19', 4290, NULL, 2737, 0, '', '', '', 'Lunch', 2.59);
INSERT INTO boekregels VALUES (2739, 524, 2014, '2014-04-23', 2210, NULL, 0, 0, '', '', '', 'Ruitenwissers', 2.60);
INSERT INTO boekregels VALUES (2738, 524, 2014, '2014-04-23', 4450, NULL, 2739, 0, '', '', '', 'Ruitenwissers', 12.39);
INSERT INTO boekregels VALUES (2741, 524, 2014, '2014-04-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.79);
INSERT INTO boekregels VALUES (2740, 524, 2014, '2014-04-23', 4410, NULL, 2741, 0, '', '', '', 'Brandstof Nissan', 51.39);
INSERT INTO boekregels VALUES (2744, 525, 2014, '2014-05-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 2.56);
INSERT INTO boekregels VALUES (2743, 525, 2014, '2014-05-01', 4410, NULL, 2744, 0, '', '', '', 'Brandstof Nissan', 12.19);
INSERT INTO boekregels VALUES (2746, 525, 2014, '2014-05-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.15);
INSERT INTO boekregels VALUES (2745, 525, 2014, '2014-05-02', 4410, NULL, 2746, 0, '', '', '', 'Brandstof Nissan', 53.12);
INSERT INTO boekregels VALUES (2748, 525, 2014, '2014-05-02', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen onderweg', 0.23);
INSERT INTO boekregels VALUES (2747, 525, 2014, '2014-05-02', 4290, NULL, 2748, 0, '', '', '', 'Versnaperingen onderweg', 3.87);
INSERT INTO boekregels VALUES (2742, 524, 2014, '2014-04-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 04 2014', -244.92);
INSERT INTO boekregels VALUES (2750, 525, 2014, '2014-05-06', 2210, NULL, 0, 0, '', '', '', 'Autoaccessoires', 1.91);
INSERT INTO boekregels VALUES (2749, 525, 2014, '2014-05-06', 4440, NULL, 2750, 0, '', '', '', 'Autoaccessoires', 9.07);
INSERT INTO boekregels VALUES (2752, 525, 2014, '2014-05-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 2.95);
INSERT INTO boekregels VALUES (2751, 525, 2014, '2014-05-09', 4410, NULL, 2752, 0, '', '', '', 'Brandstof Nissan', 14.05);
INSERT INTO boekregels VALUES (2756, 525, 2014, '2014-05-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.09);
INSERT INTO boekregels VALUES (2755, 525, 2014, '2014-05-10', 4410, NULL, 2756, 0, '', '', '', 'Brandstof Nissan', 48.04);
INSERT INTO boekregels VALUES (2758, 525, 2014, '2014-05-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.59);
INSERT INTO boekregels VALUES (2757, 525, 2014, '2014-05-14', 4410, NULL, 2758, 0, '', '', '', 'Brandstof Nissan', 55.20);
INSERT INTO boekregels VALUES (2760, 525, 2014, '2014-05-22', 2200, NULL, 0, 0, '', '', '', 'Lunch met helpster spuitwand', 1.57);
INSERT INTO boekregels VALUES (2759, 525, 2014, '2014-05-22', 4290, NULL, 2760, 0, '', '', '', 'Lunch met helpster spuitwand', 26.18);
INSERT INTO boekregels VALUES (2762, 525, 2014, '2014-05-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.80);
INSERT INTO boekregels VALUES (2761, 525, 2014, '2014-05-24', 4410, NULL, 2762, 0, '', '', '', 'Brandstof Nissan', 32.38);
INSERT INTO boekregels VALUES (2763, 525, 2014, '2014-05-25', 4270, NULL, 0, 0, '', '', '', 'Parkeerkosten Den Haad', 2.50);
INSERT INTO boekregels VALUES (2765, 525, 2014, '2014-05-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.21);
INSERT INTO boekregels VALUES (2764, 525, 2014, '2014-05-23', 4410, NULL, 2765, 0, '', '', '', 'Brandstof Nissan', 24.79);
INSERT INTO boekregels VALUES (2767, 525, 2014, '2014-05-26', 2200, NULL, 0, 0, '', '', '', 'Lunch', 0.60);
INSERT INTO boekregels VALUES (2766, 525, 2014, '2014-05-26', 4290, NULL, 2767, 0, '', '', '', 'Lunch', 10.00);
INSERT INTO boekregels VALUES (2753, 525, 2014, '2014-05-09', 4220, NULL, 2754, 0, '', '', '', 'Cleaner foto apparatuur dia''s', 18.39);
INSERT INTO boekregels VALUES (2769, 525, 2014, '2014-05-26', 2200, NULL, 0, 0, '', '', '', 'Steekkar', 2.43);
INSERT INTO boekregels VALUES (2768, 525, 2014, '2014-05-26', 4220, NULL, 2769, 0, '', '', '', 'Steekkar', 11.56);
INSERT INTO boekregels VALUES (2771, 525, 2014, '2014-05-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 1.74);
INSERT INTO boekregels VALUES (2770, 525, 2014, '2014-05-27', 4410, NULL, 2771, 0, '', '', '', 'Brandstof Nissan', 8.29);
INSERT INTO boekregels VALUES (2773, 525, 2014, '2014-05-27', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen onderweg', 0.18);
INSERT INTO boekregels VALUES (2772, 525, 2014, '2014-05-27', 4290, NULL, 2773, 0, '', '', '', 'Versnaperingen onderweg', 2.92);
INSERT INTO boekregels VALUES (2775, 525, 2014, '2014-05-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.14);
INSERT INTO boekregels VALUES (2774, 525, 2014, '2014-05-27', 4410, NULL, 2775, 0, '', '', '', 'Brandstof Nissan', 48.28);
INSERT INTO boekregels VALUES (2777, 525, 2014, '2014-05-28', 2200, NULL, 0, 0, '', '', '', 'Roller en folie', 2.55);
INSERT INTO boekregels VALUES (2776, 525, 2014, '2014-05-28', 4220, NULL, 2777, 0, '', '', '', 'Roller en folie', 12.12);
INSERT INTO boekregels VALUES (2779, 525, 2014, '2014-05-30', 2200, NULL, 0, 0, '', '', '', 'Jabra Clear bluetooth oortje', 8.67);
INSERT INTO boekregels VALUES (2778, 525, 2014, '2014-05-30', 4230, NULL, 2779, 0, '', '', '', 'Jabra Clear bluetooth oortje', 41.31);
INSERT INTO boekregels VALUES (2780, 525, 2014, '2014-05-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 05 2014', -518.49);
INSERT INTO boekregels VALUES (2782, 526, 2014, '2014-06-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.41);
INSERT INTO boekregels VALUES (2781, 526, 2014, '2014-06-02', 4410, NULL, 2782, 0, '', '', '', 'Brandstof Nissan', 44.81);
INSERT INTO boekregels VALUES (2784, 526, 2014, '2014-06-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.21);
INSERT INTO boekregels VALUES (2783, 526, 2014, '2014-06-07', 4410, NULL, 2784, 0, '', '', '', 'Brandstof Nissan', 24.80);
INSERT INTO boekregels VALUES (2785, 526, 2014, '2014-06-11', 4270, NULL, 0, 0, '', '', '', 'Parkeren Den Haag', 3.00);
INSERT INTO boekregels VALUES (2787, 526, 2014, '2014-06-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.59);
INSERT INTO boekregels VALUES (2786, 526, 2014, '2014-06-14', 4410, NULL, 2787, 0, '', '', '', 'Brandstof Nissan', 55.19);
INSERT INTO boekregels VALUES (2789, 526, 2014, '2014-06-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.83);
INSERT INTO boekregels VALUES (2788, 526, 2014, '2014-06-21', 4410, NULL, 2789, 0, '', '', '', 'Brandstof Nissan', 37.28);
INSERT INTO boekregels VALUES (2791, 526, 2014, '2014-06-21', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen onderweg', 0.11);
INSERT INTO boekregels VALUES (2790, 526, 2014, '2014-06-21', 4290, NULL, 2791, 0, '', '', '', 'Versnaperingen onderweg', 1.78);
INSERT INTO boekregels VALUES (2793, 526, 2014, '2014-06-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.64);
INSERT INTO boekregels VALUES (2792, 526, 2014, '2014-06-29', 4410, NULL, 2793, 0, '', '', '', 'Brandstof Nissan', 55.40);
INSERT INTO boekregels VALUES (2794, 526, 2014, '2014-06-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 06 2014', -268.05);
INSERT INTO boekregels VALUES (2796, 527, 2014, '2014-04-02', 2110, NULL, 0, 0, '', '', '', 'Muurschildering Den Haag', -34.71);
INSERT INTO boekregels VALUES (2795, 527, 2014, '2014-04-02', 8060, NULL, 2796, 0, '', '', '', 'Muurschildering Den Haag', -165.29);
INSERT INTO boekregels VALUES (2798, 527, 2014, '2014-05-02', 2110, NULL, 0, 0, '', '', '', 'Muurschildering Zaandam', -34.71);
INSERT INTO boekregels VALUES (2797, 527, 2014, '2014-05-02', 8060, NULL, 2798, 0, '', '', '', 'Muurschildering Zaandam', -165.29);
INSERT INTO boekregels VALUES (2800, 527, 2014, '2014-05-29', 2110, NULL, 0, 0, '', '', '', 'Schildering tekst Spijkenisse', -17.36);
INSERT INTO boekregels VALUES (2799, 527, 2014, '2014-05-29', 8070, NULL, 2800, 0, '', '', '', 'Schildering tekst Spijkenisse', -82.64);
INSERT INTO boekregels VALUES (2814, 531, 2014, '2014-06-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -150.05);
INSERT INTO boekregels VALUES (2802, 528, 2014, '2014-04-11', 8070, NULL, 2803, 0, 'midholl', '2014004', '', 'Muurschildering Jeugdhonk Nieuw Lekkerland', -294.00);
INSERT INTO boekregels VALUES (2815, 531, 2014, '2014-06-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -256.46);
INSERT INTO boekregels VALUES (2803, 528, 2014, '2014-04-11', 2110, NULL, 0, 0, 'midholl', '2014004', '', 'Muurschildering Jeugdhonk Nieuw Lekkerland', -61.74);
INSERT INTO boekregels VALUES (2804, 528, 2014, '2014-04-11', 1200, NULL, 0, 0, 'midholl', '2014004', '', 'Muurschildering Jeugdhonk Nieuw Lekkerland', 355.74);
INSERT INTO boekregels VALUES (2805, 529, 2014, '2014-04-11', 1200, NULL, 0, 0, 'lbc', '2014005', '', 'Diverse muurschilderingen binnen', 745.66);
INSERT INTO boekregels VALUES (2807, 529, 2014, '2014-04-11', 2110, NULL, 0, 0, 'lbc', '2014005', '', 'Diverse muurschilderingen binnen', -129.41);
INSERT INTO boekregels VALUES (2806, 529, 2014, '2014-04-11', 8070, NULL, 2807, 0, 'lbc', '2014005', '', 'Diverse muurschilderingen binnen', -616.25);
INSERT INTO boekregels VALUES (2808, 530, 2014, '2014-05-21', 1200, NULL, 0, 0, 'coppoolse', '2014007', '', 'Graffiti schildering op doek', 157.30);
INSERT INTO boekregels VALUES (2816, 531, 2014, '2014-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -339.94);
INSERT INTO boekregels VALUES (2809, 530, 2014, '2014-05-21', 8070, NULL, 2810, 0, 'coppoolse', '2014007', '', 'Graffiti schildering op doek', -130.00);
INSERT INTO boekregels VALUES (2810, 530, 2014, '2014-05-21', 2110, NULL, 0, 0, 'coppoolse', '2014007', '', 'Graffiti schildering op doek', -27.30);
INSERT INTO boekregels VALUES (2801, 527, 2014, '2014-06-30', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 2e kwartaal', 700.00);
INSERT INTO boekregels VALUES (2812, 527, 2014, '2014-06-14', 2110, NULL, 0, 0, '', '', '', 'Muurschildering Den Haag', -34.71);
INSERT INTO boekregels VALUES (2811, 527, 2014, '2014-06-14', 8060, NULL, 2812, 0, '', '', '', 'Muurschildering Den Haag', -165.29);
INSERT INTO boekregels VALUES (2813, 531, 2014, '2014-06-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 339.94);
INSERT INTO boekregels VALUES (2817, 531, 2014, '2014-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.06);
INSERT INTO boekregels VALUES (2818, 531, 2014, '2014-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2210', 256.46);
INSERT INTO boekregels VALUES (2819, 531, 2014, '2014-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 150.05);
INSERT INTO boekregels VALUES (2820, 531, 2014, '2014-06-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', 0.49);
INSERT INTO boekregels VALUES (2821, 531, 2014, '2014-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.06);
INSERT INTO boekregels VALUES (2822, 531, 2014, '2014-06-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', -0.49);
INSERT INTO boekregels VALUES (2823, 532, 2014, '2014-07-09', 1600, NULL, 0, 0, 'xs4all', '44714386', '', 'Internet jul', -45.50);
INSERT INTO boekregels VALUES (2825, 532, 2014, '2014-07-09', 2200, NULL, 0, 0, 'xs4all', '44714386', '', 'Internet jul zakelijk deel 75%', 5.92);
INSERT INTO boekregels VALUES (2824, 532, 2014, '2014-07-09', 4245, NULL, 2825, 0, 'xs4all', '44714386', '', 'Internet jul zakelijk deel 75%', 28.21);
INSERT INTO boekregels VALUES (2826, 532, 2014, '2014-07-09', 1060, NULL, 0, 0, 'xs4all', '44714386', '', 'Internet jul prive deel 25%', 11.37);
INSERT INTO boekregels VALUES (2827, 533, 2014, '2014-07-21', 1600, NULL, 0, 0, 'tmobile', '901222065965', '', 'Telefoon 16/7-15/8', -31.51);
INSERT INTO boekregels VALUES (2829, 533, 2014, '2014-07-21', 2200, NULL, 0, 0, 'tmobile', '901222065965', '', 'Telefoon 16/7-15/8', 5.47);
INSERT INTO boekregels VALUES (2828, 533, 2014, '2014-07-21', 4240, NULL, 2829, 0, 'tmobile', '901222065965', '', 'Telefoon 16/7-15/8', 26.04);
INSERT INTO boekregels VALUES (2830, 534, 2014, '2014-07-26', 1600, NULL, 0, 0, 'mediamarkt', '40808626', '', 'Asus pad 7inch', -124.00);
INSERT INTO boekregels VALUES (2832, 534, 2014, '2014-07-26', 2200, NULL, 0, 0, 'mediamarkt', '40808626', '', 'Asus pad 7inch', 21.52);
INSERT INTO boekregels VALUES (2831, 534, 2014, '2014-07-26', 4210, NULL, 2832, 0, 'mediamarkt', '40808626', '', 'Asus pad 7inch', 102.48);
INSERT INTO boekregels VALUES (2833, 535, 2014, '2014-08-06', 1600, NULL, 0, 0, 'claasen', '824815', '', 'Morsverf Latex', -47.80);
INSERT INTO boekregels VALUES (2835, 535, 2014, '2014-08-06', 2200, NULL, 0, 0, 'claasen', '824815', '', 'Morsverf Latex', 8.30);
INSERT INTO boekregels VALUES (2834, 535, 2014, '2014-08-06', 5010, NULL, 2835, 0, 'claasen', '824815', '', 'Morsverf Latex', 39.50);
INSERT INTO boekregels VALUES (2836, 536, 2014, '2014-08-09', 1600, NULL, 0, 0, 'xs4all', '44965935', '', 'Internet aug', -44.58);
INSERT INTO boekregels VALUES (2838, 536, 2014, '2014-08-09', 2200, NULL, 0, 0, 'xs4all', '44965935', '', 'Internet aug zakelijk deel 75%', 5.80);
INSERT INTO boekregels VALUES (2837, 536, 2014, '2014-08-09', 4245, NULL, 2838, 0, 'xs4all', '44965935', '', 'Internet aug zakelijk deel 75%', 27.64);
INSERT INTO boekregels VALUES (2839, 536, 2014, '2014-08-09', 1060, NULL, 0, 0, 'xs4all', '44965935', '', 'Internet aug prive deel 25%', 11.14);
INSERT INTO boekregels VALUES (2840, 537, 2014, '2014-08-14', 1600, NULL, 0, 0, 'vandien', '20157465', '', 'Nissan 11/8-11/11', -120.75);
INSERT INTO boekregels VALUES (2841, 537, 2014, '2014-08-14', 4420, NULL, 0, 0, 'vandien', '20157465', '', 'Nissan 11/8-11/11', 120.75);
INSERT INTO boekregels VALUES (2842, 538, 2014, '2014-08-18', 1600, NULL, 0, 0, 'belasting', '69414993M46', '', 'Nissan 17/8-16/11', -79.00);
INSERT INTO boekregels VALUES (2843, 538, 2014, '2014-08-18', 4430, NULL, 0, 0, 'belasting', '69414993M46', '', 'Nissan 17/8-16/11', 79.00);
INSERT INTO boekregels VALUES (2844, 539, 2014, '2014-08-20', 1600, NULL, 0, 0, 'tmobile', '901224253796', '', 'Telefoon 16/8-15/9', -34.73);
INSERT INTO boekregels VALUES (2846, 539, 2014, '2014-08-20', 2200, NULL, 0, 0, 'tmobile', '901224253796', '', 'Telefoon 16/8-15/9', 6.03);
INSERT INTO boekregels VALUES (2845, 539, 2014, '2014-08-20', 4240, NULL, 2846, 0, 'tmobile', '901224253796', '', 'Telefoon 16/8-15/9', 28.70);
INSERT INTO boekregels VALUES (2847, 540, 2014, '2014-08-21', 1600, NULL, 0, 0, 'hofman', '201424', '', 'Nieuwe Accu Nissan', -140.36);
INSERT INTO boekregels VALUES (2849, 540, 2014, '2014-08-21', 2210, NULL, 0, 0, 'hofman', '201424', '', 'Nieuwe Accu Nissan', 24.36);
INSERT INTO boekregels VALUES (2848, 540, 2014, '2014-08-21', 4450, NULL, 2849, 0, 'hofman', '201424', '', 'Nieuwe Accu Nissan', 116.00);
INSERT INTO boekregels VALUES (2850, 541, 2014, '2014-08-30', 1600, NULL, 0, 0, 'hofman', '2014211', '', 'Nissan Kleine beurt', -339.80);
INSERT INTO boekregels VALUES (2852, 541, 2014, '2014-08-30', 2210, NULL, 0, 0, 'hofman', '2014211', '', 'Nissan Kleine beurt', 58.97);
INSERT INTO boekregels VALUES (2851, 541, 2014, '2014-08-30', 4450, NULL, 2852, 0, 'hofman', '2014211', '', 'Nissan Kleine beurt', 280.83);
INSERT INTO boekregels VALUES (2853, 542, 2014, '2014-09-08', 1600, NULL, 0, 0, 'vandien', '20168476', '', 'Aanpassing schadevrije jaren van 74 naar 72%', -8.51);
INSERT INTO boekregels VALUES (2939, 556, 2014, '2014-09-25', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 1.63);
INSERT INTO boekregels VALUES (2854, 542, 2014, '2014-09-08', 4420, NULL, 0, 0, 'vandien', '20168476', '', 'Aanpassing schadevrije jaren van 74 naar 72%', 8.51);
INSERT INTO boekregels VALUES (2855, 543, 2014, '2014-09-09', 1600, NULL, 0, 0, 'xs4all', '45205585', '', 'Internet sep', -49.99);
INSERT INTO boekregels VALUES (2857, 543, 2014, '2014-09-09', 2200, NULL, 0, 0, 'xs4all', '45205585', '', 'Internet sep zakelijk deel 70%', 6.07);
INSERT INTO boekregels VALUES (2856, 543, 2014, '2014-09-09', 4245, NULL, 2857, 0, 'xs4all', '45205585', '', 'Internet sep zakelijk deel 70%', 28.92);
INSERT INTO boekregels VALUES (2858, 543, 2014, '2014-09-09', 1060, NULL, 0, 0, 'xs4all', '45205585', '', 'Internet sep prive deel 30%', 15.00);
INSERT INTO boekregels VALUES (2859, 544, 2014, '2014-09-20', 1600, NULL, 0, 0, 'vanbeek', '1169725', '', 'Linnen', -70.75);
INSERT INTO boekregels VALUES (2861, 544, 2014, '2014-09-20', 2200, NULL, 0, 0, 'vanbeek', '1169725', '', 'Linnen', 12.28);
INSERT INTO boekregels VALUES (2860, 544, 2014, '2014-09-20', 5010, NULL, 2861, 0, 'vanbeek', '1169725', '', 'Linnen', 58.47);
INSERT INTO boekregels VALUES (2862, 545, 2014, '2014-09-20', 1600, NULL, 0, 0, 'vanbeek', '1169731', '', 'Acryl', -12.29);
INSERT INTO boekregels VALUES (2864, 545, 2014, '2014-09-20', 2200, NULL, 0, 0, 'vanbeek', '1169731', '', 'Acryl', 2.13);
INSERT INTO boekregels VALUES (2863, 545, 2014, '2014-09-20', 5010, NULL, 2864, 0, 'vanbeek', '1169731', '', 'Acryl', 10.16);
INSERT INTO boekregels VALUES (2865, 546, 2014, '2014-09-22', 1600, NULL, 0, 0, 'tmobile', '901226471417', '', 'Telefoon 16/9-15/10', -28.99);
INSERT INTO boekregels VALUES (2867, 546, 2014, '2014-09-22', 2200, NULL, 0, 0, 'tmobile', '901226471417', '', 'Telefoon 16/9-15/10', 5.03);
INSERT INTO boekregels VALUES (2866, 546, 2014, '2014-09-22', 4240, NULL, 2867, 0, 'tmobile', '901226471417', '', 'Telefoon 16/9-15/10', 23.96);
INSERT INTO boekregels VALUES (2868, 547, 2014, '2014-09-25', 1600, NULL, 0, 0, 'publikat', 'RE1425857', '', 'Spuitmateriaal', -171.94);
INSERT INTO boekregels VALUES (2870, 547, 2014, '2014-09-25', 2200, NULL, 0, 0, 'publikat', 'RE1425857', '', 'Spuitmateriaal', 29.84);
INSERT INTO boekregels VALUES (2869, 547, 2014, '2014-09-25', 5010, NULL, 2870, 0, 'publikat', 'RE1425857', '', 'Spuitmateriaal', 142.10);
INSERT INTO boekregels VALUES (2871, 548, 2014, '2014-09-27', 1600, NULL, 0, 0, 'vanbeek', '1173616', '', 'Linnen ruilen en bijbetalen', -90.44);
INSERT INTO boekregels VALUES (2873, 548, 2014, '2014-09-27', 2200, NULL, 0, 0, 'vanbeek', '1173616', '', 'Linnen ruilen en bijbetalen', 15.70);
INSERT INTO boekregels VALUES (2872, 548, 2014, '2014-09-27', 5010, NULL, 2873, 0, 'vanbeek', '1173616', '', 'Linnen ruilen en bijbetalen', 74.74);
INSERT INTO boekregels VALUES (2874, 550, 2014, '2014-07-11', 1200, NULL, 0, 0, 'luc4me', '201409', '', 'Muurschildering', 308.55);
INSERT INTO boekregels VALUES (2876, 550, 2014, '2014-07-11', 2110, NULL, 0, 0, 'luc4me', '201409', '', 'Muurschildering', -53.55);
INSERT INTO boekregels VALUES (2875, 550, 2014, '2014-07-11', 8070, NULL, 2876, 0, 'luc4me', '201409', '', 'Muurschildering', -255.00);
INSERT INTO boekregels VALUES (2877, 551, 2014, '2014-07-11', 1200, NULL, 0, 0, 'luc4me', '201410', '', 'Houten paneel', 36.30);
INSERT INTO boekregels VALUES (2879, 551, 2014, '2014-07-11', 2110, NULL, 0, 0, 'luc4me', '201410', '', 'Houten paneel', -6.30);
INSERT INTO boekregels VALUES (2878, 551, 2014, '2014-07-11', 8070, NULL, 2879, 0, 'luc4me', '201410', '', 'Houten paneel', -30.00);
INSERT INTO boekregels VALUES (2883, 553, 2014, '2014-07-09', 1200, NULL, 0, 0, 'leeuwenauto', '201408', '', 'Live Graffitischildering op doek', 605.00);
INSERT INTO boekregels VALUES (2885, 553, 2014, '2014-07-09', 2110, NULL, 0, 0, 'leeuwenauto', '201408', '', 'Live Graffitischildering op doek', -105.00);
INSERT INTO boekregels VALUES (2884, 553, 2014, '2014-07-09', 8075, NULL, 2885, 0, 'leeuwenauto', '201408', '', 'Live Graffitischildering op doek', -500.00);
INSERT INTO boekregels VALUES (2887, 554, 2014, '2014-07-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 8.85);
INSERT INTO boekregels VALUES (2886, 554, 2014, '2014-07-07', 4410, NULL, 2887, 0, '', '', '', 'Brandstof Nissan', 42.15);
INSERT INTO boekregels VALUES (2889, 554, 2014, '2014-07-08', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 8.68);
INSERT INTO boekregels VALUES (2888, 554, 2014, '2014-07-08', 4410, NULL, 2889, 0, '', '', '', 'Brandstof Nissan', 41.34);
INSERT INTO boekregels VALUES (2891, 554, 2014, '2014-07-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.42);
INSERT INTO boekregels VALUES (2890, 554, 2014, '2014-07-13', 4410, NULL, 2891, 0, '', '', '', 'Brandstof Nissan', 49.60);
INSERT INTO boekregels VALUES (2893, 554, 2014, '2014-07-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.52);
INSERT INTO boekregels VALUES (2892, 554, 2014, '2014-07-21', 4410, NULL, 2893, 0, '', '', '', 'Brandstof Nissan', 54.86);
INSERT INTO boekregels VALUES (2895, 554, 2014, '2014-07-21', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 1.39);
INSERT INTO boekregels VALUES (2894, 554, 2014, '2014-07-21', 5010, NULL, 2895, 0, '', '', '', 'Plaatmateriaal', 6.60);
INSERT INTO boekregels VALUES (2897, 554, 2014, '2014-07-26', 2200, NULL, 0, 0, '', '', '', 'Hoesje Pad', 2.60);
INSERT INTO boekregels VALUES (2896, 554, 2014, '2014-07-26', 4220, NULL, 2897, 0, '', '', '', 'Hoesje Pad', 12.39);
INSERT INTO boekregels VALUES (2899, 554, 2014, '2014-07-26', 2200, NULL, 0, 0, '', '', '', 'Geheugen Pad', 3.47);
INSERT INTO boekregels VALUES (2898, 554, 2014, '2014-07-26', 4220, NULL, 2899, 0, '', '', '', 'Geheugen Pad', 16.52);
INSERT INTO boekregels VALUES (2901, 554, 2014, '2014-07-27', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.99);
INSERT INTO boekregels VALUES (2900, 554, 2014, '2014-07-27', 4410, NULL, 2901, 0, '', '', '', 'Brandstof Nissan', 52.32);
INSERT INTO boekregels VALUES (2902, 554, 2014, '2014-07-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 07 2014', -333.70);
INSERT INTO boekregels VALUES (2904, 555, 2014, '2014-08-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.95);
INSERT INTO boekregels VALUES (2903, 555, 2014, '2014-08-03', 4410, NULL, 2904, 0, '', '', '', 'Brandstof Nissan', 33.07);
INSERT INTO boekregels VALUES (2906, 555, 2014, '2014-08-03', 2200, NULL, 0, 0, '', '', '', 'Versnapering onderweg', 0.13);
INSERT INTO boekregels VALUES (2905, 555, 2014, '2014-08-03', 4290, NULL, 2906, 0, '', '', '', 'Versnapering onderweg', 2.12);
INSERT INTO boekregels VALUES (2908, 555, 2014, '2014-08-07', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.98);
INSERT INTO boekregels VALUES (2907, 555, 2014, '2014-08-07', 4410, NULL, 2908, 0, '', '', '', 'Brandstof Nissan', 52.26);
INSERT INTO boekregels VALUES (2910, 555, 2014, '2014-08-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.99);
INSERT INTO boekregels VALUES (2909, 555, 2014, '2014-08-17', 4410, NULL, 2910, 0, '', '', '', 'Brandstof Nissan', 52.36);
INSERT INTO boekregels VALUES (2911, 555, 2014, '2014-08-22', 4270, NULL, 0, 0, '', '', '', 'Parkeren Asd', 16.00);
INSERT INTO boekregels VALUES (2913, 555, 2014, '2014-08-24', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 13.20);
INSERT INTO boekregels VALUES (2912, 555, 2014, '2014-08-24', 4410, NULL, 2913, 0, '', '', '', 'Brandstof Nissan', 62.85);
INSERT INTO boekregels VALUES (2915, 555, 2014, '2014-08-31', 2200, NULL, 0, 0, '', '', '', 'Latex en roller', 3.64);
INSERT INTO boekregels VALUES (2914, 555, 2014, '2014-08-31', 5010, NULL, 2915, 0, '', '', '', 'Latex en roller', 19.70);
INSERT INTO boekregels VALUES (2916, 555, 2014, '2014-08-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 08 2014', -284.25);
INSERT INTO boekregels VALUES (2918, 556, 2014, '2014-09-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 4.99);
INSERT INTO boekregels VALUES (2920, 556, 2014, '2014-09-02', 2200, NULL, 0, 0, '', '', '', 'Versnapering onderweg', 0.08);
INSERT INTO boekregels VALUES (2917, 556, 2014, '2014-09-02', 4410, NULL, 2918, 0, '', '', '', 'Brandstof Nissan', 23.76);
INSERT INTO boekregels VALUES (2919, 556, 2014, '2014-09-02', 4290, NULL, 2920, 0, '', '', '', 'Versnapering onderweg', 1.42);
INSERT INTO boekregels VALUES (2921, 556, 2014, '2014-09-04', 4270, NULL, 0, 0, '', '', '', 'Parkeren DH', 2.90);
INSERT INTO boekregels VALUES (2923, 556, 2014, '2014-09-04', 2200, NULL, 0, 0, '', '', '', 'Parkeren Hilversum', 1.65);
INSERT INTO boekregels VALUES (2922, 556, 2014, '2014-09-04', 4270, NULL, 2923, 0, '', '', '', 'Parkeren Hilversum', 7.85);
INSERT INTO boekregels VALUES (2925, 556, 2014, '2014-09-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.92);
INSERT INTO boekregels VALUES (2924, 556, 2014, '2014-09-04', 4410, NULL, 2925, 0, '', '', '', 'Brandstof Nissan', 52.02);
INSERT INTO boekregels VALUES (2927, 556, 2014, '2014-09-10', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (2926, 556, 2014, '2014-09-10', 4230, NULL, 2927, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (2929, 556, 2014, '2014-09-17', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.15);
INSERT INTO boekregels VALUES (2928, 556, 2014, '2014-09-17', 4410, NULL, 2929, 0, '', '', '', 'Brandstof Nissan', 24.52);
INSERT INTO boekregels VALUES (2931, 556, 2014, '2014-09-21', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.41);
INSERT INTO boekregels VALUES (2930, 556, 2014, '2014-09-21', 4410, NULL, 2931, 0, '', '', '', 'Brandstof Nissan', 49.59);
INSERT INTO boekregels VALUES (2933, 556, 2014, '2014-09-21', 2200, NULL, 0, 0, '', '', '', 'Versnapering onderweg', 0.10);
INSERT INTO boekregels VALUES (2932, 556, 2014, '2014-09-21', 4290, NULL, 2933, 0, '', '', '', 'Versnapering onderweg', 1.65);
INSERT INTO boekregels VALUES (2935, 556, 2014, '2014-09-22', 2200, NULL, 0, 0, '', '', '', 'Acryl en doek Xenos', 5.70);
INSERT INTO boekregels VALUES (2934, 556, 2014, '2014-09-22', 5010, NULL, 2935, 0, '', '', '', 'Acryl en doek Xenos', 27.17);
INSERT INTO boekregels VALUES (2937, 556, 2014, '2014-09-22', 2200, NULL, 0, 0, '', '', '', 'Doek Xenos', 7.50);
INSERT INTO boekregels VALUES (2936, 556, 2014, '2014-09-22', 5010, NULL, 2937, 0, '', '', '', 'Doek Xenos', 35.73);
INSERT INTO boekregels VALUES (2938, 556, 2014, '2014-09-25', 5010, NULL, 2939, 0, '', '', '', 'Plaatmateriaal', 7.76);
INSERT INTO boekregels VALUES (2941, 556, 2014, '2014-09-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.94);
INSERT INTO boekregels VALUES (2940, 556, 2014, '2014-09-26', 4410, NULL, 2941, 0, '', '', '', 'Brandstof Nissan', 33.05);
INSERT INTO boekregels VALUES (2943, 556, 2014, '2014-09-29', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.73);
INSERT INTO boekregels VALUES (2942, 556, 2014, '2014-09-29', 4410, NULL, 2943, 0, '', '', '', 'Brandstof Nissan', 36.83);
INSERT INTO boekregels VALUES (2944, 556, 2014, '2014-09-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 09 2014', -373.50);
INSERT INTO boekregels VALUES (2969, 559, 2014, '2014-10-04', 5010, NULL, 2970, 0, 'vanbeek', '1176316', '', 'Diverse lijsten', 19.83);
INSERT INTO boekregels VALUES (2945, 557, 2014, '2014-07-20', 8060, NULL, 2946, 0, '', '', '', 'Dion Den Haag', -111.57);
INSERT INTO boekregels VALUES (2946, 557, 2014, '2014-07-20', 2110, NULL, 0, 0, '', '', '', 'Dion Den Haag', -23.43);
INSERT INTO boekregels VALUES (2948, 557, 2014, '2014-07-25', 2110, NULL, 0, 0, '', '', '', 'Wouter Dordrecht', -23.43);
INSERT INTO boekregels VALUES (2947, 557, 2014, '2014-07-25', 8060, NULL, 2948, 0, '', '', '', 'Wouter Dordrecht', -111.57);
INSERT INTO boekregels VALUES (2950, 557, 2014, '2014-08-11', 2110, NULL, 0, 0, '', '', '', 'Schilderij Michael Dingsdag', -23.43);
INSERT INTO boekregels VALUES (2949, 557, 2014, '2014-08-11', 8065, NULL, 2950, 0, '', '', '', 'Schilderij Michael Dingsdag', -111.57);
INSERT INTO boekregels VALUES (2952, 557, 2014, '2014-08-29', 2110, NULL, 0, 0, '', '', '', 'Hond Sander Waddinxveen', -26.03);
INSERT INTO boekregels VALUES (2951, 557, 2014, '2014-08-29', 8060, NULL, 2952, 0, '', '', '', 'Hond Sander Waddinxveen', -123.97);
INSERT INTO boekregels VALUES (2954, 557, 2014, '2014-09-06', 2110, NULL, 0, 0, '', '', '', 'Tom Den Haag', -17.36);
INSERT INTO boekregels VALUES (2953, 557, 2014, '2014-09-06', 8060, NULL, 2954, 0, '', '', '', 'Tom Den Haag', -82.64);
INSERT INTO boekregels VALUES (2956, 557, 2014, '2014-09-06', 2110, NULL, 0, 0, '', '', '', 'Arthur Den Haag', -17.36);
INSERT INTO boekregels VALUES (2955, 557, 2014, '2014-09-06', 8060, NULL, 2956, 0, '', '', '', 'Arthur Den Haag', -82.64);
INSERT INTO boekregels VALUES (2957, 557, 2014, '2014-09-30', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 3e kwartaal', 755.00);
INSERT INTO boekregels VALUES (2958, 558, 2014, '2014-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 421.89);
INSERT INTO boekregels VALUES (2959, 558, 2014, '2014-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -152.35);
INSERT INTO boekregels VALUES (2960, 558, 2014, '2014-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -222.05);
INSERT INTO boekregels VALUES (2961, 558, 2014, '2014-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -421.89);
INSERT INTO boekregels VALUES (2962, 558, 2014, '2014-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.11);
INSERT INTO boekregels VALUES (2963, 558, 2014, '2014-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 222.05);
INSERT INTO boekregels VALUES (2964, 558, 2014, '2014-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 152.35);
INSERT INTO boekregels VALUES (2965, 558, 2014, '2014-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.40);
INSERT INTO boekregels VALUES (2966, 558, 2014, '2014-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.11);
INSERT INTO boekregels VALUES (2967, 558, 2014, '2014-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.40);
INSERT INTO boekregels VALUES (2882, 552, 2014, '2014-07-20', 2110, NULL, 0, 0, 'rooiehoek', '201411', '', 'Schildering plafond', -126.00);
INSERT INTO boekregels VALUES (2881, 552, 2014, '2014-07-20', 8070, NULL, 2882, 0, 'rooiehoek', '201411', '', 'Schildering plafond', -600.00);
INSERT INTO boekregels VALUES (2880, 552, 2014, '2014-07-20', 1200, NULL, 0, 0, 'rooiehoek', '201411', '', 'Schildering plafond', 726.00);
INSERT INTO boekregels VALUES (2474, 474, 2013, '2013-12-31', 2200, NULL, 0, 0, '', '', '', 'Afschrijving van fakt. 2012003', 67.05);
INSERT INTO boekregels VALUES (2754, 525, 2014, '2014-05-09', 2200, NULL, 0, 0, '', '', '', 'Cleaner foto apparatuur dia''s', 3.86);
INSERT INTO boekregels VALUES (2968, 559, 2014, '2014-10-04', 1600, NULL, 0, 0, 'vanbeek', '1176316', '', 'Diverse lijsten', -24.00);
INSERT INTO boekregels VALUES (2970, 559, 2014, '2014-10-04', 2200, NULL, 0, 0, 'vanbeek', '1176316', '', 'Diverse lijsten', 4.17);
INSERT INTO boekregels VALUES (2971, 560, 2014, '2014-10-06', 1600, NULL, 0, 0, 'vandien', '20307233', '', 'Nissan 11-11/11-02', -119.78);
INSERT INTO boekregels VALUES (2972, 560, 2014, '2014-10-06', 4420, NULL, 0, 0, 'vandien', '20307233', '', 'Nissan 11-11/11-02', 119.78);
INSERT INTO boekregels VALUES (2973, 561, 2014, '2014-10-09', 1600, NULL, 0, 0, 'xs4all', '45446171', '', 'Internet okt', -47.99);
INSERT INTO boekregels VALUES (2982, 563, 2014, '2014-10-15', 2200, NULL, 0, 0, 'vanbeek', '1182558', '', 'Doek', 7.69);
INSERT INTO boekregels VALUES (2974, 561, 2014, '2014-10-09', 4245, NULL, 2975, 0, 'xs4all', '45446171', '', 'Internet okt zakelijk deel', 29.75);
INSERT INTO boekregels VALUES (2975, 561, 2014, '2014-10-09', 2200, NULL, 0, 0, 'xs4all', '45446171', '', 'Internet okt zakelijk deel', 6.25);
INSERT INTO boekregels VALUES (2976, 561, 2014, '2014-10-09', 1060, NULL, 0, 0, 'xs4all', '45446171', '', 'Internet okt prive deel', 11.99);
INSERT INTO boekregels VALUES (2977, 562, 2014, '2014-10-15', 1600, NULL, 0, 0, 'claasen', '834584', '', 'Div latex', -37.68);
INSERT INTO boekregels VALUES (2979, 562, 2014, '2014-10-15', 2200, NULL, 0, 0, 'claasen', '834584', '', 'Div latex', 6.54);
INSERT INTO boekregels VALUES (2978, 562, 2014, '2014-10-15', 5010, NULL, 2979, 0, 'claasen', '834584', '', 'Div latex', 31.14);
INSERT INTO boekregels VALUES (2980, 563, 2014, '2014-10-15', 1600, NULL, 0, 0, 'vanbeek', '1182558', '', 'Doek', -44.32);
INSERT INTO boekregels VALUES (2981, 563, 2014, '2014-10-15', 5010, NULL, 2982, 0, 'vanbeek', '1182558', '', 'Doek', 36.63);
INSERT INTO boekregels VALUES (2983, 564, 2014, '2014-10-15', 1600, NULL, 0, 0, 'Transip', '2014.0033.8711', '', 'Domeinnaam graffitinaam.nl', -9.06);
INSERT INTO boekregels VALUES (2985, 564, 2014, '2014-10-15', 2200, NULL, 0, 0, 'Transip', '2014.0033.8711', '', 'Domeinnaam graffitinaam.nl', 1.57);
INSERT INTO boekregels VALUES (2986, 565, 2014, '2014-10-20', 1600, NULL, 0, 0, 'tmobile', '901228639766', '', 'Telefoon 16/10-15/11', -28.99);
INSERT INTO boekregels VALUES (2988, 565, 2014, '2014-10-20', 2200, NULL, 0, 0, 'tmobile', '901228639766', '', 'Telefoon 16/10-15/11', 5.03);
INSERT INTO boekregels VALUES (2987, 565, 2014, '2014-10-20', 4240, NULL, 2988, 0, 'tmobile', '901228639766', '', 'Telefoon 16/10-15/11', 23.96);
INSERT INTO boekregels VALUES (2989, 566, 2014, '2014-10-29', 1600, NULL, 0, 0, 'vanbeek', '1188996', '', 'Diverse Katoen', -59.96);
INSERT INTO boekregels VALUES (2991, 566, 2014, '2014-10-29', 2200, NULL, 0, 0, 'vanbeek', '1188996', '', 'Diverse Katoen', 10.41);
INSERT INTO boekregels VALUES (2990, 566, 2014, '2014-10-29', 5010, NULL, 2991, 0, 'vanbeek', '1188996', '', 'Diverse Katoen', 49.55);
INSERT INTO boekregels VALUES (2992, 567, 2014, '2014-11-09', 1600, NULL, 0, 0, 'xs4all', '45689593', '', 'Internet nov', -45.00);
INSERT INTO boekregels VALUES (2994, 567, 2014, '2014-11-09', 2200, NULL, 0, 0, 'xs4all', '45689593', '', 'Internet nov zakelijk deel 75%', 5.86);
INSERT INTO boekregels VALUES (2993, 567, 2014, '2014-11-09', 4245, NULL, 2994, 0, 'xs4all', '45689593', '', 'Internet nov zakelijk deel 75%', 27.89);
INSERT INTO boekregels VALUES (2995, 567, 2014, '2014-11-09', 1060, NULL, 0, 0, 'xs4all', '45689593', '', 'Internet nov prive deel 25%', 11.25);
INSERT INTO boekregels VALUES (2996, 568, 2014, '2014-11-17', 1600, NULL, 0, 0, 'belasting', '69414993M48', '', 'Nissan 17-11/16-02', -79.00);
INSERT INTO boekregels VALUES (2997, 568, 2014, '2014-11-17', 4430, NULL, 0, 0, 'belasting', '69414993M48', '', 'Nissan 17-11/16-02', 79.00);
INSERT INTO boekregels VALUES (2998, 569, 2014, '2014-11-20', 1600, NULL, 0, 0, 'marktplaats', '141106171', '', 'Advertentieplaatsing', -5.45);
INSERT INTO boekregels VALUES (3000, 569, 2014, '2014-11-20', 2200, NULL, 0, 0, 'marktplaats', '141106171', '', 'Advertentieplaatsing', 0.95);
INSERT INTO boekregels VALUES (2999, 569, 2014, '2014-11-20', 4310, NULL, 3000, 0, 'marktplaats', '141106171', '', 'Advertentieplaatsing', 4.50);
INSERT INTO boekregels VALUES (3001, 570, 2014, '2014-11-24', 1600, NULL, 0, 0, 'tmobile', '901230784760', '', 'Telefoon 16/11-15/12', -28.99);
INSERT INTO boekregels VALUES (3003, 570, 2014, '2014-11-24', 2200, NULL, 0, 0, 'tmobile', '901230784760', '', 'Telefoon 16/11-15/12', 5.03);
INSERT INTO boekregels VALUES (3002, 570, 2014, '2014-11-24', 4240, NULL, 3003, 0, 'tmobile', '901230784760', '', 'Telefoon 16/11-15/12', 23.96);
INSERT INTO boekregels VALUES (3004, 571, 2014, '2014-11-24', 1600, NULL, 0, 0, 'vanbeek', '1202600', '', 'Katoen', -13.52);
INSERT INTO boekregels VALUES (3006, 571, 2014, '2014-11-24', 2200, NULL, 0, 0, 'vanbeek', '1202600', '', 'Katoen', 2.35);
INSERT INTO boekregels VALUES (3005, 571, 2014, '2014-11-24', 5010, NULL, 3006, 0, 'vanbeek', '1202600', '', 'Katoen', 11.17);
INSERT INTO boekregels VALUES (3007, 572, 2014, '2014-11-24', 1600, NULL, 0, 0, 'vanbeek', '1202598', '', 'Spuitmaterialen', -22.25);
INSERT INTO boekregels VALUES (3009, 572, 2014, '2014-11-24', 2200, NULL, 0, 0, 'vanbeek', '1202598', '', 'Spuitmaterialen', 3.86);
INSERT INTO boekregels VALUES (3008, 572, 2014, '2014-11-24', 5010, NULL, 3009, 0, 'vanbeek', '1202598', '', 'Spuitmaterialen', 18.39);
INSERT INTO boekregels VALUES (3010, 573, 2014, '2014-12-01', 1600, NULL, 0, 0, 'Transip', '201400402714', '', 'Domeinnamen', -90.63);
INSERT INTO boekregels VALUES (3012, 573, 2014, '2014-12-01', 2200, NULL, 0, 0, 'Transip', '201400402714', '', 'Domeinnamen', 15.73);
INSERT INTO boekregels VALUES (3011, 573, 2014, '2014-12-01', 4245, NULL, 3012, 0, 'Transip', '201400402714', '', 'Domeinnamen', 74.90);
INSERT INTO boekregels VALUES (2984, 564, 2014, '2014-10-15', 4245, NULL, 2985, 0, 'Transip', '2014.0033.8711', '', 'Domeinnaam graffitinaam.nl', 7.49);
INSERT INTO boekregels VALUES (3013, 574, 2014, '2014-12-09', 1600, NULL, 0, 0, 'xs4all', '45932076', '', 'Internet dec', -49.99);
INSERT INTO boekregels VALUES (3015, 574, 2014, '2014-12-09', 2200, NULL, 0, 0, 'xs4all', '45932076', '', 'Internet dec zakelijk deel 75%', 6.51);
INSERT INTO boekregels VALUES (3014, 574, 2014, '2014-12-09', 4245, NULL, 3015, 0, 'xs4all', '45932076', '', 'Internet dec zakelijk deel 75%', 30.99);
INSERT INTO boekregels VALUES (3016, 574, 2014, '2014-12-09', 1060, NULL, 0, 0, 'xs4all', '45932076', '', 'Internet dec prive deel 25%', 12.49);
INSERT INTO boekregels VALUES (3020, 576, 2014, '2014-12-11', 1600, NULL, 0, 0, 'marktplaats', '141205836', '', 'Advertentieplaatsing', -5.45);
INSERT INTO boekregels VALUES (3022, 576, 2014, '2014-12-11', 2200, NULL, 0, 0, 'marktplaats', '141205836', '', 'Advertentieplaatsing', 0.95);
INSERT INTO boekregels VALUES (3021, 576, 2014, '2014-12-11', 4310, NULL, 3022, 0, 'marktplaats', '141205836', '', 'Advertentieplaatsing', 4.50);
INSERT INTO boekregels VALUES (3055, 587, 2014, '2014-11-08', 2110, NULL, 0, 0, 'crossfit', '201414', '', 'Muurschildering', -105.00);
INSERT INTO boekregels VALUES (3026, 578, 2014, '2014-12-18', 1600, NULL, 0, 0, 'tmobile', '901232952490', '', 'Telefoon 16/12-15/01', -29.05);
INSERT INTO boekregels VALUES (3028, 578, 2014, '2014-12-18', 2200, NULL, 0, 0, 'tmobile', '901232952490', '', 'Telefoon 16/12-15/01', 5.04);
INSERT INTO boekregels VALUES (3027, 578, 2014, '2014-12-18', 4240, NULL, 3028, 0, 'tmobile', '901232952490', '', 'Telefoon 16/12-15/01', 24.01);
INSERT INTO boekregels VALUES (3029, 579, 2014, '2014-12-24', 1600, NULL, 0, 0, 'publikat', '1521948', '', 'Spuitmaterialen', -227.15);
INSERT INTO boekregels VALUES (3031, 579, 2014, '2014-12-24', 2200, NULL, 0, 0, 'publikat', '1521948', '', 'Spuitmaterialen', 39.42);
INSERT INTO boekregels VALUES (3030, 579, 2014, '2014-12-24', 5010, NULL, 3031, 0, 'publikat', '1521948', '', 'Spuitmaterialen', 187.73);
INSERT INTO boekregels VALUES (3032, 580, 2014, '2014-12-24', 1600, NULL, 0, 0, 'publikat', '1521969', '', 'Spuitmaterialen', -219.26);
INSERT INTO boekregels VALUES (3034, 580, 2014, '2014-12-24', 2200, NULL, 0, 0, 'publikat', '1521969', '', 'Spuitmaterialen', 38.05);
INSERT INTO boekregels VALUES (3033, 580, 2014, '2014-12-24', 5010, NULL, 3034, 0, 'publikat', '1521969', '', 'Spuitmaterialen', 181.21);
INSERT INTO boekregels VALUES (3035, 581, 2014, '2014-12-24', 1600, NULL, 0, 0, 'publikat', '1521981', '', 'Spuitmaterialen', -61.60);
INSERT INTO boekregels VALUES (3037, 581, 2014, '2014-12-24', 2200, NULL, 0, 0, 'publikat', '1521981', '', 'Spuitmaterialen', 10.69);
INSERT INTO boekregels VALUES (3036, 581, 2014, '2014-12-24', 5010, NULL, 3037, 0, 'publikat', '1521981', '', 'Spuitmaterialen', 50.91);
INSERT INTO boekregels VALUES (3038, 582, 2014, '2014-12-30', 1600, NULL, 0, 0, 'kramer', '97167', '', 'Spuitmaterialen', -317.85);
INSERT INTO boekregels VALUES (3040, 582, 2014, '2014-12-30', 2200, NULL, 0, 0, 'kramer', '97167', '', 'Spuitmaterialen', 55.16);
INSERT INTO boekregels VALUES (3039, 582, 2014, '2014-12-30', 5010, NULL, 3040, 0, 'kramer', '97167', '', 'Spuitmaterialen', 262.69);
INSERT INTO boekregels VALUES (3043, 583, 2014, '2014-12-10', 2200, NULL, 0, 0, 'kramer', '96917', '', 'Spuitmaterialen', 32.63);
INSERT INTO boekregels VALUES (3041, 583, 2014, '2014-12-10', 1600, NULL, 0, 0, 'kramer', '96917', '', 'Spuitmaterialen', -188.00);
INSERT INTO boekregels VALUES (3042, 583, 2014, '2014-12-10', 5010, NULL, 3043, 0, 'kramer', '96917', '', 'Spuitmaterialen', 155.37);
INSERT INTO boekregels VALUES (3054, 587, 2014, '2014-11-08', 8070, NULL, 3055, 0, 'crossfit', '201414', '', 'Muurschildering', -500.00);
INSERT INTO boekregels VALUES (3044, 584, 2014, '2014-12-16', 1600, NULL, 0, 0, 'kramer', '97019', '', 'Spuitmaterialen', -167.10);
INSERT INTO boekregels VALUES (3046, 584, 2014, '2014-12-16', 2200, NULL, 0, 0, 'kramer', '97019', '', 'Spuitmaterialen', 29.00);
INSERT INTO boekregels VALUES (3045, 584, 2014, '2014-12-16', 5010, NULL, 3046, 0, 'kramer', '97019', '', 'Spuitmaterialen', 138.10);
INSERT INTO boekregels VALUES (3047, 585, 2014, '2014-10-08', 1200, NULL, 0, 0, 'luc4me', '201412', '', 'Beschildering betonnen onderzetters', 30.25);
INSERT INTO boekregels VALUES (3049, 585, 2014, '2014-10-08', 2110, NULL, 0, 0, 'luc4me', '201412', '', 'Beschildering betonnen onderzetters', -5.25);
INSERT INTO boekregels VALUES (3048, 585, 2014, '2014-10-08', 8070, NULL, 3049, 0, 'luc4me', '201412', '', 'Beschildering betonnen onderzetters', -25.00);
INSERT INTO boekregels VALUES (3050, 586, 2014, '2014-10-20', 1200, NULL, 0, 0, 'luc4me', '201413', '', 'Schilderen bestaand beeldmerk', 332.75);
INSERT INTO boekregels VALUES (3052, 586, 2014, '2014-10-20', 2110, NULL, 0, 0, 'luc4me', '201413', '', 'Schilderen bestaand beeldmerk', -57.75);
INSERT INTO boekregels VALUES (3051, 586, 2014, '2014-10-20', 8070, NULL, 3052, 0, 'luc4me', '201413', '', 'Schilderen bestaand beeldmerk', -275.00);
INSERT INTO boekregels VALUES (3053, 587, 2014, '2014-11-08', 1200, NULL, 0, 0, 'crossfit', '201414', '', 'Muurschildering', 605.00);
INSERT INTO boekregels VALUES (3056, 588, 2014, '2014-11-18', 1200, NULL, 0, 0, 'mulder', '2014015', '', 'Muurschildering portret', 302.50);
INSERT INTO boekregels VALUES (3058, 588, 2014, '2014-11-18', 2110, NULL, 0, 0, 'mulder', '2014015', '', 'Muurschildering portret', -52.50);
INSERT INTO boekregels VALUES (3057, 588, 2014, '2014-11-18', 8070, NULL, 3058, 0, 'mulder', '2014015', '', 'Muurschildering portret', -250.00);
INSERT INTO boekregels VALUES (3060, 592, 2014, '2014-10-20', 2110, NULL, 0, 0, '', '', '', 'Schilderij Scarface', -24.30);
INSERT INTO boekregels VALUES (3059, 592, 2014, '2014-10-20', 8065, NULL, 3060, 0, '', '', '', 'Schilderij Scarface', -115.70);
INSERT INTO boekregels VALUES (3062, 592, 2014, '2014-10-28', 2110, NULL, 0, 0, '', '', '', 'Schilderij piratenboot', -23.43);
INSERT INTO boekregels VALUES (3061, 592, 2014, '2014-10-28', 8065, NULL, 3062, 0, '', '', '', 'Schilderij piratenboot', -111.57);
INSERT INTO boekregels VALUES (3064, 592, 2014, '2014-11-20', 2110, NULL, 0, 0, '', '', '', 'Graffiti Leiden', -23.43);
INSERT INTO boekregels VALUES (3063, 592, 2014, '2014-11-20', 8060, NULL, 3064, 0, '', '', '', 'Graffiti Leiden', -111.57);
INSERT INTO boekregels VALUES (3066, 592, 2014, '2014-12-07', 2110, NULL, 0, 0, '', '', '', 'Graffiti Spiderman', -21.69);
INSERT INTO boekregels VALUES (3065, 592, 2014, '2014-12-07', 8060, NULL, 3066, 0, '', '', '', 'Graffiti Spiderman', -103.31);
INSERT INTO boekregels VALUES (3068, 592, 2014, '2014-12-10', 2110, NULL, 0, 0, '', '', '', 'Graffiti Lyn', -27.77);
INSERT INTO boekregels VALUES (3067, 592, 2014, '2014-12-10', 8060, NULL, 3068, 0, '', '', '', 'Graffiti Lyn', -132.23);
INSERT INTO boekregels VALUES (3070, 592, 2014, '2014-12-10', 2110, NULL, 0, 0, '', '', '', 'Graffiti Tara', -23.43);
INSERT INTO boekregels VALUES (3069, 592, 2014, '2014-12-10', 8060, NULL, 3070, 0, '', '', '', 'Graffiti Tara', -111.57);
INSERT INTO boekregels VALUES (3071, 592, 2014, '2014-12-10', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 4e kwartaal', 830.00);
INSERT INTO boekregels VALUES (3073, 589, 2014, '2014-09-29', 2200, NULL, 0, 0, '', '', '', 'Led strip', 4.16);
INSERT INTO boekregels VALUES (3072, 589, 2014, '2014-09-29', 4220, NULL, 3073, 0, '', '', '', 'Led strip', 19.83);
INSERT INTO boekregels VALUES (3074, 589, 2014, '2014-09-19', 4270, NULL, 0, 0, '', '', '', 'Parkeren DH', 4.00);
INSERT INTO boekregels VALUES (3076, 589, 2014, '2014-09-28', 2200, NULL, 0, 0, '', '', '', 'Lunch bespreking', 2.23);
INSERT INTO boekregels VALUES (3075, 589, 2014, '2014-09-28', 4290, NULL, 3076, 0, '', '', '', 'Lunch bespreking', 14.82);
INSERT INTO boekregels VALUES (3078, 589, 2014, '2014-09-22', 2200, NULL, 0, 0, '', '', '', 'Led lampen', 4.50);
INSERT INTO boekregels VALUES (3077, 589, 2014, '2014-09-22', 4220, NULL, 3078, 0, '', '', '', 'Led lampen', 21.45);
INSERT INTO boekregels VALUES (3080, 589, 2014, '2014-09-22', 2200, NULL, 0, 0, '', '', '', 'Transportmateriaal', 7.80);
INSERT INTO boekregels VALUES (3079, 589, 2014, '2014-09-22', 4220, NULL, 3080, 0, '', '', '', 'Transportmateriaal', 37.14);
INSERT INTO boekregels VALUES (3082, 589, 2014, '2014-09-24', 2200, NULL, 0, 0, '', '', '', 'Micro SD cards', 4.51);
INSERT INTO boekregels VALUES (3081, 589, 2014, '2014-09-24', 4230, NULL, 3082, 0, '', '', '', 'Micro SD cards', 21.47);
INSERT INTO boekregels VALUES (3084, 589, 2014, '2014-10-04', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.70);
INSERT INTO boekregels VALUES (3083, 589, 2014, '2014-10-04', 4410, NULL, 3084, 0, '', '', '', 'Brandstof Nissan', 36.68);
INSERT INTO boekregels VALUES (3086, 589, 2014, '2014-10-07', 2200, NULL, 0, 0, '', '', '', 'Kleurendrukken', 1.32);
INSERT INTO boekregels VALUES (3085, 589, 2014, '2014-10-07', 4310, NULL, 3086, 0, '', '', '', 'Kleurendrukken', 6.28);
INSERT INTO boekregels VALUES (3087, 589, 2014, '2014-10-07', 4250, NULL, 0, 0, '', '', '', 'Aangetekende brief', 7.95);
INSERT INTO boekregels VALUES (3089, 589, 2014, '2014-10-08', 2200, NULL, 0, 0, '', '', '', 'Plaatmateriaal', 1.63);
INSERT INTO boekregels VALUES (3088, 589, 2014, '2014-10-08', 5010, NULL, 3089, 0, '', '', '', 'Plaatmateriaal', 7.76);
INSERT INTO boekregels VALUES (3091, 589, 2014, '2014-10-10', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.43);
INSERT INTO boekregels VALUES (3090, 589, 2014, '2014-10-10', 4410, NULL, 3091, 0, '', '', '', 'Brandstof Nissan', 44.90);
INSERT INTO boekregels VALUES (3093, 589, 2014, '2014-10-15', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 8.59);
INSERT INTO boekregels VALUES (3092, 589, 2014, '2014-10-15', 4410, NULL, 3093, 0, '', '', '', 'Brandstof Nissan', 40.90);
INSERT INTO boekregels VALUES (3095, 589, 2014, '2014-10-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 2.11);
INSERT INTO boekregels VALUES (3094, 589, 2014, '2014-10-18', 4410, NULL, 3095, 0, '', '', '', 'Brandstof Nissan', 10.07);
INSERT INTO boekregels VALUES (3096, 589, 2014, '2014-10-22', 4220, NULL, 3097, 0, '', '', '', 'Folie', 11.58);
INSERT INTO boekregels VALUES (3097, 589, 2014, '2014-10-22', 2200, NULL, 0, 0, '', '', '', 'Folie', 2.15);
INSERT INTO boekregels VALUES (3099, 589, 2014, '2014-10-22', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.25);
INSERT INTO boekregels VALUES (3098, 589, 2014, '2014-10-22', 4410, NULL, 3099, 0, '', '', '', 'Brandstof Nissan', 25.00);
INSERT INTO boekregels VALUES (3101, 589, 2014, '2014-10-23', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.56);
INSERT INTO boekregels VALUES (3100, 589, 2014, '2014-10-23', 4410, NULL, 3101, 0, '', '', '', 'Brandstof Nissan', 45.53);
INSERT INTO boekregels VALUES (3103, 589, 2014, '2014-10-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.27);
INSERT INTO boekregels VALUES (3102, 589, 2014, '2014-10-28', 4410, NULL, 3103, 0, '', '', '', 'Brandstof Nissan', 44.15);
INSERT INTO boekregels VALUES (3105, 589, 2014, '2014-10-28', 2200, NULL, 0, 0, '', '', '', 'Verf en roller', 0.71);
INSERT INTO boekregels VALUES (3104, 589, 2014, '2014-10-28', 4220, NULL, 3105, 0, '', '', '', 'Verf en roller', 3.37);
INSERT INTO boekregels VALUES (3107, 589, 2014, '2014-10-28', 2200, NULL, 0, 0, '', '', '', 'Verf en roller', 2.48);
INSERT INTO boekregels VALUES (3106, 589, 2014, '2014-10-28', 4220, NULL, 3107, 0, '', '', '', 'Verf en roller', 11.83);
INSERT INTO boekregels VALUES (3108, 589, 2014, '2014-10-28', 1060, NULL, 0, 0, '', '', '', 'Kasblad 10 2014', -498.11);
INSERT INTO boekregels VALUES (3110, 590, 2014, '2014-11-05', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.74);
INSERT INTO boekregels VALUES (3109, 590, 2014, '2014-11-05', 4410, NULL, 3110, 0, '', '', '', 'Brandstof Nissan', 46.39);
INSERT INTO boekregels VALUES (3112, 590, 2014, '2014-11-06', 2200, NULL, 0, 0, '', '', '', 'Aansluitmateriaal pomp', 3.90);
INSERT INTO boekregels VALUES (3111, 590, 2014, '2014-11-06', 4220, NULL, 3112, 0, '', '', '', 'Aansluitmateriaal pomp', 18.55);
INSERT INTO boekregels VALUES (3114, 590, 2014, '2014-11-10', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.37);
INSERT INTO boekregels VALUES (3113, 590, 2014, '2014-11-10', 4230, NULL, 3114, 0, '', '', '', 'Vaktijdschrift', 6.08);
INSERT INTO boekregels VALUES (3116, 590, 2014, '2014-11-12', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.45);
INSERT INTO boekregels VALUES (3115, 590, 2014, '2014-11-12', 4410, NULL, 3116, 0, '', '', '', 'Brandstof Nissan', 45.00);
INSERT INTO boekregels VALUES (3118, 590, 2014, '2014-11-20', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.38);
INSERT INTO boekregels VALUES (3117, 590, 2014, '2014-11-20', 4410, NULL, 3118, 0, '', '', '', 'Brandstof Nissan', 49.41);
INSERT INTO boekregels VALUES (3120, 590, 2014, '2014-11-20', 2200, NULL, 0, 0, '', '', '', 'Stekkerdoos', 1.56);
INSERT INTO boekregels VALUES (3119, 590, 2014, '2014-11-20', 4230, NULL, 3120, 0, '', '', '', 'Stekkerdoos', 7.43);
INSERT INTO boekregels VALUES (3122, 590, 2014, '2014-11-21', 2200, NULL, 0, 0, '', '', '', 'Doek Xenos', 5.55);
INSERT INTO boekregels VALUES (3121, 590, 2014, '2014-11-21', 5010, NULL, 3122, 0, '', '', '', 'Doek Xenos', 26.43);
INSERT INTO boekregels VALUES (3124, 590, 2014, '2014-11-26', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 9.59);
INSERT INTO boekregels VALUES (3123, 590, 2014, '2014-11-26', 4410, NULL, 3124, 0, '', '', '', 'Brandstof Nissan', 45.66);
INSERT INTO boekregels VALUES (3126, 590, 2014, '2014-11-29', 2200, NULL, 0, 0, '', '', '', 'Kachel', 5.02);
INSERT INTO boekregels VALUES (3125, 590, 2014, '2014-11-29', 4220, NULL, 3126, 0, '', '', '', 'Kachel', 23.93);
INSERT INTO boekregels VALUES (3128, 590, 2014, '2014-11-29', 2210, NULL, 0, 0, '', '', '', 'Olie', 3.46);
INSERT INTO boekregels VALUES (3127, 590, 2014, '2014-11-29', 4450, NULL, 3128, 0, '', '', '', 'Olie', 16.49);
INSERT INTO boekregels VALUES (3130, 590, 2014, '2014-11-30', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 4.83);
INSERT INTO boekregels VALUES (3129, 590, 2014, '2014-11-30', 4410, NULL, 3130, 0, '', '', '', 'Brandstof Nissan', 23.01);
INSERT INTO boekregels VALUES (3131, 590, 2014, '2014-11-30', 1060, NULL, 0, 0, '', '', '', 'Kasblad 11 2014', -372.23);
INSERT INTO boekregels VALUES (3133, 591, 2014, '2014-12-03', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.31);
INSERT INTO boekregels VALUES (3132, 591, 2014, '2014-12-03', 4410, NULL, 3133, 0, '', '', '', 'Brandstof Nissan', 49.10);
INSERT INTO boekregels VALUES (3135, 591, 2014, '2014-12-03', 2200, NULL, 0, 0, '', '', '', 'Voedsel onderweg', 0.49);
INSERT INTO boekregels VALUES (3134, 591, 2014, '2014-12-03', 4270, NULL, 3135, 0, '', '', '', 'Voedsel onderweg', 8.16);
INSERT INTO boekregels VALUES (3137, 591, 2014, '2014-12-03', 2200, NULL, 0, 0, '', '', '', 'Lampjes reserve', 1.14);
INSERT INTO boekregels VALUES (3136, 591, 2014, '2014-12-03', 4230, NULL, 3137, 0, '', '', '', 'Lampjes reserve', 5.44);
INSERT INTO boekregels VALUES (3139, 591, 2014, '2014-12-05', 2200, NULL, 0, 0, '', '', '', 'Spuitmaterialen', 0.36);
INSERT INTO boekregels VALUES (3138, 591, 2014, '2014-12-05', 5010, NULL, 3139, 0, '', '', '', 'Spuitmaterialen', 1.73);
INSERT INTO boekregels VALUES (3141, 591, 2014, '2014-12-06', 2200, NULL, 0, 0, '', '', '', 'Kleurendrukken', 0.56);
INSERT INTO boekregels VALUES (3140, 591, 2014, '2014-12-06', 4220, NULL, 3141, 0, '', '', '', 'Kleurendrukken', 2.64);
INSERT INTO boekregels VALUES (3143, 591, 2014, '2014-12-06', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 8.37);
INSERT INTO boekregels VALUES (3142, 591, 2014, '2014-12-06', 4410, NULL, 3143, 0, '', '', '', 'Brandstof Nissan', 39.86);
INSERT INTO boekregels VALUES (3145, 591, 2014, '2014-12-09', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 10.16);
INSERT INTO boekregels VALUES (3144, 591, 2014, '2014-12-09', 4410, NULL, 3145, 0, '', '', '', 'Brandstof Nissan', 48.39);
INSERT INTO boekregels VALUES (3147, 591, 2014, '2014-12-11', 2200, NULL, 0, 0, '', '', '', 'Tekenset', 1.21);
INSERT INTO boekregels VALUES (3146, 591, 2014, '2014-12-11', 4220, NULL, 3147, 0, '', '', '', 'Tekenset', 5.78);
INSERT INTO boekregels VALUES (3148, 591, 2014, '2014-12-12', 4270, NULL, 0, 0, '', '', '', 'Parkeerkosten RDAM', 59.67);
INSERT INTO boekregels VALUES (3150, 591, 2014, '2014-12-13', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 3.98);
INSERT INTO boekregels VALUES (3149, 591, 2014, '2014-12-13', 4410, NULL, 3150, 0, '', '', '', 'Brandstof Nissan', 18.98);
INSERT INTO boekregels VALUES (3151, 591, 2014, '2014-12-13', 4270, NULL, 0, 0, '', '', '', 'Tol Frankrijk', 18.10);
INSERT INTO boekregels VALUES (3152, 591, 2014, '2014-12-14', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 44.79);
INSERT INTO boekregels VALUES (3154, 591, 2014, '2014-12-14', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 5.57);
INSERT INTO boekregels VALUES (3153, 591, 2014, '2014-12-14', 4410, NULL, 3154, 0, '', '', '', 'Brandstof Nissan', 26.50);
INSERT INTO boekregels VALUES (3156, 591, 2014, '2014-12-16', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 4.45);
INSERT INTO boekregels VALUES (3155, 591, 2014, '2014-12-16', 4410, NULL, 3156, 0, '', '', '', 'Brandstof Nissan', 21.17);
INSERT INTO boekregels VALUES (3158, 591, 2014, '2014-12-18', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.09);
INSERT INTO boekregels VALUES (3157, 591, 2014, '2014-12-18', 4410, NULL, 3158, 0, '', '', '', 'Brandstof Nissan', 28.99);
INSERT INTO boekregels VALUES (3160, 591, 2014, '2014-12-25', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 7.15);
INSERT INTO boekregels VALUES (3159, 591, 2014, '2014-12-25', 4410, NULL, 3160, 0, '', '', '', 'Brandstof Nissan', 34.07);
INSERT INTO boekregels VALUES (3162, 591, 2014, '2014-12-26', 2200, NULL, 0, 0, '', '', '', 'Afplakbank', 2.43);
INSERT INTO boekregels VALUES (3161, 591, 2014, '2014-12-26', 4220, NULL, 3162, 0, '', '', '', 'Afplakbank', 11.58);
INSERT INTO boekregels VALUES (3164, 591, 2014, '2014-12-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 3.47);
INSERT INTO boekregels VALUES (3163, 591, 2014, '2014-12-28', 4410, NULL, 3164, 0, '', '', '', 'Brandstof Nissan', 16.54);
INSERT INTO boekregels VALUES (3166, 591, 2014, '2014-12-28', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 6.23);
INSERT INTO boekregels VALUES (3165, 591, 2014, '2014-12-28', 4410, NULL, 3166, 0, '', '', '', 'Brandstof Nissan', 29.68);
INSERT INTO boekregels VALUES (3168, 591, 2014, '2014-12-30', 2200, NULL, 0, 0, '', '', '', 'Vaktijdschrift', 0.98);
INSERT INTO boekregels VALUES (3167, 591, 2014, '2014-12-30', 4230, NULL, 3168, 0, '', '', '', 'Vaktijdschrift', 4.65);
INSERT INTO boekregels VALUES (3169, 591, 2014, '2014-12-31', 1060, NULL, 0, 0, '', '', '', 'Kasblad 12 2014', -548.77);
INSERT INTO boekregels VALUES (3173, 594, 2014, '2014-11-17', 2110, NULL, 0, 0, '', '', '', 'Graffiti Sylvie, Jaimie, Madelon DH', -43.39);
INSERT INTO boekregels VALUES (3172, 594, 2014, '2014-11-17', 8060, NULL, 3173, 0, '', '', '', 'Graffiti Sylvie, Jaimie, Madelon DH', -206.61);
INSERT INTO boekregels VALUES (3175, 594, 2014, '2014-12-06', 2110, NULL, 0, 0, '', '', '', 'Graffiti fietster Groningen', -43.39);
INSERT INTO boekregels VALUES (3174, 594, 2014, '2014-12-06', 8060, NULL, 3175, 0, '', '', '', 'Graffiti fietster Groningen', -206.61);
INSERT INTO boekregels VALUES (3177, 594, 2014, '2014-12-28', 2110, NULL, 0, 0, '', '', '', 'Portret op muur Pijnacker', -26.03);
INSERT INTO boekregels VALUES (3176, 594, 2014, '2014-12-28', 8060, NULL, 3177, 0, '', '', '', 'Portret op muur Pijnacker', -123.97);
INSERT INTO boekregels VALUES (3178, 594, 2014, '2014-12-28', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 4e kwartaal nagekomen bonnnen', 650.00);
INSERT INTO boekregels VALUES (3170, 593, 2014, '2014-12-31', 4510, NULL, 0, 0, '', '', '', 'BTW Correctie privegebruik Nissan', 511.00);
INSERT INTO boekregels VALUES (3171, 593, 2014, '2014-12-31', 2150, NULL, 0, 0, '', '', '', 'BTW Correctie privegebruik Nissan', -511.00);
INSERT INTO boekregels VALUES (3179, 595, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 523.00);
INSERT INTO boekregels VALUES (3180, 595, 2014, '2014-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -523.00);
INSERT INTO boekregels VALUES (3181, 596, 2014, '2014-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 477.36);
INSERT INTO boekregels VALUES (3182, 596, 2014, '2014-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -347.95);
INSERT INTO boekregels VALUES (3183, 596, 2014, '2014-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -165.14);
INSERT INTO boekregels VALUES (3184, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -477.36);
INSERT INTO boekregels VALUES (3185, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.36);
INSERT INTO boekregels VALUES (3186, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 165.14);
INSERT INTO boekregels VALUES (3187, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 347.95);
INSERT INTO boekregels VALUES (3188, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.09);
INSERT INTO boekregels VALUES (3189, 596, 2014, '2014-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.36);
INSERT INTO boekregels VALUES (3190, 596, 2014, '2014-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.09);
INSERT INTO boekregels VALUES (3191, 596, 2014, '2014-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 511.00);
INSERT INTO boekregels VALUES (3192, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -511.00);
INSERT INTO boekregels VALUES (3193, 596, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.00);
INSERT INTO boekregels VALUES (3194, 596, 2014, '2014-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', 0.00);
INSERT INTO boekregels VALUES (3195, 508, 2014, '2014-03-31', 1060, NULL, 0, 0, '', '', '', 'Contante verkopen 1e kwartaal', 1165.00);
INSERT INTO boekregels VALUES (3196, 597, 2014, '2014-01-01', 210, NULL, 0, 0, '', '', 'begin', 'Beginbalans', 7495.00);
INSERT INTO boekregels VALUES (3197, 597, 2014, '2014-01-01', 260, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -840.10);
INSERT INTO boekregels VALUES (3198, 597, 2014, '2014-01-01', 900, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -6133.90);
INSERT INTO boekregels VALUES (3199, 597, 2014, '2014-01-01', 2300, NULL, 0, 0, '', '', 'begin', 'Beginbalans', -521.00);
INSERT INTO boekregels VALUES (3202, 599, 2014, '2014-12-31', 4630, NULL, 0, 0, '', '', '', 'Afschrijving Nissan NV200', 1499.00);
INSERT INTO boekregels VALUES (3203, 599, 2014, '2014-12-31', 260, NULL, 0, 0, '', '', '', 'Afschrijving Nissan NV200', -1499.00);
INSERT INTO boekregels VALUES (3204, 600, 2014, '2014-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive ontvangen Debiteurensaldo', 5275.90);
INSERT INTO boekregels VALUES (3205, 600, 2014, '2014-12-31', 1200, NULL, 0, 0, '', '', '', 'Prive ontvangen Debiteurensaldo', -5275.90);
INSERT INTO boekregels VALUES (3206, 601, 2014, '2014-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive betaald Crediteurensaldo', -8398.73);
INSERT INTO boekregels VALUES (3207, 601, 2014, '2014-12-31', 1600, NULL, 0, 0, '', '', '', 'Prive betaald Crediteurensaldo', 8398.73);


--
-- Data for Name: boekregelsTrash; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO "boekregelsTrash" VALUES (316, 84, 2011, '2011-06-27', 2200, NULL, 0, 0, 'staples', 'VS63059691', '', 'Olympus VR310 camera', 15.81);
INSERT INTO "boekregelsTrash" VALUES (232, 59, 2011, '2011-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 2046.50);
INSERT INTO "boekregelsTrash" VALUES (233, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -2046.50);
INSERT INTO "boekregelsTrash" VALUES (234, 59, 2011, '2011-03-31', 2120, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 7.36);
INSERT INTO "boekregelsTrash" VALUES (235, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2120', -7.36);
INSERT INTO "boekregelsTrash" VALUES (236, 59, 2011, '2011-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -2401.11);
INSERT INTO "boekregelsTrash" VALUES (237, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 2401.11);
INSERT INTO "boekregelsTrash" VALUES (238, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 naar 8900', -0.50);
INSERT INTO "boekregelsTrash" VALUES (239, 59, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 van 2300', 0.50);
INSERT INTO "boekregelsTrash" VALUES (240, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 naar 8900', 0.36);
INSERT INTO "boekregelsTrash" VALUES (241, 59, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 van 2300', -0.36);
INSERT INTO "boekregelsTrash" VALUES (242, 59, 2011, '2011-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 naar 8900', -0.11);
INSERT INTO "boekregelsTrash" VALUES (243, 59, 2011, '2011-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 van 2300', 0.11);
INSERT INTO "boekregelsTrash" VALUES (534, 117, 2011, '2011-07-15', 2200, NULL, 0, 0, '', '', '', 'Keukendoeken atelier', 0.48);
INSERT INTO "boekregelsTrash" VALUES (598, 119, 2011, '2011-09-21', 2200, NULL, 0, 0, '', '', '', 'Anne Fleur Derks Den Bosch', 4.23);
INSERT INTO "boekregelsTrash" VALUES (499, 113, 2011, '2011-09-13', 1600, NULL, 0, 0, 'hofman', '2011282', '', 'Onderhoud en reparatie', -225.24);
INSERT INTO "boekregelsTrash" VALUES (501, 113, 2011, '2011-09-13', 2210, NULL, 0, 0, 'hofman', '2011282', '', 'Onderhoud en reparatie', 35.96);
INSERT INTO "boekregelsTrash" VALUES (500, 113, 2011, '2011-09-13', 4740, NULL, 0, 0, 'hofman', '2011282', '', 'Onderhoud en reparatie', 189.28);
INSERT INTO "boekregelsTrash" VALUES (603, 120, 2011, '2011-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 398.93);
INSERT INTO "boekregelsTrash" VALUES (604, 120, 2011, '2011-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -376.74);
INSERT INTO "boekregelsTrash" VALUES (605, 120, 2011, '2011-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -322.46);
INSERT INTO "boekregelsTrash" VALUES (606, 120, 2011, '2011-09-30', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -96.98);
INSERT INTO "boekregelsTrash" VALUES (607, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -398.93);
INSERT INTO "boekregelsTrash" VALUES (608, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.07);
INSERT INTO "boekregelsTrash" VALUES (609, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2220', 96.98);
INSERT INTO "boekregelsTrash" VALUES (610, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 322.46);
INSERT INTO "boekregelsTrash" VALUES (611, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 376.74);
INSERT INTO "boekregelsTrash" VALUES (612, 120, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.18);
INSERT INTO "boekregelsTrash" VALUES (613, 120, 2011, '2011-09-30', 8030, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 625.00);
INSERT INTO "boekregelsTrash" VALUES (614, 120, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.07);
INSERT INTO "boekregelsTrash" VALUES (615, 120, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.18);
INSERT INTO "boekregelsTrash" VALUES (611, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2220', 96.98);
INSERT INTO "boekregelsTrash" VALUES (612, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2210', 322.46);
INSERT INTO "boekregelsTrash" VALUES (613, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 376.74);
INSERT INTO "boekregelsTrash" VALUES (610, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', -0.07);
INSERT INTO "boekregelsTrash" VALUES (609, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -398.93);
INSERT INTO "boekregelsTrash" VALUES (608, 121, 2011, '2011-09-30', 2220, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -96.98);
INSERT INTO "boekregelsTrash" VALUES (607, 121, 2011, '2011-09-30', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -322.46);
INSERT INTO "boekregelsTrash" VALUES (606, 121, 2011, '2011-09-30', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -376.74);
INSERT INTO "boekregelsTrash" VALUES (605, 121, 2011, '2011-09-30', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 398.93);
INSERT INTO "boekregelsTrash" VALUES (614, 121, 2011, '2011-09-30', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.18);
INSERT INTO "boekregelsTrash" VALUES (615, 121, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', 0.07);
INSERT INTO "boekregelsTrash" VALUES (616, 121, 2011, '2011-09-30', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.18);
INSERT INTO "boekregelsTrash" VALUES (604, 120, 2011, '2011-09-30', 4620, NULL, 0, 0, '', '', '', 'BTW partbtw correctie van: 2220', 0.00);
INSERT INTO "boekregelsTrash" VALUES (603, 120, 2011, '2011-09-30', 2220, NULL, 0, 0, '', '', 'btwcorrectie', 'BTW partbtw correctie naar: 4620', 0.00);
INSERT INTO "boekregelsTrash" VALUES (802, 150, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 61.00);
INSERT INTO "boekregelsTrash" VALUES (803, 150, 2011, '2011-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (797, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 8900', -61.00);
INSERT INTO "boekregelsTrash" VALUES (798, 150, 2011, '2011-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (1012, 192, 2013, '2013-04-27', 100, NULL, 0, 0, '', '', '', 'test 1', 111.00);
INSERT INTO "boekregelsTrash" VALUES (1275, 244, 2012, '2012-12-31', 8060, NULL, 0, 0, '', '', '', 'Verkopen 4e kwartaal aanvulling', -84.03);
INSERT INTO "boekregelsTrash" VALUES (1274, 244, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Verkopen 4e kwartaal aanvulling', -169.21);
INSERT INTO "boekregelsTrash" VALUES (1508, 325, 2012, '2012-11-01', 2200, NULL, 0, 0, 'verweij', '431.70', '', 'Huur atelier Boskoop nov', 349217.85);
INSERT INTO "boekregelsTrash" VALUES (1507, 325, 2012, '2012-11-01', 4100, NULL, 0, 0, 'verweij', '431.70', '', 'Huur atelier Boskoop nov', 1662942.15);
INSERT INTO "boekregelsTrash" VALUES (1506, 325, 2012, '2012-11-01', 1600, NULL, 0, 0, 'verweij', '431.70', '', 'Huur atelier Boskoop nov', -2012160.00);
INSERT INTO "boekregelsTrash" VALUES (1751, 349, 2012, '2012-06-14', 2200, NULL, 0, 0, '', '', '', 'Schildersdoek', 6.22);
INSERT INTO "boekregelsTrash" VALUES (1259, 241, 2012, '2012-06-30', 2110, NULL, 0, 0, '', '', '', 'Verkopen 2e kwartaal', -1004.95);
INSERT INTO "boekregelsTrash" VALUES (1260, 242, 2012, '2012-09-30', 1060, NULL, 0, 0, '', '', '', 'Verkopen 3e kwartaal facturen', 10543.26);
INSERT INTO "boekregelsTrash" VALUES (1958, 242, 2012, '2012-09-30', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 3e kw.', -165.25);
INSERT INTO "boekregelsTrash" VALUES (1269, 243, 2012, '2012-12-31', 1060, NULL, 0, 0, '', '', '', 'Cont. verkopen 4e kw.', 1750.00);
INSERT INTO "boekregelsTrash" VALUES (1986, 243, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', '', 'Cont. verkopen muursch. 4e kw.', -291.18);
INSERT INTO "boekregelsTrash" VALUES (2054, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', -0.35);
INSERT INTO "boekregelsTrash" VALUES (2053, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.35);
INSERT INTO "boekregelsTrash" VALUES (2052, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -268.35);
INSERT INTO "boekregelsTrash" VALUES (2051, 391, 2012, '2012-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 268.35);
INSERT INTO "boekregelsTrash" VALUES (2050, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (2049, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 130.00);
INSERT INTO "boekregelsTrash" VALUES (2048, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.02);
INSERT INTO "boekregelsTrash" VALUES (2047, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.45);
INSERT INTO "boekregelsTrash" VALUES (2046, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (2045, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 8900', -130.00);
INSERT INTO "boekregelsTrash" VALUES (2044, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.02);
INSERT INTO "boekregelsTrash" VALUES (2043, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 672.94);
INSERT INTO "boekregelsTrash" VALUES (2042, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 283.08);
INSERT INTO "boekregelsTrash" VALUES (2041, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.45);
INSERT INTO "boekregelsTrash" VALUES (2040, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -1352.45);
INSERT INTO "boekregelsTrash" VALUES (2039, 391, 2012, '2012-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -283.08);
INSERT INTO "boekregelsTrash" VALUES (2038, 391, 2012, '2012-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -672.94);
INSERT INTO "boekregelsTrash" VALUES (2037, 391, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 1352.45);
INSERT INTO "boekregelsTrash" VALUES (2006, 387, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -130.00);
INSERT INTO "boekregelsTrash" VALUES (2005, 387, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 130.00);
INSERT INTO "boekregelsTrash" VALUES (2056, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', -0.35);
INSERT INTO "boekregelsTrash" VALUES (2055, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.35);
INSERT INTO "boekregelsTrash" VALUES (2054, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -268.35);
INSERT INTO "boekregelsTrash" VALUES (2053, 392, 2012, '2012-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 268.35);
INSERT INTO "boekregelsTrash" VALUES (2052, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (2051, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 803.00);
INSERT INTO "boekregelsTrash" VALUES (2050, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.02);
INSERT INTO "boekregelsTrash" VALUES (2049, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.45);
INSERT INTO "boekregelsTrash" VALUES (2048, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5d', 0.00);
INSERT INTO "boekregelsTrash" VALUES (2047, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 8900', -803.00);
INSERT INTO "boekregelsTrash" VALUES (2046, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.02);
INSERT INTO "boekregelsTrash" VALUES (2045, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 672.94);
INSERT INTO "boekregelsTrash" VALUES (2044, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 283.08);
INSERT INTO "boekregelsTrash" VALUES (2043, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.45);
INSERT INTO "boekregelsTrash" VALUES (2042, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -1352.45);
INSERT INTO "boekregelsTrash" VALUES (2041, 392, 2012, '2012-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -283.08);
INSERT INTO "boekregelsTrash" VALUES (2040, 392, 2012, '2012-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -672.94);
INSERT INTO "boekregelsTrash" VALUES (2039, 392, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 1352.45);
INSERT INTO "boekregelsTrash" VALUES (2052, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1d', -0.35);
INSERT INTO "boekregelsTrash" VALUES (2051, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1d', 0.35);
INSERT INTO "boekregelsTrash" VALUES (2050, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 van 2150', -268.35);
INSERT INTO "boekregelsTrash" VALUES (2049, 392, 2012, '2012-12-31', 2150, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 5 naar 2300', 268.35);
INSERT INTO "boekregelsTrash" VALUES (2048, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', 0.02);
INSERT INTO "boekregelsTrash" VALUES (2047, 392, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.45);
INSERT INTO "boekregelsTrash" VALUES (2046, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', -0.02);
INSERT INTO "boekregelsTrash" VALUES (2045, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 672.94);
INSERT INTO "boekregelsTrash" VALUES (2044, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2210', 283.08);
INSERT INTO "boekregelsTrash" VALUES (2043, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.45);
INSERT INTO "boekregelsTrash" VALUES (2042, 392, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -1352.45);
INSERT INTO "boekregelsTrash" VALUES (2041, 392, 2012, '2012-12-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -283.08);
INSERT INTO "boekregelsTrash" VALUES (2040, 392, 2012, '2012-12-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -672.94);
INSERT INTO "boekregelsTrash" VALUES (2039, 392, 2012, '2012-12-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 1352.45);
INSERT INTO "boekregelsTrash" VALUES (2016, 388, 2012, '2012-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 5b', -0.12);
INSERT INTO "boekregelsTrash" VALUES (2015, 388, 2012, '2012-03-31', 8900, NULL, 0, 0, '', '', 'egalisatie', 'Afronding BTW groep: 1a', -0.43);
INSERT INTO "boekregelsTrash" VALUES (2014, 388, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 5b', 0.12);
INSERT INTO "boekregelsTrash" VALUES (2013, 388, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 566.49);
INSERT INTO "boekregelsTrash" VALUES (2012, 388, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2210', 128.39);
INSERT INTO "boekregelsTrash" VALUES (2011, 388, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'Afronding: 1a', 0.43);
INSERT INTO "boekregelsTrash" VALUES (2010, 388, 2012, '2012-03-31', 2300, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -604.43);
INSERT INTO "boekregelsTrash" VALUES (2009, 388, 2012, '2012-03-31', 2210, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -128.39);
INSERT INTO "boekregelsTrash" VALUES (2008, 388, 2012, '2012-03-31', 2200, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -566.49);
INSERT INTO "boekregelsTrash" VALUES (2007, 388, 2012, '2012-03-31', 2110, NULL, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 604.43);
INSERT INTO "boekregelsTrash" VALUES (2038, 391, 2012, '2012-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -803.00);
INSERT INTO "boekregelsTrash" VALUES (2037, 391, 2012, '2012-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 803.00);
INSERT INTO "boekregelsTrash" VALUES (2091, 400, 2012, '2012-12-31', 5010, NULL, 0, 0, '', '', '', 'Voorraad spuitmateriaal eindejaar', -600.00);
INSERT INTO "boekregelsTrash" VALUES (2090, 400, 2012, '2012-12-31', 3010, NULL, 0, 0, '', '', '', 'Voorraad spuitmateriaal eindejaar', 600.00);
INSERT INTO "boekregelsTrash" VALUES (2559, 497, 2014, '2014-03-19', 1600, NULL, 0, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', -14.51);
INSERT INTO "boekregelsTrash" VALUES (2560, 497, 2014, '2014-03-19', 2200, NULL, 0, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', 3.05);
INSERT INTO "boekregelsTrash" VALUES (2559, 497, 2014, '2014-03-19', 4240, NULL, 0, 0, 'tmobile', '901213303053', '', 'Mobiel mrt', 14.51);
INSERT INTO "boekregelsTrash" VALUES (2747, 524, 2014, '2014-05-02', 2200, NULL, 0, 0, '', '', '', 'Versnaperingen', 0.23);
INSERT INTO "boekregelsTrash" VALUES (2746, 524, 2014, '2014-05-02', 4290, NULL, 0, 0, '', '', '', 'Versnaperingen', 3.87);
INSERT INTO "boekregelsTrash" VALUES (2745, 524, 2014, '2014-05-02', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 11.15);
INSERT INTO "boekregelsTrash" VALUES (2744, 524, 2014, '2014-05-02', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 53.12);
INSERT INTO "boekregelsTrash" VALUES (2743, 524, 2014, '2014-05-01', 2210, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 2.56);
INSERT INTO "boekregelsTrash" VALUES (2742, 524, 2014, '2014-05-01', 4410, NULL, 0, 0, '', '', '', 'Brandstof Nissan', 12.19);
INSERT INTO "boekregelsTrash" VALUES (3019, 575, 2014, '2014-12-10', 2200, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', 32.63);
INSERT INTO "boekregelsTrash" VALUES (3018, 575, 2014, '2014-12-10', 5010, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', 155.37);
INSERT INTO "boekregelsTrash" VALUES (3017, 575, 2014, '2014-12-10', 1600, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', -188.00);
INSERT INTO "boekregelsTrash" VALUES (3025, 577, 2014, '2014-12-16', 2200, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', 29.00);
INSERT INTO "boekregelsTrash" VALUES (3024, 577, 2014, '2014-12-16', 5010, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', 138.10);
INSERT INTO "boekregelsTrash" VALUES (3023, 577, 2014, '2014-12-16', 1600, NULL, 0, 0, 'kramer', '118722417', '', 'Spuitmaterialen', -167.10);
INSERT INTO "boekregelsTrash" VALUES (3173, 594, 2014, '2014-12-31', 8900, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering van: 2300', -561.00);
INSERT INTO "boekregelsTrash" VALUES (3172, 594, 2014, '2014-12-31', 2300, NULL, 0, 0, '', '', '5dregeling', 'BTW 5d vermindering naar: 8900', 561.00);
INSERT INTO "boekregelsTrash" VALUES (3200, 598, 2014, '2014-12-31', 1060, NULL, 0, 0, '', '', '', 'Prive bijtelling Nissan NV200', 4750.00);
INSERT INTO "boekregelsTrash" VALUES (3201, 598, 2014, '2014-12-31', 4520, NULL, 0, 0, '', '', '', 'Prive bijtelling Nissan NV200', -4750.00);


--
-- Data for Name: btwaangiftes; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO btwaangiftes VALUES (1, 22, '2010-12-31', 2010, 4, 'rkg_btwverkoophoog', 163.00, 31.00, '1a');
INSERT INTO btwaangiftes VALUES (2, 22, '2010-12-31', 2010, 4, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (3, 22, '2010-12-31', 2010, 4, 'verkopen_verlegdebtw', 1000.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (4, 22, '2010-12-31', 2010, 4, 'subtotaal5a', 0.00, 31.00, '5a');
INSERT INTO btwaangiftes VALUES (5, 22, '2010-12-31', 2010, 4, 'rkg_btwinkopen', 0.00, 143.00, '5b');
INSERT INTO btwaangiftes VALUES (6, 22, '2010-12-31', 2010, 4, 'subtotaal5c', 0.00, -112.00, '5c');
INSERT INTO btwaangiftes VALUES (7, 22, '2010-12-31', 2010, 4, 'vermindering5d', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (8, 22, '2010-12-31', 2010, 4, 'totaal5e', 0.00, -112.00, '5e');
INSERT INTO btwaangiftes VALUES (13, 87, '2011-03-31', 2011, 1, 'rkg_btwinkopen', 0.00, 2401.00, '5b');
INSERT INTO btwaangiftes VALUES (12, 87, '2011-03-31', 2011, 1, 'subtotaal5a', 0.00, 2054.00, '5a');
INSERT INTO btwaangiftes VALUES (11, 87, '2011-03-31', 2011, 1, 'verkopen_geenbtw', 1515.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (10, 87, '2011-03-31', 2011, 1, 'rkg_btwverkooplaag', 117.00, 7.00, '1b');
INSERT INTO btwaangiftes VALUES (9, 87, '2011-03-31', 2011, 1, 'rkg_btwverkoophoog', 10774.00, 2047.00, '1a');
INSERT INTO btwaangiftes VALUES (14, 87, '2011-03-31', 2011, 1, 'subtotaal5c', 0.00, -347.00, '5c');
INSERT INTO btwaangiftes VALUES (15, 87, '2011-03-31', 2011, 1, 'totaal5e', 0.00, -347.00, '5e');
INSERT INTO btwaangiftes VALUES (16, 91, '2011-06-30', 2011, 2, 'rkg_btwverkoophoog', 3721.00, 707.00, '1a');
INSERT INTO btwaangiftes VALUES (17, 91, '2011-06-30', 2011, 2, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (18, 91, '2011-06-30', 2011, 2, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (19, 91, '2011-06-30', 2011, 2, 'subtotaal5a', 0.00, 707.00, '5a');
INSERT INTO btwaangiftes VALUES (20, 91, '2011-06-30', 2011, 2, 'rkg_btwinkopen', 0.00, 792.00, '5b');
INSERT INTO btwaangiftes VALUES (21, 91, '2011-06-30', 2011, 2, 'subtotaal5c', 0.00, -85.00, '5c');
INSERT INTO btwaangiftes VALUES (22, 91, '2011-06-30', 2011, 2, 'totaal5e', 0.00, -85.00, '5e');
INSERT INTO btwaangiftes VALUES (33, 121, '2011-09-30', 2011, 3, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (34, 121, '2011-09-30', 2011, 3, 'subtotaal5a', 0.00, 399.00, '5a');
INSERT INTO btwaangiftes VALUES (32, 121, '2011-09-30', 2011, 3, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (31, 121, '2011-09-30', 2011, 3, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (30, 121, '2011-09-30', 2011, 3, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (29, 121, '2011-09-30', 2011, 3, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (28, 121, '2011-09-30', 2011, 3, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (27, 121, '2011-09-30', 2011, 3, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (26, 121, '2011-09-30', 2011, 3, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (25, 121, '2011-09-30', 2011, 3, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (24, 121, '2011-09-30', 2011, 3, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (23, 121, '2011-09-30', 2011, 3, 'rkg_btwverkoophoog', 2100.00, 399.00, '1a');
INSERT INTO btwaangiftes VALUES (35, 121, '2011-09-30', 2011, 3, 'rkg_btwinkopen', 0.00, 796.00, '5b');
INSERT INTO btwaangiftes VALUES (36, 121, '2011-09-30', 2011, 3, 'subtotaal5c', 0.00, -397.00, '5c');
INSERT INTO btwaangiftes VALUES (37, 121, '2011-09-30', 2011, 3, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (38, 121, '2011-09-30', 2011, 3, 'totaal5e', 0.00, -397.00, '5e');
INSERT INTO btwaangiftes VALUES (39, 150, '2011-12-31', 2011, 4, 'rkg_btwverkoophoog', 3279.00, 623.00, '1a');
INSERT INTO btwaangiftes VALUES (40, 150, '2011-12-31', 2011, 4, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (41, 150, '2011-12-31', 2011, 4, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (42, 150, '2011-12-31', 2011, 4, 'rkg_btwprivegebruik', 1968.00, 374.00, '1d');
INSERT INTO btwaangiftes VALUES (43, 150, '2011-12-31', 2011, 4, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (44, 150, '2011-12-31', 2011, 4, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (45, 150, '2011-12-31', 2011, 4, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (46, 150, '2011-12-31', 2011, 4, 'verkopen_binneneu', 625.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (47, 150, '2011-12-31', 2011, 4, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (48, 150, '2011-12-31', 2011, 4, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (49, 150, '2011-12-31', 2011, 4, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (50, 150, '2011-12-31', 2011, 4, 'subtotaal5a', 0.00, 997.00, '5a');
INSERT INTO btwaangiftes VALUES (51, 150, '2011-12-31', 2011, 4, 'rkg_btwinkopen', 0.00, 936.00, '5b');
INSERT INTO btwaangiftes VALUES (52, 150, '2011-12-31', 2011, 4, 'subtotaal5c', 0.00, 61.00, '5c');
INSERT INTO btwaangiftes VALUES (53, 150, '2011-12-31', 2011, 4, 'rkg_5dregeling', 0.00, 61.00, '5d');
INSERT INTO btwaangiftes VALUES (54, 150, '2011-12-31', 2011, 4, 'totaal5e', 0.00, 0.00, '5e');
INSERT INTO btwaangiftes VALUES (55, 191, '2013-03-31', 2013, 1, 'rkg_btwverkoophoog', 7895.00, 1500.00, '1a');
INSERT INTO btwaangiftes VALUES (56, 191, '2013-03-31', 2013, 1, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (57, 191, '2013-03-31', 2013, 1, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (58, 191, '2013-03-31', 2013, 1, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (59, 191, '2013-03-31', 2013, 1, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (60, 191, '2013-03-31', 2013, 1, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (61, 191, '2013-03-31', 2013, 1, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (62, 191, '2013-03-31', 2013, 1, 'verkopen_binneneu', 540.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (63, 191, '2013-03-31', 2013, 1, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (64, 191, '2013-03-31', 2013, 1, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (65, 191, '2013-03-31', 2013, 1, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (66, 191, '2013-03-31', 2013, 1, 'subtotaal5a', 0.00, 1500.00, '5a');
INSERT INTO btwaangiftes VALUES (67, 191, '2013-03-31', 2013, 1, 'rkg_btwinkopen', 0.00, 719.00, '5b');
INSERT INTO btwaangiftes VALUES (68, 191, '2013-03-31', 2013, 1, 'subtotaal5c', 0.00, 781.00, '5c');
INSERT INTO btwaangiftes VALUES (69, 191, '2013-03-31', 2013, 1, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (70, 191, '2013-03-31', 2013, 1, 'totaal5e', 0.00, 781.00, '5e');
INSERT INTO btwaangiftes VALUES (71, 237, '2013-06-30', 2013, 2, 'rkg_btwverkoophoog', 6996.00, 1469.00, '1a');
INSERT INTO btwaangiftes VALUES (72, 237, '2013-06-30', 2013, 2, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (73, 237, '2013-06-30', 2013, 2, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (74, 237, '2013-06-30', 2013, 2, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (75, 237, '2013-06-30', 2013, 2, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (76, 237, '2013-06-30', 2013, 2, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (77, 237, '2013-06-30', 2013, 2, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (78, 237, '2013-06-30', 2013, 2, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (79, 237, '2013-06-30', 2013, 2, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (80, 237, '2013-06-30', 2013, 2, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (81, 237, '2013-06-30', 2013, 2, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (82, 237, '2013-06-30', 2013, 2, 'subtotaal5a', 0.00, 1469.00, '5a');
INSERT INTO btwaangiftes VALUES (83, 237, '2013-06-30', 2013, 2, 'rkg_btwinkopen', 0.00, 2565.00, '5b');
INSERT INTO btwaangiftes VALUES (84, 237, '2013-06-30', 2013, 2, 'subtotaal5c', 0.00, -1096.00, '5c');
INSERT INTO btwaangiftes VALUES (85, 237, '2013-06-30', 2013, 2, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (86, 237, '2013-06-30', 2013, 2, 'totaal5e', 0.00, -1096.00, '5e');
INSERT INTO btwaangiftes VALUES (104, 389, '2012-06-30', 2012, 2, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (105, 389, '2012-06-30', 2012, 2, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (106, 389, '2012-06-30', 2012, 2, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (107, 389, '2012-06-30', 2012, 2, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (108, 389, '2012-06-30', 2012, 2, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (109, 389, '2012-06-30', 2012, 2, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (110, 389, '2012-06-30', 2012, 2, 'verkopen_binneneu', 1100.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (111, 389, '2012-06-30', 2012, 2, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (112, 389, '2012-06-30', 2012, 2, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (113, 389, '2012-06-30', 2012, 2, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (117, 389, '2012-06-30', 2012, 2, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (120, 390, '2012-09-30', 2012, 3, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (121, 390, '2012-09-30', 2012, 3, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (122, 390, '2012-09-30', 2012, 3, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (123, 390, '2012-09-30', 2012, 3, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (124, 390, '2012-09-30', 2012, 3, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (125, 390, '2012-09-30', 2012, 3, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (126, 390, '2012-09-30', 2012, 3, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (127, 390, '2012-09-30', 2012, 3, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (128, 390, '2012-09-30', 2012, 3, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (129, 390, '2012-09-30', 2012, 3, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (133, 390, '2012-09-30', 2012, 3, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (103, 389, '2012-06-30', 2012, 2, 'rkg_btwverkoophoog', 5289.00, 1005.00, '1a');
INSERT INTO btwaangiftes VALUES (114, 389, '2012-06-30', 2012, 2, 'subtotaal5a', 0.00, 1005.00, '5a');
INSERT INTO btwaangiftes VALUES (115, 389, '2012-06-30', 2012, 2, 'rkg_btwinkopen', 0.00, 803.00, '5b');
INSERT INTO btwaangiftes VALUES (116, 389, '2012-06-30', 2012, 2, 'subtotaal5c', 0.00, 202.00, '5c');
INSERT INTO btwaangiftes VALUES (118, 389, '2012-06-30', 2012, 2, 'totaal5e', 0.00, 202.00, '5e');
INSERT INTO btwaangiftes VALUES (119, 390, '2012-09-30', 2012, 3, 'rkg_btwverkoophoog', 9895.00, 1880.00, '1a');
INSERT INTO btwaangiftes VALUES (130, 390, '2012-09-30', 2012, 3, 'subtotaal5a', 0.00, 1880.00, '5a');
INSERT INTO btwaangiftes VALUES (131, 390, '2012-09-30', 2012, 3, 'rkg_btwinkopen', 0.00, 1061.00, '5b');
INSERT INTO btwaangiftes VALUES (132, 390, '2012-09-30', 2012, 3, 'subtotaal5c', 0.00, 819.00, '5c');
INSERT INTO btwaangiftes VALUES (134, 390, '2012-09-30', 2012, 3, 'totaal5e', 0.00, 819.00, '5e');
INSERT INTO btwaangiftes VALUES (150, 394, '2012-03-31', 2012, 1, 'totaal5e', 0.00, -98.00, '5e');
INSERT INTO btwaangiftes VALUES (154, 396, '2012-12-31', 2012, 4, 'rkg_btwprivegebruik', 0.00, 374.00, '1d');
INSERT INTO btwaangiftes VALUES (162, 396, '2012-12-31', 2012, 4, 'subtotaal5a', 0.00, 1726.00, '5a');
INSERT INTO btwaangiftes VALUES (163, 396, '2012-12-31', 2012, 4, 'rkg_btwinkopen', 0.00, 804.00, '5b');
INSERT INTO btwaangiftes VALUES (165, 396, '2012-12-31', 2012, 4, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (166, 396, '2012-12-31', 2012, 4, 'totaal5e', 0.00, 922.00, '5e');
INSERT INTO btwaangiftes VALUES (164, 396, '2012-12-31', 2012, 4, 'subtotaal5c', 0.00, 922.00, '5c');
INSERT INTO btwaangiftes VALUES (136, 394, '2012-03-31', 2012, 1, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (137, 394, '2012-03-31', 2012, 1, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (138, 394, '2012-03-31', 2012, 1, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (139, 394, '2012-03-31', 2012, 1, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (140, 394, '2012-03-31', 2012, 1, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (141, 394, '2012-03-31', 2012, 1, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (142, 394, '2012-03-31', 2012, 1, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (143, 394, '2012-03-31', 2012, 1, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (144, 394, '2012-03-31', 2012, 1, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (145, 394, '2012-03-31', 2012, 1, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (149, 394, '2012-03-31', 2012, 1, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (151, 396, '2012-12-31', 2012, 4, 'rkg_btwverkoophoog', 6440.00, 1352.00, '1a');
INSERT INTO btwaangiftes VALUES (152, 396, '2012-12-31', 2012, 4, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (153, 396, '2012-12-31', 2012, 4, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (155, 396, '2012-12-31', 2012, 4, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (156, 396, '2012-12-31', 2012, 4, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (157, 396, '2012-12-31', 2012, 4, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (158, 396, '2012-12-31', 2012, 4, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (159, 396, '2012-12-31', 2012, 4, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (160, 396, '2012-12-31', 2012, 4, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (161, 396, '2012-12-31', 2012, 4, 'rkg_btwbinneneu', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (135, 394, '2012-03-31', 2012, 1, 'rkg_btwverkoophoog', 3211.00, 610.00, '1a');
INSERT INTO btwaangiftes VALUES (146, 394, '2012-03-31', 2012, 1, 'subtotaal5a', 0.00, 610.00, '5a');
INSERT INTO btwaangiftes VALUES (147, 394, '2012-03-31', 2012, 1, 'rkg_btwinkopen', 0.00, 708.00, '5b');
INSERT INTO btwaangiftes VALUES (148, 394, '2012-03-31', 2012, 1, 'subtotaal5c', 0.00, -98.00, '5c');
INSERT INTO btwaangiftes VALUES (167, 437, '2013-09-30', 2013, 3, 'rkg_btwverkoophoog', 6930.00, 1455.00, '1a');
INSERT INTO btwaangiftes VALUES (168, 437, '2013-09-30', 2013, 3, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (169, 437, '2013-09-30', 2013, 3, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (170, 437, '2013-09-30', 2013, 3, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (171, 437, '2013-09-30', 2013, 3, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (172, 437, '2013-09-30', 2013, 3, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (173, 437, '2013-09-30', 2013, 3, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (174, 437, '2013-09-30', 2013, 3, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (175, 437, '2013-09-30', 2013, 3, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (176, 437, '2013-09-30', 2013, 3, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (177, 437, '2013-09-30', 2013, 3, 'rkg_btwinkopeneubet', 141.00, 30.00, '4b');
INSERT INTO btwaangiftes VALUES (178, 437, '2013-09-30', 2013, 3, 'subtotaal5a', 0.00, 1485.00, '5a');
INSERT INTO btwaangiftes VALUES (179, 437, '2013-09-30', 2013, 3, 'rkg_btwinkopen', 0.00, 660.00, '5b');
INSERT INTO btwaangiftes VALUES (180, 437, '2013-09-30', 2013, 3, 'subtotaal5c', 0.00, 825.00, '5c');
INSERT INTO btwaangiftes VALUES (181, 437, '2013-09-30', 2013, 3, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (182, 437, '2013-09-30', 2013, 3, 'totaal5e', 0.00, 825.00, '5e');
INSERT INTO btwaangiftes VALUES (183, 476, '2013-12-31', 2013, 4, 'rkg_btwverkoophoog', 2441.00, 513.00, '1a');
INSERT INTO btwaangiftes VALUES (184, 476, '2013-12-31', 2013, 4, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (185, 476, '2013-12-31', 2013, 4, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (186, 476, '2013-12-31', 2013, 4, 'rkg_btwprivegebruik', 0.00, 498.00, '1d');
INSERT INTO btwaangiftes VALUES (187, 476, '2013-12-31', 2013, 4, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (188, 476, '2013-12-31', 2013, 4, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (189, 476, '2013-12-31', 2013, 4, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (190, 476, '2013-12-31', 2013, 4, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (191, 476, '2013-12-31', 2013, 4, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (192, 476, '2013-12-31', 2013, 4, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (193, 476, '2013-12-31', 2013, 4, 'rkg_btwinkopeneubet', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (194, 476, '2013-12-31', 2013, 4, 'subtotaal5a', 0.00, 1011.00, '5a');
INSERT INTO btwaangiftes VALUES (195, 476, '2013-12-31', 2013, 4, 'rkg_btwinkopen', 0.00, 773.00, '5b');
INSERT INTO btwaangiftes VALUES (196, 476, '2013-12-31', 2013, 4, 'subtotaal5c', 0.00, 238.00, '5c');
INSERT INTO btwaangiftes VALUES (197, 476, '2013-12-31', 2013, 4, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (198, 476, '2013-12-31', 2013, 4, 'totaal5e', 0.00, 238.00, '5e');
INSERT INTO btwaangiftes VALUES (199, 509, '2014-03-31', 2014, 1, 'rkg_btwverkoophoog', 1848.00, 388.00, '1a');
INSERT INTO btwaangiftes VALUES (200, 509, '2014-03-31', 2014, 1, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (201, 509, '2014-03-31', 2014, 1, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (202, 509, '2014-03-31', 2014, 1, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (203, 509, '2014-03-31', 2014, 1, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (204, 509, '2014-03-31', 2014, 1, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (205, 509, '2014-03-31', 2014, 1, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (206, 509, '2014-03-31', 2014, 1, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (207, 509, '2014-03-31', 2014, 1, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (208, 509, '2014-03-31', 2014, 1, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (209, 509, '2014-03-31', 2014, 1, 'rkg_btwinkopeneubet', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (210, 509, '2014-03-31', 2014, 1, 'subtotaal5a', 0.00, 388.00, '5a');
INSERT INTO btwaangiftes VALUES (211, 509, '2014-03-31', 2014, 1, 'rkg_btwinkopen', 0.00, 769.00, '5b');
INSERT INTO btwaangiftes VALUES (212, 509, '2014-03-31', 2014, 1, 'subtotaal5c', 0.00, -381.00, '5c');
INSERT INTO btwaangiftes VALUES (213, 509, '2014-03-31', 2014, 1, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (214, 509, '2014-03-31', 2014, 1, 'totaal5e', 0.00, -381.00, '5e');
INSERT INTO btwaangiftes VALUES (215, 531, '2014-06-30', 2014, 2, 'rkg_btwverkoophoog', 1619.00, 340.00, '1a');
INSERT INTO btwaangiftes VALUES (216, 531, '2014-06-30', 2014, 2, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (217, 531, '2014-06-30', 2014, 2, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (218, 531, '2014-06-30', 2014, 2, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (219, 531, '2014-06-30', 2014, 2, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (220, 531, '2014-06-30', 2014, 2, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (221, 531, '2014-06-30', 2014, 2, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (222, 531, '2014-06-30', 2014, 2, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (223, 531, '2014-06-30', 2014, 2, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (224, 531, '2014-06-30', 2014, 2, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (225, 531, '2014-06-30', 2014, 2, 'rkg_btwinkopeneubet', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (226, 531, '2014-06-30', 2014, 2, 'subtotaal5a', 0.00, 340.00, '5a');
INSERT INTO btwaangiftes VALUES (227, 531, '2014-06-30', 2014, 2, 'rkg_btwinkopen', 0.00, 407.00, '5b');
INSERT INTO btwaangiftes VALUES (228, 531, '2014-06-30', 2014, 2, 'subtotaal5c', 0.00, -67.00, '5c');
INSERT INTO btwaangiftes VALUES (229, 531, '2014-06-30', 2014, 2, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (230, 531, '2014-06-30', 2014, 2, 'totaal5e', 0.00, -67.00, '5e');
INSERT INTO btwaangiftes VALUES (231, 558, '2014-09-30', 2014, 3, 'rkg_btwverkoophoog', 2009.00, 422.00, '1a');
INSERT INTO btwaangiftes VALUES (232, 558, '2014-09-30', 2014, 3, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (233, 558, '2014-09-30', 2014, 3, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (234, 558, '2014-09-30', 2014, 3, 'rkg_btwprivegebruik', 0.00, 0.00, '1d');
INSERT INTO btwaangiftes VALUES (235, 558, '2014-09-30', 2014, 3, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (236, 558, '2014-09-30', 2014, 3, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (237, 558, '2014-09-30', 2014, 3, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (238, 558, '2014-09-30', 2014, 3, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (239, 558, '2014-09-30', 2014, 3, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (240, 558, '2014-09-30', 2014, 3, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (241, 558, '2014-09-30', 2014, 3, 'rkg_btwinkopeneubet', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (242, 558, '2014-09-30', 2014, 3, 'subtotaal5a', 0.00, 422.00, '5a');
INSERT INTO btwaangiftes VALUES (243, 558, '2014-09-30', 2014, 3, 'rkg_btwinkopen', 0.00, 374.00, '5b');
INSERT INTO btwaangiftes VALUES (244, 558, '2014-09-30', 2014, 3, 'subtotaal5c', 0.00, 48.00, '5c');
INSERT INTO btwaangiftes VALUES (245, 558, '2014-09-30', 2014, 3, 'rkg_5dregeling', 0.00, 0.00, '5d');
INSERT INTO btwaangiftes VALUES (246, 558, '2014-09-30', 2014, 3, 'totaal5e', 0.00, 48.00, '5e');
INSERT INTO btwaangiftes VALUES (247, 596, '2014-12-31', 2014, 4, 'rkg_btwverkoophoog', 2273.00, 477.00, '1a');
INSERT INTO btwaangiftes VALUES (248, 596, '2014-12-31', 2014, 4, 'rkg_btwverkooplaag', 0.00, 0.00, '1b');
INSERT INTO btwaangiftes VALUES (249, 596, '2014-12-31', 2014, 4, 'rkg_btwoverig', 0.00, 0.00, '1c');
INSERT INTO btwaangiftes VALUES (250, 596, '2014-12-31', 2014, 4, 'rkg_btwprivegebruik', 0.00, 511.00, '1d');
INSERT INTO btwaangiftes VALUES (251, 596, '2014-12-31', 2014, 4, 'verkopen_geenbtw', 0.00, 0.00, '1e');
INSERT INTO btwaangiftes VALUES (252, 596, '2014-12-31', 2014, 4, 'rkg_btwnaarmijverlegd', 0.00, 0.00, '2a');
INSERT INTO btwaangiftes VALUES (253, 596, '2014-12-31', 2014, 4, 'verkopen_buiteneu', 0.00, 0.00, '3a');
INSERT INTO btwaangiftes VALUES (254, 596, '2014-12-31', 2014, 4, 'verkopen_binneneu', 0.00, 0.00, '3b');
INSERT INTO btwaangiftes VALUES (255, 596, '2014-12-31', 2014, 4, 'verkopen_installatieeu', 0.00, 0.00, '3c');
INSERT INTO btwaangiftes VALUES (256, 596, '2014-12-31', 2014, 4, 'rkg_btwbuiteneu', 0.00, 0.00, '4a');
INSERT INTO btwaangiftes VALUES (257, 596, '2014-12-31', 2014, 4, 'rkg_btwinkopeneubet', 0.00, 0.00, '4b');
INSERT INTO btwaangiftes VALUES (258, 596, '2014-12-31', 2014, 4, 'subtotaal5a', 0.00, 988.00, '5a');
INSERT INTO btwaangiftes VALUES (259, 596, '2014-12-31', 2014, 4, 'rkg_btwinkopen', 0.00, 513.00, '5b');
INSERT INTO btwaangiftes VALUES (260, 596, '2014-12-31', 2014, 4, 'subtotaal5c', 0.00, 475.00, '5c');
INSERT INTO btwaangiftes VALUES (261, 596, '2014-12-31', 2014, 4, 'rkg_5dregeling', 0.00, 523.00, '5d');
INSERT INTO btwaangiftes VALUES (262, 596, '2014-12-31', 2014, 4, 'totaal5e', 0.00, -48.00, '5e');


--
-- Data for Name: btwkeys; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO btwkeys VALUES (1, 'rkg_btwverkoophoog', 'btwv', 1, '1a', '1a', 'Leveringen/diensten belast met hoog tarief', 'BTW bedragen verkopen hoog', 'Verkopen hoog', 2008, 1);
INSERT INTO btwkeys VALUES (2, 'rkg_btwverkooplaag', 'btwv', 1, '1b', '1b', 'Leveringen/diensten belast met laag tarief', 'BTW bedragen verkopen laag', 'Verkopen laag', 2008, 1);
INSERT INTO btwkeys VALUES (3, 'rkg_btwoverig', 'btwv', 0, '1c', '1c', 'Leveringen/diensten belast met overige tarieven behalve 0%', 'BTW bedragen verkopen overig', 'Verkopen overig', 2008, 1);
INSERT INTO btwkeys VALUES (4, 'rkg_btwprivegebruik', 'btwv', 1, '1d', '1d', 'Privégebruik', 'BTW bedragen privégebruik', 'BTW privégebruik', 2008, 1);
INSERT INTO btwkeys VALUES (5, 'verkopen_geenbtw', 'sal', 1, '1e', '1e', 'Leveringen/diensten belast met 0% of niet bij u belast', 'Verkopen 0% BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (6, 'verkopen_verlegdebtw', 'sal', 1, '1e', '', '', 'Verkopen verlegde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (7, 'verkopen_partbtwmateriaal', 'sal', 1, '1a', '', '', 'Verkopen part materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (8, 'rkg_btwnaarmijverlegd', 'btwv', 0, '2a', '2a', 'Leveringen/diensten waarbij de heffing van BTW naar u is verlegd', 'BTW bedragen naar mij verlegd', 'BTW naar mij verlegd', 2008, 1);
INSERT INTO btwkeys VALUES (9, 'verkopen_buiteneu', 'sal', 0, '3a', '3a', 'Leveringen naar landen buiten de EU (uitvoer)', 'Verkopen buiten EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (10, 'verkopen_binneneu', 'sal', 1, '3b', '3b', 'Leveringen naar/diensten in landen binnen de EU', 'Verkopen binnen EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (12, 'verkopen_installatieeu', 'sal', 0, '3c', '3c', 'Installatie/afstandsverkopen binnen de EU', 'Verkopen installaties binnen EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (15, 'subtotaal5a', 'sub', 1, '5a', '5a', 'Verschuldigde omzetbelasting: rubrieken 1 tm 4', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (16, 'rkg_btwinkopen', 'btwi', 1, '5b', '5b', 'Voorbelasting', 'BTW bedragen inkopen', 'Inkopen', 2008, 1);
INSERT INTO btwkeys VALUES (17, 'rkg_btwautokosten', 'btwi2', 1, '5b', '', 'Voorbelasting autokosten', 'BTW bedragen autokosten', 'BTW autokosten', 2008, 1);
INSERT INTO btwkeys VALUES (11, 'rkg_btwpartmateriaal', 'btwi80', 1, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2008, 1);
INSERT INTO btwkeys VALUES (18, 'subtotaal5c', 'sub', 1, '5c', '5c', 'Subtotaal: 5a min 5b', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (19, 'rkg_5dregeling', 'btw', 1, '5d', '5d', 'Vermindering volgens kleinondernemersregeling', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (20, 'totaal5e', 'tot', 1, '5e', '5e', 'Totaal', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (21, 'rkg_betaaldebtw', 'betbtw', 1, '', '', '', 'Rekening betaalde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (22, 'dervingbtw_partbtwmateriaal', 'calc', 1, '', '', '', 'Derving BTW partiele materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (23, 'inkopen_partbtwmateriaal', 'sal', 1, '', '', '', 'Inkopen partiele materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (24, 'verkopen_vrijgesteldebtw', 'sal', 1, '1e', '', '', 'Verkopen vrijgestelde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (25, 'verkopen_privegebruik', 'sal', 1, '1d', '', '', 'Omzet privégebruik', '', 2008, 1);
INSERT INTO btwkeys VALUES (26, 'verkopen_hoog', 'sal', 1, '1a', '', '', 'Verkopen BTW hoog', '', 2008, 1);
INSERT INTO btwkeys VALUES (27, 'verkopen_laag', 'sal', 1, '1b', '', '', 'Verkopen BTW laag', '', 2008, 1);
INSERT INTO btwkeys VALUES (28, 'rkg_btwpartmateriaal', 'btwi80', 0, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2013, 1);
INSERT INTO btwkeys VALUES (29, 'rkg_btwpartmateriaal', 'btwi80', 0, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2012, 0);
INSERT INTO btwkeys VALUES (13, 'rkg_btwbuiteneu', 'btwv', 0, '4a', '4a', 'Leveringen/diensten uit landen buiten de EU', 'BTW bedragen inkopen buiten EU', 'Levering van buiten EU', 2008, 1);
INSERT INTO btwkeys VALUES (14, 'inkopen_binneneu', 'sal', 1, '4b', NULL, 'Leveringen/diensten uit landen binnen de EU', 'Inkopen binnen EU', NULL, 2013, 1);
INSERT INTO btwkeys VALUES (30, 'rkg_btwinkopeneuontv', 'btwv', 1, '5b', '', 'Voorbelasting verwerving binnen EU', 'BTW bedragen inkopen EU te ontvangen', 'Inkopen binnen EU', 2013, 1);
INSERT INTO btwkeys VALUES (30, 'rkg_btwinkopeneubet', 'btwv', 1, '4b', '4b', 'Leveringen/diensten uit landen binnen de EU', 'BTW bedragen inkopen binnen EU te betalen', NULL, 2013, 1);


--
-- Data for Name: btwrelaties; Type: TABLE DATA; Schema: public; Owner: www
--



--
-- Data for Name: btwsaldi; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO btwsaldi VALUES (1, '1a', 1848, 388, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (2, '1a', 1619, 340, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (3, '1a', 2009, 422, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (1, '5a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 388, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (2, '5a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 340, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (3, '5a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 422, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (1, '5b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 769, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (2, '5b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 407, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (3, '5b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 374, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (1, '5c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, -381, NULL, NULL);
INSERT INTO btwsaldi VALUES (2, '5c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, -67, NULL, NULL);
INSERT INTO btwsaldi VALUES (3, '5c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL);
INSERT INTO btwsaldi VALUES (1, '5e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, -381);
INSERT INTO btwsaldi VALUES (2, '5e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, -67);
INSERT INTO btwsaldi VALUES (3, '5e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48);
INSERT INTO btwsaldi VALUES (4, '1a', 3010, 632, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (4, '5a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 632, NULL, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (4, '5b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL);
INSERT INTO btwsaldi VALUES (4, '5c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 612, NULL, NULL);
INSERT INTO btwsaldi VALUES (4, '5e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 612);


--
-- Data for Name: crediteurenstam; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO crediteurenstam VALUES (1, '2011-02-27', 'kramer', 'Henx/Kramer', '', '', '', '', 'H. Kramer
Akkerland 20
1112 HB Diemen', '', 0.00);
INSERT INTO crediteurenstam VALUES (2, '2011-02-27', 'marktplaats', 'Marktplaats', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (3, '2011-02-27', 'kvk', 'Kamer van Koophandel Rotterdam', '', '', '', '', 'Blaak 40
3011 TA Rotterdam', '', 0.00);
INSERT INTO crediteurenstam VALUES (4, '2011-02-27', 'kleyn', 'Kleyn Vans B.V.', '', '', '', '', 'Industrieweg 2
4214 KZ Vuren', '', 0.00);
INSERT INTO crediteurenstam VALUES (5, '2011-02-27', 'ifactors', 'iFactors', '', '', '', '', 'Zoetermeer', '', 0.00);
INSERT INTO crediteurenstam VALUES (6, '2011-02-27', 'mediamarkt', 'MediaMarkt', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (7, '2011-02-27', 'vandien', 'VanDien verzekeringen', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (8, '2011-02-27', 'vendrig', 'Vendrig Packaging BV', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (9, '2011-02-27', 'wehkamp', 'Wehkamp', '', '', '', '', 'Zwolle', '', 0.00);
INSERT INTO crediteurenstam VALUES (10, '2011-02-27', 'tmobile', 'T-Mobile', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (11, '2011-02-27', 'belasting', 'Belastingdienst', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (12, '2011-02-27', 'hofman', 'Hofman autobedrijf', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (14, '2011-04-27', 'moonen', 'Moonen packaging', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (15, '2011-04-27', 'nicolaas', 'Nicolaas verfindustrie', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (16, '2011-04-27', 'inmac', 'Inmac', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (17, '2011-04-27', '123inkt', '123inkt', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (18, '2011-04-27', 'vandijken', 'vanDijken Glas', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (19, '2011-04-27', 'polijst', 'Polijstweb', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (20, '2011-04-28', 'claasen', 'Claasen Coatings', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (21, '2011-04-28', 'dorpstraat', 'Winkeliersvereniging Dorpstraat', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (22, '2011-07-11', 'verweij', 'Verweij Holding b.v.', '', '0172-216904', '0172-213701', '', 'Koninginneweg 1d
2771 DN Boskoop
Postbus 155
2770 AD Boskoop', '', 0.00);
INSERT INTO crediteurenstam VALUES (23, '2011-07-11', 'hartvh', 'Hart van Holland', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (24, '2011-07-11', 'tubecl', 'Tubeclamps Nederland', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (25, '2011-07-11', 'delft', 'Gemeente Delft', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (26, '2011-07-11', 'staples', 'Staples Office', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (27, '2011-10-10', 'vodafone', 'Vodafone', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (28, '2011-10-10', 'sligro', 'Sligro', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (29, '2011-10-10', 'dms', 'DMS Sound', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (30, '2012-01-18', 'engelb', 'Engelbert Strauss', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (31, '2012-01-18', 'diverse', 'Diverse crediteuren', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (32, '2012-01-18', 'bosman', 'Bosman letters en reclame', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (33, '2013-04-14', 'tshirts', 'T-shirts groothandel', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (34, '2013-04-14', 'drukwerk', 'Drukwerkdeal', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (35, '2013-04-14', 'uc', 'UC-Distribution b.v.', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (36, '2013-04-14', 'stoffen', 'Stoffen online', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (37, '2013-04-14', 'foka', 'Foka b.v.', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (38, '2013-04-14', 'konijn', 'Foto Konijnenberg', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (39, '2013-04-14', 'vanbeek', 'van Beek', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (40, '2013-04-14', 'coating', 'Coatingwinkel.nl', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (41, '2013-04-14', 'vend', 'V&D', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (42, '2013-07-07', 'bolcom', 'Bol.com', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (43, '2013-07-07', 'conrad', 'Conrad', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (44, '2013-07-07', 'kbaudio', 'KB Audio', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (45, '2013-07-07', 'profile', 'Profile Tyrecenter', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (46, '2013-07-12', 'koops', 'Koops Auto', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (47, '2013-07-31', 'a1', 'A1 gereedschappen', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (48, '2013-07-31', 'paradigit', 'Paradigit', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (49, '2013-07-31', 'acronis', 'Acronis software', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (50, '2013-07-31', 'kroon', 'Kroon Leveranciers', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (51, '2013-07-31', 'surprise', 'YourSuprise.com', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (52, '2013-07-31', 'canvas', 'Canvasdeal', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (53, '2013-07-31', 'buitelaar', 'Herman Buitelaar', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (54, '2013-07-31', 'denhaag', 'Gemeente Den Haag', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (55, '2013-07-31', 'accu', 'Goudse Accucentrale', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (56, '2013-07-31', 'kleding', 'Kleding-groothandel.nl', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (57, '2013-10-16', 'betaalbaar', 'Betaalbaarshoppen.nl', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (58, '2013-10-18', 'kruiz', 'Kruizinga.nl opslag- en transportmiddelen', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (60, '2013-10-18', 'altern', 'Alternate', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (61, '2013-10-18', 'groenec', 'Groene Computershop', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (62, '2013-10-18', 'mycom', 'MyCom', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (63, '2013-10-26', 'publikat', 'Publikat', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (64, '2013-10-26', 'molotow', 'Molotow distribution', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (59, '2013-10-18', 'wadcult', 'Wadcultureel', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (13, '2011-04-27', 'rip', 'Rip Bloem en Stijl', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (65, '2014-01-12', 'xs4all', 'Xs4All', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (66, '2014-01-12', 'hamrick', 'Hamrick software', '', '', '', '', 'USA', '', 0.00);
INSERT INTO crediteurenstam VALUES (67, '2014-04-19', 'akabels', 'Alle kabels', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (68, '2014-04-26', 'objekt', 'Objekt reclame', '', '', '', '', '', '', 0.00);
INSERT INTO crediteurenstam VALUES (69, '2015-01-25', 'Transip', 'Transip', '', '', '', '', '', '', 0.00);


--
-- Data for Name: dagboeken; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO dagboeken VALUES (1, 'begin', 'begin', 'Beginbalans', 2130, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (2, 'memo', 'memo', 'Memoriaal', 2130, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (3, 'kas', 'kas', 'Kas en prive', 1060, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (8, 'bank', 'amro', 'Amrobank', 1050, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (5, 'inkoop', 'inkoop', 'Inkoopboek', 1600, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (6, 'verkoop', 'verkoop', 'Verkoopboek', 1200, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (7, 'pin', 'pin', 'Pinbetalingen', 2020, 0, 0.00, 0, 2008, 1);


--
-- Data for Name: dagboekhistorie; Type: TABLE DATA; Schema: public; Owner: www
--



--
-- Data for Name: debiteurenstam; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO debiteurenstam VALUES (1, '2011-02-27', 'elgusto', 'El Gusto', 'Lucienne', '', '', '', 'Dorpstraat 17
5504 Veldhoven', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (2, '2011-02-27', 'midholl', 'St. Jeugd en Jongerenwerk Midden-Holland', 'Daniel Korver', '', '', '', 'Noordkade 64A
2741 EZ Waddinxveen', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (3, '2011-02-27', 'woonp', 'Woonpartners Midden-Holland', 'Sandra Stevens', '', '', '', 'Coenecoop 6
2741 PG Waddinxveen', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (4, '2011-02-27', 'particulier', 'Particulier', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (5, '2011-02-27', 'taxione', 'Taxi One', 'Remko Hummels', '', '', '', 'Nijverheidsstraat 14B
Gouda', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (6, '2011-02-27', 'cenf', 'C&F Sporting', '', '', '', '', 'Ambachtsweg 35
2841 MB Moordrecht', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (7, '2011-04-27', 'mwh', 'MWH Global', 'Vincent van Dijk', '', '', '', 'Delftechpark 9
2628XJ  DELFT', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (8, '2011-07-11', 'ipse', 'Stichting Ipse de Bruggen', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (9, '2011-07-11', 'gopdelft', 'goPasta Delft', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (10, '2011-07-11', 'dread', 'Dreadshop', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (11, '2011-07-11', 'rood', 'Ro-od Cinema Veenendaal bv', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (12, '2011-08-20', 'stek', 'De Stek', 'Vincent Plasmijer', '', '', '', 'Hazerswoude', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (13, '2011-09-30', 'kruimels', 'Kruimels', 'Yshai Thomas', '', '', '', 'Den Haag', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (14, '2011-09-30', 'vdEnde', 'vd End Theaterarrengementen', 'Marc Kempenaar / Eveline Bors', '', '', '', 'Amsterdam', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (15, '2011-09-30', 'gopbremen', 'goPasta GmbH & Co. KG, Bremen', 'Volker Nell & Matthias Beran', '', '', '', 'Papenstrasse 1
Bremen
Fac.adres:
Wilhelm-Heidsieck Strasse 45
27472 Cuxhaven
Taxnr: 18/203/05497
Handelsreg: Tostedt HRB 203012', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (16, '2012-01-22', 'spruyt', 'Juwelier Spruytenburg', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (17, '2012-01-22', 'JJB', 'JJB Grondverzet', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (18, '2013-04-23', 'kernel', 'Kernel groep / Beccaria Instituut', 'H. Neddermeijer', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (19, '2013-04-23', 'gopantw', 'GoPasta Antwerpen', 'Michael', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (20, '2013-04-23', 'bomenwijk', 'Wijkplatform Bomenwijk/Groenswaard', 'Anja Dijkhuizen', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (21, '2013-07-13', 'rooiehoek', 'Cafe de Rooie Hoek', '', '', '', '', 'Boskoop', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (22, '2013-07-13', 'eataly', 'Eataly', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (30, '2013-07-13', 'freedom', 'Freedom Registry', 'Marcel Trik', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (24, '2013-07-13', 'annders', 'Annders Interieurstyling en advies', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (25, '2013-07-13', 'coppoolse', 'Yvette Coppoolse', '', '', '', '', 'Breezand', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (26, '2013-07-13', 'horizon', 'Horizon Academie', 'Ediwn van Oostenrijk', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (27, '2013-07-13', 'markies', 'Cafe de Markies', '', '', '', '', 'Maassluis', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (28, '2013-07-13', 'butterfly', 'GOO Butterfly', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (29, '2013-07-13', 'koops', 'Koops Auto', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (31, '2013-07-31', 'skihutu', 'Skihut Utrecht', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (32, '2013-08-08', 'gopfreib', 'goPasta GMBH, Freiburg', 'Axel Gellautz', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (33, '2013-08-08', 'zuleico', 'Zuleico Dos Reis', '', '', '', '', 'Rotterdam', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (34, '2013-08-08', 'interior', 'Interior Services Group Netherlands bv', '', '', '', '', 'Amsteldijk 166
1079 LH  AMSTERDAM', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (35, '2013-08-08', 'hako', 'HAKO Bouw', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (36, '2013-08-08', 'saffier', 'Saffier de Residentie', 'Petra Beeloo', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (37, '2013-08-08', 'oudenes', 'Glazenwasserij Oudenes', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (38, '2013-08-08', 'russel', 'Russel Broadbent', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (39, '2013-08-08', 'thurley', 'Mike Thurley', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (40, '2013-08-08', 'femtastic', 'Dansstudio Femtastic', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (41, '2013-08-08', 'grvenen', 'Bibliotheek de Groene Venen', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (42, '2013-08-08', 'quarijn', 'Stichting Quarijn', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (43, '2013-08-08', 'intwell', 'International Wellness Resorts', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (44, '2013-08-08', 'rabozhm', 'Rabobank Zuid Holland Midden', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (45, '2013-08-08', 'ordemed', 'Orde van Medisch Specialisten', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (46, '2013-08-08', 'smit', 'Smit en Peters Multi Projecten', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (47, '2013-08-08', 'leeuwen', 'Van Leeuwen Wegenbouw', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (48, '2013-10-27', 'quawonen', 'QuaWonen', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (49, '2013-10-27', 'hockey', 'Hockeyclub Waddinxveen', 'Margo Vreeburg', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (50, '2013-10-27', 'dadanza', 'Studio Da Danza', 'Miranda Heemskerk', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (51, '2013-10-27', 'ppannekoek', 'Peter Pannekoek', 'Mascha Middeldorp', '', '', '', 'Wateringen', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (52, '2013-10-27', 'nsveiligh', 'NS Concern Veiligheid', 'Jerry Prins', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (53, '2014-01-07', 'jaguacy', 'Jaguacy Holland b.v.', 'Ron Jongejans', '', '', '', 'Honderdlaan 242
2676 LV  MAASDIJK', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (54, '2014-01-07', 'stolwijk', 'St. Jongerencentrum Stolwijk', 'Rik van der Meer', '', '', '', 'Kerspelpad 20
Stolwijk', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (55, '2014-01-07', 'krimpen', 'Gemeente Krimpen a.d. IJssel', 'Liesbeth Pleizier', '', '', '', 'Postbus 200
2920 AE  Krimpen a.d. IJssel', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (56, '2014-04-26', 'fitzroy', 'Fizroy & Everest', 'Olivier van Schaik', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (57, '2014-04-26', 'tvk', 'TVK Klaaswaal', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (58, '2014-04-26', 'dennis', 'Dennis Tweewielers', '', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (59, '2014-07-27', 'lbc', 'LBC Horeca BV', 'Eddie Otten', '', '', '', 'Grotestraat Centrum 26
6301 CX  VALKENBURG', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (60, '2014-10-26', 'luc4me', 'Luc4Me', 'Marcia Bodt', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (61, '2014-10-26', 'leeuwenauto', 'Van Leeuwen Autobedrijf B.V.', 'Rob den Boer', '', '', '', '', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (62, '2015-01-25', 'crossfit', 'CrossFit030', 'Mark Voordouw', '', '', '', 'Industrieweg 36-03
3606 AS  MAARSSEN', 0, 0.00, NULL);
INSERT INTO debiteurenstam VALUES (63, '2015-01-25', 'mulder', 'Mulder mode', '', '', '', '', 'Promenade 156
2741 NL  WADDINXVEEN', 0, 0.00, NULL);


--
-- Data for Name: eindbalansen; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO eindbalansen VALUES (1, '2012-03-31', 2010, 237.55, 0.00, -237.55);
INSERT INTO eindbalansen VALUES (2, '2013-01-12', 2011, 472.15, 0.00, -483.74);
INSERT INTO eindbalansen VALUES (3, '2013-08-27', 2012, 9638.64, 0.00, -9638.64);
INSERT INTO eindbalansen VALUES (4, '2015-03-31', 2013, 8208.50, 0.00, -7814.22);


--
-- Data for Name: eindbalansregels; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO eindbalansregels VALUES (1, 1, 1060, 'Rekening courant prive', 1196.35, -1070.80, 125.55);
INSERT INTO eindbalansregels VALUES (2, 1, 1200, 'Debiteuren', 1196.35, -1196.35, 0.00);
INSERT INTO eindbalansregels VALUES (3, 1, 1600, 'Crediteuren', 551.89, -551.89, 0.00);
INSERT INTO eindbalansregels VALUES (4, 1, 2110, 'Af te dragen BTW hoog tarief', 31.35, -31.35, 0.00);
INSERT INTO eindbalansregels VALUES (5, 1, 2200, 'Te ontvangen BTW', 142.71, -142.71, 0.00);
INSERT INTO eindbalansregels VALUES (6, 1, 2300, 'BTW met de fiscus te verrekenen', 143.35, -31.35, 112.00);
INSERT INTO eindbalansregels VALUES (7, 1, 4220, 'Atelierkosten', 62.70, 0.00, 62.70);
INSERT INTO eindbalansregels VALUES (8, 1, 4230, 'Kantoorkosten', 29.40, 0.00, 29.40);
INSERT INTO eindbalansregels VALUES (9, 1, 4240, 'Telefoonkosten', 46.22, 0.00, 46.22);
INSERT INTO eindbalansregels VALUES (10, 1, 4400, 'Reiskosten', 142.88, 0.00, 142.88);
INSERT INTO eindbalansregels VALUES (11, 1, 4490, 'Diverse kosten', 34.04, 0.00, 34.04);
INSERT INTO eindbalansregels VALUES (12, 1, 4500, 'Promotiekosten', 173.11, 0.00, 173.11);
INSERT INTO eindbalansregels VALUES (13, 1, 4600, 'Inkopen', 439.74, 0.00, 439.74);
INSERT INTO eindbalansregels VALUES (14, 1, 8010, 'Verkopen Atelier', 0.00, -165.00, -165.00);
INSERT INTO eindbalansregels VALUES (15, 1, 8120, 'Verkopen Workshops 0% BTW', 0.00, -1000.00, -1000.00);
INSERT INTO eindbalansregels VALUES (16, 1, 8900, 'Diverse opbrengsten', 0.00, -0.64, -0.64);
INSERT INTO eindbalansregels VALUES (17, 2, 200, 'Auto Opel Combo 88-BH-JP', 3500.00, 0.00, 3500.00);
INSERT INTO eindbalansregels VALUES (18, 2, 900, 'Kapitaal/prive', 0.00, -112.00, -112.00);
INSERT INTO eindbalansregels VALUES (19, 2, 1060, 'Rekening courant prive', 3938.12, -6842.38, -2904.26);
INSERT INTO eindbalansregels VALUES (20, 2, 1200, 'Debiteuren', 23947.36, -23947.36, 0.00);
INSERT INTO eindbalansregels VALUES (21, 2, 1600, 'Crediteuren', 28065.48, -28065.48, 0.00);
INSERT INTO eindbalansregels VALUES (22, 2, 2110, 'Af te dragen BTW hoog tarief', 3775.62, -3775.62, 0.00);
INSERT INTO eindbalansregels VALUES (23, 2, 2120, 'Af te dragen BTW laag tarief', 7.36, -7.36, 0.00);
INSERT INTO eindbalansregels VALUES (24, 2, 2150, 'Af te dragen BTW Privegebruik', 374.00, -374.00, 0.00);
INSERT INTO eindbalansregels VALUES (25, 2, 2200, 'Te ontvangen BTW', 2858.37, -2858.37, 0.00);
INSERT INTO eindbalansregels VALUES (26, 2, 2210, 'Te ontvangen BTW autokosten', 1803.46, -1803.46, 0.00);
INSERT INTO eindbalansregels VALUES (27, 2, 2220, 'Te ontvangen BTW partiele materialen', 337.11, -337.11, 0.00);
INSERT INTO eindbalansregels VALUES (28, 2, 2300, 'BTW met de fiscus te verrekenen', 5098.84, -5098.84, 0.00);
INSERT INTO eindbalansregels VALUES (29, 2, 4100, 'Huisvestingskosten', 2000.00, 0.00, 2000.00);
INSERT INTO eindbalansregels VALUES (30, 2, 4210, 'Klein apparatuur', 1530.27, 0.00, 1530.27);
INSERT INTO eindbalansregels VALUES (31, 2, 4220, 'Atelierkosten', 1914.32, 0.00, 1914.32);
INSERT INTO eindbalansregels VALUES (32, 2, 4230, 'Kantoorkosten', 435.06, 0.00, 435.06);
INSERT INTO eindbalansregels VALUES (33, 2, 4235, 'Kantinekosten', 131.29, 0.00, 131.29);
INSERT INTO eindbalansregels VALUES (34, 2, 4240, 'Telefoonkosten', 155.07, 0.00, 155.07);
INSERT INTO eindbalansregels VALUES (35, 2, 4245, 'Internetkosten', 150.08, 0.00, 150.08);
INSERT INTO eindbalansregels VALUES (36, 2, 4250, 'Portikosten', 48.42, 0.00, 48.42);
INSERT INTO eindbalansregels VALUES (37, 2, 4400, 'Reiskosten', 14.80, 0.00, 14.80);
INSERT INTO eindbalansregels VALUES (38, 2, 4490, 'Diverse kosten', 354.97, 0.00, 354.97);
INSERT INTO eindbalansregels VALUES (39, 2, 4500, 'Promotiekosten', 527.59, 0.00, 527.59);
INSERT INTO eindbalansregels VALUES (40, 2, 4600, 'Inkopen', 7492.87, 0.00, 7492.87);
INSERT INTO eindbalansregels VALUES (41, 2, 4610, 'Inkopen partiele materialen', 2567.00, 0.00, 2567.00);
INSERT INTO eindbalansregels VALUES (42, 2, 4620, 'BTW derving partiele materialen', 73.80, 0.00, 73.80);
INSERT INTO eindbalansregels VALUES (43, 2, 4710, 'Brandstof auto', 1816.82, 0.00, 1816.82);
INSERT INTO eindbalansregels VALUES (44, 2, 4720, 'Verzekering auto', 1055.01, -68.75, 986.26);
INSERT INTO eindbalansregels VALUES (45, 2, 4730, 'Wegenbelasting auto', 322.00, 0.00, 322.00);
INSERT INTO eindbalansregels VALUES (46, 2, 4740, 'Overige kosten auto', 4208.70, 0.00, 4208.70);
INSERT INTO eindbalansregels VALUES (47, 2, 4780, 'Prive bijtelling auto', 0.00, -3006.25, -3006.25);
INSERT INTO eindbalansregels VALUES (48, 2, 8010, 'Verkopen Atelier', 0.00, -11015.16, -11015.16);
INSERT INTO eindbalansregels VALUES (49, 2, 8020, 'Verkopen Kunst laag', 0.00, -122.65, -122.65);
INSERT INTO eindbalansregels VALUES (50, 2, 8030, 'Verkopen Buitenland', 0.00, -625.00, -625.00);
INSERT INTO eindbalansregels VALUES (51, 2, 8120, 'Verkopen Workshops 0% BTW', 0.00, -1515.00, -1515.00);
INSERT INTO eindbalansregels VALUES (52, 2, 8140, 'Verkopen kunst partiele materialen', 0.00, -8856.57, -8856.57);
INSERT INTO eindbalansregels VALUES (53, 2, 8900, 'Diverse opbrengsten', 0.86, -61.70, -60.84);
INSERT INTO eindbalansregels VALUES (54, 3, 200, 'Auto Opel Combo 88-BH-JP', 3500.00, 0.00, 3500.00);
INSERT INTO eindbalansregels VALUES (55, 3, 250, 'Afschrijving Opel Combo', 0.00, -1378.90, -1378.90);
INSERT INTO eindbalansregels VALUES (56, 3, 900, 'Kapitaal/prive', 0.00, -3500.00, -3500.00);
INSERT INTO eindbalansregels VALUES (57, 3, 1060, 'Rekening courant prive', 34705.57, -24335.01, 10370.56);
INSERT INTO eindbalansregels VALUES (58, 3, 1200, 'Debiteuren', 21058.55, -20638.57, 419.98);
INSERT INTO eindbalansregels VALUES (59, 3, 1600, 'Crediteuren', 17464.29, -17464.29, 0.00);
INSERT INTO eindbalansregels VALUES (60, 3, 2110, 'Af te dragen BTW hoog tarief', 4826.80, -4826.80, 0.00);
INSERT INTO eindbalansregels VALUES (61, 3, 2150, 'Af te dragen BTW Privegebruik', 268.35, -268.35, 0.00);
INSERT INTO eindbalansregels VALUES (62, 3, 2200, 'Te ontvangen BTW', 2815.31, -2815.31, 0.00);
INSERT INTO eindbalansregels VALUES (63, 3, 2210, 'Te ontvangen BTW autokosten', 783.87, -783.87, 0.00);
INSERT INTO eindbalansregels VALUES (64, 3, 2300, 'BTW met de fiscus te verrekenen', 5421.33, -5194.33, 227.00);
INSERT INTO eindbalansregels VALUES (65, 3, 4100, 'Huisvestingskosten', 4467.92, 0.00, 4467.92);
INSERT INTO eindbalansregels VALUES (66, 3, 4210, 'Klein apparatuur', 394.11, 0.00, 394.11);
INSERT INTO eindbalansregels VALUES (67, 3, 4220, 'Atelierkosten', 2067.89, -10.69, 2057.20);
INSERT INTO eindbalansregels VALUES (68, 3, 4230, 'Kantoorkosten', 311.80, 0.00, 311.80);
INSERT INTO eindbalansregels VALUES (69, 3, 4235, 'Kantinekosten', 9.77, 0.00, 9.77);
INSERT INTO eindbalansregels VALUES (70, 3, 4240, 'Telefoonkosten', 262.71, 0.00, 262.71);
INSERT INTO eindbalansregels VALUES (71, 3, 4245, 'Internetkosten', 276.92, -4.20, 272.72);
INSERT INTO eindbalansregels VALUES (72, 3, 4250, 'Portikosten', 62.05, 0.00, 62.05);
INSERT INTO eindbalansregels VALUES (73, 3, 4270, 'Reiskosten', 187.05, 0.00, 187.05);
INSERT INTO eindbalansregels VALUES (74, 3, 4290, 'Diverse kosten', 397.09, 0.00, 397.09);
INSERT INTO eindbalansregels VALUES (75, 3, 4310, 'Promotiekosten', 276.10, 0.00, 276.10);
INSERT INTO eindbalansregels VALUES (76, 3, 4410, 'Brandstof auto', 2361.97, 0.00, 2361.97);
INSERT INTO eindbalansregels VALUES (77, 3, 4420, 'Verzekering auto', 421.47, 0.00, 421.47);
INSERT INTO eindbalansregels VALUES (78, 3, 4430, 'Wegenbelasting auto', 284.00, 0.00, 284.00);
INSERT INTO eindbalansregels VALUES (79, 3, 4440, 'Overige kosten auto', 163.12, 0.00, 163.12);
INSERT INTO eindbalansregels VALUES (80, 3, 4450, 'Onderhoud auto', 1535.98, 0.00, 1535.98);
INSERT INTO eindbalansregels VALUES (81, 3, 4510, 'BTW privé gebruik auto', 268.35, 0.00, 268.35);
INSERT INTO eindbalansregels VALUES (82, 3, 4520, 'Prive bijtelling auto', 0.00, -4472.50, -4472.50);
INSERT INTO eindbalansregels VALUES (83, 3, 4620, 'Afschrijving Opel', 1378.90, 0.00, 1378.90);
INSERT INTO eindbalansregels VALUES (84, 3, 5010, 'Inkopen', 6350.81, 0.00, 6350.81);
INSERT INTO eindbalansregels VALUES (85, 3, 8030, 'Verkopen Buitenland', 0.00, -1100.00, -1100.00);
INSERT INTO eindbalansregels VALUES (86, 3, 8060, 'Wandschilderingen prive', 0.00, -7529.96, -7529.96);
INSERT INTO eindbalansregels VALUES (87, 3, 8065, 'Schilderijen prive', 0.00, -834.76, -834.76);
INSERT INTO eindbalansregels VALUES (88, 3, 8070, 'Wandschilderingen zakelijk', 0.00, -12066.75, -12066.75);
INSERT INTO eindbalansregels VALUES (89, 3, 8075, 'Schilderijen zakelijk', 0.00, -610.00, -610.00);
INSERT INTO eindbalansregels VALUES (90, 3, 8080, 'Logo en Ontwerp zakelijk', 0.00, -2296.04, -2296.04);
INSERT INTO eindbalansregels VALUES (91, 3, 8110, 'Verkopen Workshops', 0.00, -1388.74, -1388.74);
INSERT INTO eindbalansregels VALUES (92, 3, 8900, 'Diverse opbrengsten', 1.18, -804.19, -803.01);
INSERT INTO eindbalansregels VALUES (93, 4, 200, 'Auto Opel Combo 88-BH-JP', 3500.00, -3500.00, 0.00);
INSERT INTO eindbalansregels VALUES (94, 4, 210, 'Auto Nissan Nv200 5-VKH-50', 7495.00, 0.00, 7495.00);
INSERT INTO eindbalansregels VALUES (95, 4, 250, 'Afschrijving Opel Combo', 3500.00, -3500.00, 0.00);
INSERT INTO eindbalansregels VALUES (96, 4, 260, 'Afschrijving Nissan Nv200', 0.00, -840.10, -840.10);
INSERT INTO eindbalansregels VALUES (97, 4, 900, 'Kapitaal/prive', 0.00, -2768.08, -2768.08);
INSERT INTO eindbalansregels VALUES (98, 4, 1060, 'Rekening courant prive', 34603.00, -30154.60, 4448.40);
INSERT INTO eindbalansregels VALUES (99, 4, 1200, 'Debiteuren', 24256.04, -24256.04, 0.00);
INSERT INTO eindbalansregels VALUES (100, 4, 1600, 'Crediteuren', 22846.08, -22846.08, 0.00);
INSERT INTO eindbalansregels VALUES (101, 4, 2110, 'Af te dragen BTW hoog tarief', 4936.95, -4936.95, 0.00);
INSERT INTO eindbalansregels VALUES (102, 4, 2140, 'Af te dragen BTW verwerving binnen  EU ', 29.61, -29.61, 0.00);
INSERT INTO eindbalansregels VALUES (103, 4, 2150, 'Af te dragen BTW Privegebruik', 497.72, -497.72, 0.00);
INSERT INTO eindbalansregels VALUES (104, 4, 2200, 'Te ontvangen BTW', 2154.05, -2154.05, 0.00);
INSERT INTO eindbalansregels VALUES (105, 4, 2210, 'Te ontvangen BTW autokosten', 2541.31, -2541.31, 0.00);
INSERT INTO eindbalansregels VALUES (106, 4, 2220, 'Te ontvangen BTW partiele materialen', 0.00, 0.00, 0.00);
INSERT INTO eindbalansregels VALUES (107, 4, 2240, 'Te ontvangen BTW verwerving binnen EU', 29.61, -29.61, 0.00);
INSERT INTO eindbalansregels VALUES (108, 4, 2300, 'BTW met de fiscus te verrekenen', 4945.39, -5466.39, -521.00);
INSERT INTO eindbalansregels VALUES (109, 4, 4100, 'Huisvestingskosten', 356.78, 0.00, 356.78);
INSERT INTO eindbalansregels VALUES (110, 4, 4210, 'Klein apparatuur', 473.44, 0.00, 473.44);
INSERT INTO eindbalansregels VALUES (111, 4, 4220, 'Atelierkosten', 1429.45, 0.00, 1429.45);
INSERT INTO eindbalansregels VALUES (112, 4, 4230, 'Kantoorkosten', 891.68, 0.00, 891.68);
INSERT INTO eindbalansregels VALUES (113, 4, 4235, 'Kantinekosten', 75.21, 0.00, 75.21);
INSERT INTO eindbalansregels VALUES (114, 4, 4240, 'Telefoonkosten', 247.02, 0.00, 247.02);
INSERT INTO eindbalansregels VALUES (115, 4, 4245, 'Internetkosten', 264.72, 0.00, 264.72);
INSERT INTO eindbalansregels VALUES (116, 4, 4250, 'Portikosten', 36.34, 0.00, 36.34);
INSERT INTO eindbalansregels VALUES (117, 4, 4270, 'Reiskosten', 15.30, 0.00, 15.30);
INSERT INTO eindbalansregels VALUES (118, 4, 4290, 'Diverse kosten', 44.46, 0.00, 44.46);
INSERT INTO eindbalansregels VALUES (119, 4, 4310, 'Promotiekosten', 414.87, 0.00, 414.87);
INSERT INTO eindbalansregels VALUES (120, 4, 4410, 'Brandstof auto', 2407.72, 0.00, 2407.72);
INSERT INTO eindbalansregels VALUES (121, 4, 4420, 'Verzekering auto', 1040.50, 0.00, 1040.50);
INSERT INTO eindbalansregels VALUES (122, 4, 4430, 'Wegenbelasting auto', 346.00, 0.00, 346.00);
INSERT INTO eindbalansregels VALUES (123, 4, 4440, 'Overige kosten auto', 2410.87, 0.00, 2410.87);
INSERT INTO eindbalansregels VALUES (124, 4, 4450, 'Onderhoud auto', 184.50, 0.00, 184.50);
INSERT INTO eindbalansregels VALUES (125, 4, 4510, 'BTW privé gebruik auto', 497.72, 0.00, 497.72);
INSERT INTO eindbalansregels VALUES (126, 4, 4520, 'Prive bijtelling auto', 0.00, -4608.50, -4608.50);
INSERT INTO eindbalansregels VALUES (127, 4, 4610, 'Afschrijvingen', 352.90, 0.00, 352.90);
INSERT INTO eindbalansregels VALUES (128, 4, 4620, 'Afschrijving Opel', 2121.10, 0.00, 2121.10);
INSERT INTO eindbalansregels VALUES (129, 4, 4630, 'Afschrijving Nissan', 840.10, 0.00, 840.10);
INSERT INTO eindbalansregels VALUES (130, 4, 5010, 'Inkopen', 5855.76, 0.00, 5855.76);
INSERT INTO eindbalansregels VALUES (131, 4, 5015, 'Inkopen binnen EU', 141.02, 0.00, 141.02);
INSERT INTO eindbalansregels VALUES (132, 4, 8030, 'Verkopen Buitenland', 0.00, -540.00, -540.00);
INSERT INTO eindbalansregels VALUES (133, 4, 8060, 'Wandschilderingen prive', 0.00, -4923.94, -4923.94);
INSERT INTO eindbalansregels VALUES (134, 4, 8065, 'Schilderijen prive', 0.00, -347.11, -347.11);
INSERT INTO eindbalansregels VALUES (135, 4, 8070, 'Wandschilderingen zakelijk', 0.00, -13846.86, -13846.86);
INSERT INTO eindbalansregels VALUES (136, 4, 8075, 'Schilderijen zakelijk', 0.00, -896.32, -896.32);
INSERT INTO eindbalansregels VALUES (137, 4, 8080, 'Logo en Ontwerp zakelijk', 0.00, -350.00, -350.00);
INSERT INTO eindbalansregels VALUES (138, 4, 8085, 'Logo en Ontwerp prive', 0.00, -16.53, -16.53);
INSERT INTO eindbalansregels VALUES (139, 4, 8110, 'Verkopen Workshops', 0.00, -1828.35, -1828.35);
INSERT INTO eindbalansregels VALUES (140, 4, 8190, 'Verkopen Overig', 0.00, -1300.00, -1300.00);
INSERT INTO eindbalansregels VALUES (141, 4, 8900, 'Diverse opbrengsten', 2.11, -0.46, 1.65);


--
-- Data for Name: eindcheck; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO eindcheck VALUES (1, '1900-01-01', 2010, 5, 'Zijn de Eindejaars memoriaalposten gemaakt?', 'memoriaal', 0, 3, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO eindcheck VALUES (2, '1900-01-01', 2010, 10, 'Zijn alle BTW periodes geconsolideerd?', 'consolidatie', 0, 3, '');
INSERT INTO eindcheck VALUES (3, '1900-01-01', 2010, 15, 'Backup maken', 'backup', 1, 1, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO eindcheck VALUES (4, '1900-01-01', 2010, 20, 'Controleren grootboeksaldi', 'herstel', 1, 1, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO eindcheck VALUES (5, '1900-01-01', 2010, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 3, '');
INSERT INTO eindcheck VALUES (6, '1900-01-01', 2010, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 3, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO eindcheck VALUES (7, '1900-01-01', 2010, 35, 'Eindbalans consolideren', 'eindbalans', 1, 1, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO eindcheck VALUES (8, '1900-01-01', 2010, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 1, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalpost is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');
INSERT INTO eindcheck VALUES (9, '1900-01-01', 2011, 5, 'Zijn de Eindejaars memoriaalposten gemaakt?', 'memoriaal', 0, 3, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO eindcheck VALUES (10, '1900-01-01', 2011, 10, 'Zijn alle BTW periodes geconsolideerd?', 'consolidatie', 0, 3, '');
INSERT INTO eindcheck VALUES (11, '1900-01-01', 2011, 15, 'Backup maken', 'backup', 1, 1, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO eindcheck VALUES (12, '1900-01-01', 2011, 20, 'Controleren grootboeksaldi', 'herstel', 1, 1, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO eindcheck VALUES (13, '1900-01-01', 2011, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 3, '');
INSERT INTO eindcheck VALUES (14, '1900-01-01', 2011, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 3, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO eindcheck VALUES (15, '1900-01-01', 2011, 35, 'Eindbalans consolideren', 'eindbalans', 1, 1, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO eindcheck VALUES (16, '1900-01-01', 2011, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 1, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalpost is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');
INSERT INTO eindcheck VALUES (17, '1900-01-01', 2012, 5, 'Zijn de Eindejaars memoriaalposten gemaakt?', 'memoriaal', 0, 3, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO eindcheck VALUES (18, '1900-01-01', 2012, 10, 'Zijn alle BTW periodes geconsolideerd?', 'consolidatie', 0, 3, '');
INSERT INTO eindcheck VALUES (19, '1900-01-01', 2012, 15, 'Backup maken', 'backup', 1, 1, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO eindcheck VALUES (20, '1900-01-01', 2012, 20, 'Controleren grootboeksaldi', 'herstel', 1, 1, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO eindcheck VALUES (21, '1900-01-01', 2012, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 3, '');
INSERT INTO eindcheck VALUES (22, '1900-01-01', 2012, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 3, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO eindcheck VALUES (23, '1900-01-01', 2012, 35, 'Eindbalans consolideren', 'eindbalans', 1, 1, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO eindcheck VALUES (24, '1900-01-01', 2012, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 1, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalpost is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');
INSERT INTO eindcheck VALUES (33, '1900-01-01', 2014, 5, 'Zijn de Eindejaars memoriaalposten gemaakt?', 'memoriaal', 0, 2, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO eindcheck VALUES (34, '1900-01-01', 2014, 10, 'Zijn alle BTW periodes geconsolideerd?', 'consolidatie', 0, 2, '');
INSERT INTO eindcheck VALUES (35, '1900-01-01', 2014, 15, 'Backup maken', 'backup', 1, 0, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO eindcheck VALUES (36, '1900-01-01', 2014, 20, 'Controleren grootboeksaldi', 'herstel', 1, 0, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO eindcheck VALUES (37, '1900-01-01', 2014, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 2, '');
INSERT INTO eindcheck VALUES (38, '1900-01-01', 2014, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 2, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO eindcheck VALUES (39, '1900-01-01', 2014, 35, 'Eindbalans consolideren', 'eindbalans', 1, 0, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO eindcheck VALUES (40, '1900-01-01', 2014, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 0, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalpost is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');
INSERT INTO eindcheck VALUES (25, '1900-01-01', 2013, 5, 'Zijn de Eindejaars memoriaalposten gemaakt?', 'memoriaal', 0, 3, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO eindcheck VALUES (26, '1900-01-01', 2013, 10, 'Zijn alle BTW periodes geconsolideerd?', 'consolidatie', 0, 3, '');
INSERT INTO eindcheck VALUES (27, '1900-01-01', 2013, 15, 'Backup maken', 'backup', 1, 1, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO eindcheck VALUES (28, '1900-01-01', 2013, 20, 'Controleren grootboeksaldi', 'herstel', 1, 1, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO eindcheck VALUES (29, '1900-01-01', 2013, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 3, '');
INSERT INTO eindcheck VALUES (30, '1900-01-01', 2013, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 3, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO eindcheck VALUES (31, '1900-01-01', 2013, 35, 'Eindbalans consolideren', 'eindbalans', 1, 1, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO eindcheck VALUES (32, '1900-01-01', 2013, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 1, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalpost is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');


--
-- Data for Name: grootboeksaldi; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO grootboeksaldi VALUES (1, 1200, 2010, 0.00);
INSERT INTO grootboeksaldi VALUES (2, 8010, 2010, -165.00);
INSERT INTO grootboeksaldi VALUES (3, 2110, 2010, 0.00);
INSERT INTO grootboeksaldi VALUES (4, 8120, 2010, -1000.00);
INSERT INTO grootboeksaldi VALUES (13, 1600, 2010, 0.00);
INSERT INTO grootboeksaldi VALUES (14, 4600, 2010, 439.74);
INSERT INTO grootboeksaldi VALUES (15, 2200, 2010, 0.00);
INSERT INTO grootboeksaldi VALUES (16, 4500, 2010, 173.11);
INSERT INTO grootboeksaldi VALUES (17, 4490, 2010, 34.04);
INSERT INTO grootboeksaldi VALUES (19, 4230, 2010, 29.40);
INSERT INTO grootboeksaldi VALUES (20, 4240, 2010, 46.22);
INSERT INTO grootboeksaldi VALUES (22, 4220, 2010, 62.70);
INSERT INTO grootboeksaldi VALUES (26, 1200, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (27, 8010, 2011, -11015.16);
INSERT INTO grootboeksaldi VALUES (28, 2110, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (29, 8120, 2011, -1515.00);
INSERT INTO grootboeksaldi VALUES (30, 8020, 2011, -122.65);
INSERT INTO grootboeksaldi VALUES (31, 2120, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (32, 4710, 2011, 1816.82);
INSERT INTO grootboeksaldi VALUES (34, 4730, 2011, 322.00);
INSERT INTO grootboeksaldi VALUES (35, 4740, 2011, 4208.70);
INSERT INTO grootboeksaldi VALUES (37, 2210, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (38, 1600, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (39, 4600, 2011, 7492.87);
INSERT INTO grootboeksaldi VALUES (40, 2200, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (43, 200, 2011, 3500.00);
INSERT INTO grootboeksaldi VALUES (44, 4230, 2011, 435.06);
INSERT INTO grootboeksaldi VALUES (45, 4240, 2011, 155.07);
INSERT INTO grootboeksaldi VALUES (46, 4210, 2011, 1530.27);
INSERT INTO grootboeksaldi VALUES (47, 4220, 2011, 1914.32);
INSERT INTO grootboeksaldi VALUES (48, 4400, 2011, 14.80);
INSERT INTO grootboeksaldi VALUES (49, 4250, 2011, 48.42);
INSERT INTO grootboeksaldi VALUES (50, 4235, 2011, 131.29);
INSERT INTO grootboeksaldi VALUES (51, 2300, 2010, 112.00);
INSERT INTO grootboeksaldi VALUES (52, 8900, 2010, -0.64);
INSERT INTO grootboeksaldi VALUES (53, 1060, 2010, 125.55);
INSERT INTO grootboeksaldi VALUES (54, 4400, 2010, 142.88);
INSERT INTO grootboeksaldi VALUES (56, 4610, 2011, 2567.00);
INSERT INTO grootboeksaldi VALUES (57, 4720, 2011, 986.26);
INSERT INTO grootboeksaldi VALUES (58, 4500, 2011, 527.59);
INSERT INTO grootboeksaldi VALUES (59, 1060, 2011, -2904.26);
INSERT INTO grootboeksaldi VALUES (60, 4490, 2011, 354.97);
INSERT INTO grootboeksaldi VALUES (61, 8140, 2011, -8856.57);
INSERT INTO grootboeksaldi VALUES (62, 4620, 2011, 73.80);
INSERT INTO grootboeksaldi VALUES (63, 2300, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (64, 8900, 2011, -60.84);
INSERT INTO grootboeksaldi VALUES (65, 4100, 2011, 2000.00);
INSERT INTO grootboeksaldi VALUES (66, 2220, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (67, 8030, 2011, -625.00);
INSERT INTO grootboeksaldi VALUES (68, 4245, 2011, 150.08);
INSERT INTO grootboeksaldi VALUES (69, 2150, 2011, 0.00);
INSERT INTO grootboeksaldi VALUES (70, 900, 2011, -112.00);
INSERT INTO grootboeksaldi VALUES (71, 4780, 2011, -3006.25);
INSERT INTO grootboeksaldi VALUES (72, 200, 2012, 3500.00);
INSERT INTO grootboeksaldi VALUES (73, 900, 2012, -3500.00);
INSERT INTO grootboeksaldi VALUES (80, 4490, 2013, 333.38);
INSERT INTO grootboeksaldi VALUES (83, 4100, 2013, 356.78);
INSERT INTO grootboeksaldi VALUES (90, 8030, 2013, -540.00);
INSERT INTO grootboeksaldi VALUES (96, 2220, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (101, 4210, 2013, 473.44);
INSERT INTO grootboeksaldi VALUES (103, 4235, 2013, 75.21);
INSERT INTO grootboeksaldi VALUES (104, 210, 2013, 7495.00);
INSERT INTO grootboeksaldi VALUES (106, 8080, 2013, -350.00);
INSERT INTO grootboeksaldi VALUES (114, 4400, 2013, 60.90);
INSERT INTO grootboeksaldi VALUES (120, 4245, 2012, 272.72);
INSERT INTO grootboeksaldi VALUES (126, 4210, 2012, 394.11);
INSERT INTO grootboeksaldi VALUES (138, 4250, 2012, 62.05);
INSERT INTO grootboeksaldi VALUES (125, 4310, 2012, 276.10);
INSERT INTO grootboeksaldi VALUES (142, 8075, 2012, -610.00);
INSERT INTO grootboeksaldi VALUES (145, 4620, 2012, 1378.90);
INSERT INTO grootboeksaldi VALUES (136, 4410, 2012, 2361.97);
INSERT INTO grootboeksaldi VALUES (127, 4420, 2012, 421.47);
INSERT INTO grootboeksaldi VALUES (128, 4430, 2012, 284.00);
INSERT INTO grootboeksaldi VALUES (134, 4270, 2012, 187.05);
INSERT INTO grootboeksaldi VALUES (121, 4240, 2012, 262.71);
INSERT INTO grootboeksaldi VALUES (139, 8110, 2012, -1388.74);
INSERT INTO grootboeksaldi VALUES (133, 4230, 2012, 311.80);
INSERT INTO grootboeksaldi VALUES (144, 2150, 2012, 0.00);
INSERT INTO grootboeksaldi VALUES (122, 5010, 2012, 6350.81);
INSERT INTO grootboeksaldi VALUES (123, 4220, 2012, 2057.20);
INSERT INTO grootboeksaldi VALUES (135, 4440, 2012, 163.12);
INSERT INTO grootboeksaldi VALUES (130, 4450, 2012, 1535.98);
INSERT INTO grootboeksaldi VALUES (137, 4235, 2012, 9.77);
INSERT INTO grootboeksaldi VALUES (124, 4290, 2012, 397.09);
INSERT INTO grootboeksaldi VALUES (132, 8065, 2012, -834.76);
INSERT INTO grootboeksaldi VALUES (129, 8060, 2012, -7529.96);
INSERT INTO grootboeksaldi VALUES (132, 8070, 2012, -12066.75);
INSERT INTO grootboeksaldi VALUES (140, 8030, 2012, -1100.00);
INSERT INTO grootboeksaldi VALUES (141, 8080, 2012, -2296.04);
INSERT INTO grootboeksaldi VALUES (146, 250, 2012, -1378.90);
INSERT INTO grootboeksaldi VALUES (143, 4520, 2012, -4472.50);
INSERT INTO grootboeksaldi VALUES (116, 2110, 2012, 0.00);
INSERT INTO grootboeksaldi VALUES (149, 4510, 2012, 268.35);
INSERT INTO grootboeksaldi VALUES (131, 2210, 2012, 0.00);
INSERT INTO grootboeksaldi VALUES (118, 4100, 2012, 4467.92);
INSERT INTO grootboeksaldi VALUES (117, 1600, 2012, 0.00);
INSERT INTO grootboeksaldi VALUES (115, 1060, 2012, 10370.56);
INSERT INTO grootboeksaldi VALUES (119, 2200, 2012, 0.00);
INSERT INTO grootboeksaldi VALUES (147, 2300, 2012, 227.00);
INSERT INTO grootboeksaldi VALUES (148, 8900, 2012, -803.01);
INSERT INTO grootboeksaldi VALUES (132, 1200, 2012, 419.98);
INSERT INTO grootboeksaldi VALUES (152, 4290, 2013, 44.46);
INSERT INTO grootboeksaldi VALUES (94, 4250, 2013, 36.34);
INSERT INTO grootboeksaldi VALUES (77, 4310, 2013, 414.87);
INSERT INTO grootboeksaldi VALUES (153, 5015, 2013, 141.02);
INSERT INTO grootboeksaldi VALUES (92, 4410, 2013, 2407.72);
INSERT INTO grootboeksaldi VALUES (113, 8190, 2013, -1300.00);
INSERT INTO grootboeksaldi VALUES (91, 8110, 2013, -1828.35);
INSERT INTO grootboeksaldi VALUES (163, 4620, 2013, 2121.10);
INSERT INTO grootboeksaldi VALUES (155, 2140, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (164, 4430, 2013, 346.00);
INSERT INTO grootboeksaldi VALUES (165, 260, 2013, -840.10);
INSERT INTO grootboeksaldi VALUES (154, 2240, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (107, 8075, 2013, -896.32);
INSERT INTO grootboeksaldi VALUES (162, 2150, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (74, 1600, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (157, 4450, 2013, 184.50);
INSERT INTO grootboeksaldi VALUES (110, 8065, 2013, -347.11);
INSERT INTO grootboeksaldi VALUES (76, 2200, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (84, 4230, 2013, 891.68);
INSERT INTO grootboeksaldi VALUES (79, 4220, 2013, 1429.45);
INSERT INTO grootboeksaldi VALUES (105, 8070, 2013, -13846.86);
INSERT INTO grootboeksaldi VALUES (108, 8060, 2013, -4923.94);
INSERT INTO grootboeksaldi VALUES (158, 4270, 2013, 15.30);
INSERT INTO grootboeksaldi VALUES (156, 4245, 2013, 264.72);
INSERT INTO grootboeksaldi VALUES (78, 4240, 2013, 247.02);
INSERT INTO grootboeksaldi VALUES (93, 2210, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (159, 8085, 2013, -16.53);
INSERT INTO grootboeksaldi VALUES (161, 4510, 2013, 497.72);
INSERT INTO grootboeksaldi VALUES (160, 4520, 2013, -4608.50);
INSERT INTO grootboeksaldi VALUES (151, 900, 2013, -2768.08);
INSERT INTO grootboeksaldi VALUES (98, 2300, 2013, -521.00);
INSERT INTO grootboeksaldi VALUES (88, 2110, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (99, 8900, 2013, 1.65);
INSERT INTO grootboeksaldi VALUES (150, 250, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (109, 200, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (82, 4630, 2013, 840.10);
INSERT INTO grootboeksaldi VALUES (86, 1200, 2013, 0.00);
INSERT INTO grootboeksaldi VALUES (81, 4420, 2013, 1040.50);
INSERT INTO grootboeksaldi VALUES (85, 1060, 2013, 4448.40);
INSERT INTO grootboeksaldi VALUES (75, 5010, 2013, 5855.76);
INSERT INTO grootboeksaldi VALUES (95, 4440, 2013, 2410.87);
INSERT INTO grootboeksaldi VALUES (102, 4610, 2013, 352.90);
INSERT INTO grootboeksaldi VALUES (166, 1600, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (177, 2210, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (181, 8070, 2014, -3942.89);
INSERT INTO grootboeksaldi VALUES (174, 4430, 2014, 316.00);
INSERT INTO grootboeksaldi VALUES (169, 4245, 2014, 352.08);
INSERT INTO grootboeksaldi VALUES (179, 4230, 2014, 174.94);
INSERT INTO grootboeksaldi VALUES (167, 4220, 2014, 654.72);
INSERT INTO grootboeksaldi VALUES (173, 4210, 2014, 636.70);
INSERT INTO grootboeksaldi VALUES (176, 4410, 2014, 2988.82);
INSERT INTO grootboeksaldi VALUES (175, 4310, 2014, 1667.24);
INSERT INTO grootboeksaldi VALUES (172, 5010, 2014, 2261.45);
INSERT INTO grootboeksaldi VALUES (178, 4290, 2014, 183.84);
INSERT INTO grootboeksaldi VALUES (168, 2200, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (171, 4240, 2014, 345.85);
INSERT INTO grootboeksaldi VALUES (191, 8065, 2014, -338.84);
INSERT INTO grootboeksaldi VALUES (192, 4250, 2014, 7.95);
INSERT INTO grootboeksaldi VALUES (187, 4440, 2014, 9.07);
INSERT INTO grootboeksaldi VALUES (186, 4450, 2014, 967.58);
INSERT INTO grootboeksaldi VALUES (188, 4270, 2014, 122.18);
INSERT INTO grootboeksaldi VALUES (183, 8060, 2014, -2966.95);
INSERT INTO grootboeksaldi VALUES (193, 4510, 2014, 511.00);
INSERT INTO grootboeksaldi VALUES (182, 2110, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (194, 2150, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (185, 8900, 2014, -523.07);
INSERT INTO grootboeksaldi VALUES (195, 210, 2014, 7495.00);
INSERT INTO grootboeksaldi VALUES (197, 900, 2014, -6133.90);
INSERT INTO grootboeksaldi VALUES (184, 2300, 2014, -73.00);
INSERT INTO grootboeksaldi VALUES (190, 8075, 2014, -500.00);
INSERT INTO grootboeksaldi VALUES (199, 4630, 2014, 1499.00);
INSERT INTO grootboeksaldi VALUES (196, 260, 2014, -2339.10);
INSERT INTO grootboeksaldi VALUES (180, 1200, 2014, 0.00);
INSERT INTO grootboeksaldi VALUES (189, 4420, 2014, 249.04);
INSERT INTO grootboeksaldi VALUES (170, 1060, 2014, -3624.71);


--
-- Data for Name: grootboekstam; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO grootboekstam VALUES (102, 2012, 1, 4270, NULL, 3, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (153, 2013, 1, 5030, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', '', '');
INSERT INTO grootboekstam VALUES (1, 2010, 1, 100, NULL, 0, 1, 0, 0, 'Inventaris', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (2, 2010, 1, 150, NULL, 0, 1, 0, 0, 'Afschrijving inventaris', '', '');
INSERT INTO grootboekstam VALUES (98, 2012, 1, 4260, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (99, 2012, 0, 4350, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (101, 2012, 0, 4490, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (103, 2012, 0, 4400, NULL, 0, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (105, 2012, 0, 4300, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (114, 2012, 1, 4299, NULL, 0, 3, 2, 0, 'Sub algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (136, 2012, 1, 4199, NULL, 0, 3, 2, 0, 'Totaal Huisvestingskosten', '', '');
INSERT INTO grootboekstam VALUES (134, 2012, 1, 4395, NULL, 0, 3, 2, 0, 'Totaal Promotiekosten', '', '');
INSERT INTO grootboekstam VALUES (106, 2012, 1, 4399, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (138, 2012, 0, 4710, NULL, 0, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (69, 2010, 1, 2210, NULL, 0, 1, 0, 0, 'Te ontvangen BTW autokosten', 'rkg_btwautokosten', '');
INSERT INTO grootboekstam VALUES (5, 2010, 1, 300, NULL, 0, 1, 0, 0, 'Software', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (6, 2010, 1, 350, NULL, 0, 1, 0, 0, 'Afschrijving software', '', '');
INSERT INTO grootboekstam VALUES (7, 2010, 1, 500, NULL, 0, 1, 0, 0, 'Leningen', '', '');
INSERT INTO grootboekstam VALUES (10, 2010, 1, 1050, NULL, 0, 1, 0, 0, 'Amrobank', '', '');
INSERT INTO grootboekstam VALUES (12, 2010, 1, 1100, NULL, 0, 1, 0, 0, 'Nog te ontvangen', '', '');
INSERT INTO grootboekstam VALUES (14, 2010, 1, 1500, NULL, 0, 1, 0, 0, 'Nog te betalen', '', '');
INSERT INTO grootboekstam VALUES (16, 2010, 1, 1999, NULL, 0, 3, 3, 0, 'Totaal activa/passiva', '', '');
INSERT INTO grootboekstam VALUES (17, 2010, 1, 2010, NULL, 0, 1, 0, 0, 'Kruisposten', '', '');
INSERT INTO grootboekstam VALUES (18, 2010, 1, 2020, NULL, 0, 1, 0, 0, 'Betalingen onderweg', '', '');
INSERT INTO grootboekstam VALUES (19, 2010, 1, 2099, NULL, 0, 3, 1, 0, 'Totaal hulprekeningen', '', '');
INSERT INTO grootboekstam VALUES (20, 2010, 1, 2110, NULL, 0, 1, 0, 0, 'Af te dragen BTW hoog tarief', 'rkg_btwverkoophoog', '');
INSERT INTO grootboekstam VALUES (21, 2010, 1, 2120, NULL, 0, 1, 0, 0, 'Af te dragen BTW laag tarief', 'rkg_btwverkooplaag', '');
INSERT INTO grootboekstam VALUES (24, 2010, 1, 2399, NULL, 0, 3, 1, 0, 'Totaal periodieke BTW', '', '');
INSERT INTO grootboekstam VALUES (25, 2010, 1, 2500, NULL, 0, 1, 0, 0, 'Verschillenrekening', '', '');
INSERT INTO grootboekstam VALUES (26, 2010, 1, 2899, NULL, 0, 3, 3, 0, 'Totaal tussenrekeningen', '', '');
INSERT INTO grootboekstam VALUES (28, 2010, 1, 3999, NULL, 0, 3, 7, 0, 'Totaal balans', '', '');
INSERT INTO grootboekstam VALUES (29, 2010, 1, 4010, NULL, 0, 2, 0, 0, 'Personeelskosten', '', '');
INSERT INTO grootboekstam VALUES (30, 2010, 1, 4020, NULL, 0, 2, 0, 0, 'Uitbesteed werk', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (32, 2010, 1, 4200, NULL, 0, 2, 0, 0, 'Documentatiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (40, 2010, 1, 4300, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (41, 2010, 1, 4350, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (42, 2010, 1, 4400, NULL, 0, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (43, 2010, 1, 4490, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (44, 2010, 1, 4499, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (49, 2010, 1, 4699, NULL, 0, 3, 3, 0, 'Totaal specifieke kosten', '', '');
INSERT INTO grootboekstam VALUES (50, 2010, 1, 4900, NULL, 0, 2, 0, 0, 'Voordelig/nadelig saldo', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (51, 2010, 1, 4999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (52, 2010, 1, 8010, NULL, 0, 2, 0, 0, 'Verkopen Atelier', '', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (53, 2010, 1, 8199, NULL, 0, 3, 3, 0, 'Totaal verkopen', '', '');
INSERT INTO grootboekstam VALUES (54, 2010, 1, 8410, NULL, 0, 2, 0, 0, 'Rente opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (56, 2010, 1, 8980, NULL, 0, 3, 3, 0, 'Totaal diverse opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (57, 2010, 1, 8985, NULL, 0, 3, 5, 0, 'Totaal opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (58, 2010, 1, 8990, NULL, 0, 3, 7, 0, 'Totaal verlies en winst', '', '');
INSERT INTO grootboekstam VALUES (59, 2010, 1, 8999, NULL, 0, 3, 8, 0, 'Totaal administratie', '', '');
INSERT INTO grootboekstam VALUES (60, 2010, 1, 8120, NULL, 0, 2, 0, 0, 'Verkopen Workshops 0% BTW', 'verkopen_geenbtw', 'verkopen_geenbtw');
INSERT INTO grootboekstam VALUES (61, 2010, 1, 4099, NULL, 0, 3, 3, 0, 'Totaal personeelskosten', '', '');
INSERT INTO grootboekstam VALUES (63, 2010, 1, 8020, NULL, 0, 2, 0, 0, 'Verkopen Kunst laag', '', 'rkg_btwverkooplaag');
INSERT INTO grootboekstam VALUES (68, 2010, 1, 4799, NULL, 0, 3, 3, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (72, 2010, 1, 8140, NULL, 0, 2, 0, 0, 'Verkopen kunst partiele materialen', 'verkopen_partbtwmateriaal', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (74, 2010, 1, 2220, NULL, 0, 1, 0, 0, 'Te ontvangen BTW partiele materialen', 'rkg_btwpartmateriaal', '');
INSERT INTO grootboekstam VALUES (76, 2011, 1, 4780, NULL, 0, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (79, 2011, 1, 4599, NULL, 0, 3, 3, 0, 'Totaal Promotiekosten', '', '');
INSERT INTO grootboekstam VALUES (80, 2011, 1, 4699, NULL, 0, 3, 3, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (81, 2011, 1, 4199, NULL, 0, 3, 3, 0, 'Totaal Huisvestingskosten', '', '');
INSERT INTO grootboekstam VALUES (83, 2012, 1, 8010, NULL, 0, 2, 0, 0, 'Verkopen Atelier', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (84, 2012, 1, 8020, NULL, 0, 2, 0, 0, 'Verkopen Kunst laag', 'verkopen_laag', 'rkg_btwverkooplaag');
INSERT INTO grootboekstam VALUES (87, 2013, 1, 210, NULL, 0, 1, 0, 0, 'Auto Nissan Nv200 5-VKH-50', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (65, 2010, 1, 4720, NULL, 0, 2, 0, 0, 'Verzekering auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (66, 2010, 1, 4730, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (36, 2010, 1, 4235, NULL, 0, 2, 0, 0, 'Kantinekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (64, 2010, 1, 4710, NULL, 0, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (8, 2010, 1, 900, NULL, 0, 1, 0, 0, 'Kapitaal/prive', '', '');
INSERT INTO grootboekstam VALUES (3, 2010, 1, 200, NULL, 0, 1, 0, 0, 'Auto Opel Combo 88-BH-JP', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (104, 2012, 1, 4610, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (108, 2012, 1, 4620, NULL, 0, 2, 0, 0, 'Afschrijving Opel', '', '');
INSERT INTO grootboekstam VALUES (82, 2011, 1, 250, NULL, 0, 1, 0, 0, 'Afschrijving Opel Combo', '', '');
INSERT INTO grootboekstam VALUES (33, 2010, 1, 4210, NULL, 0, 2, 0, 0, 'Klein apparatuur', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (38, 2010, 1, 4245, NULL, 0, 2, 0, 0, 'Internetkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (37, 2010, 1, 4240, NULL, 0, 2, 0, 0, 'Telefoonkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (73, 2010, 1, 4620, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (45, 2010, 1, 4500, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (48, 2010, 1, 4600, NULL, 0, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (67, 2010, 1, 4740, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (75, 2011, 1, 8030, NULL, 0, 2, 0, 0, 'Verkopen Buitenland', 'verkopen_binneneu', '');
INSERT INTO grootboekstam VALUES (91, 2012, 1, 8080, NULL, 0, 2, 0, 0, 'Logo en Ontwerp zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (27, 2010, 1, 3010, NULL, 0, 1, 0, 0, 'Voorraad', '', '');
INSERT INTO grootboekstam VALUES (46, 2010, 1, 4510, NULL, 1, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (77, 2011, 1, 2150, NULL, 1, 1, 0, 0, 'Af te dragen BTW Privegebruik', 'rkg_btwprivegebruik', '');
INSERT INTO grootboekstam VALUES (47, 2010, 1, 4520, NULL, 1, 2, 0, 0, 'Productiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (109, 2013, 1, 4630, NULL, 1, 2, 0, 0, 'Afschrijving Nissan', '', '');
INSERT INTO grootboekstam VALUES (88, 2013, 1, 260, NULL, 1, 1, 0, 0, 'Afschrijving Nissan Nv200', '', '');
INSERT INTO grootboekstam VALUES (15, 2010, 1, 1600, NULL, 1, 1, 0, 0, 'Crediteuren', '', '');
INSERT INTO grootboekstam VALUES (55, 2010, 1, 8900, NULL, 0, 2, 0, 0, 'Diverse opbrengsten', 'rkg_5dregeling', '');
INSERT INTO grootboekstam VALUES (140, 2012, 0, 4730, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (142, 2012, 0, 4740, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (143, 2012, 0, 4720, NULL, 0, 2, 0, 0, 'Verzekering auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (31, 2010, 1, 4100, NULL, 0, 2, 0, 0, 'Huisvestingskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (113, 2012, 0, 4780, NULL, 0, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (117, 2012, 0, 4600, NULL, 0, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (118, 2012, 1, 5020, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (120, 2012, 1, 5030, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (122, 2012, 1, 5050, NULL, 0, 2, 0, 0, 'Kosten uitbesteed werk e.a. externe kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (124, 2012, 0, 4699, NULL, 0, 3, 3, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (125, 2012, 0, 4020, NULL, 0, 2, 0, 0, 'Uitbesteed werk', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (144, 2012, 0, 4499, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (135, 2012, 1, 4599, NULL, 0, 3, 4, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (126, 2012, 1, 5999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (130, 2012, 0, 4500, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (131, 2012, 1, 4320, NULL, 0, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (128, 2012, 1, 4499, NULL, 0, 3, 2, 0, 'Netto autokosten', '', '');
INSERT INTO grootboekstam VALUES (146, 2012, 0, 4799, NULL, 0, 2, 0, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (145, 2012, 1, 4595, NULL, 0, 3, 3, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (107, 2012, 1, 4699, NULL, 0, 3, 4, 0, 'Totaal Afschrijvingen', '', '');
INSERT INTO grootboekstam VALUES (147, 2012, 0, 4999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (123, 2012, 1, 5099, NULL, 0, 3, 4, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (23, 2010, 1, 2300, NULL, 0, 1, 0, 0, 'BTW met de fiscus te verrekenen', 'rkg_betaaldebtw', '');
INSERT INTO grootboekstam VALUES (149, 2013, 1, 4260, NULL, 0, 2, 0, 0, 'Bankkosten', '', '');
INSERT INTO grootboekstam VALUES (150, 2013, 1, 4235, NULL, 0, 2, 0, 0, 'Kantinekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (94, 2012, 1, 8190, NULL, 0, 2, 0, 0, 'Verkopen Overig', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (152, 2013, 1, 2140, NULL, 0, 1, 0, 0, 'Af te dragen BTW verwerving binnen  EU ', 'rkg_btwinkopeneubet', '');
INSERT INTO grootboekstam VALUES (154, 2013, 1, 2240, NULL, 0, 1, 0, 0, 'Te ontvangen BTW verwerving binnen EU', 'rkg_btwinkopeneuontv', '');
INSERT INTO grootboekstam VALUES (151, 2013, 1, 5015, NULL, 0, 2, 0, 0, 'Inkopen binnen EU', 'inkopen_binneneu', 'rkg_btwinkopeneuontv');
INSERT INTO grootboekstam VALUES (62, 2010, 1, 8110, NULL, 0, 2, 0, 0, 'Verkopen Workshops', '', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (85, 2012, 1, 8110, NULL, 0, 2, 0, 0, 'Verkopen Workshops', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (155, 2013, 1, 8085, NULL, 0, 2, 0, 0, 'Logo en Ontwerp prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (97, 2013, 1, 5060, NULL, 0, 2, 0, 0, 'Inkoopkosten overig', '', '');
INSERT INTO grootboekstam VALUES (22, 2010, 1, 2200, NULL, 0, 1, 0, 0, 'Te ontvangen BTW', 'rkg_btwinkopen', '');
INSERT INTO grootboekstam VALUES (71, 2010, 1, 4610, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', 'rkg_btwpartmateriaal');
INSERT INTO grootboekstam VALUES (119, 2012, 0, 4610, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (96, 2013, 1, 200, NULL, 0, 1, 0, 0, 'Auto Opel Combo 88-BH-JP', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (121, 2012, 0, 4620, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (92, 2012, 1, 8065, NULL, 0, 2, 0, 0, 'Schilderijen prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (90, 2012, 1, 8070, NULL, 0, 2, 0, 0, 'Wandschilderingen zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (100, 2012, 1, 4290, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (129, 2012, 1, 4310, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (110, 2012, 1, 4420, NULL, 0, 2, 0, 0, 'Verzekering auto', '', '');
INSERT INTO grootboekstam VALUES (141, 2012, 1, 4440, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (39, 2010, 1, 4250, NULL, 0, 2, 0, 0, 'Portikosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (139, 2012, 1, 4430, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (93, 2012, 1, 8075, NULL, 0, 2, 0, 0, 'Schilderijen zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (148, 2013, 1, 4250, NULL, 0, 2, 0, 0, 'Portikosten', '', '');
INSERT INTO grootboekstam VALUES (13, 2010, 1, 1200, NULL, 1, 1, 0, 0, 'Debiteuren', '', '');
INSERT INTO grootboekstam VALUES (11, 2010, 1, 1060, NULL, 3, 1, 0, 0, 'Rekening courant prive', '', '');
INSERT INTO grootboekstam VALUES (111, 2012, 1, 4450, NULL, 1, 2, 0, 0, 'Onderhoud auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (34, 2010, 1, 4220, NULL, 5, 2, 0, 0, 'Atelierkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (89, 2012, 1, 8060, NULL, 3, 2, 0, 0, 'Wandschilderingen prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (137, 2012, 1, 4410, NULL, 16, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (35, 2010, 1, 4230, NULL, 5, 2, 0, 0, 'Kantoorkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (112, 2012, 1, 4520, NULL, 1, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (116, 2012, 1, 5010, NULL, 2, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (115, 2012, 1, 4510, NULL, 1, 2, 0, 0, 'BTW privé gebruik auto', '', '');
INSERT INTO grootboekstam VALUES (132, 2012, 0, 4510, NULL, 1, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (156, 2013, 1, 4510, NULL, 1, 2, 0, 0, 'BTW privé gebruik auto', '', '');
INSERT INTO grootboekstam VALUES (133, 2012, 0, 4520, NULL, 1, 2, 0, 0, 'Productiekosten', '', 'rkg_btwinkopen');


--
-- Data for Name: inkoopfacturen; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO inkoopfacturen VALUES (1, 7, 2011, '2010-11-26', 'Spuitmateriaal', 145.55, 'kramer', 1, '52229', 145.55, '2010-12-31');
INSERT INTO inkoopfacturen VALUES (2, 8, 2011, '2010-12-07', 'Advertenties', 206.00, 'marktplaats', 2, '101100531', 206.00, '2010-12-31');
INSERT INTO inkoopfacturen VALUES (3, 9, 2011, '2010-12-09', 'Spuitmateriaal', 166.30, 'kramer', 1, '52316', 166.30, '2010-12-31');
INSERT INTO inkoopfacturen VALUES (4, 10, 2011, '2010-12-20', 'Kosten inschrijving', 34.04, 'kvk', 3, '241242644', 34.04, '2010-12-20');
INSERT INTO inkoopfacturen VALUES (5, 11, 2011, '2011-01-11', 'Aanschaf Opel Combo 88BHJP', 4165.00, 'kleyn', 4, '10212291', 4165.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (6, 12, 2011, '2011-01-14', 'Software upgrade', 49.00, 'ifactors', 5, '103036674', 49.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (7, 13, 2011, '2011-01-12', 'Autoradio', 122.00, 'wehkamp', 9, '12jan', 122.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (8, 14, 2011, '2011-01-19', 'Spuitmateriaal', 213.75, 'kramer', 1, '52502', 213.75, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (9, 15, 2011, '2011-01-19', 'Telefoonkosten', 79.83, 'tmobile', 10, '901128749052', 79.83, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (10, 16, 2011, '2011-01-24', 'Wegenbelasting 11jan-7mrt', 42.00, 'belasting', 11, '69414993M1', 42.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (11, 17, 2011, '2011-01-26', 'Banden', 97.58, 'hofman', 12, '2011031', 97.58, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (12, 18, 2011, '2011-01-27', 'Multimedia materiaal', 239.55, 'mediamarkt', 6, '40358967', 239.55, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (13, 30, 2011, '2011-01-31', 'Verzekering Opel Combi - kwartaal 1', 240.94, 'vandien', 7, '13678135', 240.94, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (14, 31, 2011, '2011-03-01', 'Retour premie kwartaal 1', -68.75, 'vandien', 7, '13767248', -68.75, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (15, 32, 2011, '2011-01-31', 'Kwartaal 1 dubbel gefactureerd', 172.19, 'vandien', 7, '13678135', 172.19, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (16, 33, 2011, '2011-02-21', 'Telefoon 16-2/15-3', 34.90, 'tmobile', 10, '901130920143', 34.90, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (17, 34, 2011, '2011-02-22', 'Noppenfolie', 54.15, 'vendrig', 8, '18320', 54.15, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (18, 35, 2011, '2011-02-28', 'Poetsmateriaal', 21.94, 'polijst', 19, '100000079', 21.94, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (19, 36, 2011, '2011-02-28', '18 Glazen objecten Woonpartners', 7810.84, 'vandijken', 18, '51144', 7810.84, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (20, 37, 2011, '2011-03-01', 'Printerinkt', 85.45, '123inkt', 17, '1816393', 85.45, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (21, 38, 2011, '2011-03-01', 'Epson printer Stylus PX820FWD', 242.76, 'inmac', 16, '1099635-0100', 242.76, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (22, 39, 2011, '2011-04-11', '2e kwartaal verzekering', 167.13, 'vandien', 7, '13773165', 167.13, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (23, 40, 2011, '2011-03-07', 'Wegenbelasting 8mrt-7jun', 70.00, 'belasting', 11, '69414993M12', 70.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (24, 41, 2011, '2011-03-09', 'Verf', 57.87, 'nicolaas', 15, '748927', 57.87, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (25, 42, 2011, '2011-03-09', 'Verf', 16.79, 'nicolaas', 15, '748929', 16.79, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (26, 43, 2011, '2011-03-11', 'Materiaal workshops', 85.25, 'moonen', 14, '2110520', 85.25, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (27, 44, 2011, '2011-03-21', 'Telefoon 16-3/15-4', 34.90, 'tmobile', 10, '901133104685', 34.90, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (28, 45, 2011, '2011-03-28', 'Materialen', 461.95, 'kramer', 1, '52876', 461.95, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (29, 46, 2011, '2011-03-29', 'Reparatie Opel', 72.59, 'hofman', 12, '2011105', 72.59, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (30, 47, 2011, '2011-03-29', 'Reparatie Opel', 144.53, 'hofman', 12, '2011108', 144.53, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (31, 48, 2011, '2011-03-31', 'Boeket relatie', 35.50, 'rip', 13, '1100107', 35.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (32, 53, 2011, '2011-02-01', 'Latex verf', 47.01, 'claasen', 20, '698769', 47.01, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (33, 54, 2011, '2011-02-04', 'Bijdrage KvK 2011', 46.52, 'kvk', 3, '151488299', 46.52, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (34, 55, 2011, '2011-02-18', 'Kraamhuur Braderie Dorpstraat 14 mei', 192.00, 'dorpstraat', 21, '18-02-11', 192.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (35, 56, 2011, '2011-02-21', 'Reparatie auto', 288.28, 'hofman', 12, '2011062', 288.28, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (36, 68, 2011, '2011-04-06', 'Reparatie auto motorsteun', 200.81, 'hofman', 12, '2011116', 200.81, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (37, 69, 2011, '2011-04-13', 'Spuitmateriaal', 189.25, 'kramer', 1, '52992', 189.25, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (38, 70, 2011, '2011-04-21', 'Telefoon 16-4/15-5', 34.90, 'tmobile', 10, '901135287534', 34.90, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (39, 71, 2011, '2011-05-03', 'Huur atelier mei', 297.50, 'verweij', 22, 'VF100182', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (40, 72, 2011, '2011-05-11', 'Advertentie braderie', 59.50, 'hartvh', 23, '15450', 59.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (41, 73, 2011, '2011-05-15', 'Buizenpoten tbv tafel atelier', 208.04, 'tubecl', 24, '82628', 208.04, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (42, 74, 2011, '2011-05-26', 'Spuitmateriaal', 367.65, 'kramer', 1, '53237', 367.65, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (43, 75, 2011, '2011-06-08', 'Spuitmateriaal', 386.35, 'kramer', 1, '53327', 386.35, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (44, 76, 2011, '2011-05-24', 'Naheffing parkeerbelasting', 72.00, 'delft', 25, '4178454', 72.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (45, 77, 2011, '2011-06-06', 'Huur atelier 06', 297.50, 'verweij', 22, 'VF100198', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (46, 78, 2011, '2011-06-06', 'WA Opel 11-7/11-10', 167.13, 'vandien', 7, '14053194', 167.13, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (47, 79, 2011, '2011-06-07', 'Wegenbelasting 8-6/7-11', 70.00, 'belasting', 11, '69414993M13', 70.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (48, 80, 2011, '2011-06-11', 'PB Easynote laptop', 458.95, 'wehkamp', 9, '20110611', 458.95, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (49, 81, 2011, '2011-06-17', 'Opel grote beurt', 335.70, 'hofman', 12, '2011195', 335.70, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (50, 82, 2011, '2011-06-25', 'Senseo en toiletborstel vr atelier', 99.85, 'wehkamp', 9, '20110625', 99.85, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (51, 83, 2011, '2011-06-25', 'Ventilatoren atelier', 45.90, 'wehkamp', 9, '20110625', 45.90, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (52, 84, 2011, '2011-06-27', 'Olympus cam, Brother printer', 215.96, 'staples', 26, 'VS63059691', 215.96, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (53, 85, 2011, '2011-06-30', 'Glazen tafelblad atelier', 431.38, 'vandijken', 18, '52390', 431.38, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (54, 100, 2011, '2011-07-01', 'Huur juli', 297.50, 'verweij', 22, 'VF100215', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (55, 101, 2011, '2011-07-06', 'Internet dongle juli', 25.00, 'vodafone', 27, '175890026', 25.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (56, 102, 2011, '2011-07-07', 'Spuitmateriaal', 434.00, 'kramer', 1, '53533', 434.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (57, 103, 2011, '2011-08-01', 'Huur atelier 08', 297.50, 'verweij', 22, '100229', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (58, 104, 2011, '2011-08-09', 'Spuitmateriaal', 165.00, 'kramer', 1, '53683', 165.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (59, 105, 2011, '2011-08-11', 'Versnaperingen feest atelier', 121.96, 'sligro', 28, '5457062', 121.96, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (60, 106, 2011, '2011-08-06', 'Internet dongle aug', 25.00, 'vodafone', 27, '178515545', 25.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (61, 107, 2011, '2011-08-30', 'Harde schijven voor NAS', 179.98, 'mediamarkt', 6, '40430000', 179.98, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (62, 108, 2011, '2011-08-30', 'NAS', 283.00, 'mediamarkt', 6, '40429997', 283.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (63, 109, 2011, '2011-07-23', 'Onderhoud en reparatie', 771.57, 'hofman', 12, '2011237', 771.57, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (64, 110, 2011, '2011-09-01', 'Huur atelier 09', 297.50, 'verweij', 22, '100245', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (65, 111, 2011, '2011-09-07', 'Internet dongle sep', 25.83, 'vodafone', 27, '181195660', 25.83, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (66, 112, 2011, '2011-09-05', 'Verzekering auto 11-10/11-01', 167.13, 'vandien', 7, '14356999', 167.13, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (71, 122, 2011, '2011-10-03', 'Huur atelier oktober', 297.50, 'verweij', 22, '100260', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (68, 114, 2011, '2011-09-09', 'Wegenbelasting 8-9/7-12', 70.00, 'belasting', 11, '69414993M15', 70.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (69, 115, 2011, '2011-09-19', 'Verduisteringsdoek atelier', 58.00, 'dms', 29, '11037', 58.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (70, 116, 2011, '2011-09-27', 'Distributieriem defect', 694.86, 'hofman', 12, '2011287', 694.86, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (72, 123, 2011, '2011-09-29', 'Distributieriem Opel', 694.86, 'hofman', 12, '2011287', 694.86, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (73, 124, 2011, '2011-10-13', 'Reparatie remmen Opel', 209.57, 'hofman', 12, '70046770', 209.57, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (74, 125, 2011, '2011-10-22', 'Harde schijven', 139.98, 'mediamarkt', 6, '40445545', 139.98, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (75, 126, 2011, '2011-10-23', 'Spuitmateriaal', 305.95, 'kramer', 1, '54140', 305.95, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (76, 127, 2011, '2011-11-01', 'Huur atelier november', 297.50, 'verweij', 22, '100275', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (77, 128, 2011, '2011-11-04', 'Maskers en brandblusser', 92.34, 'engelb', 30, '185480', 92.34, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (216, 322, 2012, '2012-10-25', 'Batterijen', 45.98, 'conrad', 43, '9549073130', 45.98, '2012-10-25');
INSERT INTO inkoopfacturen VALUES (78, 129, 2011, '2011-11-07', 'Mobiel Internet november', 50.00, 'vodafone', 27, '186575876', 50.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (79, 130, 2011, '2011-11-09', 'Advertenties', 300.00, 'marktplaats', 2, '111100374', 300.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (80, 131, 2011, '2011-11-22', 'Winterbanden en velgen Opel', 1157.26, 'hofman', 12, '2011365', 1157.26, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (81, 132, 2011, '2011-12-01', 'Huur atelier december', 297.50, 'verweij', 22, '100290', 297.50, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (82, 133, 2011, '2011-12-01', 'Gem.Delft Parkeernaheffingsaanslag', 54.20, 'diverse', 31, '4227593', 54.20, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (83, 134, 2011, '2011-12-05', 'Verzekering Opel 1e kw 2012', 140.49, 'vandien', 7, '14656262', 140.49, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (84, 135, 2011, '2011-12-07', 'Mobiel Internet december', 52.75, 'vodafone', 27, '189289585', 52.75, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (85, 136, 2011, '2011-12-09', 'Wegenbelasting Opel 8dec/7mrt', 70.00, 'belasting', 11, '69414993M17', 70.00, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (86, 137, 2011, '2011-12-16', 'Lettersjabloon', 228.48, 'bosman', 32, '7899', 228.48, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (87, 138, 2011, '2011-12-26', 'Spuitmateriaal', 289.85, 'kramer', 1, '54519', 289.85, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (88, 139, 2011, '2011-12-30', 'Kleine beurt Opel', 154.44, 'hofman', 12, '2011404', 154.44, '2011-12-31');
INSERT INTO inkoopfacturen VALUES (113, 179, 2013, '2012-12-03', 'Huur atelier december 2012', 431.70, 'verweij', 22, '2012173', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (140, 245, 2012, '2012-01-02', 'Huur atelier Boskoop jan', 305.57, 'verweij', 22, '2012014', 305.57, '2012-01-02');
INSERT INTO inkoopfacturen VALUES (141, 246, 2012, '2012-01-07', 'Mobiel internet jan', 47.25, 'vodafone', 27, '192034269', 47.25, '2012-01-07');
INSERT INTO inkoopfacturen VALUES (142, 247, 2012, '2012-01-18', 'Telefoon jan', 35.47, 'tmobile', 10, '901154931629', 35.47, '2012-01-18');
INSERT INTO inkoopfacturen VALUES (143, 248, 2012, '2012-01-25', 'Spuitmaskers', 213.01, 'engelb', 30, '194755', 213.01, '2012-01-25');
INSERT INTO inkoopfacturen VALUES (144, 249, 2012, '2012-01-26', 'Verf en linnen', 94.45, 'vanbeek', 39, '747147', 94.45, '2012-01-26');
INSERT INTO inkoopfacturen VALUES (145, 250, 2012, '2012-01-30', 'Printerinkt', 53.95, '123inkt', 17, '2559604', 53.95, '2012-01-30');
INSERT INTO inkoopfacturen VALUES (146, 251, 2012, '2012-01-15', 'Spuitmateriaal', 254.70, 'kramer', 1, '54622', 254.70, '2012-01-15');
INSERT INTO inkoopfacturen VALUES (147, 252, 2012, '2012-02-02', 'Huur atelier Boskoop feb', 305.57, 'verweij', 22, '201229', 305.57, '2012-02-02');
INSERT INTO inkoopfacturen VALUES (148, 253, 2012, '2012-02-02', 'Bijdrage KvK 2012', 41.03, 'kvk', 3, '251488299', 41.03, '2012-02-02');
INSERT INTO inkoopfacturen VALUES (149, 254, 2012, '2012-02-07', 'Mobiel internet feb', 50.00, 'vodafone', 27, '195064547', 50.00, '2012-02-07');
INSERT INTO inkoopfacturen VALUES (150, 255, 2012, '2012-02-11', 'Spuitmateriaal', 175.25, 'kramer', 1, '54794', 175.25, '2012-02-11');
INSERT INTO inkoopfacturen VALUES (151, 256, 2012, '2012-02-13', 'Marktplaats advertentie', 29.00, 'marktplaats', 2, '120200554', 29.00, '2012-02-13');
INSERT INTO inkoopfacturen VALUES (152, 257, 2012, '2012-02-20', 'Telefoon feb', 37.62, 'tmobile', 10, '901157136105', 37.62, '2012-02-20');
INSERT INTO inkoopfacturen VALUES (153, 258, 2012, '2012-02-23', 'Verf en linnen', 161.32, 'vanbeek', 39, '759771', 161.32, '2012-02-23');
INSERT INTO inkoopfacturen VALUES (154, 259, 2012, '2012-02-23', 'Markers', 11.82, 'vanbeek', 39, '759773', 11.82, '2012-02-23');
INSERT INTO inkoopfacturen VALUES (155, 260, 2012, '2012-02-28', 'TomTom', 119.99, 'mediamarkt', 6, '40956138', 119.99, '2012-02-28');
INSERT INTO inkoopfacturen VALUES (156, 261, 2012, '2012-03-05', 'Huur atelier Boskoop mrt', 424.57, 'verweij', 22, '2012044', 424.57, '2012-03-05');
INSERT INTO inkoopfacturen VALUES (157, 262, 2012, '2012-04-11', 'Verzekering Opel 11-4/11-7', 140.49, 'vandien', 7, '14965804', 140.49, '2012-04-11');
INSERT INTO inkoopfacturen VALUES (158, 263, 2012, '2012-03-08', 'Mobiel internet mrt', 50.00, 'vodafone', 27, '198321528', 50.00, '2012-03-08');
INSERT INTO inkoopfacturen VALUES (159, 264, 2012, '2012-03-09', 'Motorrijtuigenbelasting Opel 8-03/7-06', 71.00, 'belasting', 11, '69474993M2', 71.00, '2012-03-09');
INSERT INTO inkoopfacturen VALUES (160, 265, 2012, '2012-03-12', 'Spuitmateriaal', 292.65, 'kramer', 1, '54972', 292.65, '2012-03-12');
INSERT INTO inkoopfacturen VALUES (161, 267, 2012, '2012-03-30', 'Kleine beurt Opel', 171.51, 'hofman', 12, '2012098', 171.51, '2012-03-30');
INSERT INTO inkoopfacturen VALUES (162, 268, 2012, '2012-04-02', 'Huur atelier Boskoop apr', 424.57, 'verweij', 22, '2012059', 424.57, '2012-04-02');
INSERT INTO inkoopfacturen VALUES (163, 269, 2012, '2012-04-09', 'Mobiel internet apr', 50.00, 'vodafone', 27, '203060518', 50.00, '2012-04-09');
INSERT INTO inkoopfacturen VALUES (164, 270, 2012, '2012-04-13', 'Boete onjuiste opgaaf ICP 4e kw 2011', 123.00, 'belasting', 11, '69414993F011641', 123.00, '2012-04-13');
INSERT INTO inkoopfacturen VALUES (165, 271, 2012, '2012-05-01', 'Huur atelier Boskoop mei', 424.57, 'verweij', 22, '2012075', 424.57, '2012-05-01');
INSERT INTO inkoopfacturen VALUES (166, 272, 2012, '2012-05-02', 'Dopsleutel speciaal', 22.29, 'a1', 47, '201205139', 22.29, '2012-05-02');
INSERT INTO inkoopfacturen VALUES (167, 273, 2012, '2012-05-09', 'Mobiel internet mei', 50.00, 'vodafone', 27, '207277187', 50.00, '2012-05-09');
INSERT INTO inkoopfacturen VALUES (168, 274, 2012, '2012-05-12', 'Tekenmateriaal', 42.03, 'vanbeek', 39, '794001', 42.03, '2012-05-12');
INSERT INTO inkoopfacturen VALUES (169, 275, 2012, '2012-05-25', 'Medion portable PC', 349.00, 'mediamarkt', 6, '4070672', 349.00, '2012-05-25');
INSERT INTO inkoopfacturen VALUES (170, 276, 2012, '2012-05-17', 'Creditnota gederfde schade', -5.00, 'vodafone', 27, '209655714', -5.00, '2012-05-17');
INSERT INTO inkoopfacturen VALUES (171, 277, 2012, '2012-04-20', 'Spuitmateriaal', 467.40, 'kramer', 1, '55182', 467.40, '2012-04-20');
INSERT INTO inkoopfacturen VALUES (172, 278, 2012, '2012-05-14', 'Spuitmateriaal', 296.45, 'kramer', 1, '55395', 296.45, '2012-05-14');
INSERT INTO inkoopfacturen VALUES (173, 279, 2012, '2012-05-18', 'Linnen', 23.76, 'vanbeek', 39, '795985', 23.76, '2012-05-18');
INSERT INTO inkoopfacturen VALUES (174, 280, 2012, '2012-05-25', 'Spuitmateriaal', 133.65, 'kramer', 1, '55469', 133.65, '2012-05-25');
INSERT INTO inkoopfacturen VALUES (175, 281, 2012, '2012-06-01', 'Huur atelier Boskoop jun', 424.57, 'verweij', 22, '2012092', 424.57, '2012-06-01');
INSERT INTO inkoopfacturen VALUES (176, 282, 2012, '2012-06-04', 'Verzekering Opel 11-7/11-10', 140.49, 'vandien', 7, '15265917', 140.49, '2012-06-04');
INSERT INTO inkoopfacturen VALUES (177, 283, 2012, '2012-06-11', 'Wegenbelasting Opel 8-06/7-09', 71.00, 'belasting', 11, '69414993m22', 71.00, '2012-06-11');
INSERT INTO inkoopfacturen VALUES (178, 284, 2012, '2012-06-12', 'Spuitmateriaal', 193.90, 'kramer', 1, '55648', 193.90, '2012-06-12');
INSERT INTO inkoopfacturen VALUES (179, 285, 2012, '2012-06-23', 'Memory stick 16G', 12.99, 'paradigit', 48, '132032426', 12.99, '2012-06-23');
INSERT INTO inkoopfacturen VALUES (180, 286, 2012, '2012-06-25', 'Spuitmateriaal', 165.55, 'kramer', 1, '55793', 165.55, '2012-06-25');
INSERT INTO inkoopfacturen VALUES (181, 287, 2012, '2012-07-02', 'Spuitmateriaal', 161.75, 'kramer', 1, '55837', 161.75, '2012-07-02');
INSERT INTO inkoopfacturen VALUES (182, 288, 2012, '2012-07-10', 'Mobiel internet jul', 32.26, 'vodafone', 27, '216408394', 32.26, '2012-07-10');
INSERT INTO inkoopfacturen VALUES (183, 289, 2012, '2012-07-11', 'Mobiel internet mei', 50.00, 'vodafone', 27, '212045361', 50.00, '2012-07-11');
INSERT INTO inkoopfacturen VALUES (184, 290, 2012, '2012-07-11', 'Spuitmateriaal', 243.90, 'kramer', 1, '55936', 243.90, '2012-07-11');
INSERT INTO inkoopfacturen VALUES (185, 291, 2012, '2012-07-14', 'Spuitmateriaal', 510.45, 'kramer', 1, '55948', 510.45, '2012-07-14');
INSERT INTO inkoopfacturen VALUES (186, 292, 2012, '2012-07-16', 'Brochures Koogerkunst', 23.95, 'drukwerk', 34, '2012381133', 23.95, '2012-07-16');
INSERT INTO inkoopfacturen VALUES (187, 293, 2012, '2012-07-16', 'Vinylstickers Koogerkunst', 26.78, 'drukwerk', 34, '2012380765', 26.78, '2012-07-16');
INSERT INTO inkoopfacturen VALUES (188, 294, 2012, '2012-07-24', 'Telefoon jul', 35.47, 'tmobile', 10, '901168240121', 35.47, '2012-07-24');
INSERT INTO inkoopfacturen VALUES (189, 295, 2012, '2012-07-24', 'Printerinkt', 24.45, '123inkt', 17, '2995179', 24.45, '2012-07-24');
INSERT INTO inkoopfacturen VALUES (190, 296, 2012, '2012-07-27', 'Backup software', 49.95, 'acronis', 49, '73619285233', 49.95, '2012-07-27');
INSERT INTO inkoopfacturen VALUES (191, 297, 2012, '2012-07-28', 'Backup software update', 35.69, 'acronis', 49, '73619315387', 35.69, '2012-07-28');
INSERT INTO inkoopfacturen VALUES (192, 298, 2012, '2012-07-27', 'Telmachinemateriaal en stempel', 47.70, 'kroon', 50, '9016364', 47.70, '2012-07-27');
INSERT INTO inkoopfacturen VALUES (193, 299, 2012, '2012-08-01', 'Huur atelier Boskoop aug', 424.57, 'verweij', 22, '2012121', 424.57, '2012-08-01');
INSERT INTO inkoopfacturen VALUES (194, 300, 2012, '2012-08-02', 'Spuitmateriaal', 428.95, 'kramer', 1, '56110', 428.95, '2012-08-02');
INSERT INTO inkoopfacturen VALUES (195, 301, 2012, '2012-08-03', 'Boekjes glazen kunstwerken Vondelflats', 1127.85, 'drukwerk', 34, '2012389598', 1127.85, '2012-08-03');
INSERT INTO inkoopfacturen VALUES (196, 302, 2012, '2012-08-07', 'Onderhoud en banden Opel', 818.64, 'hofman', 12, '2012191', 818.64, '2012-08-07');
INSERT INTO inkoopfacturen VALUES (197, 303, 2012, '2012-08-07', 'Werkschort', 24.40, 'surprise', 51, '598716-372169', 24.40, '2012-08-07');
INSERT INTO inkoopfacturen VALUES (198, 304, 2012, '2012-08-08', 'Materiaal', 35.85, 'vanbeek', 39, '826289', 35.85, '2012-08-08');
INSERT INTO inkoopfacturen VALUES (199, 305, 2012, '2012-08-08', 'Foto op canvas', 27.00, 'canvas', 52, '2012221925', 27.00, '2012-08-08');
INSERT INTO inkoopfacturen VALUES (200, 306, 2012, '2012-08-11', 'Gereedschap', 29.90, 'buitelaar', 53, 'contant', 29.90, '2012-08-11');
INSERT INTO inkoopfacturen VALUES (201, 307, 2012, '2012-08-20', 'Telefoon aug', 35.47, 'tmobile', 10, '901170478394', 35.47, '2012-08-20');
INSERT INTO inkoopfacturen VALUES (202, 308, 2012, '2012-08-22', 'Spuitmateriaal', 252.00, 'kramer', 1, '56235', 252.00, '2012-08-22');
INSERT INTO inkoopfacturen VALUES (203, 309, 2012, '2012-09-02', 'Huur atelier Boskoop sep', 424.57, 'verweij', 22, '2012134', 424.57, '2012-09-02');
INSERT INTO inkoopfacturen VALUES (204, 310, 2012, '2012-09-04', 'Spuitmateriaal', 493.85, 'kramer', 1, '56333', 493.85, '2012-09-04');
INSERT INTO inkoopfacturen VALUES (205, 311, 2012, '2012-08-26', 'Parkeerbelasting Ged.Burgwal', 56.60, 'denhaag', 54, '100014', 56.60, '2012-08-26');
INSERT INTO inkoopfacturen VALUES (206, 312, 2012, '2012-09-07', 'Printerinkt', 43.45, '123inkt', 17, '3094297', 43.45, '2012-09-07');
INSERT INTO inkoopfacturen VALUES (207, 313, 2012, '2012-09-10', 'Verzekering Opel 11-10/11-01-13', 140.49, 'vandien', 7, '15569339', 140.49, '2012-09-10');
INSERT INTO inkoopfacturen VALUES (208, 314, 2012, '2012-09-10', 'Motorrijtuigenbelasting Opel 8-09/7-12', 71.00, 'belasting', 11, '69414993M25', 71.00, '2012-09-10');
INSERT INTO inkoopfacturen VALUES (209, 315, 2012, '2012-09-24', 'Telefoon sep', 38.47, 'tmobile', 10, '901172713938', 38.47, '2012-09-24');
INSERT INTO inkoopfacturen VALUES (210, 316, 2012, '2012-09-27', 'Lampen', 44.01, 'hofman', 12, '2012271', 44.01, '2012-09-27');
INSERT INTO inkoopfacturen VALUES (211, 317, 2012, '2012-09-28', 'Linnen', 68.81, 'vanbeek', 39, '847746', 68.81, '2012-09-28');
INSERT INTO inkoopfacturen VALUES (212, 318, 2012, '2012-10-01', 'Huur atelier Boskoop okt', 431.70, 'verweij', 22, '2012147', 431.70, '2012-10-01');
INSERT INTO inkoopfacturen VALUES (213, 319, 2012, '2012-11-10', 'Accu startblok', 84.80, 'accu', 55, '3424427', 84.80, '2012-11-10');
INSERT INTO inkoopfacturen VALUES (214, 320, 2012, '2012-10-10', 'Veiligheidsmateriaal', 184.28, 'engelb', 30, '222121', 184.28, '2012-10-10');
INSERT INTO inkoopfacturen VALUES (215, 321, 2012, '2012-10-15', 'Spuitmateriaal', 284.10, 'kramer', 1, '56610', 284.10, '2012-10-15');
INSERT INTO inkoopfacturen VALUES (217, 323, 2012, '2012-10-25', 'Flyers ', 47.93, 'drukwerk', 34, '2012438511', 47.93, '2012-10-25');
INSERT INTO inkoopfacturen VALUES (218, 324, 2012, '2012-10-26', 'Stickers auto', 64.06, 'drukwerk', 34, '2012439962', 64.06, '2012-10-26');
INSERT INTO inkoopfacturen VALUES (220, 326, 2012, '2012-11-01', 'Spuitmateriaal', 144.10, 'kramer', 1, '56680', 144.10, '2012-11-01');
INSERT INTO inkoopfacturen VALUES (221, 327, 2012, '2012-11-05', 'Linnen en stiften', 157.93, 'vanbeek', 39, '865253', 157.93, '2012-11-05');
INSERT INTO inkoopfacturen VALUES (222, 328, 2012, '2012-11-06', 'Spuitmateriaal', 209.40, 'kramer', 1, '56751', 209.40, '2012-11-06');
INSERT INTO inkoopfacturen VALUES (223, 329, 2012, '2012-11-21', 'Marktplaats advertentiepakket', 139.95, 'marktplaats', 2, '121126169', 139.95, '2012-11-21');
INSERT INTO inkoopfacturen VALUES (224, 330, 2012, '2012-11-22', 'Spuitmateriaal', 223.95, 'kramer', 1, '56854', 223.95, '2012-11-22');
INSERT INTO inkoopfacturen VALUES (225, 331, 2012, '2012-12-03', 'APK, winterbanden, onderhoud', 802.68, 'hofman', 12, '2012325', 802.68, '2012-12-03');
INSERT INTO inkoopfacturen VALUES (226, 332, 2012, '2012-12-04', 'Naheffing 3ekw', 61.56, 'belasting', 11, '69414993F012270', 61.56, '2012-12-04');
INSERT INTO inkoopfacturen VALUES (227, 333, 2012, '2012-12-10', 'Motorrijtuigenbelasting Opel 8-12/7-03-13', 71.00, 'belasting', 11, '69414993M27', 71.00, '2012-12-10');
INSERT INTO inkoopfacturen VALUES (228, 334, 2012, '2012-12-07', 'Markers', 44.25, 'vanbeek', 39, '882801', 44.25, '2012-12-07');
INSERT INTO inkoopfacturen VALUES (229, 335, 2012, '2012-12-11', 'T-shirts voor promotie', 105.03, 'kleding', 56, '7181', 105.03, '2012-12-11');
INSERT INTO inkoopfacturen VALUES (230, 336, 2012, '2012-12-12', 'Stiften retour', -12.93, 'vanbeek', 39, '884982', -12.93, '2012-12-12');
INSERT INTO inkoopfacturen VALUES (231, 337, 2012, '2012-12-14', 'Markers', 65.15, 'vanbeek', 39, '886388', 65.15, '2012-12-14');
INSERT INTO inkoopfacturen VALUES (232, 338, 2012, '2012-12-21', 'Spuitmateriaal', 101.76, 'uc', 35, '979', 101.76, '2012-12-21');
INSERT INTO inkoopfacturen VALUES (233, 339, 2012, '2012-12-24', 'Huur atelier Boskoop jan 13', 441.64, 'verweij', 22, '2012182', 441.64, '2012-12-24');
INSERT INTO inkoopfacturen VALUES (234, 340, 2012, '2012-10-18', 'Telefoon okt', 49.97, 'tmobile', 10, '901174959033', 49.97, '2012-10-18');
INSERT INTO inkoopfacturen VALUES (235, 341, 2012, '2012-11-21', 'Telefoon nov', 39.42, 'tmobile', 10, '901177212893', 39.42, '2012-11-21');
INSERT INTO inkoopfacturen VALUES (236, 342, 2012, '2012-12-19', 'Telefoon dec', 36.07, 'tmobile', 10, '901179454378', 36.07, '2012-12-19');
INSERT INTO inkoopfacturen VALUES (237, 343, 2012, '2012-11-01', 'Huur atelier Boskoop nov', 431.70, 'verweij', 22, '2012160', 431.70, '2012-11-01');
INSERT INTO inkoopfacturen VALUES (238, 382, 2012, '2012-07-01', 'Huur atelier Boskoop jul', 424.57, 'verweij', 22, '2012121', 424.57, '2012-07-01');
INSERT INTO inkoopfacturen VALUES (239, 383, 2012, '2012-12-01', 'Huur atelier Boskoop dec', 441.64, 'verweij', 22, '2012182', 441.64, '2012-12-01');
INSERT INTO inkoopfacturen VALUES (290, 484, 2014, '2014-01-03', 'S-Video prof kabel', 17.30, 'akabels', 67, '710276', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (291, 485, 2014, '2014-01-09', 'Internet jan 25% zakelijk deel', 91.46, 'xs4all', 65, '43254092', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (292, 486, 2014, '2014-01-20', 'Mobiel jan', 46.36, 'tmobile', 10, '901208815968', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (293, 487, 2014, '2014-01-23', 'Spuitmateriaal', 39.50, 'vanbeek', 39, '1063733', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (294, 488, 2014, '2014-01-28', 'Molotow spuitmateriaal', 264.90, 'publikat', 63, 'RE1208572', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (295, 489, 2014, '2014-02-01', 'LG G2 telefoon', 436.41, 'mediamarkt', 6, '40753381', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (296, 490, 2014, '2014-02-09', 'Internet feb 25% zakelijk deel', 85.85, 'xs4all', 65, '43499507', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (297, 491, 2014, '2014-02-19', 'Mobiel feb', 60.67, 'tmobile', 10, '901211073049', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (298, 492, 2014, '2014-02-17', 'Motorrijtuigenbelasting Nissan 17-02/16-05', 79.00, 'belasting', 11, '694.14.993.M.4.2', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (299, 493, 2014, '2014-02-18', 'SSD schijf webserver', 79.84, 'altern', 60, '424179850', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (300, 494, 2014, '2014-03-01', 'Spuitmateriaal', 14.85, 'vanbeek', 39, '1082792', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (301, 495, 2014, '2014-03-09', 'Internet mrt 25% zakelijk deel', 57.62, 'xs4all', 65, '43742381', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (302, 496, 2014, '2014-03-14', 'Verf en doek', 191.83, 'vanbeek', 39, '1089195', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (303, 497, 2014, '2014-03-19', 'Mobiel mrt', 17.56, 'tmobile', 10, '901213303053', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (304, 498, 2014, '2014-03-24', 'Glaswerk tbv display', 689.64, 'vandijken', 18, '60593', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (305, 502, 2014, '2014-02-12', 'Advertentieplaatsingen jan 2014', 11.50, 'marktplaats', 2, '140205801', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (306, 503, 2014, '2014-03-10', 'Advertentieplaatsingen feb 2014', 82.29, 'marktplaats', 2, '140305458', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (307, 504, 2014, '2014-03-21', 'Wrappen Nissan', 1210.00, 'objekt', 68, '14700233', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (308, 510, 2014, '2014-04-01', 'Printerinkt', 57.45, '123inkt', 17, '4912088', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (309, 511, 2014, '2014-04-09', 'Internet 08/04-08/05', 61.27, 'xs4all', 65, '43985891', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (310, 512, 2014, '2014-04-16', 'Keuring en onderhoud', 655.66, 'hofman', 12, '2014099', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (311, 513, 2014, '2014-04-17', 'Advertentieplaatsingen', 5.45, 'marktplaats', 2, '140405677', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (312, 514, 2014, '2014-04-21', 'Mobiel 16/4-15/5', 30.83, 'tmobile', 10, '0901215510197', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (313, 515, 2014, '2014-05-09', 'Internet apr', 39.14, 'xs4all', 65, '44229892', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (314, 516, 2014, '2014-05-14', 'Spuitmaskers', 216.59, 'engelb', 30, '305931', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (315, 517, 2014, '2014-05-19', 'Motorrijtuigenbelasting 17/5-16/8', 79.00, 'belasting', 11, '69414993M44', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (316, 518, 2014, '2014-05-20', 'Telefoon mei', 34.69, 'tmobile', 10, '901217664084', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (317, 519, 2014, '2014-05-26', 'Morsverf Latex', 119.49, 'claasen', 20, '814979', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (318, 520, 2014, '2014-05-27', 'Update backup software', 16.76, 'acronis', 49, '73634548279', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (319, 521, 2014, '2014-05-27', 'Spuitmateriaal', 150.95, 'kramer', 1, '94514', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (320, 522, 2014, '2014-06-09', 'Internet jun', 45.75, 'xs4all', 65, '44470835', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (321, 523, 2014, '2014-06-18', 'Telefoon 16/6-15/7', 46.11, 'tmobile', 10, '901219904199', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (322, 532, 2014, '2014-07-09', 'Internet jul', 45.50, 'xs4all', 65, '44714386', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (323, 533, 2014, '2014-07-21', 'Telefoon 16/7-15/8', 31.51, 'tmobile', 10, '901222065965', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (324, 534, 2014, '2014-07-26', 'Asus pad 7inch', 124.00, 'mediamarkt', 6, '40808626', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (325, 535, 2014, '2014-08-06', 'Morsverf Latex', 47.80, 'claasen', 20, '824815', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (326, 536, 2014, '2014-08-09', 'Internet aug', 44.58, 'xs4all', 65, '44965935', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (327, 537, 2014, '2014-08-14', 'Nissan 11/8-11/11', 120.75, 'vandien', 7, '20157465', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (328, 538, 2014, '2014-08-18', 'Nissan 17/8-16/11', 79.00, 'belasting', 11, '69414993M46', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (329, 539, 2014, '2014-08-20', 'Telefoon 16/8-15/9', 34.73, 'tmobile', 10, '901224253796', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (330, 540, 2014, '2014-08-21', 'Nieuwe Accu Nissan', 140.36, 'hofman', 12, '201424', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (331, 541, 2014, '2014-08-30', 'Nissan Kleine beurt', 339.80, 'hofman', 12, '2014211', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (332, 542, 2014, '2014-09-08', 'Aanpassing schadevrije jaren van 74 naar 72%', 8.51, 'vandien', 7, '20168476', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (333, 543, 2014, '2014-09-09', 'Internet sep', 49.99, 'xs4all', 65, '45205585', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (334, 544, 2014, '2014-09-20', 'Linnen', 70.75, 'vanbeek', 39, '1169725', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (335, 545, 2014, '2014-09-20', 'Acryl', 12.29, 'vanbeek', 39, '1169731', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (336, 546, 2014, '2014-09-22', 'Telefoon 16/9-15/10', 28.99, 'tmobile', 10, '901226471417', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (337, 547, 2014, '2014-09-25', 'Spuitmateriaal', 171.94, 'publikat', 63, 'RE1425857', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (338, 548, 2014, '2014-09-27', 'Linnen ruilen en bijbetalen', 90.44, 'vanbeek', 39, '1173616', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (89, 155, 2013, '2013-01-02', 'Spuitmateriaal', 177.40, 'kramer', 1, '21957039', 177.40, '2013-01-02');
INSERT INTO inkoopfacturen VALUES (90, 156, 2013, '2013-01-07', 'T-shirts voor bedrukking', 109.08, 'tshirts', 33, '7240', 109.08, '2013-01-07');
INSERT INTO inkoopfacturen VALUES (91, 157, 2013, '2013-01-11', 'Spuitmateriaal', 248.40, 'kramer', 1, '57141', 248.40, '2013-01-11');
INSERT INTO inkoopfacturen VALUES (92, 158, 2013, '2013-01-17', 'Reclameposters', 24.07, 'drukwerk', 34, '2013109457', 24.07, '2013-01-17');
INSERT INTO inkoopfacturen VALUES (93, 159, 2013, '2013-01-21', 'T-mobile 75% zakelijk', 19.63, 'tmobile', 10, '901181710172', 19.63, '2013-01-21');
INSERT INTO inkoopfacturen VALUES (94, 160, 2013, '2013-01-23', 'Reclameposters', 102.62, 'drukwerk', 34, '2013113939', 102.62, '2013-01-23');
INSERT INTO inkoopfacturen VALUES (95, 161, 2013, '2013-01-29', 'Spuitmateriaal', 237.50, 'kramer', 1, '57222', 237.50, '2013-01-29');
INSERT INTO inkoopfacturen VALUES (96, 162, 2013, '2013-02-01', 'Montana spuitmateriaal', 102.90, 'uc', 35, 'RLZ-1063', 102.90, '2013-02-01');
INSERT INTO inkoopfacturen VALUES (97, 163, 2013, '2013-02-07', 'Kaasdoek 280cm breed', 48.67, 'stoffen', 36, '201300326', 48.67, '2013-02-07');
INSERT INTO inkoopfacturen VALUES (98, 164, 2013, '2013-02-07', 'Advertentiepakket', 137.94, 'marktplaats', 2, '130200486', 137.94, '2013-02-07');
INSERT INTO inkoopfacturen VALUES (99, 165, 2013, '2013-02-15', 'Morsverf latex', 143.39, 'claasen', 20, '762144', 143.39, '2013-02-15');
INSERT INTO inkoopfacturen VALUES (100, 166, 2013, '2013-02-19', 'T-mobile 75% zakelijk', 21.38, 'tmobile', 10, '901183959412', 21.38, '2013-02-19');
INSERT INTO inkoopfacturen VALUES (101, 167, 2013, '2013-02-21', 'Groothoekcamera TZ25', 196.00, 'foka', 37, '3350113', 196.00, '2013-02-21');
INSERT INTO inkoopfacturen VALUES (102, 168, 2013, '2013-02-26', 'Jinbei flitser SP-200', 213.89, 'konijn', 38, '27495', 213.89, '2013-02-26');
INSERT INTO inkoopfacturen VALUES (103, 169, 2013, '2013-03-05', 'Molotow refill', 15.22, 'vanbeek', 39, '920615', 15.22, '2013-03-05');
INSERT INTO inkoopfacturen VALUES (104, 170, 2013, '2013-03-05', 'Morsverf latex', 47.80, 'claasen', 20, '763690', 47.80, '2013-03-05');
INSERT INTO inkoopfacturen VALUES (105, 171, 2013, '2013-02-25', 'Naheffinsaanslag 4e kw 2012', 50.00, 'belasting', 11, '69414996F012300', 50.00, '2013-02-25');
INSERT INTO inkoopfacturen VALUES (106, 172, 2013, '2013-03-06', 'Reclameposters', 52.51, 'drukwerk', 34, '2013140365', 52.51, '2013-03-06');
INSERT INTO inkoopfacturen VALUES (107, 173, 2013, '2013-03-08', 'Spuitmateriaal', 302.65, 'kramer', 1, 'HE90214', 302.65, '2013-03-08');
INSERT INTO inkoopfacturen VALUES (108, 174, 2013, '2013-03-11', 'Verzekering Opel Combo', 129.25, 'vandien', 7, '16216131', 129.25, '2013-03-11');
INSERT INTO inkoopfacturen VALUES (109, 175, 2013, '2013-03-11', 'Motorrijtuigenbelasting Opel Combo 8/3-7/6 2013', 72.00, 'belasting', 11, '69414993M32', 72.00, '2013-03-11');
INSERT INTO inkoopfacturen VALUES (110, 176, 2013, '2013-03-19', 'T-mobile 75% zakelijk 16/3-15/4', 35.15, 'tmobile', 10, '901186233106', 35.15, '2013-03-19');
INSERT INTO inkoopfacturen VALUES (111, 177, 2013, '2013-03-25', 'AGP 500', 140.97, 'coating', 40, '1303001', 140.97, '2013-03-25');
INSERT INTO inkoopfacturen VALUES (112, 178, 2013, '2013-03-26', 'Foto op canvas', 11.50, 'drukwerk', 34, '2013154632', 11.50, '2013-03-26');
INSERT INTO inkoopfacturen VALUES (114, 192, 2013, '2013-04-01', 'Schildersdoek 120x160', 240.00, 'vend', 41, '114345373', 240.00, '2013-04-01');
INSERT INTO inkoopfacturen VALUES (115, 193, 2013, '2013-04-10', 'Drukspuit', 14.99, 'bolcom', 42, '8120632180', 14.99, '2013-04-10');
INSERT INTO inkoopfacturen VALUES (116, 194, 2013, '2013-04-11', 'Spuitmateriaal', 473.65, 'kramer', 1, 'HE90648', 473.65, '2013-04-11');
INSERT INTO inkoopfacturen VALUES (117, 195, 2013, '2013-04-11', 'Afdekfolie', 11.99, 'bolcom', 42, '8120632180', 11.99, '2013-04-11');
INSERT INTO inkoopfacturen VALUES (118, 196, 2013, '2013-04-17', 'Advertentiepakket KK', 65.34, 'marktplaats', 2, 'MP130423317', 65.34, '2013-04-17');
INSERT INTO inkoopfacturen VALUES (119, 197, 2013, '2013-04-24', 'Folders KK', 71.32, 'drukwerk', 34, 'F2013175995', 71.32, '2013-04-24');
INSERT INTO inkoopfacturen VALUES (120, 198, 2013, '2013-04-25', 'Spuitmateriaal', 166.20, 'kramer', 1, 'HE90767', 166.20, '2013-04-25');
INSERT INTO inkoopfacturen VALUES (121, 199, 2013, '2013-04-29', 'Spuitmateriaal', 96.20, 'kramer', 1, 'HE90780', 96.20, '2013-04-29');
INSERT INTO inkoopfacturen VALUES (122, 200, 2013, '2013-05-04', 'Doeken en tekenmaterialen', 92.25, 'vanbeek', 39, '947244', 92.25, '2013-05-04');
INSERT INTO inkoopfacturen VALUES (123, 201, 2013, '2013-05-17', 'Stiften', 27.74, 'vanbeek', 39, '952146', 27.74, '2013-05-17');
INSERT INTO inkoopfacturen VALUES (124, 202, 2013, '2013-05-15', 'Spuitmateriaal', 540.80, 'kramer', 1, 'HE90898', 540.80, '2013-05-15');
INSERT INTO inkoopfacturen VALUES (125, 203, 2013, '2013-05-17', 'Amsterdam parkeerheffing', 60.90, 'diverse', 31, '4000000034171391', 60.90, '2013-05-17');
INSERT INTO inkoopfacturen VALUES (126, 204, 2013, '2013-05-22', 'Kaasdoek', 27.66, 'stoffen', 36, '201301243', 27.66, '2013-05-22');
INSERT INTO inkoopfacturen VALUES (127, 205, 2013, '2013-06-08', 'Wegenbelasting Opel 8-6/7-9', 72.00, 'belasting', 11, '69414993M34', 72.00, '2013-06-08');
INSERT INTO inkoopfacturen VALUES (128, 206, 2013, '2013-07-11', 'Verzekering Opel 11-7/11-10', 129.25, 'vandien', 7, '16546675', 129.25, '2013-07-11');
INSERT INTO inkoopfacturen VALUES (129, 207, 2013, '2013-06-11', 'Latex en rollers', 50.17, 'claasen', 20, 'F773925', 50.17, '2013-06-11');
INSERT INTO inkoopfacturen VALUES (130, 208, 2013, '2013-06-24', 'Spuitmaskers', 78.89, 'engelb', 30, '254755', 78.89, '2013-06-24');
INSERT INTO inkoopfacturen VALUES (131, 209, 2013, '2013-06-23', 'Acculader en laadkabel', 81.87, 'conrad', 43, '9549690681', 81.87, '2013-06-23');
INSERT INTO inkoopfacturen VALUES (132, 210, 2013, '2013-06-25', 'Spuitmateriaal', 200.85, 'kramer', 1, 'HE91317', 200.85, '2013-06-25');
INSERT INTO inkoopfacturen VALUES (133, 211, 2013, '2013-06-26', 'Audio in auto', 119.95, 'kbaudio', 44, '100007363', 119.95, '2013-06-26');
INSERT INTO inkoopfacturen VALUES (134, 212, 2013, '2013-06-26', 'Spuitmateriaal', 162.80, 'kramer', 1, 'HE91195', 162.80, '2013-06-26');
INSERT INTO inkoopfacturen VALUES (135, 213, 2013, '2013-06-28', 'Banden Nissan', 695.00, 'profile', 45, 'M10087057', 695.00, '2013-06-28');
INSERT INTO inkoopfacturen VALUES (136, 217, 2013, '2013-06-10', 'Aanschaf Nissan Nv200 5-VKH-50', 9842.95, 'koops', 46, '63700647', 9842.95, '2013-06-10');
INSERT INTO inkoopfacturen VALUES (137, 234, 2013, '2013-04-18', 'Telefoon apr 75% zakelijk', 22.16, 'tmobile', 10, '901188503627', 22.16, '2013-04-18');
INSERT INTO inkoopfacturen VALUES (138, 235, 2013, '2013-05-21', 'Telefoon mei 75% zakelijk', 24.77, 'tmobile', 10, '901190736769', 24.77, '2013-05-21');
INSERT INTO inkoopfacturen VALUES (139, 236, 2013, '2013-06-19', 'Telefoon jun 75% zakelijk', 24.77, 'tmobile', 10, '901193006754', 24.77, '2013-06-19');
INSERT INTO inkoopfacturen VALUES (240, 402, 2013, '2013-07-10', 'Spuitmateriaal', 392.00, 'kramer', 1, 'HE91472', 392.00, '2013-07-10');
INSERT INTO inkoopfacturen VALUES (244, 409, 2013, '2013-08-09', 'Spuitmaskers', 216.59, 'engelb', 30, '260590', 216.59, '2013-08-09');
INSERT INTO inkoopfacturen VALUES (248, 413, 2013, '2013-08-19', 'Acrylverf', 36.24, 'vanbeek', 39, '986655', 36.24, '2013-08-19');
INSERT INTO inkoopfacturen VALUES (252, 417, 2013, '2013-09-20', 'Computermaterialen', 172.85, 'altern', 60, '424156643', 172.85, '2013-09-20');
INSERT INTO inkoopfacturen VALUES (256, 421, 2013, '2013-09-30', 'Computermateriaal SSD schijf', 311.01, 'altern', 60, '224158708', 311.01, '2013-09-30');
INSERT INTO inkoopfacturen VALUES (260, 425, 2013, '2013-09-09', 'Molotow spuitmateriaal', 331.80, 'publikat', 63, 'RE1087838', 331.80, '2013-09-09');
INSERT INTO inkoopfacturen VALUES (241, 403, 2013, '2013-07-31', 'Ladder', 87.90, 'betaalbaar', 57, '201314642', 87.90, '2013-07-31');
INSERT INTO inkoopfacturen VALUES (245, 410, 2013, '2013-08-13', 'Spuitmateriaal', 399.60, 'kramer', 1, 'HE91752', 399.60, '2013-08-13');
INSERT INTO inkoopfacturen VALUES (249, 414, 2013, '2013-08-28', 'Kraamhuur', 20.00, 'wadcult', 59, '28082013', 20.00, '2013-08-28');
INSERT INTO inkoopfacturen VALUES (253, 418, 2013, '2013-09-21', 'Computermateriaal', 25.00, 'groenec', 61, '82599', 25.00, '2013-09-21');
INSERT INTO inkoopfacturen VALUES (257, 422, 2013, '2013-07-18', 'T-Mobile 16-7/15-8', 24.78, 'tmobile', 10, '901195252861', 24.78, '2013-07-18');
INSERT INTO inkoopfacturen VALUES (261, 426, 2013, '2013-09-24', 'Molotow spuitmateriaal Duitsland', 141.02, 'molotow', 64, '145800', 141.02, '2013-09-24');
INSERT INTO inkoopfacturen VALUES (242, 407, 2013, '2013-07-08', 'Belasting Nissan 25-06/16-08', 46.00, 'belasting', 11, '694.14.993M3.5', 46.00, '2013-07-08');
INSERT INTO inkoopfacturen VALUES (246, 411, 2013, '2013-08-14', 'Stapelkratten', 68.63, 'kruiz', 58, '4027148', 68.63, '2013-08-14');
INSERT INTO inkoopfacturen VALUES (250, 415, 2013, '2013-09-09', 'Spuitmateriaal', 295.20, 'kramer', 1, 'HE91992', 295.20, '2013-09-09');
INSERT INTO inkoopfacturen VALUES (254, 419, 2013, '2013-09-22', 'Computermateriaal', 149.99, 'mycom', 62, '2209', 149.99, '2013-09-22');
INSERT INTO inkoopfacturen VALUES (258, 423, 2013, '2013-08-20', 'T-Mobile 16-8/15-9', 24.78, 'tmobile', 10, '901197517004', 24.78, '2013-08-20');
INSERT INTO inkoopfacturen VALUES (243, 408, 2013, '2013-08-05', 'Inktcartridges', 57.45, '123inkt', 17, '4078023', 57.45, '2013-08-05');
INSERT INTO inkoopfacturen VALUES (247, 412, 2013, '2013-08-19', 'Motorrijtuigenbelasting Nissan 17-8/16-11', 78.00, 'belasting', 11, '694.14.993.M.3.7', 78.00, '2013-08-19');
INSERT INTO inkoopfacturen VALUES (251, 416, 2013, '2013-09-12', 'Advertenties', 24.00, 'marktplaats', 2, 'MPDI130905301', 24.00, '2013-09-12');
INSERT INTO inkoopfacturen VALUES (255, 420, 2013, '2013-09-30', 'Computermateriaal koeling', 19.99, 'altern', 60, '224158711', 19.99, '2013-09-30');
INSERT INTO inkoopfacturen VALUES (259, 424, 2013, '2013-09-18', 'T-Mobile 16-9/15-10', 24.78, 'tmobile', 10, '901199780567', 24.78, '2013-09-18');
INSERT INTO inkoopfacturen VALUES (262, 441, 2013, '2013-10-01', 'Stiften en verfmaterialen', 194.09, 'vanbeek', 39, '1007059', 194.09, '2013-10-01');
INSERT INTO inkoopfacturen VALUES (263, 442, 2013, '2013-01-09', 'Internet jan 75% zakelijk deel', 70.99, 'xs4all', 65, '40162635', 70.99, '2013-01-09');
INSERT INTO inkoopfacturen VALUES (264, 443, 2013, '2013-02-09', 'Internet feb 75% zakelijk deel', 73.10, 'xs4all', 65, '40438518', 73.10, '2013-02-09');
INSERT INTO inkoopfacturen VALUES (265, 444, 2013, '2013-03-09', 'Internet mrt 75% zakelijk deel', 93.47, 'xs4all', 65, '40704328', 93.47, '2013-03-09');
INSERT INTO inkoopfacturen VALUES (266, 445, 2013, '2013-04-09', 'Internet apr 75% zakelijk deel', 69.36, 'xs4all', 65, '40967790', 69.36, '2013-04-09');
INSERT INTO inkoopfacturen VALUES (267, 446, 2013, '2013-05-09', 'Internet mei 75% zakelijk deel', 63.24, 'xs4all', 65, '41230664', 63.24, '2013-05-09');
INSERT INTO inkoopfacturen VALUES (268, 447, 2013, '2013-06-09', 'Internet jun 75% zakelijk deel', 72.98, 'xs4all', 65, '41491228', 72.98, '2013-06-09');
INSERT INTO inkoopfacturen VALUES (269, 448, 2013, '2013-07-09', 'Internet jul 75% zakelijk deel', 70.24, 'xs4all', 65, '41750961', 70.24, '2013-07-09');
INSERT INTO inkoopfacturen VALUES (270, 449, 2013, '2013-08-09', 'Internet aug 75% zakelijk deel', 71.26, 'xs4all', 65, '42005730', 71.26, '2013-08-09');
INSERT INTO inkoopfacturen VALUES (271, 450, 2013, '2013-09-09', 'Internet sep 75% zakelijk deel', 85.68, 'xs4all', 65, '72258675', 85.68, '2013-09-09');
INSERT INTO inkoopfacturen VALUES (272, 451, 2013, '2013-10-09', 'Internet okt 75% zakelijk deel', 63.36, 'xs4all', 65, '42508135', 63.36, '2013-10-09');
INSERT INTO inkoopfacturen VALUES (273, 452, 2013, '2013-10-10', 'Computermaterialen', 195.89, 'altern', 60, '224160264', 195.89, '2013-10-10');
INSERT INTO inkoopfacturen VALUES (274, 453, 2013, '2013-10-17', 'Software', 29.77, 'hamrick', 66, '5619497397', 29.77, '2013-10-17');
INSERT INTO inkoopfacturen VALUES (275, 454, 2013, '2013-10-17', 'Software', 29.76, 'hamrick', 66, '5621554077', 29.76, '2013-10-17');
INSERT INTO inkoopfacturen VALUES (276, 455, 2013, '2013-10-19', 'Stiften', 15.80, 'vanbeek', 39, '1016097', 15.80, '2013-10-19');
INSERT INTO inkoopfacturen VALUES (277, 456, 2013, '2013-10-21', 'Telefoon 16-10/15-11', 33.25, 'tmobile', 10, '901202038781', 33.25, '2013-10-21');
INSERT INTO inkoopfacturen VALUES (278, 457, 2013, '2013-11-06', 'Spuitmateriaal', 277.85, 'kramer', 1, 'HE92453', 277.85, '2013-11-06');
INSERT INTO inkoopfacturen VALUES (279, 458, 2013, '2013-11-09', 'Internet nov 75% zakelijk deel', 87.38, 'xs4all', 65, '42760348', 87.38, '2013-11-09');
INSERT INTO inkoopfacturen VALUES (280, 459, 2013, '2013-11-18', 'Motorrijtuigenbelasting Nissan 17-11/16-02', 78.00, 'belasting', 11, '69414993M39', 78.00, '2013-11-18');
INSERT INTO inkoopfacturen VALUES (281, 460, 2013, '2013-11-19', 'Telefoon 16-11/15-12', 33.03, 'tmobile', 10, '901204333635', 33.03, '2013-11-19');
INSERT INTO inkoopfacturen VALUES (282, 461, 2013, '2013-11-22', 'Spuitmateriaal', 219.00, 'publikat', 63, 'RE1146822', 219.00, '2013-11-22');
INSERT INTO inkoopfacturen VALUES (283, 462, 2013, '2013-11-22', 'Spuitmateriaal', 166.50, 'publikat', 63, 'RE1146755', 166.50, '2013-11-22');
INSERT INTO inkoopfacturen VALUES (284, 463, 2013, '2013-11-22', 'Spuitmateriaal', 101.25, 'publikat', 63, 'RE1146652', 101.25, '2013-11-22');
INSERT INTO inkoopfacturen VALUES (285, 464, 2013, '2013-11-25', 'Spuitmateriaal', 109.10, 'publikat', 63, 'RE1147848', 109.10, '2013-11-25');
INSERT INTO inkoopfacturen VALUES (286, 465, 2013, '2013-12-09', 'Internet dec 75% zakelijk deel', 62.13, 'xs4all', 65, '43009098', 62.13, '2013-12-09');
INSERT INTO inkoopfacturen VALUES (287, 466, 2013, '2013-12-13', 'Nissan kleine beurt', 223.25, 'hofman', 12, '2013318', 223.25, '2013-12-13');
INSERT INTO inkoopfacturen VALUES (288, 467, 2013, '2013-12-23', 'Telefoon 16-12/15-01', 35.97, 'tmobile', 10, '901206572439', 35.97, '2013-12-23');
INSERT INTO inkoopfacturen VALUES (289, 468, 2013, '2013-12-31', 'Nissan winterbanden', 806.68, 'hofman', 12, '2013335', 806.68, '2013-12-31');
INSERT INTO inkoopfacturen VALUES (339, 559, 2014, '2014-10-04', 'Diverse lijsten', 24.00, 'vanbeek', 39, '1176316', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (340, 560, 2014, '2014-10-06', 'Nissan 11-11/11-02', 119.78, 'vandien', 7, '20307233', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (341, 561, 2014, '2014-10-09', 'Internet okt', 47.99, 'xs4all', 65, '45446171', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (342, 562, 2014, '2014-10-15', 'Div latex', 37.68, 'claasen', 20, '834584', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (343, 563, 2014, '2014-10-15', 'Doek', 44.32, 'vanbeek', 39, '1182558', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (344, 564, 2014, '2014-10-15', 'Domeinnaam graffitinaam.nl', 9.06, 'Transip', 69, '2014.0033.8711', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (345, 565, 2014, '2014-10-20', 'Telefoon 16/10-15/11', 28.99, 'tmobile', 10, '901228639766', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (346, 566, 2014, '2014-10-29', 'Diverse Katoen', 59.96, 'vanbeek', 39, '1188996', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (347, 567, 2014, '2014-11-09', 'Internet nov', 45.00, 'xs4all', 65, '45689593', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (348, 568, 2014, '2014-11-17', 'Nissan 17-11/16-02', 79.00, 'belasting', 11, '69414993M48', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (349, 569, 2014, '2014-11-20', 'Advertentieplaatsing', 5.45, 'marktplaats', 2, '141106171', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (350, 570, 2014, '2014-11-24', 'Telefoon 16/11-15/12', 28.99, 'tmobile', 10, '901230784760', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (351, 571, 2014, '2014-11-24', 'Katoen', 13.52, 'vanbeek', 39, '1202600', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (352, 572, 2014, '2014-11-24', 'Spuitmaterialen', 22.25, 'vanbeek', 39, '1202598', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (353, 573, 2014, '2014-12-01', 'Domeinnamen', 90.63, 'Transip', 69, '201400402714', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (354, 574, 2014, '2014-12-09', 'Internet dec', 49.99, 'xs4all', 65, '45932076', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (356, 576, 2014, '2014-12-11', 'Advertentieplaatsing', 5.45, 'marktplaats', 2, '141205836', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (358, 578, 2014, '2014-12-18', 'Telefoon 16/12-15/01', 29.05, 'tmobile', 10, '901232952490', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (359, 579, 2014, '2014-12-24', 'Spuitmaterialen', 227.15, 'publikat', 63, '1521948', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (360, 580, 2014, '2014-12-24', 'Spuitmaterialen', 219.26, 'publikat', 63, '1521969', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (361, 581, 2014, '2014-12-24', 'Spuitmaterialen', 61.60, 'publikat', 63, '1521981', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (362, 582, 2014, '2014-12-30', 'Spuitmaterialen', 317.85, 'kramer', 1, '97167', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (363, 583, 2014, '2014-12-10', 'Spuitmaterialen', 188.00, 'kramer', 1, '96917', 0.00, '1900-01-01');
INSERT INTO inkoopfacturen VALUES (364, 584, 2014, '2014-12-16', 'Spuitmaterialen', 167.10, 'kramer', 1, '97019', 0.00, '1900-01-01');


--
-- Data for Name: inkoopfacturenx; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO inkoopfacturenx VALUES (1, 7, 2011, '2010-11-26', 'Spuitmateriaal', 145.55, 'kramer', 1, '52229', 145.55, '2010-12-31');
INSERT INTO inkoopfacturenx VALUES (2, 8, 2011, '2010-12-07', 'Advertenties', 206.00, 'marktplaats', 2, '101100531', 206.00, '2010-12-31');
INSERT INTO inkoopfacturenx VALUES (3, 9, 2011, '2010-12-09', 'Spuitmateriaal', 166.30, 'kramer', 1, '52316', 166.30, '2010-12-31');
INSERT INTO inkoopfacturenx VALUES (4, 10, 2011, '2010-12-20', 'Kosten inschrijving', 34.04, 'kvk', 3, '241242644', 34.04, '2010-12-20');
INSERT INTO inkoopfacturenx VALUES (5, 11, 2011, '2011-01-11', 'Aanschaf Opel Combo 88BHJP', 4165.00, 'kleyn', 4, '10212291', 4165.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (6, 12, 2011, '2011-01-14', 'Software upgrade', 49.00, 'ifactors', 5, '103036674', 49.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (7, 13, 2011, '2011-01-12', 'Autoradio', 122.00, 'wehkamp', 9, '12jan', 122.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (8, 14, 2011, '2011-01-19', 'Spuitmateriaal', 213.75, 'kramer', 1, '52502', 213.75, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (9, 15, 2011, '2011-01-19', 'Telefoonkosten', 79.83, 'tmobile', 10, '901128749052', 79.83, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (10, 16, 2011, '2011-01-24', 'Wegenbelasting 11jan-7mrt', 42.00, 'belasting', 11, '69414993M1', 42.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (11, 17, 2011, '2011-01-26', 'Banden', 97.58, 'hofman', 12, '2011031', 97.58, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (12, 18, 2011, '2011-01-27', 'Multimedia materiaal', 239.55, 'mediamarkt', 6, '40358967', 239.55, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (13, 30, 2011, '2011-01-31', 'Verzekering Opel Combi - kwartaal 1', 240.94, 'vandien', 7, '13678135', 240.94, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (14, 31, 2011, '2011-03-01', 'Retour premie kwartaal 1', -68.75, 'vandien', 7, '13767248', -68.75, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (15, 32, 2011, '2011-01-31', 'Kwartaal 1 dubbel gefactureerd', 172.19, 'vandien', 7, '13678135', 172.19, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (16, 33, 2011, '2011-02-21', 'Telefoon 16-2/15-3', 34.90, 'tmobile', 10, '901130920143', 34.90, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (17, 34, 2011, '2011-02-22', 'Noppenfolie', 54.15, 'vendrig', 8, '18320', 54.15, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (18, 35, 2011, '2011-02-28', 'Poetsmateriaal', 21.94, 'polijst', 19, '100000079', 21.94, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (19, 36, 2011, '2011-02-28', '18 Glazen objecten Woonpartners', 7810.84, 'vandijken', 18, '51144', 7810.84, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (20, 37, 2011, '2011-03-01', 'Printerinkt', 85.45, '123inkt', 17, '1816393', 85.45, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (21, 38, 2011, '2011-03-01', 'Epson printer Stylus PX820FWD', 242.76, 'inmac', 16, '1099635-0100', 242.76, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (22, 39, 2011, '2011-04-11', '2e kwartaal verzekering', 167.13, 'vandien', 7, '13773165', 167.13, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (23, 40, 2011, '2011-03-07', 'Wegenbelasting 8mrt-7jun', 70.00, 'belasting', 11, '69414993M12', 70.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (24, 41, 2011, '2011-03-09', 'Verf', 57.87, 'nicolaas', 15, '748927', 57.87, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (25, 42, 2011, '2011-03-09', 'Verf', 16.79, 'nicolaas', 15, '748929', 16.79, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (26, 43, 2011, '2011-03-11', 'Materiaal workshops', 85.25, 'moonen', 14, '2110520', 85.25, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (27, 44, 2011, '2011-03-21', 'Telefoon 16-3/15-4', 34.90, 'tmobile', 10, '901133104685', 34.90, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (28, 45, 2011, '2011-03-28', 'Materialen', 461.95, 'kramer', 1, '52876', 461.95, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (29, 46, 2011, '2011-03-29', 'Reparatie Opel', 72.59, 'hofman', 12, '2011105', 72.59, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (30, 47, 2011, '2011-03-29', 'Reparatie Opel', 144.53, 'hofman', 12, '2011108', 144.53, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (31, 48, 2011, '2011-03-31', 'Boeket relatie', 35.50, 'rip', 13, '1100107', 35.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (32, 53, 2011, '2011-02-01', 'Latex verf', 47.01, 'claasen', 20, '698769', 47.01, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (33, 54, 2011, '2011-02-04', 'Bijdrage KvK 2011', 46.52, 'kvk', 3, '151488299', 46.52, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (34, 55, 2011, '2011-02-18', 'Kraamhuur Braderie Dorpstraat 14 mei', 192.00, 'dorpstraat', 21, '18-02-11', 192.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (35, 56, 2011, '2011-02-21', 'Reparatie auto', 288.28, 'hofman', 12, '2011062', 288.28, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (36, 68, 2011, '2011-04-06', 'Reparatie auto motorsteun', 200.81, 'hofman', 12, '2011116', 200.81, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (37, 69, 2011, '2011-04-13', 'Spuitmateriaal', 189.25, 'kramer', 1, '52992', 189.25, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (38, 70, 2011, '2011-04-21', 'Telefoon 16-4/15-5', 34.90, 'tmobile', 10, '901135287534', 34.90, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (39, 71, 2011, '2011-05-03', 'Huur atelier mei', 297.50, 'verweij', 22, 'VF100182', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (40, 72, 2011, '2011-05-11', 'Advertentie braderie', 59.50, 'hartvh', 23, '15450', 59.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (41, 73, 2011, '2011-05-15', 'Buizenpoten tbv tafel atelier', 208.04, 'tubecl', 24, '82628', 208.04, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (42, 74, 2011, '2011-05-26', 'Spuitmateriaal', 367.65, 'kramer', 1, '53237', 367.65, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (43, 75, 2011, '2011-06-08', 'Spuitmateriaal', 386.35, 'kramer', 1, '53327', 386.35, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (44, 76, 2011, '2011-05-24', 'Naheffing parkeerbelasting', 72.00, 'delft', 25, '4178454', 72.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (45, 77, 2011, '2011-06-06', 'Huur atelier 06', 297.50, 'verweij', 22, 'VF100198', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (46, 78, 2011, '2011-06-06', 'WA Opel 11-7/11-10', 167.13, 'vandien', 7, '14053194', 167.13, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (47, 79, 2011, '2011-06-07', 'Wegenbelasting 8-6/7-11', 70.00, 'belasting', 11, '69414993M13', 70.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (48, 80, 2011, '2011-06-11', 'PB Easynote laptop', 458.95, 'wehkamp', 9, '20110611', 458.95, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (49, 81, 2011, '2011-06-17', 'Opel grote beurt', 335.70, 'hofman', 12, '2011195', 335.70, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (50, 82, 2011, '2011-06-25', 'Senseo en toiletborstel vr atelier', 99.85, 'wehkamp', 9, '20110625', 99.85, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (51, 83, 2011, '2011-06-25', 'Ventilatoren atelier', 45.90, 'wehkamp', 9, '20110625', 45.90, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (52, 84, 2011, '2011-06-27', 'Olympus cam, Brother printer', 215.96, 'staples', 26, 'VS63059691', 215.96, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (53, 85, 2011, '2011-06-30', 'Glazen tafelblad atelier', 431.38, 'vandijken', 18, '52390', 431.38, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (54, 100, 2011, '2011-07-01', 'Huur juli', 297.50, 'verweij', 22, 'VF100215', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (55, 101, 2011, '2011-07-06', 'Internet dongle juli', 25.00, 'vodafone', 27, '175890026', 25.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (56, 102, 2011, '2011-07-07', 'Spuitmateriaal', 434.00, 'kramer', 1, '53533', 434.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (57, 103, 2011, '2011-08-01', 'Huur atelier 08', 297.50, 'verweij', 22, '100229', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (58, 104, 2011, '2011-08-09', 'Spuitmateriaal', 165.00, 'kramer', 1, '53683', 165.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (59, 105, 2011, '2011-08-11', 'Versnaperingen feest atelier', 121.96, 'sligro', 28, '5457062', 121.96, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (60, 106, 2011, '2011-08-06', 'Internet dongle aug', 25.00, 'vodafone', 27, '178515545', 25.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (61, 107, 2011, '2011-08-30', 'Harde schijven voor NAS', 179.98, 'mediamarkt', 6, '40430000', 179.98, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (62, 108, 2011, '2011-08-30', 'NAS', 283.00, 'mediamarkt', 6, '40429997', 283.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (63, 109, 2011, '2011-07-23', 'Onderhoud en reparatie', 771.57, 'hofman', 12, '2011237', 771.57, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (64, 110, 2011, '2011-09-01', 'Huur atelier 09', 297.50, 'verweij', 22, '100245', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (65, 111, 2011, '2011-09-07', 'Internet dongle sep', 25.83, 'vodafone', 27, '181195660', 25.83, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (66, 112, 2011, '2011-09-05', 'Verzekering auto 11-10/11-01', 167.13, 'vandien', 7, '14356999', 167.13, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (71, 122, 2011, '2011-10-03', 'Huur atelier oktober', 297.50, 'verweij', 22, '100260', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (68, 114, 2011, '2011-09-09', 'Wegenbelasting 8-9/7-12', 70.00, 'belasting', 11, '69414993M15', 70.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (69, 115, 2011, '2011-09-19', 'Verduisteringsdoek atelier', 58.00, 'dms', 29, '11037', 58.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (70, 116, 2011, '2011-09-27', 'Distributieriem defect', 694.86, 'hofman', 12, '2011287', 694.86, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (72, 123, 2011, '2011-09-29', 'Distributieriem Opel', 694.86, 'hofman', 12, '2011287', 694.86, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (73, 124, 2011, '2011-10-13', 'Reparatie remmen Opel', 209.57, 'hofman', 12, '70046770', 209.57, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (74, 125, 2011, '2011-10-22', 'Harde schijven', 139.98, 'mediamarkt', 6, '40445545', 139.98, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (75, 126, 2011, '2011-10-23', 'Spuitmateriaal', 305.95, 'kramer', 1, '54140', 305.95, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (76, 127, 2011, '2011-11-01', 'Huur atelier november', 297.50, 'verweij', 22, '100275', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (77, 128, 2011, '2011-11-04', 'Maskers en brandblusser', 92.34, 'engelb', 30, '185480', 92.34, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (216, 322, 2012, '2012-10-25', 'Batterijen', 45.98, 'conrad', 43, '9549073130', 45.98, '2012-10-25');
INSERT INTO inkoopfacturenx VALUES (78, 129, 2011, '2011-11-07', 'Mobiel Internet november', 50.00, 'vodafone', 27, '186575876', 50.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (79, 130, 2011, '2011-11-09', 'Advertenties', 300.00, 'marktplaats', 2, '111100374', 300.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (80, 131, 2011, '2011-11-22', 'Winterbanden en velgen Opel', 1157.26, 'hofman', 12, '2011365', 1157.26, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (81, 132, 2011, '2011-12-01', 'Huur atelier december', 297.50, 'verweij', 22, '100290', 297.50, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (82, 133, 2011, '2011-12-01', 'Gem.Delft Parkeernaheffingsaanslag', 54.20, 'diverse', 31, '4227593', 54.20, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (83, 134, 2011, '2011-12-05', 'Verzekering Opel 1e kw 2012', 140.49, 'vandien', 7, '14656262', 140.49, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (84, 135, 2011, '2011-12-07', 'Mobiel Internet december', 52.75, 'vodafone', 27, '189289585', 52.75, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (85, 136, 2011, '2011-12-09', 'Wegenbelasting Opel 8dec/7mrt', 70.00, 'belasting', 11, '69414993M17', 70.00, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (86, 137, 2011, '2011-12-16', 'Lettersjabloon', 228.48, 'bosman', 32, '7899', 228.48, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (87, 138, 2011, '2011-12-26', 'Spuitmateriaal', 289.85, 'kramer', 1, '54519', 289.85, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (88, 139, 2011, '2011-12-30', 'Kleine beurt Opel', 154.44, 'hofman', 12, '2011404', 154.44, '2011-12-31');
INSERT INTO inkoopfacturenx VALUES (89, 155, 2013, '2013-01-02', 'Spuitmateriaal', 177.40, 'kramer', 1, '21957039', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (90, 156, 2013, '2013-01-07', 'T-shirts voor bedrukking', 109.08, 'tshirts', 33, '7240', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (91, 157, 2013, '2013-01-11', 'Spuitmateriaal', 248.40, 'kramer', 1, '57141', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (92, 158, 2013, '2013-01-17', 'Reclameposters', 24.07, 'drukwerk', 34, '2013109457', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (93, 159, 2013, '2013-01-21', 'T-mobile 75% zakelijk', 19.63, 'tmobile', 10, '901181710172', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (94, 160, 2013, '2013-01-23', 'Reclameposters', 102.62, 'drukwerk', 34, '2013113939', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (95, 161, 2013, '2013-01-29', 'Spuitmateriaal', 237.50, 'kramer', 1, '57222', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (96, 162, 2013, '2013-02-01', 'Montana spuitmateriaal', 102.90, 'uc', 35, 'RLZ-1063', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (97, 163, 2013, '2013-02-07', 'Kaasdoek 280cm breed', 48.67, 'stoffen', 36, '201300326', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (98, 164, 2013, '2013-02-07', 'Advertentiepakket', 137.94, 'marktplaats', 2, '130200486', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (99, 165, 2013, '2013-02-15', 'Morsverf latex', 143.39, 'claasen', 20, '762144', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (100, 166, 2013, '2013-02-19', 'T-mobile 75% zakelijk', 21.38, 'tmobile', 10, '901183959412', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (101, 167, 2013, '2013-02-21', 'Groothoekcamera TZ25', 196.00, 'foka', 37, '3350113', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (102, 168, 2013, '2013-02-26', 'Jinbei flitser SP-200', 213.89, 'konijn', 38, '27495', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (103, 169, 2013, '2013-03-05', 'Molotow refill', 15.22, 'vanbeek', 39, '920615', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (104, 170, 2013, '2013-03-05', 'Morsverf latex', 47.80, 'claasen', 20, '763690', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (105, 171, 2013, '2013-02-25', 'Naheffinsaanslag 4e kw 2012', 50.00, 'belasting', 11, '69414996F012300', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (106, 172, 2013, '2013-03-06', 'Reclameposters', 52.51, 'drukwerk', 34, '2013140365', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (107, 173, 2013, '2013-03-08', 'Spuitmateriaal', 302.65, 'kramer', 1, 'HE90214', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (108, 174, 2013, '2013-03-11', 'Verzekering Opel Combo', 129.25, 'vandien', 7, '16216131', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (109, 175, 2013, '2013-03-11', 'Motorrijtuigenbelasting Opel Combo 8/3-7/6 2013', 72.00, 'belasting', 11, '69414993M32', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (110, 176, 2013, '2013-03-19', 'T-mobile 75% zakelijk 16/3-15/4', 35.15, 'tmobile', 10, '901186233106', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (111, 177, 2013, '2013-03-25', 'AGP 500', 140.97, 'coating', 40, '1303001', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (112, 178, 2013, '2013-03-26', 'Foto op canvas', 11.50, 'drukwerk', 34, '2013154632', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (113, 179, 2013, '2012-12-03', 'Huur atelier december 2012', 431.70, 'verweij', 22, '2012173', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (114, 192, 2013, '2013-04-01', 'Schildersdoek 120x160', 240.00, 'vend', 41, '114345373', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (115, 193, 2013, '2013-04-10', 'Drukspuit', 14.99, 'bolcom', 42, '8120632180', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (116, 194, 2013, '2013-04-11', 'Spuitmateriaal', 473.65, 'kramer', 1, 'HE90648', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (117, 195, 2013, '2013-04-11', 'Afdekfolie', 11.99, 'bolcom', 42, '8120632180', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (118, 196, 2013, '2013-04-17', 'Advertentiepakket KK', 65.34, 'marktplaats', 2, 'MP130423317', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (119, 197, 2013, '2013-04-24', 'Folders KK', 71.32, 'drukwerk', 34, 'F2013175995', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (120, 198, 2013, '2013-04-25', 'Spuitmateriaal', 166.20, 'kramer', 1, 'HE90767', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (121, 199, 2013, '2013-04-29', 'Spuitmateriaal', 96.20, 'kramer', 1, 'HE90780', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (122, 200, 2013, '2013-05-04', 'Doeken en tekenmaterialen', 92.25, 'vanbeek', 39, '947244', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (123, 201, 2013, '2013-05-17', 'Stiften', 27.74, 'vanbeek', 39, '952146', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (124, 202, 2013, '2013-05-15', 'Spuitmateriaal', 540.80, 'kramer', 1, 'HE90898', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (125, 203, 2013, '2013-05-17', 'Amsterdam parkeerheffing', 60.90, 'diverse', 31, '4000000034171391', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (126, 204, 2013, '2013-05-22', 'Kaasdoek', 27.66, 'stoffen', 36, '201301243', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (127, 205, 2013, '2013-06-08', 'Wegenbelasting Opel 8-6/7-9', 72.00, 'belasting', 11, '69414993M34', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (128, 206, 2013, '2013-07-11', 'Verzekering Opel 11-7/11-10', 129.25, 'vandien', 7, '16546675', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (129, 207, 2013, '2013-06-11', 'Latex en rollers', 50.17, 'claasen', 20, 'F773925', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (130, 208, 2013, '2013-06-24', 'Spuitmaskers', 78.89, 'engelb', 30, '254755', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (131, 209, 2013, '2013-06-23', 'Acculader en laadkabel', 81.87, 'conrad', 43, '9549690681', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (132, 210, 2013, '2013-06-25', 'Spuitmateriaal', 200.85, 'kramer', 1, 'HE91317', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (133, 211, 2013, '2013-06-26', 'Audio in auto', 119.95, 'kbaudio', 44, '100007363', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (134, 212, 2013, '2013-06-26', 'Spuitmateriaal', 162.80, 'kramer', 1, 'HE91195', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (135, 213, 2013, '2013-06-28', 'Banden Nissan', 695.00, 'profile', 45, 'M10087057', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (136, 217, 2013, '2013-06-10', 'Aanschaf Nissan Nv200 5-VKH-50', 9842.95, 'koops', 46, '63700647', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (137, 234, 2013, '2013-04-18', 'Telefoon apr 75% zakelijk', 22.16, 'tmobile', 10, '901188503627', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (138, 235, 2013, '2013-05-21', 'Telefoon mei 75% zakelijk', 24.77, 'tmobile', 10, '901190736769', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (139, 236, 2013, '2013-06-19', 'Telefoon jun 75% zakelijk', 24.77, 'tmobile', 10, '901193006754', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (240, 402, 2013, '2013-07-10', 'Spuitmateriaal', 392.00, 'kramer', 1, 'HE91472', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (244, 409, 2013, '2013-08-09', 'Spuitmaskers', 216.59, 'engelb', 30, '260590', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (248, 413, 2013, '2013-08-19', 'Acrylverf', 36.24, 'vanbeek', 39, '986655', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (252, 417, 2013, '2013-09-20', 'Computermaterialen', 172.85, 'altern', 60, '424156643', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (256, 421, 2013, '2013-09-30', 'Computermateriaal SSD schijf', 311.01, 'altern', 60, '224158708', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (260, 425, 2013, '2013-09-09', 'Molotow spuitmateriaal', 331.80, 'publikat', 63, 'RE1087838', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (241, 403, 2013, '2013-07-31', 'Ladder', 87.90, 'betaalbaar', 57, '201314642', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (245, 410, 2013, '2013-08-13', 'Spuitmateriaal', 399.60, 'kramer', 1, 'HE91752', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (249, 414, 2013, '2013-08-28', 'Kraamhuur', 20.00, 'wadcult', 59, '28082013', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (253, 418, 2013, '2013-09-21', 'Computermateriaal', 25.00, 'groenec', 61, '82599', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (257, 422, 2013, '2013-07-18', 'T-Mobile 16-7/15-8', 24.78, 'tmobile', 10, '901195252861', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (261, 426, 2013, '2013-09-24', 'Molotow spuitmateriaal Duitsland', 141.02, 'molotow', 64, '145800', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (242, 407, 2013, '2013-07-08', 'Belasting Nissan 25-06/16-08', 46.00, 'belasting', 11, '694.14.993M3.5', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (246, 411, 2013, '2013-08-14', 'Stapelkratten', 68.63, 'kruiz', 58, '4027148', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (250, 415, 2013, '2013-09-09', 'Spuitmateriaal', 295.20, 'kramer', 1, 'HE91992', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (254, 419, 2013, '2013-09-22', 'Computermateriaal', 149.99, 'mycom', 62, '2209', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (258, 423, 2013, '2013-08-20', 'T-Mobile 16-8/15-9', 24.78, 'tmobile', 10, '901197517004', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (140, 245, 2012, '2012-01-02', 'Huur atelier Boskoop jan', 305.57, 'verweij', 22, '2012014', 305.57, '2012-01-02');
INSERT INTO inkoopfacturenx VALUES (141, 246, 2012, '2012-01-07', 'Mobiel internet jan', 47.25, 'vodafone', 27, '192034269', 47.25, '2012-01-07');
INSERT INTO inkoopfacturenx VALUES (142, 247, 2012, '2012-01-18', 'Telefoon jan', 35.47, 'tmobile', 10, '901154931629', 35.47, '2012-01-18');
INSERT INTO inkoopfacturenx VALUES (143, 248, 2012, '2012-01-25', 'Spuitmaskers', 213.01, 'engelb', 30, '194755', 213.01, '2012-01-25');
INSERT INTO inkoopfacturenx VALUES (144, 249, 2012, '2012-01-26', 'Verf en linnen', 94.45, 'vanbeek', 39, '747147', 94.45, '2012-01-26');
INSERT INTO inkoopfacturenx VALUES (145, 250, 2012, '2012-01-30', 'Printerinkt', 53.95, '123inkt', 17, '2559604', 53.95, '2012-01-30');
INSERT INTO inkoopfacturenx VALUES (146, 251, 2012, '2012-01-15', 'Spuitmateriaal', 254.70, 'kramer', 1, '54622', 254.70, '2012-01-15');
INSERT INTO inkoopfacturenx VALUES (147, 252, 2012, '2012-02-02', 'Huur atelier Boskoop feb', 305.57, 'verweij', 22, '201229', 305.57, '2012-02-02');
INSERT INTO inkoopfacturenx VALUES (148, 253, 2012, '2012-02-02', 'Bijdrage KvK 2012', 41.03, 'kvk', 3, '251488299', 41.03, '2012-02-02');
INSERT INTO inkoopfacturenx VALUES (149, 254, 2012, '2012-02-07', 'Mobiel internet feb', 50.00, 'vodafone', 27, '195064547', 50.00, '2012-02-07');
INSERT INTO inkoopfacturenx VALUES (150, 255, 2012, '2012-02-11', 'Spuitmateriaal', 175.25, 'kramer', 1, '54794', 175.25, '2012-02-11');
INSERT INTO inkoopfacturenx VALUES (151, 256, 2012, '2012-02-13', 'Marktplaats advertentie', 29.00, 'marktplaats', 2, '120200554', 29.00, '2012-02-13');
INSERT INTO inkoopfacturenx VALUES (152, 257, 2012, '2012-02-20', 'Telefoon feb', 37.62, 'tmobile', 10, '901157136105', 37.62, '2012-02-20');
INSERT INTO inkoopfacturenx VALUES (153, 258, 2012, '2012-02-23', 'Verf en linnen', 161.32, 'vanbeek', 39, '759771', 161.32, '2012-02-23');
INSERT INTO inkoopfacturenx VALUES (154, 259, 2012, '2012-02-23', 'Markers', 11.82, 'vanbeek', 39, '759773', 11.82, '2012-02-23');
INSERT INTO inkoopfacturenx VALUES (155, 260, 2012, '2012-02-28', 'TomTom', 119.99, 'mediamarkt', 6, '40956138', 119.99, '2012-02-28');
INSERT INTO inkoopfacturenx VALUES (156, 261, 2012, '2012-03-05', 'Huur atelier Boskoop mrt', 424.57, 'verweij', 22, '2012044', 424.57, '2012-03-05');
INSERT INTO inkoopfacturenx VALUES (157, 262, 2012, '2012-04-11', 'Verzekering Opel 11-4/11-7', 140.49, 'vandien', 7, '14965804', 140.49, '2012-04-11');
INSERT INTO inkoopfacturenx VALUES (158, 263, 2012, '2012-03-08', 'Mobiel internet mrt', 50.00, 'vodafone', 27, '198321528', 50.00, '2012-03-08');
INSERT INTO inkoopfacturenx VALUES (159, 264, 2012, '2012-03-09', 'Motorrijtuigenbelasting Opel 8-03/7-06', 71.00, 'belasting', 11, '69474993M2', 71.00, '2012-03-09');
INSERT INTO inkoopfacturenx VALUES (160, 265, 2012, '2012-03-12', 'Spuitmateriaal', 292.65, 'kramer', 1, '54972', 292.65, '2012-03-12');
INSERT INTO inkoopfacturenx VALUES (161, 267, 2012, '2012-03-30', 'Kleine beurt Opel', 171.51, 'hofman', 12, '2012098', 171.51, '2012-03-30');
INSERT INTO inkoopfacturenx VALUES (162, 268, 2012, '2012-04-02', 'Huur atelier Boskoop apr', 424.57, 'verweij', 22, '2012059', 424.57, '2012-04-02');
INSERT INTO inkoopfacturenx VALUES (163, 269, 2012, '2012-04-09', 'Mobiel internet apr', 50.00, 'vodafone', 27, '203060518', 50.00, '2012-04-09');
INSERT INTO inkoopfacturenx VALUES (164, 270, 2012, '2012-04-13', 'Boete onjuiste opgaaf ICP 4e kw 2011', 123.00, 'belasting', 11, '69414993F011641', 123.00, '2012-04-13');
INSERT INTO inkoopfacturenx VALUES (165, 271, 2012, '2012-05-01', 'Huur atelier Boskoop mei', 424.57, 'verweij', 22, '2012075', 424.57, '2012-05-01');
INSERT INTO inkoopfacturenx VALUES (166, 272, 2012, '2012-05-02', 'Dopsleutel speciaal', 22.29, 'a1', 47, '201205139', 22.29, '2012-05-02');
INSERT INTO inkoopfacturenx VALUES (167, 273, 2012, '2012-05-09', 'Mobiel internet mei', 50.00, 'vodafone', 27, '207277187', 50.00, '2012-05-09');
INSERT INTO inkoopfacturenx VALUES (168, 274, 2012, '2012-05-12', 'Tekenmateriaal', 42.03, 'vanbeek', 39, '794001', 42.03, '2012-05-12');
INSERT INTO inkoopfacturenx VALUES (169, 275, 2012, '2012-05-25', 'Medion portable PC', 349.00, 'mediamarkt', 6, '4070672', 349.00, '2012-05-25');
INSERT INTO inkoopfacturenx VALUES (170, 276, 2012, '2012-05-17', 'Creditnota gederfde schade', -5.00, 'vodafone', 27, '209655714', -5.00, '2012-05-17');
INSERT INTO inkoopfacturenx VALUES (171, 277, 2012, '2012-04-20', 'Spuitmateriaal', 467.40, 'kramer', 1, '55182', 467.40, '2012-04-20');
INSERT INTO inkoopfacturenx VALUES (172, 278, 2012, '2012-05-14', 'Spuitmateriaal', 296.45, 'kramer', 1, '55395', 296.45, '2012-05-14');
INSERT INTO inkoopfacturenx VALUES (173, 279, 2012, '2012-05-18', 'Linnen', 23.76, 'vanbeek', 39, '795985', 23.76, '2012-05-18');
INSERT INTO inkoopfacturenx VALUES (174, 280, 2012, '2012-05-25', 'Spuitmateriaal', 133.65, 'kramer', 1, '55469', 133.65, '2012-05-25');
INSERT INTO inkoopfacturenx VALUES (175, 281, 2012, '2012-06-01', 'Huur atelier Boskoop jun', 424.57, 'verweij', 22, '2012092', 424.57, '2012-06-01');
INSERT INTO inkoopfacturenx VALUES (176, 282, 2012, '2012-06-04', 'Verzekering Opel 11-7/11-10', 140.49, 'vandien', 7, '15265917', 140.49, '2012-06-04');
INSERT INTO inkoopfacturenx VALUES (177, 283, 2012, '2012-06-11', 'Wegenbelasting Opel 8-06/7-09', 71.00, 'belasting', 11, '69414993m22', 71.00, '2012-06-11');
INSERT INTO inkoopfacturenx VALUES (178, 284, 2012, '2012-06-12', 'Spuitmateriaal', 193.90, 'kramer', 1, '55648', 193.90, '2012-06-12');
INSERT INTO inkoopfacturenx VALUES (179, 285, 2012, '2012-06-23', 'Memory stick 16G', 12.99, 'paradigit', 48, '132032426', 12.99, '2012-06-23');
INSERT INTO inkoopfacturenx VALUES (180, 286, 2012, '2012-06-25', 'Spuitmateriaal', 165.55, 'kramer', 1, '55793', 165.55, '2012-06-25');
INSERT INTO inkoopfacturenx VALUES (181, 287, 2012, '2012-07-02', 'Spuitmateriaal', 161.75, 'kramer', 1, '55837', 161.75, '2012-07-02');
INSERT INTO inkoopfacturenx VALUES (182, 288, 2012, '2012-07-10', 'Mobiel internet jul', 32.26, 'vodafone', 27, '216408394', 32.26, '2012-07-10');
INSERT INTO inkoopfacturenx VALUES (183, 289, 2012, '2012-07-11', 'Mobiel internet mei', 50.00, 'vodafone', 27, '212045361', 50.00, '2012-07-11');
INSERT INTO inkoopfacturenx VALUES (184, 290, 2012, '2012-07-11', 'Spuitmateriaal', 243.90, 'kramer', 1, '55936', 243.90, '2012-07-11');
INSERT INTO inkoopfacturenx VALUES (185, 291, 2012, '2012-07-14', 'Spuitmateriaal', 510.45, 'kramer', 1, '55948', 510.45, '2012-07-14');
INSERT INTO inkoopfacturenx VALUES (186, 292, 2012, '2012-07-16', 'Brochures Koogerkunst', 23.95, 'drukwerk', 34, '2012381133', 23.95, '2012-07-16');
INSERT INTO inkoopfacturenx VALUES (187, 293, 2012, '2012-07-16', 'Vinylstickers Koogerkunst', 26.78, 'drukwerk', 34, '2012380765', 26.78, '2012-07-16');
INSERT INTO inkoopfacturenx VALUES (188, 294, 2012, '2012-07-24', 'Telefoon jul', 35.47, 'tmobile', 10, '901168240121', 35.47, '2012-07-24');
INSERT INTO inkoopfacturenx VALUES (189, 295, 2012, '2012-07-24', 'Printerinkt', 24.45, '123inkt', 17, '2995179', 24.45, '2012-07-24');
INSERT INTO inkoopfacturenx VALUES (190, 296, 2012, '2012-07-27', 'Backup software', 49.95, 'acronis', 49, '73619285233', 49.95, '2012-07-27');
INSERT INTO inkoopfacturenx VALUES (191, 297, 2012, '2012-07-28', 'Backup software update', 35.69, 'acronis', 49, '73619315387', 35.69, '2012-07-28');
INSERT INTO inkoopfacturenx VALUES (192, 298, 2012, '2012-07-27', 'Telmachinemateriaal en stempel', 47.70, 'kroon', 50, '9016364', 47.70, '2012-07-27');
INSERT INTO inkoopfacturenx VALUES (193, 299, 2012, '2012-08-01', 'Huur atelier Boskoop aug', 424.57, 'verweij', 22, '2012121', 424.57, '2012-08-01');
INSERT INTO inkoopfacturenx VALUES (194, 300, 2012, '2012-08-02', 'Spuitmateriaal', 428.95, 'kramer', 1, '56110', 428.95, '2012-08-02');
INSERT INTO inkoopfacturenx VALUES (195, 301, 2012, '2012-08-03', 'Boekjes glazen kunstwerken Vondelflats', 1127.85, 'drukwerk', 34, '2012389598', 1127.85, '2012-08-03');
INSERT INTO inkoopfacturenx VALUES (196, 302, 2012, '2012-08-07', 'Onderhoud en banden Opel', 818.64, 'hofman', 12, '2012191', 818.64, '2012-08-07');
INSERT INTO inkoopfacturenx VALUES (197, 303, 2012, '2012-08-07', 'Werkschort', 24.40, 'surprise', 51, '598716-372169', 24.40, '2012-08-07');
INSERT INTO inkoopfacturenx VALUES (198, 304, 2012, '2012-08-08', 'Materiaal', 35.85, 'vanbeek', 39, '826289', 35.85, '2012-08-08');
INSERT INTO inkoopfacturenx VALUES (199, 305, 2012, '2012-08-08', 'Foto op canvas', 27.00, 'canvas', 52, '2012221925', 27.00, '2012-08-08');
INSERT INTO inkoopfacturenx VALUES (200, 306, 2012, '2012-08-11', 'Gereedschap', 29.90, 'buitelaar', 53, 'contant', 29.90, '2012-08-11');
INSERT INTO inkoopfacturenx VALUES (201, 307, 2012, '2012-08-20', 'Telefoon aug', 35.47, 'tmobile', 10, '901170478394', 35.47, '2012-08-20');
INSERT INTO inkoopfacturenx VALUES (202, 308, 2012, '2012-08-22', 'Spuitmateriaal', 252.00, 'kramer', 1, '56235', 252.00, '2012-08-22');
INSERT INTO inkoopfacturenx VALUES (203, 309, 2012, '2012-09-02', 'Huur atelier Boskoop sep', 424.57, 'verweij', 22, '2012134', 424.57, '2012-09-02');
INSERT INTO inkoopfacturenx VALUES (204, 310, 2012, '2012-09-04', 'Spuitmateriaal', 493.85, 'kramer', 1, '56333', 493.85, '2012-09-04');
INSERT INTO inkoopfacturenx VALUES (205, 311, 2012, '2012-08-26', 'Parkeerbelasting Ged.Burgwal', 56.60, 'denhaag', 54, '100014', 56.60, '2012-08-26');
INSERT INTO inkoopfacturenx VALUES (206, 312, 2012, '2012-09-07', 'Printerinkt', 43.45, '123inkt', 17, '3094297', 43.45, '2012-09-07');
INSERT INTO inkoopfacturenx VALUES (207, 313, 2012, '2012-09-10', 'Verzekering Opel 11-10/11-01-13', 140.49, 'vandien', 7, '15569339', 140.49, '2012-09-10');
INSERT INTO inkoopfacturenx VALUES (208, 314, 2012, '2012-09-10', 'Motorrijtuigenbelasting Opel 8-09/7-12', 71.00, 'belasting', 11, '69414993M25', 71.00, '2012-09-10');
INSERT INTO inkoopfacturenx VALUES (209, 315, 2012, '2012-09-24', 'Telefoon sep', 38.47, 'tmobile', 10, '901172713938', 38.47, '2012-09-24');
INSERT INTO inkoopfacturenx VALUES (210, 316, 2012, '2012-09-27', 'Lampen', 44.01, 'hofman', 12, '2012271', 44.01, '2012-09-27');
INSERT INTO inkoopfacturenx VALUES (211, 317, 2012, '2012-09-28', 'Linnen', 68.81, 'vanbeek', 39, '847746', 68.81, '2012-09-28');
INSERT INTO inkoopfacturenx VALUES (212, 318, 2012, '2012-10-01', 'Huur atelier Boskoop okt', 431.70, 'verweij', 22, '2012147', 431.70, '2012-10-01');
INSERT INTO inkoopfacturenx VALUES (213, 319, 2012, '2012-11-10', 'Accu startblok', 84.80, 'accu', 55, '3424427', 84.80, '2012-11-10');
INSERT INTO inkoopfacturenx VALUES (214, 320, 2012, '2012-10-10', 'Veiligheidsmateriaal', 184.28, 'engelb', 30, '222121', 184.28, '2012-10-10');
INSERT INTO inkoopfacturenx VALUES (215, 321, 2012, '2012-10-15', 'Spuitmateriaal', 284.10, 'kramer', 1, '56610', 284.10, '2012-10-15');
INSERT INTO inkoopfacturenx VALUES (217, 323, 2012, '2012-10-25', 'Flyers ', 47.93, 'drukwerk', 34, '2012438511', 47.93, '2012-10-25');
INSERT INTO inkoopfacturenx VALUES (218, 324, 2012, '2012-10-26', 'Stickers auto', 64.06, 'drukwerk', 34, '2012439962', 64.06, '2012-10-26');
INSERT INTO inkoopfacturenx VALUES (220, 326, 2012, '2012-11-01', 'Spuitmateriaal', 144.10, 'kramer', 1, '56680', 144.10, '2012-11-01');
INSERT INTO inkoopfacturenx VALUES (221, 327, 2012, '2012-11-05', 'Linnen en stiften', 157.93, 'vanbeek', 39, '865253', 157.93, '2012-11-05');
INSERT INTO inkoopfacturenx VALUES (222, 328, 2012, '2012-11-06', 'Spuitmateriaal', 209.40, 'kramer', 1, '56751', 209.40, '2012-11-06');
INSERT INTO inkoopfacturenx VALUES (223, 329, 2012, '2012-11-21', 'Marktplaats advertentiepakket', 139.95, 'marktplaats', 2, '121126169', 139.95, '2012-11-21');
INSERT INTO inkoopfacturenx VALUES (224, 330, 2012, '2012-11-22', 'Spuitmateriaal', 223.95, 'kramer', 1, '56854', 223.95, '2012-11-22');
INSERT INTO inkoopfacturenx VALUES (225, 331, 2012, '2012-12-03', 'APK, winterbanden, onderhoud', 802.68, 'hofman', 12, '2012325', 802.68, '2012-12-03');
INSERT INTO inkoopfacturenx VALUES (226, 332, 2012, '2012-12-04', 'Naheffing 3ekw', 61.56, 'belasting', 11, '69414993F012270', 61.56, '2012-12-04');
INSERT INTO inkoopfacturenx VALUES (227, 333, 2012, '2012-12-10', 'Motorrijtuigenbelasting Opel 8-12/7-03-13', 71.00, 'belasting', 11, '69414993M27', 71.00, '2012-12-10');
INSERT INTO inkoopfacturenx VALUES (228, 334, 2012, '2012-12-07', 'Markers', 44.25, 'vanbeek', 39, '882801', 44.25, '2012-12-07');
INSERT INTO inkoopfacturenx VALUES (229, 335, 2012, '2012-12-11', 'T-shirts voor promotie', 105.03, 'kleding', 56, '7181', 105.03, '2012-12-11');
INSERT INTO inkoopfacturenx VALUES (230, 336, 2012, '2012-12-12', 'Stiften retour', -12.93, 'vanbeek', 39, '884982', -12.93, '2012-12-12');
INSERT INTO inkoopfacturenx VALUES (231, 337, 2012, '2012-12-14', 'Markers', 65.15, 'vanbeek', 39, '886388', 65.15, '2012-12-14');
INSERT INTO inkoopfacturenx VALUES (232, 338, 2012, '2012-12-21', 'Spuitmateriaal', 101.76, 'uc', 35, '979', 101.76, '2012-12-21');
INSERT INTO inkoopfacturenx VALUES (233, 339, 2012, '2012-12-24', 'Huur atelier Boskoop jan 13', 441.64, 'verweij', 22, '2012182', 441.64, '2012-12-24');
INSERT INTO inkoopfacturenx VALUES (234, 340, 2012, '2012-10-18', 'Telefoon okt', 49.97, 'tmobile', 10, '901174959033', 49.97, '2012-10-18');
INSERT INTO inkoopfacturenx VALUES (235, 341, 2012, '2012-11-21', 'Telefoon nov', 39.42, 'tmobile', 10, '901177212893', 39.42, '2012-11-21');
INSERT INTO inkoopfacturenx VALUES (236, 342, 2012, '2012-12-19', 'Telefoon dec', 36.07, 'tmobile', 10, '901179454378', 36.07, '2012-12-19');
INSERT INTO inkoopfacturenx VALUES (237, 343, 2012, '2012-11-01', 'Huur atelier Boskoop nov', 431.70, 'verweij', 22, '2012160', 431.70, '2012-11-01');
INSERT INTO inkoopfacturenx VALUES (238, 382, 2012, '2012-07-01', 'Huur atelier Boskoop jul', 424.57, 'verweij', 22, '2012121', 424.57, '2012-07-01');
INSERT INTO inkoopfacturenx VALUES (239, 383, 2012, '2012-12-01', 'Huur atelier Boskoop dec', 441.64, 'verweij', 22, '2012182', 441.64, '2012-12-01');
INSERT INTO inkoopfacturenx VALUES (243, 408, 2013, '2013-08-05', 'Inktcartridges', 57.45, '123inkt', 17, '4078023', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (247, 412, 2013, '2013-08-19', 'Motorrijtuigenbelasting Nissan 17-8/16-11', 78.00, 'belasting', 11, '694.14.993.M.3.7', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (251, 416, 2013, '2013-09-12', 'Advertenties', 24.00, 'marktplaats', 2, 'MPDI130905301', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (255, 420, 2013, '2013-09-30', 'Computermateriaal koeling', 19.99, 'altern', 60, '224158711', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (259, 424, 2013, '2013-09-18', 'T-Mobile 16-9/15-10', 24.78, 'tmobile', 10, '901199780567', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (262, 441, 2013, '2013-10-01', 'Stiften en verfmaterialen', 194.09, 'vanbeek', 39, '1007059', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (263, 442, 2013, '2013-01-09', 'Internet jan 75% zakelijk deel', 70.99, 'xs4all', 65, '40162635', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (264, 443, 2013, '2013-02-09', 'Internet feb 75% zakelijk deel', 73.10, 'xs4all', 65, '40438518', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (265, 444, 2013, '2013-03-09', 'Internet mrt 75% zakelijk deel', 93.47, 'xs4all', 65, '40704328', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (266, 445, 2013, '2013-04-09', 'Internet apr 75% zakelijk deel', 69.36, 'xs4all', 65, '40967790', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (267, 446, 2013, '2013-05-09', 'Internet mei 75% zakelijk deel', 63.24, 'xs4all', 65, '41230664', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (268, 447, 2013, '2013-06-09', 'Internet jun 75% zakelijk deel', 72.98, 'xs4all', 65, '41491228', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (269, 448, 2013, '2013-07-09', 'Internet jul 75% zakelijk deel', 70.24, 'xs4all', 65, '41750961', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (270, 449, 2013, '2013-08-09', 'Internet aug 75% zakelijk deel', 71.26, 'xs4all', 65, '42005730', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (271, 450, 2013, '2013-09-09', 'Internet sep 75% zakelijk deel', 85.68, 'xs4all', 65, '72258675', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (272, 451, 2013, '2013-10-09', 'Internet okt 75% zakelijk deel', 63.36, 'xs4all', 65, '42508135', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (273, 452, 2013, '2013-10-10', 'Computermaterialen', 195.89, 'altern', 60, '224160264', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (274, 453, 2013, '2013-10-17', 'Software', 29.77, 'hamrick', 66, '5619497397', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (275, 454, 2013, '2013-10-17', 'Software', 29.76, 'hamrick', 66, '5621554077', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (276, 455, 2013, '2013-10-19', 'Stiften', 15.80, 'vanbeek', 39, '1016097', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (277, 456, 2013, '2013-10-21', 'Telefoon 16-10/15-11', 33.25, 'tmobile', 10, '901202038781', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (278, 457, 2013, '2013-11-06', 'Spuitmateriaal', 277.85, 'kramer', 1, 'HE92453', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (279, 458, 2013, '2013-11-09', 'Internet nov 75% zakelijk deel', 87.38, 'xs4all', 65, '42760348', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (280, 459, 2013, '2013-11-18', 'Motorrijtuigenbelasting Nissan 17-11/16-02', 78.00, 'belasting', 11, '69414993M39', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (281, 460, 2013, '2013-11-19', 'Telefoon 16-11/15-12', 33.03, 'tmobile', 10, '901204333635', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (282, 461, 2013, '2013-11-22', 'Spuitmateriaal', 219.00, 'publikat', 63, 'RE1146822', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (283, 462, 2013, '2013-11-22', 'Spuitmateriaal', 166.50, 'publikat', 63, 'RE1146755', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (284, 463, 2013, '2013-11-22', 'Spuitmateriaal', 101.25, 'publikat', 63, 'RE1146652', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (285, 464, 2013, '2013-11-25', 'Spuitmateriaal', 109.10, 'publikat', 63, 'RE1147848', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (286, 465, 2013, '2013-12-09', 'Internet dec 75% zakelijk deel', 62.13, 'xs4all', 65, '43009098', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (287, 466, 2013, '2013-12-13', 'Nissan kleine beurt', 223.25, 'hofman', 12, '2013318', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (288, 467, 2013, '2013-12-23', 'Telefoon 16-12/15-01', 35.97, 'tmobile', 10, '901206572439', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (289, 468, 2013, '2013-12-31', 'Nissan winterbanden', 806.68, 'hofman', 12, '2013335', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (290, 484, 2014, '2014-01-03', 'S-Video prof kabel', 17.30, 'akabels', 67, '710276', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (291, 485, 2014, '2014-01-09', 'Internet jan 25% zakelijk deel', 91.46, 'xs4all', 65, '43254092', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (292, 486, 2014, '2014-01-20', 'Mobiel jan', 46.36, 'tmobile', 10, '901208815968', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (293, 487, 2014, '2014-01-23', 'Spuitmateriaal', 39.50, 'vanbeek', 39, '1063733', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (294, 488, 2014, '2014-01-28', 'Molotow spuitmateriaal', 264.90, 'publikat', 63, 'RE1208572', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (295, 489, 2014, '2014-02-01', 'LG G2 telefoon', 436.41, 'mediamarkt', 6, '40753381', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (296, 490, 2014, '2014-02-09', 'Internet feb 25% zakelijk deel', 85.85, 'xs4all', 65, '43499507', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (297, 491, 2014, '2014-02-19', 'Mobiel feb', 60.67, 'tmobile', 10, '901211073049', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (298, 492, 2014, '2014-02-17', 'Motorrijtuigenbelasting Nissan 17-02/16-05', 79.00, 'belasting', 11, '694.14.993.M.4.2', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (299, 493, 2014, '2014-02-18', 'SSD schijf webserver', 79.84, 'altern', 60, '424179850', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (300, 494, 2014, '2014-03-01', 'Spuitmateriaal', 14.85, 'vanbeek', 39, '1082792', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (301, 495, 2014, '2014-03-09', 'Internet mrt 25% zakelijk deel', 57.62, 'xs4all', 65, '43742381', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (302, 496, 2014, '2014-03-14', 'Verf en doek', 191.83, 'vanbeek', 39, '1089195', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (303, 497, 2014, '2014-03-19', 'Mobiel mrt', 17.56, 'tmobile', 10, '901213303053', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (304, 498, 2014, '2014-03-24', 'Glaswerk tbv display', 689.64, 'vandijken', 18, '60593', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (305, 502, 2014, '2014-02-12', 'Advertentieplaatsingen jan 2014', 11.50, 'marktplaats', 2, '140205801', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (306, 503, 2014, '2014-03-10', 'Advertentieplaatsingen feb 2014', 82.29, 'marktplaats', 2, '140305458', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (307, 504, 2014, '2014-03-21', 'Wrappen Nissan', 1210.00, 'objekt', 68, '14700233', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (308, 510, 2014, '2014-04-01', 'Printerinkt', 57.45, '123inkt', 17, '4912088', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (309, 511, 2014, '2014-04-09', 'Internet 08/04-08/05', 61.27, 'xs4all', 65, '43985891', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (310, 512, 2014, '2014-04-16', 'Keuring en onderhoud', 655.66, 'hofman', 12, '2014099', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (311, 513, 2014, '2014-04-17', 'Advertentieplaatsingen', 5.45, 'marktplaats', 2, '140405677', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (312, 514, 2014, '2014-04-21', 'Mobiel 16/4-15/5', 30.83, 'tmobile', 10, '0901215510197', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (313, 515, 2014, '2014-05-09', 'Internet apr', 39.14, 'xs4all', 65, '44229892', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (314, 516, 2014, '2014-05-14', 'Spuitmaskers', 216.59, 'engelb', 30, '305931', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (315, 517, 2014, '2014-05-19', 'Motorrijtuigenbelasting 17/5-16/8', 79.00, 'belasting', 11, '69414993M44', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (316, 518, 2014, '2014-05-20', 'Telefoon mei', 34.69, 'tmobile', 10, '901217664084', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (317, 519, 2014, '2014-05-26', 'Morsverf Latex', 119.49, 'claasen', 20, '814979', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (318, 520, 2014, '2014-05-27', 'Update backup software', 16.76, 'acronis', 49, '73634548279', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (319, 521, 2014, '2014-05-27', 'Spuitmateriaal', 150.95, 'kramer', 1, '94514', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (320, 522, 2014, '2014-06-09', 'Internet jun', 45.75, 'xs4all', 65, '44470835', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (321, 523, 2014, '2014-06-18', 'Telefoon 16/6-15/7', 46.11, 'tmobile', 10, '901219904199', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (322, 532, 2014, '2014-07-09', 'Internet jul', 45.50, 'xs4all', 65, '44714386', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (323, 533, 2014, '2014-07-21', 'Telefoon 16/7-15/8', 31.51, 'tmobile', 10, '901222065965', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (324, 534, 2014, '2014-07-26', 'Asus pad 7inch', 124.00, 'mediamarkt', 6, '40808626', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (325, 535, 2014, '2014-08-06', 'Morsverf Latex', 47.80, 'claasen', 20, '824815', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (326, 536, 2014, '2014-08-09', 'Internet aug', 44.58, 'xs4all', 65, '44965935', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (327, 537, 2014, '2014-08-14', 'Nissan 11/8-11/11', 120.75, 'vandien', 7, '20157465', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (328, 538, 2014, '2014-08-18', 'Nissan 17/8-16/11', 79.00, 'belasting', 11, '69414993M46', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (329, 539, 2014, '2014-08-20', 'Telefoon 16/8-15/9', 34.73, 'tmobile', 10, '901224253796', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (330, 540, 2014, '2014-08-21', 'Nieuwe Accu Nissan', 140.36, 'hofman', 12, '201424', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (331, 541, 2014, '2014-08-30', 'Nissan Kleine beurt', 339.80, 'hofman', 12, '2014211', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (332, 542, 2014, '2014-09-08', 'Aanpassing schadevrije jaren van 74 naar 72%', 8.51, 'vandien', 7, '20168476', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (333, 543, 2014, '2014-09-09', 'Internet sep', 49.99, 'xs4all', 65, '45205585', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (334, 544, 2014, '2014-09-20', 'Linnen', 70.75, 'vanbeek', 39, '1169725', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (335, 545, 2014, '2014-09-20', 'Acryl', 12.29, 'vanbeek', 39, '1169731', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (336, 546, 2014, '2014-09-22', 'Telefoon 16/9-15/10', 28.99, 'tmobile', 10, '901226471417', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (337, 547, 2014, '2014-09-25', 'Spuitmateriaal', 171.94, 'publikat', 63, 'RE1425857', 0.00, '1900-01-01');
INSERT INTO inkoopfacturenx VALUES (338, 548, 2014, '2014-09-27', 'Linnen ruilen en bijbetalen', 90.44, 'vanbeek', 39, '1173616', 0.00, '1900-01-01');


--
-- Data for Name: journaal; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO journaal VALUES (1, 2, 2010, '2010-12-06', 4, 'verkoop', 'Schildering logo in restaurant', 0.00, 'elgusto', '29134', '', '');
INSERT INTO journaal VALUES (2, 3, 2010, '2010-12-10', 4, 'verkoop', 'Griffiti Workshop Nederlek', 0.00, 'midholl', '29135', '', '');
INSERT INTO journaal VALUES (3, 4, 2011, '2011-01-09', 1, 'verkoop', 'Aanbetaling 18 kunstobjecten op glas', 0.00, 'woonp', '2011001', '', '');
INSERT INTO journaal VALUES (4, 5, 2011, '2011-01-18', 1, 'verkoop', 'Schilderij', 0.00, 'particulier', '2011002', '', '');
INSERT INTO journaal VALUES (5, 6, 2011, '2011-01-19', 1, 'verkoop', 'Jongeren workshops', 0.00, 'midholl', '2011003', '', '');
INSERT INTO journaal VALUES (6, 7, 2011, '2011-01-27', 1, 'verkoop', 'Materiaalkosten workshop 13 mei', 0.00, 'cenf', '2011004', '', '');
INSERT INTO journaal VALUES (7, 8, 2010, '2010-11-26', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '52229', '', '');
INSERT INTO journaal VALUES (8, 9, 2010, '2010-12-07', 4, 'inkoop', 'Advertenties', 0.00, 'marktplaats', '101100531', '', '');
INSERT INTO journaal VALUES (9, 10, 2010, '2010-12-09', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '52316', '', '');
INSERT INTO journaal VALUES (10, 11, 2010, '2010-12-20', 4, 'inkoop', 'Kosten inschrijving', 0.00, 'kvk', '241242644', '', '');
INSERT INTO journaal VALUES (11, 12, 2011, '2011-01-11', 1, 'inkoop', 'Aanschaf Opel Combo 88-BH-JP', 0.00, 'kleyn', '10212291', '', '');
INSERT INTO journaal VALUES (12, 13, 2011, '2011-01-14', 1, 'inkoop', 'Software upgrade', 0.00, 'ifactors', '103036674', '', '');
INSERT INTO journaal VALUES (13, 14, 2011, '2011-01-12', 1, 'inkoop', 'Autoradio', 0.00, 'wehkamp', '12jan', '', '');
INSERT INTO journaal VALUES (14, 15, 2011, '2011-01-19', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '52502', '', '');
INSERT INTO journaal VALUES (15, 16, 2011, '2011-01-19', 1, 'inkoop', 'Telefoon 16-1/15-2', 0.00, 'tmobile', '901128749052', '', '');
INSERT INTO journaal VALUES (16, 17, 2011, '2011-01-24', 1, 'inkoop', 'Wegenbelasting 11-1/7-3', 0.00, 'belasting', '69414993M1', '', '');
INSERT INTO journaal VALUES (17, 18, 2011, '2011-01-26', 1, 'inkoop', 'Banden', 0.00, 'hofman', '2011031', '', '');
INSERT INTO journaal VALUES (18, 19, 2011, '2011-01-27', 1, 'inkoop', 'Multimedia materiaal', 0.00, 'mediamarkt', '40358967', '', '');
INSERT INTO journaal VALUES (19, 20, 2011, '2011-01-31', 1, 'kas', 'Kasblad 01', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (20, 12, 2010, '2010-12-31', 4, 'kas', 'Kasblad 3112', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (21, 1, 2010, '2010-12-16', 0, 'begin', 'Beginbalans', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (22, 13, 2010, '2010-12-31', 4, 'memo', 'BTW egalisatie boeking periode 4', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (23, 21, 2011, '2011-02-10', 1, 'verkoop', 'Schildering paneel', 0.00, 'taxione', '2011005', '', '');
INSERT INTO journaal VALUES (24, 22, 2011, '2011-02-12', 1, 'verkoop', 'Workshop Schoonhoven', 0.00, 'midholl', '2011006', '', '');
INSERT INTO journaal VALUES (25, 23, 2011, '2011-02-16', 1, 'verkoop', 'Workshop opening JOP Zuidplas', 0.00, 'midholl', '2011007', '', '');
INSERT INTO journaal VALUES (26, 24, 2011, '2011-02-24', 1, 'verkoop', 'Restant 18 kunstobjecten in glas', 0.00, 'woonp', '2011008', '', '');
INSERT INTO journaal VALUES (27, 14, 2010, '2010-12-31', 4, 'kas', 'Betaling Crediteuren dec 2010', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (28, 15, 2010, '2010-12-31', 4, 'kas', 'Ontvangen debiteuren dec 2010', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (29, 16, 2010, '2010-12-31', 4, 'memo', 'Kilometerkosten dec 2010', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (30, 25, 2011, '2011-01-31', 1, 'inkoop', 'Verzekering Opel Combi - kwartaal 1', 0.00, 'vandien', '13678135', '', '');
INSERT INTO journaal VALUES (31, 26, 2011, '2011-03-01', 1, 'inkoop', 'Retour premie kwartaal 1', 0.00, 'vandien', '13767248', '', '');
INSERT INTO journaal VALUES (32, 27, 2011, '2011-01-31', 1, 'inkoop', 'Kwartaal 1 dubbel gefactureerd', 0.00, 'vandien', '13678135', '', '');
INSERT INTO journaal VALUES (33, 28, 2011, '2011-02-21', 1, 'inkoop', 'Telefoon 16-2/15-3', 0.00, 'tmobile', '901130920143', '', '');
INSERT INTO journaal VALUES (34, 29, 2011, '2011-02-22', 1, 'inkoop', 'Noppenfolie', 0.00, 'vendrig', '18320', '', '');
INSERT INTO journaal VALUES (35, 30, 2011, '2011-02-28', 1, 'inkoop', 'Poetsmateriaal', 0.00, 'polijst', '100000079', '', '');
INSERT INTO journaal VALUES (36, 31, 2011, '2011-02-28', 1, 'inkoop', '18 Glazen objecten Woonpartners', 0.00, 'vandijken', '51144', '', '');
INSERT INTO journaal VALUES (37, 32, 2011, '2011-03-01', 1, 'inkoop', 'Printerinkt', 0.00, '123inkt', '1816393', '', '');
INSERT INTO journaal VALUES (38, 33, 2011, '2011-03-01', 1, 'inkoop', 'Epson printer Stylus PX820FWD', 0.00, 'inmac', '1099635-0100', '', '');
INSERT INTO journaal VALUES (39, 34, 2011, '2011-04-11', 1, 'inkoop', '2e kwartaal verzekering', 0.00, 'vandien', '13773165', '', '');
INSERT INTO journaal VALUES (40, 35, 2011, '2011-03-07', 1, 'inkoop', 'Wegenbelasting 8-3/7-6', 0.00, 'belasting', '69414993M12', '', '');
INSERT INTO journaal VALUES (41, 36, 2011, '2011-03-09', 1, 'inkoop', 'Verf', 0.00, 'nicolaas', '748927', '', '');
INSERT INTO journaal VALUES (42, 37, 2011, '2011-03-09', 1, 'inkoop', 'Verf', 0.00, 'nicolaas', '748929', '', '');
INSERT INTO journaal VALUES (43, 38, 2011, '2011-03-11', 1, 'inkoop', 'Materiaal workshops', 0.00, 'moonen', '2110520', '', '');
INSERT INTO journaal VALUES (44, 39, 2011, '2011-03-21', 1, 'inkoop', 'Telefoon 16-3/15-4', 0.00, 'tmobile', '901133104685', '', '');
INSERT INTO journaal VALUES (45, 40, 2011, '2011-03-28', 1, 'inkoop', 'Materialen', 0.00, 'kramer', '52876', '', '');
INSERT INTO journaal VALUES (46, 41, 2011, '2011-03-29', 1, 'inkoop', 'Reparatie Opel', 11.59, 'hofman', '2011105', '', '');
INSERT INTO journaal VALUES (47, 42, 2011, '2011-03-29', 1, 'inkoop', 'Reparatie Opel', 0.00, 'hofman', '2011108', '', '');
INSERT INTO journaal VALUES (48, 43, 2011, '2011-03-31', 1, 'inkoop', 'Boeket relatie', 0.00, 'rip', '1100107', '', '');
INSERT INTO journaal VALUES (49, 44, 2011, '2011-02-28', 1, 'kas', 'Kasblad 2', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (50, 45, 2011, '2011-03-31', 1, 'kas', 'Kasblad 03', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (51, 46, 2011, '2011-03-20', 1, 'verkoop', 'Muurschildering Dico en Bo', 0.00, 'particulier', '2011009', '', '');
INSERT INTO journaal VALUES (52, 47, 2011, '2011-03-31', 1, 'verkoop', 'Schilderij Stones afscheidscadeau', 0.00, 'mwh', '2011010', '', '');
INSERT INTO journaal VALUES (53, 48, 2011, '2011-02-01', 1, 'inkoop', 'Latex verf', 0.00, 'claasen', '698769', '', '');
INSERT INTO journaal VALUES (54, 49, 2011, '2011-02-04', 1, 'inkoop', 'Bijdrage KvK 2011', 0.00, 'kvk', '151488299', '', '');
INSERT INTO journaal VALUES (55, 50, 2011, '2011-02-18', 1, 'inkoop', 'Kraamhuur Braderie Dorpstraat 14 mei', 0.00, 'dorpstraat', '18-02-11', '', '');
INSERT INTO journaal VALUES (56, 51, 2011, '2011-02-21', 1, 'inkoop', 'Reparatie auto', 0.00, 'hofman', '2011062', '', '');
INSERT INTO journaal VALUES (57, 52, 2011, '2011-03-31', 1, 'kas', 'Kasblad 03a', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (58, 53, 2011, '2011-03-31', 1, 'memo', 'Derving BTW op inkoop partiele materialen 1e kw', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (87, 82, 2011, '2011-03-31', 1, 'memo', 'BTW egalisatie boeking periode 1', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO journaal VALUES (60, 55, 2011, '2011-04-27', 2, 'verkoop', 'Schildering Willie File Voorstraat 26', 0.00, 'ipse', '2011011', '', '');
INSERT INTO journaal VALUES (61, 56, 2011, '2011-05-05', 2, 'verkoop', 'Muurschildering Zuidplas', 0.00, 'woonp', '2011012', '', '');
INSERT INTO journaal VALUES (62, 57, 2011, '2011-05-05', 2, 'verkoop', 'Muurschildering Zuidplas ingang2', 0.00, 'woonp', '2011013', '', '');
INSERT INTO journaal VALUES (63, 58, 2011, '2011-05-16', 2, 'verkoop', 'Materialen tbv workshops', 0.00, 'cenf', '2011014', '', '');
INSERT INTO journaal VALUES (64, 59, 2011, '2011-05-31', 2, 'verkoop', 'Schildering op paneel', 0.00, 'midholl', '2011015', '', '');
INSERT INTO journaal VALUES (65, 60, 2011, '2011-06-01', 2, 'verkoop', 'Muurschildering goPasta', 0.00, 'gopdelft', '2011016', '', '');
INSERT INTO journaal VALUES (66, 61, 2011, '2011-06-02', 2, 'verkoop', 'Ontwerp character dready dreadzz', 0.00, 'dread', '2011017', '', '');
INSERT INTO journaal VALUES (67, 62, 2011, '2011-06-23', 2, 'verkoop', 'Muurschildering goPasta veenendaal', 0.00, 'rood', '2011017', '', '');
INSERT INTO journaal VALUES (68, 63, 2011, '2011-04-06', 2, 'inkoop', 'Reparatie auto motorsteun', 0.00, 'hofman', '2011116', '', '');
INSERT INTO journaal VALUES (69, 64, 2011, '2011-04-13', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '52992', '', '');
INSERT INTO journaal VALUES (70, 65, 2011, '2011-04-21', 2, 'inkoop', 'Telefoon 16-4/15-5', 0.00, 'tmobile', '901135287534', '', '');
INSERT INTO journaal VALUES (71, 66, 2011, '2011-05-03', 2, 'inkoop', 'Huur atelier 05', 0.00, 'verweij', 'VF100182', '', '');
INSERT INTO journaal VALUES (72, 67, 2011, '2011-05-11', 2, 'inkoop', 'Advertentie braderie', 0.00, 'hartvh', '15450', '', '');
INSERT INTO journaal VALUES (73, 68, 2011, '2011-05-15', 2, 'inkoop', 'Buizenpoten tbv tafel atelier', 0.00, 'tubecl', '82628', '', '');
INSERT INTO journaal VALUES (74, 69, 2011, '2011-05-26', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '53237', '', '');
INSERT INTO journaal VALUES (75, 70, 2011, '2011-06-08', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '53327', '', '');
INSERT INTO journaal VALUES (76, 71, 2011, '2011-05-24', 2, 'inkoop', 'Naheffing parkeerbelasting', 0.00, 'delft', '4178454', '', '');
INSERT INTO journaal VALUES (77, 72, 2011, '2011-06-06', 2, 'inkoop', 'Huur atelier 06', 0.00, 'verweij', 'VF100198', '', '');
INSERT INTO journaal VALUES (78, 73, 2011, '2011-06-06', 2, 'inkoop', 'WA Opel 11-7/11-10', 0.00, 'vandien', '14053194', '', '');
INSERT INTO journaal VALUES (79, 74, 2011, '2011-06-07', 2, 'inkoop', 'Wegenbelasting 8-6/7-11', 0.00, 'belasting', '69414993M13', '', '');
INSERT INTO journaal VALUES (80, 75, 2011, '2011-06-11', 2, 'inkoop', 'PB Easynote laptop', 0.00, 'wehkamp', '20110611', '', '');
INSERT INTO journaal VALUES (81, 76, 2011, '2011-06-17', 2, 'inkoop', 'Opel grote beurt', 0.00, 'hofman', '2011195', '', '');
INSERT INTO journaal VALUES (82, 77, 2011, '2011-06-25', 2, 'inkoop', 'Senseo en toiletborstel vr atelier', 0.00, 'wehkamp', '20110625', '', '');
INSERT INTO journaal VALUES (83, 78, 2011, '2011-06-25', 2, 'inkoop', 'Ventilatoren atelier', 0.00, 'wehkamp', '20110625', '', '');
INSERT INTO journaal VALUES (84, 79, 2011, '2011-06-27', 2, 'inkoop', 'Olympus cam, Brother printer', 0.00, 'staples', 'VS63059691', '', '');
INSERT INTO journaal VALUES (85, 80, 2011, '2011-06-30', 2, 'inkoop', 'Glazen tafelblad atelier', 0.00, 'vandijken', '52390', '', '');
INSERT INTO journaal VALUES (86, 81, 2011, '2011-06-30', 2, 'kas', 'Kasblad 04', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (88, 83, 2011, '2011-06-25', 2, 'verkoop', 'Muurschildering Daen, i.o. Jeroen Verboom', 0.00, 'particulier', '2011018', '', '');
INSERT INTO journaal VALUES (89, 84, 2011, '2011-06-29', 2, 'verkoop', 'Muurschildering Rafiq iov Erik van Dam', 0.00, 'particulier', '2011019', '', '');
INSERT INTO journaal VALUES (90, 85, 2011, '2011-06-29', 2, 'verkoop', 'Schilderij en muursch Janet Flierman', 0.00, 'particulier', '2011020', '', '');
INSERT INTO journaal VALUES (91, 86, 2011, '2011-06-30', 2, 'memo', 'BTW egalisatie boeking periode 2', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO journaal VALUES (92, 87, 2011, '2011-07-24', 3, 'verkoop', 'Schildering Wiebine', 0.00, 'ipse', '2011021', '', '');
INSERT INTO journaal VALUES (93, 88, 2011, '2011-08-18', 3, 'verkoop', 'Muurschildering', 0.00, 'stek', '2011022', '', '');
INSERT INTO journaal VALUES (94, 89, 2011, '2011-08-19', 3, 'verkoop', 'Schildering Benjamin', 0.00, 'ipse', '2011024', '', '');
INSERT INTO journaal VALUES (95, 90, 2011, '2011-08-18', 3, 'verkoop', 'Schilderij We Will Rock You', 0.00, 'vdEnde', '2011023', '', '');
INSERT INTO journaal VALUES (96, 91, 2011, '2011-08-26', 3, 'verkoop', 'Muurschildering binnenmuur', 0.00, 'kruimels', '2011025', '', '');
INSERT INTO journaal VALUES (97, 92, 2011, '2011-09-01', 3, 'verkoop', 'Menukaart', 0.00, 'kruimels', '2011026', '', '');
INSERT INTO journaal VALUES (98, 93, 2011, '2011-09-19', 4, 'verkoop', 'Muurschildering goPasta Bremen', 0.00, 'gopbremen', '2011027', '', '');
INSERT INTO journaal VALUES (99, 94, 2011, '2011-09-19', 3, 'verkoop', 'Schilderij Anne-Fleur Derks', 0.00, 'particulier', '2011028', '', '');
INSERT INTO journaal VALUES (100, 95, 2011, '2011-07-01', 3, 'inkoop', 'Huur atelier 07', 0.00, 'verweij', 'VF100215', '', '');
INSERT INTO journaal VALUES (101, 96, 2011, '2011-07-06', 3, 'inkoop', 'Internet dongle juli', 0.00, 'vodafone', '175890026', '', '');
INSERT INTO journaal VALUES (102, 97, 2011, '2011-07-07', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '53533', '', '');
INSERT INTO journaal VALUES (103, 98, 2011, '2011-08-01', 3, 'inkoop', 'Huur atelier 08', 0.00, 'verweij', '100229', '', '');
INSERT INTO journaal VALUES (104, 99, 2011, '2011-08-09', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '53683', '', '');
INSERT INTO journaal VALUES (105, 100, 2011, '2011-08-11', 3, 'inkoop', 'Versnaperingen feest atelier', 0.00, 'sligro', '5457062', '', '');
INSERT INTO journaal VALUES (106, 101, 2011, '2011-08-06', 3, 'inkoop', 'Internet dongle aug', 0.00, 'vodafone', '178515545', '', '');
INSERT INTO journaal VALUES (107, 102, 2011, '2011-08-30', 3, 'inkoop', 'Harde schijven voor NAS', 0.00, 'mediamarkt', '40430000', '', '');
INSERT INTO journaal VALUES (108, 103, 2011, '2011-08-30', 3, 'inkoop', 'NAS', 0.00, 'mediamarkt', '40429997', '', '');
INSERT INTO journaal VALUES (109, 104, 2011, '2011-07-23', 3, 'inkoop', 'Onderhoud en reparatie', 0.00, 'hofman', '2011237', '', '');
INSERT INTO journaal VALUES (110, 105, 2011, '2011-09-01', 3, 'inkoop', 'Huur atelier 09', 0.00, 'verweij', '100245', '', '');
INSERT INTO journaal VALUES (111, 106, 2011, '2011-09-07', 3, 'inkoop', 'Internet dongle sep', 0.00, 'vodafone', '181195660', '', '');
INSERT INTO journaal VALUES (112, 107, 2011, '2011-09-05', 3, 'inkoop', 'Verzekering auto 11-10/11-01', 0.00, 'vandien', '14356999', '', '');
INSERT INTO journaal VALUES (120, 115, 2011, '2011-09-30', 3, 'memo', 'BTW derving boekingsperiode 3', 0.00, '', '', 'btwcorrectie', 'Automatische boeking BTW derving getriggerd door BTW consolidatie van periode 3');
INSERT INTO journaal VALUES (114, 109, 2011, '2011-09-09', 3, 'inkoop', 'Wegenbelasting 8-9/7-12', 0.00, 'belasting', '69414993M15', '', '');
INSERT INTO journaal VALUES (115, 110, 2011, '2011-09-19', 3, 'inkoop', 'Verduisteringsdoek atelier', 0.00, 'dms', '11037', '', '');
INSERT INTO journaal VALUES (116, 111, 2011, '2011-09-27', 3, 'inkoop', 'Distributieriem defect', 0.00, 'hofman', '2011287', '', '');
INSERT INTO journaal VALUES (117, 112, 2011, '2011-07-31', 3, 'kas', 'Kasblad 07', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (118, 113, 2011, '2011-08-31', 3, 'kas', 'Kasblad 08', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (119, 114, 2011, '2011-09-30', 3, 'kas', 'Kasblad 09', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (121, 116, 2011, '2011-09-30', 3, 'memo', 'BTW egalisatie boekingsperiode 3', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO journaal VALUES (122, 117, 2011, '2011-10-03', 4, 'inkoop', 'Huur atelier oktober', 0.00, 'verweij', '100260', '', '');
INSERT INTO journaal VALUES (123, 118, 2011, '2011-09-29', 4, 'inkoop', 'Distributieriem Opel', 0.00, 'hofman', '2011287', '', '');
INSERT INTO journaal VALUES (124, 119, 2011, '2011-10-13', 4, 'inkoop', 'Reparatie remmen Opel', 0.00, 'hofman', '70046770', '', '');
INSERT INTO journaal VALUES (125, 120, 2011, '2011-10-22', 4, 'inkoop', 'Harde schijven', 0.00, 'mediamarkt', '40445545', '', '');
INSERT INTO journaal VALUES (126, 121, 2011, '2011-10-23', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '54140', '', '');
INSERT INTO journaal VALUES (127, 122, 2011, '2011-11-01', 4, 'inkoop', 'Huur atelier november', 0.00, 'verweij', '100275', '', '');
INSERT INTO journaal VALUES (128, 123, 2011, '2011-11-04', 4, 'inkoop', 'Maskers en brandblusser', 0.00, 'engelb', '185480', '', '');
INSERT INTO journaal VALUES (129, 124, 2011, '2011-11-07', 4, 'inkoop', 'Mobiel Internet november', 0.00, 'vodafone', '186575876', '', '');
INSERT INTO journaal VALUES (130, 125, 2011, '2011-11-09', 4, 'inkoop', 'Advertenties', 0.00, 'marktplaats', '111100374', '', '');
INSERT INTO journaal VALUES (131, 126, 2011, '2011-11-22', 4, 'inkoop', 'Winterbanden en velgen Opel', 0.00, 'hofman', '2011365', '', '');
INSERT INTO journaal VALUES (132, 127, 2011, '2011-12-01', 4, 'inkoop', 'Huur atelier december', 0.00, 'verweij', '100290', '', '');
INSERT INTO journaal VALUES (133, 128, 2011, '2011-12-01', 4, 'inkoop', 'Gem.Delft Parkeernaheffingsaanslag', 0.00, 'diverse', '4227593', '', '');
INSERT INTO journaal VALUES (134, 129, 2011, '2011-12-05', 4, 'inkoop', 'Verzekering Opel 1e kw 2012', 0.00, 'vandien', '14656262', '', '');
INSERT INTO journaal VALUES (135, 130, 2011, '2011-12-07', 4, 'inkoop', 'Mobiel Internet december', 0.00, 'vodafone', '189289585', '', '');
INSERT INTO journaal VALUES (136, 131, 2011, '2011-12-09', 4, 'inkoop', 'Wegenbelasting Opel 8dec/7mrt', 0.00, 'belasting', '69414993M17', '', '');
INSERT INTO journaal VALUES (137, 132, 2011, '2011-12-16', 4, 'inkoop', 'Lettersjabloon', 0.00, 'bosman', '7899', '', '');
INSERT INTO journaal VALUES (138, 133, 2011, '2011-12-26', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '54519', '', '');
INSERT INTO journaal VALUES (139, 134, 2011, '2011-12-30', 4, 'inkoop', 'Kleine beurt Opel', 0.00, 'hofman', '2011404', '', '');
INSERT INTO journaal VALUES (140, 135, 2011, '2011-10-31', 4, 'kas', 'Kasblad oktober', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (141, 136, 2011, '2011-10-17', 4, 'verkoop', 'Schutting reclame', 0.00, 'spruyt', '2011029', '', '');
INSERT INTO journaal VALUES (142, 137, 2011, '2011-11-23', 4, 'verkoop', 'Reclameschildering Irenetunnel', 0.00, 'gopdelft', '2011030', '', '');
INSERT INTO journaal VALUES (143, 138, 2011, '2011-12-13', 4, 'verkoop', 'Muurschildering Kerkweg Oost en Onthulling', 0.00, 'woonp', '2011031', '', '');
INSERT INTO journaal VALUES (144, 139, 2011, '2011-12-30', 4, 'verkoop', 'Schilderij', 0.00, 'JJB', '2011032', '', '');
INSERT INTO journaal VALUES (145, 140, 2011, '2011-11-30', 4, 'kas', 'Kasblad november', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (146, 141, 2011, '2011-12-31', 4, 'kas', 'Kasblad december', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (147, 142, 2011, '2011-12-31', 4, 'memo', 'BTW Privegebruik eigen auto', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (148, 143, 2011, '2011-12-31', 4, 'memo', 'BTW 5d vermindering inboeken', 0.00, '', '', '5dregeling', 'Automatische boeking van vermindering volgens BTW regeling voor kleinondernemers');
INSERT INTO journaal VALUES (149, 144, 2011, '2011-12-31', 4, 'memo', 'BTW derving boekingsperiode 4', 0.00, '', '', 'btwcorrectie', 'Automatische boeking BTW derving getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (150, 145, 2011, '2011-12-31', 4, 'memo', 'BTW egalisatie boekingsperiode 4', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (151, 1, 2011, '2011-01-01', 0, 'begin', 'Beginbalans', 0.00, '', '', 'begin', 'Automatische boeking van beginbalans in het nieuwe boekjaar');
INSERT INTO journaal VALUES (152, 146, 2011, '2011-12-31', 5, 'memo', 'Privegebruik Open Combo 25%', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (153, 147, 2011, '2011-12-31', 5, 'memo', 'Saldi prive betaald/ontvangen', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (154, 1, 2012, '2012-01-01', 0, 'begin', 'Beginbalans', 0.00, '', '', 'begin', 'Automatische boeking van beginbalans in het nieuwe boekjaar');
INSERT INTO journaal VALUES (155, 2, 2013, '2013-01-02', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '21957039', '', '');
INSERT INTO journaal VALUES (156, 3, 2013, '2013-01-07', 1, 'inkoop', 'T-shirts voor bedrukking', 0.00, 'tshirts', '7240', '', '');
INSERT INTO journaal VALUES (157, 4, 2013, '2013-01-11', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '57141', '', '');
INSERT INTO journaal VALUES (158, 5, 2013, '2013-01-17', 1, 'inkoop', 'Reclameposters', 0.00, 'drukwerk', '2013109457', '', '');
INSERT INTO journaal VALUES (159, 6, 2013, '2013-01-21', 1, 'inkoop', 'T-mobile 75% zakelijk', 0.00, 'tmobile', '901181710172', '', '');
INSERT INTO journaal VALUES (160, 7, 2013, '2013-01-23', 1, 'inkoop', 'Reclameposters', 0.00, 'drukwerk', '2013113939', '', '');
INSERT INTO journaal VALUES (161, 8, 2013, '2013-01-29', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '57222', '', '');
INSERT INTO journaal VALUES (162, 9, 2013, '2013-02-01', 1, 'inkoop', 'Montana spuitmateriaal', 0.00, 'uc', 'RLZ-1063', '', '');
INSERT INTO journaal VALUES (163, 10, 2013, '2013-02-07', 1, 'inkoop', 'Kaasdoek 280cm breed', 0.00, 'stoffen', '201300326', '', '');
INSERT INTO journaal VALUES (164, 11, 2013, '2013-02-07', 1, 'inkoop', 'Advertentiepakket', 0.00, 'marktplaats', '130200486', '', '');
INSERT INTO journaal VALUES (165, 12, 2013, '2013-02-15', 1, 'inkoop', 'Morsverf latex', 0.00, 'claasen', '762144', '', '');
INSERT INTO journaal VALUES (166, 13, 2013, '2013-02-19', 1, 'inkoop', 'T-mobile 75% zakelijk', 0.00, 'tmobile', '901183959412', '', '');
INSERT INTO journaal VALUES (167, 14, 2013, '2013-02-21', 1, 'inkoop', 'Groothoekcamera TZ25', 0.00, 'foka', '3350113', '', '');
INSERT INTO journaal VALUES (168, 15, 2013, '2013-02-26', 1, 'inkoop', 'Jinbei flitser SP-200', 0.00, 'konijn', '27495', '', '');
INSERT INTO journaal VALUES (169, 16, 2013, '2013-03-05', 1, 'inkoop', 'Molotow refill', 0.00, 'vanbeek', '920615', '', '');
INSERT INTO journaal VALUES (170, 17, 2013, '2013-03-05', 1, 'inkoop', 'Morsverf latex', 0.00, 'claasen', '763690', '', '');
INSERT INTO journaal VALUES (171, 18, 2013, '2013-02-25', 1, 'inkoop', 'Naheffinsaanslag 4e kw 2012', 0.00, 'belasting', '69414996F012300', '', '');
INSERT INTO journaal VALUES (172, 19, 2013, '2013-03-06', 1, 'inkoop', 'Reclameposters', 0.00, 'drukwerk', '2013140365', '', '');
INSERT INTO journaal VALUES (173, 20, 2013, '2013-03-08', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE90214', '', '');
INSERT INTO journaal VALUES (174, 21, 2013, '2013-03-11', 1, 'inkoop', 'Verzekering Opel Combo', 0.00, 'vandien', '16216131', '', '');
INSERT INTO journaal VALUES (175, 22, 2013, '2013-03-11', 1, 'inkoop', 'Motorrijtuigenbelasting Opel Combo 8/3-7/6 2013', 0.00, 'belasting', '69414993M32', '', '');
INSERT INTO journaal VALUES (176, 23, 2013, '2013-03-19', 1, 'inkoop', 'T-mobile 75% zakelijk 16/3-15/4', 0.00, 'tmobile', '901186233106', '', '');
INSERT INTO journaal VALUES (177, 24, 2013, '2013-03-25', 1, 'inkoop', 'AGP 500', 0.00, 'coating', '1303001', '', '');
INSERT INTO journaal VALUES (178, 25, 2013, '2013-03-26', 1, 'inkoop', 'Foto op canvas', 0.00, 'drukwerk', '2013154632', '', '');
INSERT INTO journaal VALUES (179, 26, 2013, '2012-12-03', 1, 'inkoop', 'Huur atelier december 2012', 0.00, 'verweij', '2012173', '', '');
INSERT INTO journaal VALUES (180, 27, 2013, '2013-01-01', 1, 'kas', 'Bonnen 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (181, 28, 2013, '2013-01-14', 1, 'verkoop', 'Muurschildering FC Utrecht, Zwammerdam', 0.00, 'ipse', '2013001', '', '');
INSERT INTO journaal VALUES (182, 29, 2013, '2013-02-20', 1, 'verkoop', 'Muurschilderingen Alexandertunnel, 25%', 0.00, 'bomenwijk', '2013002', '', '');
INSERT INTO journaal VALUES (183, 30, 2013, '2013-02-27', 1, 'verkoop', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', 0.00, 'bomenwijk', '2013003', '', '');
INSERT INTO journaal VALUES (184, 31, 2013, '2013-03-06', 1, 'verkoop', 'Muurschildering GoPasta Antwerpen', 0.00, 'gopantw', '2013004', '', '');
INSERT INTO journaal VALUES (185, 32, 2013, '2013-03-16', 1, 'verkoop', 'Presentatie graffiti 30 minuten', 0.00, 'kernel', '2013005', '', '');
INSERT INTO journaal VALUES (186, 33, 2013, '2013-03-31', 1, 'kas', 'Contante verkopen 1e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (187, 34, 2013, '2013-01-31', 1, 'kas', 'Kasblad 01 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (188, 35, 2013, '2013-02-28', 1, 'kas', 'Kasblad 02 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (189, 36, 2013, '2013-03-31', 1, 'kas', 'Kasblad 03 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (191, 38, 2013, '2013-03-31', 1, 'memo', 'BTW egalisatie boekingsperiode 1', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO journaal VALUES (192, 39, 2013, '2013-04-01', 2, 'inkoop', 'Schildersdoek 120x160', 0.00, 'vend', '114345373', '', '');
INSERT INTO journaal VALUES (193, 40, 2013, '2013-04-10', 2, 'inkoop', 'Drukspuit', 0.00, 'bolcom', '8120632180', '', '');
INSERT INTO journaal VALUES (194, 41, 2013, '2013-04-11', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE90648', '', '');
INSERT INTO journaal VALUES (195, 42, 2013, '2013-04-11', 2, 'inkoop', 'Afdekfolie', 0.00, 'bolcom', '8120632180', '', '');
INSERT INTO journaal VALUES (196, 43, 2013, '2013-04-17', 2, 'inkoop', 'Advertentiepakket KK', 0.00, 'marktplaats', 'MP130423317', '', '');
INSERT INTO journaal VALUES (197, 44, 2013, '2013-04-24', 2, 'inkoop', 'Folders KK', 0.00, 'drukwerk', 'F2013175995', '', '');
INSERT INTO journaal VALUES (198, 45, 2013, '2013-04-25', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE90767', '', '');
INSERT INTO journaal VALUES (199, 46, 2013, '2013-04-29', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE90780', '', '');
INSERT INTO journaal VALUES (200, 47, 2013, '2013-05-04', 2, 'inkoop', 'Doeken en tekenmaterialen', 0.00, 'vanbeek', '947244', '', '');
INSERT INTO journaal VALUES (201, 48, 2013, '2013-05-17', 2, 'inkoop', 'Stiften', 0.00, 'vanbeek', '952146', '', '');
INSERT INTO journaal VALUES (202, 49, 2013, '2013-05-15', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE90898', '', '');
INSERT INTO journaal VALUES (203, 50, 2013, '2013-05-17', 2, 'inkoop', 'Amsterdam parkeerheffing', 0.00, 'diverse', '4000000034171391', '', '');
INSERT INTO journaal VALUES (204, 51, 2013, '2013-05-22', 2, 'inkoop', 'Kaasdoek', 0.00, 'stoffen', '201301243', '', '');
INSERT INTO journaal VALUES (206, 53, 2013, '2013-07-11', 2, 'inkoop', 'Verzekering Opel 11-7/11-10', 0.00, 'vandien', '16546675', '', '');
INSERT INTO journaal VALUES (207, 54, 2013, '2013-06-11', 2, 'inkoop', 'Latex en rollers', 0.00, 'claasen', 'F773925', '', '');
INSERT INTO journaal VALUES (208, 55, 2013, '2013-06-24', 2, 'inkoop', 'Spuitmaskers', 0.00, 'engelb', '254755', '', '');
INSERT INTO journaal VALUES (209, 56, 2013, '2013-06-23', 2, 'inkoop', 'Acculader en laadkabel', 0.00, 'conrad', '9549690681', '', '');
INSERT INTO journaal VALUES (210, 57, 2013, '2013-06-25', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE91317', '', '');
INSERT INTO journaal VALUES (211, 58, 2013, '2013-06-26', 2, 'inkoop', 'Audio in auto', 0.00, 'kbaudio', '100007363', '', '');
INSERT INTO journaal VALUES (212, 59, 2013, '2013-06-26', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE91195', '', '');
INSERT INTO journaal VALUES (213, 60, 2013, '2013-06-28', 2, 'inkoop', 'Banden Nissan', 0.00, 'profile', 'M10087057', '', '');
INSERT INTO journaal VALUES (217, 64, 2013, '2013-06-10', 2, 'inkoop', 'Aanschaf Nissan Nv200 5-VKH-50', 0.00, 'koops', '63700647', '', '');
INSERT INTO journaal VALUES (218, 65, 2013, '2013-04-06', 2, 'verkoop', 'Schilderij Wicked', 0.00, 'vdEnde', '2013006', '', '');
INSERT INTO journaal VALUES (219, 66, 2013, '2013-04-13', 2, 'verkoop', 'Schildering Rolluik', 0.00, 'rooiehoek', '2013007', '', '');
INSERT INTO journaal VALUES (220, 67, 2013, '2013-04-23', 2, 'verkoop', 'Graffitiworkshop opening Skatepark', 0.00, 'bomenwijk', '2013008', '', '');
INSERT INTO journaal VALUES (221, 68, 2013, '2013-05-05', 2, 'verkoop', 'Wandschilderingen', 0.00, 'eataly', '2013009', '', '');
INSERT INTO journaal VALUES (222, 69, 2013, '2013-05-05', 2, 'verkoop', 'Logo Freenorm', 0.00, 'freedom', '201310', '', '');
INSERT INTO journaal VALUES (223, 70, 2013, '2013-05-09', 2, 'verkoop', 'Schilderij Vermeer', 0.00, 'annders', '201311', '', '');
INSERT INTO journaal VALUES (224, 71, 2013, '2013-05-14', 2, 'verkoop', 'Wandschildering bloemen', 0.00, 'ipse', '201312', '', '');
INSERT INTO journaal VALUES (225, 72, 2013, '2013-05-20', 2, 'verkoop', 'Schilderij Vermeer bijwerken', 0.00, 'annders', '201313', '', '');
INSERT INTO journaal VALUES (226, 73, 2013, '2013-05-20', 2, 'verkoop', 'Wandschildering fotostudio', 0.00, 'coppoolse', '201314', '', '');
INSERT INTO journaal VALUES (227, 74, 2013, '2013-05-30', 2, 'verkoop', 'Graffitiworkshop', 0.00, 'horizon', '201315', '', '');
INSERT INTO journaal VALUES (228, 75, 2013, '2013-06-06', 2, 'verkoop', 'Schildering op kaasdoek', 0.00, 'coppoolse', '201316', '', '');
INSERT INTO journaal VALUES (229, 76, 2013, '2013-06-10', 2, 'verkoop', 'Wandschildering Las Vegas', 0.00, 'markies', '201317', '', '');
INSERT INTO journaal VALUES (230, 77, 2013, '2013-06-18', 2, 'verkoop', 'Wandschildering buitenmuur', 0.00, 'butterfly', '201318', '', '');
INSERT INTO journaal VALUES (231, 78, 2013, '2013-06-19', 2, 'verkoop', 'Verkoop Opel Combi', 0.00, 'koops', '201319', '', '');
INSERT INTO journaal VALUES (232, 79, 2013, '2013-06-30', 2, 'kas', 'Contante verkopen 2e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (233, 80, 2013, '2013-06-30', 2, 'memo', 'Correctie BTW 1e per. jrnl.188', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (234, 81, 2013, '2013-04-18', 2, 'inkoop', 'Telefoon apr 75% zakelijk', 0.00, 'tmobile', '901188503627', '', '');
INSERT INTO journaal VALUES (235, 82, 2013, '2013-05-21', 2, 'inkoop', 'Telefoon mei 75% zakelijk', 0.00, 'tmobile', '901190736769', '', '');
INSERT INTO journaal VALUES (236, 83, 2013, '2013-06-19', 2, 'inkoop', 'Telefoon jun 75% zakelijk', 0.00, 'tmobile', '901193006754', '', '');
INSERT INTO journaal VALUES (237, 84, 2013, '2013-06-30', 2, 'memo', 'BTW egalisatie boekingsperiode 2', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO journaal VALUES (214, 61, 2013, '2013-04-30', 2, 'kas', 'Kasblad 04 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (215, 62, 2013, '2013-05-31', 2, 'kas', 'Kasblad 05 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (216, 63, 2013, '2013-06-30', 2, 'kas', 'Kasblad 06 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (238, 2, 2012, '2012-01-22', 1, 'verkoop', 'Muurschildering deel 1', 0.00, 'skihutu', '2012001', '', '');
INSERT INTO journaal VALUES (239, 3, 2012, '2012-02-29', 1, 'verkoop', 'Schilderij Indonesie', 0.00, 'ipse', '2012002', '', '');
INSERT INTO journaal VALUES (240, 4, 2012, '2012-02-28', 1, 'verkoop', 'Muurschildering deel 2 en 3', 0.00, 'skihutu', '2012003', '', '');
INSERT INTO journaal VALUES (273, 37, 2012, '2012-05-09', 2, 'inkoop', 'Mobiel internet mei', 0.00, 'vodafone', '207277187', '', '');
INSERT INTO journaal VALUES (245, 9, 2012, '2012-01-02', 1, 'inkoop', 'Huur atelier Boskoop jan', 0.00, 'verweij', '2012014', '', '');
INSERT INTO journaal VALUES (262, 26, 2012, '2012-04-11', 1, 'inkoop', 'Verzekering Opel 11-4/11-7', 0.00, 'vandien', '14965804', '', '');
INSERT INTO journaal VALUES (246, 10, 2012, '2012-01-07', 1, 'inkoop', 'Mobiel internet jan', 0.00, 'vodafone', '192034269', '', '');
INSERT INTO journaal VALUES (247, 11, 2012, '2012-01-18', 1, 'inkoop', 'Telefoon jan', 0.00, 'tmobile', '901154931629', '', '');
INSERT INTO journaal VALUES (298, 62, 2012, '2012-07-27', 3, 'inkoop', 'Telmachinemateriaal en stempel', 0.00, 'kroon', '9016364', '', '');
INSERT INTO journaal VALUES (263, 27, 2012, '2012-03-08', 1, 'inkoop', 'Mobiel internet mrt', 0.00, 'vodafone', '198321528', '', '');
INSERT INTO journaal VALUES (248, 12, 2012, '2012-01-25', 1, 'inkoop', 'Spuitmaskers', 0.00, 'engelb', '194755', '', '');
INSERT INTO journaal VALUES (274, 38, 2012, '2012-05-12', 2, 'inkoop', 'Tekenmateriaal', 0.00, 'vanbeek', '794001', '', '');
INSERT INTO journaal VALUES (249, 13, 2012, '2012-01-26', 1, 'inkoop', 'Verf en linnen', 0.00, 'vanbeek', '747147', '', '');
INSERT INTO journaal VALUES (264, 28, 2012, '2012-03-09', 1, 'inkoop', 'Motorrijtuigenbelasting Opel 8-03/7-06', 0.00, 'belasting', '69474993M2', '', '');
INSERT INTO journaal VALUES (250, 14, 2012, '2012-01-30', 1, 'inkoop', 'Printerinkt', 0.00, '123inkt', '2559604', '', '');
INSERT INTO journaal VALUES (283, 47, 2012, '2012-06-11', 2, 'inkoop', 'Wegenbelasting Opel 8-06/7-09', 0.00, 'belasting', '69414993m22', '', '');
INSERT INTO journaal VALUES (251, 15, 2012, '2012-01-15', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '54622', '', '');
INSERT INTO journaal VALUES (265, 29, 2012, '2012-03-12', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '54972', '', '');
INSERT INTO journaal VALUES (252, 16, 2012, '2012-02-02', 1, 'inkoop', 'Huur atelier Boskoop feb', 0.00, 'verweij', '201229', '', '');
INSERT INTO journaal VALUES (275, 39, 2012, '2012-05-25', 2, 'inkoop', 'Medion portable PC', 0.00, 'mediamarkt', '4070672', '', '');
INSERT INTO journaal VALUES (253, 17, 2012, '2012-02-02', 1, 'inkoop', 'Bijdrage KvK 2012', 0.00, 'kvk', '251488299', '', '');
INSERT INTO journaal VALUES (254, 18, 2012, '2012-02-07', 1, 'inkoop', 'Mobiel internet feb', 0.00, 'vodafone', '195064547', '', '');
INSERT INTO journaal VALUES (255, 19, 2012, '2012-02-11', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '54794', '', '');
INSERT INTO journaal VALUES (290, 54, 2012, '2012-07-11', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55936', '', '');
INSERT INTO journaal VALUES (276, 40, 2012, '2012-05-17', 2, 'inkoop', 'Creditnota gederfde schade', 0.00, 'vodafone', '209655714', '', '');
INSERT INTO journaal VALUES (256, 20, 2012, '2012-02-13', 1, 'inkoop', 'Marktplaats advertentie', 0.00, 'marktplaats', '120200554', '', '');
INSERT INTO journaal VALUES (267, 31, 2012, '2012-03-30', 2, 'inkoop', 'Kleine beurt Opel', 0.00, 'hofman', '2012098', '', '');
INSERT INTO journaal VALUES (257, 21, 2012, '2012-02-20', 1, 'inkoop', 'Telefoon feb', 0.00, 'tmobile', '901157136105', '', '');
INSERT INTO journaal VALUES (284, 48, 2012, '2012-06-12', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55648', '', '');
INSERT INTO journaal VALUES (258, 22, 2012, '2012-02-23', 1, 'inkoop', 'Verf en linnen', 0.00, 'vanbeek', '759771', '', '');
INSERT INTO journaal VALUES (268, 32, 2012, '2012-04-02', 2, 'inkoop', 'Huur atelier Boskoop apr', 0.00, 'verweij', '2012059', '', '');
INSERT INTO journaal VALUES (259, 23, 2012, '2012-02-23', 1, 'inkoop', 'Markers', 0.00, 'vanbeek', '759773', '', '');
INSERT INTO journaal VALUES (277, 41, 2012, '2012-04-20', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55182', '', '');
INSERT INTO journaal VALUES (260, 24, 2012, '2012-02-28', 1, 'inkoop', 'TomTom', 0.00, 'mediamarkt', '40956138', '', '');
INSERT INTO journaal VALUES (269, 33, 2012, '2012-04-09', 2, 'inkoop', 'Mobiel internet apr', 0.00, 'vodafone', '203060518', '', '');
INSERT INTO journaal VALUES (261, 25, 2012, '2012-03-05', 1, 'inkoop', 'Huur atelier Boskoop mrt', 0.00, 'verweij', '2012044', '', '');
INSERT INTO journaal VALUES (270, 34, 2012, '2012-04-13', 2, 'inkoop', 'Boete onjuiste opgaaf ICP 4e kw 2011', 0.00, 'belasting', '69414993F011641', '', '');
INSERT INTO journaal VALUES (295, 59, 2012, '2012-07-24', 3, 'inkoop', 'Printerinkt', 0.00, '123inkt', '2995179', '', '');
INSERT INTO journaal VALUES (278, 42, 2012, '2012-05-14', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55395', '', '');
INSERT INTO journaal VALUES (271, 35, 2012, '2012-05-01', 2, 'inkoop', 'Huur atelier Boskoop mei', 0.00, 'verweij', '2012075', '', '');
INSERT INTO journaal VALUES (285, 49, 2012, '2012-06-23', 2, 'inkoop', 'Memory stick 16G', 0.00, 'paradigit', '132032426', '', '');
INSERT INTO journaal VALUES (272, 36, 2012, '2012-05-02', 2, 'inkoop', 'Dopsleutel speciaal', 0.00, 'a1', '201205139', '', '');
INSERT INTO journaal VALUES (279, 43, 2012, '2012-05-18', 2, 'inkoop', 'Linnen', 0.00, 'vanbeek', '795985', '', '');
INSERT INTO journaal VALUES (291, 55, 2012, '2012-07-14', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55948', '', '');
INSERT INTO journaal VALUES (286, 50, 2012, '2012-06-25', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55793', '', '');
INSERT INTO journaal VALUES (280, 44, 2012, '2012-05-25', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55469', '', '');
INSERT INTO journaal VALUES (281, 45, 2012, '2012-06-01', 2, 'inkoop', 'Huur atelier Boskoop jun', 0.00, 'verweij', '2012092', '', '');
INSERT INTO journaal VALUES (304, 68, 2012, '2012-08-08', 3, 'inkoop', 'Materiaal', 0.00, 'vanbeek', '826289', '', '');
INSERT INTO journaal VALUES (287, 51, 2012, '2012-07-02', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '55837', '', '');
INSERT INTO journaal VALUES (282, 46, 2012, '2012-06-04', 2, 'inkoop', 'Verzekering Opel 11-7/11-10', 0.00, 'vandien', '15265917', '', '');
INSERT INTO journaal VALUES (301, 65, 2012, '2012-08-03', 3, 'inkoop', 'Boekjes glazen kunstwerken Vondelflats', 0.00, 'drukwerk', '2012389598', '', '');
INSERT INTO journaal VALUES (292, 56, 2012, '2012-07-16', 3, 'inkoop', 'Brochures Koogerkunst', 0.00, 'drukwerk', '2012381133', '', '');
INSERT INTO journaal VALUES (288, 52, 2012, '2012-07-10', 3, 'inkoop', 'Mobiel internet jul', 0.00, 'vodafone', '216408394', '', '');
INSERT INTO journaal VALUES (296, 60, 2012, '2012-07-27', 3, 'inkoop', 'Backup software', 0.00, 'acronis', '73619285233', '', '');
INSERT INTO journaal VALUES (289, 53, 2012, '2012-07-11', 3, 'inkoop', 'Mobiel internet mei', 0.00, 'vodafone', '212045361', '', '');
INSERT INTO journaal VALUES (293, 57, 2012, '2012-07-16', 3, 'inkoop', 'Vinylstickers Koogerkunst', 0.00, 'drukwerk', '2012380765', '', '');
INSERT INTO journaal VALUES (299, 63, 2012, '2012-08-01', 3, 'inkoop', 'Huur atelier Boskoop aug', 0.00, 'verweij', '2012121', '', '');
INSERT INTO journaal VALUES (294, 58, 2012, '2012-07-24', 3, 'inkoop', 'Telefoon jul', 0.00, 'tmobile', '901168240121', '', '');
INSERT INTO journaal VALUES (297, 61, 2012, '2012-07-28', 3, 'inkoop', 'Backup software update', 0.00, 'acronis', '73619315387', '', '');
INSERT INTO journaal VALUES (303, 67, 2012, '2012-08-07', 3, 'inkoop', 'Werkschort', 0.00, 'surprise', '598716-372169', '', '');
INSERT INTO journaal VALUES (300, 64, 2012, '2012-08-02', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56110', '', '');
INSERT INTO journaal VALUES (302, 66, 2012, '2012-08-07', 3, 'inkoop', 'Onderhoud en banden Opel', 0.00, 'hofman', '2012191', '', '');
INSERT INTO journaal VALUES (307, 71, 2012, '2012-08-20', 3, 'inkoop', 'Telefoon aug', 0.00, 'tmobile', '901170478394', '', '');
INSERT INTO journaal VALUES (305, 69, 2012, '2012-08-08', 3, 'inkoop', 'Foto op canvas', 0.00, 'canvas', '2012221925', '', '');
INSERT INTO journaal VALUES (306, 70, 2012, '2012-08-11', 3, 'inkoop', 'Gereedschap', 0.00, 'buitelaar', 'contant', '', '');
INSERT INTO journaal VALUES (308, 72, 2012, '2012-08-22', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56235', '', '');
INSERT INTO journaal VALUES (309, 73, 2012, '2012-09-02', 3, 'inkoop', 'Huur atelier Boskoop sep', 0.00, 'verweij', '2012134', '', '');
INSERT INTO journaal VALUES (310, 74, 2012, '2012-09-04', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56333', '', '');
INSERT INTO journaal VALUES (311, 75, 2012, '2012-08-26', 3, 'inkoop', 'Parkeerbelasting Ged.Burgwal', 0.00, 'denhaag', '100014', '', '');
INSERT INTO journaal VALUES (312, 76, 2012, '2012-09-07', 3, 'inkoop', 'Printerinkt', 0.00, '123inkt', '3094297', '', '');
INSERT INTO journaal VALUES (313, 77, 2012, '2012-09-10', 3, 'inkoop', 'Verzekering Opel 11-10/11-01-13', 0.00, 'vandien', '15569339', '', '');
INSERT INTO journaal VALUES (314, 78, 2012, '2012-09-10', 3, 'inkoop', 'Motorrijtuigenbelasting Opel 8-09/7-12', 0.00, 'belasting', '69414993M25', '', '');
INSERT INTO journaal VALUES (315, 79, 2012, '2012-09-24', 3, 'inkoop', 'Telefoon sep', 0.00, 'tmobile', '901172713938', '', '');
INSERT INTO journaal VALUES (334, 98, 2012, '2012-12-07', 4, 'inkoop', 'Markers', 0.00, 'vanbeek', '882801', '', '');
INSERT INTO journaal VALUES (316, 80, 2012, '2012-09-27', 3, 'inkoop', 'Lampen', 0.00, 'hofman', '2012271', '', '');
INSERT INTO journaal VALUES (317, 81, 2012, '2012-09-28', 3, 'inkoop', 'Linnen', 0.00, 'vanbeek', '847746', '', '');
INSERT INTO journaal VALUES (335, 99, 2012, '2012-12-11', 4, 'inkoop', 'T-shirts voor promotie', 0.00, 'kleding', '7181', '', '');
INSERT INTO journaal VALUES (242, 6, 2012, '2012-09-30', 3, 'memo', 'Contante verkopen 3e kw.', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (244, 8, 2012, '2012-12-31', 4, 'memo', 'Contante verkopen 4e kw. aanvulling', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (243, 7, 2012, '2012-12-31', 4, 'memo', 'Contante verkopen 4e kw.', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (266, 30, 2012, '2012-03-31', 1, 'memo', 'Contante verkopen 1e kw.', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (318, 82, 2012, '2012-10-01', 4, 'inkoop', 'Huur atelier Boskoop okt', 0.00, 'verweij', '2012147', '', '');
INSERT INTO journaal VALUES (319, 83, 2012, '2012-11-10', 4, 'inkoop', 'Accu startblok', 0.00, 'accu', '3424427', '', '');
INSERT INTO journaal VALUES (336, 100, 2012, '2012-12-12', 4, 'inkoop', 'Stiften retour', 0.00, 'vanbeek', '884982', '', '');
INSERT INTO journaal VALUES (320, 84, 2012, '2012-10-10', 4, 'inkoop', 'Veiligheidsmateriaal', 0.00, 'engelb', '222121', '', '');
INSERT INTO journaal VALUES (321, 85, 2012, '2012-10-15', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56610', '', '');
INSERT INTO journaal VALUES (337, 101, 2012, '2012-12-14', 4, 'inkoop', 'Markers', 0.00, 'vanbeek', '886388', '', '');
INSERT INTO journaal VALUES (322, 86, 2012, '2012-10-25', 4, 'inkoop', 'Batterijen', 0.00, 'conrad', '9549073130', '', '');
INSERT INTO journaal VALUES (323, 87, 2012, '2012-10-25', 4, 'inkoop', 'Flyers ', 0.00, 'drukwerk', '2012438511', '', '');
INSERT INTO journaal VALUES (338, 102, 2012, '2012-12-21', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'uc', '979', '', '');
INSERT INTO journaal VALUES (324, 88, 2012, '2012-10-26', 4, 'inkoop', 'Stickers auto', 0.00, 'drukwerk', '2012439962', '', '');
INSERT INTO journaal VALUES (339, 103, 2012, '2012-12-24', 4, 'inkoop', 'Huur atelier Boskoop jan 13', 0.00, 'verweij', '2012182', '', '');
INSERT INTO journaal VALUES (326, 90, 2012, '2012-11-01', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56680', '', '');
INSERT INTO journaal VALUES (327, 91, 2012, '2012-11-05', 4, 'inkoop', 'Linnen en stiften', 0.00, 'vanbeek', '865253', '', '');
INSERT INTO journaal VALUES (340, 104, 2012, '2012-10-18', 4, 'inkoop', 'Telefoon okt', 0.00, 'tmobile', '901174959033', '', '');
INSERT INTO journaal VALUES (328, 92, 2012, '2012-11-06', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56751', '', '');
INSERT INTO journaal VALUES (329, 93, 2012, '2012-11-21', 4, 'inkoop', 'Marktplaats advertentiepakket', 0.00, 'marktplaats', '121126169', '', '');
INSERT INTO journaal VALUES (341, 105, 2012, '2012-11-21', 4, 'inkoop', 'Telefoon nov', 0.00, 'tmobile', '901177212893', '', '');
INSERT INTO journaal VALUES (330, 94, 2012, '2012-11-22', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '56854', '', '');
INSERT INTO journaal VALUES (331, 95, 2012, '2012-12-03', 4, 'inkoop', 'APK, winterbanden, onderhoud Opel', 0.00, 'hofman', '2012325', '', '');
INSERT INTO journaal VALUES (342, 106, 2012, '2012-12-19', 4, 'inkoop', 'Telefoon dec', 0.00, 'tmobile', '901179454378', '', '');
INSERT INTO journaal VALUES (332, 96, 2012, '2012-12-04', 4, 'inkoop', 'Naheffing 3ekw', 0.00, 'belasting', '69414993F012270', '', '');
INSERT INTO journaal VALUES (333, 97, 2012, '2012-12-10', 4, 'inkoop', 'Motorrijtuigenbelasting Opel 8-12/7-03-13', 0.00, 'belasting', '69414993M27', '', '');
INSERT INTO journaal VALUES (343, 107, 2012, '2012-11-01', 4, 'inkoop', 'Huur atelier Boskoop nov', 0.00, 'verweij', '2012160', '', '');
INSERT INTO journaal VALUES (356, 120, 2012, '2012-04-05', 2, 'verkoop', 'Graffitiworkshop Lekkerkerk', 0.00, 'midholl', '2012005', '', '');
INSERT INTO journaal VALUES (352, 116, 2012, '2012-09-30', 3, 'kas', 'Kasblad 09 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (346, 110, 2012, '2012-03-31', 1, 'kas', 'Kasblad 03 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (382, 146, 2012, '2012-07-01', 3, 'inkoop', 'Huur atelier Boskoop jul', 0.00, 'verweij', '2012121', '', '');
INSERT INTO journaal VALUES (364, 128, 2012, '2012-07-27', 3, 'verkoop', 'Muurschildering Cirkelflat', 0.00, 'woonp', '2012013', '', '');
INSERT INTO journaal VALUES (357, 121, 2012, '2012-05-05', 2, 'verkoop', 'Wandschilderingen Freiburg', 0.00, 'gopfreib', '2012006', '', '');
INSERT INTO journaal VALUES (349, 113, 2012, '2012-06-30', 2, 'kas', 'Kasblad 06 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (376, 140, 2012, '2012-11-10', 4, 'verkoop', 'Muurschildering client', 0.00, 'ipse', '2012025', '', '');
INSERT INTO journaal VALUES (358, 122, 2012, '2012-05-05', 2, 'verkoop', 'Muurschildering binnen', 0.00, 'zuleico', '2012008', '', '');
INSERT INTO journaal VALUES (371, 135, 2012, '2012-09-12', 3, 'verkoop', 'Workshop streetart', 0.00, 'grvenen', '2012020', '', '');
INSERT INTO journaal VALUES (365, 129, 2012, '2012-07-27', 3, 'verkoop', 'Herstellen muursch. Kerkweg Oost', 0.00, 'woonp', '2012014', '', '');
INSERT INTO journaal VALUES (359, 123, 2012, '2012-05-05', 2, 'verkoop', 'Muurschildering binnen', 0.00, 'interior', '2012007', '', '');
INSERT INTO journaal VALUES (353, 117, 2012, '2012-10-31', 4, 'kas', 'Kasblad 10 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (344, 108, 2012, '2012-01-31', 1, 'kas', 'Kasblad 01 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (347, 111, 2012, '2012-04-30', 2, 'kas', 'Kasblad 04 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (360, 124, 2012, '2012-06-05', 2, 'verkoop', 'Workshop', 0.00, 'midholl', '2012009', '', '');
INSERT INTO journaal VALUES (366, 130, 2012, '2012-07-30', 3, 'verkoop', 'Muurschildering bijwerken', 0.00, 'russel', '2012015', '', '');
INSERT INTO journaal VALUES (350, 114, 2012, '2012-07-31', 3, 'kas', 'Kasblad 07 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (361, 125, 2012, '2012-06-14', 2, 'verkoop', 'Muurschildering binnen', 0.00, 'hako', '2012010', '', '');
INSERT INTO journaal VALUES (362, 126, 2012, '2012-06-29', 2, 'verkoop', 'Muurschildering binnen', 0.00, 'saffier', '2012011', '', '');
INSERT INTO journaal VALUES (372, 136, 2012, '2012-09-18', 3, 'verkoop', 'Muurschildering binnen', 0.00, 'quarijn', '2012021', '', '');
INSERT INTO journaal VALUES (367, 131, 2012, '2012-07-30', 3, 'verkoop', 'Muurschildering binnen', 0.00, 'thurley', '2012016', '', '');
INSERT INTO journaal VALUES (345, 109, 2012, '2012-02-29', 1, 'kas', 'Kasblad 02 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (354, 118, 2012, '2012-11-30', 4, 'kas', 'Kasblad 11 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (379, 143, 2012, '2012-11-28', 4, 'verkoop', 'Muurschilderingen binnen', 0.00, 'rooiehoek', '2012028', '', '');
INSERT INTO journaal VALUES (368, 132, 2012, '2012-08-07', 3, 'verkoop', 'Ontwerp en realisatie boekje', 0.00, 'woonp', '2012017', '', '');
INSERT INTO journaal VALUES (241, 5, 2012, '2012-06-30', 2, 'memo', 'Contante verkopen 2e kw.', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (351, 115, 2012, '2012-08-31', 3, 'kas', 'Kasblad 08 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (348, 112, 2012, '2012-05-31', 2, 'kas', 'Kasblad 05 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (373, 137, 2012, '2012-10-11', 4, 'verkoop', 'Muurschildering ronde muur', 0.00, 'quarijn', '2012022', '', '');
INSERT INTO journaal VALUES (363, 127, 2012, '2012-07-17', 3, 'verkoop', 'Muurschildering skyline Rotterdam', 0.00, 'oudenes', '2012012', '', '');
INSERT INTO journaal VALUES (385, 149, 2012, '2012-12-31', 5, 'memo', 'BTW Correctie prive gebruik Opel Combo', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (369, 133, 2012, '2012-08-07', 3, 'verkoop', 'Muurschildering Broadbents', 0.00, 'russel', '2012018', '', '');
INSERT INTO journaal VALUES (355, 119, 2012, '2012-12-31', 4, 'kas', 'Kasblad 12 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (374, 138, 2012, '2012-10-11', 4, 'verkoop', 'Muurschildering bruin cafe', 0.00, 'leeuwen', '2012023', '', '');
INSERT INTO journaal VALUES (370, 134, 2012, '2012-08-21', 3, 'verkoop', 'Muurschildering Femtastic', 0.00, 'femtastic', '2012019', '', '');
INSERT INTO journaal VALUES (380, 144, 2012, '2012-12-11', 4, 'verkoop', 'Muurschildering marktkraam', 0.00, 'intwell', '2012028', '', '');
INSERT INTO journaal VALUES (375, 139, 2012, '2012-10-14', 4, 'verkoop', 'Muurschildering bruin cafe', 0.00, 'smit', '2012024', '', '');
INSERT INTO journaal VALUES (384, 148, 2012, '2012-12-31', 5, 'memo', 'Prive bijtelling Opel Combo', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (377, 141, 2012, '2012-11-11', 4, 'verkoop', 'Live painting thema', 0.00, 'ordemed', '2012026', '', '');
INSERT INTO journaal VALUES (381, 145, 2012, '2012-03-28', 1, 'verkoop', 'Nog nakijken', 0.00, 'particulier', '2012004', '', '');
INSERT INTO journaal VALUES (378, 142, 2012, '2012-11-26', 4, 'verkoop', 'Workshop personeel', 0.00, 'rabozhm', '2012027', '', '');
INSERT INTO journaal VALUES (389, 153, 2012, '2012-06-30', 2, 'memo', 'BTW egalisatie boekingsperiode 2', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO journaal VALUES (386, 150, 2012, '2012-12-31', 5, 'memo', 'Afschrijving Opel Combo 2011 en 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (390, 154, 2012, '2012-09-30', 3, 'memo', 'BTW egalisatie boekingsperiode 3', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO journaal VALUES (393, 157, 2012, '2012-02-28', 1, 'verkoop', 'Dummy factuur', 0.00, 'particulier', '2012004', '', '');
INSERT INTO journaal VALUES (394, 158, 2012, '2012-03-31', 1, 'memo', 'BTW egalisatie boekingsperiode 1', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO journaal VALUES (395, 159, 2012, '2012-12-31', 4, 'memo', 'BTW 5d vermindering inboeken', 0.00, '', '', '5dregeling', 'Automatische boeking van vermindering volgens BTW regeling voor kleinondernemers');
INSERT INTO journaal VALUES (396, 160, 2012, '2012-12-31', 4, 'memo', 'BTW egalisatie boekingsperiode 4', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (397, 161, 2012, '2012-12-31', 5, 'memo', 'Werkelijk betaalde BTW bedragen', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (398, 162, 2012, '2012-12-31', 5, 'memo', 'Debiteurensaldo prive ontvangen 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (383, 147, 2012, '2012-12-01', 4, 'inkoop', 'Huur atelier Boskoop dec', 0.00, 'verweij', '2012182', '', '');
INSERT INTO journaal VALUES (399, 163, 2012, '2012-12-31', 5, 'memo', 'Crediteurensaldo prive betaald 2012', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (401, 1, 2013, '2013-01-01', 0, 'begin', 'Beginbalans', 0.00, '', '', 'begin', 'Automatische boeking van beginbalans in het nieuwe boekjaar');
INSERT INTO journaal VALUES (400, 164, 2012, '2012-12-31', 5, 'memo', 'Correctiebedrag BTW naar verrekening', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (402, 85, 2013, '2013-07-10', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE91472', '', '');
INSERT INTO journaal VALUES (403, 86, 2013, '2013-07-31', 3, 'inkoop', 'Ladder', 0.00, 'betaalbaar', '201314642', '', '');
INSERT INTO journaal VALUES (415, 98, 2013, '2013-09-09', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE91992', '', '');
INSERT INTO journaal VALUES (416, 99, 2013, '2013-09-12', 3, 'inkoop', 'Advertenties', 0.00, 'marktplaats', 'MPDI130905301', '', '');
INSERT INTO journaal VALUES (417, 100, 2013, '2013-09-20', 3, 'inkoop', 'Computermaterialen', 0.00, 'altern', '424156643', '', '');
INSERT INTO journaal VALUES (418, 101, 2013, '2013-09-21', 3, 'inkoop', 'Computermateriaal', 0.00, 'groenec', '82599', '', '');
INSERT INTO journaal VALUES (404, 87, 2013, '2013-07-31', 3, 'kas', 'Kasblad 07 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (419, 102, 2013, '2013-09-22', 3, 'inkoop', 'Computermateriaal geheugen', 0.00, 'mycom', '2209', '', '');
INSERT INTO journaal VALUES (420, 103, 2013, '2013-09-30', 3, 'inkoop', 'Computermateriaal koeling', 0.00, 'altern', '224158711', '', '');
INSERT INTO journaal VALUES (405, 88, 2013, '2013-08-31', 3, 'kas', 'Kasblad 08 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (421, 104, 2013, '2013-09-30', 3, 'inkoop', 'Computermateriaal SSD schijf', 0.00, 'altern', '224158708', '', '');
INSERT INTO journaal VALUES (422, 105, 2013, '2013-07-18', 3, 'inkoop', 'T-Mobile 16-7/15-8', 0.00, 'tmobile', '901195252861', '', '');
INSERT INTO journaal VALUES (423, 106, 2013, '2013-08-20', 3, 'inkoop', 'T-Mobile 16-8/15-9', 0.00, 'tmobile', '901197517004', '', '');
INSERT INTO journaal VALUES (408, 91, 2013, '2013-08-05', 3, 'inkoop', 'Inktcartridges', 0.00, '123inkt', '4078023', '', '');
INSERT INTO journaal VALUES (424, 107, 2013, '2013-09-18', 3, 'inkoop', 'T-Mobile 16-9/15-10', 0.00, 'tmobile', '901199780567', '', '');
INSERT INTO journaal VALUES (409, 92, 2013, '2013-08-09', 3, 'inkoop', 'Spuitmaskers', 0.00, 'engelb', '260590', '', '');
INSERT INTO journaal VALUES (410, 93, 2013, '2013-08-13', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE91752', '', '');
INSERT INTO journaal VALUES (425, 108, 2013, '2013-09-09', 3, 'inkoop', 'Molotow spuitmateriaal', 0.00, 'publikat', 'RE1087838', '', '');
INSERT INTO journaal VALUES (411, 94, 2013, '2013-08-14', 3, 'inkoop', 'Stapelkratten', 0.00, 'kruiz', '4027148', '', '');
INSERT INTO journaal VALUES (412, 95, 2013, '2013-08-19', 3, 'inkoop', 'Motorrijtuigenbelasting Nissan 17-8/16-11', 0.00, 'belasting', '694.14.993.M.3.7', '', '');
INSERT INTO journaal VALUES (413, 96, 2013, '2013-08-19', 3, 'inkoop', 'Acrylverf', 0.00, 'vanbeek', '986655', '', '');
INSERT INTO journaal VALUES (426, 109, 2013, '2013-09-24', 3, 'inkoop', 'Molotow spuitmateriaal Duitsland', 0.00, 'molotow', '145800', '', '');
INSERT INTO journaal VALUES (414, 97, 2013, '2013-08-28', 3, 'inkoop', 'Kraamhuur 21 sept', 0.00, 'wadcult', '28082013', '', '');
INSERT INTO journaal VALUES (427, 110, 2013, '2013-07-02', 3, 'verkoop', 'Muurschildering Beatles', 0.00, 'ipse', '2013020', '', '');
INSERT INTO journaal VALUES (444, 127, 2013, '2013-03-09', 4, 'inkoop', 'Internet mrt', 0.00, 'xs4all', '40704328', '', '');
INSERT INTO journaal VALUES (438, 121, 2013, '2013-11-22', 4, 'verkoop', 'Muurschildering Logo', 0.00, 'jaguacy', '2013029', '', '');
INSERT INTO journaal VALUES (428, 111, 2013, '2013-07-02', 3, 'verkoop', 'Muurschildering poorten icm workshop', 0.00, 'quawonen', '201321', '', '');
INSERT INTO journaal VALUES (429, 112, 2013, '2013-07-02', 3, 'verkoop', 'Graffitiworkshop container', 0.00, 'hockey', '2013022', '', '');
INSERT INTO journaal VALUES (456, 139, 2013, '2013-10-21', 4, 'inkoop', 'Telefoon 16-10/15-11', 0.00, 'tmobile', '901202038781', '', '');
INSERT INTO journaal VALUES (439, 122, 2013, '2013-11-29', 4, 'verkoop', 'Muurschildering graffiti project', 0.00, 'stolwijk', '2013030', '', '');
INSERT INTO journaal VALUES (430, 113, 2013, '2013-07-05', 3, 'verkoop', 'Schilderij danseres', 0.00, 'dadanza', '2013023', '', '');
INSERT INTO journaal VALUES (431, 114, 2013, '2013-07-27', 3, 'verkoop', 'Muurschilderingen restaurant', 0.00, 'ppannekoek', '2013024', '', '');
INSERT INTO journaal VALUES (440, 123, 2013, '2013-12-18', 4, 'verkoop', 'Workshops jeugd', 0.00, 'krimpen', '2013031', '', '');
INSERT INTO journaal VALUES (432, 115, 2013, '2013-08-25', 3, 'verkoop', 'Restant Alexandertunnel', 0.00, 'bomenwijk', '2013025', '', '');
INSERT INTO journaal VALUES (443, 126, 2013, '2013-02-09', 4, 'inkoop', 'Internet feb', 0.00, 'xs4all', '40438518', '', '');
INSERT INTO journaal VALUES (433, 116, 2013, '2013-08-30', 3, 'verkoop', 'Muurschildering paarden', 0.00, 'ipse', '2013026', '', '');
INSERT INTO journaal VALUES (441, 124, 2013, '2013-10-01', 4, 'inkoop', 'Stiften en verfmaterialen', 0.00, 'vanbeek', '1007059', '', '');
INSERT INTO journaal VALUES (434, 117, 2013, '2013-09-05', 3, 'verkoop', 'Muurschildering BigBen', 0.00, 'ppannekoek', '2013027', '', '');
INSERT INTO journaal VALUES (450, 133, 2013, '2013-09-09', 4, 'inkoop', 'Internet sep', 0.00, 'xs4all', '72258675', '', '');
INSERT INTO journaal VALUES (435, 118, 2013, '2013-09-23', 3, 'verkoop', 'Presentatie graffiti', 0.00, 'nsveiligh', '2013028', '', '');
INSERT INTO journaal VALUES (406, 89, 2013, '2013-09-30', 3, 'kas', 'Kasblad 09 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (460, 143, 2013, '2013-11-19', 4, 'inkoop', 'Telefoon 16-11/15-12', 0.00, 'tmobile', '901204333635', '', '');
INSERT INTO journaal VALUES (465, 148, 2013, '2013-12-09', 4, 'inkoop', 'Internet dec', 0.00, 'xs4all', '43009098', '', '');
INSERT INTO journaal VALUES (458, 141, 2013, '2013-11-09', 4, 'inkoop', 'Internet nov', 0.00, 'xs4all', '42760348', '', '');
INSERT INTO journaal VALUES (457, 140, 2013, '2013-11-06', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', 'HE92453', '', '');
INSERT INTO journaal VALUES (473, 156, 2013, '2013-10-31', 4, 'kas', 'Kasblad 10 2013 nagekomen', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (452, 135, 2013, '2013-10-10', 4, 'inkoop', 'Computermaterialen', 0.00, 'altern', '224160264', '', '');
INSERT INTO journaal VALUES (436, 119, 2013, '2013-09-30', 3, 'kas', 'Contante verkopen 3e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (437, 120, 2013, '2013-09-30', 3, 'memo', 'BTW egalisatie boekingsperiode 3', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO journaal VALUES (447, 130, 2013, '2013-06-09', 4, 'inkoop', 'Internet jun', 0.00, 'xs4all', '41491228', '', '');
INSERT INTO journaal VALUES (453, 136, 2013, '2013-10-17', 4, 'inkoop', 'Software', 0.00, 'hamrick', '5619497397', '', '');
INSERT INTO journaal VALUES (446, 129, 2013, '2013-05-09', 4, 'inkoop', 'Internet mei', 0.00, 'xs4all', '41230664', '', '');
INSERT INTO journaal VALUES (467, 150, 2013, '2013-12-23', 4, 'inkoop', 'Telefoon 16-12/15-01', 0.00, 'tmobile', '901206572439', '', '');
INSERT INTO journaal VALUES (454, 137, 2013, '2013-10-17', 4, 'inkoop', 'Software', 0.00, 'hamrick', '5621554077', '', '');
INSERT INTO journaal VALUES (445, 128, 2013, '2013-04-09', 4, 'inkoop', 'Internet apr', 0.00, 'xs4all', '40967790', '', '');
INSERT INTO journaal VALUES (455, 138, 2013, '2013-10-19', 4, 'inkoop', 'Stiften', 0.00, 'vanbeek', '1016097', '', '');
INSERT INTO journaal VALUES (461, 144, 2013, '2013-11-22', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'publikat', 'RE1146822', '', '');
INSERT INTO journaal VALUES (464, 147, 2013, '2013-11-25', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'publikat', 'RE1147848', '', '');
INSERT INTO journaal VALUES (459, 142, 2013, '2013-11-18', 4, 'inkoop', 'Motorrijtuigenbelasting Nissan 17-11/16-02', 0.00, 'belasting', '69414993M39', '', '');
INSERT INTO journaal VALUES (466, 149, 2013, '2013-12-13', 4, 'inkoop', 'Nissan kleine beurt', 0.00, 'hofman', '2013318', '', '');
INSERT INTO journaal VALUES (462, 145, 2013, '2013-11-22', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'publikat', 'RE1146755', '', '');
INSERT INTO journaal VALUES (470, 153, 2013, '2013-11-30', 4, 'kas', 'Kasblad 11 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (463, 146, 2013, '2013-11-22', 4, 'inkoop', 'Spuitmateriaal', 0.00, 'publikat', 'RE1146652', '', '');
INSERT INTO journaal VALUES (449, 132, 2013, '2013-08-09', 4, 'inkoop', 'Internet aug', 0.00, 'xs4all', '42005730', '', '');
INSERT INTO journaal VALUES (469, 152, 2013, '2013-10-31', 4, 'kas', 'Kasblad 10 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (468, 151, 2013, '2013-12-31', 4, 'inkoop', 'Nissan winterbanden', 0.00, 'hofman', '2013335', '', '');
INSERT INTO journaal VALUES (472, 155, 2013, '2013-12-31', 4, 'kas', 'Contante verkopen 4e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (451, 134, 2013, '2013-10-09', 4, 'inkoop', 'Internet okt', 0.00, 'xs4all', '42508135', '', '');
INSERT INTO journaal VALUES (471, 154, 2013, '2013-12-31', 4, 'kas', 'Kasblad 12 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (442, 125, 2013, '2013-01-09', 4, 'inkoop', 'Internet jan', 0.00, 'xs4all', '40162635', '', '');
INSERT INTO journaal VALUES (448, 131, 2013, '2013-07-09', 4, 'inkoop', 'Internet jul', 0.00, 'xs4all', '41750961', '', '');
INSERT INTO journaal VALUES (407, 90, 2013, '2013-07-08', 3, 'inkoop', 'Motorrijtuigenbelasting Nissan 25-06/16-08', 0.00, 'belasting', '694.14.993M3.5', '', '');
INSERT INTO journaal VALUES (475, 158, 2013, '2013-12-31', 5, 'memo', 'Prive autogebruik 2013', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (476, 159, 2013, '2013-12-31', 4, 'memo', 'BTW egalisatie boekingsperiode 4', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (205, 52, 2013, '2013-06-08', 2, 'inkoop', 'Motorrijtuigenbelasting Opel Combo 8-6/7-9', 0.00, 'belasting', '69414993M34', '', '');
INSERT INTO journaal VALUES (477, 160, 2013, '2013-06-10', 5, 'memo', 'Afschrijving Opel Combi t.m. 10 juni', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (478, 161, 2013, '2013-06-10', 5, 'memo', 'Afvoeren Opel Combo van balans wgs verkoop', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (479, 162, 2013, '2013-06-10', 5, 'memo', 'Opel Combo restverlies op verkoop', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (480, 163, 2013, '2013-12-31', 5, 'memo', 'Afschrijving Nissan vanaf 10 juni', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (481, 164, 2013, '2013-12-31', 5, 'memo', 'Prive betaald Crediteuren', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (482, 165, 2013, '2013-12-31', 5, 'memo', 'Prive ontvangen Debiteuren', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (483, 166, 2013, '2013-12-31', 5, 'memo', 'Betaalde allrisk verzekering Nissan', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (474, 157, 2013, '2013-12-31', 5, 'memo', 'Afschrijving van fakt. 2012003', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (484, 2, 2014, '2014-01-03', 1, 'inkoop', 'S-Video prof kabel', 0.00, 'akabels', '710276', '', '');
INSERT INTO journaal VALUES (517, 35, 2014, '2014-05-19', 2, 'inkoop', 'Motorrijtuigenbelasting 17/5-16/8', 0.00, 'belasting', '69414993M44', '', '');
INSERT INTO journaal VALUES (506, 24, 2014, '2014-01-25', 1, 'verkoop', 'Muurschildering logo', 0.00, 'tvk', '2014002', '', '');
INSERT INTO journaal VALUES (485, 3, 2014, '2014-01-09', 1, 'inkoop', 'Internet jan 25% zakelijk deel', 0.00, 'xs4all', '43254092', '', '');
INSERT INTO journaal VALUES (486, 4, 2014, '2014-01-20', 1, 'inkoop', 'Mobiel jan', 0.00, 'tmobile', '901208815968', '', '');
INSERT INTO journaal VALUES (530, 48, 2014, '2014-05-21', 2, 'verkoop', 'Graffiti schildering op doek', 0.00, 'coppoolse', '2014007', '', '');
INSERT INTO journaal VALUES (499, 17, 2014, '2014-01-31', 1, 'kas', 'Kasblad 01 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (487, 5, 2014, '2014-01-23', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'vanbeek', '1063733', '', '');
INSERT INTO journaal VALUES (507, 25, 2014, '2014-02-04', 1, 'verkoop', 'Muurschildering wereldsteden', 0.00, 'dennis', '2014003', '', '');
INSERT INTO journaal VALUES (488, 6, 2014, '2014-01-28', 1, 'inkoop', 'Molotow spuitmateriaal', 0.00, 'publikat', 'RE1208572', '', '');
INSERT INTO journaal VALUES (536, 54, 2014, '2014-08-09', 3, 'inkoop', 'Internet aug', 0.00, 'xs4all', '44965935', '', '');
INSERT INTO journaal VALUES (527, 45, 2014, '2014-06-30', 2, 'kas', 'Contante verkopen 2e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (531, 49, 2014, '2014-06-30', 2, 'memo', 'BTW egalisatie boekingsperiode 2', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO journaal VALUES (490, 8, 2014, '2014-02-09', 1, 'inkoop', 'Internet feb 25% zakelijk deel', 0.00, 'xs4all', '43499507', '', '');
INSERT INTO journaal VALUES (519, 37, 2014, '2014-05-26', 2, 'inkoop', 'Morsverf Latex', 0.00, 'claasen', '814979', '', '');
INSERT INTO journaal VALUES (491, 9, 2014, '2014-02-19', 1, 'inkoop', 'Mobiel feb', 0.00, 'tmobile', '901211073049', '', '');
INSERT INTO journaal VALUES (509, 27, 2014, '2014-03-31', 1, 'memo', 'BTW egalisatie boekingsperiode 1', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO journaal VALUES (492, 10, 2014, '2014-02-17', 1, 'inkoop', 'Motorrijtuigenbelasting Nissan 17-02/16-05', 0.00, 'belasting', '694.14.993.M.4.2', '', '');
INSERT INTO journaal VALUES (493, 11, 2014, '2014-02-18', 1, 'inkoop', 'SSD schijf webserver', 0.00, 'altern', '424179850', '', '');
INSERT INTO journaal VALUES (510, 28, 2014, '2014-04-01', 2, 'inkoop', 'Printerinkt', 0.00, '123inkt', '4912088', '', '');
INSERT INTO journaal VALUES (494, 12, 2014, '2014-03-01', 1, 'inkoop', 'Spuitmateriaal', 0.00, 'vanbeek', '1082792', '', '');
INSERT INTO journaal VALUES (520, 38, 2014, '2014-05-27', 2, 'inkoop', 'Update backup software', 0.00, 'acronis', '73634548279', '', '');
INSERT INTO journaal VALUES (495, 13, 2014, '2014-03-09', 1, 'inkoop', 'Internet mrt 25% zakelijk deel', 0.00, 'xs4all', '43742381', '', '');
INSERT INTO journaal VALUES (532, 50, 2014, '2014-07-09', 3, 'inkoop', 'Internet jul', 0.00, 'xs4all', '44714386', '', '');
INSERT INTO journaal VALUES (496, 14, 2014, '2014-03-14', 1, 'inkoop', 'Verf en doek', 0.00, 'vanbeek', '1089195', '', '');
INSERT INTO journaal VALUES (500, 18, 2014, '2014-02-28', 1, 'kas', 'Kasblad 02 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (526, 44, 2014, '2014-06-30', 2, 'kas', 'Kasblad 06 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (521, 39, 2014, '2014-05-27', 2, 'inkoop', 'Spuitmateriaal', 0.00, 'kramer', '94514', '', '');
INSERT INTO journaal VALUES (512, 30, 2014, '2014-04-16', 2, 'inkoop', 'Keuring en onderhoud', 0.00, 'hofman', '2014099', '', '');
INSERT INTO journaal VALUES (497, 15, 2014, '2014-03-19', 1, 'inkoop', 'Mobiel mrt', 0.00, 'tmobile', '901213303053', '', '');
INSERT INTO journaal VALUES (498, 16, 2014, '2014-03-24', 1, 'inkoop', 'Glaswerk tbv display', 0.00, 'vandijken', '60593', '', '');
INSERT INTO journaal VALUES (513, 31, 2014, '2014-04-17', 2, 'inkoop', 'Advertentieplaatsingen', 0.00, 'marktplaats', '140405677', '', '');
INSERT INTO journaal VALUES (524, 42, 2014, '2014-04-30', 2, 'kas', 'Kasblad 04 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (522, 40, 2014, '2014-06-09', 2, 'inkoop', 'Internet jun', 0.00, 'xs4all', '44470835', '', '');
INSERT INTO journaal VALUES (514, 32, 2014, '2014-04-21', 2, 'inkoop', 'Mobiel apr', 0.00, 'tmobile', '0901215510197', '', '');
INSERT INTO journaal VALUES (501, 19, 2014, '2014-03-31', 1, 'kas', 'Kasblad 03 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (489, 7, 2014, '2014-02-01', 1, 'inkoop', 'LG G2 smartphone', 0.00, 'mediamarkt', '40753381', '', '');
INSERT INTO journaal VALUES (537, 55, 2014, '2014-08-14', 3, 'inkoop', 'Nissan 11/8-11/11', 0.00, 'vandien', '20157465', '', '');
INSERT INTO journaal VALUES (502, 20, 2014, '2014-02-12', 1, 'inkoop', 'Advertentieplaatsingen jan 2014', 0.00, 'marktplaats', '140205801', '', '');
INSERT INTO journaal VALUES (503, 21, 2014, '2014-03-10', 1, 'inkoop', 'Advertentieplaatsingen feb 2014', 0.00, 'marktplaats', '140305458', '', '');
INSERT INTO journaal VALUES (533, 51, 2014, '2014-07-21', 3, 'inkoop', 'Telefoon 16/7-15/8', 0.00, 'tmobile', '901222065965', '', '');
INSERT INTO journaal VALUES (511, 29, 2014, '2014-04-09', 2, 'inkoop', 'Internet apr', 0.00, 'xs4all', '43985891', '', '');
INSERT INTO journaal VALUES (516, 34, 2014, '2014-05-14', 2, 'inkoop', 'Spuitmaskers', 0.00, 'engelb', '305931', '', '');
INSERT INTO journaal VALUES (504, 22, 2014, '2014-03-21', 1, 'inkoop', 'Wrappen Nissan in blauw', 0.00, 'objekt', '14700233', '', '');
INSERT INTO journaal VALUES (505, 23, 2014, '2014-01-24', 1, 'verkoop', 'Beschilderen Surfboards', 0.00, 'fitzroy', '2014001', '', '');
INSERT INTO journaal VALUES (541, 59, 2014, '2014-08-30', 3, 'inkoop', 'Nissan Kleine beurt', 0.00, 'hofman', '2014211', '', '');
INSERT INTO journaal VALUES (515, 33, 2014, '2014-05-09', 2, 'inkoop', 'Internet mei', 0.00, 'xs4all', '44229892', '', '');
INSERT INTO journaal VALUES (518, 36, 2014, '2014-05-20', 2, 'inkoop', 'Mobiel mei', 0.00, 'tmobile', '901217664084', '', '');
INSERT INTO journaal VALUES (523, 41, 2014, '2014-06-18', 2, 'inkoop', 'Mobiel jun', 0.00, 'tmobile', '901219904199', '', '');
INSERT INTO journaal VALUES (538, 56, 2014, '2014-08-18', 3, 'inkoop', 'Nissan 17/8-16/11', 0.00, 'belasting', '69414993M46', '', '');
INSERT INTO journaal VALUES (534, 52, 2014, '2014-07-26', 3, 'inkoop', 'Asus pad 7inch', 0.00, 'mediamarkt', '40808626', '', '');
INSERT INTO journaal VALUES (528, 46, 2014, '2014-04-11', 2, 'verkoop', 'Muurschildering Jeugdhonk Nieuw Lekkerland', 0.00, 'midholl', '2014004', '', '');
INSERT INTO journaal VALUES (529, 47, 2014, '2014-04-11', 2, 'verkoop', 'Diverse muurschilderingen binnen', 0.00, 'lbc', '2014005', '', '');
INSERT INTO journaal VALUES (535, 53, 2014, '2014-08-06', 3, 'inkoop', 'Morsverf Latex', 0.00, 'claasen', '824815', '', '');
INSERT INTO journaal VALUES (544, 62, 2014, '2014-09-20', 3, 'inkoop', 'Linnen', 0.00, 'vanbeek', '1169725', '', '');
INSERT INTO journaal VALUES (539, 57, 2014, '2014-08-20', 3, 'inkoop', 'Telefoon 16/8-15/9', 0.00, 'tmobile', '901224253796', '', '');
INSERT INTO journaal VALUES (542, 60, 2014, '2014-09-08', 3, 'inkoop', 'Aanpassing schadevrije jaren van 74 naar 72%', 0.00, 'vandien', '20168476', '', '');
INSERT INTO journaal VALUES (525, 43, 2014, '2014-05-31', 2, 'kas', 'Kasblad 05 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (540, 58, 2014, '2014-08-21', 3, 'inkoop', 'Nieuwe Accu Nissan', 0.00, 'hofman', '201424', '', '');
INSERT INTO journaal VALUES (547, 65, 2014, '2014-09-25', 3, 'inkoop', 'Spuitmateriaal', 0.00, 'publikat', 'RE1425857', '', '');
INSERT INTO journaal VALUES (543, 61, 2014, '2014-09-09', 3, 'inkoop', 'Internet sep', 0.00, 'xs4all', '45205585', '', '');
INSERT INTO journaal VALUES (545, 63, 2014, '2014-09-20', 3, 'inkoop', 'Acryl', 0.00, 'vanbeek', '1169731', '', '');
INSERT INTO journaal VALUES (546, 64, 2014, '2014-09-22', 3, 'inkoop', 'Telefoon 16/9-15/10', 0.00, 'tmobile', '901226471417', '', '');
INSERT INTO journaal VALUES (548, 66, 2014, '2014-09-27', 3, 'inkoop', 'Linnen ruilen en bijbetalen', 0.00, 'vanbeek', '1173616', '', '');
INSERT INTO journaal VALUES (550, 68, 2014, '2014-07-11', 3, 'verkoop', 'Muurschildering', 0.00, 'luc4me', '201409', '', '');
INSERT INTO journaal VALUES (551, 69, 2014, '2014-07-11', 3, 'verkoop', 'Houten paneel', 0.00, 'luc4me', '201410', '', '');
INSERT INTO journaal VALUES (553, 71, 2014, '2014-07-09', 3, 'verkoop', 'Live Graffitischildering op doek', 0.00, 'leeuwenauto', '201408', '', '');
INSERT INTO journaal VALUES (556, 74, 2014, '2014-09-30', 3, 'kas', 'Kasblad 09 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (555, 73, 2014, '2014-08-31', 3, 'kas', 'Kasblad 08 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (554, 72, 2014, '2014-07-31', 3, 'kas', 'Kasblad 07 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (557, 75, 2014, '2014-09-30', 3, 'kas', 'Contante verkopen 3e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (558, 76, 2014, '2014-09-30', 3, 'memo', 'BTW egalisatie boekingsperiode 3', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO journaal VALUES (552, 70, 2014, '2014-07-20', 3, 'verkoop', 'Schildering plafond', 0.00, 'rooiehoek', '201411', '', '');
INSERT INTO journaal VALUES (559, 77, 2014, '2014-10-04', 4, 'inkoop', 'Diverse lijsten', 0.00, 'vanbeek', '1176316', '', '');
INSERT INTO journaal VALUES (560, 78, 2014, '2014-10-06', 4, 'inkoop', 'Nissan 11-11/11-02', 0.00, 'vandien', '20307233', '', '');
INSERT INTO journaal VALUES (561, 79, 2014, '2014-10-09', 4, 'inkoop', 'Internet okt', 0.00, 'xs4all', '45446171', '', '');
INSERT INTO journaal VALUES (508, 26, 2014, '2014-03-31', 1, 'kas', 'Contante verkopen 1e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (562, 80, 2014, '2014-10-15', 4, 'inkoop', 'Div latex', 0.00, 'claasen', '834584', '', '');
INSERT INTO journaal VALUES (580, 98, 2014, '2014-12-24', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'publikat', '1521969', '', '');
INSERT INTO journaal VALUES (563, 81, 2014, '2014-10-15', 4, 'inkoop', 'Doek', 0.00, 'vanbeek', '1182558', '', '');
INSERT INTO journaal VALUES (564, 82, 2014, '2014-10-15', 4, 'inkoop', 'Domeinnaam graffitinaam.nl', 0.00, 'Transip', '2014.0033.8711', '', '');
INSERT INTO journaal VALUES (581, 99, 2014, '2014-12-24', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'publikat', '1521981', '', '');
INSERT INTO journaal VALUES (565, 83, 2014, '2014-10-20', 4, 'inkoop', 'Telefoon 16/10-15/11', 0.00, 'tmobile', '901228639766', '', '');
INSERT INTO journaal VALUES (566, 84, 2014, '2014-10-29', 4, 'inkoop', 'Diverse Katoen', 0.00, 'vanbeek', '1188996', '', '');
INSERT INTO journaal VALUES (582, 100, 2014, '2014-12-30', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'kramer', '97167', '', '');
INSERT INTO journaal VALUES (567, 85, 2014, '2014-11-09', 4, 'inkoop', 'Internet nov', 0.00, 'xs4all', '45689593', '', '');
INSERT INTO journaal VALUES (568, 86, 2014, '2014-11-17', 4, 'inkoop', 'Nissan 17-11/16-02', 0.00, 'belasting', '69414993M48', '', '');
INSERT INTO journaal VALUES (583, 101, 2014, '2014-12-10', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'kramer', '96917', '', '');
INSERT INTO journaal VALUES (569, 87, 2014, '2014-11-20', 4, 'inkoop', 'Advertentieplaatsing', 0.00, 'marktplaats', '141106171', '', '');
INSERT INTO journaal VALUES (570, 88, 2014, '2014-11-24', 4, 'inkoop', 'Telefoon 16/11-15/12', 0.00, 'tmobile', '901230784760', '', '');
INSERT INTO journaal VALUES (584, 102, 2014, '2014-12-16', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'kramer', '97019', '', '');
INSERT INTO journaal VALUES (571, 89, 2014, '2014-11-24', 4, 'inkoop', 'Katoen', 0.00, 'vanbeek', '1202600', '', '');
INSERT INTO journaal VALUES (594, 112, 2014, '2014-12-31', 4, 'kas', 'Contante verkopen 4e kwartaal nagekomen bonnnen', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (572, 90, 2014, '2014-11-24', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'vanbeek', '1202598', '', '');
INSERT INTO journaal VALUES (585, 103, 2014, '2014-10-08', 4, 'verkoop', 'Beschildering betonnen onderzetters', 0.00, 'luc4me', '201412', '', '');
INSERT INTO journaal VALUES (573, 91, 2014, '2014-12-01', 4, 'inkoop', 'Domeinnamen', 0.00, 'Transip', '201400402714', '', '');
INSERT INTO journaal VALUES (593, 111, 2014, '2014-12-31', 5, 'memo', 'BTW Correctie privegebruik Nissan', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (595, 113, 2014, '2014-12-31', 4, 'memo', 'BTW 5d vermindering inboeken', 0.00, '', '', '5dregeling', 'Automatische boeking van vermindering volgens BTW regeling voor kleinondernemers');
INSERT INTO journaal VALUES (586, 104, 2014, '2014-10-20', 4, 'verkoop', 'Schilderen bestaand beeldmerk', 0.00, 'luc4me', '201413', '', '');
INSERT INTO journaal VALUES (574, 92, 2014, '2014-12-09', 4, 'inkoop', 'Internet dec', 0.00, 'xs4all', '45932076', '', '');
INSERT INTO journaal VALUES (596, 114, 2014, '2014-12-31', 4, 'memo', 'BTW egalisatie boekingsperiode 4', 0.00, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO journaal VALUES (597, 1, 2014, '2014-01-01', 0, 'begin', 'Beginbalans', 0.00, '', '', 'begin', 'Automatische boeking van beginbalans in het nieuwe boekjaar');
INSERT INTO journaal VALUES (587, 105, 2014, '2014-11-08', 4, 'verkoop', 'Muurschildering', 0.00, 'crossfit', '201414', '', '');
INSERT INTO journaal VALUES (576, 94, 2014, '2014-12-11', 4, 'inkoop', 'Advertentieplaatsing', 0.00, 'marktplaats', '141205836', '', '');
INSERT INTO journaal VALUES (589, 107, 2014, '2014-10-31', 4, 'kas', 'Kasblad 10 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (588, 106, 2014, '2014-11-18', 4, 'verkoop', 'Muurschildering portret', 0.00, 'mulder', '2014015', '', '');
INSERT INTO journaal VALUES (578, 96, 2014, '2014-12-18', 4, 'inkoop', 'Telefoon 16/12-15/01', 0.00, 'tmobile', '901232952490', '', '');
INSERT INTO journaal VALUES (579, 97, 2014, '2014-12-24', 4, 'inkoop', 'Spuitmaterialen', 0.00, 'publikat', '1521948', '', '');
INSERT INTO journaal VALUES (599, 116, 2014, '2014-12-31', 5, 'memo', 'Afschrijving Nissan NV200', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (590, 108, 2014, '2014-11-30', 4, 'kas', 'Kasblad 11 2014', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (600, 117, 2014, '2014-12-31', 5, 'memo', 'Prive ontvangen Debiteurensaldo', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (592, 110, 2014, '2014-12-31', 4, 'kas', 'Contante verkopen 4e kwartaal', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (601, 118, 2014, '2014-12-31', 5, 'memo', 'Prive betaald Crediteurensaldo', 0.00, '', '', '', '');
INSERT INTO journaal VALUES (591, 109, 2014, '2014-12-31', 4, 'kas', 'Kasblad 12 2014', 0.00, '', '', '', '');


--
-- Data for Name: kostenplaatsen; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO kostenplaatsen VALUES (1, 100000, 900000, 0, 'Activa');
INSERT INTO kostenplaatsen VALUES (2, 110000, 100000, 0, 'Vaste activa');
INSERT INTO kostenplaatsen VALUES (3, 120000, 110000, 0, 'Immateriele vaste activa');
INSERT INTO kostenplaatsen VALUES (4, 121000, 120000, 0, 'Overige immateriele vaste activa');
INSERT INTO kostenplaatsen VALUES (5, 122000, 121000, 1, 'Intellectuele eigendom');
INSERT INTO kostenplaatsen VALUES (6, 123000, 120000, 1, 'Goodwill');
INSERT INTO kostenplaatsen VALUES (7, 130000, 110000, 0, 'Materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (8, 131000, 130000, 0, 'Bedrijfsgebouwen en terreinen');
INSERT INTO kostenplaatsen VALUES (9, 132000, 130000, 0, 'Machines en installaties');
INSERT INTO kostenplaatsen VALUES (10, 133000, 130000, 0, 'Overige materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (11, 134000, 133000, 0, 'Bedrijfsauto''s');
INSERT INTO kostenplaatsen VALUES (12, 134100, 134000, 1, 'Opel');
INSERT INTO kostenplaatsen VALUES (13, 134200, 134000, 1, 'Nissan');
INSERT INTO kostenplaatsen VALUES (14, 140000, 110000, 0, 'Financiele vaste activa');
INSERT INTO kostenplaatsen VALUES (15, 150000, 100000, 0, 'Vlottende activa');
INSERT INTO kostenplaatsen VALUES (16, 160000, 150000, 0, 'Voorraden excl. onderhanden werk');
INSERT INTO kostenplaatsen VALUES (17, 161000, 160000, 1, 'Voorraad atelier');
INSERT INTO kostenplaatsen VALUES (18, 170000, 150000, 0, 'Vorderingen');
INSERT INTO kostenplaatsen VALUES (19, 171000, 170000, 1, 'Debiteuren');
INSERT INTO kostenplaatsen VALUES (20, 180000, 150000, 0, 'Effecten');
INSERT INTO kostenplaatsen VALUES (21, 190000, 150000, 0, 'Liquide middelen');
INSERT INTO kostenplaatsen VALUES (22, 191100, 190000, 1, 'Kas');
INSERT INTO kostenplaatsen VALUES (23, 191200, 190000, 1, 'ABN-AMRO bank');
INSERT INTO kostenplaatsen VALUES (24, 191500, 190000, 1, 'Prive rekening courant');
INSERT INTO kostenplaatsen VALUES (25, 300000, 900000, 0, 'Passiva');
INSERT INTO kostenplaatsen VALUES (26, 310000, 300000, 0, 'Eigen vermogen');
INSERT INTO kostenplaatsen VALUES (27, 311000, 310000, 0, 'Gestort en opgevraagd kapitaal');
INSERT INTO kostenplaatsen VALUES (28, 311100, 311000, 0, 'Gestort kapitaal');
INSERT INTO kostenplaatsen VALUES (29, 311200, 311000, 0, 'Opgevraagd kapitaal');
INSERT INTO kostenplaatsen VALUES (30, 320000, 300000, 0, 'Voorzieningen');
INSERT INTO kostenplaatsen VALUES (31, 321000, 320000, 0, 'Voorzieningen voor pensioenen');
INSERT INTO kostenplaatsen VALUES (32, 322000, 320000, 0, 'Voorzieningen voor belastingen');
INSERT INTO kostenplaatsen VALUES (33, 322100, 322000, 1, 'Voorziening voor Inkomstenbelasting');
INSERT INTO kostenplaatsen VALUES (34, 322200, 322000, 1, 'Voorziening voor Omzetbelasting');
INSERT INTO kostenplaatsen VALUES (35, 323000, 320000, 0, 'Voorzieningen overige');
INSERT INTO kostenplaatsen VALUES (36, 330000, 300000, 0, 'Langlopende schulden');
INSERT INTO kostenplaatsen VALUES (37, 331000, 330000, 0, 'Schulden aan kredietinstellingen');
INSERT INTO kostenplaatsen VALUES (38, 331100, 331000, 1, 'Financiering Nissan');
INSERT INTO kostenplaatsen VALUES (39, 332000, 330000, 0, 'Schulden aan leveranciers en handelskredieten');
INSERT INTO kostenplaatsen VALUES (40, 333000, 330000, 0, 'Belastingen en premies sociale verzekeringen');
INSERT INTO kostenplaatsen VALUES (41, 333100, 333000, 1, 'Omzetbelasting af te dragen');
INSERT INTO kostenplaatsen VALUES (42, 350000, 300000, 0, 'Kortlopende schulden');
INSERT INTO kostenplaatsen VALUES (43, 351000, 350000, 0, 'Schulden aan kredietinstellingen');
INSERT INTO kostenplaatsen VALUES (44, 352000, 350000, 0, 'Schulden aan leveranciers en handelskredieten');
INSERT INTO kostenplaatsen VALUES (45, 352100, 352000, 1, 'Crediteuren');
INSERT INTO kostenplaatsen VALUES (46, 353000, 350000, 0, 'Belastingen en premies sociale verzekeringen');
INSERT INTO kostenplaatsen VALUES (47, 400000, 900000, 0, 'Kosten');
INSERT INTO kostenplaatsen VALUES (48, 410000, 400000, 0, 'Personeelskosten');
INSERT INTO kostenplaatsen VALUES (49, 420000, 400000, 0, 'Overige bedrijfskosten');
INSERT INTO kostenplaatsen VALUES (50, 430000, 420000, 0, 'Huisvestingskosten');
INSERT INTO kostenplaatsen VALUES (51, 431000, 430000, 1, 'Huur atelier Boskoop');
INSERT INTO kostenplaatsen VALUES (52, 432000, 430000, 1, 'Overige kosten huisvesting');
INSERT INTO kostenplaatsen VALUES (53, 440000, 420000, 0, 'Onderhoudskosten overige materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (54, 450000, 420000, 0, 'Verkoopkosten');
INSERT INTO kostenplaatsen VALUES (55, 451000, 450000, 1, 'Promotiekosten');
INSERT INTO kostenplaatsen VALUES (56, 452000, 450000, 1, 'Acquisitiekosten');
INSERT INTO kostenplaatsen VALUES (57, 460000, 420000, 0, 'Andere kosten');
INSERT INTO kostenplaatsen VALUES (58, 461000, 460000, 1, 'Atelierkosten');
INSERT INTO kostenplaatsen VALUES (59, 462000, 460000, 1, 'Kantoorkosten');
INSERT INTO kostenplaatsen VALUES (60, 463000, 460000, 1, 'Kantinekosten');
INSERT INTO kostenplaatsen VALUES (61, 464000, 460000, 1, 'Klein apparatuur');
INSERT INTO kostenplaatsen VALUES (62, 465000, 460000, 1, 'Telefoon Internet Porti');
INSERT INTO kostenplaatsen VALUES (63, 468000, 460000, 1, 'Diverse kosten');
INSERT INTO kostenplaatsen VALUES (64, 470000, 420000, 0, 'Kosten auto''s');
INSERT INTO kostenplaatsen VALUES (65, 471000, 470000, 0, 'Kosten Opel');
INSERT INTO kostenplaatsen VALUES (66, 471100, 471000, 1, 'Brandstof Opel');
INSERT INTO kostenplaatsen VALUES (67, 471200, 471000, 1, 'Onderhoud en reparatie Opel');
INSERT INTO kostenplaatsen VALUES (68, 471300, 471000, 1, 'Verzekering Opel');
INSERT INTO kostenplaatsen VALUES (69, 471400, 471000, 1, 'Wegenbelasting Opel');
INSERT INTO kostenplaatsen VALUES (70, 471500, 471000, 1, 'Overige kosten Opel');
INSERT INTO kostenplaatsen VALUES (71, 471700, 471000, 1, 'BTW privegebruik Opel');
INSERT INTO kostenplaatsen VALUES (72, 471800, 471000, 1, 'Prive-bijtelling Opel');
INSERT INTO kostenplaatsen VALUES (73, 471900, 471000, 1, 'Saldo verkoop Opel');
INSERT INTO kostenplaatsen VALUES (74, 481000, 470000, 0, 'Kosten Nissan');
INSERT INTO kostenplaatsen VALUES (75, 481100, 481000, 1, 'Brandstof Nissan');
INSERT INTO kostenplaatsen VALUES (76, 481200, 481000, 1, 'Onderhoud en reparatie Nissan');
INSERT INTO kostenplaatsen VALUES (77, 481300, 481000, 1, 'Verzekering Nissan');
INSERT INTO kostenplaatsen VALUES (78, 481400, 481000, 1, 'Wegenbelasting Nissan');
INSERT INTO kostenplaatsen VALUES (79, 481500, 481000, 1, 'Overige kosten Nissan');
INSERT INTO kostenplaatsen VALUES (80, 481700, 481000, 1, 'BTW privegebruik Nissan');
INSERT INTO kostenplaatsen VALUES (81, 481800, 481000, 1, 'Prive-bijtelling Nissan');
INSERT INTO kostenplaatsen VALUES (82, 481900, 481000, 1, 'Saldo verkoop Nissan');
INSERT INTO kostenplaatsen VALUES (83, 500000, 400000, 0, 'Afschrijvingen');
INSERT INTO kostenplaatsen VALUES (84, 510000, 470000, 0, 'Afschrijvingen auto''s');
INSERT INTO kostenplaatsen VALUES (85, 511000, 471000, 1, 'Afschrijving Opel');
INSERT INTO kostenplaatsen VALUES (86, 512000, 481000, 1, 'Afschrijving Nissan');
INSERT INTO kostenplaatsen VALUES (87, 520000, 500000, 0, 'Afschrijvingen materiele activa');
INSERT INTO kostenplaatsen VALUES (88, 530000, 500000, 0, 'Afschrijvingen vlottende activa');
INSERT INTO kostenplaatsen VALUES (89, 531000, 530000, 1, 'Afschrijving materialen');
INSERT INTO kostenplaatsen VALUES (90, 532000, 530000, 1, 'Afschrijving debiteuren');
INSERT INTO kostenplaatsen VALUES (91, 600000, 400000, 0, 'Inkoopkosten');
INSERT INTO kostenplaatsen VALUES (92, 610000, 600000, 1, 'Inkoop materialen');
INSERT INTO kostenplaatsen VALUES (93, 620000, 600000, 1, 'Kosten uitbesteed werk e.a. externe kosten');
INSERT INTO kostenplaatsen VALUES (94, 700000, 900000, 0, 'Financiele baten en lasten');
INSERT INTO kostenplaatsen VALUES (95, 710000, 700000, 1, 'Opbrengsten banktegoeden');
INSERT INTO kostenplaatsen VALUES (96, 730000, 700000, 1, 'Waardevermindering van vorderingen');
INSERT INTO kostenplaatsen VALUES (97, 770000, 700000, 1, 'Kosten van schulden, rentelasten etc.');
INSERT INTO kostenplaatsen VALUES (98, 800000, 900000, 0, 'Totaal opbrengsten: fiscaal');
INSERT INTO kostenplaatsen VALUES (99, 810000, 800000, 0, 'Netto-omzet');
INSERT INTO kostenplaatsen VALUES (100, 820000, 800000, 1, 'Overige opbrengsten');
INSERT INTO kostenplaatsen VALUES (101, 820000, 810000, 0, 'Opbrengsten zakelijk');
INSERT INTO kostenplaatsen VALUES (102, 821000, 820000, 1, 'Schilderijen zakelijk');
INSERT INTO kostenplaatsen VALUES (103, 822000, 820000, 1, 'Spuitwerk zakelijk');
INSERT INTO kostenplaatsen VALUES (104, 823000, 820000, 1, 'Ontwerp en logos zakelijk');
INSERT INTO kostenplaatsen VALUES (105, 824000, 820000, 1, 'Workshops zakelijk');
INSERT INTO kostenplaatsen VALUES (106, 830000, 810000, 0, 'Opbrengsten prive');
INSERT INTO kostenplaatsen VALUES (107, 831000, 830000, 1, 'Schilderijen prive');
INSERT INTO kostenplaatsen VALUES (108, 832000, 830000, 1, 'Spuitwerk prive');
INSERT INTO kostenplaatsen VALUES (109, 833000, 830000, 1, 'Ontwerp en logos prive');
INSERT INTO kostenplaatsen VALUES (110, 834000, 830000, 1, 'Workshops prive');
INSERT INTO kostenplaatsen VALUES (111, 850000, 810000, 0, 'Opbrengsten buitenland');
INSERT INTO kostenplaatsen VALUES (112, 851000, 850000, 1, 'Opbrengsten Duitsland');
INSERT INTO kostenplaatsen VALUES (113, 852000, 850000, 1, 'Opbrengsten Belgie');
INSERT INTO kostenplaatsen VALUES (114, 900000, NULL, 0, 'Batig saldo');


--
-- Name: kostenplaatsen_identifier_seq; Type: SEQUENCE SET; Schema: public; Owner: www
--

SELECT pg_catalog.setval('kostenplaatsen_identifier_seq', 114, true);


--
-- Data for Name: meta; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO meta VALUES ('versie', '1.0.0');
INSERT INTO meta VALUES ('platform', 'linux');
INSERT INTO meta VALUES ('sqlversie', '1.17.0');


--
-- Data for Name: notities; Type: TABLE DATA; Schema: public; Owner: www
--



--
-- Data for Name: pinbetalingen; Type: TABLE DATA; Schema: public; Owner: www
--



--
-- Data for Name: stamgegevens; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO stamgegevens VALUES (1, 2008, 'a', 1, 'Naam administratie', 'adminnaam', 'KoogerKunst', '');
INSERT INTO stamgegevens VALUES (2, 2008, 'a', 3, 'Contactgegevens', 'adminomschrijving', 'Fa. Timmerman, meubels
att. Rogier Timmerman
Dwarsbalk 18
1234 ZZ Amsterdam

telefoon: 0123 456789
fax: 0123 4455667
mobiel: 062 1234567
email: rogier@timmerman.biz', '');
INSERT INTO stamgegevens VALUES (4, 2008, 'b', 3, 'Periode van', 'periodevan', '1', '');
INSERT INTO stamgegevens VALUES (5, 2008, 'b', 5, 'Periode tot', 'periodetot', '4', '');
INSERT INTO stamgegevens VALUES (6, 2008, 'b', 7, 'Extra periode', 'periodeextra', '5', '');
INSERT INTO stamgegevens VALUES (21, 2008, 'e', 5, 'Rekening bankboek', 'rkg_bankboek', '1050', '');
INSERT INTO stamgegevens VALUES (20, 2008, 'e', 3, 'Rekening kasboek', 'rkg_kasboek', '1000', '');
INSERT INTO stamgegevens VALUES (19, 2008, 'e', 13, 'Rekening pinbetalingen', 'rkg_pinbetalingen', '2020', '');
INSERT INTO stamgegevens VALUES (18, 2008, 'g', 3, 'BTW percentage laag', 'btwverkooplaag', '6', '');
INSERT INTO stamgegevens VALUES (14, 2008, ' ', 0, 'Verschillenrekening', 'rkg_verschillen', '2500', '');
INSERT INTO stamgegevens VALUES (8, 2008, 'e', 9, 'Rekening debiteuren', 'rkg_debiteuren', '1200', '');
INSERT INTO stamgegevens VALUES (9, 2008, 'e', 11, 'Rekening crediteuren', 'rkg_crediteuren', '1600', '');
INSERT INTO stamgegevens VALUES (7, 2008, 'e', 1, 'Rekening kapitaal/prive', 'rkg_kapitaalprive', '900', '');
INSERT INTO stamgegevens VALUES (24, 2008, 'e', 27, 'Rekening Diverse Opbrengsten', 'rkg_divopbrengsten', '8900', '');
INSERT INTO stamgegevens VALUES (26, 2008, 'e', 7, 'Rekening Prive rekeningcourant', 'rkg_priverekeningcourant', '1060', '');
INSERT INTO stamgegevens VALUES (27, 2008, 'e', 30, 'Omslagrekening Balans/VW', 'omslag', '4000', 'Bepaal vanaf welk rekeningnummer de Balansrekeningen eindigen en de VenW rekeningen beginnen.');
INSERT INTO stamgegevens VALUES (29, 2010, 'a', 3, 'Contactgegevens', 'adminomschrijving', 'Kooger Kunst
Ruud Kooger
Sirius 18
2743 ME Waddinxveen

telefoon: 0182 611557
fax: 0182 611557
mobiel: 0638160870
email: info@koogerkunst.nl', '');
INSERT INTO stamgegevens VALUES (30, 2010, 'b', 5, 'Periode tot', 'periodetot', '4', '');
INSERT INTO stamgegevens VALUES (31, 2010, 'b', 7, 'Extra periode', 'periodeextra', '5', '');
INSERT INTO stamgegevens VALUES (33, 2010, 'e', 3, 'Rekening kasboek', 'rkg_kasboek', '1060', '');
INSERT INTO stamgegevens VALUES (17, 2008, 'g', 1, 'BTW percentage hoog', 'btwverkoophoog', '19', '');
INSERT INTO stamgegevens VALUES (34, 2012, 'g', 1, 'BTW percentage hoog', 'btwverkoophoog', '21', '');
INSERT INTO stamgegevens VALUES (35, 2014, 'a', 3, 'Contactgegevens', 'adminomschrijving', 'Kooger Kunst
Ruud Kooger
Weremeus Buninglaan 58
2741 ZK Waddinxveen

mobiel: 0638160870
email: info@koogerkunst.nl', '');
INSERT INTO stamgegevens VALUES (3, 2008, 'b', 1, 'Lopend jaar', 'lopendjaar', '2014', '');


--
-- Data for Name: verkoopfacturen; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO verkoopfacturen VALUES (1, 1, 2011, '2010-12-06', 'Schildering logo in restaurant', 196.35, 'elgusto', 1, '29134', 196.35, '2010-12-31');
INSERT INTO verkoopfacturen VALUES (2, 2, 2011, '2010-12-10', 'Griffiti Workshop Nederlek', 1000.00, 'midholl', 2, '29135', 1000.00, '2010-12-31');
INSERT INTO verkoopfacturen VALUES (3, 3, 2011, '2011-01-09', 'Aanbetaling 18 kunstobjecten op glas', 7518.42, 'woonp', 3, '2011001', 7518.42, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (4, 4, 2011, '2011-01-18', 'Schilderij', 130.01, 'particulier', 4, '2011002', 130.01, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (5, 5, 2011, '2011-01-19', 'Jongeren workshops', 360.00, 'midholl', 2, '2011003', 360.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (6, 6, 2011, '2011-01-27', 'Materiaalkosten workshop 13 mei', 303.45, 'cenf', 6, '2011004', 303.45, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (7, 23, 2011, '2011-02-10', 'Schildering paneel', 226.10, 'taxione', 5, '2011005', 226.10, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (8, 24, 2011, '2011-02-12', 'Workshop Schoonhoven', 855.00, 'midholl', 2, '2011006', 855.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (9, 25, 2011, '2011-02-16', 'Workshop opening JOP Zuidplas', 300.00, 'midholl', 2, '2011007', 300.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (10, 26, 2011, '2011-02-24', 'Restant 18 kunstobjecten in glas', 4048.38, 'woonp', 3, '2011008', 4048.38, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (11, 51, 2011, '2011-03-20', 'Muurschildering Dico en Bo', 571.20, 'particulier', 4, '2011009', 571.20, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (12, 52, 2011, '2011-03-31', 'Schilderij Stones afscheidscadeau', 150.00, 'mwh', 7, '2011010', 150.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (13, 60, 2011, '2011-04-27', 'Schildering Willie File Voorstraat 26', 267.75, 'ipse', 8, '2011011', 267.75, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (14, 61, 2011, '2011-05-05', 'Muurschildering Zuidplas', 285.60, 'woonp', 3, '2011012', 285.60, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (15, 62, 2011, '2011-05-05', 'Muurschildering Zuidplas ingang2', 242.76, 'woonp', 3, '2011013', 242.76, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (16, 63, 2011, '2011-05-16', 'Materialen tbv workshops', 367.71, 'cenf', 6, '2011014', 367.71, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (17, 64, 2011, '2011-05-31', 'Schildering op paneel', 238.00, 'midholl', 2, '2011015', 238.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (18, 65, 2011, '2011-06-01', 'Muurschildering goPasta', 595.00, 'gopdelft', 9, '2011016', 595.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (19, 66, 2011, '2011-06-02', 'Ontwerp character dready dreadzz', 199.99, 'dread', 10, '2011017', 199.99, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (20, 67, 2011, '2011-06-23', 'Muurschildering goPasta veenendaal', 595.00, 'rood', 11, '2011017', 595.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (21, 88, 2011, '2011-06-25', 'Muurschildering Daen, i.o. Jeroen Verboom', 743.75, 'particulier', 4, '2011018', 743.75, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (22, 89, 2011, '2011-06-29', 'Muurschildering Rafiq iov Erik van Dam', 357.00, 'particulier', 4, '2011019', 357.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (23, 90, 2011, '2011-06-29', 'Schilderij en muursch Janet Flierman', 535.50, 'particulier', 4, '2011020', 535.50, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (24, 92, 2011, '2011-07-24', 'Schildering Wiebine', 377.83, 'ipse', 8, '2011021', 377.83, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (25, 93, 2011, '2011-08-18', 'Muurschildering', 327.25, 'stek', 12, '2011022', 327.25, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (26, 94, 2011, '2011-08-19', 'Schildering Benjamin', 238.00, 'ipse', 8, '2011024', 238.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (27, 95, 2011, '2011-08-18', 'Schilderij We Will Rock You', 499.80, 'vdEnde', 14, '2011023', 499.80, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (28, 96, 2011, '2011-08-26', 'Muurschildering binnenmuur', 333.20, 'kruimels', 13, '2011025', 333.20, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (29, 97, 2011, '2011-09-01', 'Menukaart', 422.45, 'kruimels', 13, '2011026', 422.45, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (30, 98, 2011, '2011-09-19', 'Muurschildering goPasta Bremen', 625.00, 'gopbremen', 15, '2011027', 625.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (31, 99, 2011, '2011-09-19', 'Schilderij Anne-Fleur Derks', 150.00, 'particulier', 4, '2011028', 150.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (32, 141, 2011, '2011-10-17', 'Schutting reclame', 595.71, 'spruyt', 16, '2011029', 595.71, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (33, 142, 2011, '2011-11-23', 'Reclameschildering Irenetunnel', 178.50, 'gopdelft', 9, '2011030', 178.50, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (34, 143, 2011, '2011-12-13', 'Muurschildering Kerkweg Oost en Onthulling', 1190.00, 'woonp', 3, '2011031', 1190.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (35, 144, 2011, '2011-12-30', 'Schilderij', 119.00, 'JJB', 17, '2011032', 119.00, '2011-12-31');
INSERT INTO verkoopfacturen VALUES (57, 240, 2012, '2012-02-28', 'Muurschildering deel 2 en 3', 719.95, 'skihutu', 31, '2012003', 300.00, '2012-02-28');
INSERT INTO verkoopfacturen VALUES (55, 238, 2012, '2012-01-22', 'Muurschildering deel 1', 282.63, 'skihutu', 31, '2012001', 282.63, '2012-01-22');
INSERT INTO verkoopfacturen VALUES (56, 239, 2012, '2012-02-29', 'Schilderij Indonesie', 238.00, 'ipse', 8, '2012002', 238.00, '2012-02-29');
INSERT INTO verkoopfacturen VALUES (58, 356, 2012, '2012-04-05', 'Graffitiworkshop Lekkerkerk', 499.80, 'midholl', 2, '2012005', 499.80, '2012-04-05');
INSERT INTO verkoopfacturen VALUES (59, 357, 2012, '2012-05-05', 'Wandschilderingen Freiburg', 1100.00, 'gopfreib', 32, '2012006', 1100.00, '2012-05-05');
INSERT INTO verkoopfacturen VALUES (60, 358, 2012, '2012-05-05', 'Muurschildering binnen', 583.10, 'zuleico', 33, '2012008', 583.10, '2012-05-05');
INSERT INTO verkoopfacturen VALUES (61, 359, 2012, '2012-05-05', 'Muurschildering binnen', 470.05, 'interior', 34, '2012007', 470.05, '2012-05-05');
INSERT INTO verkoopfacturen VALUES (62, 360, 2012, '2012-06-05', 'Workshop', 535.50, 'midholl', 2, '2012009', 535.50, '2012-06-05');
INSERT INTO verkoopfacturen VALUES (63, 361, 2012, '2012-06-14', 'Muurschildering binnen', 333.20, 'hako', 35, '2012010', 333.20, '2012-06-14');
INSERT INTO verkoopfacturen VALUES (64, 362, 2012, '2012-06-29', 'Muurschildering binnen', 315.35, 'saffier', 36, '2012011', 315.35, '2012-06-29');
INSERT INTO verkoopfacturen VALUES (65, 363, 2012, '2012-07-17', 'Muurschildering skyline Rotterdam', 1671.95, 'oudenes', 37, '2012012', 1671.95, '2012-07-17');
INSERT INTO verkoopfacturen VALUES (66, 364, 2012, '2012-07-27', 'Muurschildering Cirkelflat', 4317.32, 'woonp', 3, '2012013', 4317.32, '2012-07-27');
INSERT INTO verkoopfacturen VALUES (67, 365, 2012, '2012-07-27', 'Herstellen muursch. Kerkweg Oost', 59.50, 'woonp', 3, '2012014', 59.50, '2012-07-27');
INSERT INTO verkoopfacturen VALUES (68, 366, 2012, '2012-07-30', 'Muurschildering bijwerken', 178.50, 'russel', 38, '2012015', 178.50, '2012-07-30');
INSERT INTO verkoopfacturen VALUES (69, 367, 2012, '2012-07-30', 'Muurschildering binnen', 150.00, 'thurley', 39, '2012016', 150.00, '2012-07-30');
INSERT INTO verkoopfacturen VALUES (70, 368, 2012, '2012-08-07', 'Ontwerp en realisatie boekje', 2607.29, 'woonp', 3, '2012017', 2607.29, '2012-08-07');
INSERT INTO verkoopfacturen VALUES (71, 369, 2012, '2012-08-07', 'Muurschildering Broadbents', 392.50, 'russel', 38, '2012018', 392.50, '2012-08-07');
INSERT INTO verkoopfacturen VALUES (72, 370, 2012, '2012-08-21', 'Muurschildering Femtastic', 476.00, 'femtastic', 40, '2012019', 476.00, '2012-08-21');
INSERT INTO verkoopfacturen VALUES (73, 371, 2012, '2012-09-12', 'Workshop streetart', 119.00, 'grvenen', 41, '2012020', 119.00, '2012-09-12');
INSERT INTO verkoopfacturen VALUES (41, 218, 2013, '2013-04-06', 'Schilderij Wicked', 508.20, 'vdEnde', 14, '2013006', 508.20, '2013-04-06');
INSERT INTO verkoopfacturen VALUES (74, 372, 2012, '2012-09-18', 'Muurschildering binnen', 571.20, 'quarijn', 42, '2012021', 571.20, '2012-09-18');
INSERT INTO verkoopfacturen VALUES (75, 373, 2012, '2012-10-11', 'Muurschildering ronde muur', 1052.70, 'quarijn', 42, '2012022', 1052.70, '2012-10-11');
INSERT INTO verkoopfacturen VALUES (76, 374, 2012, '2012-10-11', 'Muurschildering bruin cafe', 266.81, 'leeuwen', 47, '2012023', 266.81, '2012-10-11');
INSERT INTO verkoopfacturen VALUES (77, 375, 2012, '2012-10-14', 'Muurschildering bruin cafe', 484.00, 'smit', 46, '2012024', 484.00, '2012-10-14');
INSERT INTO verkoopfacturen VALUES (78, 376, 2012, '2012-11-10', 'Muurschildering binnen', 296.45, 'ipse', 8, '2012025', 296.45, '2012-11-10');
INSERT INTO verkoopfacturen VALUES (79, 377, 2012, '2012-11-11', 'Live painting thema', 738.10, 'ordemed', 45, '2012026', 738.10, '2012-11-11');
INSERT INTO verkoopfacturen VALUES (80, 378, 2012, '2012-11-26', 'Workshop personeel', 354.15, 'rabozhm', 44, '2012027', 354.15, '2012-11-26');
INSERT INTO verkoopfacturen VALUES (81, 379, 2012, '2012-11-28', 'Muurschilderingen binnen', 1089.00, 'rooiehoek', 21, '2012028', 1089.00, '2012-11-28');
INSERT INTO verkoopfacturen VALUES (82, 380, 2012, '2012-12-11', 'Muurschildering marktkraam', 786.50, 'intwell', 43, '2012028', 786.50, '2012-12-11');
INSERT INTO verkoopfacturen VALUES (83, 381, 2012, '2012-03-28', 'Nog nakijken', 185.00, 'particulier', 4, '2012004', 185.00, '2012-03-28');
INSERT INTO verkoopfacturen VALUES (84, 393, 2012, '2012-02-28', 'Dummy factuur', 185.00, 'particulier', 4, '2012004', 185.00, '2012-02-28');
INSERT INTO verkoopfacturen VALUES (97, 505, 2014, '2014-01-24', 'Beschilderen Surfboards', 544.50, 'fitzroy', 56, '2014001', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (98, 506, 2014, '2014-01-25', 'Muurschildering logo', 199.65, 'tvk', 57, '2014002', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (99, 507, 2014, '2014-02-04', 'Muurschildering wereldsteden', 326.70, 'dennis', 58, '2014003', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (100, 528, 2014, '2014-04-11', 'Muurschildering Jeugdhonk Nieuw Lekkerland', 355.74, 'midholl', 2, '2014004', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (101, 529, 2014, '2014-04-11', 'Diverse muurschilderingen binnen', 745.66, 'lbc', 59, '2014005', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (102, 530, 2014, '2014-05-21', 'Graffiti schildering op doek', 157.30, 'coppoolse', 25, '2014007', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (103, 550, 2014, '2014-07-11', 'Muurschildering', 308.55, 'luc4me', 60, '201409', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (104, 551, 2014, '2014-07-11', 'Houten paneel', 36.30, 'luc4me', 60, '201410', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (106, 553, 2014, '2014-07-09', 'Live Graffitischildering op doek', 605.00, 'leeuwenauto', 61, '201408', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (105, 552, 2014, '2014-07-20', 'Schildering plafond', 726.00, 'rooiehoek', 21, '201411', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (36, 181, 2013, '2013-01-14', 'Muurschildering FC Utrecht, Zwammerdam', 341.83, 'ipse', 8, '2013001', 341.83, '2013-01-14');
INSERT INTO verkoopfacturen VALUES (37, 182, 2013, '2013-02-20', 'Muurschilderingen Alexandertunnel, 25%', 1238.19, 'bomenwijk', 20, '2013002', 1238.19, '2013-02-20');
INSERT INTO verkoopfacturen VALUES (38, 183, 2013, '2013-02-27', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', 5926.73, 'bomenwijk', 20, '2013003', 5926.73, '2013-02-27');
INSERT INTO verkoopfacturen VALUES (39, 184, 2013, '2013-03-06', 'Muurschildering binnen', 540.00, 'gopantw', 19, '2013004', 540.00, '2013-03-06');
INSERT INTO verkoopfacturen VALUES (40, 185, 2013, '2013-03-16', 'Presentatie graffiti 30 minuten', 60.50, 'kernel', 18, '2013005', 60.50, '2013-03-16');
INSERT INTO verkoopfacturen VALUES (42, 219, 2013, '2013-04-13', 'Schildering Rolluik', 290.40, 'rooiehoek', 21, '2013007', 290.40, '2013-04-13');
INSERT INTO verkoopfacturen VALUES (43, 220, 2013, '2013-04-23', 'Graffitiworkshop opening Skatepark', 302.50, 'bomenwijk', 20, '2013008', 302.50, '2013-04-23');
INSERT INTO verkoopfacturen VALUES (44, 221, 2013, '2013-05-05', 'Wandschilderingen', 867.87, 'eataly', 22, '2013009', 867.87, '2013-05-05');
INSERT INTO verkoopfacturen VALUES (45, 222, 2013, '2013-05-05', 'Logo Freenorm', 423.50, 'freedom', 30, '201310', 423.50, '2013-05-05');
INSERT INTO verkoopfacturen VALUES (46, 223, 2013, '2013-05-09', 'Schilderij Vermeer', 284.35, 'annders', 24, '201311', 284.35, '2013-05-09');
INSERT INTO verkoopfacturen VALUES (47, 224, 2013, '2013-05-14', 'Wandschildering bloemen', 330.94, 'ipse', 8, '201312', 330.94, '2013-05-14');
INSERT INTO verkoopfacturen VALUES (48, 225, 2013, '2013-05-20', 'Schilderij Vermeer bijwerken', 50.00, 'annders', 24, '201313', 50.00, '2013-05-20');
INSERT INTO verkoopfacturen VALUES (49, 226, 2013, '2013-05-20', 'Wandschildering fotostudio', 225.00, 'coppoolse', 25, '201314', 225.00, '2013-05-20');
INSERT INTO verkoopfacturen VALUES (50, 227, 2013, '2013-05-30', 'Graffitiworkshop', 550.55, 'horizon', 26, '201315', 550.55, '2013-05-30');
INSERT INTO verkoopfacturen VALUES (51, 228, 2013, '2013-06-06', 'Schildering op kaasdoek', 133.27, 'coppoolse', 25, '201316', 133.27, '2013-06-06');
INSERT INTO verkoopfacturen VALUES (52, 229, 2013, '2013-06-10', 'Wandschildering Las Vegas', 726.00, 'markies', 27, '201317', 726.00, '2013-06-10');
INSERT INTO verkoopfacturen VALUES (53, 230, 2013, '2013-06-18', 'Wandschildering buitenmuur', 704.46, 'butterfly', 28, '201318', 704.46, '2013-06-18');
INSERT INTO verkoopfacturen VALUES (54, 231, 2013, '2013-06-19', 'Verkoop Opel Combi', 1512.50, 'koops', 29, '201319', 1512.50, '2013-06-19');
INSERT INTO verkoopfacturen VALUES (85, 427, 2013, '2013-07-02', 'Muurschildering Beatles', 484.30, 'ipse', 8, '2013020', 484.30, '2013-07-02');
INSERT INTO verkoopfacturen VALUES (86, 428, 2013, '2013-07-02', 'Muurschildering poorten icm workshop', 677.60, 'quawonen', 48, '201321', 677.60, '2013-07-02');
INSERT INTO verkoopfacturen VALUES (87, 429, 2013, '2013-07-02', 'Graffitiworkshop container', 393.25, 'hockey', 49, '2013022', 393.25, '2013-07-02');
INSERT INTO verkoopfacturen VALUES (88, 430, 2013, '2013-07-05', 'Schilderij danseres', 242.00, 'dadanza', 50, '2013023', 242.00, '2013-07-05');
INSERT INTO verkoopfacturen VALUES (89, 431, 2013, '2013-07-27', 'Muurschilderingen restaurant', 1458.05, 'ppannekoek', 51, '2013024', 1458.05, '2013-07-27');
INSERT INTO verkoopfacturen VALUES (90, 432, 2013, '2013-08-25', 'Restant Alexandertunnel', 3714.58, 'bomenwijk', 20, '2013025', 3714.58, '2013-08-25');
INSERT INTO verkoopfacturen VALUES (91, 433, 2013, '2013-08-30', 'Muurschildering paarden', 330.94, 'ipse', 8, '2013026', 330.94, '2013-08-30');
INSERT INTO verkoopfacturen VALUES (92, 434, 2013, '2013-09-05', 'Muurschildering BigBen', 199.65, 'ppannekoek', 51, '2013027', 199.65, '2013-09-05');
INSERT INTO verkoopfacturen VALUES (93, 435, 2013, '2013-09-23', 'Presentatie graffiti', 60.50, 'nsveiligh', 52, '2013028', 60.50, '2013-09-23');
INSERT INTO verkoopfacturen VALUES (94, 438, 2013, '2013-11-22', 'Muurschildering Logo', 302.50, 'jaguacy', 53, '2013029', 302.50, '2013-11-22');
INSERT INTO verkoopfacturen VALUES (95, 439, 2013, '2013-11-29', 'Muurschildering graffiti project', 290.40, 'stolwijk', 54, '2013030', 290.40, '2013-11-29');
INSERT INTO verkoopfacturen VALUES (96, 440, 2013, '2013-12-18', 'Workshops jeugd', 665.50, 'krimpen', 55, '2013031', 665.50, '2013-12-18');
INSERT INTO verkoopfacturen VALUES (107, 585, 2014, '2014-10-08', 'Beschildering betonnen onderzetters', 30.25, 'luc4me', 60, '201412', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (108, 586, 2014, '2014-10-20', 'Schilderen bestaand beeldmerk', 332.75, 'luc4me', 60, '201413', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (109, 587, 2014, '2014-11-08', 'Muurschildering', 605.00, 'crossfit', 62, '201414', 0.00, '1900-01-01');
INSERT INTO verkoopfacturen VALUES (110, 588, 2014, '2014-11-18', 'Muurschildering portret', 302.50, 'mulder', 63, '2014015', 0.00, '1900-01-01');


--
-- Data for Name: verkoopfacturenx; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO verkoopfacturenx VALUES (1, 1, 2011, '2010-12-06', 'Schildering logo in restaurant', 196.35, 'elgusto', 1, '29134', 196.35, '2010-12-31');
INSERT INTO verkoopfacturenx VALUES (2, 2, 2011, '2010-12-10', 'Griffiti Workshop Nederlek', 1000.00, 'midholl', 2, '29135', 1000.00, '2010-12-31');
INSERT INTO verkoopfacturenx VALUES (3, 3, 2011, '2011-01-09', 'Aanbetaling 18 kunstobjecten op glas', 7518.42, 'woonp', 3, '2011001', 7518.42, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (4, 4, 2011, '2011-01-18', 'Schilderij', 130.01, 'particulier', 4, '2011002', 130.01, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (5, 5, 2011, '2011-01-19', 'Jongeren workshops', 360.00, 'midholl', 2, '2011003', 360.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (6, 6, 2011, '2011-01-27', 'Materiaalkosten workshop 13 mei', 303.45, 'cenf', 6, '2011004', 303.45, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (7, 23, 2011, '2011-02-10', 'Schildering paneel', 226.10, 'taxione', 5, '2011005', 226.10, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (8, 24, 2011, '2011-02-12', 'Workshop Schoonhoven', 855.00, 'midholl', 2, '2011006', 855.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (9, 25, 2011, '2011-02-16', 'Workshop opening JOP Zuidplas', 300.00, 'midholl', 2, '2011007', 300.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (10, 26, 2011, '2011-02-24', 'Restant 18 kunstobjecten in glas', 4048.38, 'woonp', 3, '2011008', 4048.38, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (11, 51, 2011, '2011-03-20', 'Muurschildering Dico en Bo', 571.20, 'particulier', 4, '2011009', 571.20, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (12, 52, 2011, '2011-03-31', 'Schilderij Stones afscheidscadeau', 150.00, 'mwh', 7, '2011010', 150.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (13, 60, 2011, '2011-04-27', 'Schildering Willie File Voorstraat 26', 267.75, 'ipse', 8, '2011011', 267.75, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (14, 61, 2011, '2011-05-05', 'Muurschildering Zuidplas', 285.60, 'woonp', 3, '2011012', 285.60, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (15, 62, 2011, '2011-05-05', 'Muurschildering Zuidplas ingang2', 242.76, 'woonp', 3, '2011013', 242.76, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (16, 63, 2011, '2011-05-16', 'Materialen tbv workshops', 367.71, 'cenf', 6, '2011014', 367.71, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (17, 64, 2011, '2011-05-31', 'Schildering op paneel', 238.00, 'midholl', 2, '2011015', 238.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (18, 65, 2011, '2011-06-01', 'Muurschildering goPasta', 595.00, 'gopdelft', 9, '2011016', 595.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (19, 66, 2011, '2011-06-02', 'Ontwerp character dready dreadzz', 199.99, 'dread', 10, '2011017', 199.99, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (20, 67, 2011, '2011-06-23', 'Muurschildering goPasta veenendaal', 595.00, 'rood', 11, '2011017', 595.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (21, 88, 2011, '2011-06-25', 'Muurschildering Daen, i.o. Jeroen Verboom', 743.75, 'particulier', 4, '2011018', 743.75, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (22, 89, 2011, '2011-06-29', 'Muurschildering Rafiq iov Erik van Dam', 357.00, 'particulier', 4, '2011019', 357.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (23, 90, 2011, '2011-06-29', 'Schilderij en muursch Janet Flierman', 535.50, 'particulier', 4, '2011020', 535.50, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (24, 92, 2011, '2011-07-24', 'Schildering Wiebine', 377.83, 'ipse', 8, '2011021', 377.83, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (25, 93, 2011, '2011-08-18', 'Muurschildering', 327.25, 'stek', 12, '2011022', 327.25, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (26, 94, 2011, '2011-08-19', 'Schildering Benjamin', 238.00, 'ipse', 8, '2011024', 238.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (27, 95, 2011, '2011-08-18', 'Schilderij We Will Rock You', 499.80, 'vdEnde', 14, '2011023', 499.80, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (28, 96, 2011, '2011-08-26', 'Muurschildering binnenmuur', 333.20, 'kruimels', 13, '2011025', 333.20, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (29, 97, 2011, '2011-09-01', 'Menukaart', 422.45, 'kruimels', 13, '2011026', 422.45, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (30, 98, 2011, '2011-09-19', 'Muurschildering goPasta Bremen', 625.00, 'gopbremen', 15, '2011027', 625.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (31, 99, 2011, '2011-09-19', 'Schilderij Anne-Fleur Derks', 150.00, 'particulier', 4, '2011028', 150.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (32, 141, 2011, '2011-10-17', 'Schutting reclame', 595.71, 'spruyt', 16, '2011029', 595.71, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (33, 142, 2011, '2011-11-23', 'Reclameschildering Irenetunnel', 178.50, 'gopdelft', 9, '2011030', 178.50, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (34, 143, 2011, '2011-12-13', 'Muurschildering Kerkweg Oost en Onthulling', 1190.00, 'woonp', 3, '2011031', 1190.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (35, 144, 2011, '2011-12-30', 'Schilderij', 119.00, 'JJB', 17, '2011032', 119.00, '2011-12-31');
INSERT INTO verkoopfacturenx VALUES (36, 181, 2013, '2013-01-14', 'Muurschildering FC Utrecht, Zwammerdam', 341.83, 'ipse', 8, '2013001', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (37, 182, 2013, '2013-02-20', 'Muurschilderingen Alexandertunnel, 25%', 1238.19, 'bomenwijk', 20, '2013002', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (38, 183, 2013, '2013-02-27', 'Garantie muurschilderingen Alexandertunnel, 4 jaar', 5926.73, 'bomenwijk', 20, '2013003', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (39, 184, 2013, '2013-03-06', 'Muurschildering binnen', 540.00, 'gopantw', 19, '2013004', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (40, 185, 2013, '2013-03-16', 'Presentatie graffiti 30 minuten', 60.50, 'kernel', 18, '2013005', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (41, 218, 2013, '2013-04-06', 'Schilderij Wicked', 508.20, 'vdEnde', 14, '2013006', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (42, 219, 2013, '2013-04-13', 'Schildering Rolluik', 290.40, 'rooiehoek', 21, '2013007', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (43, 220, 2013, '2013-04-23', 'Graffitiworkshop opening Skatepark', 302.50, 'bomenwijk', 20, '2013008', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (44, 221, 2013, '2013-05-05', 'Wandschilderingen', 867.87, 'eataly', 22, '2013009', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (45, 222, 2013, '2013-05-05', 'Logo Freenorm', 423.50, 'freedom', 30, '201310', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (46, 223, 2013, '2013-05-09', 'Schilderij Vermeer', 284.35, 'annders', 24, '201311', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (47, 224, 2013, '2013-05-14', 'Wandschildering bloemen', 330.94, 'ipse', 8, '201312', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (48, 225, 2013, '2013-05-20', 'Schilderij Vermeer bijwerken', 50.00, 'annders', 24, '201313', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (49, 226, 2013, '2013-05-20', 'Wandschildering fotostudio', 225.00, 'coppoolse', 25, '201314', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (50, 227, 2013, '2013-05-30', 'Graffitiworkshop', 550.55, 'horizon', 26, '201315', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (51, 228, 2013, '2013-06-06', 'Schildering op kaasdoek', 133.27, 'coppoolse', 25, '201316', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (52, 229, 2013, '2013-06-10', 'Wandschildering Las Vegas', 726.00, 'markies', 27, '201317', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (53, 230, 2013, '2013-06-18', 'Wandschildering buitenmuur', 704.46, 'butterfly', 28, '201318', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (54, 231, 2013, '2013-06-19', 'Verkoop Opel Combi', 1512.50, 'koops', 29, '201319', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (57, 240, 2012, '2012-02-28', 'Muurschildering deel 2 en 3', 719.95, 'skihutu', 31, '2012003', 300.00, '2012-02-28');
INSERT INTO verkoopfacturenx VALUES (55, 238, 2012, '2012-01-22', 'Muurschildering deel 1', 282.63, 'skihutu', 31, '2012001', 282.63, '2012-01-22');
INSERT INTO verkoopfacturenx VALUES (56, 239, 2012, '2012-02-29', 'Schilderij Indonesie', 238.00, 'ipse', 8, '2012002', 238.00, '2012-02-29');
INSERT INTO verkoopfacturenx VALUES (58, 356, 2012, '2012-04-05', 'Graffitiworkshop Lekkerkerk', 499.80, 'midholl', 2, '2012005', 499.80, '2012-04-05');
INSERT INTO verkoopfacturenx VALUES (59, 357, 2012, '2012-05-05', 'Wandschilderingen Freiburg', 1100.00, 'gopfreib', 32, '2012006', 1100.00, '2012-05-05');
INSERT INTO verkoopfacturenx VALUES (60, 358, 2012, '2012-05-05', 'Muurschildering binnen', 583.10, 'zuleico', 33, '2012008', 583.10, '2012-05-05');
INSERT INTO verkoopfacturenx VALUES (61, 359, 2012, '2012-05-05', 'Muurschildering binnen', 470.05, 'interior', 34, '2012007', 470.05, '2012-05-05');
INSERT INTO verkoopfacturenx VALUES (62, 360, 2012, '2012-06-05', 'Workshop', 535.50, 'midholl', 2, '2012009', 535.50, '2012-06-05');
INSERT INTO verkoopfacturenx VALUES (63, 361, 2012, '2012-06-14', 'Muurschildering binnen', 333.20, 'hako', 35, '2012010', 333.20, '2012-06-14');
INSERT INTO verkoopfacturenx VALUES (64, 362, 2012, '2012-06-29', 'Muurschildering binnen', 315.35, 'saffier', 36, '2012011', 315.35, '2012-06-29');
INSERT INTO verkoopfacturenx VALUES (65, 363, 2012, '2012-07-17', 'Muurschildering skyline Rotterdam', 1671.95, 'oudenes', 37, '2012012', 1671.95, '2012-07-17');
INSERT INTO verkoopfacturenx VALUES (66, 364, 2012, '2012-07-27', 'Muurschildering Cirkelflat', 4317.32, 'woonp', 3, '2012013', 4317.32, '2012-07-27');
INSERT INTO verkoopfacturenx VALUES (67, 365, 2012, '2012-07-27', 'Herstellen muursch. Kerkweg Oost', 59.50, 'woonp', 3, '2012014', 59.50, '2012-07-27');
INSERT INTO verkoopfacturenx VALUES (68, 366, 2012, '2012-07-30', 'Muurschildering bijwerken', 178.50, 'russel', 38, '2012015', 178.50, '2012-07-30');
INSERT INTO verkoopfacturenx VALUES (69, 367, 2012, '2012-07-30', 'Muurschildering binnen', 150.00, 'thurley', 39, '2012016', 150.00, '2012-07-30');
INSERT INTO verkoopfacturenx VALUES (70, 368, 2012, '2012-08-07', 'Ontwerp en realisatie boekje', 2607.29, 'woonp', 3, '2012017', 2607.29, '2012-08-07');
INSERT INTO verkoopfacturenx VALUES (71, 369, 2012, '2012-08-07', 'Muurschildering Broadbents', 392.50, 'russel', 38, '2012018', 392.50, '2012-08-07');
INSERT INTO verkoopfacturenx VALUES (72, 370, 2012, '2012-08-21', 'Muurschildering Femtastic', 476.00, 'femtastic', 40, '2012019', 476.00, '2012-08-21');
INSERT INTO verkoopfacturenx VALUES (73, 371, 2012, '2012-09-12', 'Workshop streetart', 119.00, 'grvenen', 41, '2012020', 119.00, '2012-09-12');
INSERT INTO verkoopfacturenx VALUES (74, 372, 2012, '2012-09-18', 'Muurschildering binnen', 571.20, 'quarijn', 42, '2012021', 571.20, '2012-09-18');
INSERT INTO verkoopfacturenx VALUES (75, 373, 2012, '2012-10-11', 'Muurschildering ronde muur', 1052.70, 'quarijn', 42, '2012022', 1052.70, '2012-10-11');
INSERT INTO verkoopfacturenx VALUES (76, 374, 2012, '2012-10-11', 'Muurschildering bruin cafe', 266.81, 'leeuwen', 47, '2012023', 266.81, '2012-10-11');
INSERT INTO verkoopfacturenx VALUES (77, 375, 2012, '2012-10-14', 'Muurschildering bruin cafe', 484.00, 'smit', 46, '2012024', 484.00, '2012-10-14');
INSERT INTO verkoopfacturenx VALUES (78, 376, 2012, '2012-11-10', 'Muurschildering binnen', 296.45, 'ipse', 8, '2012025', 296.45, '2012-11-10');
INSERT INTO verkoopfacturenx VALUES (79, 377, 2012, '2012-11-11', 'Live painting thema', 738.10, 'ordemed', 45, '2012026', 738.10, '2012-11-11');
INSERT INTO verkoopfacturenx VALUES (80, 378, 2012, '2012-11-26', 'Workshop personeel', 354.15, 'rabozhm', 44, '2012027', 354.15, '2012-11-26');
INSERT INTO verkoopfacturenx VALUES (81, 379, 2012, '2012-11-28', 'Muurschilderingen binnen', 1089.00, 'rooiehoek', 21, '2012028', 1089.00, '2012-11-28');
INSERT INTO verkoopfacturenx VALUES (82, 380, 2012, '2012-12-11', 'Muurschildering marktkraam', 786.50, 'intwell', 43, '2012028', 786.50, '2012-12-11');
INSERT INTO verkoopfacturenx VALUES (83, 381, 2012, '2012-03-28', 'Nog nakijken', 185.00, 'particulier', 4, '2012004', 185.00, '2012-03-28');
INSERT INTO verkoopfacturenx VALUES (84, 393, 2012, '2012-02-28', 'Dummy factuur', 185.00, 'particulier', 4, '2012004', 185.00, '2012-02-28');
INSERT INTO verkoopfacturenx VALUES (85, 427, 2013, '2013-07-02', 'Muurschildering Beatles', 484.30, 'ipse', 8, '2013020', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (86, 428, 2013, '2013-07-02', 'Muurschildering poorten icm workshop', 677.60, 'quawonen', 48, '201321', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (87, 429, 2013, '2013-07-02', 'Graffitiworkshop container', 393.25, 'hockey', 49, '2013022', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (88, 430, 2013, '2013-07-05', 'Schilderij danseres', 242.00, 'dadanza', 50, '2013023', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (89, 431, 2013, '2013-07-27', 'Muurschilderingen restaurant', 1458.05, 'ppannekoek', 51, '2013024', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (90, 432, 2013, '2013-08-25', 'Restant Alexandertunnel', 3714.58, 'bomenwijk', 20, '2013025', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (91, 433, 2013, '2013-08-30', 'Muurschildering paarden', 330.94, 'ipse', 8, '2013026', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (92, 434, 2013, '2013-09-05', 'Muurschildering BigBen', 199.65, 'ppannekoek', 51, '2013027', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (93, 435, 2013, '2013-09-23', 'Presentatie graffiti', 60.50, 'nsveiligh', 52, '2013028', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (94, 438, 2013, '2013-11-22', 'Muurschildering Logo', 302.50, 'jaguacy', 53, '2013029', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (95, 439, 2013, '2013-11-29', 'Muurschildering graffiti project', 290.40, 'stolwijk', 54, '2013030', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (96, 440, 2013, '2013-12-18', 'Workshops jeugd', 665.50, 'krimpen', 55, '2013031', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (97, 505, 2014, '2014-01-24', 'Beschilderen Surfboards', 544.50, 'fitzroy', 56, '2014001', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (98, 506, 2014, '2014-01-25', 'Muurschildering logo', 199.65, 'tvk', 57, '2014002', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (99, 507, 2014, '2014-02-04', 'Muurschildering wereldsteden', 326.70, 'dennis', 58, '2014003', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (100, 528, 2014, '2014-04-11', 'Muurschildering Jeugdhonk Nieuw Lekkerland', 355.74, 'midholl', 2, '2014004', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (101, 529, 2014, '2014-04-11', 'Diverse muurschilderingen binnen', 745.66, 'lbc', 59, '2014005', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (102, 530, 2014, '2014-05-21', 'Graffiti schildering op doek', 157.30, 'coppoolse', 25, '2014007', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (103, 550, 2014, '2014-07-11', 'Muurschildering', 308.55, 'luc4me', 60, '201409', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (104, 551, 2014, '2014-07-11', 'Houten paneel', 36.30, 'luc4me', 60, '201410', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (106, 553, 2014, '2014-07-09', 'Live Graffitischildering op doek', 605.00, 'leeuwenauto', 61, '201408', 0.00, '1900-01-01');
INSERT INTO verkoopfacturenx VALUES (105, 552, 2014, '2014-07-20', 'Schildering plafond', 726.00, 'rooiehoek', 21, '201411', 0.00, '1900-01-01');


--
-- Data for Name: voorkeuren; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO voorkeuren VALUES (1, 'Facturen tonen in debiteuren/crediteurenstam', 'facturen_tonen', 'true');
INSERT INTO voorkeuren VALUES (2, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');


--
-- Data for Name: vwbtw; Type: TABLE DATA; Schema: public; Owner: www
--

INSERT INTO vwbtw VALUES (2014, 1, '1a', '1a. Leveringen/diensten belast met hoog tarief', 1848, 388);
INSERT INTO vwbtw VALUES (2014, 1, '5a', '5a. Verschuldigde omzetbelasting: rubrieken 1 tm 4', NULL, 388);
INSERT INTO vwbtw VALUES (2014, 1, '5b', '5b. Voorbelasting', NULL, 769);
INSERT INTO vwbtw VALUES (2014, 1, '5c', '5c. Subtotaal: 5a min 5b', NULL, -381);
INSERT INTO vwbtw VALUES (2014, 1, '5e', '5e. Totaal', NULL, -381);
INSERT INTO vwbtw VALUES (2014, 2, '1a', '1a. Leveringen/diensten belast met hoog tarief', 1619, 340);
INSERT INTO vwbtw VALUES (2014, 2, '5a', '5a. Verschuldigde omzetbelasting: rubrieken 1 tm 4', NULL, 340);
INSERT INTO vwbtw VALUES (2014, 2, '5b', '5b. Voorbelasting', NULL, 407);
INSERT INTO vwbtw VALUES (2014, 2, '5c', '5c. Subtotaal: 5a min 5b', NULL, -67);
INSERT INTO vwbtw VALUES (2014, 2, '5e', '5e. Totaal', NULL, -67);
INSERT INTO vwbtw VALUES (2014, 3, '1a', '1a. Leveringen/diensten belast met hoog tarief', 2009, 422);
INSERT INTO vwbtw VALUES (2014, 3, '5a', '5a. Verschuldigde omzetbelasting: rubrieken 1 tm 4', NULL, 422);
INSERT INTO vwbtw VALUES (2014, 3, '5b', '5b. Voorbelasting', NULL, 374);
INSERT INTO vwbtw VALUES (2014, 3, '5c', '5c. Subtotaal: 5a min 5b', NULL, 48);
INSERT INTO vwbtw VALUES (2014, 3, '5e', '5e. Totaal', NULL, 48);


--
-- Name: boekregels_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY boekregels
    ADD CONSTRAINT boekregels_pkey PRIMARY KEY (boekregelid);


--
-- Name: btk_prima; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY btwkeys
    ADD CONSTRAINT btk_prima PRIMARY KEY (key, boekjaar, ccode);


--
-- Name: btwaangiftes_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY btwaangiftes
    ADD CONSTRAINT btwaangiftes_pkey PRIMARY KEY (id);


--
-- Name: btwsaldi_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY btwsaldi
    ADD CONSTRAINT btwsaldi_pkey PRIMARY KEY (periode, ccode);


--
-- Name: crediteurenstam_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY crediteurenstam
    ADD CONSTRAINT crediteurenstam_pkey PRIMARY KEY (id);


--
-- Name: dagboeken_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY dagboeken
    ADD CONSTRAINT dagboeken_pkey PRIMARY KEY (id);


--
-- Name: debiteurenstam_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY debiteurenstam
    ADD CONSTRAINT debiteurenstam_pkey PRIMARY KEY (id);


--
-- Name: eindbalansen_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY eindbalansen
    ADD CONSTRAINT eindbalansen_pkey PRIMARY KEY (id);


--
-- Name: eindbalansregels_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY eindbalansregels
    ADD CONSTRAINT eindbalansregels_pkey PRIMARY KEY (id);


--
-- Name: eindcheck_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY eindcheck
    ADD CONSTRAINT eindcheck_pkey PRIMARY KEY (id);


--
-- Name: grootboekstam_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY grootboekstam
    ADD CONSTRAINT grootboekstam_pkey PRIMARY KEY (id);


--
-- Name: inkoopfacturen_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY inkoopfacturen
    ADD CONSTRAINT inkoopfacturen_pkey PRIMARY KEY (id);


--
-- Name: journaal_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY journaal
    ADD CONSTRAINT journaal_pkey PRIMARY KEY (journaalid);


--
-- Name: kostenplaatsen_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY kostenplaatsen
    ADD CONSTRAINT kostenplaatsen_pkey PRIMARY KEY (identifier);


--
-- Name: meta_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY meta
    ADD CONSTRAINT meta_pkey PRIMARY KEY (key);


--
-- Name: notities_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY notities
    ADD CONSTRAINT notities_pkey PRIMARY KEY (id);


--
-- Name: pinbetalingen_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY pinbetalingen
    ADD CONSTRAINT pinbetalingen_pkey PRIMARY KEY (id);


--
-- Name: pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY btwrelaties
    ADD CONSTRAINT pkey PRIMARY KEY (journaalid, boekregelid, btwrelatie);


--
-- Name: stamgegevens_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY stamgegevens
    ADD CONSTRAINT stamgegevens_pkey PRIMARY KEY (id);


--
-- Name: verkoopfacturen_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY verkoopfacturen
    ADD CONSTRAINT verkoopfacturen_pkey PRIMARY KEY (id);


--
-- Name: voorkeuren_pkey; Type: CONSTRAINT; Schema: public; Owner: www; Tablespace: 
--

ALTER TABLE ONLY voorkeuren
    ADD CONSTRAINT voorkeuren_pkey PRIMARY KEY (id);


--
-- Name: br_grootboekrekening; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX br_grootboekrekening ON boekregels USING btree (grootboekrekening);


--
-- Name: br_idboekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE UNIQUE INDEX br_idboekjaar ON boekregels USING btree (boekregelid, boekjaar);


--
-- Name: br_journaalid; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX br_journaalid ON boekregels USING btree (journaalid);


--
-- Name: bt_grootboekrekening; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX bt_grootboekrekening ON "boekregelsTrash" USING btree (grootboekrekening);


--
-- Name: bt_id; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX bt_id ON "boekregelsTrash" USING btree (boekregelid);


--
-- Name: bt_journaalid; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX bt_journaalid ON "boekregelsTrash" USING btree (journaalid);


--
-- Name: ebr_ideindbalans; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX ebr_ideindbalans ON eindbalansregels USING btree (ideindbalans);


--
-- Name: gbs_boekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX gbs_boekjaar ON grootboeksaldi USING btree (boekjaar);


--
-- Name: gbs_nummer; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX gbs_nummer ON grootboeksaldi USING btree (nummer);


--
-- Name: grbst_combi; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX grbst_combi ON grootboekstam USING btree (nummer, boekjaar, active);


--
-- Name: grbst_combi2; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX grbst_combi2 ON grootboekstam USING btree (boekjaar, nummer, active);


--
-- Name: grbst_nummer; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX grbst_nummer ON grootboekstam USING btree (nummer);


--
-- Name: if_idboekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE UNIQUE INDEX if_idboekjaar ON inkoopfacturen USING btree (id, boekjaar);


--
-- Name: j_dagboekcode; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX j_dagboekcode ON journaal USING btree (dagboekcode);


--
-- Name: j_idboekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE UNIQUE INDEX j_idboekjaar ON journaal USING btree (journaalpost, boekjaar);


--
-- Name: j_periode; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE INDEX j_periode ON journaal USING btree (periode);


--
-- Name: pb_idboekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
--

CREATE UNIQUE INDEX pb_idboekjaar ON pinbetalingen USING btree (id, boekjaar);


--
-- Name: vf_idboekjaar; Type: INDEX; Schema: public; Owner: www; Tablespace: 
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

