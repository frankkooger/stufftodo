#!/bin/sh
#
# drop tables, views, indexes
# Omdat FireBird niet zelf een optie heeft voor SQL dump, gebruiken we een tool fbexport (sourceforge)
#

SHEL=bash
test -n "$1" && DBASE=$1 || DBASE='testadministratie'
USER=webuser
PWD=poedel
BASEDIR=/pub/webs/openadmin
DATADIR=$BASEDIR/data
BIN=/usr/bin/isql-fb
VERSIE=1-3-0

test -f "x0" && unlink x0
test -f "x1" && unlink x1
test -f "dump.sql" && unlink dump.sql

# Lees de user-tabellen in de database en sla op in een tempfile
#
echo "SET HEADING;SELECT RDB\$RELATION_NAME FROM RDB\$RELATIONS WHERE RDB\$RELATION_NAME NOT LIKE '%$%';" \
    | $BIN -u $USER -p $PWD $DATADIR/$DBASE.fdb > x0

for i in $(cat x0); do

if [[ "$SHEL" == 'bourne' ]]; then
  # bij gebruik van sh: (let op! bij CentOS is /bin/sh een logical naar /bin/bash
  #
  LINE='/usr/local/bin/fbexport -Si -D '$DATADIR'/'$DBASE'.fdb -U '$USER' -P '$PWD' -F - -J "Y-M-D" -Q "SELECT \* FROM \"'$i'\"" >>dump.sql'
else  
  # bij gebruik van bash (en dus bij CentOS):
  #
  LINE='/usr/local/bin/fbexport -Si -D '$DATADIR'/'$DBASE'.fdb -U '$USER' -P '$PWD' -F - -J "Y-M-D" -Q "SELECT {*} FROM \"'$i'\"" >>dump.sql'
  # {*} voorkomt dat bash de * expandeert; {} wordt straks via een tussenstap met sed weer verwijderd
fi

  echo $LINE >>x1
  echo 'echo >>dump.sql' >>x1
done

echo 'SET TRANSACTION;' >dump.sql
echo >>dump.sql

if [[ "$SHEL" == 'bourne' ]]; then
  sh x1
else
  # bash:
  cat x1 | sed -e 's/[{}]//g' | sh
fi

echo 'COMMIT;' >>dump.sql

test -f "x0" && unlink x0
test -f "x1" && unlink x1

# bewerk de output
cat dump.sql | sed -e 's/([^)]\+) //' -e 's/values/VALUES/' -e 's/[a-zA-Z0-9]\+/"&"/3' > $DBASE.vulling.firebird.$VERSIE.sql
#
# -e 's/([^)]\+) //' \  # remove fieldnames in INSERT statement; makes the sqldump smaller
# -e 's/values/VALUES/' \  # uppercase 'values'; not strictly neccessary
# -e 's/[a-zA-Z0-9]\+/"&"/3' \  # database name (3rd word) between "; why doesn't fbexport do that?!

test -f "dump.sql" && unlink dump.sql

# De outputfile dumpdata.sql kan nu gebruikt worden als INSERT bestand voor de testdatabase

