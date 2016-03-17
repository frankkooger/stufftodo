#!/bin/bash

### command as executed from openadmin to preform a backup
###
pg_dump --inserts -C -c -h localhost administratiekk | gzip > /pub/webs/administratie/data/_administratiekk.postgres.sserver02.20141211-1051.sql.gz
