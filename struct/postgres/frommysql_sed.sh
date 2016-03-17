#!/bin/bash

# Een dump uit mysql moet omgebouwd worden om in postgresql te kunnen inlezen
# onderstaande elementen moeten eruit:

cat $1 | sed \
 -e 's|0000-00-00|1900-01-01|g' \
 -e 's| AUTO_INCREMENT||g' \
 -e 's|int(11)|Integer|g' \
 -e 's|tinyint(1)|smallint|g' \
 -e 's|smallint(6)|smallint|g' \
 -e 's|.*KEY.\+||g' \
 -e 's| COMMENT|, --|g' \
 -e 's|^\/.\+\;$||g' \
 -e 's|^DROP TABLE.\+\;$||g' \
> $1.out

#
# Verwijder alles vanaf vw_ tot het einde van de file
#
# Verwijder alle komma's van de laatste regels in CREATE TABLE statements
#  deze zijn blijven staan na het verwijderen van de KEY regels
# Dit doe je met:
# :% s/[,]\n\{2\}/^M/gc
#
# Repareer escape sequences:
# WARNING:  nonstandard use of \' in a string literal
# LINE 621: ...ES (591,119,2011,'2011-09-16',4230,592,0,'','','','DVD\'s le...
#                                                                ^
# HINT:  Use '' to write quotes in strings, or use the escape string syntax (E'...').
# HINT:  Use the escape string syntax for escapes, e.g., E'\r\n'.
# Werkte niet, gebruik ^V^M om echte linebreaks in te voegen.
#                                                                ^
# Doe dit met vi:
# :% s/\\r\\n/^M/g
# en
# :% s/\\'/''/g

# Lees daarna een bestand met CREATE VIEW en CREATE INDEX, CREATE PROCEDURES en GRANT statements
# dat is getrokken van een bestaande postgresql administratie database
#
