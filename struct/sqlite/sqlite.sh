#!/bin/sh
#

test -n "$1" && DBASE=$1 || DBASE='testadministratie'

BASEDIR=/pub/webs/openadmin

sqlite3 $BASEDIR/data/$DBASE.db3
