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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
     LEFT JOIN kostenplaatsen g ON ((f."ID" = g."parentID")));


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

