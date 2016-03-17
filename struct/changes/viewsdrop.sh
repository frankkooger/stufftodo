# maakt een drop views file out of een views file
#
# postgres versie
# view: 
#tac views.sql | grep 'CREATE' | sed -e 's|CREATE OR REPLACE|DROP|' -e 's| A[Ss]|;|' 
# write:
tac views-postgres.sql | grep 'CREATE' | sed -e 's|CREATE OR REPLACE|DROP|' -e 's| A[Ss]|;|' > viewsdrop-postgres.sql

# firebird versie
# view: 
#tac views-firebird.sql | grep 'CREATE' | sed -e 's|CREATE|DROP|' -e 's| A[Ss]|;COMMIT;|' 
# write:
tac views-firebird.sql | grep 'CREATE' | sed -e 's|CREATE|DROP|' -e 's|\(.*\)|\1;COMMIT;|' > viewsdrop-firebird.sql

# mysql versie
# view: 
#tac views-mysql.sql | grep 'CREATE' | sed -e 's|CREATE OR REPLACE|DROP|' -e 's| A[Ss]|;|' 
# write:
echo "Set SESSION sql_mode='ANSI';" > viewsdrop-mysql.sql
tac views-mysql.sql | grep 'CREATE' | sed -e 's|CREATE OR REPLACE|DROP|' -e 's| A[Ss]|;|' > viewsdrop-mysql.sql

# mssql versie
# view: 
#tac views-mssql.sql | grep 'CREATE' | sed -e 's|CREATE OR REPLACE|DROP|' -e 's| A[Ss]|;|' 
# write:
tac views-mssql.sql | grep 'CREATE' | sed -e 's|CREATE|DROP|' -e 's| A[Ss]|\nGO|' > viewsdrop-mssql.sql

# sqlite versie is gelijk aan de postgresql versie en voor sqlite2 en 3 gelijk
tac views-sqlite2.sql | grep 'CREATE' | sed -e 's|CREATE|DROP|' -e 's| A[Ss]|;|' > viewsdrop-sqlite.sql

