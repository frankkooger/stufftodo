#!/bin/bash
#

#test -n "$1" && DBASE=$1 || DBASE='administratiekk'
test -n "$1" && DBASE=$1 || DBASE='template1'

PGUSER=system
PGPASSWORD=poedel21
#PGUSER=webuser
#PGPASSWORD=poedel
export PGUSER PGPASSWORD

psql -h localhost -p 5432 $DBASE
# default port is 5432

