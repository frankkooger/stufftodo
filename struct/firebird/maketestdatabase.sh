#!/bin/sh
#
# Deze procedure maakt database sqlversie 1.11.0
#

test -n "$1" && DBASE=$1 || DBASE='testadministratie'

USER=SYSDBA
PWD=OpenAdmin.nl
USER=webuser
PWD=poedel
# De fireburd user (normaal 'firebird') moet schrijfrechten hebben in de datadir
BASEDIR=/pub/webs/openadmin
DATADIR=$BASEDIR/data
VERSION=1-11-0

openadmin() {
  local BIN=isql-fb
  echo 'CREATE DATABASE "'$DATADIR'/'$DBASE'.fdb";' | $BASEDIR/bin/isql -u $USER -p $PWD
  cat $DBASE.struct.firebird.$VERSION.sql | $BASEDIR/bin/isql -u $USER -p $PWD $DATADIR/$DBASE.fdb
  cat $DBASE.vulling.firebird.$VERSION.sql | $BASEDIR/bin/isql -u $USER -p $PWD $DATADIR/$DBASE.fdb
}

Mint9() {
  local BIN=/usr/bin/isql-fb
  echo 'CREATE DATABASE "'$DATADIR'/'$DBASE'.fdb";' | $BIN -u $USER -p $PWD
  cat $DBASE.struct.firebird.$VERSION.sql | $BIN -u $USER -p $PWD $DATADIR/$DBASE.fdb
  cat $DBASE.vulling.firebird.$VERSION.sql | $BIN -u $USER -p $PWD $DATADIR/$DBASE.fdb
}

# execute
Mint9

