#!/bin/sh
#
# drop tables, views, indexes

test -n "$1" && DBASE=$1 || DBASE='testadministratie'

BASEDIR=/pub/webs/openadmin


test -f "x0" && unlink x0
test -f "x1" && unlink x1

echo "select name from sqlite_master;" | sqlite3 $BASEDIR/data/$DBASE.db3 > x0

for i in $(cat x0); do echo "DROP TABLE IF EXISTS \"$i\" ;" >>x1 ; done

cat x1 | sqlite3 $BASEDIR/data/$DBASE.db3

cat testadmin.sqlite3.sql | sqlite3 $BASEDIR/data/$DBASE.db3

test -f "x0" && unlink x0
