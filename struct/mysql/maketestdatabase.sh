#!/bin/sh
#
# drop tables, views, indexes

test -n "$1" && DBASE=$1 || DBASE='testadministratie'

#USER=-uwebuser
#PWD=-ppoedel
USER=-uroot
PWD=
BASEDIR=/pub/webs/openadmin

test -f "x0"  && unlink x0
test -f "x1"  && unlink x1

mysqladmin $USER $PWD create $DBASE

echo "show tables from $DBASE;" | mysql $USER $PWD > x0

for i in $(cat x0); do echo "DROP TABLE \`$i\` ;" >>x1 ; done
# for i in $(cat x0); do echo "drop index \"$i\" ;" >>x1 ; done
# for i in $(cat x0); do echo "drop view IF EXISTS \`$i\` ;" >>x1 ; done

test -f "x1"  && cat x1 | mysql $USER $PWD $DBASE

test -f "x0"  && unlink x0

cat testadmin.mysql.sql | mysql $USER $PWD $DBASE

