
#cat views.sql | grep CREATE | awk '{ print $5 }' | sed -n -e 's/"//g' -e 's/\(.*\)/ALTER TABLE \1 OWNER TO "www";/p' > viewsalter.sql
cat views-postgres.sql | grep "CREATE OR" | awk '{ print $5 }' | sed -n -e 's/\(.*\)/ALTER TABLE \1 OWNER TO "www";/p' > viewsalter-postgres.sql
