#!/bin/bash

test -n "$1" && DBASE=$1 || DBASE='administratiekk'

DATE=`date '+%Y%m%d'`
PGUSER=system
PGPASSWORD=poedel21
export PGUSER PGPASSWORD 

##### routines voor dump postgresdatabase
#####   pgdump.sh "-U webuser -W administratiekk"

### -C, --create
###    Begin the output with a command to create the database itself and
###    reconnect to the created database. (With a script of this form, it doesn't
###    matter which database you connect to before running the script.)
###    If --clean is also specified, the script drops and recreates the target
###    database before reconnecting to it.
### 
###    This option is only meaningful for the plain-text format. For the archive
###    formats, you can specify the option when you call pg_restore.

### -c, --clean
###    Output commands to clean (drop) database objects prior to outputting the
###    commands for creating them. (Restore might generate some harmless error
###    messages, if any objects were not present in the destination database.)
###
###    This option is only meaningful for the plain-text format. For the
###    archive formats, you can specify the option when you call pg_restore.
###    If --clean is used without --create all individual objects in the database will
###    be dropped which isn't ofcourse the matter with --create

### --inserts
###    Dump data as INSERT commands (rather than COPY). This will make restoration
###    very slow; it is mainly useful for making dumps that can be loaded into
###    non-PostgreSQL databases. Also, since this option generates a separate
###    command for each row, an error in reloading a row causes only that row to
###    be lost rather than the entire table contents. Note that the restore might
###    fail altogether if you have rearranged column order. The --column-inserts
###    option is safe against column order changes, though even slower.

### --column-inserts, --attribute-inserts
###    Dump data as INSERT commands with explicit column names (INSERT INTO
###    table (column, ...) VALUES ...). This will make restoration very
###    slow; it is mainly useful for making dumps that can be loaded into
###    non-PostgreSQL databases. Also, since this option generates a separate
###    command for each row, an error in reloading a row causes only that row
###    to be lost rather than the entire table contents.


### dump in asci formaat (default), geen data
### second form: begin the script with clean-objects commands

# pg_dump --file=_schema.$DATE.sql --schema=public --schema-only $DBASE
# pg_dump --file=_schema.$DATE.sql --schema=public --schema-only --clean $DBASE
 pg_dump -O -x --file=_schema.$DATE.sql --schema=public --schema-only --create --clean $DBASE


### dump in asci formaat (default), data only in copy-format
### second and third form: in sql-inserts, first form: in copy format

# pg_dump --file=_data.$DATE.sql --schema=public --data-only $DBASE
 pg_dump -O -x --file=_data.$DATE.sql --schema=public --data-only --inserts $DBASE
# pg_dump --file=_data.$DATE.sql --schema=public --data-only --inserts --column-inserts $DBASE


### dump in asci formaat (default), data in copy format

# pg_dump --file=_out.$DATE.sql --schema=public $DBASE


### dump in asci formaat (default), data in uitgebreid sql-insert format

# pg_dump --file=_out.$DATE.sql --schema=public --attribute-inserts $DBASE


### dump in asci formaat (default), data in sql-insert format

#pg_dump --file=_out.$DATE.sql --schema=public --inserts $DBASE
