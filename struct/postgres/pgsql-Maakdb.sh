#!/bin/bash
#
# Een bupfile van postgresql kan je alleen terugzetten in een lege database.
# !dat is niet helemaal waar: je kan de bupfile ook beginnen met clean commandos!
# Om de bestaande database 'administratie' te verwijderen en een lege aan
# te maken zijn onderstaande commando's
#

test -n "$1" && DBASE=$1 || DBASE='administratiekk'

PGUSER=webuser
PGPASSWORD=poedel
export PGUSER PGPASSWORD

echo "DROP database $DBASE\;" | psql postgres
createdb $DBASE

# of, zonder envir variabelen:
#echo "DROP database $DBASE\;" | psql postgres --username=www -W
#createdb $DBASE --username=www -W
#echo "DROP database $DBASE\;" | psql postgres --username=webuser -W
#createdb $DBASE --username=webuser -W
