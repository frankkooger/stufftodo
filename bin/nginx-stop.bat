@echo off

rem stop het nginx webserver proces. stop eerst php-cgi

tskill php-cgi

rem stop nginx netjes

START /D C:\openadmin\nginx C:\openadmin\nginx\nginx.exe -s stop

rem zeker weten dat alle nginx processen zijn gekilled

tskill nginx

rem wacht 1 seconden tot de webserver heeft kunnen stoppen

sleep 1
