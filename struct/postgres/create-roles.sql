-- perform this als user "postgres":
--   su -
--   su - postgres
--   psql -d template1
--   \i /pub/webs/openadmin/struct/postgres/create-roles.sql
--     of (productie)
--   \i /pub/webs/administratie/struct/postgres/create-roles.sql
--

CREATE ROLE "system" LOGIN
  ENCRYPTED PASSWORD 'md5f7969ba9e7132ab3dd940a6aea559d55'
    SUPERUSER INHERIT CREATEDB CREATEROLE ;

CREATE ROLE "webuser" LOGIN
  ENCRYPTED PASSWORD 'md53d8c6b944e78718563aafccdf0bc4b06'
    NOSUPERUSER INHERIT CREATEDB NOCREATEROLE ;

CREATE GROUP "www";

-- set owner of tables and views to "www":
-- ALTER TABLE "grootboekstam" OWNER TO "www";
--   etc.etc.

-- Add login webuser to group www

GRANT "www" TO "webuser";

