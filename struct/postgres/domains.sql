--
-- Deze procedure moet ingelezen voor creatie van de tabels
--
--
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: signed; Type: DOMAIN; Schema: public; Owner: www
--

CREATE DOMAIN "signed" AS integer DEFAULT 0;
ALTER DOMAIN "signed" OWNER TO "www";

-- Domain: "decimal"
-- DROP DOMAIN "decimal";

CREATE DOMAIN "decimal" AS numeric;
ALTER DOMAIN "decimal" OWNER TO "www";

SET default_tablespace = '';
SET default_with_oids = false;

