rem stop the service
NET STOP Mysql

rem wacht even
sleep 3

rem de-install service mysqld
c:\openadmin\mysql\bin\mysqld.exe --remove

