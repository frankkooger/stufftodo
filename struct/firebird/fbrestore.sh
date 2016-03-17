#!/bin/bash
#
# syntax:  ./fbrestore.sh <backupfile>
#
# Restore the database from a backupfile

# Shutdown the database
#
# gfix -shut full -attach 0 ./administratie.fdb -USER SYSDBA -PASSWORD OpenAdmin.nl

# Doe een restore
#
# ongezipte bupfile:
#
#gbak  -USER SYSDBA -PASSWORD OpenAdmin.nl -recreate overwrite $1 ./administratie.fdb
#
# gezipte bupfile:
#
cat $1 | gzip -d | gbak -USER SYSDBA -PASSWORD OpenAdmin.nl -recreate overwrite  stdin /pub/webs/openadministratie/dbase/administratie.fdb

