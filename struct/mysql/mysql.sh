#!/bin/sh
#

test -n "$1" && DBASE=$1 || DBASE='testadministratie'

#USER=-uwebuser
#PWD=-ppoedel
USER=-uroot
PWD=
BASEDIR=/pub/webs/openadministratie

mysql $USER $PWD $DBASE
