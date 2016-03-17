sqlite2
=======
verwijder CASTS, die zijn in sqlite2 niet bekend.

verwijder COMMENT (-- of /**/), is niet toegestaan.
Vreemd genoeg werkt COMMENT in de data en struct scripts wel?!
Wellicht een kwestie van filetype (unix/dos)?

vw_periodes werkt niet in sqlite2. Je kan niet sorteren en geen kolomnaam toekennen aan integer constants
dit moet dus met een table opgelost worden.

sqlite3
=======
CASTS zijn toegestaan.
COMMENT is toegestaan.
vw_periodes werkt prima en heeft geen table constructie nodig.

Een sqlite2 views-script kan ook door sqlite3 gelezen worden maar dan mis je mogelijk expliciete CASTS zoals char(2) of decimal.
Of dat tot problemen leidt heb ik nog niet uitgezocht.


beide
=====
Begin een views-script met een ; (puntkomma).
De reader leest eerst een punt aan het begin van het script en als dat voor een normale CREATE VIEW staat, onstaat daar een error
De puntkomma aan het begin geeft weliswaar ook een error maar daarna gaat het script verder met de rest van de componenten.

geen SUBSTRING maar SUBSTR .

Data en struct table scripts zijn gebaseerd op die van Firebird.

