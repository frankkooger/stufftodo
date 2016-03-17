
set SESSION sql_mode='ANSI_QUOTES,PIPES_AS_CONCAT';


-- Update van btwkeys met historie attributen

ALTER TABLE "btwkeys"
ADD COLUMN "boekjaar" integer NOT NULL DEFAULT 0
, ADD COLUMN "active" integer NOT NULL DEFAULT 1;

UPDATE "btwkeys"
SET "boekjaar"=2008;

INSERT INTO "btwkeys" VALUES('verkopen_vrijgesteldebtw', 'sal', 1, '', '', '', 'Verkopen vrijgestelde BTW', '', 2008,1);

UPDATE "meta" SET "value"='1.9.3' WHERE "key"='sqlversie';

