#!/bin/sh
#
# drop tables, views, indexes
# LET OP: voor drop tables eerst views droppen met :
#
# isql-fb -u SYSDBA -p OpenAdmin.nl -i viewsdrop_firebird.sql  $BASEDIR/data/$DBASE.fdb
#

# test -n "$1" && DBASE=$1 || DBASE='testadministratie'
DBASE='administratiekk4'

USER=SYSDBA
PWD=OpenAdmin.nl
BASEDIR=/pub/webs/openadmin

test -f "x0" && unlink x0
test -f "x1" && unlink x1

echo "SET HEADING;SELECT RDB\$RELATION_NAME FROM RDB\$RELATIONS WHERE RDB\$RELATION_NAME NOT LIKE '%$%';" | isql-fb -u SYSDBA -p OpenAdmin.nl $BASEDIR/data/$DBASE.fdb > x0

echo 'DROP DOMAIN "SIGNED";' > x1
for i in $(cat x0); do echo "DROP TABLE \"$i\" ;" >>x1 ; done
echo 'COMMIT;' >>x1

isql-fb -u SYSDBA -p OpenAdmin.nl -i x1 $BASEDIR/data/$DBASE.fdb

test -f "x0" && unlink x0
